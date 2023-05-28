let path = require('path');
let fs = require('fs');
const archiver = require('archiver');

let rootPath = path.resolve(__dirname, '../../../');
const DIR_NAME = {
    ROOT: "arcadia",
    CONFIG: "config",
    SAMPLE: "sample",
    SCRIPTS: "scripts",
    LOG: "log",
    REPO: "repo",
    RAW: "raw",
    BAK: "config/bak"
}
const DIR_KEY = {
    ROOT: DIR_NAME.ROOT + "/",
    CONFIG: DIR_NAME.CONFIG + "/",
    SAMPLE: DIR_NAME.SAMPLE + "/",
    SCRIPTS: DIR_NAME.SCRIPTS + "/",
    LOG: DIR_NAME.LOG + "/",
    REPO: DIR_NAME.REPO + "/",
    RAW: DIR_NAME.RAW + "/",
    BAK: DIR_NAME.BAK + "/"
}

// 日志目录
let logPath = path.join(rootPath, DIR_KEY.LOG);
// 脚本目录
let scriptsPath = path.join(rootPath, DIR_KEY.SCRIPTS);
// repo目录
let repoPath = path.join(rootPath, DIR_KEY.REPO);
//config 目录
let configPath = path.join(rootPath, DIR_KEY.CONFIG);
//sample目录
let samplePath = path.join(rootPath, DIR_KEY.SAMPLE);
if (!fs.existsSync(scriptsPath)) {
    fs.mkdirSync(scriptsPath);
}
if (!fs.existsSync(repoPath)) {
    fs.mkdirSync(repoPath);
}
// config.sh 文件所在目录
let configFile = path.join(configPath, 'config.sh');

// crontab.list 文件所在目录
let crontabFile = path.join(configPath, 'crontab.list');
// config.sh 文件备份目录
let confBakDir = path.join(rootPath, DIR_KEY.BAK);
// auth.json 文件目录
let authConfigFile = path.join(configPath, 'auth.json');
// account.json 文件目录
let accountFile = path.join(configPath, 'account.json');
// bot.json 文件所在目录
let botFile = path.join(configPath, 'bot.json');
// extra.sh 文件目录
let extraFile = path.join(configPath, 'extra.sh');
// extra_server.js 文件目录
let extraServerFile = path.join(configPath, 'extra_server.js');

// config.sh 文件所在目录
let sampleFile = path.join(samplePath, 'config.sh');

let os = require('os');

let {
    execSync
} = require('child_process');
const {arrayObjectSort, parseFileNameDate} = require("../../utils");
const {API_STATUS_CODE} = require("../http/apiCode");
const {logger} = require("../logger");


const CONFIG_FILE_KEY = {
    CONFIG: "config",
    SAMPLE: "sample",
    CRONTAB: "crontab",
    EXTRA: "extra",
    BOT: "bot",
    ACCOUNT: "account",
    AUTH: "auth"
}
/**
 * 解析参数
 * @param options
 * @return {{excludeRegExp: RegExp, keywords: string, startTime: string, endTime: string, isDir: boolean}}
 */
const getOptions = (options) => {
    let excludeRegExp = /(.git)|(.tmp)|(.check)|(node_modules)|(auth.json)|(crontab.list)|(crontab.sample.list)/;
    let keywords = "";
    //用于日志查询
    let startTime = "";
    let endTime = "";
    let isDir = false;
    if (typeof options === 'string') {
        keywords = options;
    }
    if (typeof options === 'object') {
        keywords = options['keywords'] || "";
        if (options.type && options.type === "log") {
            startTime = options['startTime'] || "";
            endTime = options['endTime'] || "";
        }
        isDir = options['isDir'] || false;
    }
    return {keywords, startTime, endTime, isDir, excludeRegExp, type: options.type};
}
/**
 * 根据目录返回目录下的文件夹和文件
 * @param dir
 * @param query
 */
const getDirectory = (dir, query) => {
    if (!fs.existsSync(dir)) {
        throw new Error(`目录 ${dir} 不存在`);
    }
    let parentDir = dir;
    let options = getOptions(query);
    let files = fs.readdirSync(dir);
    let result = { //构造文件夹数据
        path: dir,
        title: path.basename(dir),
        type: 0
    }
    result.children = arrayObjectSort("type", files.filter(item => {
        let subPath = path.join(dir, item)
        let stats = fs.statSync(subPath);
        if (options.isDir && !stats.isDirectory()) {
            //非文件夹
            return false;
        }
        return !options.excludeRegExp.test(item)
    }).map(function (file) {
        let subPath = path.join(dir, file)
        let stats = fs.statSync(subPath)
        return {
            path: subPath,
            name: file,
            type: stats.isDirectory() ? 0 : 1
        }
    }).filter((item) => {
        return dirQueryAfter(parentDir, item, options)
    }), true)
    return result //返回数据
}

