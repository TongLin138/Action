const db = require('../db')
const { logger } = require('../logger')
const eventBus = require('../eventBus').db

;(async () => {
    const tableExit = await db.existTable('tasks')
    if (tableExit) {
        // const ColumnExit = await db.existColumn('tasks', 'logPath')
        // logger.info(ColumnExit)
        // if (ColumnExit) {
        //     logger.info('tasks表logPath列已存在')
        // } else {
        //     // await db.exec(`ALTER TABLE tasks ADD COLUMN logPath VARCHAR(200) NOT NULL DEFAULT ''`)
        //     logger.info('tasks表logPath列不存在')
        // }
        // logger.info("检查tasks表完成,已存在")
        return
    }
    await db.exec(`
        CREATE TABLE tasks
        (
            id           INTEGER PRIMARY KEY AUTOINCREMENT,
            name         VARCHAR(200) NOT NULL,
            cron         VARCHAR(100) NOT NULL,
            type         VARCHAR(20)  NOT NULL,
            shell        TEXT         NOT NULL DEFAULT '',
            active       integer      NOT NULL DEFAULT 1,
            last_runtime DATETIME,
            last_run_use INT,
            tags         VARCHAR(200) NOT NULL DEFAULT '',
            sort         INT          NOT NULL DEFAULT 99999,
            create_time  DATETIME              DEFAULT CURRENT_TIMESTAMP,
            config       TEXT         NOT NULL default '',
            remark       TEXT         NOT NULL default '',
            bind         TEXT         NOT NULL DEFAULT ''
        );
        CREATE INDEX sort ON tasks (sort);`)
    eventBus.emit('createTable', 'tasks')
})()
;(async () => {
    if (await db.existTable('task_core')) {
        // logger.info("检查task_core表完成,已存在")
        return
    }
    await db.exec(`
        CREATE TABLE task_core
        (
            id       varchar(20) primary key,
            cron     varchar(100) not null,
            callback varchar(100) not null
        )`)
    eventBus.emit('createTable', 'task_core')
})()
