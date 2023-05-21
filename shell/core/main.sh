#!/bin/bash
## Modified: 2023-05-21

## 目录
RootDir=${WORK_DIR}
ShellDir=$RootDir/shell
ScriptsDir=$RootDir/scripts
UtilsDir=$RootDir/utils
PanelDir=$RootDir/web
ConfigDir=$RootDir/config
SampleDir=$RootDir/sample
LogDir=$RootDir/log
LogTmpDir=$LogDir/.tmp
SignDir=$UtilsDir/.sign
CodeDir=$LogDir/ShareCodes
ReposDir=$RootDir/repo
RawDir=$RootDir/raw
BotDir=$RootDir/jbot
BotLogDir=$LogDir/TelegramBot
BotSrcDir=$UtilsDir/bot_src
RootDir_NodeModules=$RootDir/node_modules
ScriptsDir_NodeModules=$ScriptsDir/node_modules

## 文件
FileCode=$ShellDir/code.sh
FileRunAll=$ShellDir/runall.sh
FileConfUser=$ConfigDir/config.sh
FileConfSample=$SampleDir/config.sh
FileSyncConfUser=$ConfigDir/sync_config.yml
FileSyncConfSample=$SampleDir/sync_config.yml
FileAuthUser=$ConfigDir/auth.json
FileAuthSample=$SampleDir/auth.json
FileAccountConfUser=$ConfigDir/account.json
FileAccountConfSample=$SampleDir/account.json
FileExtra=$ConfigDir/extra.sh
FileNotify=$UtilsDir/notify.js
FileSendNotify=$UtilsDir/sendNotify.js
FileSendNotifyScripts=$ScriptsDir/sendNotify.js
FileSendNotifyUser=$ConfigDir/sendNotify.js
FileSendMark=$RootDir/send_mark
FilePm2List=$RootDir/.pm2_list.log
FileProcessList=$RootDir/.process_list.log
FileUpdateCookie=$UtilsDir/UpdateCookies.js

## 清单
ListOldScripts=$LogTmpDir/scripts_old.list
ListNewScripts=$LogTmpDir/scripts_new.list
ListAddScripts=$LogTmpDir/scripts_add.list
ListDelScripts=$LogTmpDir/scripts_del.list
ListConfScripts=$LogTmpDir/scripts_conf.json

## 字符
ARCH=$(uname -m)
TaskCmd="task"
ContrlCmd="taskctl"
UpdateCmd="update"
TIME_FORMAT="+%Y-%m-%d %T:%N"
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
PURPLE='\033[35m'
AZURE='\033[36m'
PLAIN='\033[0m'
BOLD='\033[1m'
SUCCESS="[\033[1;32m成功${PLAIN}]"
COMPLETE="[\033[1;32m完成${PLAIN}]"
WARN="[\033[1;5;33m注意${PLAIN}]"
ERROR="[\033[1;31m错误${PLAIN}]"
FAIL="[\033[1;31m失败${PLAIN}]"
WORKING="[\033[1;36m >_ ${PLAIN}]"
EXAMPLE="[\033[1;35m参考命令${PLAIN}]"
TIPS="[\033[1;32m提示${PLAIN}]"
COMMAND_ERROR="$ERROR 命令不正确，请确认后重试！"
TOO_MANY_COMMANDS="$ERROR 输入命令过多，请确认后重试！"
ShieldingScripts="jd_update\.js|env_copy\.js|index\.js|ql\.js|jCkSeq\.js|jd_CheckCK\.js|jd_disable\.py|jd_updateCron\.ts|scripts_check_dependence\.py|UpdateUIDtoRemark\.js|magic\.|test\.|wskey\.|h5\.js|h5st\.js|getToken\.js|telecom\.py|main\.py|depend\.py"
ShieldingKeywords="\.json\b|AGENTS|^TS_|Cookie|cookie|Token|ShareCodes|sendNotify\.|^JDJR|Validator|validate|ZooFaker|MovementFaker|tencentscf|^api_test|^app\.|^main\.|\.bak\b|jdEnv|identical|${ShieldingScripts}"
RawDirUtils="node_modules|${ShieldingKeywords}"
CoreFiles="jdCookie.js USER_AGENTS.js"
ScriptsDirReplaceFiles=""

