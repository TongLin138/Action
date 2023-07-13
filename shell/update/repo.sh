#!/bin/bash
## Modified: 2023-07-13

## 更新所有仓库
# update repo
function update_all_repo() {
    local Repo_Name Repo_Url Repo_Branch Repo_Dir Repo_Path Repo_Enable
    ## 统计仓库数量并生成配置
    count_reposum
    gen_repoconf_array

    if [[ $RepoSum -ge 1 && ${#Array_Repo_url[*]} -ge 1 ]]; then
        ## 遍历仓库配置数组
        for ((i = 0; i < ${#Array_Repo_url[*]}; i++)); do
            ## 判断仓库是否启用
            [[ -z "${Array_Repo_url[i]}" || -z "${Array_Repo_branch[i]}" ]] && continue
            [[ ${Array_Repo_enable[i]} == "false" ]] && continue

            ## 更新/克隆仓库
            if [ -d "${Array_Repo_path[i]}/.git" ]; then
                # 生成旧的定时脚本清单
                [[ ${Array_Repo_cronSettings_updateTaskList[i]} == "true" ]] && gen_repocron_list "old" "${Array_Repo_path[i]}" "${Array_Repo_cronSettings_scriptsPath[i]}" "${Array_Repo_cronSettings_scriptsType[i]}" "${Array_Repo_cronSettings_whiteList[i]}" "${Array_Repo_cronSettings_blackList[i]}" "${Array_Repo_cronSettings_autoDisable[i]}" "${Array_Repo_cronSettings_addNotify[i]}" "${Array_Repo_cronSettings_delNotify[i]}"

                reset_romote_url ${Array_Repo_path[i]} ${Array_Repo_url[i]} ${Array_Repo_branch[i]}
                git_pull ${Array_Repo_path[i]} ${Array_Repo_branch[i]} "开始更新仓库 ${BLUE}${Array_Repo_name[i]}${PLAIN}"
                if [[ $EXITSTATUS -eq 0 ]]; then
                    echo -e "\n$COMPLETE ${BLUE}${Array_Repo_name[i]}${PLAIN} 仓库更新完成"
                else
                    echo -e "\n$FAIL ${BLUE}${Array_Repo_name[i]}${PLAIN} 仓库更新失败，请检查原因..."
                fi
            else
                git_clone ${Array_Repo_url[i]} ${Array_Repo_path[i]} ${Array_Repo_branch[i]} "开始克隆仓库 ${BLUE}${Array_Repo_name[i]}${PLAIN}"
                if [[ $EXITSTATUS -eq 0 ]]; then
                    echo -e "\n$SUCCESS ${BLUE}${Array_Repo_name[i]}${PLAIN} 仓库克隆成功"
                else
                    echo -e "\n$FAIL ${BLUE}${Array_Repo_name[i]}${PLAIN} 仓库克隆失败，请检查原因..."
                    continue
                fi
            fi

            # 生成新的定时脚本清单
            [[ ${Array_Repo_cronSettings_updateTaskList[i]} == "true" ]] && gen_repocron_list "new" "${Array_Repo_path[i]}" "${Array_Repo_cronSettings_scriptsPath[i]}" "${Array_Repo_cronSettings_scriptsType[i]}" "${Array_Repo_cronSettings_whiteList[i]}" "${Array_Repo_cronSettings_blackList[i]}" "${Array_Repo_cronSettings_autoDisable[i]}" "${Array_Repo_cronSettings_addNotify[i]}" "${Array_Repo_cronSettings_delNotify[i]}"
        done
    else
        echo -e "\n$TIP 未检测到任何有效的仓库配置，跳过更新仓库..."
    fi
}

## 更新指定路径下的仓库
# update <path>
function update_designated_repo() {
    local input_content format_path pwd_tmp
    ## 去掉最后一个/
    echo $1 | grep "/$" -q
    if [ $? -eq 0 ]; then
        local input_content="${1%?}"
    else
        local input_content="$1"
    fi
    ## 判定传入的是绝对路径还是相对路径
    echo "${input_content}" | grep "^$RootDir" -q
    if [ $? -eq 0 ]; then
        format_path="${input_content}"
    else
        ## 处理上级目录
        echo "${input_content}" | grep "\.\./" -q
        if [ $? -eq 0 ]; then
            pwd_tmp=$(pwd | sed "s|/$(pwd | awk -F '/' '{printf$NF}')||g")
            format_path=$(echo "${input_content}" | sed "s|\.\./|${pwd_tmp}/|g")
        else
            format_path=$(echo "${input_content}" | sed "s|\.\/||g; s|^*|$(pwd)/|g")
        fi
    fi
    ## 判定是否存在仓库
    if [ -d ${format_path}/.git ]; then
        if [[ "${format_path}" = "$RootDir" ]]; then
            print_title_start "source"
            import update/source
            update_sourcecode
        else
            print_title_start "designated"
            make_dir $RepoDir $LogTmpDir
            import sync
            import update/cron
            count_reposum
            gen_repoconf_array
            ## 清空定时任务关联脚本清单内容
            clean_list_scripts
            ## 判断仓库是否在配置文件中
            # 根据目标仓库是否为已配置的仓库
            local configured_repo=false # 是否为已配置的仓库
            if [[ $RepoSum -ge 1 && ${#Array_Repo_url[*]} -ge 1 ]]; then
                for ((i = 0; i < ${#Array_Repo_url[*]}; i++)); do
                    echo "${Array_Repo_path[i]}" | grep "${format_path}" -q
                    if [ $? -eq 0 ]; then
                        local current_num=$i
                        configured_repo=true
                        break
                    fi
                done
            fi
            if [ $configured_repo == true ]; then
                # 生成旧的定时脚本清单
                if [[ ${Array_Repo_cronSettings_updateTaskList[current_num]} == "true" ]]; then
                    gen_repocron_list "old" "${Array_Repo_path[current_num]}" "${Array_Repo_cronSettings_scriptsPath[current_num]}" "${Array_Repo_cronSettings_scriptsType[current_num]}" "${Array_Repo_cronSettings_whiteList[current_num]}" "${Array_Repo_cronSettings_blackList[current_num]}" "${Array_Repo_cronSettings_autoDisable[current_num]}" "${Array_Repo_cronSettings_addNotify[current_num]}" "${Array_Repo_cronSettings_delNotify[current_num]}"
                fi
                reset_romote_url ${Array_Repo_path[current_num]} ${Array_Repo_url[current_num]} ${Array_Repo_branch[current_num]}
                git_pull ${Array_Repo_path[current_num]} ${Array_Repo_branch[current_num]}
                if [[ $EXITSTATUS -eq 0 ]]; then
                    echo -e "\n$COMPLETE ${BLUE}${Array_Repo_name[current_num]}${PLAIN} 仓库更新完成"
                else
                    echo -e "\n$FAIL ${BLUE}${Array_Repo_name[current_num]}${PLAIN} 仓库更新失败，请检查原因..."
                fi
                # 生成新的定时脚本清单
                if [[ ${Array_Repo_cronSettings_updateTaskList[current_num]} == "true" ]]; then
                    gen_repocron_list "new" "${Array_Repo_path[current_num]}" "${Array_Repo_cronSettings_scriptsPath[current_num]}" "${Array_Repo_cronSettings_scriptsType[current_num]}" "${Array_Repo_cronSettings_whiteList[current_num]}" "${Array_Repo_cronSettings_blackList[current_num]}" "${Array_Repo_cronSettings_autoDisable[current_num]}" "${Array_Repo_cronSettings_addNotify[current_num]}" "${Array_Repo_cronSettings_delNotify[current_num]}"
                fi

                ## 更新定时任务
                update_cron
            else
                git_pull "${format_path}" $(grep "branch" ${format_path}/.git/config | awk -F '\"' '{print$2}')
                if [[ $EXITSTATUS -eq 0 ]]; then
                    echo -e "\n$COMPLETE 仓库更新完成"
                else
                    echo -e "\n$FAIL 仓库更新失败，请检查原因..."
                fi
            fi
        fi
    else
        if [ -d ${format_path} ]; then
            output_error "未检测到 ${BLUE}${format_path}${PLAIN} 路径下存在任何仓库，请重新确认！"
        else
            output_error "未检测到 ${BLUE}${format_path}${PLAIN} 路径不存在，请重新确认！"
        fi
    fi
}
