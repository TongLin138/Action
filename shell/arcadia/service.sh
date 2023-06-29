#!/bin/bash
## Modified: 2023-06-29

## 后端服务控制
# arcadia service start/restart/stop/info/respwd
function main_service_manage() {

    ## 更新源码
    function update_sourcecode() {
        local CurrentDir=$(pwd)
        cd $RootDir
        git fetch --all >/dev/null 2>&1
        git pull >/dev/null 2>&1
        git reset --hard origin/$(git status | head -n 1 | awk -F ' ' '{print$NF}') >/dev/null 2>&1
        cd $CurrentDir
    }

    ## 安装网页终端
    function install_ttyd() {
        [ ! -x /usr/bin/ttyd ] && apk --no-cache add -f ttyd
        ## 增加环境变量
        export PS1="\[\e[32;1m\]@Arcadia CLI\[\e[37;1m\] ➜\[\e[34;1m\]  \w\[\e[0m\] \\$ "
        pm2 start ttyd --name "web_terminal" --log-date-format "YYYY-MM-DD HH:mm:ss" -- \
            -p 7685 \
            -t rendererType=canvas \
            -t fontFamily='SF Mono, JetBrains Mono, Courier New, Consolas, monospace' \
            -t cursorBlink=true \
            -t fontSize=14 \
            -t lineHeight=1.5 \
            -t disableLeaveAlert=true \
            -t macOptionIsMeta=true \
            -t macOptionClickForcesSelection=true \
            bash
    }

    local ServiceStatus
    import arcadia/pm2
    pm2_list_all_services
    cat $FilePm2List | awk -F '|' '{print$3}' | grep "web_server" -wq
    local ExitStatusSERVER=$?
    cat $FilePm2List | awk -F '|' '{print$3}' | grep "web_terminal" -wq
    local ExitStatusTTYD=$?
    case $1 in
    ## 开启/重启服务
    start | restart)
        ## 禁用 Core Dump
        ulimit -c 0 >/dev/null 2>&1
        ## 删除日志
        rm -rf /root/.pm2/logs/web_server-*.log /root/.pm2/logs/inner_server-*.log /root/.pm2/logs/web_terminal-*.log
        if [[ ${ExitStatusSERVER} -eq 0 ]]; then
            local ServiceStatus=$(cat $FilePm2List | grep "web_server" -w | awk -F '|' '{print$10}')
            case ${ServiceStatus} in
            online)
                pm2 restart web_server
                pm2 restart inner_server >/dev/null 2>&1
                echo -e "\n$COMPLETE 后台管理面板已重启\n"
                ;;
            stopped)
                pm2 start web_server
                pm2 start inner_server >/dev/null 2>&1
                echo -e "\n$COMPLETE 后台管理面板已重新启动\n"
                ;;
            errored)
                echo -e "\n$WARN 检测到服务状态异常，开始尝试修复...\n"
                pm2 delete web_server
                pm2 delete inner_server >/dev/null 2>&1
                update_sourcecode
                cd $PanelDir
                npm install
                pm2 start ecosystem.config.js && sleep 3
                pm2_list_all_services
                local ServiceNewStatus=$(cat $FilePm2List | grep "web_server" -w | awk -F '|' '{print$10}')
                if [[ "${ServiceNewStatus}" == "online" ]]; then
                    echo -e "\n$SUCCESS 已修复错误，服务恢复正常运行！\n"
                else
                    echo -e "\n$FAIL 未能自动修复错误，请检查原因后重试！\n"
                fi
                ;;
            esac
        else
            update_sourcecode
            cd $PanelDir
            npm install
            pm2 start ecosystem.config.js && sleep 1
            pm2_list_all_services
            local ServiceStatus=$(cat $FilePm2List | grep "web_server" -w | awk -F '|' '{print$10}')
            if [[ ${ServiceStatus} == "online" ]]; then
                echo -e "\n$SUCCESS 后台管理面板已启动\n"
            else
                echo -e "\n$FAIL 后台管理面板启动失败，请检查原因后重试！\n"
            fi
        fi
        if [[ ${ExitStatusTTYD} -eq 0 ]]; then
            ServiceStatus=$(pm2 describe web_terminal | grep status | awk '{print $4}')
            case ${ServiceStatus} in
            online)
                pm2 restart web_terminal
                echo -e "\n$COMPLETE 网页终端已重启\n"
                ;;
            stopped)
                pm2 start web_terminal
                echo -e "\n$COMPLETE 网页终端已重新启动\n"
                ;;
            errored)
                echo -e "\n$WARN 检测到服务状态异常，开始尝试修复...\n"
                pm2 delete web_terminal
                update_sourcecode
                cd $RootDir
                install_ttyd && sleep 3
                pm2_list_all_services
                local ServiceNewStatus=$(cat $FilePm2List | grep "web_terminal" -w | awk -F '|' '{print$10}')
                if [[ "${ServiceNewStatus}" == "online" ]]; then
                    echo -e "\n$SUCCESS 已修复错误，服务恢复正常运行！\n"
                else
                    echo -e "\n$FAIL 未能自动修复错误，请检查原因后重试！\n"
                fi
                ;;
            esac
        else
            update_sourcecode
            cd $RootDir
            install_ttyd && sleep 1
            pm2_list_all_services
            local ServiceStatus=$(cat $FilePm2List | grep "web_terminal" -w | awk -F '|' '{print$10}')
            if [[ ${ServiceStatus} == "online" ]]; then
                echo -e "\n$SUCCESS 网页终端已启动\n"
            else
                echo -e "\n$FAIL 网页终端启动失败，请检查原因后重试！\n"
            fi
        fi
        ;;
    ## 关闭服务
    stop)
        if [[ ${ExitStatusSERVER} -eq 0 ]]; then
            pm2 stop web_server >/dev/null 2>&1
            if [[ ${ExitStatusTTYD} -eq 0 ]]; then
                pm2 stop web_terminal >/dev/null 2>&1
            fi
            pm2 list
            echo -e "\n$COMPLETE 后台管理面板和网页终端已关闭\n"
        else
            echo -e "\n$ERROR 服务不存在！\n"
        fi
        ;;
    ## 登录信息
    info)
        if [ ! -f $FileAuthUser ]; then
            cp -f $FileAuthSample $FileAuthUser
        fi
        echo ''
        jq '.' $FileAuthUser | perl -pe '{s|\"user\"|[用户名]|g; s|\"password\"|[密码]|g; s|\"openApiToken\"|[openApiToken]|g; s|\"lastLoginInfo\"|\n    最后一次登录信息|g; s|\"loginIp\"|[ IP 地址]|g; s|\"loginAddress\"|[地理位置]|g; s|\"loginTime\"|[登录时间]|g; s|\"authErrorCount\"|[认证失败次数]|g; s|[{},"]||g;}'
        echo -e '\n'
        ;;
    ## 重置密码
    respwd)
        cp -f $FileAuthSample $FileAuthUser
        echo -e "\n$COMPLETE 已重置后台管理面板用于登录认证的用户名和登录密码\n\n[用户名]： useradmin\n[密  码]： passwd\n"
        ;;
    esac
    ## 删除 PM2 进程日志清单
    [ -f $FilePm2List ] && rm -rf $FilePm2List
}

