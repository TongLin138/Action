const express = require('express');


let api = express();
const {errorCount} = require("../core");
const {API_STATUS_CODE, getClientIP} = require("../core/http");
const {saveNewConf, CONFIG_FILE_KEY, getJsonFile, DIR_KEY} = require("../core/file");
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
    logger.info(`检测到用户登录行为，尝试登录用户名 ${username}`)
    let con = getJsonFile(CONFIG_FILE_KEY.AUTH);
    let curTime = new Date();
    let authErrorCount = con['authErrorCount'] || 0;
    if (authErrorCount >= 3 && con.authErrorTime) {
        let authErrorTime = con.authErrorTime;
        // 判断登录是否间隔一分钟
        let limitTime = 60 - (curTime.getTime() - authErrorTime)/1000;
        if (limitTime > 0) {
            // 累计错误登录次数超过3次锁定1分钟
            response.send(API_STATUS_CODE.failData('认证失败次数过多，请稍后尝试！', {
                showCaptcha: true,
                limitTime:Math.floor(limitTime),
            }))
            return;
        }
    }

    let showCaptcha = authErrorCount >= errorCount;
    if (captcha === '' && showCaptcha) {
        response.send(API_STATUS_CODE.failData('请输入验证码！', {showCaptcha: true}))
        return;
    }
    let authCaptcha = con['captcha'];
    if (showCaptcha && captcha.toLowerCase() !== authCaptcha) {
        response.send(API_STATUS_CODE.failData('验证码不正确！', {showCaptcha: showCaptcha}))
        return;
    }
    if (username && password) {
        if (username === con.user && password === con.password) {
            const result = {token: 0, newPwd: ''};
            if (password === "passwd") {
                //如果是默认密码
                con.password = random(16);
                logger.info(`系统检测到密码为初始密码，已修改为随机密码：${con.password}`);
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
                if(ip !== "127.0.0.1" &&  ip !== "localhost"){
                    logger.info(`用户 ${username} 已登录，登录地址：${ip} ${address}`);
                }
                saveNewConf(CONFIG_FILE_KEY.AUTH, con, false);
            });
            result.token = jwt.sign({
                username: username,
            }, con["jwtSecret"], {expiresIn: 3600 * 24 * 3})
            response.send(API_STATUS_CODE.okData(result));
        } else {
            authErrorCount++;
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
        logger.info(`用户修改了用户名密码，openApiToken 已重置为：${config.openApiToken}`)
        response.send(API_STATUS_CODE.ok("修改成功！"));
    } else {
        response.send(API_STATUS_CODE.fail("请输入用户名密码！"));
    }

});

/**
 * 退出登录
 */
api.get('/logout', function (request, response) {
    response.send(API_STATUS_CODE.ok());
});


module.exports.userAPI = api;