const express = require('express')
const cron = require('node-cron')
let api = express()

const core = require('../core/cron/core')
const curd = require('../core/cron/curd')
const {API_STATUS_CODE} = require('../core/http')
const {logger} = require('../core/logger')
const scriptResolve = require('../core/file/scriptResolve')
const {DIR_KEY} = require("../core/file");

/**
 * 获取定时任务列表
 * @apiQuery  {String} page 页数
 * @apiQuery  {String} size 每页数量
 * @apiQuery  {String} search 查询
 */
api.get('/', async function (request, response) {
    let active = request.query.active ? request.query.active.split(',') : []
    let tags = request.query.tags ? request.query.tags.split(',') : []
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
            if (tags.length > 0) {
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
        orderBy: ['sort'],
    })
    tasks.data.forEach((task) => (task.running_status = !!core.running[task.id]))
    response.send(API_STATUS_CODE.okData(tasks))
})
/**
 * 创建定时任务
 */
api.post('/', async function (request, response) {
    let task = Object.assign({}, request.body, {create_time: new Date()})
    delete task.id
    try {
        if (!cron.validate(task.cron)) {
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
    let task = Object.assign({}, request.body)
    delete task.sort
    delete task.bind
    delete task.creat_time
    try {
        if (task.cron && !cron.validate(task.cron)) {
            throw new Error('cron表达式错误')
        }
        await curd.updateById(task)
        logger.info('添加定时任务', request.query.id, task)
        task = await curd.getById(task.id)
        if (task && task.cron && task.cron !== task.cron) {
            await curd.fixCron(task.id)
        }
        response.send(API_STATUS_CODE.okData(!!task))
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
            let repoPath = "/" + DIR_KEY.ROOT + DIR_KEY.REPO;
            if (s.startsWith(repoPath)) {
                s = s.replace(repoPath, "")
            }
            return type + '#' + s.substring(0, s.indexOf('/')) + '#' + s.substring(s.indexOf('/') + 1)
        }

        let infos = []
        let {deleteFiles, newFiles, type} = request.body

        //1.删除定时任务
        if (deleteFiles && deleteFiles.length > 0) {
            await curd.deleteCustomize(
                `bind in (${deleteFiles.map((_) => '?').join(',')})`,
                deleteFiles.map((s) => toBind(type, s.path))
            )
            for (const task of deleteFiles) {
                infos.push({ok: true, message: `删除定时任务: ${task}`})
                await curd.fixCron(task.id);
            }
        }
        if (newFiles && newFiles.length > 0) {
            await curd.deleteCustomize(
                `bind in (${newFiles.map((_) => '?').join(',')})`,
                newFiles.map((s) => toBind(type, s.path))
            )
            for (const task of newFiles) {
                infos.push({ok: true, message: `删除定时任务: ${task}`})
                await curd.fixCron(task.id);
            }
            //2.新增定时任务
            //2.1,批量插入定时任务
            for (let item of newFiles) {
                let task = await scriptResolve(item.path)
                //可优化,一次性插入效果更好
                let t = {
                    name: task.name,
                    type: 'user',
                    cron: task.cron,
                    shell: `task run ${task.runPath}`,
                    active: item.active || 1, // 默认启用
                    config: '',
                    tags: task.tags || '',
                    creat_time: new Date(),
                    bind: toBind(type, item.path),
                }
                await curd.save(t)
                await curd.fixCron(t.id)
                infos.push({ok: true, message: `添加定时任务: ${task.name}`})
            }
            await curd.fixOrder()
        }
        response.send(API_STATUS_CODE.okData(infos))
    } catch (e) {
        response.send(API_STATUS_CODE.fail(e.message || e))
        logger.error('批量更新定时任务失败', e)
    }
})

module.exports.cronAPI = api
module.exports.innerCornApi = innerCornApi