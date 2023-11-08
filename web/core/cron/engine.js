const { CronJob } = require('cron')
const idTotask = {}
const CronTimeZone = 'Asia/Shanghai'

module.exports = {
    /**
     * 设置定时任务
     * @param {string} id - 任务ID
     * @param {string} cron - cron表达式
     * @param {function} callback - 回调函数
     */
    setTask(id, cron, callback) {
        let cronTask = idTotask[id]
        // 如果任务已存在，则先停止并删除
        if (cronTask) {
            cronTask.task.stop()
            cronTask.task = null
            delete cronTask.task
        }
        cronTask = {}
        idTotask[id] = cronTask
        cronTask.callback = callback
        cronTask.task = new CronJob(
            cron,
            () => {
                cronTask.callback()
            },
            true,
            CronTimeZone
        )
        cronTask.task.start()
    },
    /**
     * 移除定时任务
     * @param {string} id - 任务ID
     */
    removeTask(id) {
        let task = idTotask[id]
        if (task) {
            task.task.stop()
            delete idTotask[id]
        }
    },
}