const dirQueryAfter = (parentDir, item, options) => {
    let {keywords, startTime, endTime, isDir} = options;
    if (item.type === 1 && isDir) {
        return false
    }
    if (item.type === 0) {
        return true
    }
    let path = item.path.replace(parentDir, "");
    let name = item.name;
    if (options.type && options.type !== "log") {
        return keywords === '' || (path.indexOf(keywords) > -1);
    }

    //只有日志才匹配时间
    return (keywords === '' || (path.indexOf(keywords) > -1))
        && (startTime === '' || fileNameTimeCompare(name, startTime) > -1)
        && (endTime === '' || fileNameTimeCompare(name, endTime) < 1)
}

/**
 * 目录数
 * @param type 类型 all、config、repo、scripts、repo_scripts、sample、log、dirs
 * @param dir
 * @param query 参数
 * @returns {*[]}
 */
const getDirTree = (type, dir, query) => {
    let filesNameArr = []
    if (!fs.existsSync(dir)) {
        return filesNameArr
    }
    let parentDir = dir;
    let options = getOptions(query);

    // 用个hash队列保存每个目录的深度
    let mapDeep = {}
    mapDeep[dir] = 0
    // 先遍历一遍给其建立深度索引
    const getMap = (dir, curIndex) => {
        let files = fs.readdirSync(dir) //同步拿到文件目录下的所有文件名
        files.forEach((file) => {
            let subPath = path.join(dir, file)
            let stats = fs.statSync(subPath)
            if (file !== 'node_modules' && !options.excludeRegExp.test(file)) {
                mapDeep[file] = curIndex + 1
                if (stats.isDirectory()) { //判断是否为文件夹类型
                    return getMap(subPath, mapDeep[file]) //递归读取文件夹
                }
            }
        })
    }

    getMap(dir, mapDeep[dir])

    const readDirs = (dir, folderName) => {
        let result = { //构造文件夹数据
            path: dir,
            title: path.basename(dir),
            type: 0,
            deep: mapDeep[folderName]
        }

        let files = fs.readdirSync(dir)
        result.children = arrayObjectSort("type", files.filter(item => {
            return !options.excludeRegExp.test(item)
        }).map(function (file) {
            let subPath = path.join(dir, file)
            let stats = fs.statSync(subPath)
            if (stats.isDirectory()) {
                return readDirs(subPath, file)
            }
            return {
                path: subPath,
                name: file,
                type: 1
            }
        }).filter((item) => {
            return dirQueryAfter(parentDir, item, options);
        }), true)
        return result //返回数据
    }
    if (type === "repo_scripts" || type === "all") {
        if (type === "all") {
            filesNameArr.push(readDirs(dir + "/" + DIR_NAME.CONFIG, dir + "/" + DIR_NAME.CONFIG))
            filesNameArr.push(readDirs(dir + "/" + DIR_NAME.SAMPLE, dir + "/" + DIR_NAME.SAMPLE))
        }
        filesNameArr.push(readDirs(dir + "/" + DIR_NAME.SCRIPTS, dir + "/" + DIR_NAME.SCRIPTS))
        filesNameArr.push(readDirs(dir + "/" + DIR_NAME.REPO, dir + "/" + DIR_NAME.REPO))
    } else {
        filesNameArr.push(readDirs(dir, dir))
    }

    return filesNameArr
}

/**
 * 文件名称进行时间对比
 * @param fileName 文件名称 yyyy-MM-dd-HH-mm-ss
 * @param time 时间 yyyy-MM-dd hh:mm:ss
 * @return 正数数则 fileName 的时间大 反之则time的时间大
 */
function fileNameTimeCompare(fileName, time) {
    try {
        let fileTime = parseFileNameDate(fileName);
        let dateTime = new Date(time)
        return fileTime.getTime() - dateTime.getTime();
    } catch (e) {
        return 0
    }

}


/**
 * 检查 config/bak/ 备份目录是否存在，不存在则创建
 */
