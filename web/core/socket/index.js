const {logger} = require("../logger");
const {Server} = require("socket.io")

module.exports = (server, sessionMiddleware) => {
    const io = new Server(server, {
        cors: true,
        path: '/api/ws',
        allowEIO3: true
    });

    // convert a connect middleware to a Socket.IO middleware
    const wrap = middleware => (socket, next) => middleware(socket.request, {}, next);

    io.use(wrap(sessionMiddleware));

    // only allow authenticated users
    io.use((socket, next) => {
        const user = socket.request.user;
        if (user && user.username) {
            next();
        } else {
            next(new Error("unauthorized"));
        }
    });

    io.on("connection", (socket) => {
        const user = socket.request.user;
        logger.info(`用户 ${user.username} 已连接`)
    });
    return io;
}

