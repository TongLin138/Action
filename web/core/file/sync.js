const fs = require("fs");
const _path = require("path");
const curd = require("../cron/curd");
const cronCore = require("../cron/core");
const scriptResolve = require("./scriptResolve");

/**
 * @type {{
 *     [string]:{
 *         beforeSync?:((path:string,params:{})=>Promise<void>),
 *         doSync:((path:string,params:{})=>Promise<{
 *             updateFiles?:string[],
 *         }>),
 *         afterSync?:((path:string,params:{})=>Promise<void>),
 *         cleanSync?:((path:string,params:{})=>void),
 *     }
 * }}
 */
const types = {
    "git": {
        doSync: require("./syncMethod/git").doSync
    },
    "raw": {
        doSync: require("./syncMethod/raw").doSync
    },
}

/**
 *
 * @param type
 * @param {{
 *         beforeSync?:((path:string,params:{})=>Promise<void>),
 *         doSync:((path:string,params:{})=>Promise<{
 *             updateFiles?:string[],
 *         }>),
 *         afterSync?:((path:string,params:{})=>Promise<void>),
 *         cleanSync?:((path:string,params:{})=>void),
 *        }} handler
 */
function registerSync(type, handler) {
    types[type] = handler;
}


function checkRuntimeDir() {
    let dir = _path.resolve("/tmp/arcadia_server/sync/");
    if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir, {recursive: true});
    }
}

function saveInfo(name, info) {
    checkRuntimeDir()
    fs.writeFileSync(_path.resolve("/tmp/arcadia_server/sync/", name.replaceAll("/", "$$") + ".json"), JSON.stringify(info))
}

function cleanInfo(name) {
    try {
        checkRuntimeDir()
        fs.unlinkSync(_path.resolve("/tmp/arcadia_server/sync/", name.replaceAll("/", "$$") + ".json"))
    } catch {
    }
}

function getInfo(name) {
    try {
        checkRuntimeDir()
        return JSON.parse(fs.readFileSync(_path.resolve("/tmp/arcadia_server/sync/", name.replaceAll("/", "$$") + ".json"), "utf-8"))
    } catch (e) {
        return null;
    }
}


/**
 * 同步开始同步文件
 * @param type 类型:git,svn等,需要预先注册
 * @param path 同步的目录
 * @param params
 * @param callback
 */
async function startSync(type, path, params = {}, callback) {
    if (!types[type]) {
        throw new Error("未注册的同步类型:" + type);
    }
    let handler = types[type];
    handler.beforeSync && await handler.beforeSync(path, params)
    //如果有缓存,则上次同步失败,不要更新历史
    if (!getInfo(path)) {
        let oldFiles = readFilesRecursion(path);
        saveInfo(path, {
            files: oldFiles
        })
    }
    //执行同步
    let {updateFiles} = await handler.doSync(path, params);
    await handler.afterSync && await handler.afterSync(path, params)
    //同步后工作,更新定时任务列表
    await updateTasks(type, path, updateFiles);
    //清理历史
    cleanInfo(path);
    //同步回调
    callback && await callback()
    //异步清理资源
    handler.cleanSync && setTimeout(() => handler.cleanSync(path, params));
}

/**
 * @typedef {{name:string,child:Info[],isDir:boolean}} Info
 */

/**
 * 递归读取文件夹
 * @param path 文件夹路径
 * @param recursion 当前递归深度,无需传递
 * @return {Info[]}
 */
function readFilesRecursion(path, recursion = 0) {
    if (recursion > 5) {
        return []
    }
    /**
     * @type Info[]
     */
    let dir = []
    let files = fs.readdirSync(_path.resolve(path), {withFileTypes: true});
    files.forEach(file => {
        if (file.isDirectory()) {
            dir.push({
                name: file.name,
                child: readFilesRecursion(_path.resolve(path, file.name), recursion + 1),
                isDir: true
            })
        } else {
            dir.push({
                name: file.name,
                child: [],
                isDir: false
            })
        }
    })
    return dir
}


