#!/bin/bash
## Modified: 2023-05-27

## 命令帮助
function Help() {
    case $1 in
    task)
        case ${ARCH} in
        armv7l | armv6l)
            echo -e "
❖ 主要指令：

   ${BLUE}$TaskCmd <name/path/url> now${PLAIN}          ✧ 普通执行，前台运行并在命令行输出进度，可选参数(支持多个，加在末尾)：${BLUE}-<l/m/w/h/d/p/r/c/g/b>${PLAIN}
   ${BLUE}$TaskCmd <name/path> pkill${PLAIN}            ✧ 终止执行，根据脚本匹配对应的进程并立即杀死，当脚本报错死循环时建议使用
   ${BLUE}source runall${PLAIN}                     ✧ 全部执行，在选择运行模式后执行指定范围的脚本(交互)，非常耗时不要盲目使用

   ${BLUE}$TaskCmd ps${PLAIN}                           ✧ 查看设备资源消耗情况和正在运行的脚本进程
   ${BLUE}$TaskCmd rmlog${PLAIN}                        ✧ 删除一定天数的由项目和运行脚本产生的各类日志文件
   ${BLUE}$TaskCmd cleanup${PLAIN}                      ✧ 检测并终止卡死状态的脚本进程，以释放内存占用提高运行效率

   ${BLUE}$TaskCmd list${PLAIN}                         ✧ 列出本地脚本清单，默认列出已配置的脚本，支持指定路径
   ${BLUE}$TaskCmd exsc${PLAIN}                         ✧ 导出互助码变量和助力格式，互助码从最后一个日志提取，受日志内容影响
   ${BLUE}$TaskCmd cookie <args>${PLAIN}                ✧ 检测账号是否有效 ${BLUE}check${PLAIN}，使用wskey更新账号 ${BLUE}update${PLAIN}，获取账号收支 ${BLUE}beans${PLAIN}，查看本地账号清单 ${BLUE}list${PLAIN}
   ${BLUE}$TaskCmd env <args>${PLAIN}                   ✧ 管理全局环境变量功能(交互)，添加 ${BLUE}add${PLAIN}，删除 ${BLUE}del${PLAIN}，修改 ${BLUE}edit${PLAIN}，查询 ${BLUE}search${PLAIN}，支持快捷命令
   ${BLUE}$TaskCmd notify <title> <content> ${PLAIN}    ✧ 自定义推送通知消息，参数为标题加内容，支持转义字符

❋ 指令参数注释：

    ${BLUE}<name>${PLAIN} 脚本名（仅限scripts目录）;  ${BLUE}<path>${PLAIN} 相对路径或绝对路径;  ${BLUE}<url>${PLAIN} 脚本链接地址;  ${BLUE}<args>${PLAIN} 固定可选的子命令

❋ 命令选项：

   ${BLUE}-l${PLAIN} 或 ${BLUE}--loop${PLAIN}          循环运行，连续多次的执行脚本，参数后需跟循环次数
   ${BLUE}-m${PLAIN} 或 ${BLUE}--mute${PLAIN}          静默运行，不推送任何通知消息
   ${BLUE}-w${PLAIN} 或 ${BLUE}--wait${PLAIN}          等待执行，等待指定时间后再运行任务，参数后需跟时间值
   ${BLUE}-h${PLAIN} 或 ${BLUE}--hang${PLAIN}          后台挂起，将脚本设置为守护进程保持在后台运行，期间中断或结束会自动重新运行
   ${BLUE}-d${PLAIN} 或 ${BLUE}--delay${PLAIN}         延迟执行，随机倒数一定秒数后再执行脚本
   ${BLUE}-p${PLAIN} 或 ${BLUE}--proxy${PLAIN}         下载代理，仅适用于执行位于 GitHub 仓库的脚本
   ${BLUE}-c${PLAIN} 或 ${BLUE}--cookie${PLAIN}        指定账号，参数后需跟账号序号，多个账号用 \",\" 隔开，账号区间用 \"-\" 连接，可以用 \"%\" 表示账号总数
   ${BLUE}-g${PLAIN} 或 ${BLUE}--grouping${PLAIN}      账号分组，每组账号单独运行脚本，参数后需跟账号序号并分组，参数用法跟指定账号一样，组与组之间用 \"@\" 隔开
   ${BLUE}-b${PLAIN} 或 ${BLUE}--background${PLAIN}    后台运行，不在前台输出脚本执行进度，不占用终端命令行
