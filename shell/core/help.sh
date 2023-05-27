#!/bin/bash
## Modified: 2023-05-27

## 命令帮助
function print_help() {
    # armv7 不可使用的命令有 arcadia tgbot、task conc
    case "$1" in
    "${TaskCmd}")
        case ${ARCH} in
        armv7l | armv6l)
            echo -e "
❖ 处理任务指令

  命令帮助：

    ${BLUE}$TaskCmd run <name/path/url> [--options]${PLAIN}    ✧ 普通执行，前台运行并在命令行输出进度，命令选项的用法详见 ${BLUE}$TaskCmd run${PLAIN} 命令帮助
    ${BLUE}$TaskCmd stop <name/path>${PLAIN}                   ✧ 终止执行，根据脚本匹配对应的进程并立即杀死

    ${BLUE}$TaskCmd ps${PLAIN}                                 ✧ 查看设备资源消耗情况和正在运行的脚本进程
    ${BLUE}$TaskCmd rmlog${PLAIN}                              ✧ 删除一定天数的由项目和运行脚本产生的各类日志文件
    ${BLUE}$TaskCmd cleanup${PLAIN}                            ✧ 检测并终止卡死状态的脚本进程，以释放内存占用提高运行效率

    ${BLUE}$TaskCmd list <path>${PLAIN}                        ✧ 列出本地脚本清单，默认列出已配置的脚本，支持指定路径
    ${BLUE}$TaskCmd exsc${PLAIN}                               ✧ 导出互助码变量和助力格式，互助码从最后一个日志提取，受日志内容影响
    ${BLUE}$TaskCmd cookie <args>${PLAIN}                      ✧ 检测账号是否有效 ${BLUE}check${PLAIN}，更新wskey账号 ${BLUE}update${PLAIN}，获取收支 ${BLUE}beans${PLAIN}，查看账号列表 ${BLUE}list${PLAIN}
    ${BLUE}$TaskCmd notify <title> <content>${PLAIN}           ✧ 自定义推送通知消息，参数为标题加内容，支持转义字符

  命令注释：

    ${BLUE}<args>${PLAIN} 子命令  ${BLUE}<name>${PLAIN} 脚本名(仅scripts目录)  ${BLUE}<path>${PLAIN} 相对路径或绝对路径  ${BLUE}<url>${PLAIN} 链接地址  ${BLUE}[--options]${PLAIN} 命令选项
"
            ;;
        *)
            echo -e "
❖ 处理任务指令

  命令帮助：

    ${BLUE}$TaskCmd run <name/path/url> [--options]${PLAIN}    ✧ 普通执行，前台运行并在命令行输出进度，命令选项的用法详见 ${BLUE}$TaskCmd run${PLAIN} 命令帮助
    ${BLUE}$TaskCmd conc <name/path/url> [--options]${PLAIN}   ✧ 并发执行，后台运行不在命令行输出进度，命令选项的用法详见 ${BLUE}$TaskCmd conc${PLAIN} 命令帮助
    ${BLUE}$TaskCmd stop <name/path>${PLAIN}                   ✧ 终止执行，根据脚本匹配对应的进程并立即杀死

    ${BLUE}$TaskCmd ps${PLAIN}                                 ✧ 查看设备资源消耗情况和正在运行的脚本进程
    ${BLUE}$TaskCmd rmlog${PLAIN}                              ✧ 删除一定天数的由项目和运行脚本产生的各类日志文件
    ${BLUE}$TaskCmd cleanup${PLAIN}                            ✧ 检测并终止卡死状态的脚本进程，以释放内存占用提高运行效率

    ${BLUE}$TaskCmd list <path>${PLAIN}                        ✧ 列出本地脚本清单，默认列出已配置的脚本，支持指定路径
    ${BLUE}$TaskCmd exsc${PLAIN}                               ✧ 导出互助码变量和助力格式，互助码从最后一个日志提取，受日志内容影响
    ${BLUE}$TaskCmd cookie <args>${PLAIN}                      ✧ 检测账号是否有效 ${BLUE}check${PLAIN}，更新wskey账号 ${BLUE}update${PLAIN}，获取收支 ${BLUE}beans${PLAIN}，查看账号列表 ${BLUE}list${PLAIN}
    ${BLUE}$TaskCmd notify <title> <content>${PLAIN}           ✧ 自定义推送通知消息，参数为标题加内容，支持转义字符

  命令注释：

    ${BLUE}<args>${PLAIN} 子命令  ${BLUE}<name>${PLAIN} 脚本名(仅scripts目录)  ${BLUE}<path>${PLAIN} 相对路径或绝对路径  ${BLUE}<url>${PLAIN} 链接地址  ${BLUE}[--options]${PLAIN} 命令选项
