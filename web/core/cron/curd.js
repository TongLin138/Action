const db = require("../db");

const template = require("../db/curdTemplate");

let curd = template("tasks", {
    id: 0,
    name: "",
    type: "",
    cron: "",
    shell: "",
    active: 0,
    config: "",
    tags: "",
    last_runtime: new Date(),
    last_run_use: 0,
    sort: 0,
    creat_time: new Date(),
    remark: "",
    bind: ""
}, "id", 0);

const Type = curd.Type;

module.exports = curd;

/**
 * @param {number} taskId
 * @param {number} newOrder
 * @returns {Promise<boolean>}
 */
curd.updateSortById = async (taskId, newOrder) => {
    const old = await curd.getById(taskId);
    if (newOrder === old.sort) {
        return true
    }
    let args = newOrder > old.sort ?
        [old.sort, newOrder, -1, old.sort + 1, newOrder] :
        [old.sort, newOrder, 1, old.sort, newOrder - 1];
    await db.exec(
        `UPDATE tasks
         SET sort = iif(sort = ?, ?, sort + ?)
         WHERE (sort between ? and ?)`, args)
}
/**
 * 数据库所有成员sort设置为顺序值
 * @return {Promise<void>}
 */
curd.fixOrder = async () => {
    await db.exec(
        `
            UPDATE tasks
            SET sort = t.row_num
            FROM (SELECT rowid, id, row_number() over ( order by sort) as row_num
                  FROM tasks) t
            WHERE t.id = tasks.id`
    )
}

let index;

/**
 * @param {number} taskId
 * @returns {Promise<boolean>}
 */
curd.fixCron = async (taskId) => {
    if (!index) {
        index = require("./core")
    }
    let task = await curd.getById(taskId);
    if (task) {
        await index.setTaskJob(task)
    } else {
        await index.deleteTaskJob(taskId)
    }
}