"
            ;;
        *)
            echo -e "
❖ 主要指令：

   ${BLUE}$TaskCmd <name/path/url> now${PLAIN}          ✧ 普通执行，前台运行并在命令行输出进度，可选参数(支持多个，加在末尾)：${BLUE}-<l/m/w/h/d/p/r/c/g/b>${PLAIN}
   ${BLUE}$TaskCmd <name/path/url> conc${PLAIN}         ✧ 并发执行，后台运行不在命令行输出进度，可选参数(支持多个，加在末尾)：${BLUE}-<m/w/d/p/r/c>${PLAIN}
   ${BLUE}$TaskCmd <name/path> pkill${PLAIN}            ✧ 终止执行，根据脚本匹配对应的进程并立即杀死，当脚本报错死循环时建议使用
   ${BLUE}source runall${PLAIN}                     ✧ 全部执行，在选择运行模式后执行指定范围的脚本(交互)，非常耗时不要盲目使用

   ${BLUE}$TaskCmd ps${PLAIN}                           ✧ 查看设备资源消耗情况和正在运行的脚本进程
   ${BLUE}$TaskCmd rmlog${PLAIN}                        ✧ 删除一定天数的由项目和运行脚本产生的各类日志文件
   ${BLUE}$TaskCmd cleanup${PLAIN}                      ✧ 检测并终止卡死状态的脚本进程，以释放内存占用提高运行效率

   ${BLUE}$TaskCmd list${PLAIN}                         ✧ 列出本地脚本清单，默认列出已配置的脚本，支持指定路径
   ${BLUE}$TaskCmd exsc${PLAIN}                         ✧ 导出互助码变量和助力格式，互助码从最后一个日志提取，受日志内容影响
   ${BLUE}$TaskCmd cookie <args>${PLAIN}                ✧ 检测账号是否有效 ${BLUE}check${PLAIN}，使用wskey更新账号 ${BLUE}update${PLAIN}，获取账号收支 ${BLUE}beans${PLAIN}，查看本地账号清单 ${BLUE}list${PLAIN}
   ${BLUE}$TaskCmd env <args>${PLAIN}                   ✧ 管理全局环境变量功能(交互)，添加 ${BLUE}add${PLAIN}，删除 ${BLUE}del${PLAIN}，修改 ${BLUE}edit${PLAIN}，查询 ${BLUE}search${PLAIN}，支持快捷命令
   ${BLUE}$TaskCmd notify <title> <content> ${PLAIN}    ✧ 自定义推送通知消息，参数为标题加内容，支持转义字符

❋ 指令参数注释：

   ${BLUE}<name>${PLAIN} 脚本名（仅限scripts目录）;  ${BLUE}<path>${PLAIN} 相对路径或绝对路径;  ${BLUE}<url>${PLAIN} 脚本链接地址;  ${BLUE}<args>${PLAIN} 固定可选的子命令

❋ 命令选项：

   ${BLUE}-l${PLAIN} 或 ${BLUE}--loop${PLAIN}          循环运行，连续多次的执行脚本，参数后需跟循环次数
   ${BLUE}-m${PLAIN} 或 ${BLUE}--mute${PLAIN}          静默运行，不推送任何通知消息
   ${BLUE}-w${PLAIN} 或 ${BLUE}--wait${PLAIN}          等待执行，等待指定时间后再运行任务，参数后需跟时间值
   ${BLUE}-h${PLAIN} 或 ${BLUE}--hang${PLAIN}          后台挂起，将脚本设置为守护进程保持在后台运行，期间中断或结束会自动重新运行
   ${BLUE}-d${PLAIN} 或 ${BLUE}--delay${PLAIN}         延迟执行，随机倒数一定秒数后再执行脚本
   ${BLUE}-p${PLAIN} 或 ${BLUE}--proxy${PLAIN}         下载代理，仅适用于执行位于 GitHub 仓库的脚本
   ${BLUE}-c${PLAIN} 或 ${BLUE}--cookie${PLAIN}        指定账号，参数后需跟账号序号，多个账号用 \",\" 隔开，账号区间用 \"-\" 连接，可以用 \"%\" 表示账号总数
   ${BLUE}-g${PLAIN} 或 ${BLUE}--grouping${PLAIN}      账号分组，每组账号单独运行脚本，参数后需跟账号序号并分组，参数用法跟指定账号一样，组与组之间用 \"@\" 隔开
   ${BLUE}-b${PLAIN} 或 ${BLUE}--background${PLAIN}    后台运行，不在前台输出脚本执行进度，不占用终端命令行