async function updateTasks(type, path, updateFiles) {
    let oldFiles = getInfo(path).files;
    let newFiles = readFilesRecursion(path);
    let diffFiles = diffFilesRecursion(oldFiles, newFiles);

    function toBind(s) {
        return type + "#" + s.substring(0, s.indexOf("/")) + "#" + s.substring(s.indexOf("/") + 1);
    }

    //1.删除定时任务
    if (diffFiles.delete.length > 0) {
        //查询需要删除的定时任务
        let deleteTasks = await curd.list(
            {}
            , null, (o, sql, p) => {
                p.push(...diffFiles.delete.map(s => toBind(s)))
                return `bind in (${diffFiles.delete.map(_ => "?").join(",")})`
            }
        )
        await curd.deleteCustomize(
            `bind in (${diffFiles.delete.map(_ => "?").join(",")})`,
            diffFiles.delete.map(s => toBind(s))
        )
        for (const task of deleteTasks) {
            await curd.fixCron(task.id);
        }
    }
    //2.新增定时任务
    //2.1,循环新增的文件,并解析文件
    let tasks = [];
    for (let file of diffFiles.add) {
        let task = await scriptResolve(file);
        if (task) {
            tasks.push(task);
        }
    }
    //2.2,批量插入定时任务
    for (const task of tasks) {
        //可优化,一次性插入效果更好
        let t = {
            name: task.name,
            type: "user",
            cron: task.cron,
            shell: `task run ${task.runPath}`,
            active: 1,
            config: "",
            tags: "",
            creat_time: new Date(),
            bind: toBind(task.path),
        };
        await curd.save(t);
        await curd.fixCron(t.id)
    }
    return [];
}

/**
 * 递归比较文件列表,返回新增和删除的文件列表
 * @param oldFiles
 * @param newFiles
 * @return {{add: *[], delete: *[]}}
 */
function diffFilesRecursion(oldFiles, newFiles) {
    let tasks = {
        delete: [],
        add: [],
    }

    //合并并去重新旧文件列表
    let files = oldFiles.concat(newFiles).filter((file, index, self) => {    //合并数组
        return self.findIndex(t => t.name === file.name) === index;
    });
    // 遍历所有文件列表,查找删除的文件
    files.forEach(file => {
        // 查找新文件列表中是否存在该文件
        const newFile = newFiles.find(file => file.name === file.name);
        // 查找旧文件列表中是否存在该文件
        const oldFile = oldFiles.find(file => file.name === file.name);

        // 如果旧文件列表中不存在该文件,则说明是新增文件
        if (!oldFile && newFile) {
            //如果是文件,则直接添加到新增列表
            if (!file.isDir) {
                tasks.add.push(file.name);
            } else {
                // 如果是目录,则递归查找新增的子文件
                const childDiff = diffFilesRecursion([], file.child);
                tasks.add.push(...childDiff.add.map(name => file.name + "/" + name));
            }
        } else
            // 说明是删除文件
        if (!newFile && oldFile) {
            if (!file.isDir) {
                tasks.delete.push(file.name);
            } else {
                // 如果删除的是目录,则携带父目录添加旧文件的所有文件到删除列表
                file.child.forEach(file => {
                    tasks.delete.push(file.name + "/" + file.name);
                })
            }
        } else {
            //2者都有
            // 如果是旧文件是目录,新文件为文件,则递归添加旧文件的所有文件到删除列表
            if (oldFile.isDir && !newFile.isDir) {
                file.child.forEach(file => {
                    tasks.delete.push(file.name + "/" + file.name);
                })
                tasks.add.push(file.name);
            } else if (!oldFile.isDir && newFile.isDir) {
                // 如果是旧文件是文件,新文件为目录,则递归添加新文件的所有文件到新增列表
                const childDiff = diffFilesRecursion([], file.child);
                tasks.delete.push(file.name);
                tasks.add.push(...childDiff.add.map(name => file.name + "/" + name));
            } else if (oldFile.isDir && newFile.isDir) {
                // 如果都是目录,则递归比较子文件列表
                const childDiff = diffFilesRecursion(oldFile.child, newFile.child);
                tasks.add.push(...childDiff.add.map(name => file.name + "/" + name));
                tasks.delete.push(...childDiff.delete.map(name => file.name + "/" + name));
            }
        }
    })
    return tasks;
}

exports.startSync=startSync