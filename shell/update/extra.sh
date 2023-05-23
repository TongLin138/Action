#!/bin/bash
## Modified: 2023-05-23

## 自定义更新脚本
function UpdateExtra() {
    if [[ ${EnableExtraShell} = true || ${EnableExtraShellSync} = true ]]; then
        echo -e "-------------------------------------------------------------\n"
    fi
    ## 同步用户的 extra.sh
    if [[ $EnableExtraShellSync == true ]] && [[ $ExtraShellSyncUrl ]]; then
        echo -e "$WORKING 开始同步自定义更新脚本：$ExtraShellSyncUrl\n"
        wget -q --no-check-certificate $ExtraShellSyncUrl -O $FileExtra.new -T 20
        if [ $? -eq 0 ]; then
            mv -f "$FileExtra.new" "$FileExtra"
            echo -e "$COMPLETE 自定义更新脚本同步完成\n"
            sleep 1s
        else
            if [ -f $FileExtra ]; then
                echo -e "$FAIL 自定义更新脚本同步失败，保留之前的版本...\n"
            else
                echo -e "$FAIL 自定义更新脚本同步失败，请检查原因...\n"
            fi
            sleep 2s
        fi
        [ -f "$FileExtra.new" ] && rm -rf "$FileExtra.new"
    fi
    ## 执行用户的 extra.sh
    if [[ $EnableExtraShell == true ]]; then
        ## 执行
        if [ -f $FileExtra ]; then
            echo -e "$WORKING 开始执行自定义更新脚本：$FileExtra\n"
            . $FileExtra
            echo -e "\n$COMPLETE 自定义更新脚本执行完毕\n"
        else
            echo -e "$ERROR 自定义更新脚本不存在，跳过执行...\n"
        fi
    fi
}
