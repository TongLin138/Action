#!/bin/bash
## Modified: 2023-05-21

## 清空定时任务关联脚本清单内容
function CleanListScripts() {
    local Dirs=("$ListOldScripts $ListNewScripts $ListAddScripts $ListDelScripts $ListConfScripts")
    for file in ${Dirs}; do
        [ -f $file ] && sed -i '1,$d' $file || touch $file
    done
    echo "{}" >$ListConfScripts
}

## 更新定时任务（后端处理）
function Update_Cron() {

    # 读取脚本同步全局配置
    function Get_GobalConf() {
        cat $FileSyncConfUser | yq '.gobal' | jq -rc "$1"
    }

    ## 更新定时
    # $1 接口路径
    # $2 Body / json
    function cronFile_updateAll() {
        local data=$1
        local response=$(curl -s -X POST -H "Content-Type: application/json" -d "$data" "http://127.0.0.1:5678/api/cronFile/updateAll?_t=$(date +%s)000")
        echo "${response}"
    }

    local AddArr DelArr file newFiles deleteFiles
    ## 比较清单并生成差异清单
    if [ -s $ListOldScripts ] && [ -s $ListNewScripts ]; then
        diff $ListNewScripts $ListOldScripts | grep -E "^< " | awk '{print $2}' >$ListAddScripts
        diff $ListNewScripts $ListOldScripts | grep -E "^> " | awk '{print $2}' >$ListDelScripts
        [ ! -f $ListAddScripts ] && touch $ListAddScripts
        [ ! -f $ListDelScripts ] && touch $ListDelScripts
    elif [ ! -s $ListOldScripts ] && [ ! -s $ListNewScripts ]; then
        return # 清单无变化直接跳出
    elif [ ! -s $ListOldScripts ] && [ -s $ListNewScripts ]; then
        cp -f $ListNewScripts $ListAddScripts
    elif [ -s $ListOldScripts ] && [ ! -s $ListNewScripts ]; then
        cp -f $ListOldScripts $ListDelScripts
    fi

    ## 定义数据变量
    AddArr=(
        $(cat $ListAddScripts)
    )
    DelArr=(
        $(cat $ListDelScripts)
    )
    local data_tmp path active
    for ((i = 0; i < ${#AddArr[@]}; i++)); do
        path="$(cat $ListConfScripts | jq -r ".\"${AddArr[i]}\".path")"
        if [[ "$(cat $ListConfScripts | jq -r ".\"${AddArr[i]}\".autoDisable")" == "true" ]]; then
            active=0
        else
            active=1
        fi
        data_tmp='{"path": "'"${path}"'", "active": '"${active}"'}'
        if [[ $i -eq 0 ]]; then
            newFiles="${data_tmp}"
        else
            newFiles="${newFiles}, ${data_tmp}"
        fi
    done
    for ((i = 0; i < ${#DelArr[@]}; i++)); do
        if [[ $i -eq 0 ]]; then
            deleteFiles="\"${DelArr[i]}\""
        else
            deleteFiles="${deleteFiles}, \"${DelArr[i]}\""
        fi
    done
    if [[ "$(Get_GobalConf ".autoDisableRepoDuplicateCron")" == "true" ]]; then
        local autoDisable="true"
    else
        local autoDisable="false"
    fi
    # echo -e "AddArr:\n${#AddArr[@]}"
    # echo -e "DelArr:\n${#DelArr[@]}"
    # echo -e "newFiles:\n${newFiles}"
    # echo -e "deleteFiles:\n${deleteFiles}"

    ## 请求后端处理更新定时任务
    local data='{"type": "user", "autoDisable": '"${autoDisable}"', "newFiles": ['"${newFiles}"'], "deleteFiles": ['"${deleteFiles}"']}'
    # echo "${data}"
    # return
    local result="$(cronFile_updateAll "${data}")"
    # echo ${result}
    if [ "${result}" ]; then
        result="$(echo ${result} | jq)"
        echo -e "\n${result}"
    else
        echo -e "\n$ERROR 更新定时任务失败，接口未响应！\n"
    fi
}

## 更新所有仓库
function Update_AllRepo() {
    local Repo_Name Repo_Url Repo_Branch Repo_Dir Repo_Path Repo_Enable
    ## 统计仓库数量并生成配置
    Count_RepoSum
    Gen_RepoConf

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
