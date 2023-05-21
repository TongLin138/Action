const curd = require('../core/configs/curd');
const express = require('express');
let api = express();

const {API_STATUS_CODE} = require("../core/http");

api.get('/type', async function (request, response) {
    let type = request.params.type;
    response.send(API_STATUS_CODE.okData(await curd.list({
        type: type
    })))
})


/**
 * 分页查询
 */
api.get('/type', async function (request, response) {
    let filter = Object.assign({}, request.query)
    const data = await curd.page(parseInt(request.query.page || 1), parseInt(request.query.size || 20), {
        filter,
        orderBy: ['sort'],
    });
    response.send(API_STATUS_CODE.okData(data))
});
/**
 * 创建
 */
api.post('/type', async function (request, response) {
    let task = Object.assign({}, request.body, {create_time: new Date()});
    delete task.id
    try {
        await curd.save(task);
        response.send(API_STATUS_CODE.okData(task))
    } catch (e) {
        response.send(API_STATUS_CODE.fail(e.message || e))
    }
});
/**
 * 修改
 */
api.put('/type', async function (request, response) {
    let task = Object.assign({}, request.body);
    try {
        await curd.updateById(task);
        task = await curd.getById(task.id)
        response.send(API_STATUS_CODE.okData(!!task))
    } catch (e) {
        response.send(API_STATUS_CODE.fail(e.message || e))
    }
});

/**
 * 删除
 */
api.delete('/type', async function (request, response) {
    try {
        const res = await curd.deleteById(request.query.id)
        response.send(API_STATUS_CODE.okData(!!res.change()))
    } catch (e) {
        response.send(API_STATUS_CODE.fail(e.message || e))
    }
});

/**
 * 根据类型查询
 */
api.get('/type/:type', async function (request, response) {
    let type = request.params.type;
    response.send(API_STATUS_CODE.okData(await curd.list({
        type: type
    })))
})
/**
 * 根据类型查询一个
 */
api.get('/type/single/:type', async function (request, response) {
    let type = request.params.type;
    let configs = await curd.list({
        type: type
    }, [], (obj, sql) => {
        return sql + " order by sort limit 1"
    });
    response.send(API_STATUS_CODE.okData(configs?.length > 0 ? configs[0] : null))
})

module.exports.configAPI = api;