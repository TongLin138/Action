#!/bin/bash
## Modified: 2023-05-23

## 更新项目源码
function Update_SourceCode() {
    ## 检测配置文件版本
    function Detect_Config_Version() {
        ## 识别出两个文件的版本号
        VerConfSample=$(grep " Version: " $FileConfSample | perl -pe "s|.+v((\d+\.?){3})|\1|")
        [ -f $FileConfUser ] && VerConfUser=$(grep " Version: " $FileConfUser | perl -pe "s|.+v((\d+\.?){3})|\1|")
        ## 删除旧的发送记录文件
        [ -f $FileSendMark ] && [[ $(cat $FileSendMark) != $VerConfSample ]] && rm -f $FileSendMark
        ## 识别出更新日期和更新内容
        UpdateDate=$(grep " Date: " $FileConfSample | awk -F ": " '{print $2}')
        UpdateContent=$(grep " Update Content: " $FileConfSample | awk -F ": " '{print $2}' | sed "s/[0-9]\./\\\n&/g")
        ## 如果是今天，并且版本号不一致，则发送通知
        if [ -f $FileConfUser ] && [[ $VerConfUser != $VerConfSample ]] && [[ $UpdateDate == $(date "+%Y-%m-%d") ]]; then
            if [ ! -f $FileSendMark ]; then
                local NotifyTitle="配置文件更新通知"
                local NotifyContent="更新日期: $UpdateDate\n当前版本: $VerConfUser\n新的版本: $VerConfSample\n更新内容: $UpdateContent\n"
                echo -e $NotifyContent
                Notify "$NotifyTitle" "$NotifyContent"
                echo ''
                [ $? -eq 0 ] && echo $VerConfSample >$FileSendMark
            fi
        else
            [ -f $FileSendMark ] && rm -f $FileSendMark
        fi
    }

    local PanelDependOld PanelDependNew
    echo -e "-------------------------------------------------------------"
    ## 更新前先存储 package.json
    [ -f $PanelDir/package.json ] && PanelDependOld=$(cat $PanelDir/package.json)
    ## 更新仓库
    cd $RootDir
    Git_Pull $RootDir "$(git status | head -n 1 | awk -F ' ' '{print$NF}')" "开始更新项目源码"
    if [[ $ExitStatus -eq 0 ]]; then
        echo -e "\n$COMPLETE 源码已更新\n"
    else
        echo -e "\n$FAIL 源码更新失败，请检查原因...\n"
    fi
    ## 检测依赖变动
    [ -f $PanelDir/package.json ] && PanelDependNew=$(cat $PanelDir/package.json)
    if [[ "$PanelDependOld" != "$PanelDependNew" ]]; then
        pm2 delete server >/dev/null 2>&1
        $ContrlCmd service on
    fi
    ## 检测配置文件版本
    Detect_Config_Version
}