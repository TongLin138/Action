## Version: v1.0.0
## Date: 2023-05-01
## Update Content: New

# ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ 自 定 义 环 境 变 量 设 置 区 域 ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ #
# 可在下方编写你需要用到的环境变量，格式：export 变量名="变量值"




# ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ 账 号 设 置 区 域 ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ #

# 注意：所有赋值等号两边不能有空格，所有的值请一律在两侧添加半角的双引号，如果变量值中含有双引号，则外侧改为一对半角的单引号。

## ※ 定义账号（必填）
# 请依次填入每个用户的Cookie，具体格式为( pt_key=xxxxxxxxxx;pt_pin=xxxx; )，只有 pt_key 字段和 pt_pin 字段，没有其他字段
# 必须按数字顺序1、2、3、4...依次编号下去，账号变量之间不能有空变量，否则自第一个空变量开始下面的所有账号将不会生效
# 在用户名中不允许填入汉字，如果有请通过面板的转码工具进行转换为URL编码
Cookie1=""
## 用户名=无;  联系方式：无;  上次更新：无;  备注：无;
Cookie2=""
## 用户名=无;  联系方式：无;  上次更新：无;  备注：无;


## ❖ 账号屏蔽功能（选填）
# 可以使用此功能在不调整 Cookie 账号变量的的前提下屏蔽掉目标账号，变量中需填写目标屏蔽账号对应 Cookie 序号或 pt_pin 用户名
# 注意该功能仅在默认使用全部账号运行脚本时有效，在使用指定账号参数或分组账号参数运行脚本时所有屏蔽设置均不会生效
# 示例：TempBlockCookie="2 test_user" 临时屏蔽掉账号2和用户名为 test_user 的账号，多个用空格分开不分前后顺序
TempBlockCookie=""

# 如果只想屏蔽某账号不执行特定脚本，可以参考下方 case 语句的例子来控制
# 注意代码缩进和该 case 语句的语法，脚本名称需去掉后缀格式，否则不能被程序识别
# 代码示例：
# case $1 in
# test)
#   TempBlockCookie="test_user"     # 用户名为 test_user 的账号不执行 test 脚本
#   ;;
# example | warp)
#   TempBlockCookie="3 6"     # 账号3、账号6不执行 example 和 warp 脚本
#   ;;
# esac


## ❖ 自动增加新的账号
# 控制通过调用面板 OpenApi 接口或使用本项目其它添加账号工具后是否自动添加新的 Cookie 账号
# 默认已启用，如想禁用请修改为 "false"，可避免自动添加陌生人的账号，也可以防止被滥用
export CK_AUTO_ADD="true"




# ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ 项 目 功 能 设 置 区 域 ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ #

## ❖ 1. 控制删除日志时间
# 定义在运行删除旧的日志任务时要删除多少天以前的日志，请输入正整数，不填则禁用删除日志的功能
RmLogDaysAgo="7"

## ❖ 2. 自定义 Extra 脚本功能
# 在每次执行更新脚本时额外运行的 Shell 脚本
# 必须将脚本命名为 "extra.sh" 并且放置在 config 目录下
# 如想启用请赋值为 "true"
EnableExtraShell=""
# 定义 Extra 自定义脚本远程同步功能：
#   1). 功能开关，如想启用请赋值为 "true"
EnableExtraShellSync=""
#   2). 同步地址
ExtraShellSyncUrl=""

## ❖ 3. 更新账号推送通知
# 控制当使用 wskey 更新 Cookie 后是否推送更新结果内容
# 默认不推送，如想要接收推送通知提醒请赋值为 "true"
EnableCookieUpdateNotify=""

## ❖ 4. 更新账号异常告警
# 控制当使用 wskey 更新 Cookie 失败后是否推送通知提醒，以用于快速处理失效的 wskey
# 默认不推送，如想要接收推送通知提醒请赋值为 "true"
EnableCookieUpdateFailureNotify=""

## ❖ 5. 控制是否保存远程执行的脚本
# 控制当 task run <url> 任务执行完毕后是否删除脚本（下载的脚本默认存放在 scripts 目录），即是否本地保存执行的脚本
# 默认不删除，如想要自动删除请赋值为 "true"
AutoDelRawFiles=""

## ❖ 6. 脚本全局代理
# Powered by global-agent (仅支持 js 脚本)
# 官方仓库：https://github.com/gajus/global-agent
# 官方文档：https://www.npmjs.com/package/global-agent
# 全局代理，如想全局启用代理请赋值为 "true"
EnableGlobalProxy=""

