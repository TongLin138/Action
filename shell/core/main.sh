#!/bin/bash
## Modified: 2023-05-23

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

## 字符
ARCH=$(uname -m)
ContrlCmd="arcadia"
TaskCmd="task"
UpdateCmd="update"
EnvManageCmd="envm"
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
ShieldingScripts="jd_update\.js|env_copy\.js|index\.js|ql\.js|jCkSeq\.js|jd_CheckCK\.js|jd_disable\.py|jd_updateCron\.ts|scripts_check_dependence\.py|UpdateUIDtoRemark\.js|magic\.|test\.|wskey\.|h5\.js|h5st\.js|getToken\.js|telecom\.py|main\.py|depend\.py"
ShieldingKeywords="\.json\b|AGENTS|^TS_|Cookie|cookie|Token|ShareCodes|sendNotify\.|^JDJR|Validator|validate|ZooFaker|MovementFaker|tencentscf|^api_test|^app\.|^main\.|\.bak\b|jdEnv|identical|${ShieldingScripts}"
RawDirUtils="node_modules|${ShieldingKeywords}"
CoreFiles="jdCookie.js USER_AGENTS.js"
ScriptsDirReplaceFiles=""

## URL
SignsRepoGitUrl="git@arcadia:supermanito/service_sign_json.git"

## 导入模块
function import() {
    if [ -d "$ShellDir/$1" ]; then
        local target="$ShellDir/$1/main.sh"
    else
        local target="$ShellDir/$1.sh"
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
function Output_Error() {
    [ "$1" ] && echo -e "\n$ERROR $1\n"
    exit 1
}
function Output_Command_Error() {
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
            local Tmp=$(grep -E "^脚本名称" $FileName | head -1 | awk -F "[\'\":,：]" '{print $2}' | awk -F "[\'\":,：]" '{print $1}')
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
