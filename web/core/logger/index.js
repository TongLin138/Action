/**
 * 日志
 * */

let log4js = require("log4js");

log4js.configure({
    appenders: {
        MAIN: {
            type: "file",
            filename: "/arcadia/logs/Arcadia/server.log"
        }
    },
    categories: {
        default: {
            appenders: ["MAIN"],
            level: "info"
        }
    },
});


module.exports.logger = log4js.getLogger("MAIN");
