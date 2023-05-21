// type: 'success' | 'error' | 'warning';
let successCode = 1, errorCode = 0;
const API_STATUS_CODE = {
    ok(message = 'success', result) {
        return {
            code: successCode,
            result, message,
            type: 'success'
        }
    },
    okData(result) {
        return this.ok('success', result)
    },

    fail(message, code = errorCode) {
        return {
            code, message,
            type: 'error'
        }
    },
    failData(message = '系统错误', result) {
        return {
            message,
            result: result,
            code: errorCode,
            type: 'error',
        }
    },
    webHookOk(type = 'success', result) {
        return {
            code: 200,
            result: result,
            message: type
        }
    },
    webhookFail() {
        return {
            code: 400,
            message: '已成功获取到您的账号信息但未能将其同步至服务器，请联系管理员进行处理！'
        }
    },
    //-------------------------------以下为旧版本---------------------------------//
    okDataOld(data) {
        return {
            code: 1,
            data:data,
            msg: 'success'
        }
    },
    webHookOkOld(msg = 'success', data) {
        return {
            code: 200,
            data: data,
            message: msg
        }
    },
    failOld(msg = 'fail', code = 0, desc) {
        return {
            code: code,
            msg: msg,
            desc: desc
        }
    },
    API: {
        NEED_LOGIN: {
            code: 403,
            message: "请先登录!"
        },
        NO_PERMISSION: {
            code: 401,
            message: "无权限访问!"
        }
    },
    OPEN_API: {
        AUTH_FAIL: {
            code: 4403,
            type: "认证失败!"
        },
        NOT_OPEN: {
            code: 4406,
            type: "调用失败",
            message: "未设置开放接口密钥，不允许访问"
        }
    }
}

module.exports = {
    API_STATUS_CODE
}
