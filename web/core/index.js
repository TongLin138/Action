var {
    execSync
} = require('child_process');

const NodeRSA = require("node-rsa");
const {CONFIG_FILE_KEY, getJsonFile, saveNewConf} = require("./file");
const utils = require("../utils");
const random = require('string-random');
const got = require("got");
const errorCount = 1;
/**
 * 初始化
 */
function init() {
    let authFileJson = getJsonFile(CONFIG_FILE_KEY.AUTH);
    if(!utils.isNotEmpty(authFileJson["openApiToken"])){
        authFileJson["openApiToken"] = random(32)
    }

    if(!utils.isNotEmpty(authFileJson["jwtSecret"])){
        authFileJson["jwtSecret"] = random(16)
    }
    saveNewConf(CONFIG_FILE_KEY.AUTH, authFileJson, true);
}

init();



// 获取本机内网ip
function getLocalIp() {
    try {
        const res = execSync(`ifdata -pa eth0`, {encoding: 'utf8'});
        const ipArr = res.split('\n');
        console.log(ipArr);
        return ipArr[0] || '';
    } catch (e) {
        console.log(e.message)
    }
    return "127.0.0.1"

}

/**
 * ip转为地址
 * @param ip
 */
async function ip2Address(ip) {
    try {
        const {body} = await got(`http://ip.360.cn/IPShare/info?ip=${ip}`, {
            responseType: 'json',
            timeout: 2000,
            headers: {
                'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/101.0.4951.64 Safari/537.36 Edg/101.0.1210.53',
                Referer: 'http://ip.360.cn/',
                Host: 'ip.360.cn',
            },
        });
        let address = body.location === '* ' ? '未知' : body.location;
        address = address.replace(/\t/g, ' ');
        return {
            ip: ip,
            address: address,
        };
    } catch (e) {
        console.error("IP 转为地址失败", e);
    }
    return {
        ip: ip,
        address: "未知"
    };
}

module.exports = {
    ip2Address, getLocalIp,errorCount
}
