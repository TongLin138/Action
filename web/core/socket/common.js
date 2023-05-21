const socketCommon = {
    getSocket() {
        return global.io;
    },
    setSocket(io) {
        global.io = io;
    },
    emit(name, data) {
        let io = this.getSocket()
        if (io) {
            io.emit(name, data)
        }
    }
}
module.exports = socketCommon;