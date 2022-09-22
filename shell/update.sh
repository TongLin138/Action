#!/bin/bash
## Author: SuperManito
## Modified: 2022-09-22

ShellDir=${WORK_DIR}/shell
. $ShellDir/template.sh

## 创建日志文件夹
Make_Dir $LogDir
## 导入配置文件（不检查）
Import_Config_Not_Check

## 更新crontab，gitee服务器同一时间限制5个链接，因此每个人更新代码必须错开时间，每次执行git_pull随机生成。
## 每天次数随机，更新时间随机，更新秒数随机，至少4次，至多6次，大部分为5次，符合正态分布。
function Random_Update_Cron() {
    local RanMin RanSleep RanHourArray RanHour Tmp
    if [[ $(date "+%-H") -le 2 ]] && [ -f ${ListCrontabUser} ]; then
        RanMin=$((${RANDOM} % 60))
        RanSleep=$((${RANDOM} % 56))
        RanHourArray[0]=$((${RANDOM} % 3))
        RanHour=${RanHourArray[0]}
        for ((i = 1; i < 14; i++)); do
            j=$(($i - 1))
            Tmp=$((${RANDOM} % 3 + ${RanHourArray[j]} + 2))
            [[ ${Tmp} -lt 24 ]] && RanHourArray[i]=${Tmp} || break
        done
        for ((i = 1; i < ${#RanHourArray[*]}; i++)); do
            RanHour="${RanHour},${RanHourArray[i]}"
        done
        perl -i -pe "s|.+(update shell.*)|${RanMin} ${RanHour} \* \* \* sleep ${RanSleep} && \1|" ${ListCrontabUser}
        crontab ${ListCrontabUser}
    fi
}

## 克隆仓库
## 注释  $1：仓库地址，$2：仓库保存路径，$3：分支（可省略）
function Git_Clone() {
    local Url=$1
    local Dir=$2
    local Branch=$3
    [[ $Branch ]] && local Command="-b $Branch "
    echo -e "\n$WORKING 开始克隆仓库 ${BLUE}$Url${PLAIN}\n"
    GIT_TERMINAL_PROMPT=0 git clone $Command $Url $Dir
    ExitStatus=$?
}

## 更新仓库
## 注释  $1：仓库保存路径
function Git_Pull() {
    local CurrentDir=$(pwd)
    local WorkDir=$1
    local Branch=$2
    cd $WorkDir
    echo -e "\n$WORKING 开始更新仓库：${BLUE}$WorkDir${PLAIN}\n"
    GIT_TERMINAL_PROMPT=0 git fetch --all
    ExitStatus=$?
    GIT_TERMINAL_PROMPT=0 git pull
    GIT_TERMINAL_PROMPT=0 git reset --hard origin/$Branch
    cd $CurrentDir
}

## 重置仓库远程链接 remote url
## 注释  $1：要重置的目录，$2：要重置为的网址
function Reset_Romote_Url() {
    local CurrentDir=$(pwd)
    local WorkDir=$1
    local Url=$2
    local Branch=$3
    if [ -d "$WorkDir/.git" ]; then
        cd $WorkDir
        git remote set-url origin $Url >/dev/null 2>&1
        GIT_TERMINAL_PROMPT=0 git fetch --all >/dev/null 2>&1
        GIT_TERMINAL_PROMPT=0 git reset --hard origin/$Branch >/dev/null 2>&1
        cd $CurrentDir
    fi
}

## 生成仓库用户配置信息数组
# 仓库名称 Array_Repo_name
# 远程地址 Array_Repo_url
# 分支名称 Array_Repo_branch
# 存放仓库文件夹名 Array_Repo_dir
# 仓库本地绝对路径 Array_Repo_path
# 仓库启用状态 Array_Repo_status
# 仓库脚本定时设置（是否启用定时） Array_Repo_cronSettings_isEnable
# 仓库脚本定时设置（脚本路径） Array_Repo_cronSettings_scriptsPath
# 仓库脚本定时设置（匹配白名单） Array_Repo_cronSettings_whiteList
# 仓库脚本定时设置（匹配黑名单） Array_Repo_cronSettings_blackList

function Gen_RepoConf() {

    local scripts_path_num="-1"
    local arr_num TmpConf Tmp_name Tmp_url Tmp_branch Tmp_isEnable Tmp_cronSettings_isEnable Tmp_cronSettings_scriptsPath Tmp_cronSettings_whiteList Tmp_cronSettings_blackList Tmp_KeysValue
    if [[ $RepoSum -ge 1 ]]; then
        for ((i = 1; i <= $RepoSum; i++)); do
            arr_num=$((i - 1))

            # 读取仓库配置并检测语法
            TmpConf=RepoConfig$i
            jq -n "${!TmpConf}" >/dev/null 2>&1
            if [ $? -ne 0 ]; then
                echo -e "$ERROR 第$i个仓库配置存在语法错误，跳过..."
                continue
            fi

            ## 仓库地址（如若未定义或格式错误则跳过视为无效配置）
            Tmp_url="$(JSON_Parse "${!TmpConf}" ".url")"
            if [[ -z ${Tmp_url} ]] || [[ ${Tmp_url} == "null" ]]; then
                # echo -e "$ERROR 未检测到第$i个仓库配置的远程地址，跳过..."
                continue
            fi
            # 判断仓库地址格式
            echo ${Tmp_url} | grep -Eq "\.git$" # 链接必须以.git结尾
            if [ $? -ne 0 ]; then
                # echo -e "$ERROR 检测到第$i个仓库配置的远程地址无效，跳过..."
                continue
            fi
            echo ${Tmp_url} | grep -Eq "http.*:"
            if [ $? -ne 0 ]; then
                echo ${Tmp_url} | grep -Eq "^git\@"
                if [ $? -ne 0 ]; then
                    # echo -e "$ERROR 检测到第$i个仓库配置的远程地址无效，跳过..."
                    continue
                fi
            fi

            ## 仓库分支（如若未定义或格式错误则跳过视为无效配置）
            Tmp_branch="$(JSON_Parse "${!TmpConf}" ".branch")"
            if [[ -z ${Tmp_branch} ]] || [[ ${Tmp_branch} == "null" ]]; then
                # echo -e "$ERROR 未检测到第$i个仓库配置的分支名称，跳过..."
                continue
            fi

            Array_Repo_url[$arr_num]="${Tmp_url}"
            Array_Repo_branch[$arr_num]="${Tmp_branch}"

            ## 仓库名称（如若未定义则采用远程地址中的仓库名称）
            Tmp_name="$(JSON_Parse "${!TmpConf}" ".name")"
            if [[ $Tmp_name == "null" ]]; then
                Array_Repo_name[$arr_num]="$(echo ${Array_Repo_url[$arr_num]} | perl -pe "s|\.git||" | awk -F "/|:" '{print$NF}')"
            else
                Array_Repo_name[$arr_num]="${Tmp_name}"
            fi

            ## 仓库路径
            Array_Repo_dir[$arr_num]="$(echo "${Array_Repo_url[$arr_num]}" | perl -pe "s|\.git||" | awk -F "/|:" '{print $((NF - 1)) "_" $NF}')"
            Array_Repo_path[$arr_num]="$RepoDir/${Array_Repo_dir[$arr_num]}"

            ## 仓库启用状态（默认启用仓库，即使键名键值未定义或键值定义错误）
            Tmp_isEnable="$(JSON_Parse "${!TmpConf}" ".isEnable")"
            if [[ $Tmp_isEnable == true ]]; then
                Array_Repo_status[$arr_num]="true"
            else
                Array_Repo_status[$arr_num]="false"
            fi

            # 定时启用状态（如若未定义或格式错误则默认禁用）
            if [[ "$(JSON_Parse "${!TmpConf}" ".cronSettings.isEnable")" == true ]]; then
                Array_Repo_cronSettings_isEnable[$arr_num]="true"
            else
                Array_Repo_cronSettings_isEnable[$arr_num]="false"
            fi
            # 定时脚本路径（如若未定义或格式错误则默认为空）
            if [[ "$(JSON_Parse "${!TmpConf}" ".cronSettings.scriptsPath")" == '""' ]]; then
                Array_Repo_cronSettings_scriptsPath[$arr_num]=""
            else
                Array_Repo_cronSettings_scriptsPath[$arr_num]="$(JSON_ParseSting "${!TmpConf}" ".cronSettings.scriptsPath" | sed "s|^\"||g; s|\"$||g")"
            fi
            # 定时脚本白名单（如若未定义则默认为空）
            if [[ "$(JSON_Parse "${!TmpConf}" ".cronSettings.whiteList")" == '""' ]]; then
                Array_Repo_cronSettings_whiteList[$arr_num]=""
            else
                Array_Repo_cronSettings_whiteList[$arr_num]="$(JSON_ParseSting "${!TmpConf}" ".cronSettings.whiteList" | sed "s|^\"||g; s|\"$||g")"
            fi
            # 定时脚本黑名单（如若未定义则默认为空）
            if [[ "$(JSON_Parse "${!TmpConf}" ".cronSettings.blackList")" == '""' ]]; then
                Array_Repo_cronSettings_blackList[$arr_num]=""
            else
                Array_Repo_cronSettings_blackList[$arr_num]="$(JSON_ParseSting "${!TmpConf}" ".cronSettings.blackList" | sed "s|^\"||g; s|\"$||g")"
            fi
            echo "仓库 $i 的定时配置：
            ${Array_Repo_cronSettings_isEnable[$arr_num]}
            ${Array_Repo_cronSettings_scriptsPath[$arr_num]}
            ${Array_Repo_cronSettings_whiteList[$arr_num]}
            ${Array_Repo_cronSettings_blackList[$arr_num]}"
        done
    fi
}