"
            ;;
        esac
        ;;
    "${TaskCmd}_run")
        echo -e "
❖ 普通执行脚本命令

  使用方法：

    ${BLUE}$TaskCmd run <name/path/url> [--options]${PLAIN}   
       
  命令选项：

    ${BLUE}-l${PLAIN},  ${BLUE}--loop${PLAIN}              循环运行，连续多次的执行脚本，参数后需跟循环次数
    ${BLUE}-m${PLAIN},  ${BLUE}--mute${PLAIN}              静默运行，不推送任何通知消息
    ${BLUE}-w${PLAIN},  ${BLUE}--wait${PLAIN}              等待执行，等待指定时间后再运行任务，参数后需跟时间值
    ${BLUE}-h${PLAIN},  ${BLUE}--hang${PLAIN}              后台挂起，将脚本设置为守护进程保持在后台运行，期间中断或结束会自动重新运行
    ${BLUE}-a${PLAIN},  ${BLUE}--agent${PLAIN}             网络代理，使脚本通过 HTTP/HTTPS 全局代理进行网络请求，仅支持 JavaScript/TypeScript 脚本
    ${BLUE}-d${PLAIN},  ${BLUE}--delay${PLAIN}             延迟执行，随机倒数一定秒数后再执行脚本
    ${BLUE}-p${PLAIN},  ${BLUE}--proxy${PLAIN}             下载代理，仅适用于执行位于 GitHub 仓库的脚本，代理固定为 jsDelivr CDN
    ${BLUE}-c${PLAIN},  ${BLUE}--cookie${PLAIN}            指定账号，参数后需跟账号序号，多个账号用 \",\" 隔开，账号区间用 \"-\" 连接，可以用 \"%\" 表示账号总数
    ${BLUE}-g${PLAIN},  ${BLUE}--grouping${PLAIN}          账号分组，每组账号单独运行脚本，参数后需跟账号序号并分组，参数用法跟指定账号一样，组与组之间用 \"@\" 隔开
    ${BLUE}-b${PLAIN},  ${BLUE}--background${PLAIN}        后台运行，不在前台输出脚本执行进度，不占用终端命令行
"
        ;;
    "${TaskCmd}_conc")
        echo -e "
❖ 并发执行脚本命令

  使用方法：

    ${BLUE}$TaskCmd conc <name/path/url> [--options]${PLAIN}        
       
  命令选项：

    ${BLUE}-m${PLAIN},  ${BLUE}--mute${PLAIN}              静默运行，不推送任何通知消息
    ${BLUE}-w${PLAIN},  ${BLUE}--wait${PLAIN}              等待执行，等待指定时间后再运行任务，参数后需跟时间值
    ${BLUE}-a${PLAIN},  ${BLUE}--agent${PLAIN}             网络代理，使脚本通过 HTTP/HTTPS 全局代理进行网络请求，仅支持 JavaScript/TypeScript 脚本
    ${BLUE}-d${PLAIN},  ${BLUE}--delay${PLAIN}             延迟执行，随机倒数一定秒数后再执行脚本
    ${BLUE}-p${PLAIN},  ${BLUE}--proxy${PLAIN}             下载代理，仅适用于执行位于 GitHub 仓库的脚本，代理固定为 jsDelivr CDN
    ${BLUE}-c${PLAIN},  ${BLUE}--cookie${PLAIN}            指定账号，参数后需跟账号序号，多个账号用 \",\" 隔开，账号区间用 \"-\" 连接，可以用 \"%\" 表示账号总数
