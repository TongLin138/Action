#!/bin/bash
## Modified: 2023-06-01
## 新增定时任务解析模块

## 定时表达式匹配算法 - 解析脚本内预设的定时表达式
function get_Cron() {
    local path="$1"

    ## 校验定时表达式合法性
    check_cron_expression() {
        local expression=$1 # 定时表达式
        local is_six=0
        local seconds_field=""
        local fields=()

        # 校验字段合法性
        check_field() {
            local field=$1
            local max_value=$2
            # 校验字段
            if [[ $field == "*" ]]; then
                return 0
            elif [[ $field =~ ^[0-9]+$ && $field -le $max_value ]]; then
                return 0
            elif [[ $field =~ ^[0-9]+\-[0-9]+$ ]]; then
                local start_end=($(echo "$field" | tr '-' ' '))
                local start=${start_end[0]}
                local end=${start_end[1]}
                if [[ $start -le $end && $start -le $max_value && $end -le $max_value ]]; then
                    return 0
                fi
            elif [[ $field =~ ^\*/[0-9]+$ ]]; then
                local divisor=${field:2}
                if [[ $divisor -ne 0 && $divisor -le $max_value ]]; then
                    return 0
                fi
            elif [[ $field =~ ^[0-9]+(,[0-9]+)*$ ]]; then
                local values=($(echo "$field" | tr ',' ' '))
                for value in "${values[@]}"; do
                    if [[ $value =~ ^[0-9]+$ && $value -le $max_value ]]; then
                        continue
                    else
                        return 1
                    fi
                done
                return 0
            fi
            return 1
        }

        # 按空格拆分表达式为数组
        IFS=' ' read -ra fields <<<"$expression"
        # 判断表达式的长度
        local field_count=${#fields[@]}
        if [[ $field_count -eq 5 ]]; then
            # 5位表达式，缺少秒字段，将秒字段置为 *
            seconds_field="*"
        elif [[ $field_count -eq 6 ]]; then
            # 6位表达式，有秒字段
            seconds_field="${fields[0]}"
            fields=("${fields[@]:1}")
            is_six=1
        else
            # echo '\033[31m[×]\033[0m'
            echo '' # 判断为非法表达式，返回为空值
            return
        fi
        # 校验秒字段
        if ! check_field "$seconds_field" 59; then
            # echo '\033[31m[×]\033[0m'
            echo '' # 判断为非法表达式，返回为空值
            return
        fi
        # 校验其他字段
        local max_values=(59 23 31 12 7) # 秒、分、时、日、月、周 的最大
        local field_indexes=(0 1 2 3 4)  # 秒、分、时、日、月 在数组中的索引
        local is_six_field=0             # 是否为扩展字段
        if [[ $is_six -eq 1 ]]; then
            max_values=(59 "${max_values[@]}")
            field_indexes=(1 2 3 4 5)
            is_six_field=1
        fi
        for i in "${!fields[@]}"; do
            local field=${fields[$i]}
            local max_value=${max_values[${field_indexes[$i]}]}
            if [[ $i -eq $field_count-1 && $is_six_field -eq 0 ]]; then
                # 最后一位是周字段，其最大值为 7
                max_value=7
            fi
            if ! check_field "$field" "$max_value"; then
                # echo '\033[31m[×]\033[0m'
                echo '' # 判断为非法表达式，返回为空值
                return
            fi
        done
        # echo '\033[32m[✔]\033[0m'
        echo "${expression}" # 判断为合法表达式，返回表达式
    }

    # # 测试
    # cron=(
    #     "7 7 7 7 7"
    # )
    # echo -e "\n定时表达式合法性测试（仅标准字符）\n"
    # for expression in "${cron[@]}"; do
    #     echo -en "$expression  "
    #     check_cron_expression "$expression"
    #     echo ''
    # done

    ## 生成每天执行一次的随机五位定时表达式
    function gen_random_cron() {
        local random_minute=$((${RANDOM} % 60))
        local random_hour=$((${RANDOM} % 24))
        echo -e "${random_minute} ${random_hour} * * *"
    }

    ## 提取定时表达式
    local cron="$(perl -ne 'while (/((?:[0-9*\/,-]+\s+){4}(?:[0-9*\/,-]+)(?:\s+[0-9*\/,-]+)?)/g) { my $expr = $1; $expr =~ s/^([^:]*):(.*)$/$1$2/; print "$expr\n"; }' $path | head -n 1)"
    ## 去除首尾空格
    cron="$(echo "${cron}" | sed -E 's/^[[:space:]]+|[[:space:]]+$//g')"
    ## 校验定时表达式
    check_cron_expression
    ## 如果未检测到或表达式不合法就随机一个每天执行 1 次的定时
    if [ "${cron}" ]; then
        echo "${cron}"
    else
        echo "$(gen_random_cron)"
    fi
}

## 查询脚本名 - 解析脚本名称
function query_scriptname() {
    local current_dir=$(pwd)
    local path="$1"
    local FileName=$(echo ${path##*/})

    cd ${path%/*} >/dev/null 2>&1
    case ${FileName##*.} in
    js)
        grep "\$ \=" $FileName | grep -Eiq ".*new Env\(.*\)"
        if [ $? -eq 0 ]; then
            local Tmp=$(grep "\$ \=" $FileName | grep -Ei ".*new Env\(.*\)" | head -1 | perl -pe "{s|.*nv\([\'\"](.*)[\'\"]\).*|\1|g}")
        else
            local Tmp=$(grep -w "script-path" $FileName | head -1 | sed "s/\W//g" | sed "s/[0-9a-zA-Z_]//g")
        fi
        ;;
    *)
        cat $FileName | sed -n "1,10p" | grep -Eiq ".*new Env\(.*\)"
        if [ $? -eq 0 ]; then
            local Tmp=$(grep "new Env(" $FileName | grep -Ei ".*new Env\(.*\)" | head -1 | perl -pe "{s|.*nv\([\'\"](.*)[\'\"]\).*|\1|g}")
        else
            local Tmp=$(grep -E "^脚本名称" $FileName | head -1 | awk -F "[\'\":,：]" '{print $2}' | awk -F "[\'\":,：]" '{print $1}')
        fi
        ;;
    esac
    cd $current_dir
    if [[ ${Tmp} ]]; then
        echo "${Tmp}"
    else
        echo "${FileName}"
    fi
}

## 获取标签
function Get_Tag() {
    local path="$1"
    echo "$path" | grep "^${ARCADIA_DIR}/repo/" -q
    if [ $? -eq 0 ]; then
        echo "$path" | awk -F '/' '{print$4}'
    else
        echo "$path" | grep "^${ARCADIA_DIR}/raw/" -q
        if [ $? -eq 0 ]; then
            echo "raw"
        else
            echo ""
        fi
    fi
}

function main() {
    local path="$1"
    local CronString="$(get_Cron "${path}")"
    local ScriptName="$(query_scriptname "${path}")"
    local FormatPath="$(echo "${path}" | sed "s|^${ARCADIA_DIR}/repo/||g")"
    local Tags=$(Get_Tag "${path}")

    ## 返回json格式
    echo '{"path": "'"${path}"'", "runPath": "'"${FormatPath}"'", "name": "'"${ScriptName}"'", "cron": "'"${CronString}"'", "tags": "'"${Tags}"'"}' | jq -c
}

main "$@"
