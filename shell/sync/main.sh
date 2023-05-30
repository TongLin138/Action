#!/bin/bash
## Modified: 2023-05-30

## 统计脚本仓库数量
function count_reposum() {
    cat $FileSyncConfUser | yq >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        RepoSum="$(cat $FileSyncConfUser | yq '.repo | length')"
    else
        output_error "配置文件 $FileSyncConfUser 存在语法错误，请检查后重试！"
    fi
}

## 统计远程脚本数量
function count_rawsum() {
    cat $FileSyncConfUser | yq >/dev/null 2>&1
    if [ $? -eq 0 ]; then
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

    local repo_num=0
    local arr_num tmp_url tmp_branch
    if [[ $RepoSum -ge 1 ]]; then
        for ((i = 1; i <= $RepoSum; i++)); do
            arr_num=$((i - 1))
            ## 仓库地址（如若未定义或格式错误则跳过视为无效配置）
            tmp_url="$(get_repoconf ".[$arr_num] | .url")"
            if [[ -z "${tmp_url}" ]] || [[ "${tmp_url}" == "null" ]]; then
                # echo -e "$ERROR 未检测到第$(($repo_num+ 1))个仓库配置的远程地址，跳过..."
                continue
            fi
            # 判断仓库地址格式
            echo "${tmp_url}" | grep -Eq "\.git$" # 链接必须以.git结尾
            if [ $? -ne 0 ]; then
                echo -e "$ERROR 检测到第$(($repo_num + 1))个仓库配置的远程地址无效"
                continue
            fi
            echo "${tmp_url}" | grep -Eq "https?:"
            if [ $? -ne 0 ]; then
                echo "${tmp_url}" | grep -Eq "^git\@"
                if [ $? -ne 0 ]; then
                    echo -e "$ERROR 检测到第$(($repo_num + 1))个仓库配置的远程地址无效"
                    continue
                fi
            fi
            ## 仓库分支（如若未定义或格式错误则跳过视为无效配置）
            tmp_branch="$(get_repoconf ".[$arr_num] | .branch")"
            if [[ -z "${tmp_branch}" ]] || [[ "${tmp_branch}" == "null" ]]; then
                # echo -e "$ERROR 未检测到第$(($repo_num+ 1))个仓库配置的分支名称，跳过..."
                continue
            fi
            Array_Repo_url[$repo_num]="${tmp_url}"
            Array_Repo_branch[$repo_num]="${tmp_branch}"
            ## 仓库名称（如若未定义则采用远程地址中的仓库名称）
            Array_Repo_name[$repo_num]="$(get_repoconf ".[$arr_num] | .name")"
            if [[ -z "${Array_Repo_name[repo_num]}" || "${Array_Repo_name[repo_num]}" == "null" ]]; then
                Array_Repo_name[$repo_num]="$(echo ${Array_Repo_url[repo_num]} | sed "s|\.git||g" | awk -F "/|:" '{print$NF}')"
            fi
            ## 仓库路径
            Array_Repo_dir[$repo_num]="$(echo "${Array_Repo_url[repo_num]}" | sed "s|\.git||g" | awk -F "/|:" '{print $((NF - 1)) "_" $NF}')"
            Array_Repo_path[$repo_num]="$RepoDir/${Array_Repo_dir[repo_num]}"
            ## 仓库启用状态（默认启用）
            if [[ "$(get_repoconf ".[$arr_num] | .enable")" == "false" ]]; then
                Array_Repo_enable[$repo_num]="false"
            else
                Array_Repo_enable[$repo_num]="true"
            fi
            # 定时启用状态（默认禁用）
            if [[ "$(get_repoconf ".[$arr_num] | .cronSettings.updateTaskList")" == "true" ]]; then
                Array_Repo_cronSettings_updateTaskList[$repo_num]="true"
            else
                Array_Repo_cronSettings_updateTaskList[$repo_num]="false"
            fi
            # 定时脚本路径（如若未定义则默认为'/'，表示根目录）
            if [[ -z "$(get_repoconf ".[$arr_num] | .cronSettings.scriptsPath")" || "$(get_repoconf ".[$arr_num] | .cronSettings.scriptsPath")" == "null" ]]; then
                Array_Repo_cronSettings_scriptsPath[$repo_num]="/"
            else
                Array_Repo_cronSettings_scriptsPath[$repo_num]="$(get_repoconf ".[$arr_num] | .cronSettings.scriptsPath")"
            fi
            # 定时脚本类型（如若未定义则默认为js、py、ts）
            if [[ "$(get_repoconf ".[$arr_num] | .cronSettings.scriptsType | arrays")" ]]; then
                Array_Repo_cronSettings_scriptsType[$repo_num]="js py ts"
            else
                Array_Repo_cronSettings_scriptsType[$repo_num]="$(get_repoconf ".[$arr_num] | .cronSettings.scriptsType | arrays" | jq -r 'join("  ")')"
            fi
            # 定时脚本白名单（如若未定义则默认为空）
            if [[ -z "$(get_repoconf ".[$arr_num] | .cronSettings.whiteList")" || "$(get_repoconf ".[$arr_num] | .cronSettings.whiteList")" == "null" ]]; then
                Array_Repo_cronSettings_whiteList[$repo_num]=""
            else
                Array_Repo_cronSettings_whiteList[$repo_num]="$(get_repoconf ".[$arr_num] | .cronSettings.whiteList")"
            fi
            # 定时脚本黑名单（如若未定义则默认为空）
            if [[ -z "$(get_repoconf ".[$arr_num] | .cronSettings.blackList")" || "$(get_repoconf ".[$arr_num] | .cronSettings.blackList")" == "null" ]]; then
                Array_Repo_cronSettings_blackList[$repo_num]=""
            else
                Array_Repo_cronSettings_blackList[$repo_num]="$(get_repoconf ".[$arr_num] | .cronSettings.blackList")"
            fi
            # 自动禁用新的定时任务（默认禁用）
            if [[ "$(get_repoconf ".[$arr_num] | .cronSettings.autoDisable")" == "true" ]]; then
                Array_Repo_cronSettings_autoDisable[$repo_num]="true"
            else
                Array_Repo_cronSettings_autoDisable[$repo_num]="false"
            fi
            # 新增定时任务推送通知提醒（默认启用）
            if [[ "$(get_repoconf ".[$arr_num] | .cronSettings.addNotify")" == "false" ]]; then
                Array_Repo_cronSettings_addNotify[$repo_num]="false"
            else
                Array_Repo_cronSettings_addNotify[$repo_num]="true"
            fi
            # 过期定时任务推送通知提醒（默认启用）
            if [[ "$(get_repoconf ".[$arr_num] | .cronSettings.delNotify")" == "false" ]]; then
                Array_Repo_cronSettings_delNotify[$repo_num]="false"
            else
                Array_Repo_cronSettings_delNotify[$repo_num]="true"
            fi

            # echo "第$(($repo_num + 1))个脚本仓库的配置：
            # name: ${Array_Repo_name[repo_num]}
            # url: ${Array_Repo_url[repo_num]}
            # branch: ${Array_Repo_branch[repo_num]}
            # enable: ${Array_Repo_enable[repo_num]}
            # dir: ${Array_Repo_dir[repo_num]}
            # path: ${Array_Repo_path[repo_num]}
            # updateTaskList: ${Array_Repo_cronSettings_updateTaskList[repo_num]}
            # autoDisable: ${Array_Repo_cronSettings_autoDisable[repo_num]}
            # addNotify: ${Array_Repo_cronSettings_addNotify[repo_num]}
            # delNotify: ${Array_Repo_cronSettings_delNotify[repo_num]}
            # scriptsPath: ${Array_Repo_cronSettings_scriptsPath[repo_num]}
            # scriptsType: ${Array_Repo_cronSettings_scriptsType[repo_num]}
            # whiteList: ${Array_Repo_cronSettings_whiteList[repo_num]}
            # blackList: ${Array_Repo_cronSettings_blackList[repo_num]}"

            let repo_num++
        done
    fi
}