"
            ;;
        esac
        ;;
    arcadia)
        case ${ARCH} in
        armv7l | armv6l)
            echo -e "
❖ 服务控制指令：

   ${BLUE}$ContrlCmd server status${PLAIN}             ✧ 查看各服务的详细信息，包括运行状态，创建时间，处理器占用，内存占用，运行时长
   ${BLUE}$ContrlCmd service <args>${PLAIN}            ✧ 后台管理面板和网页终端功能控制，开启或重启 ${BLUE}on${PLAIN}，关闭 ${BLUE}off${PLAIN}，登录信息 ${BLUE}info${PLAIN}，重置密码 ${BLUE}respwd${PLAIN}
   ${BLUE}$ContrlCmd env <args>${PLAIN}                ✧ 执行环境软件包相关命令(环境不支持使用 TypeScript 和 Python 运行环境)，安装 ${BLUE}install${PLAIN}，修复 ${BLUE}repairs${PLAIN}
   ${BLUE}$ContrlCmd check conf${PLAIN}               ✧ 检查项目相关配置文件是否存在，如果缺失就从模板导入

❋ 指令参数注释：

   ${BLUE}<args>${PLAIN} 固定可选的子命令
"
            ;;
        *)
            echo -e "
❖ 服务控制指令：

   ${BLUE}$ContrlCmd server status${PLAIN}             ✧ 查看各服务的详细信息，包括运行状态，创建时间，处理器占用，内存占用，运行时长
   ${BLUE}$ContrlCmd service <args>${PLAIN}            ✧ 后台管理面板和网页终端功能控制，开启或重启 ${BLUE}on${PLAIN}，关闭 ${BLUE}off${PLAIN}，登录信息 ${BLUE}info${PLAIN}，重置密码 ${BLUE}respwd${PLAIN}
   ${BLUE}$ContrlCmd tgbot <args>${PLAIN}               ✧ 电报机器人功能控制，启动或重启 ${BLUE}start${PLAIN}，停止 ${BLUE}stop${PLAIN}，查看日志 ${BLUE}logs${PLAIN}，更新升级 ${BLUE}update${PLAIN}
   ${BLUE}$ContrlCmd env <args>${PLAIN}                ✧ 执行环境软件包相关命令(支持 TypeScript 和 Python 运行环境)，安装 ${BLUE}install${PLAIN}，修复 ${BLUE}repairs${PLAIN}
   ${BLUE}$ContrlCmd check conf${PLAIN}               ✧ 检查项目相关配置文件是否存在，如果缺失就从模板导入

❋ 指令参数注释：

   ${BLUE}<args>${PLAIN} 固定可选的子命令
"
            ;;
        esac
        ;;
    update)
        echo -e "
❖ 更新指令：

   ${BLUE}$UpdateCmd all${PLAIN}                        ✧ 全部更新，包括项目源码，所有仓库和脚本，自定义脚本等
   ${BLUE}$UpdateCmd <args/path>${PLAIN}                 ✧ 指定更新，项目源码 ${BLUE}source${PLAIN}，脚本仓库 ${BLUE}repo${PLAIN}，远程脚本 ${BLUE}raw${PLAIN}，自定义脚本 ${BLUE}extra${PLAIN}，指定仓库 ${BLUE}<path>${PLAIN}

❋ 指令参数注释：

    ${BLUE}<path>${PLAIN} 相对路径或绝对路径
"
        ;;
    "${ContrlCmd}_repo")
        echo -e "
❖ 导入脚本仓库配置命令

使用方法：

  ${BLUE}$ContrlCmd repo <name> <url> <branch> [--options]${PLAIN}    ✧ 必须提供名称、地址、分支，其它通过命令参数控制

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

  ${BLUE}$ContrlCmd raw <name> <url> [--options]${PLAIN}    ✧ 必须提供名称、地址，其它通过命令参数控制

命令选项：

  ${BLUE}--updateTaskList${PLAIN}     是否更新定时任务
  ${BLUE}--help${PLAIN}               查看命令帮助
"
    ;;
    esac
}