# 如果只是想在执行部分脚本时使用代理，可以参考下方 case 语句的例子来控制，脚本名称请去掉后缀格式，同时注意代码缩进
# case $1 in
# test)
#   EnableGlobalProxy="true"    ## 在执行 test 脚本时启用代理
#   ;;
# utils | warp)
#   EnableGlobalProxy="true"    ## 在执行 utils 和 warp 脚本时启用代理
#   ;;
# *)
#   EnableGlobalProxy="false"
#   ;;
# esac

## 定义 HTTP 代理地址（必填）
# 如需使用，请自行解除下一行的注释并赋值并赋值
# export GLOBAL_AGENT_HTTP_PROXY=""

## 定义 HTTPS 代理地址，为 HTTPS 请求指定单独的代理（选填）
# 如果未设置此变量那么两种协议的请求均通过 HTTP 代理地址变量设定的地址
# 如需使用，请自行解除下一行的注释并赋值并赋值
# export GLOBAL_AGENT_HTTPS_PROXY=""

## ❖ 7. 自定义推送通知模块功能
# 默认使用项目提供的 sendNotify.js 推送通知模块，配置教程详见官网 https://arcadia.cool/docs/configuration/notify
# 如想使用第三方推送通知模块请将下方变量赋值为 "true" ，并在 config 目录下存放你的 sendNotify.js 脚本
# 注意如若使用第三方通知模块可能会出现兼容性问题导致项目部分功能不可用
EnableCustomNotify=""




# ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ 推 送 通 知 设 置 区 域 ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ #

# 在下方定义推送通知方式，想通过什么渠道收取通知，就填入对应渠道的值，你也可以同时使用多个渠道获取通知
# 目前提供：Server酱、Bark、Telegram、钉钉、企业微信、iGot、pushplus、go-cqhttp、WxPusher
# 项目文档：https://arcadia.cool/docs/configuration/notify

## ❖ 定义通知尾
export NOTIFY_TAIL="❖ 本通知 By：https://github.com/SuperManito/Arcadia"

## ❖ 通知内容屏蔽关键词，多个词用 "&" 连接，注意屏蔽针对的是内容而不是通知标题
export NOTIFY_MASKING=""

## ❖ 1. Server酱
# 官网：https://sct.ftqq.com
# 下方填写 SCHKEY 值或 SendKey 值
export PUSH_KEY=""
# 自建Server酱
export SCKEY_WECOM=""
export SCKEY_WECOM_URL=""


## ❖ 2. Bark
# 下方填写app提供的设备码，例如：https://api.day.app/123 那么此处的设备码就是123
export BARK_PUSH=""
# 下方填写推送声音设置，例如choo，具体值请在bark-推送铃声-查看所有铃声
export BARK_SOUND=""
# 下方填写推送消息分组，默认为 "Arcadia"，推送成功后可以在bark-历史消息-右上角文件夹图标查看
export BARK_GROUP=""


## ❖ 3. Telegram
# 需设备可连接外网，"TG_BOT_TOKEN" 和 "TG_USER_ID" 必须同时赋值
# 下方填写自己申请 @BotFather 的 Token，如 10xxx4:AAFcqxxxxgER5uw
export TG_BOT_TOKEN=""
# 下方填写 @getuseridbot 中获取到的纯数字ID
export TG_USER_ID=""
# Telegram 代理IP（选填）
# 下方填写代理IP地址，代理类型为 http，比如你代理是 http://127.0.0.1:1080，则填写 "127.0.0.1"
# 如需使用，请自行解除下一行的注释并赋值
# export TG_PROXY_HOST=""
# Telegram 代理端口（选填）
# 下方填写代理端口号，代理类型为 http，比如你代理是 http://127.0.0.1:1080，则填写 "1080"
# 如需使用，请自行解除下一行的注释并赋值
# export TG_PROXY_PORT=""
# Telegram 代理的认证参数（选填）
# export TG_PROXY_AUTH=""
# Telegram api自建反向代理地址（选填）
# 教程：https://www.hostloc.com/thread-805441-1-1.html
# 如反向代理地址 http://aaa.bbb.ccc 则填写 aaa.bbb.ccc
# 如需使用，请赋值代理地址链接，并自行解除下一行的注释
# export TG_API_HOST=""