## 生成用户远程脚本配置信息数组
# 脚本名称（用户定义） Array_Raw_name
# 脚本名称（文件名） Array_Raw_fileName
# 脚本远程地址 Array_Raw_url
# 脚本路径 Array_Raw_path
# 脚本定时设置 - 定时任务启用状态 Array_Raw_cronSettings_updateTaskList
function gen_rawconf_array() {

    # 读取远程脚本配置
    function get_rawconf() {
        cat $FileSyncConfUser | yq '.raw' | jq -rc "$1"
    }

    local raw_num=0
    local arr_num tmp_url
    if [[ $RawSum -ge 1 ]]; then
        for ((i = 1; i <= $RawSum; i++)); do
            arr_num=$((i - 1))
            ## 脚本地址（如若未定义或格式错误则跳过视为无效配置）
            tmp_url="$(get_rawconf ".[$arr_num] | .url")"
            if [[ -z "${tmp_url}" ]] || [[ "${tmp_url}" == "null" ]]; then
                # echo -e "$ERROR 未检测到第$(($raw_num+ 1))个远程脚本配置的远程地址，跳过..."
                continue
            fi
            Array_Raw_url[$raw_num]="${tmp_url}"
            Array_Raw_path[$raw_num]="${RawDir}/${Array_Raw_url[raw_num]##*/}"
            ## 仓库原始文件地址自动纠正
            import utils/request
            if [[ "$(get_correct_raw_url "${Array_Raw_url[raw_num]}")" ]]; then
                Array_Raw_url[$raw_num]="$(get_correct_raw_url "${Array_Raw_url[raw_num]}")"
            fi
            ## 脚本名称（如若未定义则采用远程地址中的脚本名称）
            Array_Raw_fileName[$raw_num]="${Array_Raw_url[raw_num]##*/}"
            if [[ "$(get_rawconf ".[$arr_num] | .name")" == "null" ]]; then
                Array_Raw_name[$raw_num]="${Array_Raw_fileName[raw_num]}"
            else
                Array_Raw_name[$raw_num]="$(get_rawconf ".[$arr_num] | .name")"
            fi
            # 定时启用状态（默认禁用）
            if [[ "$(get_rawconf ".[$arr_num] | .cronSettings.updateTaskList")" == "true" ]]; then
                Array_Raw_cronSettings_updateTaskList[$raw_num]="true"
            else
                Array_Raw_cronSettings_updateTaskList[$raw_num]="false"
            fi

            # echo -e "第$(($raw_num + 1))个远程脚本的配置：
            # name: ${Array_Raw_name[raw_num]}
            # url: ${Array_Raw_url[raw_num]}
            # path: ${Array_Raw_path[raw_num]}
            # fileName: ${Array_Raw_fileName[raw_num]}
            # Array_Raw_cronSettings_updateTaskList: ${Array_Raw_cronSettings_updateTaskList[raw_num]}
            # "

            let raw_num++
        done
    fi
}

## 生成定时任务脚本的绝对路径清单
function gen_repocron_list() {

    ## 生成脚本清单对应的配置（部分用于在更新定时请求时携带）
    function gen_script_listconf() {
        echo "$(cat $ListConfScripts | jq '."'"$1"'"='"$2"'')" >$ListConfScripts
    }

    local current_dir=$(pwd)
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
    cd $current_dir
}
