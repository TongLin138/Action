const express = require('express')
const { updateCookie, removeCookie, updateAccount, getCount, getCookieList } = require('../core/cookie')
const { API_STATUS_CODE } = require('../core/http')

let api = express()
/**
 * 更新已经存在的人的cookie & 自动添加新用户
 *
 * {"cookie":"","userMsg":""}
 * */
api.post('/updateCookie', function (request, response) {
    try {
        response.send(
            API_STATUS_CODE.okDataOld(
                updateCookie({
                    ck: request.body.cookie,
                    remarks: request.body.userMsg,
                    phone: request.body.phone,
                })
            )
        )
    } catch (e) {
        response.send(API_STATUS_CODE.failOld(e.message))
    }
})

/**
 * 删除CK
 * {"ptPins":[]}
 */
api.post('/cookie/delete', function (request, response) {
    try {
        response.send(API_STATUS_CODE.okDataOld(removeCookie(request.body.ptPins)))
    } catch (e) {
        response.send(API_STATUS_CODE.failOld(e.message))
    }
})

/**
 * 添加或者更新账号
 * {"ptPin":"",ptKey:"",wsKey:"","remarks":""}
 * ptPin 必填
 * */
api.post('/addOrUpdateAccount', function (request, response) {
    try {
        let { ptPin, ptKey, wsKey, remarks, phone } = request.body
        response.send(
            API_STATUS_CODE.okDataOld(
                updateAccount({
                    ptPin: ptPin,
                    ptKey: ptKey,
                    wsKey: wsKey,
                    remarks: remarks,
                    phone: phone,
                })
            )
        )
    } catch (e) {
        response.send(API_STATUS_CODE.failOld(e.message))
    }
})

/**
 * 获取ck数量
 * */
api.get('/count', function (request, response) {
    try {
        response.send(API_STATUS_CODE.okDataOld(getCount()))
    } catch (e) {
        response.send(API_STATUS_CODE.failOld(e.message))
    }
})

/**
 * 获取当前账号信息列表
 * */
api.get('/list', function (request, response) {
    try {
        response.send(API_STATUS_CODE.okDataOld(getCookieList()))
    } catch (e) {
        response.send(API_STATUS_CODE.failOld(e.message))
    }
})

/**
 * CK 回调
 * Body 内容为 {
            ck: "",
            remarks: "",
            phone: ""
        }
 其中 ck为必须项，remarks和phone为非必须
 */
api.post('/cookie/webhook', function (request, response) {
    try {
        let { ck, remarks = '', phone } = request.body
        response.send(
            API_STATUS_CODE.webHookOkOld(
                updateCookie({
                    ck: ck,
                    remarks: remarks,
                    phone: phone,
                })
            )
        )
    } catch (e) {
        response.send(API_STATUS_CODE.webhookFail(e.message))
    }
})

module.exports.openOldAPI = api
