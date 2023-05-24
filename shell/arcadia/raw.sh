#!/bin/bash
## Modified: 2023-05-25

function Add_Raw() {
    # 定义临时文件
    local tmp_file="${ARCADIA_DIR}/.raw.yml"
    # 生成配置文件模板
    function CreateTemplate() {
        echo '{ "name": "", "url": "", "cronSettings": { "updateTaskList": true } }' | jq | yq -y >$tmp_file
        # 插入缩进空格
        local LineSum="$(cat $tmp_file | grep "" -c)"
        for ((i = 1; i <= $LineSum; i++)); do
            [ $i -eq 1 ] && sed -i "1s/^/  - /g" $tmp_file || sed -i "${i}s/^/    /g" $tmp_file
        done
    }

    CreateTemplate
    [ -f $tmp_file ] && rm -rf $tmp_file
}
