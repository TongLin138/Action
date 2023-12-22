const express = require('express')
const { API_STATUS_CODE } = require('../core/http')

let api = express()

/**
 * 健康检测
 */
api.get('/health', async function (request, response) {
    response.send(API_STATUS_CODE.okData(true))
})

module.exports.commonAPI = api
