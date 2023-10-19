const { Server } = require('socket.io')
const jwt = require('jsonwebtoken')
const { logger } = require('../logger')
const { CONFIG_FILE_KEY, getJsonFile } = require('../file')
let authConfig = getJsonFile(CONFIG_FILE_KEY.AUTH)
let jwtSecret = authConfig['jwtSecret']
let getToken = function fromHeaderOrQuerystring(request) {
    if (request.headers.authorization && request.headers.authorization.split(' ')[0] === 'Bearer') {
        return request.headers.authorization.split(' ')[1]
    } else if (request.query && request.query.token) {
        return request.query.token
    }
    return null
}

module.exports = (server, sessionMiddleware) => {
    const io = new Server(server, {
        cors: true,
        path: '/api/ws',
        allowEIO3: true,
    })

    // convert a connect middleware to a Socket.IO middleware
    const wrap = (middleware) => (socket, next) => middleware(socket.request, {}, next)

    io.use(wrap(sessionMiddleware))

    // only allow authenticated users
    io.use((socket, next) => {
        const token = getToken(socket.request)
        if (token) {
            jwt.verify(token, jwtSecret, (err, decoded) => {
                if (err) {
                    next(new Error('unauthorized'))
                } else {
                    socket.request.user = decoded
                    next()
                }
            })
        } else {
            next(new Error('unauthorized'))
        }
    })

    io.on('connection', (socket) => {
        // const user = socket.request.user
        logger.info(`用户已建立 WebSocket 连接`)
    })
    return io
}
