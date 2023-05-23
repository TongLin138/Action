#!/bin/bash
## Modified: 2023-05-13
## 新增定时任务解析模块

## 定时表达式匹配算法 - 解析脚本内预设的定时表达式
function Get_Cron() {
    ## 生成每天执行一次的随机定时表达式
    function Gen_Random_Cron() {
        local Random_Minute=$((${RANDOM} % 60))
        local Random_Hour=$((${RANDOM} % 24))
        echo -e "${Random_Minute} ${Random_Hour} * * * *"
    }
    local path="$1"
    local ScriptName=$(echo ${path##*/} | awk -F "." '{print $1}')
    local filterKeywords="function |def |async |await |return " # 编程语言常用关键字过滤
    ## 判断表达式所在行
    local Tmp1=$(grep -Ev "${filterKeywords}" ${path} | grep -E "^cron|^Cron|script-path=|[0-9] \* \*|^[0-9]\*.*${ScriptName}" | grep -Ev "^https\?:" | head -1 | perl -pe '{s|[a-zA-Z\"\.\=\:\_]||g;}')
    ## 判断开头
    local Tmp2=$(echo "${Tmp1}" | awk -F '[0-9]' '{print$1}' | sed 's/\*/\\*/g; s/\./\\./g')
    ## 判断表达式的第一个数字（分钟）
    local Tmp3=$(echo "${Tmp1}" | grep -Eo "[0-9]" | head -1)
    ## 判定开头是否为空值
    if [[ $(echo "${Tmp2}" | perl -pe '{s| ||g;}') = "" ]]; then
        local cron=$(echo "${Tmp1}" | awk '{if($1~/^[0-9]{1,2}/) print $1,$2,$3,$4,$5; else if ($1~/^[*]/) print $2,$3,$4,$5,$6}')
    else
        local cron=$(echo "${Tmp1}" | sed "s|${Tmp2}${Tmp3}|${Tmp3}|g" | awk '{if($1~/^[0-9]{1,2}/) print $1,$2,$3,$4,$5; else if ($1~/^[*]/) print $2,$3,$4,$5,$6}')
    fi
    ## 如果未检测出定时就随机一个每天执行1次的定时
    echo "${Tmp1}" | grep "[0-9]" -q
    if [ $? -eq 0 ]; then
        echo "${cron}"
    else
        echo "$(Gen_Random_Cron)"
    fi
}

## 查询脚本名 - 解析脚本名称
function Query_ScriptName() {
    local CurrentDir=$(pwd)
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
    cd $CurrentDir
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

function Main() {
    local path="$1"
    local CronString="$(Get_Cron "${path}")"
    local ScriptName="$(Query_ScriptName "${path}")"
    local FormatPath="$(echo "${path}" | sed "s|^${ARCADIA_DIR}/repo/||g")"
    local Tags=$(Get_Tag "${path}")

    ## 返回json格式
    echo '{"path": "'"${path}"'", "runPath": "'"${FormatPath}"'", "name": "'"${ScriptName}"'", "cron": "'"${CronString}"'", "tags": "'"${Tags}"'"}' | jq -c
}

Main "$@"
