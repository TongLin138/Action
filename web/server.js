const express = require('express');
const compression = require('compression');
const expressJwt = require('express-jwt')
const jwt = require("jsonwebtoken");
const bodyParser = require('body-parser');
const path = require('path');
const random = require('string-random');
const {
    createProxyMiddleware
} = require('http-proxy-middleware');

const {
    extraServerFile,
    checkConfigFile,
    CONFIG_FILE_KEY,
    getJsonFile, saveNewConf,
} = require("./core/file");

const {API_STATUS_CODE} = require("./core/http");

const app = express();
const server = require("http").createServer(app);

// gzip压缩
app.use(compression({
    level: 6,
    filter: shouldCompress
}));

function shouldCompress(req, res) {
    if (req.headers['x-no-compression']) {
        return false;
    }
    return compression.filter(req, res);
}

let authConfig = getJsonFile(CONFIG_FILE_KEY.AUTH);
let jwtSecret = authConfig["jwtSecret"];
if (!jwtSecret || jwtSecret === "") {
    jwtSecret = random(32);
    authConfig["jwtSecret"] = jwtSecret;
    saveNewConf(CONFIG_FILE_KEY.AUTH, authConfig);
}
let getToken = function fromHeaderOrQuerystring(req) {
    if (
        req.headers.authorization &&
        req.headers.authorization.split(" ")[0] === "Bearer"
    ) {
        return req.headers.authorization.split(" ")[1];
    } else if (req.query && req.query.token) {
        return req.query.token;
    }
    return null;
};
let sessionMiddleware = expressJwt({
    secret: jwtSecret,
    algorithms: ['HS256'],
    credentialsRequired: true,
    getToken: getToken
}).unless({
    path: [
        '/',
        '/index.html',
        '/favicon.ico',
        '/_app.config.js',
        /^\/resource\/*/,
        /^\/assets\/*/,
        '/api/common/cookie/check',
        '/api/common/health',
        '/api/user/auth',
        '/api/captcha',
        /^\/api\/captcha\/.*/,
    ]  // 指定路径不经过 Token 解析
})

app.use('*', require('cors')())
app.use(bodyParser.json({
    limit: '50mb'
}));
app.use(bodyParser.urlencoded({
    limit: '50mb',
    extended: true
}));
app.use(express.static(path.join(__dirname, 'public')));

app.use(
    '/api/shell',
    createProxyMiddleware({
        target: 'http://127.0.0.1:7685',
        ws: true,
        changeOrigin: true,
        pathRewrite: {
            '^/shell': '/',
        },
        onProxyReq: function(proxyReq, req, res) {
            const token = getToken(req);
            if (token) {
                jwt.verify(token, jwtSecret, function(err, decoded) {
                    if (err) {
                        // JWT 验证失败
                        res.send(API_STATUS_CODE.fail(API_STATUS_CODE.API.NEED_LOGIN.message, API_STATUS_CODE.API.NEED_LOGIN.code));
                    } else {
                        // JWT 验证成功
                        proxyReq.setHeader('Authorization', token); // 将 token 传递给目标服务器
                    }
                });
            } else {
                res.send(API_STATUS_CODE.fail(API_STATUS_CODE.API.NEED_LOGIN.message, API_STATUS_CODE.API.NEED_LOGIN.code));
            }
        }
    })
);
app.use('/api/cronFile', require("./api/cron").cronFileAPI);

const {openAPI, openApiHandler} = require("./api/open");
app.use('/api/open', openApiHandler, openAPI);
app.use('/openApi', openApiHandler, require("./api/open_old").openOldAPI);

app.use(sessionMiddleware);
app.use(function (err, req, res, next) {
    if (err.name === 'UnauthorizedError') {
        res.send(API_STATUS_CODE.fail(API_STATUS_CODE.API.NEED_LOGIN.message, API_STATUS_CODE.API.NEED_LOGIN.code));
    }
    next();
});




app.use('/api', require("./api/main").mainAPI);
app.use('/api/config', require("./api/config").configAPI);
app.use('/api/file', require("./api/file").fileAPI);
app.use('/api/user', require("./api/user").userAPI);
app.use('/api/cron', require("./api/cron").cronAPI);
app.use('/api/common', require("./api/common").commonAPI);
app.use('/api/config', require("./api/configs").configAPI);


/**
 * socket init
 */
const {setSocket} = require("./core/socket/common");
setSocket(require("./core/socket")(server, sessionMiddleware))

checkConfigFile();

// 调用自定义api
try {
    require.resolve(extraServerFile);
    const extraServer = require(extraServerFile);
    if (typeof extraServer === 'function') {
        extraServer(app);
        console.log('用户自定义API => 初始化成功');
    }
} catch (e) {
}

server.listen(5678, '0.0.0.0', () => {
    console.log('应用正在监听 5678 端口!');
});

