#!/bin/bash
## Modified: 2023-06-13

function main() {
    case $# in
    0)
        import core/help
        print_help $TaskCmd
        ;;
    1)
        case $1 in
        run)
            import core/help
            print_help "${TaskCmd}_run"
            ;;
        conc)
            import core/help
            print_help "${TaskCmd}_conc"
            ;;
        ps)
            import task/process
            process_status
            ;;
        rmlog)
            import task/rmlog
            remove_logs
            ;;
        cleanup)
            import task/process
            process_cleanup
            ;;
        *)
            import core/help
            print_help $TaskCmd
            ;;
        esac
        ;;
    ## 2个命令选项
    2)
        case $1 in
        # 运行脚本
        run | conc)
            RUN_MODE="$1"
            import task/run
            run_script "${RUN_MODE}" "$2"
            ;;
        # 终止运行
        stop)
            import task/process
            process_stop $2
            ;;
        cookie)
            case $2 in
            update | check | list | beans)
                import task/account
                accounts_control $2
                ;;
            *)
                output_command_error 1 # 命令错误
                ;;
            esac
            ;;
        # 清理日志
        rmlog)
            case $2 in
            [1-9] | [1-9][0-9] | [1-9][0-9][0-9] | [1-9][0-9][0-9][0-9])
                import task/rmlog
                remove_logs $2
                ;;
            *)
                output_command_error 1 # 命令错误
                ;;
            esac
            ;;
        # 清理进程
        cleanup)
            case $2 in
            [1-9] | [1-9][0-9] | [1-9][0-9][0-9] | [1-9][0-9][0-9][0-9])
                import task/process
                process_cleanup $2
                ;;
            *)
                output_command_error 1 # 命令错误
                ;;
            esac
            ;;
        # 脚本列表
        list)
            import task/list
            list_local_scripts $2
            ;;
        ps | cleanup)
            output_command_error 2 # 命令过多
            ;;
        *)
            output_command_error 1 # 命令错误
            ;;
        esac
        ;;

    ## 3个参数
    3)
        case $1 in
        run | conc)
            RUN_MODE="${1}"
            shift
            RUN_TARGET="${1}"
            shift
            ## 判断命令选项
            while [ $# -gt 0 ]; do
                case "$1" in
                -l | --loop)
                    case "${RUN_MODE}" in
                    run)
                        output_error "检测到 ${BLUE}$1${PLAIN} 为无效命令选项，请在该命令选项后指定循环次数！"
                        ;;
                    conc)
                        output_error "检测到 ${BLUE}$1${PLAIN} 为无效命令选项，该命令选项仅适用于普通执行！"
                        ;;
                    esac
                    ;;
                -s | --silent)
                    RUN_SILENT="true"
                    ;;
                -w | --wait)
                    output_error "检测到 ${BLUE}$1${PLAIN} 为无效命令选项，请在该命令选项后指定等待时间！"
                    ;;
                -a | --agent)
                    RUN_GLOBAL_AGENT="true"
                    ;;
                -D | --delay)
                    RUN_DELAY="true"
                    ;;
                -T | --Timeout)
                    output_error "检测到 ${BLUE}$1${PLAIN} 为无效命令选项，请在该命令选项后指定超时命令选项！"
                    ;;
                -p | --proxy)
                    echo ${RUN_TARGET} | grep -Eq "https?://.*github"
                    if [ $? -eq 0 ]; then
                        DOWNLOAD_PROXY="true"
                    else
                        output_error "检测到 ${BLUE}$1${PLAIN} 为无效命令选项，该命令选项仅适用于执行位于 GitHub 仓库的脚本，请确认后重新输入！"
                    fi
                    ;;
                -d | --daemon)
                    case "${RUN_MODE}" in
                    run)
                        RUN_DAEMON="true"
                        ;;
                    conc)
                        output_error "检测到 ${BLUE}$1${PLAIN} 为无效命令选项，该命令选项仅适用于普通执行！"
                        ;;
                    esac
                    ;;
                -c | --cookie)
                    output_error "检测到 ${BLUE}$1${PLAIN} 为无效命令选项，请在该命令选项后指定运行账号！"
                    ;;
                -g | --grouping)
                    case "${RUN_MODE}" in
                    run)
                        output_error "检测到 ${BLUE}$1${PLAIN} 为无效命令选项，请在该命令选项后指定账号运行分组！"
                        ;;
                    conc)
                        output_error "检测到 ${BLUE}$1${PLAIN} 为无效命令选项，该命令选项仅适用于普通执行！"
                        ;;
                    esac
                    ;;
                -b | --background)
                    case "${RUN_MODE}" in
                    run)
                        RUN_BACKGROUND="true"
                        ;;
                    conc)
                        output_error "检测到 ${BLUE}$1${PLAIN} 为无效命令选项，该命令选项仅适用于普通执行！"
                        ;;
                    esac
                    ;;
                *)
                    output_error "检测到 ${BLUE}$1${PLAIN} 为无效命令选项，请确认后重新输入！"
                    ;;
                esac
                shift
            done
            ## 运行
            import task/run
            run_script "${RUN_MODE}" "${RUN_TARGET}"
            ;;
        cookie)
            case $2 in
            update | check | beans)
                case $3 in
                [1-9] | [1-9][0-9] | [1-9][0-9][0-9] | [1-9][0-9][0-9][0-9])
                    import task/account
                    accounts_control $2 $3
                    ;;
                *)
                    grep -Eq "Cookie[0-9]{1,3}=.*pt_pin=$3;.*" $FileConfUser
                    if [ $? -eq 0 ]; then
                        import task/account
                        accounts_control $2 $(grep -E "Cookie[0-9]{1,3}=.*pt_pin=$3;.*" $FileConfUser | awk -F '=' '{print$1}' | awk -F 'Cookie' '{print$2}')
                    else
                        output_command_error 1 # 命令错误
                    fi
                    ;;
                esac
                ;;
            *)
                output_command_error 1 # 命令错误
                ;;
            esac
            ;;
        notify)
            ## 自定义推送通知功能
            import_config_not_check
            send_notify "$2" "$3"
            ;;
        *)
            output_command_error 1 # 命令错误
            ;;
        esac
        ;;

    ## 多个参数
    *)
        case $1 in
        run | conc)
            RUN_MODE="${1}"
            shift
            RUN_TARGET="${1}"
            shift
            ## 判断命令选项
            while [ $# -gt 0 ]; do
                case "$1" in
                -l | --loop)
                    case "${RUN_MODE}" in
                    run)
                        if [[ "$2" ]]; then
                            echo "$2" | grep -Eq "[a-zA-Z,/\!@#$%^&*|\-_=\+]|\(|\)|\[|\]|\{|\}"
                            if [ $? -eq 0 ]; then
                                output_error "检测到无效命令选项值 ${BLUE}$2${PLAIN} ，语法有误请确认后重新输入！"
                            else
                                RUN_LOOP="true"
                                RUN_LOOP_TIMES="$2"
                                shift
                            fi
                        else
                            output_error "检测到 ${BLUE}$1${PLAIN} 为无效命令选项，请在该命令选项后指定循环次数！"
                        fi
                        ;;
                    conc)
                        output_error "检测到 ${BLUE}$1${PLAIN} 为无效命令选项，该命令选项仅适用于普通执行！"
                        ;;
                    esac
                    ;;
                -s | --silent)
                    RUN_SILENT="true"
                    ;;
                -w | --wait)
                    if [[ "$2" ]]; then
                        echo "$2" | grep -Eq "[abcefgijklnopqrtuvwxyzA-Z,/\!@#$%^&*|\-_=\+]|\(|\)|\[|\]|\{|\}"
                        if [ $? -eq 0 ]; then
                            output_error "检测到无效命令选项值 ${BLUE}$2${PLAIN} ，语法有误请确认后重新输入！"
                        else
                            RUN_WAIT="true"
                            RUN_WAIT_TIMES="$2"
                            shift
                        fi
                    else
                        output_error "检测到 ${BLUE}$1${PLAIN} 为无效命令选项，请在该命令选项后指定等待时间！"
                    fi
                    ;;
                -a | --agent)
                    RUN_GLOBAL_AGENT="true"
                    ;;
                -D | --delay)
                    RUN_DELAY="true"
                    ;;
                -T | --Timeout)
                    if [[ "$2" ]]; then
                        RUN_TIMEOUT="true"
                        TIMEOUT_OPTIONS="$2"
                        shift
                    else
                        output_error "检测到 ${BLUE}$1${PLAIN} 为无效命令选项，请在该命令选项后指定超时命令选项！"
                    fi
                    ;;
                -p | --proxy)
                    echo ${RUN_TARGET} | grep -Eq "https?://.*github"
                    if [ $? -eq 0 ]; then
                        DOWNLOAD_PROXY="true"
                    else
                        output_error "检测到 ${BLUE}$1${PLAIN} 为无效命令选项，该命令选项仅适用于执行位于 GitHub 仓库的脚本，请确认后重新输入！"
                    fi
                    ;;
                -d | --daemon)
                    case "${RUN_MODE}" in
                    run)
                        RUN_DAEMON="true"
                        ;;
                    conc)
                        output_error "检测到 ${BLUE}$1${PLAIN} 为无效命令选项，该命令选项仅适用于普通执行！"
                        ;;
                    esac
                    ;;
                -c | --cookie)
                    if [[ "$2" ]]; then
                        echo "$2" | grep -Eq "[a-zA-Z\.;:\<\>/\!@#$^&*|\-_=\+]|\(|\)|\[|\]|\{|\}"
                        if [ $? -eq 0 ]; then
                            output_error "检测到无效命令选项值 ${BLUE}$2${PLAIN} ，语法有误请确认后重新输入！"
                        else
                            if [[ ${RUN_GROUPING} == true ]]; then
                                output_error "检测到无效命令选项 ${BLUE}$1${PLAIN} ，不可与账号分组命令选项同时使用！"
                            else
                                RUN_DESIGNATED="true"
                                DESIGNATED_VALUE="$2"
                                shift
                            fi
                        fi
                    else
                        output_error "检测到 ${BLUE}$1${PLAIN} 为无效命令选项，请在该命令选项后指定运行账号！"
                    fi
                    ;;
                -g | --grouping)
                    case "${RUN_MODE}" in
                    run)
                        if [[ "$2" ]]; then
                            echo "$2" | grep -Eq "[a-zA-Z\.;:\<\>/\!#$^&*|\-_=\+]|\(|\)|\[|\]|\{|\}"
                            if [ $? -eq 0 ]; then
                                output_error "检测到无效命令选项值 ${BLUE}$2${PLAIN} ，语法有误请确认后重新输入！"
                            else
                                if [[ ${RUN_DESIGNATED} == true ]]; then
                                    output_error "检测到无效命令选项 ${BLUE}$1${PLAIN} ，不可与指定账号命令选项同时使用！"
                                else
                                    ## 判断是否已分组
                                    echo "$2" | grep -Eq "@"
                                    if [ $? -eq 0 ]; then
                                        RUN_GROUPING="true"
                                        GROUPING_VALUE="$2"
                                        shift
                                    else
                                        output_error "检测到无效命令选项值 ${BLUE}$2${PLAIN} ，请定义账号分组否则请使用指定账号命令选项！"
                                    fi
                                fi
                            fi
                        else
                            output_error "检测到 ${BLUE}$1${PLAIN} 为无效命令选项，请在该命令选项后指定账号运行分组！"
                        fi
                        ;;
                    conc)
                        output_error "检测到 ${BLUE}$1${PLAIN} 为无效命令选项，该命令选项仅适用于普通执行！"
                        ;;
                    esac
                    ;;
                -b | --background)
                    case "${RUN_MODE}" in
                    run)
                        RUN_BACKGROUND="true"
                        ;;
                    conc)
                        output_error "检测到 ${BLUE}$1${PLAIN} 为无效命令选项，该命令选项仅适用于普通执行！"
                        ;;
                    esac
                    ;;
                *)
                    output_error "检测到 ${BLUE}$1${PLAIN} 为无效命令选项，请确认后重新输入！"
                    ;;
                esac
                shift
            done
            ## 运行
            import task/run
            run_script "${RUN_MODE}" "${RUN_TARGET}"
            ;;
        *)
            output_command_error 1 # 命令错误
            ;;
        esac
        ;;
    esac
}

main "$@"
