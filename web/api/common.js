const express = require('express');
const {checkCookieStatus} = require("../core/cookie");
const {API_STATUS_CODE} = require("../core/http");


let api = express();

/**
 * 检测账号状态
 */
api.post("/cookie/check", async function (request, response) {
    let ck = request.body.cookie;
    let data = await checkCookieStatus(ck)
    let statusCode = data.retcode;
    if (statusCode) {
        if (statusCode === "0") {
            // 有效
            response.send(API_STATUS_CODE.okData(true));
        } else {
            // 无效
            response.send(API_STATUS_CODE.okData(false));
        }
    } else {
        response.send(API_STATUS_CODE.fail("网络环境异常"));
    }
});

/**
 * 健康检测
 */
api.get("/health", async function (request, response) {
    response.send(API_STATUS_CODE.okData(true));
});

module.exports.commonAPI = api;