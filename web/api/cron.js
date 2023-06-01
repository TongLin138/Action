const express = require('express')
const cron = require('cron')
let api = express()

const core = require('../core/cron/core')
const curd = require('../core/cron/curd')
const { API_STATUS_CODE } = require('../core/http')
const { logger } = require('../core/logger')
const scriptResolve = require('../core/file/scriptResolve')
const { DIR_KEY } = require("../core/file");

/**
 * 获取定时任务列表
 * @apiQuery  {String} page 页数
 * @apiQuery  {String} size 每页数量
 * @apiQuery  {String} search 查询
 */
api.get('/', async function (request, response) {
    let active = request.query.active ? request.query.active.split(',') : []
    let tags = request.query.tags ? request.query.tags.split(',').map(s => s.trim()).filter(s => s) : []
    let filter = Object.assign({}, request.query)
    delete filter.active
    delete filter.tags
    let likeKeys = ['remark']
    if (request.query.bind) {
        likeKeys.push('bind')
    }
    const tasks = await curd.page(parseInt(request.query.page || 1), parseInt(request.query.size || 20), {
        filter: filter,
        likeKeys: likeKeys,
        customize: (obj, sql, args) => {
            if (active.length > 0) {
                if (sql && sql.trim()) {
                    sql += ` and `
                }
                sql += ` active in (${active.map((a) => '?').join(',')}) `
                args.push(...active)
            }
            if (request.query.tags === "$__null__") {
                if (sql && sql.trim()) {
                    sql += ` and `
                }
                sql += ` (tags = '')`
            } else if (tags.length > 0) {
                if (sql && sql.trim()) {
                    sql += ` and `
                }
                sql += ` (` + tags.map((s) => 'tags ' + curd.db.likeSql()).join(' or ') + `)`
                args.push(...tags)
            }
            if (request.query.search) {
                if (sql && sql.trim()) {
                    sql += ` and `
                }
                sql += ` ( name ` + curd.db.likeSql() + ` or shell ` + curd.db.likeSql() + `)`
                args.push(request.query.search, request.query.search)
            }
            return sql
        },
        orderBy: [{ name: 'sort', desc: true }]
    })
    tasks.data.forEach((task) => task.create_time = new Date(task.create_time))
    tasks.data.forEach((task) => {
        if (task.last_runtime) {
            task.last_runtime = new Date(task.last_runtime)
        }
    })
    tasks.data.forEach((task) => (task.running_status = !!core.running[task.id]))
    response.send(API_STATUS_CODE.okData(tasks))
})
/**
 * 创建定时任务
 */
api.post('/', async function (request, response) {
    let task = Object.assign({}, request.body, { create_time: new Date() })
    delete task.id
    try {
        try {
            cron.CronTime(task.cron)
        } catch (e) {
            throw new Error('cron表达式错误')
        }
        await curd.save(task)
        logger.info('添加定时任务', request.query.id, task)
        await curd.fixOrder()
        await curd.fixCron(task.id)
        response.send(API_STATUS_CODE.okData(task))
    } catch (e) {
        response.send(API_STATUS_CODE.fail(e.message || e))
    }
})
/**
 * 修改
 */
api.put('/', async function (request, response) {
    let tasks
    if (Array.isArray(request)) {
        tasks = request.body.map((task) => Object.assign({}, task))
    } else {
        tasks = [Object.assign({}, request.body)]
    }
    for (const task of tasks) {
        delete task.sort
        delete task.bind
        delete task.create_time
        try {
            cron.CronTime(task.cron)
        } catch (e) {
            response.send(API_STATUS_CODE.fail('cron表达式错误'))
            return
        }
    }
    try {
        let ok = false
        for (const task of tasks) {
            await curd.updateById(task)
            logger.info('修改定时任务', task.id, task)
            let task1 = await curd.getById(task.id)
            if (task && task.cron && task1.cron !== task.cron) {
                await curd.fixCron(task.id)
            }
            if (!ok) {
                ok = !!task
            }
        }
        response.send(API_STATUS_CODE.okData(ok))
    } catch (e) {
        response.send(API_STATUS_CODE.fail(e.message || e))
    }
})

/**
 * 调整排序
 */
api.put('/order', async function (request, response) {
    try {
        response.send(API_STATUS_CODE.okData(await curd.updateSortById(request.query.id, request.query.order)))
    } catch (e) {
        response.send(API_STATUS_CODE.fail(e.message || e))
    }
})

/**
 * 删除
 */
