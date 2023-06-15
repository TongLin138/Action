const db = require("../db");
// const {logger} = require("../logger");
const eventBus = require("../eventBus").db;

((async () => {
    if (await db.existTable("config")) {
        // logger.info("检查tasks表完成,已存在")
        return
    }
    await db.exec(`
        CREATE TABLE config
        (
            id    INTEGER PRIMARY KEY AUTOINCREMENT,
            type  VARCHAR(200) NOT NULL,
            label VARCHAR(200) NOT NULL default '',
            value VARCHAR(200) NOT NULL,
            sort  int          NOT NULL default 999
        );
        CREATE INDEX type ON config (type);`)
    eventBus.emit("createTable", 'config')
})());
