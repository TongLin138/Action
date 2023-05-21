const express = require('express');


let api = express();

const {API_STATUS_CODE} = require("../core/http");
const {
    getFile,
    getDirTree,
    rootPath,
    DIR_KEY,
    saveFile,
    saveFileByPath,
    fileRename,
    getNeatContent,
    fileDelete, pathCheck, fileDownload, fileMove, authConfigFile, rootPathCheck, fileCreate, fileInfo, getDirectory
} = require("../core/file");
const path = require("path");
const fs = require("fs");
const {logger} = require("../core/logger");
const sync = require("../core/file/sync");
const multer = require("multer");


let queryOptions = (request) => {
    let type = request.query.type || "all";
    let keywords = request.query.keywords || "";
    let startTime = request.query.startTime || "";
    let endTime = request.query.endTime || "";
    let isDir = request.query.isDir || false;
    return {type, keywords, startTime, endTime, isDir};
}

/**
 * @api {get} /api/file/tree 获取配置目录
 * @apiName 获取配置目录
 * @apiGroup File
 *
 * @apiHeader {String} Authorization   Bearer "your access token"
 *
 * @apiQuery {String} type      可选值 config、own、scripts、own_scripts、sample、log
 * @apiQuery {String} keywords  关键字
 * @apiQuery {String} startTime  开始时间 用于日志查询 yyyy-MM-dd hh:mm:ss  path 为 log 生效
 * @apiQuery {String} endTime  结束时间 用于日志查询 yyyy-MM-dd hh:mm:ss path 为 log 生效
 * @apiSuccess {Number} code 1
 * @apiSuccess {type} success 1
 * @apiSuccess {message} code 1
 * @apiSuccess {Object} result 目录信息 type 0表示目录 1表示文件
 * @apiSuccessExample {Array} Response-Example:
 * {
 *     "code": 1,
 *     "result": [
 *         {
 *             "path": "E:\\xxxx\\jd_base\\config\\",
 *             "title": "config",
 *             "type": 0,
 *             "deep": 0,
 *             "children": [
 *                 {
 *                     "path": "E:\\xxxx\\jd_base\\config\\account.json",
 *                     "name": "account.json",
 *                     "type": 1
 *                 },
 *                 {
 *                     "path": "E:\\xxxx\\jd_base\\config\\auth.json",
 *                     "name": "auth.json",
 *                     "type": 1
 *                 },
 *                 {
 *                     "path": "E:\\xxxx\\jd_base\\config\\bak",
 *                     "title": "bak",
 *                     "type": 0,
 *                     "deep": 1,
 *                     "children": []
 *                 }
 *             ]
 *         }
 *     ],
 *     "message": "success",
 *     "type": "success"
 * }
 *
 */
api.get('/tree', function (request, response) {
    let query = queryOptions(request)
    let type = query.type;
    if (Object.keys(DIR_KEY).includes(type.toUpperCase()) || type === 'all') {
        response.send(API_STATUS_CODE.okData(getDirTree(type,
            type === 'all' ? rootPath : path.join(rootPath, type),
            query
        )));
    } else {
        response.send(API_STATUS_CODE.fail("参数错误"))
    }
});

/**
 * 获取目录下的文件
 */
api.get('/dir', function (request, response) {
    let path = request.query.path;
    pathCheck(path);
    try {
        response.send(API_STATUS_CODE.okData(getDirectory(path,
            queryOptions(request)
        )));
    } catch (e) {
        response.send(API_STATUS_CODE.fail(e.message));
    }

});

/**
 * 获取脚本
 */
api.get('/tree/scripts', function (request, response) {
    let keywords = request.query.keywords || "";
    let startTime = request.query.startTime || "";
    let endTime = request.query.endTime || "";
    response.send(API_STATUS_CODE.okData(getDirTree("own_scripts", rootPath, {
        keywords,
        startTime,
        endTime
    })));

});


/**
 * @api {get} /api/file 获取文件内容
 * @apiName 获取文件内容
 * @apiGroup File
 *
 * @apiHeader {String} Authorization   Bearer "your access token"
 *
 * @apiQuery  {String} path 绝对路径
 * @apiSuccess {String} body 内容
 *
 */
api.get('/', function (request, response) {
    let path = request.query.path;
    try {
        pathCheck(path)
        response.setHeader('Content-Type', 'text/plain');
        // 日志文件去掉颜色标记，其他文件暂不处理
        const content = path.includes('/log/') ? getNeatContent(getFile(path)) : getFile(path);
        response.send(API_STATUS_CODE.okData(content));
    } catch (e) {
        response.send(API_STATUS_CODE.fail(e.message));
    }

});

/**
 * 查看文件详情
 */
api.get('/info', function (request, response) {
    let path = request.query.path;
    try {
        pathCheck(path)
        response.send(API_STATUS_CODE.okData(fileInfo(path)));
    } catch (e) {
        response.send(API_STATUS_CODE.fail(e.message));
    }

});

