require("./dbInit")

let engine = require('./engine');
const db = require("../db");
const curd = require("./curd");
const taskRunner = require("../taskRunner");
const eventBus = require("../eventBus").task;

const template = require("../db/curdTemplate");
const {logger} = require("../logger");
const taskCoreCurd = template("task_core", {
    id: "", cron: "", callback: ""
}, "id", "");

const TaskCoreType = taskCoreCurd.Type;

const running = {};

setTimeout(async () => {
    let tasks = await taskCoreCurd.list()
    for (let task of tasks) {
        if (task.cron.split(" ").length < 5) {
            console.error("cron表达式错误", task)
            continue
        }
        engine.setTask(task.id, task.cron, () => onCron(task))
    }
}, 100)

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
        return
    }
    running[taskId] = task;
    //fixme:需要其他操作,如指定日志等
    taskRunner.execShell(task.shell, {
        callback: (error, stdout, stderr) => {
            if (error) {
                logger.log("task over", taskId, stdout.substring(stdout.length - 1000))
            } else {
                logger.warn("task error", taskId, error.substring(stdout.length - 1000))
            }
        },
        onExit: (code) => {
            delete running[taskId]
        }
    })

}

module.exports = {
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
        await taskCoreCurd.save({id, cron, callback})
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