"
        ;;
    "${ContrlCmd}")
        case ${ARCH} in
        armv7l | armv6l)
            echo -e "
❖ 核心指令

  命令帮助：

    ${BLUE}$ContrlCmd repo <name> <url> <branch> [--options]${PLAIN}   ✧ 导入脚本仓库配置，其它配置项通过命令选项控制，具体详见 ${BLUE}$ContrlCmd repo${PLAIN} 命令帮助
    ${BLUE}$ContrlCmd raw <name> <url> [--options]${PLAIN}             ✧ 导入远程脚本配置，其它配置项通过命令选项控制，具体详见 ${BLUE}$ContrlCmd raw${PLAIN} 命令帮助

    ${BLUE}$ContrlCmd service <args>${PLAIN}                           ✧ 后台管理面板和网页终端功能控制，开启或重启 ${BLUE}start${PLAIN}，关闭 ${BLUE}stop${PLAIN}，登录信息 ${BLUE}info${PLAIN}，重置密码 ${BLUE}respwd${PLAIN}
    ${BLUE}$ContrlCmd server status${PLAIN}                            ✧ 查看各服务的详细信息，包括运行状态，创建时间，处理器占用，内存占用，运行时长

    ${BLUE}$ContrlCmd env <args>${PLAIN}                               ✧ 处理运行脚本依赖相关命令，安装 ${BLUE}install${PLAIN}，修复 ${BLUE}repairs${PLAIN}
    ${BLUE}$ContrlCmd check config${PLAIN}                             ✧ 检查项目相关配置文件完整性，如果缺失就从模板导入

  命令注释：

    ${BLUE}<args>${PLAIN} 子命令  ${BLUE}<name>${PLAIN} 配置名称  ${BLUE}<url>${PLAIN} 链接地址  ${BLUE}<branch>${PLAIN} 分支名称  ${BLUE}[--options]${PLAIN} 命令选项
"
            ;;
        *)
            echo -e "
❖ 核心指令

  命令帮助：

    ${BLUE}$ContrlCmd repo <name> <url> <branch> [--options]${PLAIN}   ✧ 导入脚本仓库配置，其它配置项通过命令选项控制，具体详见 ${BLUE}$ContrlCmd repo${PLAIN} 命令帮助
    ${BLUE}$ContrlCmd raw <name> <url> [--options]${PLAIN}             ✧ 导入远程脚本配置，其它配置项通过命令选项控制，具体详见 ${BLUE}$ContrlCmd raw${PLAIN} 命令帮助

    ${BLUE}$ContrlCmd service <args>${PLAIN}                           ✧ 后台管理面板和网页终端功能控制，开启或重启 ${BLUE}start${PLAIN}，关闭 ${BLUE}stop${PLAIN}，登录信息 ${BLUE}info${PLAIN}，重置密码 ${BLUE}respwd${PLAIN}
    ${BLUE}$ContrlCmd tgbot <args>${PLAIN}                             ✧ 电报机器人功能控制，启动或重启 ${BLUE}start${PLAIN}，停止 ${BLUE}stop${PLAIN}，查看日志 ${BLUE}logs${PLAIN}，更新升级 ${BLUE}update${PLAIN}
    ${BLUE}$ContrlCmd server status${PLAIN}                            ✧ 查看各服务的详细信息，包括运行状态，创建时间，处理器占用，内存占用，运行时长

    ${BLUE}$ContrlCmd env <args>${PLAIN}                               ✧ 处理运行脚本依赖相关命令，安装 ${BLUE}install${PLAIN}，修复 ${BLUE}repairs${PLAIN}
    ${BLUE}$ContrlCmd check config${PLAIN}                             ✧ 检查项目相关配置文件完整性，如果缺失就从模板导入

  命令注释：

    ${BLUE}<args>${PLAIN} 子命令  ${BLUE}<name>${PLAIN} 配置名称  ${BLUE}<url>${PLAIN} 链接地址  ${BLUE}<branch>${PLAIN} 分支名称  ${BLUE}[--options]${PLAIN} 命令选项