/**
 * @api {post} /api/file 保存文件
 * @apiName 保存文件
 * @apiGroup File
 *
 * @apiHeader {String} Authorization   Bearer "your access token"
 *
 * @apiBody {String} path 绝对路径
 * @apiBody {String} content 内容
 *
 * @apiSuccess {Number} code 1
 * @apiSuccess {type} success 1
 * @apiSuccess {message} code 1
 * @apiSuccess {Object} result 成功
 *
 */
api.post('/', function (request, response) {
    let path = request.body.path;
    let content = request.body.content;
    try {
        pathCheck(path);
        saveFileByPath(path, content)
        response.send(API_STATUS_CODE.ok());
    } catch (e) {
        logger.error("文件保存失败", e);
        response.send(API_STATUS_CODE.fail(`文件保存失败：${e.message}`,));
    }

});

/**
 * 重命名
 */
api.post('/rename', function (request, response) {
    let path = request.body.path;
    let name = request.body.name;
    try {
        pathCheck(path);
        fileRename(path, name)
        response.send(API_STATUS_CODE.ok());
    } catch (e) {
        logger.error("文件保存失败", e);
        response.send(API_STATUS_CODE.fail(`文件重命名失败：${e.message}`,));
    }

});

/**
 * 文件移动
 */
api.post('/move', function (request, response) {
    let oldPath = request.body.path;
    let newPath = request.body.newPath;
    try {
        pathCheck(oldPath);
        rootPathCheck(newPath)
        fileMove(oldPath, newPath)
        response.send(API_STATUS_CODE.ok());
    } catch (e) {
        logger.error("文件移动失败", e);
        response.send(API_STATUS_CODE.fail(`文件移动失败：${e.message}`,));
    }

});


/**
 * 文件创建
 * @param dir 目录
 * @param name 名称 含后缀
 * @param type 0 目录 1 文件
 * @param content 内容 非必填 如果 type = 0 该参数无效
 */
api.post('/create', function (request, response) {
    let dir = request.body.dir;
    let name = request.body.name;
    let type = request.body.type;
    let content = request.body.content || '';
    try {
        rootPathCheck(dir);
        response.send(API_STATUS_CODE.okData(fileCreate(dir, name, type, content)));
    } catch (e) {
        logger.error(`${type === 0 ? '目录' : '文件'}创建失败`, e);
        response.send(API_STATUS_CODE.fail(`${type === 0 ? '目录' : '文件'}创建失败：${e.message}`,));
    }

});

/**
 * 文件删除
 */
api.delete('/', function (request, response) {
    let path = request.body.path;
    try {
        pathCheck(path);
        fileDelete(path)
        response.send(API_STATUS_CODE.ok());
    } catch (e) {
        logger.error("文件删除失败", e);
        response.send(API_STATUS_CODE.fail(`文件删除失败：${e.message}`,));
    }

});

/**
 * 文件下载
 */
api.get('/download', function (request, response) {
    let path = request.query.path;
    try {
        pathCheck(path);
        fileDownload(path, response)
    } catch (e) {
        logger.error("文件下载失败", e);
        response.send(API_STATUS_CODE.fail(`文件下载失败：${e.message}`,));
    }

});

let upload = multer({
    storage: multer.diskStorage({
        destination: function (req, file, cb) {
            let savePath = req.query.path;
            rootPathCheck(savePath)
            let stat = null;
            try {
                stat = fs.statSync(savePath);
            } catch (err) {
                fs.mkdirSync(savePath);
            }
            if (stat && !stat.isDirectory()) {
                throw new Error("文件夹不存在");
            }
            cb(null, savePath);
        },
        filename: function (req, file, cb) {
            // 解决中文名乱码的问题
            file.originalname = Buffer.from(file.originalname, "latin1").toString(
                "utf8"
            );

            let savePath = req.query.path;
            let originalName = file.originalname;
            //文件操作限制
            if (path.join(savePath, originalName) === authConfigFile) {
                originalName = originalName + ".json";
            }
            cb(null, originalName)
        }
    })
});

/**
 * 单个文件上传
 */
api.post('/upload', upload.single('file'), (request, response) => {
    response.send(API_STATUS_CODE.ok({
        fileName: request.file.originalname,
        filePath: request.file.path
    }));
});

/**
 * 多个文件上传
 */
api.post('/upload/multi', upload.array('file'), (request, response) => {
    let fileList = request.files.map((elem) => {
        return {
            fileName: elem.originalname,
            filePath: elem.path
        }
    });
    response.send(API_STATUS_CODE.ok(fileList));
});

/**
 * 更新仓库
 */
api.post('/update/repo', async (request, response) => {
    sync.startSync("git", request.body.path, request.body.params).then((res) => {
        logger.log("更新仓库完成", request.query.path, res);
    })
    response.send(API_STATUS_CODE.ok());
});
api.post('/update/raw', async (request, response) => {
    sync.startSync("raw", request.body.path, request.params).then((res) => {
        logger.log("更新raw脚本完成", request.query.path, res);
    })
    response.send(API_STATUS_CODE.ok());
});

module.exports.fileAPI = api;