## URL
SignsRepoGitUrl="git@jd_base_gitee:supermanito/panel_sign_json.git"

## 导入模块
function import() {
    echo "$1" | grep "/" -q
    if [ $? -eq 0 ]; then
        local target="$ShellDir/$1.sh"
    else
        local target="$ShellDir/$1/main.sh"
    fi
    if [ -s "$target" ]; then
        [ ! -x "$target" ] && chmod +x "$target" >/dev/null 2>&1
        . "$target"
    else
        echo -e "\n$ERROR $target 不存在，跳过导入！\n"
    fi
}

## 导入配置文件
function Import_Config() {
    if [ -f $FileConfUser ]; then
        . $FileConfUser
    else
        echo -e "\n$ERROR 配置文件 $FileConfUser 不存在，请检查是否移动过该文件！\n"
        exit
    fi
}
function Import_Config_Not_Check() {
    if [ -f $FileConfUser ]; then
        . $FileConfUser >/dev/null 2>&1
    fi
}

## URL编码
function UrlEncode() {
    local LANG=C
    local length="${#1}"
    local i=0
    while :; do
        [ $length -gt $i ] && {
            local c="${1:$i:1}"
            case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            *) printf '%%%02X' "'$c" ;;
            esac
        } || break
        let i++
    done
}

## URL解码
function UrlDecode() {
    local u="${1//+/ }"
    echo -e "${u//%/\\x}"
}

## 计算字符串长度
function StringLength() {
    local text=$1
    echo "${#text}"
}

## 输出命令错误提示
function Output_Command_Error() {
    local Mod=$1
    case $Mod in
    1)
        echo -e "$COMMAND_ERROR\n"
        ;;
    2)
        echo -e "$TOO_MANY_COMMANDS\n"
        ;;
    esac
}

## 统计账号数量
function Count_UserSum() {
    for ((i = 1; i <= 0x2710; i++)); do
        local Tmp=Cookie$i
        local CookieTmp=${!Tmp}
        [[ ${CookieTmp} ]] && UserSum=$i || break
    done
}

## 组合变量
function Combin_Sub() {
    local What_Combine=$1
    local CombinAll=""
    local Tmp1
    ## 全局屏蔽
    grep "^TempBlockCookie=" $FileConfUser -q 2>/dev/null
    if [ $? -eq 0 ]; then
        local GlobalBlockCookie=$(grep "^TempBlockCookie=" $FileConfUser | head -n 1 | awk -F "[\"\']" '{print$2}')
    fi
    for ((i = 0x1; i <= ${UserSum}; i++)); do
        if [[ ${GlobalBlockCookie} ]]; then
            for num1 in ${GlobalBlockCookie}; do
                [[ $i -eq $num1 ]] && continue 2
            done
        fi
        Tmp1=$What_Combine$i
        Tmp2=${!Tmp1}
        CombinAll="${CombinAll}&${Tmp2}"
    done
    echo $CombinAll | perl -pe "{s|^&||; s|^@+||; s|&@|&|g; s|@+&|&|g; s|@+|@|g; s|@+$||}"
}

