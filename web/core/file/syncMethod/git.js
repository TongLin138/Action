const childProcess = require("child_process");
const path = require("path");

let rootPath = path.resolve(__dirname);
let shellPath = path.resolve(rootPath, "git.sh");

module.exports = {
    doSync: async (path, options) => {
        //判断文件夹是否存在
        //如果不存在,则创建,并从指定地址拉取
        return new Promise((f, r) => {
            let timeoutId
            let process = childProcess.exec(shellPath + " --path='" + path + "' " + Object.keys(options).map(k => "--" + k + "='" + options[k] + "'").join(" "),
                (error, stdout, stderr) => {
                    clearTimeout(timeoutId)
                    if (error) {
                        r(error)
                    } else {
                        f(stdout)
                    }
                })
            timeoutId = setTimeout(() => {
                process.kill()
                r("timeout")
            }, 1000 * 60 * 5)
        })
    }
}