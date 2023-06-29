#!/bin/bash
## Modified: 2023-06-29

## 统计数量
function count_usersum() {
    UserSum=0
    for ((i = 1; i <= 0x2710; i++)); do
        local Tmp=Cookie$i
        local CookieTmp=${!Tmp}
        [[ ${CookieTmp} ]] && UserSum=$i || break
    done
}

## 随机延迟
function random_delay() {
    if [[ -n ${RandomDelay} ]] && [[ ${RandomDelay} -gt 0 ]]; then
        local current_delay=$((${RANDOM} % ${RandomDelay} + 1))
        echo -en "\n$WORKING 已启用随机延迟，此任务将在 ${BLUE}${current_delay}${PLAIN} 秒后开始运行..."
        sleep ${current_delay}
    fi
}

## 推迟执行
function wait_before_run() {
    local FormatPrint
    echo ${RUN_WAIT_TIMES} | grep -E "\.[smd]$|\.$"
    if [ $? -eq 0 ]; then
        output_error "等待时间值格式有误！"
    fi
    Tmp=$(echo ${RUN_WAIT_TIMES} | perl -pe '{s|[smd]||g}')
    case ${RUN_WAIT_TIMES:0-1} in
    s)
        FormatPrint=" ${BLUE}${Tmp}${PLAIN} 秒"
        ;;
    m)
        FormatPrint=" ${BLUE}${Tmp}${PLAIN} 分"
        ;;
    d)
        FormatPrint=" ${BLUE}${Tmp}${PLAIN} 天"
        ;;
    *)
        FormatPrint=" ${BLUE}${Tmp}${PLAIN} 秒"
        ;;
    esac
    echo -en "\n$WORKING 此任务将在 ${BLUE}${FormatPrint}${PLAIN} 后开始运行..."
    sleep ${RUN_WAIT_TIMES}
    echo ''
}

## 判定账号是否存在
function account_existence_judgment() {
    local Num=$1
    local Tmp=Cookie$Num
    if [[ -z ${!Tmp} ]]; then
        output_error "账号 ${BLUE}$Num${PLAIN} 不存在，请重新确认！"
    fi
}

## 判断账号区间语法合法性
function check_accounts_range_format() {
    local String=$1
    if [[ $(echo "${String}" | grep -o "-" | wc -l) -ge 2 ]]; then
        output_error "账号区间语法有误，检测到无效参数值 ${BLUE}${String}${PLAIN} ，存在多个 ${BLUE}-${PLAIN} 连接符！"
    elif [[ $(echo "${String}" | grep -o "%" | wc -l) -ge 2 ]]; then
        output_error "账号区间语法有误，检测到无效参数值 ${BLUE}${String}${PLAIN} ，存在多个 ${BLUE}%${PLAIN} 账号总数代符！"
    fi
}

## 静默执行，不推送通知消息
function no_send_notify() {
    ## Server酱
    export PUSH_KEY=""
    export SCKEY_WECOM=""
    export SCKEY_WECOM_URL=""
    ## Bark
    export BARK_PUSH=""
    export BARK_SOUND=""
    export BARK_GROUP=""
    ## Telegram
    export TG_BOT_TOKEN=""
    export TG_USER_ID=""
    ## 钉钉
    export DD_BOT_TOKEN=""
    export DD_BOT_SECRET=""
    ## 企业微信
    export QYWX_KEY=""
    export QYWX_AM=""
    ## iGot聚合
    export IGOT_PUSH_KEY=""
    ## pushplus
    export PUSH_PLUS_TOKEN=""
    export PUSH_PLUS_USER=""
    ## go-cqhttp
    export GO_CQHTTP_URL=""
    export GO_CQHTTP_QQ=""
    export GO_CQHTTP_METHOD=""
    export GO_CQHTTP_SCRIPTS=""
    export GO_CQHTTP_LINK=""
    export GO_CQHTTP_MSG_SIZE=""
    export GO_CQHTTP_EXPIRE_SEND_PRIVATE=""
    ## WxPusher
    export WP_APP_TOKEN=""
    export WP_UIDS=""
    export WP_TOPICIDS=""
    export WP_URL=""
}

