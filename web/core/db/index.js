const path = require("path");
const fs = require("fs");
const {logger} = require("../logger");
const sqlite3 = require('sqlite3').verbose();

const basePath = path.resolve(__dirname + "/../../../config");
const s = path.resolve(basePath + "/config.db");
if (!fs.existsSync(basePath)) {
    fs.mkdirSync(basePath)
}
const sqlite = new sqlite3.Database(s, (e) => {
    if (e) {
        console.error("连接sqlite失败!!!")
        throw e
    }
})

const db = {
    /**
     * 查询并返回第一条数据
     * @param {string} sql - sql语句
     * @param {any|Array?} data - 参数数组
     * @returns {Promise<any>} - 返回一个Promise对象，resolve时返回查询结果的第一条数据
     */
    selectFirst: (sql, data) => {
        sql = sql.trim()
        if (!sql.includes("limit")) {
            sql = sql + " limit 1"
        }
        return new Promise((r, f) => sqlite.all(sql, data, (e, d) => e ? f(e) : r(d[0])))
    },

    /**
     * 执行单条sql语句
     * @param {string} sql - sql语句
     * @param {any|Array?} data - 参数数组
     * @returns {Promise<[any]|{id:()=>number|string,change:()=>number,original:()=>any}>} - 返回一个Promise对象，resolve时返回查询结果或执行结果
     */
    exec: (sql, data) => {
        sql = sql.trim()
        const indexOf = sql.indexOf("select");
        if (indexOf > -1 && indexOf < 10) {
            return new Promise((r, f) => sqlite.all(sql, data, (e, d) => e ? f(e) : r(d)))
        } else {
            return new Promise((r, f) => sqlite.run(sql, data, function (e) {
                e ? f(e) : r({
                    id: () => this.lastID,
                    change: () => this.changes,
                    original: () => this
                })
            }))
        }
    },

    /**
     * 批量执行预处理sql语句，只支持非查询
     * @param {string} sql - sql语句
     * @param {Array} datas - 参数数组
     * @returns {Promise} - 返回一个Promise对象，resolve时返回执行结果
     */
    execGroup: (sql, datas) => {
        return new Promise((r, f) => {
            let err1
            const statement = sqlite.prepare(sql, async (err) => {
                if (err) {
                    err1 = err
                    f(err)
                }
            })
            if (err1) {
                return
            }
            let res = []
            for (let data of datas) {
                res.push(new Promise((r1, f1) => {
                    statement.run(data, function (err) {
                        err ? f1(err) : r1()
                    })
                }))
            }
            Promise.all(res).then(r, f).finally(() => statement.finalize())
        })
    },

    /**
     * 判断表是否存在
     * @param {string} tableName - 表名
     * @returns {Promise<boolean>} - 返回一个Promise对象，resolve时返回表名是否存在
     */
    existTable: (tableName) => {
        return db.selectFirst(`
            SELECT 1
            FROM sqlite_master
            WHERE type = 'table'
              AND name = ?`, tableName
        )
    },
    /**
     * like查询sql
     *
     * @return {string}
     */
    likeSql() {
        return ` like ('%'|| ? || '%')`
    },
    debug: process.env.DEBUG_SQL === "true",
    serialize: sqlite.serialize,
    sqlite,
};

{
    let starting = true
    setTimeout(() => {
        starting = false
    }, 1000)
    sqlite.on('trace', (sql) => {
        if (starting) {
            if (sql.includes("create") || sql.includes("CREATE")) {
                // console.log('CREATE SQL: ', sql)
                logger.info('SQL: ', sql)
            }
            return
        }
        db.debug && logger.info('SQL: ', sql)
    })
}
module.exports = db;
(async function () {
    if (await db.existTable("info")) {
        logger.info("检查info表完成,已存在")
        await db.exec(`update info
                       set value=?
                       where name = ?`,
            [`start`, new Date().getTime() + ""]
        )
        return
    }
    await db.exec(`CREATE TABLE info
                   (
                       name  varchar(20),
                       value TEXT
                   )`)
    await db.execGroup(`insert into info (name, value)
                        values (?, ?)`, [
        [`version`, `0.0.1`],
        [`start`, new Date().getTime() + ""],
    ])
}())
