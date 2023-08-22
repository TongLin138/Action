let engine = require('./engine')
// const db = require("../db");
const curd = require('./curd')
const taskRunner = require('../taskRunner')
const eventBus = require('../eventBus').task

const template = require('../db/curdTemplate')
const { logger } = require('../logger')
const taskCoreCurd = template(
    'task_core',
    {
        id: '',
        cron: '',
        callback: '',
    },
    'id',
    ''
)

// const TaskCoreType = taskCoreCurd.Type;

const running = {}

/**
 * 将定时字符串中的月份减一
 *
 * @param {string} cron 定时字符串
 * @returns {string} 减一后的定时字符串
 */
function decreaseMonth(cron) {
    let parts = cron.split(' ')
    let month = parts.length === 6 ? parts[4] : parts[3]
    if (month === '*') {
        // 如果月份为 *，则直接返回原字符串
        return cron
    }
    if (/\d/.test(month)) {
        // 如果月份包含数字，则将数字减一
        month = month
            .split(',')
            .map((m) => {
                if (m.includes('-')) {
                    // 如果月份是区间表达式，则将区间的两个数字都减一
                    let [start, end] = m.split('-')
                    return `${Math.max(Number(start) - 1, 0)}-${Math.max(Number(end) - 1, 0)}`
                } else {
                    // 如果月份是单一数字，则将数字减一
                    return String(Math.max(Number(m) - 1, 0))
                }
            })
            .join(',')
        if (parts.length === 6) {
            parts[4] = month
        } else {
            parts[3] = month
        }
    }
    return parts.join(' ')
}

/**
 * 任务初始化
 */
function cronInit() {
    require('./dbInit')
    setTimeout(async () => {
        let tasks = await taskCoreCurd.list()
        logger.log(`定时任务初始化开始`)
        // logger.log('任务总数', tasks.length)
        for (let task of tasks) {
            task.cron = task.cron.trim() // 去除首尾空格
            // 定时表达式格式校验
            const cronParams = task.cron.split(' ')
            if (cronParams.length < 5 || cronParams.length > 6) {
                logger.error(`设置定时任务 ${task.id.split('T_')[1]} 失败 => ${task.cron.trim()} (格式错误)`)
                continue
            }
            // 月份兼容性处理（kelektiv/node-cron 库特性，月份单位为非Unix格式，0-11 代表 Jan-Dec）
            task.cron = decreaseMonth(task.cron)
            // 设置定时
            try {
                engine.setTask(task.id, task.cron, () => onCron(task))
                // logger.log(`设置定时任务 ${task.id.split('T_')[1]} 成功 => ${task.cron}`)
            } catch (e) {
                logger.error(`设置定时任务 ${task.id.split('T_')[1]} 失败 => ${task.cron.trim()} ${e.message || e}`)
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
    if (task.id.startsWith('T_') && task.callback === '') {
        onCronTask(parseInt(task.id.substring(2))).then((r) => {
            // console.log("over", task.id)
        })
    }
    eventBus.emit(task.id, task)
    eventBus.emit('callback.' + task.callback, task)
}

/**
 * tasks表回调
 *
 * @param {number} taskId
 */
async function onCronTask(taskId) {
    let task = await curd.getById(taskId)
    if (!task) {
        //todo:报错?
        await taskCoreCurd.deleteById(taskId) // 删除不存在的定时任务
        return
    }
    if (task.active <= 0) {
        // logger.log("触发定时任务", task.shell, "（PASS，原因：已被禁用）")
        return
    }
    if (running[taskId]) {
        logger.log('触发定时任务', task.shell, '（PASS，原因：正在运行）')
        return
    }
    running[taskId] = task
    let date = new Date()
    //fixme:需要其他操作,如指定日志等
    taskRunner.execShell(task.shell, {
        callback: (error, stdout, stderr) => {
            if (error) {
                // logger.log("定时任务运行完毕", task.shell, stdout.substring(stdout.length - 1000))
                // } else {
                logger.warn('定时任务异常', task.shell, error.toString().substring(stdout.length - 1000))
            }
        },
        onExit: (code) => {
            delete running[taskId]
            curd.updateById({
                id: taskId,
                last_runtime: date,
                last_run_use: (new Date().getTime() - date.getTime()) / 1000,
            }).catch((e) => {})
        },
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
        let formatCron = cron.trim() // 去除首尾空格
        let change = await taskCoreCurd.updateById({ id, cron: formatCron, callback })
        if (!change) {
            await taskCoreCurd.save({ id, cron: formatCron, callback })
        }
        // 格式化表达式
        formatCron = decreaseMonth(formatCron) // 月份兼容性处理（kelektiv/node-cron 库特性，月份单位为非Unix格式，0-11 代表 Jan-Dec）
        engine.setTask(id, formatCron, () =>
            onCron({
                id: id,
                cron: formatCron,
                callback: '',
            })
        )
    },
    /**
     * @param {typeof import('./curd').Type} task
     */
    setTaskJob: async (task) => {
        return module.exports.setTaskCore('T_' + task.id, task.cron, '')
    },
    /**
     * @param {number} taskId
     */
    deleteTaskJob: async (taskId) => {
        const id = 'T_' + taskId
        await taskCoreCurd.deleteById(id)
        engine.removeTask(id)
    },
}