"
            ;;
        esac
        ;;
    "${ContrlCmd}_repo")
        echo -e "
❖ 导入脚本仓库配置命令

  使用方法：

    ${BLUE}$ContrlCmd repo <name> <url> <branch> [--options]${PLAIN}

  命令选项：

    ${BLUE}--enable${PLAIN}             是否启用仓库
    ${BLUE}--updateTaskList${PLAIN}     是否更新定时任务
    ${BLUE}--scriptsPath${PLAIN}        定时脚本路径
    ${BLUE}--scriptsType${PLAIN}        定时脚本文件格式，多个用 \"|\" 分开
    ${BLUE}--whiteList${PLAIN}          定时脚本匹配白名单
    ${BLUE}--blackList${PLAIN}          定时脚本匹配黑名单
    ${BLUE}--autoDisable${PLAIN}        是否自动禁用新的定时任务
    ${BLUE}--addNotify${PLAIN}          是否为新增定时任务推送通知提醒
    ${BLUE}--delNotify${PLAIN}          是否为过期定时任务推送通知提醒
    ${BLUE}--help${PLAIN}               查看命令帮助
"
        ;;
    "${ContrlCmd}_raw")
        echo -e "
❖ 导入远程脚本配置命令

  使用方法：

    ${BLUE}$ContrlCmd raw <name> <url> [--options]${PLAIN}

  命令选项：

    ${BLUE}--updateTaskList${PLAIN}     是否更新定时任务
    ${BLUE}--help${PLAIN}               查看命令帮助
"
        ;;
    "${UpdateCmd}")
        echo -e "
❖ 更新指令

  使用方法：

    ${BLUE}$UpdateCmd all${PLAIN}        ✧ 更新全部内容，包括下列除指定仓库以外的所有内容
    ${BLUE}$UpdateCmd source${PLAIN}     ✧ 更新项目源码，包括项目源码，所有仓库和脚本，自定义脚本等
    ${BLUE}$UpdateCmd repo${PLAIN}       ✧ 更新脚本仓库，包括项目源码，所有仓库和脚本，自定义脚本等
    ${BLUE}$UpdateCmd raw${PLAIN}        ✧ 更新远程脚本，包括项目源码，所有仓库和脚本，自定义脚本等
    ${BLUE}$UpdateCmd extra${PLAIN}      ✧ 执行自定义更新脚本，包括项目源码，所有仓库和脚本，自定义脚本等
    ${BLUE}$UpdateCmd <path>${PLAIN}     ✧ 更新指定路径下的脚本仓库，包括项目源码，所有仓库和脚本，自定义脚本等

  命令注释：

    ${BLUE}<path>${PLAIN} 相对路径或绝对路径
"
        ;;
"${EnvManageCmd}")
        echo -e "
❖ 用户环境变量管理指令

  使用方法：

    ${BLUE}$EnvManageCmd add [<name> <value> <remark>]${PLAIN}    ✧ 添加变量
    ${BLUE}$EnvManageCmd edit [<name> <value> <remark>]${PLAIN}   ✧ 修改变量
    ${BLUE}$EnvManageCmd del [<name>]${PLAIN}                     ✧ 删除变量
    ${BLUE}$EnvManageCmd search [<string>]${PLAIN}                ✧ 查询变量
    ${BLUE}$EnvManageCmd enable <name>${PLAIN}                    ✧ 启用变量
    ${BLUE}$EnvManageCmd disable <name>${PLAIN}                   ✧ 禁用变量

  命令注释：

    ${BLUE}[xxx]${PLAIN} 可选的快捷子命令  ${BLUE}<name>${PLAIN} 环境变量名称  ${BLUE}<value>${PLAIN} 环境变量值  ${BLUE}<remark>${PLAIN} 环境变量备注  ${BLUE}<string>${PLAIN} 搜索关键字
"
;;
    esac
}
