const {exec} = require('child_process');

/**
 * 执行shell
 * @param {string} shell
 * @param {{
 * callback:(error:any,stdout:string,stderr:string)=>?,
 * onChange:function(data:{},type:'stdout'|'stderr')?,
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
    } finally {
        config.onExit && config.onExit(1)
    }
}

module.exports = {
    execShell
}