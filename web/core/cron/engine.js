const Cron = require('cron');

const id2task = {}


module.exports = {
    /**
     * 设置定时任务
     * @param {string} id - 任务ID
     * @param {string} cron - cron表达式
     * @param {function} callback - 回调函数
     */
    setTask(id, cron, callback) {
        let task = id2task[id];
        if (task) {
            task.task.stop()
        } else {
            task = {}
            id2task[id] = task
        }
        task.callback = callback
        let job = new Cron.CronJob(cron, () => {
            task.callback()
        });
        task.task = job
        job.start()
    },
    /**
     * 移除定时任务
     * @param {string} id - 任务ID
     */
    removeTask(id) {
        let task = id2task[id];
        if (task) {
            task.task.stop()
            delete id2task[id]
        }
    }
}

