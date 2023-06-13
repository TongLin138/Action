/**
 * 日志组件
 * */

let log4js = require("log4js");

log4js.configure({
    appenders: {
        console: { type: 'console' },
        file: {
            type: 'file',
            filename: '/arcadia/log/server.log',
            layout: {
                type: 'pattern',
                pattern: '%d{yyyy-MM-dd hh:mm:ss} [%p] %c - %m'
            }
        }
    },
    categories: {
        default: { appenders: ['console', 'file'], level: 'debug' }
    }
});

module.exports.logger = log4js.getLogger("MAIN");
