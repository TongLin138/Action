#!/bin/bash
## Modified: 2023-08-15

## Telegram Bot 功能
# arcadia tgbot start/stop/logs/update
function tgbot_manage() {

    ## 安装 Telegram Bot
    function install_main() {
        ## 检测配置文件是否存在
        if [ ! -s $ConfigDir/bot.json ]; then
            cp -fv $SampleDir/bot.json $ConfigDir/bot.json
        fi
        make_dir $BotLogDir
        ## 安装模块
        echo -e "$WORKING 开始安装模块...\n"
        cp -rf $BotSrcDir/tgbot $RootDir
        cd $BotDir
        pip3 --default-timeout=3600 install -r requirements.txt --no-cache-dir
        if [ $? -eq 0 ]; then
            echo -e "\n$COMPLETE 模块安装完成\n"
        else
            echo -e "\n$FAIL 模块安装失败，请检查原因后重试！\n"
        fi
    }

    ## 卸载
    function remove_src() {
        echo -e "\n$WORKING 开始卸载...\n"
        [ -f $BotDir/requirements.txt ] && pip3 uninstall -y -r $BotDir/requirements.txt
        rm -rf $BotDir/* $RootDir/bot.session*
        echo -e "\n$COMPLETE 卸载完成"
    }

    ## 备份用户的脚本
    function backup_user_scripts() {
        local UserFiles=($(
            ls $BotDir/diy 2>/dev/null | grep -Ev "__pycache__|example.py"
        ))
        if [ ${#UserFiles[@]} -gt 0 ]; then
            make_dir $RootDir/tmp
            for ((i = 0; i < ${#UserFiles[*]}; i++)); do
                mv -f $BotDir/diy/${UserFiles[i]} $RootDir/tmp
            done
        fi
    }

    import_config_not_check
    import arcadia/pm2
    case ${ARCH} in
    armv7l | armv6l)
        output_error "宿主机的处理器架构不支持使用此功能，建议更换运行环境！"
        ;;
    *)
        if [[ -z $(grep -E "123456789" $ConfigDir/bot.json) ]]; then
            pm2_list_all_services
            cat $FilePm2List | awk -F '|' '{print$3}' | grep "tgbot" -wq
            local ExitStatustgbot=$?
            case $1 in
            ## 开启/重启服务
            start | restart)
                ## 删除日志
                rm -rf $BotLogDir/up.log /root/.pm2/logs/tgbot-*.log
                if [[ ${ExitStatustgbot} -eq 0 ]]; then
                    local ServiceStatus=$(cat $FilePm2List | grep "tgbot" -w | awk -F '|' '{print$10}')
                    case ${ServiceStatus} in
                    online)
                        pm2 delete tgbot >/dev/null 2>&1
                        ## 启动 bot
                        cd $BotDir && pm2 start ecosystem.config.js && sleep 1
                        pm2_list_all_services
                        local ServiceNewStatus=$(cat $FilePm2List | grep "tgbot" -w | awk -F '|' '{print$10}')
                        if [[ "${ServiceNewStatus}" == "online" ]]; then
                            echo -e "\n$COMPLETE 电报机器人已重启\n"
                        else
                            echo -e "\n$FAIL 重启失败，请检查原因后重试！\n"
                        fi
                        ;;
                    stopped)
                        pm2 start tgbot
                        pm2_list_all_services
                        local ServiceNewStatus=$(cat $FilePm2List | grep "tgbot" -w | awk -F '|' '{print$10}')
                        if [[ "${ServiceNewStatus}" == "online" ]]; then
                            echo -e "\n$COMPLETE 电报机器人已重新启动\n"
                        else
                            echo -e "\n$FAIL 启动失败，请检查原因后重试！\n"
                        fi
                        ;;
                    errored)
                        echo -e "\n$WARN 检测到服务状态异常，开始尝试修复...\n"
                        pm2 delete tgbot >/dev/null 2>&1
                        ## 恢复用户插件
                        if [ -d $BotDir ]; then
                            backup_user_scripts
                            [ ! -x /usr/bin/python3 ] && remove_src
                            install_main
                            if [[ -d $RootDir/tmp ]]; then
                                mv -f $RootDir/tmp/* $BotSrcDir/tgbot/diy
                                rm -rf $RootDir/tmp
                            fi
                        else
                            install_main
                        fi
                        cp -rf $BotSrcDir/tgbot $RootDir
                        ## 启动 bot
                        cd $BotDir && pm2 start ecosystem.config.js && sleep 1
                        pm2_list_all_services
                        local ServiceNewStatus=$(cat $FilePm2List | grep "tgbot" -w | awk -F '|' '{print$10}')
                        if [[ "${ServiceNewStatus}" == "online" ]]; then
                            echo -e "\n$SUCCESS 已修复错误，服务恢复正常运行！\n"
                        else
                            echo -e "\n$FAIL 未能自动修复错误，请检查原因后重试！\n"
                        fi
                        ;;
                    esac
                else
                    ## 恢复用户插件
                    if [ -d $BotDir ]; then
                        backup_user_scripts
                        [ ! -x /usr/bin/python3 ] && remove_src
                        install_main
                        if [[ -d $RootDir/tmp ]]; then
                            mv -f $RootDir/tmp/* $BotSrcDir/tgbot/diy
                            rm -rf $RootDir/tmp
                        fi
                    else
                        install_main
                    fi
                    cp -rf $BotSrcDir/tgbot $RootDir
                    ## 启动 bot
                    cd $BotDir && pm2 start ecosystem.config.js && sleep 1
                    local ServiceStatus=$(pm2 describe tgbot | grep status | awk '{print $4}')
                    if [[ ${ServiceStatus} == "online" ]]; then
                        echo -e "\n$SUCCESS 电报机器人已启动\n"
                    else
                        echo -e "\n$FAIL 电报机器人启动失败，请检查原因后重试！\n"
                    fi
                fi
                ;;

            ## 关闭服务
            stop)
                if [[ ${ExitStatustgbot} -eq 0 ]]; then
                    pm2 stop tgbot >/dev/null 2>&1
                    pm2 list
                    echo -e "\n$COMPLETE 电报机器人已停止\n"
                else
                    echo -e "\n$ERROR 服务不存在！\n"
                fi
                ;;

            ## 更新
            update)
                if [[ ${ExitStatustgbot} -eq 0 ]]; then
                    pm2 delete tgbot >/dev/null 2>&1
                    ## 删除日志
                    rm -rf $BotLogDir/up.log
                    ## 保存用户的脚本
                    if [ -d $BotDir ]; then
                        backup_user_scripts
                        [ ! -x /usr/bin/python3 ] && remove_src
                        install_main
                        if [[ -d $RootDir/tmp ]]; then
                            mv -f $RootDir/tmp/* $BotSrcDir/tgbot/diy
                            rm -rf $RootDir/tmp
                        fi
                    else
                        install_main
                    fi
                    cp -rf $BotSrcDir/tgbot $RootDir
                    ## 启动 bot
                    cd $BotDir && pm2 start ecosystem.config.js && sleep 1
                    local ServiceStatus=$(pm2 describe tgbot | grep status | awk '{print $4}')
                    if [[ ${ServiceStatus} == "online" ]]; then
                        echo -e "\n$SUCCESS 电报机器人已更新至最新版本\n"
                    else
                        echo -e "\n$FAIL 电报机器人更新后启动异常，请检查原因后重试！\n"
                    fi
                else
                    output_error "请先启动您的 Bot ！"
                fi
                ;;

            ## 查看日志
            logs)
                if [[ -f $BotLogDir/run.log ]]; then
                    echo ''
                    cat $BotLogDir/run.log | tail -n 200
                    echo ''
                else
                    echo -e "\n$ERROR 日志不存在！\n"
                fi
                ;;
            esac
            ## 删除 PM2 进程日志清单
            [ -f $FilePm2List ] && rm -rf $FilePm2List
        else
            output_error "请先在 $ConfigDir/bot.json 中配置好您的 Bot ！"
        fi
        ;;
    esac
}
