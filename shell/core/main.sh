#!/bin/bash
## Modified: 2023-05-27

## 目录
RootDir=${ARCADIA_DIR}
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
BotDir=$RootDir/tgbot
BotLogDir=$LogDir/TelegramBot
BotSrcDir=$UtilsDir/bot_src
RootDir_NodeModules=$RootDir/node_modules
ScriptsDir_NodeModules=$ScriptsDir/node_modules

## 文件
FileCode=$ShellDir/code.sh
FileRunAll=$ShellDir/runall.sh
FileConfUser=$ConfigDir/config.sh
FileConfSample=$SampleDir/config.sh
FileSyncConfUser=$ConfigDir/sync.yml
FileSyncConfSample=$SampleDir/sync.yml
FileAuthUser=$ConfigDir/auth.json
FileAuthSample=$SampleDir/auth.json
FileAccountConfUser=$ConfigDir/account.json
FileAccountConfSample=$SampleDir/account.json
FileUpdateExtra=$ConfigDir/update_extra.sh
FileInitExtra=$ConfigDir/init_extra.sh
FileTaskBeforeExtra=$ConfigDir/task_before_extra.sh
FileTaskAfterExtra=$ConfigDir/task_after_extra.sh
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

## 字符串
ContrlCmd="arcadia"
TaskCmd="task"
UpdateCmd="update"
EnvManageCmd="envm"
ARCH="$(uname -m)"
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
TIP="[\033[1;32m提示${PLAIN}]"
WORKING="[\033[1;36m >_ ${PLAIN}]"
EXAMPLE="[\033[1;35m参考命令${PLAIN}]"

## 导入模块
function import() {
    if [ -d "$ShellDir/$1" ]; then
        local target="$ShellDir/$1/main.sh"
    else
        local target="$ShellDir/$1.sh"
    fi
    if [ -s "$target" ]; then
        [ ! -x "$target" ] && chmod +x "$target" >/dev/null 2>&1
        source "$target"
    else
        echo -e "\n$ERROR $target 不存在，跳过导入！\n"
    fi
}

## 导入配置文件
function import_config() {
    if [ -f $FileConfUser ]; then
        source $FileConfUser
    else
        echo -e "\n$ERROR 配置文件 $FileConfUser 不存在，请检查是否移动过该文件！\n"
        exit
    fi
}
function import_config_not_check() {
    if [ -f $FileConfUser ]; then
        source $FileConfUser >/dev/null 2>&1
    fi
}

## 计算字符串长度
function string_length() {
    local text=$1
    echo "${#text}"
}

## 输出命令错误提示
function output_error() {
    [ "$1" ] && echo -e "\n$ERROR $1\n"
    exit 1
}
function output_command_error() {
    local Mod=$1
    case $Mod in
    1)
        echo -e "\n$ERROR 命令不正确，请确认后重试！\n"
        ;;
    2)
        echo -e "\n$ERROR 输入命令过多，请确认后重试！\n"
        ;;
    esac
}

## 统计数量
function count_usersum() {
    for ((i = 1; i <= 0x2710; i++)); do
        local Tmp=Cookie$i
        local CookieTmp=${!Tmp}
        [[ ${CookieTmp} ]] && UserSum=$i || break
    done
}

## 推送通知
function send_notify() {
    local title=$(echo "$1" | sed "s|-|_|g")
    local msg="$(echo -e "$2")"
    if [ -d $ScriptsDir_NodeModules ]; then
        node $FileNotify "$title" "$msg"
    fi
}

## 创建目录
function make_dir() {
    local Dir=$1
    [ ! -d $Dir ] && mkdir -p $Dir
}
