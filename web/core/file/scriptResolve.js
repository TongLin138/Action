const fs = require("fs");
const _path = require("path");

const types = {
    "js": require("./resolve/resolveJs").resolve,
    "ts": require("./resolve/resolveTs").resolve,
    "py": require("./resolve/resolvePy").resolve,
    "sh": require("./resolve/resolveShell").resolve,
}

/**
 * @typedef {{
 *     name: string,
 *     cron: string,
 * }} ScriptInfo
 */

/**
 * @param filePath 文件路径
 * @returns null|ScriptInfo
 */
function resolveScript(filePath) {
    let ext = _path.extname(filePath);
    let type = ext.substring(1);
    let handler = types[type];
    if (handler) {
        return handler(filePath, ext);
    }
    return null;
}

module.exports = resolveScript;
