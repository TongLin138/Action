#!/bin/bash
## Modified: 2023-05-28

## 统计脚本仓库数量
function count_reposum() {
    cat $FileSyncConfUser | yq >/dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        RepoSum="$(cat $FileSyncConfUser | yq '.repo | length')"
    else
        output_error "配置文件 $FileSyncConfUser 存在语法错误，请检查后重试！"
    fi
}

## 统计扩展脚本数量
function count_rawsum() {
    cat $FileSyncConfUser | yq >/dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        RawSum="$(cat $FileSyncConfUser | yq '.raw | length')"
    else
        output_error "配置文件 $FileSyncConfUser 存在语法错误，请检查后重试！"
    fi
}

## 生成用户脚本仓库配置信息数组
# 仓库名称 Array_Repo_name
# 仓库远程地址 Array_Repo_url
# 仓库分支名称 Array_Repo_branch
# 仓库启用状态 Array_Repo_enable
# 仓库本地存放目录名称 Array_Repo_dir
# 仓库本地文件绝对路径 Array_Repo_path
# 仓库脚本定时设置 - 定时任务启用状态 Array_Repo_cronSettings_updateTaskList
# 仓库脚本定时设置 - 自动禁用新的定时任务 Array_Repo_cronSettings_autoDisable
# 仓库脚本定时设置 - 新增定时任务推送通知提醒 Array_Repo_cronSettings_addNotify
# 仓库脚本定时设置 - 过期定时任务推送通知提醒 Array_Repo_cronSettings_delNotify
# 仓库脚本定时设置 - 脚本过滤路径 Array_Repo_cronSettings_scriptsPath
# 仓库脚本定时设置 - 脚本过滤文件格式 Array_Repo_cronSettings_scriptsType
# 仓库脚本定时设置 - 过滤白名单 Array_Repo_cronSettings_whiteList
# 仓库脚本定时设置 - 过滤黑名单 Array_Repo_cronSettings_blackList
function gen_repoconf_array() {

    # 读取脚本仓库配置
    function get_repoconf() {
        cat $FileSyncConfUser | yq '.repo' | jq -rc "$1"
    }

    if [[ $RepoSum -ge 1 ]]; then
        for ((i = 1; i <= $RepoSum; i++)); do
            local arr_num=$((i - 1))
            ## 仓库地址（如若未定义或格式错误则跳过视为无效配置）
            local Tmp_url="$(get_repoconf ".[$arr_num] | .url")"
            if [[ -z ${Tmp_url} ]] || [[ ${Tmp_url} == "null" ]]; then
                # echo -e "$ERROR 未检测到第${i}个仓库配置的远程地址，跳过..."
                continue
            fi
            # 判断仓库地址格式
            echo ${Tmp_url} | grep -Eq "\.git$" # 链接必须以.git结尾
            if [ $? -ne 0 ]; then
                echo -e "$ERROR 检测到第${i}个仓库配置的远程地址无效"
                continue
            fi
            echo ${Tmp_url} | grep -Eq "http.*:"
            if [ $? -ne 0 ]; then
                echo ${Tmp_url} | grep -Eq "^git\@"
                if [ $? -ne 0 ]; then
                    echo -e "$ERROR 检测到第${i}个仓库配置的远程地址无效"
                    continue
                fi
            fi
            ## 仓库分支（如若未定义或格式错误则跳过视为无效配置）
            local Tmp_branch="$(get_repoconf ".[$arr_num] | .branch")"
            if [[ -z ${Tmp_branch} ]] || [[ ${Tmp_branch} == "null" ]]; then
                # echo -e "$ERROR 未检测到第${i}个仓库配置的分支名称，跳过..."
                continue
            fi
            Array_Repo_url[$arr_num]="${Tmp_url}"
            Array_Repo_branch[$arr_num]="${Tmp_branch}"
            ## 仓库名称（如若未定义则采用远程地址中的仓库名称）
            Array_Repo_name[$arr_num]="$(get_repoconf ".[$arr_num] | .name")"
            if [[ -z "${Array_Repo_name[arr_num]}" || "${Array_Repo_name[arr_num]}" == "null" ]]; then
                Array_Repo_name[$arr_num]="$(echo ${Array_Repo_url[$arr_num]} | sed "s|\.git||g" | awk -F "/|:" '{print$NF}')"
            fi
            ## 仓库路径
            Array_Repo_dir[$arr_num]="$(echo "${Array_Repo_url[$arr_num]}" | sed "s|\.git||g" | awk -F "/|:" '{print $((NF - 1)) "_" $NF}')"
            Array_Repo_path[$arr_num]="$RepoDir/${Array_Repo_dir[$arr_num]}"
            ## 仓库启用状态（默认启用）
            if [[ "$(get_repoconf ".[$arr_num] | .enable")" == "false" ]]; then
                Array_Repo_enable[$arr_num]="false"
            else
                Array_Repo_enable[$arr_num]="true"
            fi
            # 定时启用状态（默认禁用）
            if [[ "$(get_repoconf ".[$arr_num] | .cronSettings.updateTaskList")" == "true" ]]; then
                Array_Repo_cronSettings_updateTaskList[$arr_num]="true"
            else
                Array_Repo_cronSettings_updateTaskList[$arr_num]="false"
            fi
            # 自动禁用新的定时任务（默认禁用）
            if [[ "$(get_repoconf ".[$arr_num] | .cronSettings.autoDisable")" == "true" ]]; then
                Array_Repo_cronSettings_autoDisable[$arr_num]="true"
            else
                Array_Repo_cronSettings_autoDisable[$arr_num]="false"
            fi
            # 新增定时任务推送通知提醒（默认启用）
            if [[ "$(get_repoconf ".[$arr_num] | .cronSettings.addNotify")" == "false" ]]; then
                Array_Repo_cronSettings_addNotify[$arr_num]="false"
            else
                Array_Repo_cronSettings_addNotify[$arr_num]="true"
            fi
            # 过期定时任务推送通知提醒（默认启用）
            if [[ "$(get_repoconf ".[$arr_num] | .cronSettings.delNotify")" == "false" ]]; then
                Array_Repo_cronSettings_delNotify[$arr_num]="false"
            else
                Array_Repo_cronSettings_delNotify[$arr_num]="true"
            fi
            # 定时脚本路径（如若未定义则默认为'/'，表示根目录）
            if [[ -z "$(get_repoconf ".[$arr_num] | .cronSettings.scriptsPath")" || "$(get_repoconf ".[$arr_num] | .cronSettings.scriptsPath")" == "null" ]]; then
                Array_Repo_cronSettings_scriptsPath[$arr_num]="/"
            else
                Array_Repo_cronSettings_scriptsPath[$arr_num]="$(get_repoconf ".[$arr_num] | .cronSettings.scriptsPath")"
            fi
            # 定时脚本类型（如若未定义则默认为js、py、ts）
            if [[ "$(get_repoconf ".[$arr_num] | .cronSettings.scriptsType | arrays")" ]]; then
                Array_Repo_cronSettings_scriptsType[$arr_num]="js py ts"
            else
                Array_Repo_cronSettings_scriptsType[$arr_num]="$(get_repoconf ".[$arr_num] | .cronSettings.scriptsType | arrays" | jq -r 'join("  ")')"
            fi
            # 定时脚本白名单（如若未定义则默认为空）
            if [[ -z "$(get_repoconf ".[$arr_num] | .cronSettings.whiteList")" || "$(get_repoconf ".[$arr_num] | .cronSettings.whiteList")" == "null" ]]; then
                Array_Repo_cronSettings_whiteList[$arr_num]=""
            else
                Array_Repo_cronSettings_whiteList[$arr_num]="$(get_repoconf ".[$arr_num] | .cronSettings.whiteList")"
            fi
            # 定时脚本黑名单（如若未定义则默认为空）
            if [[ -z "$(get_repoconf ".[$arr_num] | .cronSettings.blackList")" || "$(get_repoconf ".[$arr_num] | .cronSettings.blackList")" == "null" ]]; then
                Array_Repo_cronSettings_blackList[$arr_num]=""
            else
                Array_Repo_cronSettings_blackList[$arr_num]="$(get_repoconf ".[$arr_num] | .cronSettings.blackList")"
            fi

            # echo "第${i}个仓库的定时配置：
            # updateTaskList: ${Array_Repo_cronSettings_updateTaskList[arr_num]}
            # autoDisable: ${Array_Repo_cronSettings_autoDisable[arr_num]}
            # addNotify: ${Array_Repo_cronSettings_addNotify[arr_num]}
            # delNotify: ${Array_Repo_cronSettings_delNotify[arr_num]}
            # scriptsPath: ${Array_Repo_cronSettings_scriptsPath[arr_num]}
            # scriptsType: ${Array_Repo_cronSettings_scriptsType[arr_num]}
            # whiteList: ${Array_Repo_cronSettings_whiteList[arr_num]}
            # blackList: ${Array_Repo_cronSettings_blackList[arr_num]}"
        done
    fi
}

