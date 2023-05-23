#!/bin/bash
## Modified: 2023-05-23

## 更新所有仓库
function Update_AllRepo() {
    local Repo_Name Repo_Url Repo_Branch Repo_Dir Repo_Path Repo_Enable
    ## 统计仓库数量并生成配置
    Count_RepoSum
    Gen_RepoConfArray

    if [[ $RepoSum -ge 1 && ${#Array_Repo_url[*]} -ge 1 ]]; then
        ## 遍历仓库配置数组
        for ((i = 0; i < ${#Array_Repo_url[*]}; i++)); do
            ## 判断仓库是否启用
            [[ ${Array_Repo_enable[i]} == "false" ]] && continue

            ## 更新/克隆仓库
            if [ -d "${Array_Repo_path[i]}/.git" ]; then
                # 生成旧的定时脚本清单
                [[ ${Array_Repo_cronSettings_updateTaskList[i]} == "true" ]] && Gen_RepoCronList "old" "${Array_Repo_path[i]}" "${Array_Repo_cronSettings_scriptsPath[i]}" "${Array_Repo_cronSettings_scriptsType[i]}" "${Array_Repo_cronSettings_whiteList[i]}" "${Array_Repo_cronSettings_blackList[i]}" "${Array_Repo_cronSettings_autoDisable[i]}" "${Array_Repo_cronSettings_addNotify[i]}" "${Array_Repo_cronSettings_delNotify[i]}"

                Reset_Romote_Url ${Array_Repo_path[i]} ${Array_Repo_url[i]} ${Array_Repo_branch[i]}
                Git_Pull ${Array_Repo_path[i]} ${Array_Repo_branch[i]} "开始更新仓库 ${BLUE}${Array_Repo_name[i]}${PLAIN}"
                if [[ $ExitStatus -eq 0 ]]; then
                    echo -e "\n$COMPLETE ${BLUE}${Array_Repo_name[i]}${PLAIN} 仓库更新完成"
                else
                    echo -e "\n$FAIL ${BLUE}${Array_Repo_name[i]}${PLAIN} 仓库更新失败，请检查原因..."
                fi
            else
                Git_Clone ${Array_Repo_url[i]} ${Array_Repo_path[i]} ${Array_Repo_branch[i]} "开始克隆仓库 ${BLUE}${Array_Repo_name[i]}${PLAIN}"
                if [[ $ExitStatus -eq 0 ]]; then
                    echo -e "\n$SUCCESS ${BLUE}${Array_Repo_name[i]}${PLAIN} 仓库克隆成功"
                else
                    echo -e "\n$FAIL ${BLUE}${Array_Repo_name[i]}${PLAIN} 仓库克隆失败，请检查原因..."
                    continue
                fi
            fi

            # 生成新的定时脚本清单
            [[ ${Array_Repo_cronSettings_updateTaskList[i]} == "true" ]] && Gen_RepoCronList "new" "${Array_Repo_path[i]}" "${Array_Repo_cronSettings_scriptsPath[i]}" "${Array_Repo_cronSettings_scriptsType[i]}" "${Array_Repo_cronSettings_whiteList[i]}" "${Array_Repo_cronSettings_blackList[i]}" "${Array_Repo_cronSettings_autoDisable[i]}" "${Array_Repo_cronSettings_addNotify[i]}" "${Array_Repo_cronSettings_delNotify[i]}"
        done
    else
        echo -e "$ERROR 未检测到任何有效的仓库配置，跳过更新仓库..."
    fi
}

## 更新指定路径下的仓库
function Update_Designated() {
    local InputContent AbsolutePath PwdTmp
    ## 去掉最后一个/
    echo $1 | grep "/$" -q
    if [ $? -eq 0 ]; then
        local InputContent="${1%?}"
    else
        local InputContent="$1"
    fi
    ## 判定传入的是绝对路径还是相对路径
    echo "${InputContent}" | grep "^$RootDir" -q
    if [ $? -eq 0 ]; then
        AbsolutePath="${InputContent}"
    else
        ## 处理上级目录
        echo "${InputContent}" | grep "\.\./" -q
        if [ $? -eq 0 ]; then
            PwdTmp=$(pwd | sed "s|/$(pwd | awk -F '/' '{printf$NF}')||g")
            AbsolutePath=$(echo "${InputContent}" | sed "s|\.\./|${PwdTmp}/|g")
        else
            AbsolutePath=$(echo "${InputContent}" | sed "s|\.\/||g; s|^*|$(pwd)/|g")
        fi
    fi
    ## 判定是否存在仓库
    if [ -d ${AbsolutePath}/.git ]; then
        if [[ "${AbsolutePath}" = "$RootDir" ]]; then
            Title "source"
            Update_SourceCode
        else
            Make_Dir $ReposDir
            Make_Dir $LogTmpDir

            import sync
            import update/cron

            Count_RepoSum
            Gen_RepoConfArray

            ## 清空定时任务关联脚本清单内容
            CleanListScripts
            ## 判断仓库是否在配置文件中
            # 根据目标仓库是否为已配置的仓库
            local configured_repo=false # 是否为已配置的仓库
            if [[ $RepoSum -ge 1 && ${#Array_Repo_url[*]} -ge 1 ]]; then
                for ((i = 0; i < ${#Array_Repo_url[*]}; i++)); do
                    echo "${AbsolutePath}" | grep "${Array_Repo_path[i]}" -q
                    [ $? -eq 0 ] && local current_num=$i && configured_repo=true && break
                done
            fi
            Title "designated"
            echo -e "-------------------------------------------------------------"
            if [ $configured_repo == true ]; then
                # 生成旧的定时脚本清单
                if [[ ${Array_Repo_cronSettings_updateTaskList[current_num]} == "true" ]]; then
                    Gen_RepoCronList "old" "${Array_Repo_path[current_num]}" "${Array_Repo_cronSettings_scriptsPath[current_num]}" "${Array_Repo_cronSettings_scriptsType[current_num]}" "${Array_Repo_cronSettings_whiteList[current_num]}" "${Array_Repo_cronSettings_blackList[current_num]}" "${Array_Repo_cronSettings_autoDisable[current_num]}" "${Array_Repo_cronSettings_addNotify[current_num]}" "${Array_Repo_cronSettings_delNotify[current_num]}"
                fi
                Reset_Romote_Url ${Array_Repo_path[current_num]} ${Array_Repo_url[current_num]} ${Array_Repo_branch[current_num]}
                Git_Pull ${Array_Repo_path[current_num]} ${Array_Repo_branch[current_num]}
                if [[ $ExitStatus -eq 0 ]]; then
                    echo -e "\n$COMPLETE ${BLUE}${Array_Repo_name[current_num]}${PLAIN} 仓库更新完成"
                else
                    echo -e "\n$FAIL ${BLUE}${Array_Repo_name[current_num]}${PLAIN} 仓库更新失败，请检查原因..."
                fi
                # 生成新的定时脚本清单
                if [[ ${Array_Repo_cronSettings_updateTaskList[current_num]} == "true" ]]; then
                    Gen_RepoCronList "new" "${Array_Repo_path[current_num]}" "${Array_Repo_cronSettings_scriptsPath[current_num]}" "${Array_Repo_cronSettings_scriptsType[current_num]}" "${Array_Repo_cronSettings_whiteList[current_num]}" "${Array_Repo_cronSettings_blackList[current_num]}" "${Array_Repo_cronSettings_autoDisable[current_num]}" "${Array_Repo_cronSettings_addNotify[current_num]}" "${Array_Repo_cronSettings_delNotify[current_num]}"
                fi

                ## 更新定时任务
                Update_Cron
            else
                Git_Pull "${AbsolutePath}" $(grep "branch" ${AbsolutePath}/.git/config | awk -F '\"' '{print$2}')
                if [[ $ExitStatus -eq 0 ]]; then
                    echo -e "\n$COMPLETE 仓库更新完成"
                else
                    echo -e "\n$FAIL 仓库更新失败，请检查原因..."
                fi
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