## 生成定时任务脚本的绝对路径清单
function Gen_ListCron() {
    local Matching isEnable scriptsPath whiteList blackList FormatPath
    local MatchScriptsType="\.js$|\.py$|\.ts$"
    local CurrentDir=$(pwd)

    ## 先导入用户的定时
    local ListCronTmp=$LogTmpDir/crontab_tmp.list
    Make_Dir $LogTmpDir
    [ ! -f $ListScripts ] && touch $ListScripts
    grep -vwf $ListScripts $ListCrontabUser | grep -Eq " $TaskCmd $RepoDir"
    local ExitStatus=$?
    [[ $ExitStatus -eq 0 ]] && grep -vwf $ListScripts $ListCrontabUser | grep -E " $TaskCmd $RepoDir" | perl -pe "s|.*$TaskCmd ([^\s]+)( .+\|$)|\1|" | sort -u >$ListCronTmp
    rm -rf $LogTmpDir/*.list

    ## 循环处理各个仓库配置
    for ((i = 0; i < ${#Array_Repo_name[*]}; i++)); do
        # 判断仓库是否启用
        [[ ${Array_Repo_status[i]} == false ]] && continue
        # 判断仓库是否启用定时
        [[ ${Array_Repo_cronSettings_isEnable[i]} == false ]] && continue

        ## 黑白名单
        whiteList="${Array_Repo_cronSettings_whiteList[i]}"
        blackList="${Array_Repo_cronSettings_blackList[i]}"
        echo "仓库 $((i + 1)) 的白名单：${whiteList}"
        echo "仓库 $((i + 1)) 的黑名单：${blackList}"

        ## 脚本路径（循环处理）
        scriptsPath="$(echo ${Array_Repo_cronSettings_scriptsPath[i]} | perl -pe '{s|\\"\\"|根目录|g}')"
        echo "仓库 $((i + 1)) 的脚本路径：${scriptsPath}"

        ## 配置为空表示根目录
        if [[ -z ${scriptsPath} ]]; then
            ## 进入仓库根目录
            cd ${Array_Repo_path[i]}

            ## 判断路径下是否存在脚本
            if [[ "$(ls | grep -E "${MatchScriptsType}")" ]]; then

                ## 判断是否定义了黑名单并筛选符合条件的脚本
                if [[ -z ${blackList} ]]; then
                    Matching=$(ls | grep -E "${MatchScriptsType}" 2>/dev/null | grep -E "${whiteList}")
                else
                    Matching=$(ls | grep -E "${MatchScriptsType}" 2>/dev/null | grep -E "${whiteList}" | grep -Ev ${blackList})
                fi
                for file in ${Matching}; do
                    ## 判断脚本是否存在内容
                    if [ -s $file ]; then
                        echo "${Array_Repo_dir[i]}/${file}" >>$ListScripts
                    else
                        continue
                    fi
                done
            else
                continue
            fi
        else
            for path in ${scriptsPath}; do
                # echo "仓库 $((i + 1)) 循环处理路径: $path"
                ## 进入仓库根目录
                cd ${Array_Repo_path[i]}

                ## 判断路径
                if [[ ${path} == '根目录' ]]; then
                    FormatPath="${Array_Repo_path[i]}" # 根目录
                else
                    FormatPath="$RepoDir/$(echo "${Array_Repo_dir[i]}/$path" | perl -pe "{s|//|/|g; s|/$||}")" # 去掉多余的斜杠
                    ## 判断子目录是否存在
                    if [ -d "${FormatPath}" ]; then
                        cd ${FormatPath}
                    else
                        echo -e "\n$ERROR 仓库 $((i + 1)) 的定时脚本配置路径 ${BLUE}${FormatPath}${PLAIN} 不存在，跳过！\n"
                        continue
                    fi
                fi

                ## 判断路径下是否存在脚本
                if [[ "$(ls | grep -E "${MatchScriptsType}")" ]]; then

                    ## 判断是否定义了黑名单并筛选符合条件的脚本
                    if [[ -z ${blackList} ]]; then
                        Matching=$(ls | grep -E "${MatchScriptsType}" 2>/dev/null | grep -E "${whiteList}")
                    else
                        Matching=$(ls | grep -E "${MatchScriptsType}" 2>/dev/null | grep -E "${whiteList}" | grep -Ev ${blackList})
                    fi
                    for file in ${Matching}; do
                        ## 判断脚本是否存在内容
                        if [ -s $file ]; then
                            echo "${FormatPath}/${file}" >>$ListScripts
                        else
                            continue
                        fi
                    done
                else
                    continue
                fi
            done
        fi
    done
    if [[ ${#RawFile[*]} -ge 1 ]]; then
        if [[ $(ls | grep -E "${MatchScriptsType}" | grep -Ev "${RawDirUtils}" 2>/dev/null) ]]; then
            for file in $(ls | grep -E "${MatchScriptsType}" | grep -Ev "${RawDirUtils}"); do
                if [ -f $file ]; then
                    echo "$RawDir/$file" >>$ListScripts
                fi
            done
        fi
    fi

    [ ! -f $ListScripts ] && touch $ListScripts
    ## 汇总去重
    echo "$(sort -u $ListScripts)" >$ListScripts
    ## 导入用户的定时
    cat $ListScripts >$ListAll
    [[ $ExitStatus -eq 0 ]] && cat $ListCronTmp >>$ListAll

    if [[ $ExitStatus -eq 0 ]]; then
        grep -E " $TaskCmd $RepoDir" $ListCrontabUser | grep -Ev "$(cat $ListCronTmp)" | perl -pe "s|.*$TaskCmd ([^\s]+)( .+\|$)|\1|" | sort -u >$ListUser
        cat $ListCronTmp >>$ListUser
    else
        grep -E " $TaskCmd $RepoDir" $ListCrontabUser | perl -pe "s|.*$TaskCmd ([^\s]+)( .+\|$)|\1|" | sort -u >$ListUser
    fi
    [ -f $ListCronTmp ] && rm -f $ListCronTmp
    cd $CurrentDir
}

## 检测cron的差异
## 注释  $1：脚本清单文件路径，$2：cron任务清单文件路径，$3：增加任务清单文件路径，$4：删除任务清单文件路径
function Diff_Cron() {
    local ListScripts="$1"
    local ListTask="$2"
    local ListAdd="$3"
    local ListDrop="$4"
    if [ -s $ListTask ] && [ -s $ListScripts ]; then
        diff $ListScripts $ListTask | grep "<" | awk '{print $2}' >$ListAdd
        diff $ListScripts $ListTask | grep ">" | awk '{print $2}' >$ListDrop
        [ ! -f $ListAdd ] && touch $ListAdd
        [ ! -f $ListDrop ] && touch $ListDrop
    elif [ ! -s $ListTask ] && [ -s $ListScripts ]; then
        cp -f $ListScripts $ListAdd
    elif [ -s $ListTask ] && [ ! -s $ListScripts ]; then
        cp -f $ListTask $ListDrop
    fi
}

## 检测配置文件版本
function Detect_Config_Version() {
    ## 识别出两个文件的版本号
    VerConfSample=$(grep " Version: " $FileConfSample | perl -pe "s|.+v((\d+\.?){3})|\1|")
    [ -f $FileConfUser ] && VerConfUser=$(grep " Version: " $FileConfUser | perl -pe "s|.+v((\d+\.?){3})|\1|")
    ## 删除旧的发送记录文件
    [ -f $FileSendMark ] && [[ $(cat $FileSendMark) != $VerConfSample ]] && rm -f $FileSendMark
    ## 识别出更新日期和更新内容
    UpdateDate=$(grep " Date: " $FileConfSample | awk -F ": " '{print $2}')
    UpdateContent=$(grep " Update Content: " $FileConfSample | awk -F ": " '{print $2}' | sed "s/[0-9]\./\\\n&/g")
    ## 如果是今天，并且版本号不一致，则发送通知
    if [ -f $FileConfUser ] && [[ $VerConfUser != $VerConfSample ]] && [[ $UpdateDate == $(date "+%Y-%m-%d") ]]; then
        if [ ! -f $FileSendMark ]; then
            local NotifyTitle="配置文件更新通知"
            local NotifyContent="更新日期: $UpdateDate\n当前版本: $VerConfUser\n新的版本: $VerConfSample\n更新内容: $UpdateContent\n"
            echo -e $NotifyContent
            Notify "$NotifyTitle" "$NotifyContent"
            echo ''
            [ $? -eq 0 ] && echo $VerConfSample >$FileSendMark
        fi
    else
        [ -f $FileSendMark ] && rm -f $FileSendMark
    fi
}

## npm install 安装脚本依赖模块
## 注释  $1：package.json 文件所在路径
function Npm_Install_Standard() {
    local CurrentDir=$(pwd)
    local WorkDir=$1
    cd $WorkDir
    echo -e "\n$WORKING 开始执行 npm install ...\n"
    npm install
    [ $? -ne 0 ] && echo -e "\n$FAIL 检测到脚本所需的依赖模块安装失败，请进入 $WorkDir 目录后手动执行 npm install ...\n"
    cd $CurrentDir
}
function Npm_Install_Upgrade() {
    local CurrentDir=$(pwd)
    local WorkDir=$1
    cd $WorkDir
    echo -e "\n$WORKING 检测到 $WorkDir 目录脚本所需的依赖模块有所变动，执行 npm install ...\n"
    npm install
    [ $? -ne 0 ] && echo -e "\n$FAIL 检测到模块安装失败，再次尝试一遍...\n" && Npm_Install_Standard $WorkDir
    cd $CurrentDir
}

## 输出是否有新的或失效的定时任务
## 注释  $1：新的或失效的任务清单文件路径，$2：新/失效
function Output_List_Add_Drop() {
    local List=$1
    local Type=$2
    if [ -s $List ]; then
        echo -e "\n$TIPS 检测到有$Type的定时任务：\n"
        if [[ ${Type} == "新" ]]; then
            local ListArr=(
                $(cat $List)
            )
            rm -rf $ListAddNames
            for script in ${ListArr[@]}; do
                NameTmp=${script##*/}
                DirTmp=${script%/*}
                cd $DirTmp
                Query_ScriptName "${NameTmp}"
                printf "%-50s %s\n" "${script}" "${ScriptName}"
                echo -e "${script} ➜  ${ScriptName}" >>$ListAddNames
                cd $CurrentDir
            done
        else
            cat $List
        fi
        echo ''
    fi
}

## 自动删除失效的脚本与定时任务
## 需要：
##      1.AutoDelCron/AutoDelRepoCron/AutoDelRawCron 设置为 true；
##      2.正常更新脚本，没有报错；
##      3.存在失效任务；
##      4.crontab.list存在并且不为空
## 注释  $1：失效任务清单文件路径，$2：task
function Del_Cron() {
    local ListDrop=$1
    local Type=$2
    local Detail Detail2
    if [ -s $ListDrop ] && [ -s $ListCrontabUser ]; then
        Detail=$(cat $ListDrop)
        for cron in $Detail; do
            local Tmp=$(echo $cron | perl -pe "s|/|\.|g")
            perl -i -ne "{print unless / $Type $Tmp( |$)/}" $ListCrontabUser
        done
        crontab $ListCrontabUser
        Detail2=$(echo $Detail | perl -pe "s| |\\\n|g")
        echo -e "$SUCCESS 成功删除失效的定时任务\n"
        if [[ ${EnableDelCronNotify} == true ]]; then
            Notify "失效定时任务通知" "已删除以下失效的定时任务：\n\n$Detail2"
        fi
    fi
}

## 自动增加自己额外的脚本的定时任务
## 需要：
##      1.AutoAddRepoCron/AutoAddRawCron 设置为 true；
##      2.正常更新脚本，没有报错；
##      3.存在新任务；
##      4.crontab.list存在并且不为空
## 注释  $1：新任务清单文件路径
function Add_Cron() {
    local ListAdd=$1
    local ListCronTmp=$LogTmpDir/crontab_tmp.list
    [ -f $ListCronTmp ] && rm -f $ListCronTmp
    if [ -s $ListAdd ] && [ -s $ListCrontabUser ]; then
        local Detail=$(cat $ListAdd)
        for path in $Detail; do

            local ScriptSuffix=$(echo ${path##*.})
            local ScriptName=$(echo ${path##*/} | awk -F "." '{print $1}')
            ## 判断表达式所在行
            local Tmp1=$(grep -E "^cron|^Cron|script-path=|tag=|[0-9] \* \*|^[0-9]\*.*${ScriptName}" ${path} | grep -Ev "^https\?:|^function " | head -1 | perl -pe '{s|[a-zA-Z\"\.\=\:\_]||g;}')
            ## 判断开头
            local Tmp2=$(echo "${Tmp1}" | awk -F '[0-9]' '{print$1}' | sed 's/\*/\\*/g; s/\./\\./g')
            ## 判断表达式的第一个数字（分钟）
            local Tmp3=$(echo "${Tmp1}" | grep -Eo "[0-9]" | head -1)
            ## 判定开头是否为空值
            if [[ $(echo "${Tmp2}" | perl -pe '{s| ||g;}') = "" ]]; then
                local Cron=$(echo "${Tmp1}" | awk '{if($1~/^[0-9]{1,2}/) print $1,$2,$3,$4,$5; else if ($1~/^[*]/) print $2,$3,$4,$5,$6}')
            else
                local Cron=$(echo "${Tmp1}" | perl -pe "{s|${Tmp2}${Tmp3}|${Tmp3}|g;}" | awk '{if($1~/^[0-9]{1,2}/) print $1,$2,$3,$4,$5; else if ($1~/^[*]/) print $2,$3,$4,$5,$6}')
            fi
            ## 如果未检测出定时就随机一个每天执行1次的定时
            echo "${Tmp1}" | grep "[0-9]" -q
            if [ $? -eq 0 ]; then
                echo "$Cron $TaskCmd ${path}" | sort -u | head -1 >>$ListCronTmp
            else
                echo "$((${RANDOM} % 60)) $((${RANDOM} % 24)) * * * $TaskCmd ${path}" | sort -u | head -1 >>$ListCronTmp
            fi
        done
        perl -i -pe "s|(# 项目定时任务结束.+)|$(cat $ListCronTmp)\n\1|" $ListCrontabUser
        ExitStatus=$?
    fi
    [ -f $ListCronTmp ] && rm -f $ListCronTmp
}

