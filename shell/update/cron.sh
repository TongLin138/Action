#!/bin/bash
## Modified: 2023-05-27

## 更新定时任务（后端处理）
function update_cron() {

    ## 更新定时
    # $1 Body/json
    function api_updatecron() {
        local data=$1
        local response=$(curl -s -X POST -H "Content-Type: application/json" -d "$data" "http://127.0.0.1:15678/inner/cron/updateAll?_t=$(date +%s)000")
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
        data_tmp='{"type": "system", "path": "'"${path}"'", "active": '"${active}"'}'
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
    # echo -e "AddArr:\n${#AddArr[@]}"
    # echo -e "DelArr:\n${#DelArr[@]}"
    # echo -e "newFiles:\n${newFiles}"
    # echo -e "deleteFiles:\n${deleteFiles}"

    ## 请求后端处理更新定时任务
    local data='{"newFiles": ['"${newFiles}"'], "deleteFiles": ['"${deleteFiles}"']}'
    # echo "${data}"
    # return
    local result="$(api_updatecron "${data}")"
    # echo ${result}
    if [ "${result}" ]; then
        result="$(echo ${result} | jq)"
        echo -e "\n${result}"
    else
        echo -e "\n$ERROR 更新定时任务失败，接口未响应！\n"
    fi
}
