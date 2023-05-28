#!/bin/bash
## Modified: 2023-05-28

## 删除日志功能
# task rmlog [days]
function remove_logs() {

    ## 删除日志（通用）
    # 根据时间格式 YYYY-mm-dd HH:MM:SS 判断
    function rm_log_universal() {
        local target_file="$1"
        if [ -f $target_file ]; then
            local timestamp=$(($(date "+%s") - 86400 * ${RmDays}))
            local del_format_date=$(date -d "@${timestamp}" "+%Y-%m-%d")
            local line_end=$(($(cat $target_file | grep -n "${del_format_date}" | head -1 | awk -F ":" '{print $1}') - 3))
            [ ${line_end} -gt 0 ] && perl -i -ne "{print unless 1 .. ${line_end} }" $target_file
        fi
    }
    function rm_script_log() {
        local log_file_list=$(ls -l $LogDir/*/*.log 2>/dev/null | awk '{print $9}' | grep -v "log/bot")
        for log in ${log_file_list}; do
            ## 文件名比文件属性获得的日期要可靠
            local log_date=$(echo ${log} | awk -F '/' '{print $NF}' | grep -Eo "20[0-9][0-9]-[0-1][0-9]-[0-3][0-9]")
            [[ -z ${log_date} ]] && continue
            local time_difference=$(($(date +%s) - $(date +%s -d "${log_date}")))
            [ ${time_difference} -gt $((${RmDays} * 86400)) ] && rm -vf ${log}
        done
    }
    ## 删除日志目录下的空文件夹
    function rm_empty_dir() {
        cd $LogDir
        for dir in $(ls); do
            if [ -d ${dir} ] && [[ $(ls ${dir}) == "" ]]; then
                rm -rf ${dir}
            fi
        done
    }

    case $# in
    0)
        import_config_not_check
        local RmDays=${RmLogDaysAgo}
        ;;
    1)
        local RmDays=$1
        ;;
    esac

    if [ -n "${RmDays}" ]; then
        echo -e "\n$WORKING 开始检索并删除超过 ${BLUE}${RmDays}${PLAIN} 天的日志文件和日志内容...\n"
        rm_script_log # 删除脚本运行日志
        rm_log_universal "$LogDir/update.log" # 删除 update 的运行日志
        rm_log_universal "$BotLogDir/run.log" # 删除 Telegram Bot 的运行日志
        rm_empty_dir # 删除日志目录下的空文件夹
        [ -f $RootDir/core ] && rm -rf $RootDir/core # 删除缓存
        echo -e "\n$COMPLETE 运行结束\n"
    fi
}
