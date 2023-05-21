const express = require('express');
const jwt = require('jsonwebtoken')
const {
    scriptsPath,
    saveFile,
    loadScripts,
    rootPath,
    logPath,
    loadLogTree,
    saveNewConf,
    getFileContentByName,
    getLastModifyFilePath,
    CONFIG_FILE_KEY,
    getFile,
    getJsonFile,
    getNeatContent, DIR_KEY,
} = require("../core/file");
const random = require('string-random');
const util = require('../utils/index');
const svgCaptcha = require("svg-captcha");
const {panelSendNotify} = require("../core/notify");
const {
    saveAccount, checkCookieStatus
} = require("../core/cookie");
const {API_STATUS_CODE} = require("../core/http");
const {
    exec
} = require('child_process');
const path = require('path');
const fs = require('fs');
const {errorCount} = require("../core");
const {logger} = require("../core/logger");
const socketCommon = require("../core/socket/common");

let api = express();
/**
 * 登录是否显示验证码
 */
api.get('/captcha/flag', function (request, response) {
    let con = getJsonFile(CONFIG_FILE_KEY.AUTH);
    let authErrorCount = con['authErrorCount'] || 0;
    response.send(API_STATUS_CODE.okData({showCaptcha: authErrorCount >= errorCount}));
});

/**
 * 验证码
 */
api.get('/captcha', function (req, res) {
    let {w = 120, h = 50} = req.query;
    let captcha = svgCaptcha.createMathExpr({width: w, height: h});
    let con = getJsonFile(CONFIG_FILE_KEY.AUTH);
    con['captcha'] = captcha.text;
    saveNewConf(CONFIG_FILE_KEY.AUTH, con, false)
    res.type('svg');
    res.status(200).send(captcha.data);
});

api.post('/runCmd', function (request, response) {
    const cmd = `cd ${rootPath};` + request.body.cmd;
    let name = "runLog";
    let runId = random(16);
    try {
        let result = exec(cmd, {encoding: 'utf-8'});
        result.stdout.on("data", (data) => {
            socketCommon.emit(name, API_STATUS_CODE.okData({
                runId, log: getNeatContent(data), over: false
            }))
        })
        result.stderr.on("data", (data) => {
            socketCommon.emit(name, API_STATUS_CODE.failData("run fail", {
                runId, log: getNeatContent(data), over: false
            }))
        })
        result.on("exit", (code) => {
            //结束
            socketCommon.emit(name, API_STATUS_CODE.ok("run over", {
                runId, over: true
            }))
        })
    } catch (err) {
        logger.error(err)
    }

    response.send(API_STATUS_CODE.okData(runId));
});

// global.io.emit("runLog", API_STATUS_CODE.okData({
//     runId, log: getNeatContent(`${stdout}`)
// }))

/**
 * 使用jsName获取最新的日志
 */
api.get('/runLog', function (request, response) {
    let jsName = request.query.jsName;
    let logFile;

    if (jsName.indexOf(".") > -1) {
        jsName = jsName.substring(0, jsName.lastIndexOf("."));
    }
    let pathUrl = DIR_KEY.LOG + `${jsName}/`;
    if (jsName.startsWith(DIR_KEY.SCRIPTS)) {
        jsName = jsName.substring(jsName.indexOf("/") + 1);
        pathUrl = DIR_KEY.LOG +`${jsName}/`;
    } else if (jsName.startsWith(DIR_KEY.REPO)) {
        jsName = jsName.substring(jsName.indexOf("/") + 1);
        pathUrl = DIR_KEY.LOG + `${jsName.replace(new RegExp('[/\\-]', "gm"), '_')}/`;
    } else {
        if (!fs.existsSync(path.join(rootPath, pathUrl))) {
            pathUrl = DIR_KEY.LOG + `jd_${jsName}/`;
        }
    }
    logFile = getLastModifyFilePath(
        path.join(rootPath, pathUrl)
    );

    if (logFile) {
        const content = getFileContentByName(logFile);
        response.setHeader('Content-Type', 'text/plain');
        response.send(API_STATUS_CODE.okData(getNeatContent(content)));
    } else {
        response.send(API_STATUS_CODE.okData("no logs"));
    }
});

module.exports.mainAPI = api;
