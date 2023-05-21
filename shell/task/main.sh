#!/bin/bash
## Modified: 2023-05-21


## 自定义推送通知功能
function SendNotify() {
    Import_Config_Not_Check
    Notify "$1" "$2"
}

## 切换分支功能
function SwitchBranch() {
    local CurrentBranch=$(git status | head -n 1 | awk -F ' ' '{print$NF}')
    if [[ ${CurrentBranch} == "master" ]]; then
        echo ''
        git reset --hard
        git checkout dev
        echo -e "\n$COMPLETE 已为您切换至开发分支，感谢参与测试\n"
    elif [[ ${CurrentBranch} == "dev" ]]; then
        echo ''
        git reset --hard
        git checkout master
        echo -e "\n$COMPLETE 已切换回用户分支\n"
    fi
}

## 删除日志功能
function Remove_LogFiles() {
    local LogFileList LogDate DiffTime Stmp DateDelLog LineEndGitPull LineEndBotRun RmDays
    case $# in
    0)
        Import_Config_Not_Check
        RmDays=${RmLogDaysAgo}
        ;;
    1)
        RmDays=$1
        ;;
    esac
    function Rm_JsLog() {
        LogFileList=$(ls -l $LogDir/*/*.log 2>/dev/null | awk '{print $9}' | grep -v "log/bot")
        for log in ${LogFileList}; do
            ## 文件名比文件属性获得的日期要可靠
            LogDate=$(echo ${log} | awk -F '/' '{print $NF}' | grep -Eo "20[2-9][0-9]-[0-1][0-9]-[0-3][0-9]")
            [[ -z ${LogDate} ]] && continue
            DiffTime=$(($(date +%s) - $(date +%s -d "${LogDate}")))
            [ ${DiffTime} -gt $((${RmDays} * 86400)) ] && rm -vf ${log}
        done
    }
    ## 删除 update 的运行日志
    function Rm_UpdateLog() {
        if [ -f $LogDir/update.log ]; then
            Stmp=$(($(date "+%s") - 86400 * ${RmDays}))
            DateDelLog=$(date -d "@${Stmp}" "+%Y-%m-%d")
            LineEndGitPull=$(($(cat $LogDir/update.log | grep -n "${DateDelLog}" | head -1 | awk -F ":" '{print $1}') - 3))
            [ ${LineEndGitPull} -gt 0 ] && perl -i -ne "{print unless 1 .. ${LineEndGitPull} }" $LogDir/update.log
        fi
    }
    ## 删除 Bot 的运行日志
    function Rm_BotLog() {
        if [ -f $BotLogDir/run.log ]; then
            Stmp=$(($(date "+%s") - 86400 * ${RmDays}))
            DateDelLog=$(date -d "@${Stmp}" "+%Y-%m-%d")
            LineEndBotRun=$(($(cat $BotLogDir/run.log | grep -n "${DateDelLog}" | tail -n 1 | awk -F ":" '{print $1}') - 3))
            [ ${LineEndBotRun} -gt 0 ] && perl -i -ne "{print unless 1 .. ${LineEndBotRun} }" $BotLogDir/run.log
        fi
    }
    ## 删除空文件夹
    function Rm_EmptyDir() {
        cd $LogDir
        for dir in $(ls); do
            if [ -d ${dir} ] && [[ $(ls ${dir}) == "" ]]; then
                rm -rf ${dir}
            fi
        done
    }
    ## 汇总
    if [ -n "${RmDays}" ]; then
        echo -e "\n$WORKING 开始检索并删除超过 ${BLUE}${RmDays}${PLAIN} 天的日志文件...\n"
        Rm_JsLog
        Rm_UpdateLog
        Rm_BotLog
        Rm_EmptyDir
        [ -f $RootDir/core ] && rm -rf $RootDir/core
        echo -e "\n$COMPLETE 运行结束\n"
    fi
}

## 判断传入命令（最外层通过传入参数数量判断）
case $# in
0)
    Help $TaskCmd
    ;;
1)
    case $1 in
    ps)
        import task/process
        Process_Status
        ;;
    list)
        import task/list
        List_Local_Scripts
        ;;
    rmlog)
        Remove_LogFiles
        ;;
    cleanup)
        import task/process
        Process_CleanUp
        ;;
    debug)
        SwitchBranch
        ;;
    *)
        Help $TaskCmd
        ;;
    esac
    ;;
## 2个参数
2)
    case $1 in
    # 运行脚本
    run | conc)
        RUN_MODE="$1"
        import task/run
        Run_Script "${RUN_MODE}" "$2"
        ;;
    # 终止运行
    stop)
        import task/process
        Process_Stop $2
        ;;
    cookie)
        case $2 in
        update | check | list | beans)
            import task/account
            Accounts_Control $2
            ;;
        *)
            Output_Command_Error 1 # 命令错误
            ;;
        esac
        ;;
    # 清理日志
    rmlog)
        case $2 in
        [1-9] | [1-9][0-9] | [1-9][0-9][0-9] | [1-9][0-9][0-9][0-9])
            Remove_LogFiles $2
            ;;
        *)
            Output_Command_Error 1 # 命令错误
            ;;
        esac
        ;;
    # 清理进程
    cleanup)
        case $2 in
        [1-9] | [1-9][0-9] | [1-9][0-9][0-9] | [1-9][0-9][0-9][0-9])
            import task/process
            Process_CleanUp $2
            ;;
        *)
            Output_Command_Error 1 # 命令错误
            ;;
        esac
        ;;
    # 脚本列表
    list)
        import task/list
        List_Local_Scripts $2
        ;;
    ps | cleanup)
        Output_Command_Error 2 # 命令过多
        ;;
    *)
        Output_Command_Error 1 # 命令错误
        ;;
    esac
    ;;

## 3个参数
3)
    case $1 in
    run | conc)
        ## 定义执行内容，下面的判断会把参数打乱
        RUN_MODE="${1}"
        RUN_TARGET="${2}"
        ## 判断参数
        while [ $# -gt 2 ]; do
            case $3 in
            -l | --loop)
                case "${RUN_MODE}" in
                run)
                    echo -e "\n$ERROR 检测到 ${BLUE}$3${PLAIN} 为无效参数，请在该参数后指定循环次数！\n"
                    ;;
                conc)
                    echo -e "\n$ERROR 检测到 ${BLUE}$3${PLAIN} 为无效参数，该参数仅适用于普通执行！\n"
                    ;;
                esac
                exit ## 终止退出
                ;;
            -m | --mute)
                RUN_MUTE="true"
                ;;
            -w | --wait)
                echo -e "\n$ERROR 检测到 ${BLUE}$3${PLAIN} 为无效参数，请在该参数后指定等待时间！\n"
                exit ## 终止退出
                ;;
            -a | --agent)
                RUN_GLOBAL_AGENT="true"
                ;;
            -d | --delay)
                RUN_DELAY="true"
                ;;
            -p | --proxy)
                echo ${RUN_TARGET} | grep -Eq "http.*:.*github"
                if [ $? -eq 0 ]; then
                    DOWNLOAD_PROXY="true"
                else
                    echo -e "$ERROR 检测到 ${BLUE}$3${PLAIN} 为无效参数，该参数仅适用于执行位于 GitHub 仓库的脚本，请确认后重新输入！\n"
                    exit ## 终止退出
                fi
                ;;
            -h | --hang)
                case "${RUN_MODE}" in
                run)
                    RUN_DAEMON="true"
                    ;;
                conc)
                    echo -e "\n$ERROR 检测到 ${BLUE}$3${PLAIN} 为无效参数，该参数仅适用于普通执行！\n"
                    exit ## 终止退出
                    ;;
                esac
                ;;
            -c | --cookie)
                echo -e "\n$ERROR 检测到 ${BLUE}$3${PLAIN} 为无效参数，请在该参数后指定运行账号！\n"
                exit ## 终止退出
                ;;
            -g | --grouping)
                case "${RUN_MODE}" in
                run)
                    echo -e "\n$ERROR 检测到 ${BLUE}$3${PLAIN} 为无效参数，请在该参数后指定账号运行分组！\n"
                    ;;
                conc)
                    echo -e "\n$ERROR 检测到 ${BLUE}$3${PLAIN} 为无效参数，该参数仅适用于普通执行！\n"
                    ;;
                esac
                exit ## 终止退出
                ;;
            -b | --background)
                case "${RUN_MODE}" in
                run)
                    RUN_BACKGROUND="true"
                    ;;
                conc)
                    echo -e "\n$ERROR 检测到 ${BLUE}$3${PLAIN} 为无效参数，该参数仅适用于普通执行！\n"
                    exit ## 终止退出
                    ;;
                esac
                ;;
            *)
                echo -e "\n$ERROR 检测到 ${BLUE}$3${PLAIN} 为无效参数，请确认后重新输入！\n"
                exit ## 终止退出
                ;;
            esac
            shift
        done
        ## 运行
        import task/run
        Run_Script "${RUN_MODE}" "${RUN_TARGET}"
        ;;
    cookie)
        case $2 in
        update | check | beans)
            case $3 in
            [1-9] | [1-9][0-9] | [1-9][0-9][0-9] | [1-9][0-9][0-9][0-9])
                import task/account
                Accounts_Control $2 $3
                ;;
            *)
                grep -Eq "Cookie[0-9]{1,3}=.*pt_pin=$3;.*" $FileConfUser
                if [ $? -eq 0 ]; then
                    import task/account
                    Accounts_Control $2 $(grep -E "Cookie[0-9]{1,3}=.*pt_pin=$3;.*" $FileConfUser | awk -F '=' '{print$1}' | awk -F 'Cookie' '{print$2}')
                else
                    Output_Command_Error 1 # 命令错误
                fi
                ;;
            esac
            ;;
        *)
            Output_Command_Error 1 # 命令错误
            ;;
        esac
        ;;
    notify)
        SendNotify $2 $3
        ;;
    *)
        Output_Command_Error 1 # 命令错误
        ;;
    esac
    ;;

## 多个参数（ 2 + 参数个数 + 参数值个数 ）
[4-9] | [1][0-7])
    case $1 in
    run | conc)
        ## 定义执行内容，下面的判断会把参数打乱
        RUN_MODE="${1}"
        RUN_TARGET="${2}"
        ## 判断参数
        while [ $# -gt 2 ]; do
            case $3 in
            -l | --loop)
                case "${RUN_MODE}" in
                run)
                    if [[ $4 ]]; then
                        echo "$4" | grep -Eq "[a-zA-Z,/\!@#$%^&*|\-_=\+]|\(|\)|\[|\]|\{|\}"
                        if [ $? -eq 0 ]; then
                            echo -e "\n$ERROR 检测到无效参数值 ${BLUE}$4${PLAIN} ，语法有误请确认后重新输入！\n"
                            exit ## 终止退出
                        else
                            RUN_LOOP="true"
                            RUN_LOOP_TIMES="$4"
                            shift
                        fi
                    else
                        echo -e "\n$ERROR 检测到 ${BLUE}$3${PLAIN} 为无效参数，请在该参数后指定循环次数！\n"
                        exit ## 终止退出
                    fi
                    ;;
                conc)
                    echo -e "\n$ERROR 检测到 ${BLUE}$3${PLAIN} 为无效参数，该参数仅适用于普通执行！\n"
                    exit ## 终止退出
                    ;;
                esac
                ;;
            -m | --mute)
                RUN_MUTE="true"
                ;;
            -w | --wait)
                if [[ $4 ]]; then
                    echo "$4" | grep -Eq "[abcefgijklnopqrtuvwxyzA-Z,/\!@#$%^&*|\-_=\+]|\(|\)|\[|\]|\{|\}"
                    if [ $? -eq 0 ]; then
                        echo -e "\n$ERROR 检测到无效参数值 ${BLUE}$4${PLAIN} ，语法有误请确认后重新输入！\n"
                        exit ## 终止退出
                    else
                        RUN_WAIT="true"
                        RUN_WAIT_TIMES="$4"
                        shift
                    fi
                else
                    echo -e "\n$ERROR 检测到 ${BLUE}$3${PLAIN} 为无效参数，请在该参数后指定等待时间！\n"
                    exit ## 终止退出
                fi
                ;;
            -a | --agent)
                RUN_GLOBAL_AGENT="true"
                ;;
            -d | --delay)
                RUN_DELAY="true"
                ;;
            -p | --proxy)
                echo ${RUN_TARGET} | grep -Eq "http.*:.*github"
                if [ $? -eq 0 ]; then
                    DOWNLOAD_PROXY="true"
                else
                    echo -e "\n$ERROR 检测到 ${BLUE}$3${PLAIN} 为无效参数，该参数仅适用于执行位于 GitHub 仓库的脚本，请确认后重新输入！\n"
                    exit ## 终止退出
                fi
                ;;
            -h | --hang)
                case "${RUN_MODE}" in
                run)
                    RUN_DAEMON="true"
                    ;;
                conc)
                    echo -e "\n$ERROR 检测到 ${BLUE}$3${PLAIN} 为无效参数，该参数仅适用于普通执行！\n"
                    exit ## 终止退出
                    ;;
                esac
                ;;
            -c | --cookie)
                if [[ $4 ]]; then
                    echo "$4" | grep -Eq "[a-zA-Z\.;:\<\>/\!@#$^&*|\-_=\+]|\(|\)|\[|\]|\{|\}"
                    if [ $? -eq 0 ]; then
                        echo -e "\n$ERROR 检测到无效参数值 ${BLUE}$4${PLAIN} ，语法有误请确认后重新输入！\n"
                        exit ## 终止退出
                    else
                        if [[ ${RUN_GROUPING} == true ]]; then
                            echo -e "\n$ERROR 检测到无效参数 ${BLUE}$3${PLAIN} ，不可与账号分组参数同时使用！\n"
                            exit ## 终止退出
                        else
                            RUN_DESIGNATED="true"
                            DESIGNATED_VALUE="$4"
                            shift
                        fi
                    fi
                else
                    echo -e "\n$ERROR 检测到 ${BLUE}$3${PLAIN} 为无效参数，请在该参数后指定运行账号！\n"
                    exit ## 终止退出
                fi
                ;;
            -g | --grouping)
                case "${RUN_MODE}" in
                run)
                    if [[ $4 ]]; then
                        echo "$4" | grep -Eq "[a-zA-Z\.;:\<\>/\!#$^&*|\-_=\+]|\(|\)|\[|\]|\{|\}"
                        if [ $? -eq 0 ]; then
                            echo -e "\n$ERROR 检测到无效参数值 ${BLUE}$4${PLAIN} ，语法有误请确认后重新输入！\n"
                            exit ## 终止退出
                        else
                            if [[ ${RUN_DESIGNATED} == true ]]; then
                                echo -e "\n$ERROR 检测到无效参数 ${BLUE}$3${PLAIN} ，不可与指定账号参数同时使用！\n"
                                exit ## 终止退出
                            else
                                ## 判断是否已分组
                                echo "$4" | grep -Eq "@"
                                if [ $? -eq 0 ]; then
                                    RUN_GROUPING="true"
                                    GROUPING_VALUE="$4"
                                    shift
                                else
                                    echo -e "\n$ERROR 检测到无效参数值 ${BLUE}$4${PLAIN} ，请定义账号分组否则请使用指定账号参数！\n"
                                    exit ## 终止退出
                                fi
                            fi
                        fi
                    else
                        echo -e "\n$ERROR 检测到 ${BLUE}$3${PLAIN} 为无效参数，请在该参数后指定账号运行分组！\n"
                        exit ## 终止退出
                    fi
                    ;;
                conc)
                    echo -e "\n$ERROR 检测到 ${BLUE}$3${PLAIN} 为无效参数，该参数仅适用于普通执行！\n"
                    exit ## 终止退出
                    ;;
                esac
                ;;
            -b | --background)
                case "${RUN_MODE}" in
                run)
                    RUN_BACKGROUND="true"
                    ;;
                conc)
                    echo -e "\n$ERROR 检测到 ${BLUE}$3${PLAIN} 为无效参数，该参数仅适用于普通执行！\n"
                    exit ## 终止退出
                    ;;
                esac
                ;;
            *)
                echo -e "\n$ERROR 检测到 ${BLUE}$3${PLAIN} 为无效参数，请确认后重新输入！\n"
                exit ## 终止退出
                ;;
            esac
            shift
        done
        ## 运行
        import task/run
        Run_Script "${RUN_MODE}" "${RUN_TARGET}"
        ;;
    *)
        Output_Command_Error 1 # 命令错误
        ;;
    esac
    ;;

*)
    Output_Command_Error 2 # 命令过多
    ;;
esac
