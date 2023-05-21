const express = require('express');


let api = express();

const {API_STATUS_CODE} = require("../core/http");
const {getFile, CONFIG_FILE_KEY, saveNewConf} = require("../core/file");

/**
 * 获取定时任务配置文件
 */
api.get('/cron', function (request, response) {
    response.setHeader('Content-Type', 'text/plain');
    response.send(API_STATUS_CODE.okData(getFile(CONFIG_FILE_KEY.CRONTAB)));
});

/**
 * 保存定时任务配置文件
 */
api.post('/cron', function (request, response) {
    let postContent = request.body.content;
    try {
        saveNewConf(CONFIG_FILE_KEY.CRONTAB, postContent)
        response.send(API_STATUS_CODE.ok("保存成功"));
    } catch (e) {
        response.send(API_STATUS_CODE.fail(`保存失败！${e.message}`));
    }

});


module.exports.configAPI = api;