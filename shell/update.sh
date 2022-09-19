#!/bin/bash
## Author: SuperManito
## Modified: 2022-09-20

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
    echo -e "\n$WORKING 开始克隆仓库 ${BLUE}$Url${PLAIN} 到 ${BLUE}$Dir${PLAIN}\n"
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

## 统计 own 仓库数量
function Count_OwnRepoSum() {
    if [[ -z ${OwnRepoUrl1} ]]; then
        OwnRepoSum=0
    else
        for ((i = 1; i <= 0x64; i++)); do
            local Tmp1=OwnRepoConfig$i
            local Tmp2=${!Tmp1}
            [[ $Tmp2 ]] && OwnRepoSum=$i || break
        done
    fi
}

## 生成仓库配置清单数组
## 生成 own 仓库信息的数组，组依赖于 Import_Conf 或 Import_Config_Not_Check
## array_own_repo_path：repo存放的绝对路径组成的数组；array_own_scripts_path：所有要使用的脚本所在的绝对路径组成的数组
# 仓库名称 array_own_repo_name
# 远程地址 array_own_repo_url
# 分支名称 array_own_repo_branch
# 存放仓库文件夹名 array_own_repo_dir
# 仓库本地绝对路径 array_own_repo_path
# 仓库启用状态 array_own_repo_status
# 仓库脚本定时设置 array_own_repo_cronSettings
function Gen_Own_Repo_Conf() {

    local scripts_path_num="-1"
    local arr_num TmpConf Tmp_name Tmp_url Tmp_branch Tmp_isEnable Tmp_cronSettings_isEnable Tmp_cronSettings_scriptsPath Tmp_cronSettings_whiteList Tmp_cronSettings_blackList Tmp_KeysValue

    if [[ $OwnRepoSum -ge 1 ]]; then
        for ((i = 1; i <= $OwnRepoSum; i++)); do
            arr_num=$((i - 1))

            # 读取仓库配置并检测语法
            TmpConf=OwnRepoConfig$i
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
            echo ${RepoUrl} | grep -Eq "\.git$" # 链接必须以.git结尾
            if [ $? -ne 0 ]; then
                # echo -e "$ERROR 检测到第$i个仓库配置的远程地址无效，跳过..."
                continue
            fi
            echo ${RepoUrl} | grep -Eq "http.*:"
            if [ $? -ne 0 ]; then
                echo ${RepoUrl} | grep -Eq "^git\@"
                if [ $? -ne 0 ]; then
                    # echo -e "$ERROR 检测到第$i个仓库配置的远程地址无效，跳过..."
                    continue
                fi
            fi

            ## 仓库分支（如若未定义或格式错误则跳过视为无效配置）
            Tmp_branch="$(JSON_Parse "${!TmpConf}" ". branch")"
            if [[ -z ${Tmp_branch} ]] || [[ ${Tmp_branch} == "null" ]]; then
                # echo -e "$ERROR 未检测到第$i个仓库配置的分支名称，跳过..."
                continue
            fi

            array_own_repo_url[$arr_num]="${Tmp_url}"
            array_own_repo_branch[$arr_num]="${Tmp_branch}"

            ## 仓库名称（如若未定义则采用远程地址中的仓库名称）
            Tmp_name="$(JSON_Parse "${!TmpConf}" ".name")"
            if [[ $Tmp_branch == "null" ]]; then
                array_own_repo_name[$arr_num]="$(echo ${array_own_repo_url[$arr_num]} | perl -pe "s|\.git||" | awk -F "/|:" '{print$NF}')"
            else
                array_own_repo_name[$arr_num]="${Tmp_name}"
            fi

            ## 仓库路径
            array_own_repo_dir[$arr_num]="$(echo ${array_own_repo_url[$arr_num]} | perl -pe "s|\.git||" | awk -F "/|:" '{print $((NF - 1)) "_" $NF}')"
            array_own_repo_path[$arr_num]="$OwnDir/${array_own_repo_dir[$arr_num]}"

            ## 仓库启用状态（默认启用仓库，即使键名键值未定义或键值定义错误）
            Tmp_isEnable="$(JSON_Parse "${!TmpConf}" ".isEnable")"
            if [[ $Tmp_branch == true ]]; then
                array_own_repo_status[$arr_num]="true"
            else
                array_own_repo_status[$arr_num]="false"
            fi

            ## 仓库定时任务配置
            Tmp_cronSettings="$(JSON_Parse "${!TmpConf}" ".cronSettings")"

            # 定时启用状态（如若未定义或格式错误则默认禁用）
            Tmp_KeysValue="$(JSON_Parse "${Tmp_cronSettings}" ".isEnable")"
            if [[ "${Tmp_KeysValue}" == true ]]; then
                Tmp_cronSettings_isEnable="true"
            else
                Tmp_cronSettings_isEnable="false"
            fi
            # 定时脚本路径（如若未定义或格式错误则默认为空）
            Tmp_KeysValue="$(JSON_Parse "${Tmp_cronSettings}" ".scriptsPath")"
            if [[ "${Tmp_KeysValue}" == "null" ]]; then
                Tmp_cronSettings_scriptsPath=""
            else
                Tmp_cronSettings_scriptsPath="${Tmp_KeysValue}"
            fi
            # 定时脚本白名单（如若未定义则默认为空）
            Tmp_KeysValue="$(JSON_Parse "${Tmp_cronSettings}" ".whiteList")"
            if [[ "${Tmp_KeysValue}" == "null" ]]; then
                Tmp_cronSettings_whiteList=""
            else
                Tmp_cronSettings_whiteList="${Tmp_KeysValue}"
            fi
            # 定时脚本黑名单（如若未定义则默认为空）
            Tmp_KeysValue="$(JSON_Parse "${Tmp_cronSettings}" ".blackList")"
            if [[ "${Tmp_KeysValue}" == "null" ]]; then
                Tmp_cronSettings_blackList=""
            else
                Tmp_cronSettings_blackList="${Tmp_KeysValue}"
            fi
            # 生成配置
            array_own_repo_cronSettings[$arr_num]="{
                isEnable: \"${Tmp_cronSettings_isEnable}\",
                scriptsPath: \"${Tmp_cronSettings_scriptsPath}\",
                whiteList: \"${Tmp_cronSettings_whiteList}\",
                blackList: \"${Tmp_cronSettings_blackList}\"
            }"
        done
    fi
}