## 列出各服务状态
function server_status() {
    local Services ServiceName StatusJudge Status CreateTime CPUOccupancy MemoryOccupancy RunTime
    local SERVICE_ONLINE="${GREEN}正在运行${PLAIN}"
    local SERVICE_STOPPED="${YELLOW}未在运行${PLAIN}"
    local SERVICE_ERRORED="${RED}服务异常${PLAIN}"
    echo ''
    pm2 list
    echo ''
    import arcadia/pm2
    pm2_list_all_services
    Services="web_server web_terminal tgbot"
    for Name in ${Services}; do
        ServiceName=''
        StatusJudge=''
        Status=''
        CreateTime=''
        CPUOccupancy=''
        MemoryOccupancy=''
        RunTime=''
        cat $FilePm2List | awk -F '|' '{print$3}' | grep ${Name} -wq
        if [ $? -eq 0 ]; then
            StatusJudge=$(cat $FilePm2List | grep ${Name} | awk -F '|' '{print $10}')
            case $StatusJudge in
            online)
                Status=$SERVICE_ONLINE
                ;;
            stopped)
                Status=$SERVICE_STOPPED
                ;;
            errored)
                Status=$SERVICE_ERRORED
                ;;
            esac
            CreateTime="${BLUE}$(date --date "$(pm2 describe ${Name} | grep "created at" | awk '{print $5}')")${PLAIN}"
            CPUOccupancy="${BLUE}$(cat $FilePm2List | grep ${Name} | awk -F '|' '{print $11}')${PLAIN}"
            MemoryOccupancy="${BLUE}$(cat $FilePm2List | grep ${Name} | awk -F '|' '{print $12}')${PLAIN}"
            RunTime="${BLUE}$(cat $FilePm2List | grep ${Name} | awk -F '|' '{print $8}')${PLAIN}"
        else
            Status=$SERVICE_STOPPED
            CreateTime="${BLUE}          No Data           ${PLAIN}"
            CPUOccupancy="${BLUE}No Data${PLAIN}"
            MemoryOccupancy="${BLUE}No Data${PLAIN}"
            RunTime="${BLUE}No Data${PLAIN}"
        fi
        case ${Name} in
        web_server)
            ServiceName="[后  端  服  务]"
            ;;
        web_terminal)
            ServiceName="[网ㅤ页ㅤ终ㅤ端]"
            ;;
        tgbot)
            ServiceName="[ Telegram Bot ]"
            ;;
        esac
        echo -e " $ServiceName：$Status       [创建时间]：$CreateTime       [资源占用]：$CPUOccupancy / $MemoryOccupancy / $RunTime"
    done
    ## 删除 PM2 进程日志清单
    [ -f $FilePm2List ] && rm -rf $FilePm2List
    echo ''
}
