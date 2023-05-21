const express = require('express');


let api = express();
const {errorCount} = require("../core");
const {API_STATUS_CODE, getClientIP} = require("../core/http");
const {saveNewConf, CONFIG_FILE_KEY, getJsonFile} = require("../core/file");
const {ip2Address} = require("../core");
const random = require("string-random");
const util = require("../utils");
const jwt = require("jsonwebtoken");
const {panelSendNotify} = require("../core/notify");
const {logger} = require("../core/logger");

/**
 * auth
 */
api.post('/auth', async (request, response) => {
    let {username, password, captcha = ''} = request.body;
    logger.info(`用户：${username} 开始登录...`)
    let con = getJsonFile(CONFIG_FILE_KEY.AUTH);
    let curTime = new Date();
    let authErrorCount = con['authErrorCount'] || 0;
    if (authErrorCount >= 30) {
        //错误次数超过30次，直接禁止登录
        response.send(API_STATUS_CODE.failData('面板错误登录次数到达30次，已禁止登录!', {showCaptcha: true}))
        return;
    }
    if (authErrorCount >= 3 && con.authErrorTime) {
        let authErrorTime = con.authErrorTime;
        // 判断登录是否间隔一分钟
        let limitTime = 60 - (curTime.getTime() - authErrorTime)/1000;
        if (limitTime > 0) {
            response.send(API_STATUS_CODE.failData('面板错误登录次数到达3次，请间隔一分钟之后进行登录!', {
                showCaptcha: true,
                limitTime:Math.floor(limitTime),
            }))
            return;
        }
    }

    let showCaptcha = authErrorCount >= errorCount;
    if (captcha === '' && showCaptcha) {
        response.send(API_STATUS_CODE.failData('请输入验证码!', {showCaptcha: true}))
        return;
    }
    let authCaptcha = con['captcha'];
    if (showCaptcha && captcha !== authCaptcha) {
        response.send(API_STATUS_CODE.failData('验证码不正确!', {showCaptcha: showCaptcha}))
        return;
    }
    if (username && password) {
        if (username === con.user && password === con.password) {
            const result = {token: 0, newPwd: ''};
            if (password === "passwd") {
                //如果是默认密码
                con.password = random(16);
                logger.info(`系统检测到您的密码为初始密码，已修改为随机密码：${con.password}`);
                result.newPwd = con.password;
            }
            con['authErrorCount'] = 0;
            //记录本次登录信息
            await ip2Address(getClientIP(request)).then(({ip, address}) => {
                con.lastLoginInfo = Object.assign(con.curLoginInfo || {}, {});
                con.curLoginInfo = {
                    loginIp: ip,
                    loginAddress: address,
                    loginTime: util.dateToString(curTime)
                }
                logger.info(`${username} 用户登录成功，登录IP：${ip}，登录地址：${address}`);
                saveNewConf(CONFIG_FILE_KEY.AUTH, con, false);
            });
            result.token = jwt.sign({
                username: username,
            }, con["jwtSecret"], {expiresIn: 3600 * 24 * 3})
            response.send(API_STATUS_CODE.okData(result));
        } else {
            authErrorCount++;

            try {
                if (authErrorCount === 10 || authErrorCount === 20) {
                    panelSendNotify(`异常登录提醒`, `您的面板登录验证错误次数已达到${authErrorCount}次，为了保障您的面板安全，请进行检查！温馨提示：请定期修改账号和密码，并将面板更新至最新版本`);
                } else if (authErrorCount === 30) {
                    panelSendNotify(`异常登录提醒`, `您的面板登录验证错误次数已达到${authErrorCount}次，已禁用面板登录。请手动设置/jd/config/auth.json文件里面的“authErrorCount”为0来恢复面板登录！`);
                }
            }catch (e) {
                logger.error(`发送异常登录提醒失败：${e.message}`)
            }

            con['authErrorCount'] = authErrorCount;
            con['authErrorTime'] = curTime.getTime();
            saveNewConf(CONFIG_FILE_KEY.AUTH, con, false);
            response.send(API_STATUS_CODE.fail("错误的用户名密码，请重试"))
        }
    } else {
        response.send(API_STATUS_CODE.fail("请输入用户名密码！"))
    }

});

/**
 * 获取用户信息
 */
api.get('/info', function (request, response) {
    let con = getJsonFile(CONFIG_FILE_KEY.AUTH);
    response.send(API_STATUS_CODE.okData({username: con.user, lastLoginInfo: con.lastLoginInfo || {}}));
});

/**
 * change pwd
 */
api.post('/changePwd', function (request, response) {
    let username = request.body.username;
    let password = request.body.password;
    if (username && password) {
        let config = getJsonFile(CONFIG_FILE_KEY.AUTH);
        config.password = password;
        config.user = username;
        config.openApiToken = random(32);
        saveNewConf(CONFIG_FILE_KEY.AUTH, config, true);
        logger.info(`用户修改了用户名密码，且 openApiToken 已重置为：${config.openApiToken}`)
        response.send(API_STATUS_CODE.ok("修改成功！"));
    } else {
        response.send(API_STATUS_CODE.fail("请输入用户名密码!"));
    }

});

/**
 * 退出登录
 */
api.get('/logout', function (request, response) {
    response.send(API_STATUS_CODE.ok());
});


module.exports.userAPI = api;