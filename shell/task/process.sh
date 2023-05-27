#!/bin/bash
## Modified: 2023-05-27

## 终止执行
# task stop
function process_stop() {
    local InputContent=$1
    local ProcessShielding="grep|pkill|/bin/bash /usr/local/bin| task "
    ## 匹配脚本
    Find_Script ${InputContent}
    local ProcessKeywords="${FileName}\.${FileSuffix}\$"
    ## 判定对应脚本是否存在相关进程
    ps -ef | grep -Ev "grep|pkill" | grep "${FileName}\.${FileSuffix}$" -wq
    local EXITSTATUS=$?
    if [[ ${EXITSTATUS} == 0 ]]; then
        ## 列出检测到的相关进程
        echo -e "\n检测到下列关于 ${BLUE}${FileName}.${FileSuffix}${PLAIN} 脚本的进程："
        echo -e "\n${BLUE}[进程]  [任务]${PLAIN}"
        ps -axo pid,command | grep "${ProcessKeywords}" | grep -Ev "${ProcessShielding}"
        ## 终止前等待确认
        echo -en "\n$WORKING 进程将在 ${BLUE}3${PLAIN} 秒后终止，可通过 ${BLUE}Ctrl + Z${PLAIN} 中断此操作..."
        sleep 3
        echo ''
        ## 杀死进程
        kill -9 $(ps -ef | grep "${ProcessKeywords}" | grep -Ev "${ProcessShielding}" | awk '$0 !~/grep/ {print $2}' | tr -s '\n' ' ') >/dev/null 2>&1
        sleep 1
        kill -9 $(ps -ef | grep "${ProcessKeywords}" | grep -Ev "${ProcessShielding}" | awk '$0 !~/grep/ {print $2}' | tr -s '\n' ' ') >/dev/null 2>&1

        ## 验证
        ps -ef | grep -Ev "grep|pkill" | grep "\.${FileSuffix}$" -wq
        if [ $? -eq 0 ]; then
            ps -axo pid,command | less | grep "${ProcessKeywords}" | grep -Ev "${ProcessShielding}"
            echo -e "\n$FAIL 未能成功终止进程，请尝试手动 ${BLUE}kill -9 <pid>${PLAIN}\n"
        else
            echo -e "\n$SUCCESS 已终止相关进程\n"
        fi
    else
        echo -e "\n$ERROR 未检测到与 ${BLUE}${FileName}${PLAIN} 脚本相关的进程，可能此时没有正在运行，请确认！\n"
    fi
}

## 进程状态功能
# task ps
function process_status() {
    local MemoryTotal MemoryUsed MemoryFree MemoryAvailable MemoryUsage CPUUsage MemoryUsedNew MemoryAvailableNew MemoryUsageNew LogFilesSpace
    MemoryTotal=$(free -m | grep Mem | awk -F ' ' '{print$2}')
    MemoryUsed=$(free -m | grep Mem | awk -F ' ' '{print$3}')
    MemoryFree=$(free -m | grep Mem | awk -F ' ' '{print$4}')
    MemoryAvailable=$(free -m | grep Mem | awk -F ' ' '{print$7}')
    MemoryUsage=$(awk 'BEGIN{printf "%.1f%\n",('$MemoryUsed'/'$MemoryTotal')*100}')
    CPUUsage=$(busybox top -n 1 | grep CPU | head -1 | awk -F ' ' '{print$2}')
    ConfigSpaceUsage=$(du -sm $ConfigDir | awk -F ' ' '{print$1}')
    LogFilesSpaceUsage=$(du -sm $LogDir | awk -F ' ' '{print$1}')
    ScriptsRepoSpaceUsage=$(du -sm $ScriptsDir | awk -F ' ' '{print$1}')
    OwnReposSpaceUsage=$(du -sm $ReposDir | awk -F ' ' '{print$1}')
    ReposSpaceUsage=$((${ScriptsRepoSpaceUsage} + ${OwnReposSpaceUsage}))
    echo -e "\n❖  处理器使用率：${YELLOW}${CPUUsage}${PLAIN}   内存使用率：${YELLOW}${MemoryUsage}${PLAIN}   可用内存：${YELLOW}${MemoryAvailable}MB${PLAIN}   空闲内存：${YELLOW}${MemoryFree}MB${PLAIN}   \n\n❖  配置文件占用空间：${YELLOW}${ConfigSpaceUsage}MB${PLAIN}    日志占用空间：${YELLOW}${LogFilesSpaceUsage}MB${PLAIN}    脚本占用空间：${YELLOW}${ReposSpaceUsage}MB${PLAIN}"
    ## 检测占用过高后释放内存
    if [[ $(echo ${MemoryUsage} | awk -F '.' '{print$1}') -gt "89" ]]; then
        sync >/dev/null 2>&1
        echo 3 >/proc/sys/vm/drop_caches >/dev/null 2>&1
        MemoryUsedNew=$(free -m | grep Mem | awk -F ' ' '{print$3}')
        MemoryAvailableNew=$(free -m | grep Mem | awk -F ' ' '{print$4}')
        MemoryUsageNew=$(awk 'BEGIN{printf "%.1f%%\n",('$MemoryUsedNew'/'$MemoryTotal')*100}')
        echo -e "\n$WORKING 检测到内存占用过高，开始尝试释放内存..."
        echo -e "${BLUE}[释放后]${PLAIN}  内存占用：${YELLOW}${MemoryUsageNew}${PLAIN}   可用内存：${YELLOW}${MemoryAvailableNew}MB${PLAIN}"
    fi
    ## 列出进程
    echo -e "\n${BLUE}[运行时长]  [CPU]    [内存]    [脚本名称]${PLAIN}"
    ps -axo user,time,pcpu,user,pmem,user,command --sort -pmem | less | egrep "\.js$|\.py$|\.ts$" | egrep -v "\/jd\/web\/server\.js|pm2 |egrep |perl |sed |bash |wget |\<defunct\>" |
        perl -pe '{s| root     |% |g; s|\/usr\/bin\/ts-node-transpile-only ||g; s|\/usr\/bin\/ts-node ||g; s|\/usr\/bin\/python3 ||g; s|python3 -u ||g; s|\/usr\/bin\/python ||g; s|\/usr\/bin\/node ||g; s|node -r global-agent/bootstrap |(代理)|g; s|node ||g;  s|root     |#|g; s|#[0-9][0-9]:|#|g;  s|  | |g; s| |     |g; s|#|•  |g; s|/jd/scripts/jd_cfd_loop\.js|jd_cfd_loop\.js|g; s|\./utils/||g;}'
    echo ''
}