## ❖ 4. 钉钉
# 官方文档：https://developers.dingtalk.com/document/app/custom-robot-access
# 参考图片：https://github.com/chinnkarahoi/jd_scripts/blob/master/icon/DD_bot.png
# "DD_BOT_TOKEN" 和 "DD_BOT_SECRET" 必须同时赋值
# 下方填写token后面的内容，只需 https://oapi.dingtalk.com/robot/send?access_token=XXX 等于=符号后面的XXX即可
export DD_BOT_TOKEN=""
# 下方填写密钥，机器人安全设置页面，加签一栏下面显示的 SEC 开头的 SECXXXXXXXXXX 等字符
# 注:钉钉机器人安全设置只需勾选加签即可，其他选项不要勾选
export DD_BOT_SECRET=""


## ❖ 5. 企业微信 - 机器人
# 官方文档：https://work.weixin.qq.com/api/doc/90000/90136/91770
# 下方填写密钥，企业微信推送 webhook 后面的 key
export QYWX_KEY=""


## ❖ 6. 企业微信 - 应用
# 参考文档：http://note.youdao.com/s/HMiudGkb
#          http://note.youdao.com/noteshare?id=1a0c8aff284ad28cbd011b29b3ad0191
# 下方填写素材库图片id（corpid,corpsecret,touser,agentid），素材库图片填0为图文消息, 填1为纯文本消息
export QYWX_AM=""


## ❖ 7. iGot聚合
# 官方文档：https://wahao.github.io/Bark-MP-helper
# 下方填写iGot的推送key，支持多方式推送，确保消息可达
export IGOT_PUSH_KEY=""


## ❖ 8. pushplus
# 官网：http://www.pushplus.plus
# 下方填写你的Token，微信扫码登录后一对一推送或一对多推送下面的 token，只填 "PUSH_PLUS_TOKEN" 默认为一对一推送
export PUSH_PLUS_TOKEN=""
# 一对一多推送（选填）
# 下方填写你的一对多推送的 "群组编码" ，（一对多推送下面->你的群组(如无则新建)->群组编码）
# 注 1. 需订阅者扫描二维码
#    2、如果你是创建群组所属人，也需点击“查看二维码”扫描绑定，否则不能接受群组消息推送
export PUSH_PLUS_USER=""


## ❖ 9. go-cqhttp
# 官方仓库：https://github.com/Mrs4s/go-cqhttp
# 官方文档：https://docs.go-cqhttp.org/api/
# 官方搭建教程：https://docs.go-cqhttp.org/guide/quick_start.html
# 需要自建服务，默认监听地址：127.0.0.1:5700，下方填写你服务的监听地址
export GO_CQHTTP_URL=""
# 下方填写接收消息的QQ或QQ群
export GO_CQHTTP_QQ=""
# 下方填写 "send_private_msg" 或 "send_group_msg" 的值
export GO_CQHTTP_METHOD=""
# 下方填写分开推送的脚本名，如需使用请赋值并自行解除下一行的注释
# export GO_CQHTTP_SCRIPTS=""
# 下方填写外网扫码地址，如需使用请赋值并自行解除下一行的注释
# export GO_CQHTTP_LINK=""
# 下方填写消息分页字数，默认每 "1500" 字分为一条信息，如需修改请在赋值下面的变量
export GO_CQHTTP_MSG_SIZE=""
# 下方填写当账号失效后是否启用私信，默认启用，如需关闭请修改为 "false"
# 由于在账号失效后一般会批量群发，有可能触发风控下线或者封号，不建议禁用
# export GO_CQHTTP_EXPIRE_SEND_PRIVATE=""


## ❖ 10. WxPusher
# 官方仓库：https://github.com/wxpusher/wxpusher-client
# 官方文档：https://wxpusher.zjiecode.com/docs
# 微信公众号：WxPusher 消息推送平台
# 下方填写你申请的 appToken，可在管理台查看：https://wxpusher.zjiecode.com/admin/main/app/appToken
export WP_APP_TOKEN=""
# 下方填写发送目标用户的UID，多个用户用 ";" 分隔，WP_UIDS 和 WP_TOPICIDS 可以同时填写, 也可以只填写一个
export WP_UIDS=""
# 下方填写发送主题的 TopicId ，适用于群发，用户只需要订阅主题即可，多个主题用 ";" 分隔，使用 WP_UIDS 单独发送的时可以不定义此变量
export WP_TOPICIDS=""
# 下方填写原文链接，如需使用请赋值并自行解除下一行的注释
# export WP_URL=""
