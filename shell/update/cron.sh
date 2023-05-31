#!/bin/bash
## Modified: 2023-05-29

## 更新定时任务（后端处理）
function update_cron() {

    ## 更新定时
    # $1 Body/json
    function api_updatecron() {
        local data=$1
        local response=$(curl -s -X POST -H "Content-Type: application/json" -d "$data" "http://127.0.0.1:15678/inner/cron/updateAll?_t=$(date +%s)000")
        echo "${response}"
    }

    ## 处理接口响应
    function handle_result() {
        local success type name path message status array_title_add array_msg_add array_title_del array_msg_del
        local send_mark_add="$RootDir/.send_mark_add.log"
        local send_mark_del="$RootDir/.send_mark_del.log"
        local array_num_add=0
        local array_num_del=0
        local request="$1"

        if [[ "$(echo "${request}" | jq -r '.code')" != "1" ]]; then
            echo "${request}" | jq -r '.message'
            echo -e "\n$ERROR 更新定时任务失败，接口响应错误！"
            return
        fi

        local result="$(echo "${request}" | jq -rc '.result')"
        local result_length="$(echo "${result}" | jq 'length')"
        for ((i = 0; i < ${result_length}; i++)); do
            success="$(echo "${result}" | jq -r ".[${i}].success")" # 处理结果：true 成功 false 失败
            type="$(echo "${result}" | jq -r ".[${i}].type")"       # 处理类型： 0 添加 1 删除
            name="$(echo "${result}" | jq -r ".[${i}].name")"       # 脚本名称（中文名称/文件名）
            path="$(echo "${result}" | jq -r ".[${i}].path")"       # 脚本路径
            message="$(echo "${result}" | jq -r ".[${i}].message")" # 处理结果消息（报错时返回）

            case "${type}" in
            0)
                [[ "${success}" == "true" ]] && status="添加成功" || status="添加失败（${message}）"
                array_title_add[$array_num_add]="${name}"
                array_msg_add[$array_num_add]="${status}"
                ## 推送通知提醒
                if [[ "$(cat $ListConfScripts | jq -r '."'"${path}"'".addNotify')" == "true" ]]; then
                    echo "${name} => ${status}" >>$send_mark_add
                fi
                let array_num_add++
                ;;
            1)
                [[ "${success}" == "true" ]] && status="删除成功" || status="删除失败（${message}）"
                array_title_del[$array_num_del]="${name}"
                array_msg_del[$array_num_del]="${status}"
                ## 推送通知提醒
                if [[ "$(cat $ListConfScripts | jq -r '."'"${path}"'".delNotify')" == "true" ]]; then
                    echo "${name} => ${status}" >>$send_mark_del
                fi
                let array_num_del++
                ;;
            esac
        done
        # echo -e "\n${result}"
        ## 打印结果
        local tmp_file="$RootDir/.tmp.json"
        if [ $array_num_add -gt 0 ]; then
            echo "[]" >$tmp_file
            for ((i = 0; i < $array_num_add; i++)); do
                echo "$(cat $tmp_file | jq '.['$i']={ "新增定时任务": "'"${array_title_add[i]}"'", "消息": "'"${array_msg_add[i]}"'" }')" >$tmp_file
            done
            echo ''
            output_table_data_file "$tmp_file"
        fi
        if [ $array_num_del -gt 0 ]; then
            echo "[]" >$tmp_file
            for ((i = 0; i < $array_num_del; i++)); do
                echo "$(cat $tmp_file | jq '.['$i']={ "过期定时任务": "'"${array_title_del[i]}"'", "消息": "'"${array_msg_del[i]}"'" }')" >$tmp_file
            done
            echo ''
            output_table_data_file "$tmp_file"
        fi
        [ -f $tmp_file ] && rm -f $tmp_file
        ## 推送通知提醒
        if [ -s $send_mark_add ]; then
            send_notify "新增定时任务" "$(cat $send_mark_add)"
            rm -f $send_mark_add
        fi
        if [ -s $send_mark_del ]; then
            send_notify "过期定时任务" "$(cat $send_mark_del)"
            rm -f $send_mark_del
        fi
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
        data_tmp='{"path": "'"${path}"'", "active": '${active}'}'
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
    local data='{"type": "system", "newFiles": ['"${newFiles}"'], "deleteFiles": ['"${deleteFiles}"']}'
    # echo "${data}"
    # return
    local req="$(api_updatecron "${data}")"
    # echo ${req}
    if [ "${req}" ]; then
        handle_result "${req}"
    else
        echo -e "\n$ERROR 更新定时任务失败，接口未响应！"
    fi
}