## 进程清理功能（终止卡死进程释放内存）
# task cleanup
function process_cleanup() {
    local CheckHour ProcessArray FormatCurrentTime StartTime FormatDiffTime Tmp
    ## 判断检测时间，单位小时
    case $# in
    0)
        CheckHour=6
        ;;
    1)
        CheckHour=$1
        ;;
    esac
    ## 生成进程清单
    ps -axo pid,time,user,start,command | egrep "\.js$|\.py$|\.ts$" | egrep -v "server\.js|pm2|egrep|perl|sed|bash" | grep -E "[0-9][0-9]:[0-9][0-9]:[0-9][0-9] root" >${FileProcessList}
    if [[ "$(cat ${FileProcessList})" != "" ]]; then
        echo -e "\n$WORKING 开始匹配并清理启动超过 ${BLUE}${CheckHour}${PLAIN} 小时的卡死进程...\n"
        ## 生成进程 PID 数组
        ProcessArray=($(
            cat ${FileProcessList} | awk -F ' ' '{print$1}'
        ))
        ## 定义当前时间戳
        FormatCurrentTime=$(date +%s)
        for ((i = 1; i <= ${#ProcessArray[@]}; i++)); do
            local n=$((i - 1))
            ## 判断启动时间的类型（距离启动超过1天会显示为日期）
            StartTime=$(grep "${ProcessArray[n]}" ${FileProcessList} | awk -F ' ' '{print$4}')
            if [[ ${StartTime} = [0-9][0-9]:[0-9][0-9]:[0-9][0-9] ]]; then
                ## 定义实际时间戳
                Tmp=$(date +%s -d "$(date "+%Y-%m-%d") ${StartTime}")
                [[ ${Tmp} -gt ${FormatCurrentTime} ]] && FormatStartTime=$((${Tmp} - 86400)) || FormatStartTime=${Tmp}
                ## 比较时间
                FormatDiffTime=$((${FormatCurrentTime} - 3600 * ${CheckHour}))
                if [[ ${FormatDiffTime} -gt ${FormatStartTime} ]]; then
                    echo -e "已终止进程：${ProcessArray[n]}  脚本名称：$(grep ${ProcessArray[n]} ${FileProcessList} | awk -F ' ' '{print$NF}')"
                    kill -9 ${ProcessArray[n]} >/dev/null 2>&1
                else
                    continue
                fi
            elif [[ ${StartTime} = [ADFJMNOS][a-z]* ]]; then
                echo -e "已终止进程：${ProcessArray[n]}  脚本名称：$(grep ${ProcessArray[n]} ${FileProcessList} | awk -F ' ' '{print$NF}')"
                kill -9 ${ProcessArray[n]} >/dev/null 2>&1
            fi
        done
        echo -e "\n$COMPLETE 运行结束\n"
        [ -f ${FileProcessList} ] && rm -rf ${FileProcessList}
    else
        echo -e "\n$COMPLETE 未查询到正在运行中的进程\n"
    fi
}