## 生成 own 定时任务脚本的绝对路径清单
function Gen_ListOwn() {
    local Matching isEnable scriptsPath whiteList blackList ScriptSuffix
    local MatchScriptsType="\.js$|\.py$|\.ts$"
    local CurrentDir=$(pwd)

    ## 先导入用户的定时
    local ListCrontabOwnTmp=$LogTmpDir/crontab_own.list
    Make_Dir $LogTmpDir
    [ ! -f $ListOwnScripts ] && touch $ListOwnScripts
    grep -vwf $ListOwnScripts $ListCrontabUser | grep -Eq " $TaskCmd $OwnDir"
    local ExitStatus=$?
    [[ $ExitStatus -eq 0 ]] && grep -vwf $ListOwnScripts $ListCrontabUser | grep -E " $TaskCmd $OwnDir" | perl -pe "s|.*$TaskCmd ([^\s]+)( .+\|$)|\1|" | sort -u >$ListCrontabOwnTmp
    rm -rf $LogTmpDir/own*.list

    # 仓库名称 array_own_repo_name
    # 远程地址 array_own_repo_url
    # 分支名称 array_own_repo_branch
    # 存放仓库文件夹名 array_own_repo_dir
    # 仓库本地绝对路径 array_own_repo_path
    # 仓库启用状态 array_own_repo_status
    # 仓库脚本定时设置 array_own_repo_cronSettings

    ## 循环处理各个仓库配置
    for ((i = 0; i < ${#array_own_repo_name[*]}; i++)); do
        # 判断仓库是否启用
        [[ ${array_own_repo_status[i]} == false ]] && continue
        # 判断仓库是否启用定时
        isEnable=$(JSON_Parse "${array_own_repo_cronSettings[i]}" ".isEnable")
        [[ ${isEnable} == false ]] && continue

        ## 黑白名单
        whiteList=$(JSON_Parse "${array_own_repo_cronSettings[i]}" ".whiteList" | perl -pe '{s|^ ||g; s| $||g; s# #\|#g;}')
        blackList=$(JSON_Parse "${array_own_repo_cronSettings[i]}" ".blackList" | perl -pe '{s|^ ||g; s| $||g; s# #\|#g;}')

        ## 脚本路径（循环处理）
        scriptsPath=$(JSON_Parse "${array_own_repo_cronSettings[i]}" ".scriptsPath" | perl -pe '{s|^ ||g; s| $||g; s#\|# #g;}')
        for path in ${scriptsPath}; do
            ## 进入仓库根目录
            cd ${array_own_repo_path[i]}

            ## 判断是否存在子目录（值为空则代表根目录）
            if [[ ${path} ]]; then
                if [[ -d ${path} ]]; then
                    cd ${path}
                else
                    continue
                fi
            fi

            ## 判断路径下是否存在脚本
            if [[ $(ls | grep -E "${MatchScriptsType}") ]]; then

                ## 判断是否定义了黑名单并筛选符合条件的脚本
                if [[ -z ${blackList} ]]; then
                    Matching=$(ls | grep -E "${MatchScriptsType}" 2>/dev/null | grep -E "${whiteList}" | grep -Ev ${blackList})
                else
                    Matching=$(ls | grep -E "${MatchScriptsType}" 2>/dev/null | grep -E "${whiteList}")
                fi

                for file in ${Matching}; do
                    ## 判断脚本是否存在内容
                    if [ -s $file ]; then
                        ## 判断脚本路径是否包含仓库下子目录
                        if [[ ${path} ]]; then
                            echo "${array_own_repo_path[i]}/${path}/${file}" >>$ListOwnScripts
                        else
                            echo "${array_own_repo_path[i]}/${file}" >>$ListOwnScripts
                        fi
                    else
                        continue
                    fi
                done
            else
                continue
            fi
        done
    done

    if [[ ${#OwnRawFile[*]} -ge 1 ]]; then
        let scripts_path_num++
        array_own_scripts_path[$scripts_path_num]=$RawDir
        if [ ${array_own_scripts_path[i]} = $RawDir ]; then
            if [[ $(ls | grep -E "${MatchScriptsType}" | grep -Ev "${RawDirUtils}" 2>/dev/null) ]]; then
                for file in $(ls | grep -E "${MatchScriptsType}" | grep -Ev "${RawDirUtils}"); do
                    if [ -f $file ]; then
                        echo "$RawDir/$file" >>$ListOwnScripts
                    fi
                done
            fi
        fi
    fi

    [ ! -f $ListOwnScripts ] && touch $ListOwnScripts
    ## 汇总去重
    echo "$(sort -u $ListOwnScripts)" >$ListOwnScripts
    ## 导入用户的定时
    cat $ListOwnScripts >$ListOwnAll
    [[ $ExitStatus -eq 0 ]] && cat $ListCrontabOwnTmp >>$ListOwnAll

    if [[ $ExitStatus -eq 0 ]]; then
        grep -E " $TaskCmd $OwnDir" $ListCrontabUser | grep -Ev "$(cat $ListCrontabOwnTmp)" | perl -pe "s|.*$TaskCmd ([^\s]+)( .+\|$)|\1|" | sort -u >$ListOwnUser
        cat $ListCrontabOwnTmp >>$ListOwnUser
    else
        grep -E " $TaskCmd $OwnDir" $ListCrontabUser | perl -pe "s|.*$TaskCmd ([^\s]+)( .+\|$)|\1|" | sort -u >$ListOwnUser
    fi
    [ -f $ListCrontabOwnTmp ] && rm -f $ListCrontabOwnTmp
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

## 生成新增脚本名称清单
function Gen_AddScripts_Name() {
    local CurrentDir=$(pwd)
    local NameTmp DirTmp
    local List=$1
    local scriptArr=(
        $(cat $List)
    )
    rm -rf $ListOwnAddNames
    for script in ${scriptArr[@]}; do
        NameTmp=${script##*/}
        DirTmp=${script%/*}
        cd $DirTmp
        Query_ScriptName "${NameTmp}"
        echo "${ScriptName}" >>$ListOwnAddNames
        cd $CurrentDir
    done
}

## 输出是否有新的或失效的定时任务
## 注释  $1：新的或失效的任务清单文件路径，$2：新/失效
function Output_List_Add_Drop() {
    local List=$1
    local Type=$2
    if [ -s $List ]; then
        echo -e "\n检测到有$Type的定时任务：\n"
        if [[ ${Type} == "新" ]]; then
            local ListArr=(
                $(cat $List)
            )
            Gen_AddScripts_Name $List
            local NameListArr=(
                $(cat $ListOwnAddNames)
            )
            rm -rf $ListOwnAddNames
            for ((i = 0; i < ${#ListArr[@]}; i++)); do
                echo -e "${ListArr[i]} ➜  ${NameListArr[i]}" | tee -a $ListOwnAddNames
            done
        else
            cat $List
        fi
        echo ''
    fi
}

## 自动删除失效的脚本与定时任务
## 需要：
##      1.AutoDelCron/AutoDelOwnRepoCron/AutoDelOwnRawCron 设置为 true；
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
        echo -e "$WORKING 开始删除定时任务...\n"
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
##      1.AutoAddOwnRepoCron/AutoAddOwnRawCron 设置为 true；
##      2.正常更新脚本，没有报错；
##      3.存在新任务；
##      4.crontab.list存在并且不为空
## 注释  $1：新任务清单文件路径
function Add_Cron_Own() {
    local ListAdd=$1
    local ListCrontabOwnTmp=$LogTmpDir/crontab_own.list
    [ -f $ListCrontabOwnTmp ] && rm -f $ListCrontabOwnTmp
    if [ -s $ListAdd ] && [ -s $ListCrontabUser ]; then
        echo -e "$WORKING 开始添加 own 脚本的定时任务...\n"
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
                echo "$Cron $TaskCmd ${path}" | sort -u | head -1 >>$ListCrontabOwnTmp
            else
                echo "$((${RANDOM} % 60)) $((${RANDOM} % 24)) * * * $TaskCmd ${path}" | sort -u | head -1 >>$ListCrontabOwnTmp
            fi
        done
        perl -i -pe "s|(# 自用own任务结束.+)|$(cat $ListCrontabOwnTmp)\n\1|" $ListCrontabUser
        ExitStatus=$?
    fi
    [ -f $ListCrontabOwnTmp ] && rm -f $ListCrontabOwnTmp
}

## 向系统添加定时任务以及通知
## 注释  $1：写入crontab.list时的exit状态，$2：新增清单文件路径，$3：Scripts仓库脚本/Own仓库脚本/Raw脚本
function Add_Cron_Notify() {
    local Status_Code=$1
    local ListAdd=$2
    local Tmp=$(echo $(cat $ListAdd))
    local Detail=$(echo $Tmp | perl -pe "s| |\\\n|g")
    local Type=$3
    if [[ $Status_Code -eq 0 ]]; then
        crontab $ListCrontabUser
        echo -e "$SUCCESS 成功添加新的定时任务\n"
        if [[ ${EnableAddCronNotify} == true ]]; then
            Notify "新增定时任务通知" "已添加新的定时任务（$Type）：\n\n$Detail"
        fi
    else
        echo -e "添加新的定时任务出错，请手动添加...\n"
        if [[ ${EnableAddCronNotify} == true ]]; then
            Notify "新任务添加失败通知" "尝试自动添加以下新的定时任务出错，请尝试手动添加（$Type）：\n\n$Detail"
        fi
    fi
}

## 更新所有 Own 仓库
function Update_OwnRepo() {
    for ((i = 0; i < ${#array_own_repo_url[*]}; i++)); do
        ## 判断仓库是否启用
        [[ ${array_own_repo_status[i]} == "false" ]] && continue
        if [ -d ${array_own_repo_path[i]}/.git ]; then
            Reset_Romote_Url ${array_own_repo_path[i]} ${array_own_repo_url[i]} ${array_own_repo_branch[i]}
            Git_Pull ${array_own_repo_path[i]} ${array_own_repo_branch[i]}
            if [[ $ExitStatus -eq 0 ]]; then
                echo -e "\n$COMPLETE ${BLUE}${array_own_repo_dir[i]}${PLAIN} 仓库更新完成"
            else
                echo -e "\n$FAIL ${BLUE}${array_own_repo_dir[i]}${PLAIN} 仓库更新失败，请检查原因..."
            fi
        else
            Git_Clone ${array_own_repo_url[i]} ${array_own_repo_path[i]} ${array_own_repo_branch[i]}
            if [[ $ExitStatus -eq 0 ]]; then
                echo -e "\n$SUCCESS ${BLUE}${array_own_repo_dir[i]}${PLAIN} 克隆仓库成功"
            else
                echo -e "\n$FAIL ${BLUE}${array_own_repo_dir[i]}${PLAIN} 克隆仓库失败，请检查原因..."
            fi
        fi
    done
}

## 更新所有 Raw 脚本
function Update_RawFile() {
    local RawFileName RemoveMark FormatUrl ReformatUrl RepoBranch RepoUrl RepoPlatformUrl DownloadUrl
    for ((i = 0; i < ${#OwnRawFile[*]}; i++)); do
        ## 定义脚本名称
        RawFileName[$i]=$(echo ${OwnRawFile[i]} | awk -F "/" '{print $NF}')

        ## 判断脚本来源（ 托管仓库 or 普通网站 ）
        echo ${OwnRawFile[i]} | grep -Eq "github|gitee|gitlab"
        if [ $? -eq 0 ]; then
            ## 纠正链接地址（将传入的链接地址转换为对应代码托管仓库的raw原始文件链接地址）
            echo ${OwnRawFile[i]} | grep "\.com\/.*\/blob\/.*" -q
            if [ $? -eq 0 ]; then
                case $(echo ${OwnRawFile[i]} | grep -Eo "github|gitee|gitlab") in
                github)
                    echo ${OwnRawFile[i]} | grep "github\.com\/.*\/blob\/.*" -q
                    if [ $? -eq 0 ]; then
                        DownloadUrl=$(echo ${OwnRawFile[i]} | perl -pe "{s|github\.com/|raw\.githubusercontent\.com/|g; s|\/blob\/|\/|g}")
                    else
                        DownloadUrl=${OwnRawFile[i]}
                    fi
                    ;;
                gitee)
                    echo ${OwnRawFile[i]} | grep "gitee\.com\/.*\/blob\/.*" -q
                    if [ $? -eq 0 ]; then
                        DownloadUrl=$(echo ${OwnRawFile[i]} | sed "s/\/blob\//\/raw\//g")
                    else
                        DownloadUrl=${OwnRawFile[i]}
                    fi
                    ;;
                gitlab)
                    echo ${OwnRawFile[i]} | grep "gitlab\.com\/.*\/blob\/.*" -q
                    if [ $? -eq 0 ]; then
                        DownloadUrl=$(echo ${OwnRawFile[i]} | sed "s/\/blob\//\/raw\//g")
                    else
                        DownloadUrl=${OwnRawFile[i]}
                    fi
                    ;;
                esac
            else
                ## 原始链接
                DownloadUrl=${OwnRawFile[i]}
            fi

            echo ${DownloadUrl} | grep -E "git.*\.io/" -q
            if [ $? -eq 0 ]; then
                echo -e "\n$WORKING 开始从网站 ${BLUE}$(echo ${OwnRawFile[i]} | perl -pe "{s|\/${RawFileName[$i]}||g;}")${PLAIN} 下载 ${BLUE}${RawFileName[$i]}${PLAIN} 脚本..."
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
            DownloadUrl=${OwnRawFile[i]}
            echo -e "\n$WORKING 开始从网站 ${BLUE}$(echo ${OwnRawFile[i]} | perl -pe "{s|\/${RawFileName[$i]}||g;}")${PLAIN} 下载 ${BLUE}${RawFileName[$i]}${PLAIN} 脚本..."
            wget -q --no-check-certificate -O "$RawDir/${RawFileName[$i]}.new" ${DownloadUrl} -T 20
        fi
        if [ $? -eq 0 ]; then
            mv -f "$RawDir/${RawFileName[$i]}.new" "$RawDir/${RawFileName[$i]}"
            echo -e "$COMPLETE ${RawFileName[$i]} 下载完成，脚本保存路径：$RawDir/${RawFileName[$i]}"
        else
            echo -e "$FAIL 下载 ${RawFileName[$i]} 失败，保留之前正常下载的版本...\n"
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
    echo -e "\n$WORKING 开始更新项目源码：\n"
    git fetch --all
    git pull
    git reset --hard origin/$(git status | head -n 1 | awk -F ' ' '{print$NF}')
    if [[ $ExitStatus -eq 0 ]]; then
        echo -e "\n$COMPLETE 源码更新完成\n"
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

## 更新 Own Repo 仓库和 Own RawFile 脚本
function Update_Own() {
    Make_Dir $RawDir
    Count_OwnRepoSum
    Gen_Own_Repo_Conf
    local EnableRepoUpdate EnableRawUpdate
    case $1 in
    all)
        EnableRepoUpdate="true"
        EnableRawUpdate="true"
        ;;
    repo)
        EnableRepoUpdate="true"
        EnableRawUpdate="false"
        if [[ $OwnRepoSum -eq 0 ]]; then
            Processing_Crontab
            Notice
            exit ## 终止退出
        fi
        ;;
    raw)
        EnableRepoUpdate="false"
        EnableRawUpdate="true"
        if [[ ${#OwnRawFile[*]} -eq 0 ]]; then
            echo -e "\n$ERROR 请先在 $FileConfUser 中配置好您的 Own RawFile 脚本！\n"
            exit ## 终止退出
        fi
        Title $1
        ;;
    esac
    if [[ ${#array_own_repo_url[*]} -gt 0 ]]; then
        echo -e "-------------------------------------------------------------"
        ## 更新仓库
        if [[ ${EnableRepoUpdate} == true ]]; then
            Update_OwnRepo
        fi
        if [[ ${EnableRawUpdate} == true ]]; then
            Update_RawFile
        fi
        ## 比较定时任务
        Gen_ListOwn
        Diff_Cron $ListOwnAll $ListOwnUser $ListOwnAdd $ListOwnDrop
        ## Own Repo 仓库
        if [[ ${EnableRepoUpdate} == true ]]; then
            ## 比对清单
            grep -v "$RawDir/" $ListOwnAdd 2>/dev/null >$ListOwnRepoAdd
            grep -v "$RawDir/" $ListOwnDrop 2>/dev/null >$ListOwnRepoDrop

            ## 删除定时任务 & 通知
            if [[ ${AutoDelOwnRepoCron} == true ]] && [ -s $ListOwnRepoDrop ]; then
                Output_List_Add_Drop $ListOwnRepoDrop "失效"
                Del_Cron $ListOwnRepoDrop $TaskCmd
            fi
            ## 新增定时任务 & 通知
            if [[ ${AutoAddOwnRepoCron} == true ]] && [ -s $ListOwnRepoAdd ]; then
                Output_List_Add_Drop $ListOwnRepoAdd "新"
                Add_Cron_Own $ListOwnRepoAdd
                Add_Cron_Notify $ExitStatus $ListOwnAddNames " Own 仓库脚本"
            fi
        fi
        ## Own Raw 脚本
        if [[ ${EnableRawUpdate} == true ]]; then
            ## 比对清单
            grep "$RawDir/" $ListOwnAdd 2>/dev/null >$ListOwnRawAdd
            grep "$RawDir/" $ListOwnDrop 2>/dev/null >$ListOwnRawDrop

            ## 删除定时任务 & 通知
            if [[ ${AutoDelOwnRawCron} == true ]] && [ -s $ListOwnRawDrop ]; then
                Output_List_Add_Drop $ListOwnRawDrop "失效"
                Del_Cron $ListOwnRawDrop $TaskCmd
            fi
            ## 新增定时任务 & 通知
            if [[ ${AutoAddOwnRawCron} == true ]] && [ -s $ListOwnRawAdd ]; then
                Output_List_Add_Drop $ListOwnRawAdd "新"
                Add_Cron_Own $ListOwnRawAdd
                Add_Cron_Notify $ExitStatus $ListOwnAddNames " Raw 脚本"
            fi

        fi
        echo ''
    else
        perl -i -ne "{print unless / $TaskCmd \/jd\/own/}" $ListCrontabUser
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
            Git_Pull ${AbsolutePath} $(grep "branch" ${AbsolutePath}/.git/config | awk -F '\"' '{print$2}')
            if [[ $ExitStatus -eq 0 ]]; then
                echo -e "\n$COMPLETE ${AbsolutePath} 仓库更新完成\n"
                echo -e "$WARN 此更新模式下不会附带更新定时任务\n"
            else
                echo -e "\n$FAIL ${AbsolutePath} 仓库更新失败，请检查原因...\n"
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
    own)
        RunMod=" 扩 展 仓 库 "
        ;;
    repo)
        RunMod=" 所 有 仓 库 "
        ;;
    raw)
        RunMod=" 扩 展 脚 本 "
        ;;
    extra)
        RunMod="  自定义脚本 "
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

function UpdateMain() {

    case $# in
    0)
        Help $UpdateCmd
        ;;
    1)
        case $1 in
        all)
            Title $1
            Update_Shell
            Update_Own "all"
            ExtraShell
            ;;
        shell)
            Title $1
            Update_Shell
            ;;
        own)
            Title $1
            Update_Own "all"
            ;;
        repo)
            Title $1
            Update_Own "repo"
            ;;
        raw)
            Update_Own "raw"
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
        Notice
        exit ## 终止退出
        ;;
    *)
        Output_Command_Error 2 ## 命令过多
        ;;
    esac
}

UpdateMain $@ | tee -a $LogDir/update.log