api.delete('/', async function (request, response) {
    try {
        const id = request.query.id ? request.query.id.split(',') : []
        const res = await curd.deleteById(id)
        logger.info('删除定时任务', request.query.id, res.change())
        for (let i of id) {
            await curd.fixCron(i)
        }
        await curd.fixOrder()
        response.send(API_STATUS_CODE.okData(!!res.change()))
    } catch (e) {
        response.send(API_STATUS_CODE.fail(e.message || e))
    } finally {
        await curd.fixCron(request.query.id)
    }
})

/**
 * 查询bind组
 */
api.get('/bindGroup', async function (request, response) {
    try {
        response.send(
            API_STATUS_CODE.okData(
                await curd.db.exec(`
                    select bind, count(*) count
                    from (SELECT SUBSTR(bind, INSTR(bind, '#') + 1,
                                        INSTR(SUBSTR(bind, INSTR(bind, '#') + 1), '#') - 1) AS bind
                          FROM tasks)
                    GROUP BY bind
                `)
            )
        )
    } catch (e) {
        response.send(API_STATUS_CODE.fail(e.message || e))
    }
})

let innerCornApi = express()

innerCornApi.post('/updateAll', async function (request, response) {
    try {
        function toBind(type, s) {
            let prefix = "/" + DIR_KEY.ROOT + DIR_KEY.REPO;
            if (s.startsWith(prefix)) {
                s = s.replace(prefix, "")
            }
            prefix = "/" + DIR_KEY.ROOT + DIR_KEY.RAW;
            if (s.startsWith(prefix)) {
                s = s.replace(prefix, DIR_KEY.RAW)
            }
            return type + '#' + s.substring(0, s.indexOf('/')) + '#' + s.substring(s.indexOf('/') + 1)
        }

        let infos = []
        let { deleteFiles, newFiles, type } = request.body

        //1.删除定时任务
        if (deleteFiles && deleteFiles.length > 0) {
            let deleteTask = await curd.list({}, [], (o, sql, params) => {
                params.push(...deleteFiles.map((s) => toBind(type, s.path)))
                return `bind in (${deleteFiles.map((_) => '?').join(',')})`
            }
            );
            await curd.deleteById(deleteTask.map((s) => s.id))
            for (const item of deleteTask) {
                let paths = item.bind.split("#");
                let path = paths[1] + "/" + paths[2];
                try {
                    await curd.fixCron(item.id);
                    infos.push({
                        success: true,
                        type: 1,
                        path: path,
                        name: item.name,
                        remark: item.remark,
                        message: `ok`
                    })
                } catch (e) {
                    infos.push({
                        success: false,
                        type: 1,
                        path: path,
                        name: item.name,
                        remark: item.remark,
                        message: `${e.message || e}`
                    })
                }
            }
        }
        //2.新增定时任务
        if (newFiles && newFiles.length > 0) {
            {
                let deleteTask = await curd.list({}, [], (o, sql, params) => {
                    params.push(...newFiles.map((s) => toBind(type, s.path)))
                    return `bind in (${newFiles.map((_) => '?').join(',')})`
                }
                );
                await curd.deleteById(deleteTask.map((s) => s.id))
                for (const item of deleteTask) {
                    await curd.fixCron(item.id);
                }
            }
            //2.1,批量插入定时任务
            for (let item of newFiles) {
                try {
                    let task = await scriptResolve(item.path)
                    //可优化,一次性插入效果更好
                    let t = {
                        name: task.name,
                        type: type,
                        cron: task.cron,
                        shell: `task run ${task.runPath}`,
                        active: item.active || 1, // 默认启用
                        config: '',
                        tags: task.tags || '',
                        create_time: new Date(),
                        bind: toBind(type, item.path),
                    }
                    await curd.save(t)
                    await curd.fixCron(t.id)
                    infos.push({
                        success: true,
                        type: 0,
                        path: task.path,
                        name: task.name,
                        message: `ok`
                    })
                } catch (e) {
                    let arr = item.path.split('/');
                    let name = arr[arr.length - 1];
                    infos.push({
                        success: false,
                        type: 0,
                        path: item.path,
                        name: name,
                        message: `${e.message || e}`
                    })
                }
                await curd.fixOrder()
            }
        }
        response.send(API_STATUS_CODE.okData(infos))
    } catch (e) {
        response.send(API_STATUS_CODE.fail(e.message || e))
        logger.error('批量更新定时任务失败', e)
    }
})

module.exports.cronAPI = api
module.exports.innerCornApi = innerCornApi
