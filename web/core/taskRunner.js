const {exec} = require('child_process');

/**
 * @callback callback
 * @param {any}error
 * @param {string}stdout
 * @param {string}stderr
 */

/**
 * 执行shell
 * @param {string} shell
 * @param {{
 * callback:callback?,
 * onChange:function(data,type)?,
 * onExit:function(code:number)?,
 * onException:function(error)?
 * }?} config
 * @return child_process.ChildProcess
 */
function execShell(shell, config) {
    try {
        const process = exec(shell, config.callback);
        const onChange = config.onChange;
        if (onChange) {
            process.stdout.on("data", (data) => onChange(data, "stdout"))
            process.stderr.on("data", (data) => onChange(data, "stderr"))
        }
        if (config.onExit) {
            process.on("exit", config.onExit)
        }
        return process
    } catch (e) {
        config.onException && config.onException(e)
        config.onExit && config.onExit(1)
    }
}

module.exports = {
    execShell
}