function mkdirConfigBakDir() {
    if (!fs.existsSync(confBakDir)) {
        fs.mkdirSync(confBakDir);
    }
}

// 去除文件内容中无法正常渲染的引导非常规字符序列（\033）
function getNeatContent(origin) {
    return (origin || '').replace(/\033\[0m/g, '')
        .replace(/\033\[1m/g, '')
        .replace(/\033\[31m/g, '')
        .replace(/\033\[32m/g, '')
        .replace(/\033\[33m/g, '')
        .replace(/\033\[34m/g, '')
        .replace(/\033\[35m/g, '')
        .replace(/\033\[36m/g, '')
        .replace(/\033\[1;31m/g, '')
        .replace(/\033\[1;32m/g, '')
        .replace(/\033\[1;33m/g, '')
        .replace(/\033\[1;34m/g, '')
        .replace(/\033\[1;35m/g, '')
        .replace(/\033\[1;36m/g, '');
}

/**
 * 检查 config.sh 以及 config.sample.sh 文件是否存在
 */
function checkConfigFile() {
    if (!fs.existsSync(configFile)) {
        console.error(rootPath);
        console.error('脚本启动失败，config.sh 文件不存在！');
        process.exit(1);
    }
    if (!fs.existsSync(sampleFile)) {
        console.error('脚本启动失败，config.sample.sh 文件不存在！');
        process.exit(1);
    }
}

/**
 * 备份 config.sh 文件 并返回旧的文件内容
 */
function bakConfigFile(file) {
    mkdirConfigBakDir();
    let date = new Date();
    let bakConfigFile =
        confBakDir +
        file +
        '_' +
        date.getFullYear() +
        '-' +
        (date.getMonth() + 1) +
        '-' +
        date.getDate() +
        '-' +
        date.getHours() +
        '-' +
        date.getMinutes() +
        '-' +
        date.getMilliseconds();
    let oldConfContent = '';
    switch (file) {
        case CONFIG_FILE_KEY.CONFIG:
            oldConfContent = getFileContentByName(configFile);
            fs.writeFileSync(bakConfigFile, oldConfContent);
            break;
        case CONFIG_FILE_KEY.CRONTAB:
            oldConfContent = getFileContentByName(crontabFile);
            fs.writeFileSync(bakConfigFile, oldConfContent);
            break;
        case CONFIG_FILE_KEY.EXTRA:
            oldConfContent = getFileContentByName(extraFile);
            fs.writeFileSync(bakConfigFile, oldConfContent);
            break;
        case CONFIG_FILE_KEY.BOT:
            oldConfContent = getFileContentByName(botFile);
            fs.writeFileSync(bakConfigFile, oldConfContent);
            break;
        case CONFIG_FILE_KEY.ACCOUNT:
            oldConfContent = getFileContentByName(accountFile);
            fs.writeFileSync(bakConfigFile, oldConfContent);
            break;
        default:
            break;
    }
    return oldConfContent;
}

function checkConfigSave(content) {
    if (os.type() === 'Linux') {
        //判断格式是否正确
        try {
            execSync(`bash ${configFile} >${logPath}.check`, {encoding: 'utf8'});
        } catch (e) {
            let errorMsg, line;
            try {
                errorMsg = /(?<=line\s[0-9]*:)([^"]+)/.exec(e.message)[0];
                line = /(?<=line\s)[0-9]*/.exec(e.message)[0]
            } catch (e) {
            }
            throw new Error(errorMsg && line ? `第 ${line} 行:${errorMsg}` : e.message);
        }
    }
    fs.writeFileSync(configFile, content);

}

/**
 * 将 post 提交内容写入 config.sh 文件（同时备份旧的 config.sh 文件到 bak 目录）
 * @param file
 * @param content
 * @param isBak 是否备份 默认为true
 */
function saveNewConf(file, content, isBak = true) {
    let oldContent = isBak ? bakConfigFile(file) : "";
    switch (file) {
        case CONFIG_FILE_KEY.CONFIG:
        case 'config.sh':
            checkConfigSave(content);
            break;
        case CONFIG_FILE_KEY.CRONTAB:
        case 'crontab.list':
            fs.writeFileSync(crontabFile, content);
            execSync('crontab ' + crontabFile);
            break;
        case CONFIG_FILE_KEY.EXTRA:
        case 'extra.sh':
            fs.writeFileSync(extraFile, content);
            break;
        case CONFIG_FILE_KEY.AUTH:
        case 'auth.json':
            fs.writeFileSync(authConfigFile, JSON.stringify(content, null, 2));
            break;
        case CONFIG_FILE_KEY.BOT:
        case 'bot.json':
            fs.writeFileSync(botFile, content);
            break;
        case CONFIG_FILE_KEY.ACCOUNT:
        case 'account.json':
            fs.writeFileSync(accountFile, JSON.stringify(content, null, 2));
            break;
        default:
            break;
    }
}

/**
 * 获取文件内容
 * @param fileName 文件路径
 * @returns {string}
 */
function getFileContentByName(fileName) {
    if (fs.existsSync(fileName)) {
        return fs.readFileSync(fileName, 'utf8');
    }
    return '';
}

/**
 * 获取目录中最后修改的文件的路径
 * @param dir 目录路径
 * @returns {string} 最新文件路径
 */
function getLastModifyFilePath(dir) {
    let filePath = '';

    if (fs.existsSync(dir)) {
        let lastmtime = 0;

        let arr = fs.readdirSync(dir);

        arr.forEach(function (item) {
            let fullpath = path.join(dir, item);
            let stats = fs.statSync(fullpath);
            if (stats.isFile()) {
                if (stats.mtimeMs >= lastmtime) {
                    filePath = fullpath;
                }
            }
        });
    }
    return filePath;
}

/**
 * 获取文件内容
 * @param fileKey
 * @return string
 */
function getFile(fileKey) {
    let content = "";
    switch (fileKey) {
        case CONFIG_FILE_KEY.CONFIG:
            content = getFileContentByName(configFile);
            break;
        case CONFIG_FILE_KEY.SAMPLE:
            content = getFileContentByName(sampleFile);
            break;
        case CONFIG_FILE_KEY.CRONTAB:
            content = getFileContentByName(crontabFile);
            break;
        case CONFIG_FILE_KEY.EXTRA:
            content = getFileContentByName(extraFile);
            break;
        case CONFIG_FILE_KEY.AUTH:
            content = getFileContentByName(authConfigFile);
            break;
        case CONFIG_FILE_KEY.BOT:
            content = getFileContentByName(botFile);
            break;
        case CONFIG_FILE_KEY.ACCOUNT:
            content = getFileContentByName(accountFile);
            break;
        default:
            content = getFileContentByName(fileKey);
            break;
    }
    return content;
}

/**
 * 获取文件内容
 * @param fileKey
 * @return JSON
 */
function getJsonFile(fileKey) {
    return JSON.parse(getFile(fileKey))
}

/**
 * 获取配置文件
 * @param keywords
 * @returns {*[]}
 */
function loadConfigTree(keywords) {
    let fileList = fs.readdirSync(configPath, 'utf-8');
    let dirs = [], rootFiles = [];
    let excludeRegExp = /(.tmp)/;
    fileList.map((name, index) => {
        if ((keywords === '' || name.indexOf(keywords) > -1) && !excludeRegExp.test(name)) {
            let stat = fs.lstatSync(configPath + name);
            // 是目录，需要继续
            if (stat.isDirectory()) {
                let fileListTmp = fs.readdirSync(configPath + '/' + name, 'utf-8');
                fileListTmp.reverse();
                let dirMap = {
                    dirName: name,
                    files: fileListTmp,
                };
                dirs.push(dirMap);
            } else {
                rootFiles.push(name);
            }
        }
    })
    dirs.push({
        dirName: '@',
        files: rootFiles,
    });
    return dirs;
}

/**
 * 加载日志文件目录
 * @param keywords
 * @return {*[]}
 */
function loadLogTree(keywords) {
    let fileList = fs.readdirSync(logPath, 'utf-8');
    let dirs = [], rootFiles = [];
    let excludeRegExp = /(.tmp)/;
    fileList.map((name, index) => {
        if ((keywords === '' || name.indexOf(keywords) > -1) && !excludeRegExp.test(name)) {
            let stat = fs.lstatSync(logPath + name);
            // 是目录，需要继续
            if (stat.isDirectory()) {
                let fileListTmp = fs.readdirSync(logPath + '/' + name, 'utf-8');
                fileListTmp.reverse();
                let dirMap = {
                    dirName: name,
                    files: fileListTmp,
                };
                dirs.push(dirMap);
            } else {
                rootFiles.push(name);
            }
        }
    })
    dirs.push({
        dirName: '@',
        files: rootFiles,
    });
    return dirs;
}

function loadFileTree(loadPath, dirName, keywords, onlyRunJs) {
    let arrFiles = [], arrDirs = [];
    let excludeRegExp = /(.git)|(.github)|(node_modules)|(icon)/;
    let fileRegExp = /.*?/g;
    if (onlyRunJs) {
        excludeRegExp = /(.git)|(.github)|(node_modules)|(icon)|AGENTS|Cookie|cookie|Token|ShareCodes|sendNotify|JDJR|validate|ZooFaker|MovementFaker|tencentscf|api_test|app.|main.|jd_update.js|jd_env_copy.js|main.js|.json|ql.js|jdEnv|(.json)|(.jpg)|(.png)|(.gif)|(.jpeg)/
        fileRegExp = /(.js)|(.ts)|(.py)/
    }
    const files = fs.readdirSync(rootPath + "/" + loadPath, {withFileTypes: true})
    files.map((item, index) => {
        let name = item.name;
        let dirPath = loadPath + '/' + name;
        let filter = (!excludeRegExp.test(name) && fileRegExp.test(name)) && (keywords === '' || name.indexOf(keywords) > -1);
        if (filter || item.isDirectory()) {
            if (item.isDirectory()) {
                let dirPathFiles = loadFileTree(dirPath, name, keywords, onlyRunJs)
                if (filter || (keywords !== "" && dirPathFiles.length > 0)) {
                    if (onlyRunJs) {
                        arrFiles = arrFiles.concat(dirPathFiles)
                    } else {
                        arrDirs.push({
                            dirName: name,
                            dirPath: dirPath,
                            files: dirPathFiles,
                        })
                    }
                }
            } else if (!item.isDirectory()) {
                arrFiles.push({
                    fileName: name,
                    filePath: dirPath,
                })
            }
        }

    })
    return arrDirs.concat(arrFiles);
}

/**
 * 加载脚本文件
 * @param keywords 关键字
 * @param onlyRunJs 是否只返回可运行的脚本文件
 * @return {*[]}
 */
function loadScripts(keywords, onlyRunJs) {
    let rootFiles = [], scriptsDir = DIR_NAME.SCRIPTS, repoDir = DIR_NAME.REPO, dirList = [scriptsDir];
    if (!onlyRunJs) {
        dirList.push(repoDir);
    }
    dirList.forEach((dirName) => {
        rootFiles.push({
            dirName: dirName,
            dirPath: dirName,
            files: loadFileTree(dirName, dirName, keywords, onlyRunJs),
        })
    })
    if (onlyRunJs) {
        let repoFileList = fs.readdirSync(repoPath, {withFileTypes: true});
        repoFileList.forEach((item) => {
            let name = item.name;
            if (item.isDirectory()) {
                rootFiles.push({
                    dirName: name,
                    dirPath: repoDir + "/" + name,
                    files: loadFileTree(repoDir + "/" + name, name, keywords, onlyRunJs),
                })
            }
        })
    }
    return rootFiles;
}

/**
 * 保存文件
 * @param file
 * @param content
 *
 */
function saveFile(file, content) {
    fs.writeFileSync(path.join(rootPath, file), content);
}

/**
 * 保存文件
 * @param filePath
 * @param content
 *
 */
function saveFileByPath(filePath, content) {
    pathCheck(filePath)
    if (filePath === configFile) {
        saveNewConf(CONFIG_FILE_KEY.CONFIG, content, true)
        return;
    }
    if(filePath.endsWith(".js") || filePath.endsWith(".sh") || filePath.endsWith(".py") || filePath.endsWith(".ts")) {
        content = content.replace(/\r\n/g, '\n');
    }
    fs.writeFileSync(filePath, content);
}

/**
 * 目录参数检查
 * @param checkPath
 */
function rootPathCheck(checkPath) {
    if (!checkPath.startsWith(rootPath)) {
        throw new Error(`目录必须以${rootPath}开头`)
    }

}

/**
 * 目录参数检查
 * @param checkPath
 */
function pathCheck(checkPath) {
    rootPathCheck(checkPath)
    if (!fs.existsSync(checkPath)) {
        throw new Error(`文件(夹)不存在`)
    }
    if (authConfigFile === path.join(checkPath)) {
        throw new Error(`该文件无法进行操作`)
    }
}


/**
 * 文件（夹）命名
 * @param filePath 当前路径
 * @param name 名称
 */
function fileRename(filePath, name) {
    let parentPath = path.join(filePath, "../");
    fs.renameSync(filePath, path.join(parentPath, name));
}

/**
 * 删除指定目录下所有子文件
 * @param {*} path
 */
function emptyDir(path) {
    const files = fs.readdirSync(path);
    files.forEach(file => {
        const filePath = `${path}/${file}`;
        const stats = fs.statSync(filePath);
        if (stats.isDirectory()) {
            emptyDir(filePath);
        } else {
            fs.unlinkSync(filePath);
        }
    });
}

/**
 * 文件（夹）删除
 * @param filePath 当前路径
 */
function fileDelete(filePath) {
    let file = fs.statSync(filePath)
    if (file.isDirectory()) {
        emptyDir(filePath);
        fs.rmdirSync(filePath)
        return;
    }
    fs.unlinkSync(filePath);
}

/**
 * 文件（夹）移动
 * @param filePath 当前路径
 * @param newPath 目标路径
 */
function fileMove(filePath, newPath) {
    fs.renameSync(filePath, newPath);
}

/**
 * 文件下载
 * @param filePath
 * @param response
 */
function fileDownload(filePath, response) {
    let file = fs.statSync(filePath)
    let fileName = path.basename(filePath);
    if (file.isDirectory()) {
        let archive = archiver('zip', {});
        archive.on('error', function (err) {
            response.send(API_STATUS_CODE.fail(err.message));
        });
        archive.on('end', function () {
            logger.info('Archive wrote %d bytes', archive.pointer());
        });
        response.attachment(`${fileName}.zip`);

        archive.pipe(response);
        archive.directory(filePath, fileName);
        archive.finalize();
    } else {
        response.writeHead(200, {
            'Content-Type': 'application/octet-stream', //告诉浏览器这是一个二进制文件
            'Content-Disposition': 'attachment; filename=' + fileName, //告诉浏览器这是一个需要下载的文件
        });
        fs.createReadStream(filePath).pipe(response);
    }

}

/**
 * 文件创建
 * @param fileDir 路径
 * @param fileName 名称 含后缀
 * @param type 0 目录 1 文件
 * @param content 内容
 */
function fileCreate(fileDir, fileName, type, content = "") {
    if (!fs.existsSync(fileDir)) {
        fs.mkdirSync(fileDir);
    }
    let filePath = path.join(fileDir, fileName);
    if (fs.existsSync(filePath)) {
        throw new Error(`${fileDir}目录下已经含有${fileName}该文件（夹）`)
    }
    if (type === 0) {
        fs.mkdirSync(filePath)
    } else {
        fs.writeFileSync(filePath, content);
    }
    return filePath;
}

/**
 * 格式化文件大小
 * @param size
 */
function formatFileSize(size) {
    const units = ["B", "KB", "MB", "GB", "TB"];
    let i = 0;
    while (size >= 1024 && i < units.length - 1) {
        size /= 1024;
        i++;
    }
    return `${size.toFixed(2)} ${units[i]}`;
}

/**
 * 查看文件详情
 * @param filePath
 */
function fileInfo(filePath) {
    let stat = fs.statSync(filePath);
    return {
        fileSize: formatFileSize(stat.size),
        birthtime: stat.birthtime,
        atime: stat.atime,
        ctime: stat.ctime,
        mtime: stat.mtime,
        name: path.basename(filePath),
        path: path.join(filePath, "../").slice(0, -1),
        mode: (stat.mode & parseInt('777', 8)).toString(8)
    }
}

module.exports = {
    pathCheck,
    rootPathCheck,
    saveFileByPath,
    getDirTree,
    getDirectory,
    DIR_KEY,
    fileRename,
    fileDelete,
    fileDownload,
    fileMove,
    fileCreate,
    fileInfo,
    mkdirConfigBakDir,
    getNeatContent,
    checkConfigFile,
    bakConfigFile,
    saveFile,
    checkConfigSave,
    saveNewConf,
    getFileContentByName,
    getLastModifyFilePath,
    getFile,
    CONFIG_FILE_KEY,
    loadLogTree,
    loadFileTree,
    loadScripts,
    getJsonFile,
    rootPath,
    logPath,
    scriptsPath,
    configPath,
    samplePath,
    extraServerFile,
    configFile,
    confBakDir,
    crontabFile,
    authConfigFile,
    accountFile,
    botFile,
    extraFile,
    sampleFile,
}