## 普通执行
function run_normal() {
    local UserNum LogFile
    ## 统计账号数量
    count_usersum
    ## 静默运行
    [[ ${RUN_SILENT} == true ]] && no_send_notify

    ## 运行主命令
    function run_normal_main() {
        local cmd global_proxy_cmd
        if [[ "${EnableGlobalProxy}" == true ]]; then
            global_proxy_cmd="-r 'global-agent/bootstrap' "
        else
            global_proxy_cmd=""
        fi
        if [[ ${RUN_BACKGROUND} == true ]]; then
            ## 记录执行开始时间
            echo -e "[$(date "${TIME_FORMAT}" | cut -c1-23)] 执行开始，后台运行不记录结束时间\n" >>${LogFile}
            case "${FileFormat}" in
            JavaScript)
                cmd="node ${global_proxy_cmd}${FileName}.js 2>&1 &>>${LogFile} &"
                ;;
            Python)
                cmd="python3 -u ${FileName}.py 2>&1 &>>${LogFile} &"
                ;;
            TypeScript)
                cmd="ts-node-transpile-only ${global_proxy_cmd}${FileName}.ts 2>&1 &>>${LogFile} &"
                ;;
            Shell)
                cmd="bash ${FileName}.sh 2>&1 &>>${LogFile} &"
                ;;
            esac
            if [[ "${RUN_TIMEOUT}" == true ]]; then
                timeout ${TIMEOUT_OPTIONS} bash -c "${cmd}"
            else
                bash -c "${cmd}"
            fi
            echo -e "\n$COMPLETE 已部署当前任务并于后台运行中，如需查询脚本运行记录请前往 ${BLUE}${LogPath:4}${PLAIN} 目录查看最新日志\n"
        else
            ## 记录执行开始时间
            local starttime=$(date +'%Y-%m-%d %H:%M:%S')
            echo -e "[$(date "${TIME_FORMAT}" | cut -c1-23)] 执行开始\n" >>${LogFile}
            case "${FileFormat}" in
            JavaScript)
                cmd="node ${global_proxy_cmd}${FileName}.js 2>&1 | tee -a ${LogFile}"
                ;;
            Python)
                cmd="python3 -u ${FileName}.py 2>&1 | tee -a ${LogFile}"
                ;;
            TypeScript)
                cmd="ts-node-transpile-only ${global_proxy_cmd}${FileName}.ts 2>&1 | tee -a ${LogFile}"
                ;;
            Shell)
                cmd="bash ${FileName}.sh 2>&1 | tee -a ${LogFile}"
                ;;
            esac
            if [[ "${RUN_TIMEOUT}" == true ]]; then
                timeout ${TIMEOUT_OPTIONS} bash -c "${cmd}"
            else
                bash -c "${cmd}"
            fi
            ## 记录执行结束时间
            local endtime=$(date +'%Y-%m-%d %H:%M:%S')
            local start_seconds=$(date --date="$starttime" +%s)
            local end_seconds=$(date --date="$endtime" +%s)
            echo -e "\n[$(date "${TIME_FORMAT}" | cut -c1-23)] 执行结束，总用时 $((end_seconds - start_seconds)) 秒" >>${LogFile}
        fi
    }

    ## 组合账号变量
    function combin_designated_cookie() {
        local Num="$1"
        local Tmp1=Cookie$Num
        local Tmp2=${!Tmp1}
        local CombinAll="${COOKIE_TMP}&${Tmp2}"
        COOKIE_TMP=$(echo $CombinAll | sed "s|^&||g")
    }

    ## 指定运行账号
    function designated_account() {
        local AccountsTmp="$1"
        for UserNum in ${AccountsTmp}; do
            echo "${UserNum}" | grep "-" -q
            if [ $? -eq 0 ]; then
                ## 格式检测
                check_accounts_range_format "${UserNum}"
                if [[ ${UserNum%-*} -lt ${UserNum##*-} ]]; then
                    for ((i = ${UserNum%-*}; i <= ${UserNum##*-}; i++)); do
                        ## 判定账号是否存在
                        account_existence_judgment $i
                        combin_designated_cookie $i
                    done
                else
                    output_error "检测到无效参数值 ${BLUE}${UserNum}${PLAIN} ，账号区间语法有误，请重新输入！"
                fi
            else
                ## 判定账号是否存在
                account_existence_judgment $UserNum
                combin_designated_cookie $UserNum
            fi
        done
        ## 声明变量
        export JD_COOKIE=${COOKIE_TMP}
    }

    ## 后台挂起（守护进程）
    function daemon_process() {
        pm2 list | sed "/─/d" | sed "s| ||g; s#│#|#g" | sed "1d" >$FilePm2List
        cat $FilePm2List | awk -F '|' '{print$3}' | grep $FileName -wq
        EXITSTATUS=$?
        ## 删除原有
        pm2 stop $FileName >/dev/null 2>&1
        pm2 flush >/dev/null 2>&1
        pm2 delete $FileName >/dev/null 2>&1
        ## 启用
        echo -e "[$(date "${TIME_FORMAT}" | cut -c1-23)] 守护进程启动\n" >>${LogFile}
        case "${FileFormat}" in
        JavaScript)
            pm2 start "${FileName}.${FileSuffix}" --name "$FileName" --watch --log ${LogFile}
            ;;
        Python)
            pm2 start "${FileName}.${FileSuffix}" --interpreter /usr/bin/python3 --log ${LogFile} -- -u
            ;;
        TypeScript)
            pm2 start "${FileName}.${FileSuffix}" --interpreter /usr/bin/ts-node-transpile-only --name "$FileName" --log ${LogFile}
            ;;
        Shell)
            pm2 start "${FileName}.${FileSuffix}" --interpreter bash --name "$FileName" --log ${LogFile}
            ;;
        esac
        if [[ $EXITSTATUS -eq 0 ]]; then
            echo -e "\n$COMPLETE 已重启 ${BLUE}$FileName${PLAIN} 守护进程，日志位于 ${BLUE}${LogFile}${PLAIN}\n"
        else
            echo -e "\n$SUCCESS 已启动 ${BLUE}$FileName${PLAIN} 守护进程，日志位于 ${BLUE}${LogFile}${PLAIN}\n"
        fi
        ## 删除 PM2 进程日志清单
        [ -f $FilePm2List ] && rm -rf $FilePm2List
    }

    ## 加载全部账号
    function combin_all_cookie() {
        local What_Combine=Cookie
        local CombinAll=""
        local Tmp1 Tmp2 i
        ## 全局屏蔽
        grep "^TempBlockCookie=" $FileConfUser -q 2>/dev/null
        if [ $? -eq 0 ]; then
            local GlobalBlockCookie=$(grep "^TempBlockCookie=" $FileConfUser | head -n 1 | awk -F "[\"\']" '{print$2}')
        fi
        for ((i = 0x1; i <= ${UserSum}; i++)); do
            ## 跳过全局屏蔽的账号
            if [[ ${GlobalBlockCookie} ]]; then
                for num1 in ${GlobalBlockCookie}; do
                    if [[ $i -eq $num1 ]]; then
                        continue 2
                    else
                        grep "^Cookie$i=[\"\'].*pt_pin=${num1};.*[\"\']" $FileConfUser -q 2>/dev/null
                        [ $? -eq 0 ] && continue 2
                    fi
                done
            fi
            ## 跳过临时屏蔽的账号
            for num2 in ${TempBlockCookie}; do
                if [[ $i -eq $num2 ]]; then
                    continue 2
                else
                    grep "^Cookie$i=[\"\'].*pt_pin=${num2};.*[\"\']" $FileConfUser -q 2>/dev/null
                    [ $? -eq 0 ] && continue 2
                fi
            done
            Tmp1=$What_Combine$i
            Tmp2=${!Tmp1}
            CombinAll="${CombinAll}&${Tmp2}"
        done
        export JD_COOKIE="$(echo $CombinAll | sed "s|^&||g; s|^@+||g; s|&@|&|g; s|@+&|&|g; s|@+|@|g; s|@+$||g")"

    }

    ## 脚本代理
    if [[ ${RUN_GLOBAL_AGENT} == true ]]; then
        if [[ "${FileFormat}" == "JavaScript" || "${FileFormat}" == "TypeScript" ]]; then
            EnableGlobalProxy="true"
        else
            output_error "检测到无效参数 ${BLUE}--agent${PLAIN} ，仅支持运行 JavaScript 和 TypeScript 类型的脚本！"
        fi
    fi

    ## 进入脚本所在目录
    cd ${FileDir}
    ## 定义日志文件路径
    LogFile="${LogPath}/$(date "+%Y-%m-%d-%H-%M-%S").log"

    ## 账号分组
    if [[ ${RUN_GROUPING} == true ]]; then
        ## 定义分组
        local Groups=$(echo ${GROUPING_VALUE} | sed "s|@| |g")
        for group in ${Groups}; do
            local Accounts=$(echo "${group}" | sed "s|%|${UserSum}|g; s|,| |g")
            designated_account "${Accounts}"

            ## 判断循环运行次数
            [[ ${RUN_LOOP} == true ]] && RunTimes=$(($RUN_LOOP_TIMES + 1))
            ## 执行脚本
            for ((i = 1; i <= ${RunTimes:-"1"}; i++)); do
                ## 随机延迟
                [[ ${RUN_DELAY} == true ]] && random_delay
                ## 推迟执行
                [[ ${RUN_WAIT} == true ]] && wait_before_run
                ## 运行
                if [[ ${RUN_DAEMON} == true ]]; then
                    ## 后台挂起（守护进程）
                    daemon_process
                else
                    run_normal_main
                fi
            done

            ## 账号分组清空变量重新组合
            COOKIE_TMP=""
        done
    else
        ## 指定账号
        if [[ ${RUN_DESIGNATED} == true ]]; then
            local Accounts=$(echo ${DESIGNATED_VALUE} | sed "s|%|${UserSum}|g; s|,| |g")
            designated_account "${Accounts}"
        else
            ## 加载全部账号
            combin_all_cookie
        fi

        ## 判断循环运行次数
        [[ ${RUN_LOOP} == true ]] && RunTimes=$(($RUN_LOOP_TIMES + 1))
        ## 执行脚本
        for ((i = 1; i <= ${RunTimes:-"1"}; i++)); do
            ## 随机延迟
            [[ ${RUN_DELAY} == true ]] && random_delay
            ## 推迟执行
            [[ ${RUN_WAIT} == true ]] && wait_before_run
            ## 运行
            if [[ ${RUN_DAEMON} == true ]]; then
                ## 后台挂起（守护进程）
                daemon_process
            else
                run_normal_main
            fi
        done
    fi

    ## 判断远程脚本执行后是否删除
    if [[ ${RUN_REMOTE} == true && ${AutoDelRawFiles} == true ]]; then
        rm -rf "${FileDir}/${FileName}.${FileSuffix}"
    fi
}

## 并发执行
function run_concurrent() {
    local UserNum LogFile
    ## 统计账号数量
    count_usersum
    ## 静默运行参数
    [[ ${RUN_SILENT} == true ]] && no_send_notify

    ## 运行主命令
    function run_concurrent_main() {
        local Num=$1
        local Tmp=Cookie${Num}
        export JD_COOKIE=${!Tmp}
        ## 定义日志文件路径
        LogFile="${LogPath}/$(date "+%Y-%m-%d-%H-%M-%S")_${Num}.log"
        ## 记录执行开始时间
        echo -e "[$(date "${TIME_FORMAT}" | cut -c1-23)] 执行开始，后台运行不记录结束时间\n" >>${LogFile}
        ## 执行脚本
        local cmd global_proxy_cmd
        if [[ "${EnableGlobalProxy}" == true ]]; then
            global_proxy_cmd=" -r 'global-agent/bootstrap'"
        else
            global_proxy_cmd=""
        fi
        case "${FileFormat}" in
        JavaScript)
            cmd="node ${global_proxy_cmd}${FileName}.js 2>&1 &>>${LogFile} &"
            ;;
        Python)
            cmd="python3 -u ${FileName}.py 2>&1 &>>${LogFile} &"
            ;;
        TypeScript)
            cmd="ts-node-transpile-only ${global_proxy_cmd}${FileName}.ts 2>&1 &>>${LogFile} &"
            ;;
        Shell)
            cmd="bash ${FileName}.sh 2>&1 &>>${LogFile} &"
            ;;
        esac
        if [[ "${RUN_TIMEOUT}" == true ]]; then
            timeout ${TIMEOUT_OPTIONS} bash -c "${cmd}"
        else
            bash -c "${cmd}"
        fi
    }

    ## 脚本代理
    if [[ ${RUN_GLOBAL_AGENT} == true ]]; then
        if [[ "${FileFormat}" == "JavaScript" || "${FileFormat}" == "TypeScript" ]]; then
            EnableGlobalProxy="true"
        else
            output_error "检测到无效参数 ${BLUE}--agent${PLAIN} ，仅支持运行 JavaScript 和 TypeScript 类型的脚本！"
        fi
    fi

    ## 进入脚本所在目录
    cd ${FileDir}
    ## 随机延迟
    [[ ${RUN_DELAY} == true ]] && random_delay
    ## 推迟执行
    [[ ${RUN_WAIT} == true ]] && wait_before_run

    ## 加载账号并执行
    if [[ ${RUN_DESIGNATED} == true ]]; then
        ## 判定账号是否存在
        local Accounts=$(echo ${DESIGNATED_VALUE} | sed "s|%|${UserSum}|g; s|,| |g")
        for UserNum in ${Accounts}; do
            echo "${UserNum}" | grep "-" -q
            if [ $? -eq 0 ]; then
                ## 格式检测
                check_accounts_range_format "${UserNum}"
                if [[ ${UserNum%-*} -lt ${UserNum##*-} ]]; then
                    for ((i = ${UserNum%-*}; i <= ${UserNum##*-}; i++)); do
                        ## 判定账号是否存在
                        account_existence_judgment $i
                    done
                else
                    output_error "检测到无效参数值 ${BLUE}${UserNum}${PLAIN} ，账号区间语法有误，请重新输入！"
                fi
            else
                ## 判定账号是否存在
                account_existence_judgment $UserNum
            fi
        done

        ## 指定运行账号
        for UserNum in ${Accounts}; do
            echo "${UserNum}" | grep "-" -q
            if [ $? -eq 0 ]; then
                for ((i = ${UserNum%-*}; i <= ${UserNum##*-}; i++)); do
                    ## 执行脚本
                    run_concurrent_main $i
                done
            else
                ## 执行脚本
                run_concurrent_main ${UserNum}
            fi
        done
    else
        ## 加载全部账号
        # 全局屏蔽
        grep "^TempBlockCookie=" $FileConfUser -q 2>/dev/null
        if [ $? -eq 0 ]; then
            local GlobalBlockCookie=$(grep "^TempBlockCookie=" $FileConfUser | awk -F "[\"\']" '{print$2}')
        fi
        for ((UserNum = 1; UserNum <= ${UserSum}; UserNum++)); do
            if [[ ${GlobalBlockCookie} ]]; then
                for num1 in ${GlobalBlockCookie}; do
                    [[ $i -eq $num1 ]] && continue 2
                done
            fi
            for num in ${TempBlockCookie}; do
                [[ $UserNum -eq $num ]] && continue 2
            done
            ## 执行脚本
            run_concurrent_main ${UserNum}
        done
    fi
    echo -e "\n$COMPLETE 已部署当前任务并于后台运行中，如需查询脚本运行记录请前往 ${BLUE}${LogPath:4}${PLAIN} 目录查看相关日志\n"

    ## 判断远程脚本执行后是否删除
    if [[ ${RUN_REMOTE} == true && ${AutoDelRawFiles} == true ]]; then
        rm -rf "${FileDir}/${FileName}.${FileSuffix}"
    fi
}

function run_script() {
    RUN_MODE="${1}"
    ## 匹配脚本
    import task/script
    find_script "${2}"
    ## 导入配置文件
    import_config ${FileName}
    # task_before.sh
    if [[ "${EnableTaskBeforeExtra}" == true ]]; then
        if [ -f $FileTaskBeforeExtra ]; then
            source $FileTaskBeforeExtra
        fi
    fi
    ## 禁用 Core Dump
    ulimit -c 0 >/dev/null 2>&1
    case "${RUN_MODE}" in
    run)
        run_normal
        ;;
    conc)
        run_concurrent
        ;;
    esac
    # task_after.sh
    if [[ "${EnableTaskAfterExtra}" == true ]]; then
        if [ -f $FileTaskAfterExtra ]; then
            source $FileTaskAfterExtra
        fi
    fi
}