## 生成用户扩展脚本配置信息数组
# 脚本名称（用户定义） Array_Raw_name
# 脚本名称（文件名） Array_Raw_fileName
# 脚本远程地址 Array_Raw_url
# 脚本路径 Array_Raw_path
# 脚本定时设置 - 定时任务启用状态 Array_Raw_cronSettings_updateTaskList
function gen_rawconf_array() {

    # 读取扩展脚本配置
    function get_rawconf() {
        cat $FileSyncConfUser | yq '.raw' | jq -rc "$1"
    }

    local FormatUrl ReformatUrl RepoBranch RepoUrl RepoPlatformUrl DownloadUrl
    if [[ $RawSum -ge 1 ]]; then
        for ((i = 1; i <= $RawSum; i++)); do
            local arr_num=$((i - 1))
            ## 脚本地址（如若未定义或格式错误则跳过视为无效配置）
            local Tmp_url="$(get_rawconf ".[$arr_num] | .url")"
            if [[ -z ${Tmp_url} ]] || [[ ${Tmp_url} == "null" ]]; then
                # echo -e "$ERROR 未检测到第${i}个扩展脚本配置的远程地址，跳过..."
                continue
            fi
            ## 脚本名称（如若未定义则采用远程地址中的脚本名称）
            Array_Raw_fileName[$arr_num]="${Array_Raw_url[arr_num]##*/}"
            if [[ "$(get_rawconf ".[$arr_num] | .name")" == "null" ]]; then
                Array_Raw_name[$arr_num]="${Array_Raw_fileName[arr_num]}"
            else
                Array_Raw_name[$arr_num]="$(get_rawconf ".[$arr_num] | .name")"
            fi
            # 定时启用状态（默认禁用）
            if [[ "$(get_rawconf ".[$arr_num] | .cronSettings.enabled")" == "true" ]]; then
                Array_Raw_cronSettings_updateTaskList[$arr_num]="true"
            else
                Array_Raw_cronSettings_updateTaskList[$arr_num]="false"
            fi
            Array_Raw_url[$arr_num]="${Tmp_url}"
            Array_Raw_path[$arr_num]="${RawDir}/${Array_Raw_url[$arr_num]##*/}"

            ## 地址纠正判（断脚本来源：托管仓库 or 普通网站 ）
            echo "${Array_Raw_url[arr_num]}" | grep -Eq "github|gitee|gitlab"
            if [ $? -eq 0 ]; then
                ## 纠正链接地址（将传入的链接地址转换为对应代码托管仓库的raw原始文件链接地址）
                echo "${Array_Raw_url[arr_num]}" | grep "\.com\/.*\/blob\/.*" -q
                if [ $? -eq 0 ]; then
                    case $(echo "${Array_Raw_url[arr_num]}" | grep -Eo "github|gitee|gitlab") in
                    github)
                        echo "${Array_Raw_url[arr_num]}" | grep "github\.com\/.*\/blob\/.*" -q
                        if [ $? -eq 0 ]; then
                            DownloadUrl=$(echo "${Array_Raw_url[arr_num]}" | sed "s|github\.com/|raw\.githubusercontent\.com/|g; s|\/blob\/|\/|g")
                        else
                            DownloadUrl="${Array_Raw_url[arr_num]}"
                        fi
                        ;;
                    gitee)
                        echo "${Array_Raw_url[arr_num]}" | grep "gitee\.com\/.*\/blob\/.*" -q
                        if [ $? -eq 0 ]; then
                            DownloadUrl=$(echo "${Array_Raw_url[arr_num]}" | sed "s/\/blob\//\/raw\//g")
                        else
                            DownloadUrl="${Array_Raw_url[arr_num]}"
                        fi
                        ;;
                    gitlab)
                        echo "${Array_Raw_url[arr_num]}" | grep "gitlab\.com\/.*\/blob\/.*" -q
                        if [ $? -eq 0 ]; then
                            DownloadUrl=$(echo "${Array_Raw_url[arr_num]}" | sed "s/\/blob\//\/raw\//g")
                        else
                            DownloadUrl="${Array_Raw_url[arr_num]}"
                        fi
                        ;;
                    esac
                else
                    ## 原始链接
                    DownloadUrl="${Array_Raw_url[arr_num]}"
                fi
                echo ${DownloadUrl} | grep -E "git.*\.io/" -q
                if [ $? -ne 0 ]; then
                    ## 处理仓库地址
                    FormatUrl=$(echo ${DownloadUrl} | sed "s|${Array_Raw_fileName[i]}||g" | awk -F '.com' '{print$NF}' | sed 's/.$//')
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
                fi
                Array_Raw_url[$arr_num]="${DownloadUrl}"
            fi
        done
    fi
}