## 组合全部Cookie
function Combin_AllCookie() {
    Combin() {
        local What_Combine=Cookie
        local CombinAll=""
        local Tmp1 Tmp2
        ## 全局屏蔽
        grep "^TempBlockCookie=" $FileConfUser -q 2>/dev/null
        if [ $? -eq 0 ]; then
            local GlobalBlockCookie=$(grep "^TempBlockCookie=" $FileConfUser | head -n 1 | awk -F "[\"\']" '{print$2}')
        fi
        for ((i = 0x1; i <= ${UserSum}; i++)); do
            ## 跳过全局屏蔽的账号
            if [[ ${GlobalBlockCookie} ]]; then
                for num1 in ${GlobalBlockCookie}; do
                    if [[ $i -eq $num1 ]]; then
                        continue 2
                    else
                        grep "^Cookie$i=[\"\'].*pt_pin=${num1};.*[\"\']" $FileConfUser -q 2>/dev/null
                        [ $? -eq 0 ] && continue 2
                    fi
                done
            fi
            ## 跳过临时屏蔽的账号
            for num2 in ${TempBlockCookie}; do
                if [[ $i -eq $num2 ]]; then
                    continue 2
                else
                    grep "^Cookie$i=[\"\'].*pt_pin=${num2};.*[\"\']" $FileConfUser -q 2>/dev/null
                    [ $? -eq 0 ] && continue 2
                fi
            done
            Tmp1=$What_Combine$i
            Tmp2=${!Tmp1}
            CombinAll="${CombinAll}&${Tmp2}"
        done
        echo $CombinAll | sed "s|^&||g; s|^@+||g; s|&@|&|g; s|@+&|&|g; s|@+|@|g; s|@+$||g"
    }

    export JD_COOKIE=$(Combin)
}

## 推送通知
function Notify() {
    local title=$(echo "$1" | sed "s|-|_|g")
    local msg="$(echo -e "$2")"
    if [ -d $ScriptsDir_NodeModules ]; then
        node $FileNotify "$title" "$msg"
    fi
}

## 应用推送通知模块
function Apply_SendNotify() {
    local WorkDir=$1
    Import_Config_Not_Check
    if [[ ${EnableCustomNotify} == true ]] && [ -s $FileSendNotifyUser ]; then
        cp -rf $FileSendNotifyUser $WorkDir
    else
        cp -rf $FileSendNotify $WorkDir
    fi
}

## 解析 json 数据
function JSON_Parse() {
    jq -n "$1" | jq -rc "$2"
}

## 解析被Encode的中文字符串
function ParseEncodeStringToChinese() {
    local String=$1
    printf $(echo ${String} | sed "s|%|\\\x|g")
}

## 创建目录
function Make_Dir() {
    local Dir=$1
    [ ! -d $Dir ] && mkdir -p $Dir
}

## 查询脚本名，$1 为脚本名
function Query_ScriptName() {
    local FileName=$1
    case ${FileName##*.} in
    js)
        grep "\$ \=" $FileName | grep -Eiq ".*new Env\(.*\)"
        if [ $? -eq 0 ]; then
            local Tmp=$(grep "\$ \=" $FileName | grep -Ei ".*new Env\(.*\)" | head -1 | perl -pe "{s|.*nv\([\'\"](.*)[\'\"]\).*|\1|g}")
        else
            local Tmp=$(grep -w "script-path" $FileName | head -1 | sed "s/\W//g" | sed "s/[0-9a-zA-Z_]//g")
        fi
        ;;
    *)
        cat $FileName | sed -n "1,10p" | grep -Eiq ".*new Env\(.*\)"
        if [ $? -eq 0 ]; then
            local Tmp=$(grep "new Env(" $FileName | grep -Ei ".*new Env\(.*\)" | head -1 | perl -pe "{s|.*nv\([\'\"](.*)[\'\"]\).*|\1|g}")
        else
            local Tmp=$(grep -E "^活动名称|^脚本名称" $FileName | head -1 | awk -F "[\'\":,：]" '{print $2}' | awk -F "[\'\":,：]" '{print $1}')
        fi
        ;;
    esac
    if [[ ${Tmp} ]]; then
        ScriptName=${Tmp}
    else
        ScriptName="<未命名>"
    fi
}