## 向系统添加定时任务以及通知
## 注释  $1：写入crontab.list时的exit状态，$2：新增清单文件路径，$3：Repo仓库脚本/Raw脚本
function Add_Cron_Notify() {
    local Status_Code=$1
    local ListAdd=$2
    local Tmp=$(echo $(cat $ListAdd))
    local Detail=$(echo $Tmp | perl -pe "s| |\\\n|g")
    local Type=$3
    if [[ $Status_Code -eq 0 ]]; then
        crontab $ListCrontabUser
        echo -e "$SUCCESS 已添加新的定时任务\n"
        if [[ ${EnableAddCronNotify} == true ]]; then
            Notify "新增定时任务通知" "已添加新的定时任务（$Type）：\n\n$Detail"
        fi
    else
        echo -e "添加新的定时任务出错，请手动添加...\n"
        if [[ ${EnableAddCronNotify} == true ]]; then
            Notify "新增定时任务添加异常通知" "尝试自动添加以下新的定时任务出错，请尝试手动添加（$Type）：\n\n$Detail"
        fi
    fi
}

## 删除定时任务
function Update_Cron() {
    ## 生成定时任务脚本的绝对路径清单
    Gen_ListCron
    ## 比较定时任务
    Diff_Cron $ListAll $ListUser $ListAdd $ListDrop
    case $1 in
    repo)
        if [[ ${#Array_Repo_url[*]} -gt 0 ]]; then
            ## 比对清单
            grep -v "$RawDir/" $ListAdd 2>/dev/null >$ListRepoAdd
            grep -v "$RawDir/" $ListDrop 2>/dev/null >$ListRepoDrop

            ## 删除定时任务 & 通知
            if [[ ${AutoDelRepoCron} == true ]] && [[ $(cat $ListRepoDrop) != '' ]]; then
                Output_List_Add_Drop $ListRepoDrop "失效"
                Del_Cron $ListRepoDrop $TaskCmd
            fi
            ## 新增定时任务 & 通知
            if [[ ${AutoAddRepoCron} == true ]] && [[ $(cat $ListRepoAdd) != '' ]]; then
                Output_List_Add_Drop $ListRepoAdd "新"
                Add_Cron $ListRepoAdd
                Add_Cron_Notify $ExitStatus $ListAddNames " Repo 仓库脚本"
            fi
        else
            perl -i -ne "{print unless / $TaskCmd \/jd\/repo/}" $ListCrontabUser
        fi
        ;;
    raw)
        if [[ ${#RawFile[*]} -gt 0 ]]; then
            ## 比对清单
            grep "$RawDir/" $ListAdd 2>/dev/null >$ListRawAdd
            grep "$RawDir/" $ListDrop 2>/dev/null >$ListRawDrop

            ## 删除定时任务 & 通知
            if [[ ${AutoDelRawCron} == true ]] && [ -s $ListRawDrop ]; then
                Output_List_Add_Drop $ListRawDrop "失效"
                Del_Cron $ListRawDrop $TaskCmd
            fi
            ## 新增定时任务 & 通知
            if [[ ${AutoAddRawCron} == true ]] && [ -s $ListRawAdd ]; then
                Output_List_Add_Drop $ListRawAdd "新"
                Add_Cron $ListRawAdd
                Add_Cron_Notify $ExitStatus $ListAddNames " Raw 脚本"
            fi

        else
            perl -i -ne "{print unless / $TaskCmd \/jd\/raw/}" $ListCrontabUser
        fi
        ;;
    all)
        if [[ ${#Array_Repo_url[*]} -gt 0 ]]; then
            ## 比对清单
            grep -v "$RawDir/" $ListAdd 2>/dev/null >$ListRepoAdd
            grep -v "$RawDir/" $ListDrop 2>/dev/null >$ListRepoDrop

            ## 删除定时任务 & 通知
            if [[ ${AutoDelRepoCron} == true ]] && [[ $(cat $ListRepoDrop) != '' ]]; then
                Output_List_Add_Drop $ListRepoDrop "失效"
                Del_Cron $ListRepoDrop $TaskCmd
            fi
            ## 新增定时任务 & 通知
            if [[ ${AutoAddRepoCron} == true ]] && [[ $(cat $ListRepoAdd) != '' ]]; then
                Output_List_Add_Drop $ListRepoAdd "新"
                Add_Cron $ListRepoAdd
                Add_Cron_Notify $ExitStatus $ListAddNames " Repo 仓库脚本"
            fi
        else
            perl -i -ne "{print unless / $TaskCmd \/jd\/repo/}" $ListCrontabUser
        fi
        if [[ ${#RawFile[*]} -gt 0 ]]; then
            ## 比对清单
            grep "$RawDir/" $ListAdd 2>/dev/null >$ListRawAdd
            grep "$RawDir/" $ListDrop 2>/dev/null >$ListRawDrop

            ## 删除定时任务 & 通知
            if [[ ${AutoDelRawCron} == true ]] && [ -s $ListRawDrop ]; then
                Output_List_Add_Drop $ListRawDrop "失效"
                Del_Cron $ListRawDrop $TaskCmd
            fi
            ## 新增定时任务 & 通知
            if [[ ${AutoAddRawCron} == true ]] && [ -s $ListRawAdd ]; then
                Output_List_Add_Drop $ListRawAdd "新"
                Add_Cron $ListRawAdd
                Add_Cron_Notify $ExitStatus $ListAddNames " Raw 脚本"
            fi

        else
            perl -i -ne "{print unless / $TaskCmd \/jd\/raw/}" $ListCrontabUser
        fi
        ;;
    esac
}

## 更新所有仓库
function Update_Repo() {
    for ((i = 0; i < ${#Array_Repo_url[*]}; i++)); do
        ## 判断仓库是否启用
        [[ ${Array_Repo_status[i]} == "false" ]] && continue
        if [ -d ${Array_Repo_path[i]}/.git ]; then
            Reset_Romote_Url ${Array_Repo_path[i]} ${Array_Repo_url[i]} ${Array_Repo_branch[i]}
            Git_Pull ${Array_Repo_path[i]} ${Array_Repo_branch[i]}
            if [[ $ExitStatus -eq 0 ]]; then
                echo -e "\n$COMPLETE ${BLUE}${Array_Repo_dir[i]}${PLAIN} 仓库更新完成"
            else
                echo -e "\n$FAIL ${BLUE}${Array_Repo_dir[i]}${PLAIN} 仓库更新失败，请检查原因..."
            fi
        else
            Git_Clone ${Array_Repo_url[i]} ${Array_Repo_path[i]} ${Array_Repo_branch[i]}
            if [[ $ExitStatus -eq 0 ]]; then
                echo -e "\n$SUCCESS ${BLUE}${Array_Repo_dir[i]}${PLAIN} 克隆仓库成功"
            else
                echo -e "\n$FAIL ${BLUE}${Array_Repo_dir[i]}${PLAIN} 克隆仓库失败，请检查原因..."
            fi
        fi
    done
}

## 更新所有 Raw 脚本
function Update_RawFile() {
    local RawFileName RemoveMark FormatUrl ReformatUrl RepoBranch RepoUrl RepoPlatformUrl DownloadUrl
    for ((i = 0; i < ${#RawFile[*]}; i++)); do
        ## 定义脚本名称
        RawFileName[$i]=$(echo ${RawFile[i]} | awk -F "/" '{print $NF}')

        ## 判断脚本来源（ 托管仓库 or 普通网站 ）
        echo ${RawFile[i]} | grep -Eq "github|gitee|gitlab"
        if [ $? -eq 0 ]; then
            ## 纠正链接地址（将传入的链接地址转换为对应代码托管仓库的raw原始文件链接地址）
            echo ${RawFile[i]} | grep "\.com\/.*\/blob\/.*" -q
            if [ $? -eq 0 ]; then
                case $(echo ${RawFile[i]} | grep -Eo "github|gitee|gitlab") in
                github)
                    echo ${RawFile[i]} | grep "github\.com\/.*\/blob\/.*" -q
                    if [ $? -eq 0 ]; then
                        DownloadUrl=$(echo ${RawFile[i]} | perl -pe "{s|github\.com/|raw\.githubusercontent\.com/|g; s|\/blob\/|\/|g}")
                    else
                        DownloadUrl=${RawFile[i]}
                    fi
                    ;;
                gitee)
                    echo ${RawFile[i]} | grep "gitee\.com\/.*\/blob\/.*" -q
                    if [ $? -eq 0 ]; then
                        DownloadUrl=$(echo ${RawFile[i]} | sed "s/\/blob\//\/raw\//g")
                    else
                        DownloadUrl=${RawFile[i]}
                    fi
                    ;;
                gitlab)
                    echo ${RawFile[i]} | grep "gitlab\.com\/.*\/blob\/.*" -q
                    if [ $? -eq 0 ]; then
                        DownloadUrl=$(echo ${RawFile[i]} | sed "s/\/blob\//\/raw\//g")
                    else
                        DownloadUrl=${RawFile[i]}
                    fi
                    ;;
                esac
            else
                ## 原始链接
                DownloadUrl=${RawFile[i]}
            fi

            echo ${DownloadUrl} | grep -E "git.*\.io/" -q
            if [ $? -eq 0 ]; then
                echo -e "\n$WORKING 开始从网站 ${BLUE}$(echo ${RawFile[i]} | perl -pe "{s|\/${RawFileName[$i]}||g;}")${PLAIN} 下载 ${BLUE}${RawFileName[$i]}${PLAIN} 脚本..."
            else
                ## 处理仓库地址
                FormatUrl=$(echo ${DownloadUrl} | perl -pe "{s|${RawFileName[$i]}||g;}" | awk -F '.com' '{print$NF}' | sed 's/.$//')
                ## 判断仓库平台
                case $(echo ${DownloadUrl} | grep -Eo "github|gitee|gitlab") in
                github)
                    RepoPlatformUrl="https://github.com"
                    RepoBranch=$(echo $FormatUrl | awk -F '/' '{print$4}')
                    ReformatUrl=$(echo $FormatUrl | sed "s|$RepoBranch|tree/$RepoBranch|g")
                    ## 定义脚本来源仓库地址链接
                    RepoUrl="${RepoPlatformUrl}${ReformatUrl}"
                    ;;
                gitee)
                    RepoPlatformUrl="https://gitee.com"
                    ReformatUrl=$(echo $FormatUrl | sed "s|/raw/|/tree/|g")
                    ## 定义脚本来源仓库地址链接
                    RepoUrl="${RepoPlatformUrl}${ReformatUrl}"
                    ;;
                gitlab)
                    ## 定义脚本来源仓库地址链接
                    RepoUrl=${DownloadUrl}
                    ;;
                esac
                ## 拉取脚本
                echo -e "\n$WORKING 开始从仓库 ${BLUE}${RepoUrl}${PLAIN} 下载 ${BLUE}${RawFileName[$i]}${PLAIN} 脚本..."
            fi
            wget -q --no-check-certificate -O "$RawDir/${RawFileName[$i]}.new" ${DownloadUrl} -T 20
        else
            ## 拉取脚本
            DownloadUrl=${RawFile[i]}
            echo -e "\n$WORKING 开始从网站 ${BLUE}$(echo ${RawFile[i]} | perl -pe "{s|\/${RawFileName[$i]}||g;}")${PLAIN} 下载 ${BLUE}${RawFileName[$i]}${PLAIN} 脚本..."
            wget -q --no-check-certificate -O "$RawDir/${RawFileName[$i]}.new" ${DownloadUrl} -T 20
        fi
        if [ $? -eq 0 ]; then
            mv -f "$RawDir/${RawFileName[$i]}.new" "$RawDir/${RawFileName[$i]}"
            echo -e "$COMPLETE ${RawFileName[$i]} 下载完成，脚本保存路径：$RawDir/${RawFileName[$i]}"
        else
            echo -e "$FAIL ${RawFileName[$i]} 下载异常，保留之前正常下载的版本...\n"
            [ -f "$RawDir/${RawFileName[$i]}.new" ] && rm -f "$RawDir/${RawFileName[$i]}.new"
        fi
    done
    if [[ $(ls $RawDir 2>/dev/null | grep -Ev "${RawDirUtils}") ]]; then
        for file in $(ls $RawDir 2>/dev/null | grep -Ev "${RawDirUtils}"); do
            RemoveMark="yes"
            for ((i = 0; i < ${#RawFileName[*]}; i++)); do
                if [[ $file == ${RawFileName[$i]} ]]; then
                    RemoveMark="no"
                    break
                fi
            done
            [[ $RemoveMark == yes ]] && rm -f $RawDir/$file 2>/dev/null
        done
    fi
}

## 更新项目源码
function Update_Shell() {
    local PanelDependOld PanelDependNew
    echo -e "-------------------------------------------------------------"
    ## 更新前先存储 package.json
    [ -f $PanelDir/package.json ] && PanelDependOld=$(cat $PanelDir/package.json)
    ## 随机更新任务的定时
    Random_Update_Cron
    ## 更新仓库
    cd $RootDir
    echo -e "\n$WORKING 开始更新项目源码\n"
    git fetch --all
    git pull
    git reset --hard origin/$(git status | head -n 1 | awk -F ' ' '{print$NF}')
    if [[ $ExitStatus -eq 0 ]]; then
        echo -e "\n$COMPLETE 源码已更新\n"
    else
        echo -e "\n$FAIL 源码更新失败，请检查原因...\n"
    fi
    ## 检测面板模块变动
    [ -f $PanelDir/package.json ] && PanelDependNew=$(cat $PanelDir/package.json)
    if [[ "$PanelDependOld" != "$PanelDependNew" ]]; then
        if [[ $ENABLE_WEB_PANEL = true ]]; then
            pm2 delete server >/dev/null 2>&1
            $ContrlCmd panel on
        else
            Npm_Install_Upgrade $PanelDir
        fi
    fi
    ## 检测配置文件版本
    Detect_Config_Version
}

## 更新 Repo 仓库和 RawFile 脚本
function UpdateMain() {
    Make_Dir $RepoDir
    Make_Dir $RawDir
    Count_RepoSum
    Gen_RepoConf
    local EnableRepoUpdate EnableRawUpdate
    case $1 in
    all)
        EnableRepoUpdate="true"
        EnableRawUpdate="true"
        ;;
    repo)
        EnableRepoUpdate="true"
        EnableRawUpdate="false"
        if [[ $RepoSum -eq 0 ]]; then
            Processing_Crontab
            Notice
            exit ## 终止退出
        fi
        ;;
    raw)
        EnableRepoUpdate="false"
        EnableRawUpdate="true"
        if [[ ${#RawFile[*]} -eq 0 ]]; then
            echo -e "\n$ERROR 请先在 $FileConfUser 中配置好您的 RawFile 脚本！\n"
            exit ## 终止退出
        fi
        Title $1
        ;;
    esac

    if [[ ${EnableRepoUpdate} == true ]] && [[ ${EnableRawUpdate} == true ]]; then
        # Update_Repo
        Update_RawFile
        Update_Cron "all"
    else
        if [[ ${EnableRepoUpdate} == true ]]; then
            # Update_Repo
            Update_Cron "repo"
        fi
        if [[ ${EnableRawUpdate} == true ]]; then
            Update_RawFile
            Update_Cron "raw"
        fi

    fi
}

## 自定义脚本
function ExtraShell() {
    if [[ ${EnableExtraShell} = true || ${EnableExtraShellSync} = true ]]; then
        echo -e "-------------------------------------------------------------\n"
    fi
    ## 同步用户的 extra.sh
    if [[ $EnableExtraShellSync == true ]] && [[ $ExtraShellSyncUrl ]]; then
        echo -e "$WORKING 开始同步自定义脚本：$ExtraShellSyncUrl\n"
        wget -q --no-check-certificate $ExtraShellSyncUrl -O $FileExtra.new -T 20
        if [ $? -eq 0 ]; then
            mv -f "$FileExtra.new" "$FileExtra"
            echo -e "$COMPLETE 自定义脚本同步完成\n"
            sleep 1s
        else
            if [ -f $FileExtra ]; then
                echo -e "$FAIL 自定义脚本同步失败，保留之前的版本...\n"
            else
                echo -e "$FAIL 自定义脚本同步失败，请检查原因...\n"
            fi
            sleep 2s
        fi
        [ -f "$FileExtra.new" ] && rm -rf "$FileExtra.new"
    fi
    ## 执行用户的 extra.sh
    if [[ $EnableExtraShell == true ]]; then
        ## 执行
        if [ -f $FileExtra ]; then
            echo -e "$WORKING 开始执行自定义脚本：$FileExtra\n"
            . $FileExtra
            echo -e "\n$COMPLETE 自定义脚本执行完毕\n"
        else
            echo -e "$ERROR 自定义脚本不存在，跳过执行...\n"
        fi
    fi
}

## 更新指定路径下的仓库
function Update_Designated() {
    local InputContent AbsolutePath PwdTmp
    ## 去掉最后一个/
    echo $1 | grep "/$" -q
    if [ $? -eq 0 ]; then
        local InputContent=${1%?}
    else
        local InputContent=$1
    fi
    ## 判定传入的是绝对路径还是相对路径
    echo ${InputContent} | grep "^$RootDir" -q
    if [ $? -eq 0 ]; then
        AbsolutePath=${InputContent}
    else
        ## 处理上级目录
        echo ${InputContent} | grep "\.\./" -q
        if [ $? -eq 0 ]; then
            PwdTmp=$(pwd | perl -pe "{s|/$(pwd | awk -F '/' '{printf$NF}')||g;}")
            AbsolutePath=$(echo "${InputContent}" | perl -pe "{s|\.\./|${PwdTmp}/|;}")
        else
            AbsolutePath=$(echo "${InputContent}" | perl -pe "{s|\.\/||; s|^*|$(pwd)/|;}")
        fi
    fi
    ## 判定是否存在仓库
    if [ -d ${AbsolutePath}/.git ]; then
        if [[ "${AbsolutePath}" = "$RootDir" ]]; then
            Title "shell"
            Update_Shell
        else

            Title "designated"
            echo -e "-------------------------------------------------------------"

            Make_Dir $RepoDir
            Count_RepoSum
            Gen_RepoConf
            Git_Pull ${AbsolutePath} $(grep "branch" ${AbsolutePath}/.git/config | awk -F '\"' '{print$2}')
            Update_Cron "all"
            if [[ $ExitStatus -eq 0 ]]; then
                echo -e "\n$COMPLETE ${BLUE}${Array_Repo_dir[i]}${PLAIN} 仓库更新完成"
            else
                echo -e "\n$FAIL ${BLUE}${Array_Repo_dir[i]}${PLAIN} 仓库更新失败，请检查原因..."
            fi
        fi
    else
        if [ -d ${AbsolutePath} ]; then
            echo -e "\n$ERROR 未检测到 ${BLUE}${AbsolutePath}${PLAIN} 路径下存在任何仓库，请重新确认！\n"
        else
            echo -e "\n$ERROR 未检测到 ${BLUE}${AbsolutePath}${PLAIN} 路径不存在，请重新确认！\n"
        fi
        exit ## 终止退出
    fi
}

## 处理 Crontab
function Processing_Crontab() {
    ## 规范 crontab.list 中的命令
    perl -i -pe "s|( ?&>/dev/null)+||g" $ListCrontabUser
    ## 同步定时清单
    Synchronize_Crontab
}

function Title() {
    local p=$1
    local RunMod
    case $1 in
    all)
        RunMod=" 全 部 内 容 "
        ;;
    shell)
        RunMod=" 项 目 源 码 "
        ;;
    repo)
        RunMod=" 所 有 仓 库 "
        ;;
    raw)
        RunMod=" 扩 展 脚 本 "
        ;;
    extra)
        RunMod=" 自 定 脚 本 "
        ;;
    designated)
        RunMod=" 指 定 仓 库 "
        ;;
    esac
    echo -e "\n+-------------------- 执 行 更 新 程 序 --------------------+"
    echo -e ''
    echo -e "                   更新模式：${BLUE}${RunMod}${PLAIN}  "
    echo -e ''
    echo -e "                系统时间：${BLUE}$(date "+%Y-%m-%d %T")${PLAIN}"
    echo -e ''
}

function Notice() {
    echo -e "+----------------------- 郑 重 提 醒 -----------------------+

  本项目为非营利性的公益闭源项目，脚本免费使用仅供用于学习！

  项目资源禁止以任何形式发布到咸鱼等国内平台，否则后果自负！

  我们始终致力于打击使用本项目进行非法贩售行为的个人或组织！

  我们不会放纵某些行为，不保证不采取非常手段，请勿挑战底线！

+--------------- 请遵循本项目宗旨 - 低调使用 ---------------+\n"
}

function Main() {

    case $# in
    0)
        Help $UpdateCmd
        ;;
    1)
        case $1 in
        all)
            Title $1
            Update_Shell
            UpdateMain "all"
            ExtraShell
            ;;
        shell)
            Title $1
            Update_Shell
            ;;
        repo)
            Title $1
            UpdateMain "repo"
            ;;
        raw)
            UpdateMain "raw"
            ;;
        extra)
            if [[ $EnableExtraShellSync == true ]] || [[ $EnableExtraShell == true ]]; then
                Title $1
                ExtraShell
            else
                echo -e "\n$ERROR 请先在 $FileConfUser 中启用关于 Extra 自定义脚本的相关变量！\n"
            fi
            ;;
        *)
            ## 判断传入参数
            echo $1 | grep "\/" -q
            if [ $? -eq 0 ]; then
                Update_Designated $1
            else
                if [ -d "$(pwd)/$1" ]; then
                    if [[ "$1" = "." ]]; then
                        Update_Designated "$(pwd)"
                    elif [[ "$1" = "./" ]]; then
                        Update_Designated "$(pwd)"
                    else
                        Update_Designated "$(pwd)/$1"
                    fi
                else
                    Output_Command_Error 1 ## 命令错误
                    exit                   ## 终止退出
                fi
            fi
            ;;
        esac
        Processing_Crontab
        # Notice
        exit ## 终止退出
        ;;
    *)
        Output_Command_Error 2 ## 命令过多
        ;;
    esac
}

Main $@ | tee -a $LogDir/update.log
