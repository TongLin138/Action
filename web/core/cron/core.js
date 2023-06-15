let engine = require('./engine');
// const db = require("../db");
const curd = require("./curd");
const taskRunner = require("../taskRunner");
const eventBus = require("../eventBus").task;

const template = require("../db/curdTemplate");
const {logger} = require("../logger");
const taskCoreCurd = template("task_core", {
    id: "", cron: "", callback: ""
}, "id", "");

// const TaskCoreType = taskCoreCurd.Type;

const running = {};

/**
 * 任务初始化
 */
function cronInit(){
    require("./dbInit");
    setTimeout(async () => {
        let tasks = await taskCoreCurd.list()
        logger.log(`定时任务初始化开始`)
        logger.log('任务总数', tasks.length)
        for (let task of tasks) {
            if (task.cron.split(" ").length < 5) {
                continue
            }
            try {
                engine.setTask(task.id, task.cron, () => onCron(task))
                logger.log('设置定时任务成功', task.id.split("T_")[1])
            } catch (e) {
                logger.log('设置定时任务失败', task.id.split("T_")[1], task.cron, e.message || e)
            }
        }
        logger.log(`定时任务初始化结束`)
    }, 1000)
}



/**
 * 定时任务回调
 *
 * @param {{id: string, cron: string, callback: string}} task
 */
function onCron(task) {
    if (task.id.startsWith("T_") && task.callback === "") {
        onCronTask(parseInt(task.id.substring(2))).then(r => {
            // console.log("over", task.id)
        })
    }
    eventBus.emit(task.id, task)
    eventBus.emit("callback." + task.callback, task)
}


/**
 * tasks表回调
 *
 * @param {number} taskId
 */
async function onCronTask(taskId) {
    let task = await curd.getById(taskId);
    if (!task) {
        //todo:报错?
        await taskCoreCurd.deleteById(taskId) // 删除不存在的定时任务
        return
    }
    if (task.active <= 0) {
        logger.log("触发定时任务", task.shell, "（PASS，原因：已被禁用）")
        return
    }
    if (running[taskId]) {
        logger.log("触发定时任务", task.shell, "（PASS，原因：正在运行）")
        return
    }
    running[taskId] = task;
    let date = new Date();
    //fixme:需要其他操作,如指定日志等
    taskRunner.execShell(task.shell, {
        callback: (error, stdout, stderr) => {
            if (error) {
                // logger.log("定时任务运行完毕", task.shell, stdout.substring(stdout.length - 1000))
                // } else {
                logger.warn("定时任务异常", task.shell, error.toString().substring(stdout.length - 1000))
            }
        },
        onExit: (code) => {
            delete running[taskId]
            curd.updateById({
                id: taskId,
                last_runtime: date,
                last_run_use: (new Date().getTime() - date.getTime()) / 1000
            }).catch(e => {
            })
        }
    })

}

module.exports = {
    cronInit,
    /**
     * 运行中的任务
     */
    running,
    /**
     * 系统核心定时任务
     *
     * @param {string} id
     * @param {string} cron
     * @param {string} callback
     */
    setTaskCore: async (id, cron, callback) => {
        let change = await taskCoreCurd.updateById({id, cron, callback});
        if (!change) {
            await taskCoreCurd.save({id, cron, callback})
        }
        engine.setTask(id, cron, () => onCron({
            id: id, cron: cron, callback: ""
        }))
    },
    /**
     * @param {typeof import('./curd').Type} task
     */
    setTaskJob: async (task) => {
        return module.exports.setTaskCore("T_" + task.id, task.cron, "")
    },
    /**
     * @param {number} taskId
     */
    deleteTaskJob: async (taskId) => {
        const id = "T_" + taskId;
        await taskCoreCurd.deleteById(id)
        engine.removeTask(id)
    }
}