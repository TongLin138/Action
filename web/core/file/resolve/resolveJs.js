const childProcess = require('child_process')
const path = require('path')

let shellPath = path.resolve('./core/file/resolve/resolve.sh')

module.exports = {
    resolve: (filePath) => {
        //判断文件夹是否存在
        //如果不存在,则创建,并从指定地址拉取
        return new Promise((f, r) =>
            childProcess.exec(shellPath + ' ' + filePath, (error, stdout, stderr) => {
                if (error) {
                    r(error)
                } else {
                    try {
                        let text = stdout.split('\n').filter((it) => it.trim().length > 0)
                        f(JSON.parse(text[text.length - 1]))
                        // f(JSON.parse(stdout))
                    } catch (e) {
                        r(e)
                    }
                }
            })
        )
    },
}
