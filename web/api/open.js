const express = require('express')
const util = require('../utils')
const { extraServerFile, getJsonFile, CONFIG_FILE_KEY } = require('../core/file')
const { updateCookie, removeCookie, updateAccount, getCount } = require('../core/cookie')
const { API_STATUS_CODE } = require('../core/http')

let api = express()

api.post('/updateCookie', function (request, response) {
    try {
        response.send(
            API_STATUS_CODE.okData(
                updateCookie({
                    ck: request.body.cookie,
                    remarks: request.body.userMsg,
                    phone: request.body.phone,
                })
            )
        )
    } catch (e) {
        response.send(API_STATUS_CODE.fail(e.message))
    }
})

api.post('/cookie/delete', function (request, response) {
    try {
        response.send(API_STATUS_CODE.okData(removeCookie(request.body.ptPins)))
    } catch (e) {
        response.send(API_STATUS_CODE.fail(e.message))
    }
})

api.post('/addOrUpdateAccount', function (request, response) {
    try {
        let { ptPin, ptKey, wsKey, remarks, phone } = request.body
        response.send(
            API_STATUS_CODE.okData(
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
        response.send(API_STATUS_CODE.fail(e.message))
    }
})

api.get('/count', function (request, response) {
    try {
        response.send(API_STATUS_CODE.okData(getCount()))
    } catch (e) {
        response.send(API_STATUS_CODE.fail(e.message))
    }
})

api.post('/cookie/webhook', function (request, response) {
    try {
        let { ck, remarks = '', phone } = request.body
        response.send(
            API_STATUS_CODE.webHookOk(
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

// 调用自定义接口
try {
    require.resolve(extraServerFile)
    const extraApi = require(extraServerFile)
    if (typeof extraServer === 'function') {
        extraApi(api)
        logger.success('用户 Open Api 模块初始化成功')
    }
} catch {}

module.exports.openAPI = api
module.exports.tokenChecker = function (req) {
    // open
    let authFileJson = getJsonFile(CONFIG_FILE_KEY.AUTH)
    let token = req.headers['api-token']
    if (!token || token === '') {
        //取URL中的TOKEN
        token = req.query['api-token']
    }
    if (util.isNotEmpty(authFileJson['openApiToken'])) {
        if (token && token !== '' && token === authFileJson['openApiToken']) {
            return null
        } else {
            return API_STATUS_CODE.OPEN_API.AUTH_FAIL
        }
    } else {
        return API_STATUS_CODE.OPEN_API.NOT_OPEN
    }
}
module.exports.openApiHandler = function (req, res, next) {
    // open
    let fail = module.exports.tokenChecker(req)
    if (fail) {
        res.send(fail)
        return
    }
    next()
}