## 生成定时任务脚本的绝对路径清单
function gen_repocron_list() {

    ## 生成脚本清单对应的配置（对应仓库的配置数据）用于在更新定时请求时携带
    function gen_script_listconf() {
        echo "$(cat $ListConfScripts | jq '."'"$1"'"='"$2"'')" >$ListConfScripts
    }

    local CurrentDir=$(pwd)

    # 生成模式
    case "$1" in
    "old")
        local writeFile="$ListOldScripts"
        ;;
    "new")
        local writeFile="$ListNewScripts"
        ;;
    esac
    # 仓库路径
    local repoPath="$2"
    local repoDir="${repoPath##*/}"
    # 脚本路径
    local scriptsPath="$3"
    # 脚本类型
    local scriptsType="$4"
    local scriptsTypeMatch type
    if [[ "${scriptsType}" ]]; then
        for type in ${scriptsType}; do
            if [[ "${scriptsTypeMatch}" ]]; then
                scriptsTypeMatch="${scriptsTypeMatch}|\.${type}$"
            else
                scriptsTypeMatch="\.${type}$"
            fi
        done
    else
        scriptsTypeMatch=""
    fi
    # 过滤白名单
    local whiteList="$5"
    # 过滤黑名单
    local blackList="$6"
    # 自动禁用新的定时任务
    local autoDisable="$7"
    # 新增定时任务推送通知提醒
    local addNotify="$8"
    # 过期定时任务推送通知提醒
    local delNotify="$9"

    # echo "仓库 ${repoPath} 白名单：${whiteList:-"未定义"}"
    # echo "仓库 ${repoPath} 黑名单：${blackList:-"未定义"}"

    ## 脚本路径
    # echo "仓库 ${repoPath} 脚本路径：${scriptsPath:-"未定义"}"

    local Matching
    ## 仅根目录
    if [[ "${scriptsPath}" == "/" ]]; then
        ## 进入仓库根目录
        cd $repoPath
        ## 判断路径下是否存在脚本
        if [[ "$(ls | grep -E "${scriptsTypeMatch}")" ]]; then
            ## 判断是否定义了黑名单并筛选符合条件的脚本
            if [[ -z "${blackList}" ]]; then
                Matching=$(ls | grep -E "${scriptsTypeMatch}" 2>/dev/null | grep -E "${whiteList}")
            else
                Matching=$(ls | grep -E "${scriptsTypeMatch}" 2>/dev/null | grep -E "${whiteList}" | grep -Ev ${blackList})
            fi
            for file in ${Matching}; do
                ## 判断脚本是否存在内容
                if [ -s $file ]; then
                    echo "${repoPath}/${file}" >>$writeFile
                    gen_script_listconf "${repoPath}/${file}" '{"path": "'"${repoPath}"'/'"${file}"'", "autoDisable": "'"${autoDisable}"'", "addNotify": "'"${addNotify}"'", "delNotify": "'"${delNotify}"'"}'
                else
                    continue
                fi
            done
        else
            continue
        fi
    else
        local FormatPath path
        for path in ${scriptsPath}; do
            # echo "仓库 $((i + 1)) 循环处理路径: $path"
            ## 进入仓库根目录
            cd $repoPath
            ## 判断路径
            if [[ "${path}" == '/' ]]; then
                FormatPath="${Array_Repo_path[i]}" # 根目录
            else
                FormatPath="$RepoDir/$(echo "${repoDir}/$path" | sed "s|//|/|g; s|/$||g")" # 去掉多余的斜杠
                ## 判断子目录是否存在
                if [ -d "${FormatPath}" ]; then
                    cd ${FormatPath}
                else
                    echo -e "\n$ERROR 仓库 $((i + 1)) 的定时脚本配置路径 ${BLUE}${FormatPath}${PLAIN} 不存在，跳过！\n"
                    continue
                fi
            fi
            ## 判断路径下是否存在脚本
            if [[ "$(ls | grep -E "${scriptsTypeMatch}")" ]]; then
                ## 判断是否定义了黑名单并筛选符合条件的脚本
                if [[ -z ${blackList} ]]; then
                    Matching=$(ls | grep -E "${scriptsTypeMatch}" 2>/dev/null | grep -E "${whiteList}")
                else
                    Matching=$(ls | grep -E "${scriptsTypeMatch}" 2>/dev/null | grep -E "${whiteList}" | grep -Ev ${blackList})
                fi
                for file in ${Matching}; do
                    ## 判断脚本是否存在内容
                    if [ -s $file ]; then
                        echo "${FormatPath}/${file}" >>$writeFile
                        gen_script_listconf "${FormatPath}/${file}" '{"path": "'"${FormatPath}"'/'"${file}"'", "autoDisable": "'"${autoDisable}"'", "addNotify": "'"${addNotify}"'", "delNotify": "'"${delNotify}"'"}'
                    else
                        continue
                    fi
                done
            else
                continue
            fi
        done
    fi
    ## 汇总去重
    echo "$(sort -u $writeFile)" >$writeFile
    cd $CurrentDir
}