## 查询脚本大小，$1 为脚本名
function Query_ScriptSize() {
    local FileName=$1
    ScriptSize=$(ls -lth | grep "\b$FileName\b" | awk -F ' ' '{print$5}')
}

## 查询脚本修改时间，$1 为脚本名
function Query_ScriptEditTimes() {
    local FileName=$1
    local Data=$(ls -lth | grep "\b$FileName\b" | awk -F 'root' '{print$NF}')
    local MonthTmp=$(echo $Data | awk -F ' ' '{print$2}')
    case $MonthTmp in
    Jan)
        Month="01"
        ;;
    Feb)
        Month="02"
        ;;
    Mar)
        Month="03"
        ;;
    Apr)
        Month="04"
        ;;
    May)
        Month="05"
        ;;
    Jun)
        Month="06"
        ;;
    Jul)
        Month="07"
        ;;
    Aug)
        Month="08"
        ;;
    Sept)
        Month="09"
        ;;
    Oct)
        Month="10"
        ;;
    Nov)
        Month="11"
        ;;
    Dec)
        Month="12"
        ;;
    esac
    local Day=$(echo $Data | awk -F ' ' '{print$3}')
    if [[ $Day -lt "10" ]]; then
        Day="0$Day"
    fi
    local Time=$(echo $Data | awk -F ' ' '{print$4}')
    ScriptEditTimes="$Month-$Day $Time"
}

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
    taskctl)
        case ${ARCH} in
        armv7l | armv6l)
            echo -e "
❖ 服务控制指令：

   ${BLUE}$ContrlCmd server status${PLAIN}             ✧ 查看各服务的详细信息，包括运行状态，创建时间，处理器占用，内存占用，运行时长
   ${BLUE}$ContrlCmd panel <args>${PLAIN}              ✧ 控制面板和网页终端功能控制，开启或重启 ${BLUE}on${PLAIN}，关闭 ${BLUE}off${PLAIN}，登录信息 ${BLUE}info${PLAIN}，重置密码 ${BLUE}respwd${PLAIN}
   ${BLUE}$ContrlCmd env <args>${PLAIN}                ✧ 执行环境软件包相关命令(环境不支持使用 TypeScript 和 Python 运行环境)，安装 ${BLUE}install${PLAIN}，修复 ${BLUE}repairs${PLAIN}
   ${BLUE}$ContrlCmd check files${PLAIN}               ✧ 检查项目相关配置文件是否存在，如果缺失就从模板导入

❋ 指令参数注释：

   ${BLUE}<args>${PLAIN} 固定可选的子命令
"
            ;;
        *)
            echo -e "
❖ 服务控制指令：

   ${BLUE}$ContrlCmd server status${PLAIN}             ✧ 查看各服务的详细信息，包括运行状态，创建时间，处理器占用，内存占用，运行时长
   ${BLUE}$ContrlCmd panel <args>${PLAIN}              ✧ 控制面板和网页终端功能控制，开启或重启 ${BLUE}on${PLAIN}，关闭 ${BLUE}off${PLAIN}，登录信息 ${BLUE}info${PLAIN}，重置密码 ${BLUE}respwd${PLAIN}
   ${BLUE}$ContrlCmd jbot <args>${PLAIN}               ✧ 电报机器人功能控制，启动或重启 ${BLUE}start${PLAIN}，停止 ${BLUE}stop${PLAIN}，查看日志 ${BLUE}logs${PLAIN}，更新升级 ${BLUE}update${PLAIN}
   ${BLUE}$ContrlCmd env <args>${PLAIN}                ✧ 执行环境软件包相关命令(支持 TypeScript 和 Python 运行环境)，安装 ${BLUE}install${PLAIN}，修复 ${BLUE}repairs${PLAIN}
   ${BLUE}$ContrlCmd check files${PLAIN}               ✧ 检查项目相关配置文件是否存在，如果缺失就从模板导入

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
    esac
}
