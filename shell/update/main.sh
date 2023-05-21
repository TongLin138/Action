#!/bin/bash
## Modified: 2023-05-21

import update/git

## 创建日志文件夹
Make_Dir $LogDir
## 导入配置文件（不检查）
Import_Config_Not_Check

## 更新所有 Raw 脚本
function Update_RawFile() {

    # 读取脚本同步全局配置
    function Get_GobalConf() {
        cat $FileSyncConfUser | yq '.gobal' | jq -rc "$1"
    }

    local RemoveMark DownloadUrl
    ## 统计扩展脚本数量并生成配置
    Count_RawSum
    Gen_RawConf

    if [[ $RawSum -ge 1 && ${#Array_Raw_url[*]} -ge 1 ]]; then
        ## 定义依赖文件过滤（白名单）
        if [[ "$(Get_GobalConf ".rawDependencyFilter")" ]]; then
            local filter="${RawDirUtils}|$(Get_GobalConf ".rawDependencyFilter")"
        else
            local filter="${RawDirUtils}"
        fi
        ## 生成旧的定时脚本清单
        if [[ ${Array_Raw_cronSettings_updateTaskList[i]} == "true" ]]; then
            if [[ $(ls $RawDir 2>/dev/null | grep -Ev "${filter}") ]]; then
                for file in $(ls $RawDir 2>/dev/null | grep -Ev "${filter}"); do
                    echo "${Array_Raw_path[i]}" >>$ListOldScripts
                done
            fi
        fi
        ## 遍历扩展脚本配置数组，更新并生成新的定时脚本清单
        for ((i = 0; i < ${#Array_Raw_url[*]}; i++)); do
            echo "${Array_Raw_url[i]}" | grep -Eq "github|gitee|gitlab"
            local web_url=${Array_Raw_url/*:\/\//}
            ## 拉取脚本
            local web_url="${Array_Raw_url[i]/\/${Array_Raw_name[i]}/}"
            if [ $? -eq 0 ]; then
                echo ${Array_Raw_url[i]} | grep -E "git.*\.io/" -q
                if [ $? -eq 0 ]; then
                    echo -e "\n$WORKING 开始从网站 ${BLUE}${web_url}${PLAIN} 下载 ${BLUE}${Array_Raw_fileName[i]}${PLAIN} 脚本..."
                else
                    echo -e "\n$WORKING 开始从仓库 ${BLUE}${RepoUrl}${PLAIN} 下载 ${BLUE}${Array_Raw_fileName[i]}${PLAIN} 脚本..."
                fi
                wget -q --no-check-certificate -O "$RawDir/${Array_Raw_name[i]}.new" ${Array_Raw_url[i]} -T 30
            else
                DownloadUrl="${Array_Raw_url[i]}"
                echo -e "\n$WORKING 开始从网站 ${BLUE}${web_url}${PLAIN} 下载 ${BLUE}${Array_Raw_fileName[i]}${PLAIN} 脚本..."
                wget -q --no-check-certificate -O "$RawDir/${Array_Raw_name[i]}.new" ${Array_Raw_url[i]} -T 30
            fi
            if [ $? -eq 0 ]; then
                mv -f "$RawDir/${Array_Raw_name[i]}.new" "$RawDir/${Array_Raw_name[i]}"
                echo -e "$COMPLETE ${Array_Raw_name[i]} 下载完成，脚本保存路径：$RawDir/${Array_Raw_name[i]}"
            else
                echo -e "$FAIL ${Array_Raw_name[i]} 下载异常，保留之前正常下载的版本...\n"
                [ -f "$RawDir/${Array_Raw_name[i]}.new" ] && rm -f "$RawDir/${Array_Raw_name[i]}.new"
            fi

            [[ ${Array_Raw_cronSettings_updateTaskList[i]} == "true" ]] && echo "${Array_Raw_path[i]}" >>$ListNewScripts
        done
        ## 清理 raw 目录下无关的文件
        if [[ $(ls $RawDir 2>/dev/null | grep -Ev "${filter}") ]]; then
            for file in $(ls $RawDir 2>/dev/null | grep -Ev "${filter}"); do
                RemoveMark="yes"
                for ((i = 0; i < ${#Array_Raw_url[*]}; i++)); do
                    if [[ $file == "${Array_Raw_path[arr_num]##*/}" ]]; then
                        RemoveMark="no"
                        break
                    fi
                    ${Array_Raw_url[$arr_num]##*/}
                done
                [[ $RemoveMark == yes ]] && rm -f $RawDir/$file 2>/dev/null
            done
        fi
    else
        echo -e "$ERROR 未检测到任何有效的扩展脚本配置，跳过更新扩展脚本..."
    fi
}

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
        $ContrlCmd panel on
    fi
    ## 检测配置文件版本
    Detect_Config_Version
}

## 更新 Repo 仓库和 RawFile 脚本
function UpdateMain() {
    import sync
    import cron

    ## 创建目录
    Make_Dir $ReposDir
    Make_Dir $RawDir
    Make_Dir $LogTmpDir

    ## 清空定时任务关联脚本清单内容
    CleanListScripts
    ## 根据模式进行跟香港
    case $1 in
    all)
        Update_AllRepo
        Update_RawFile
        ;;
    repo)
        Update_AllRepo
        ;;
    raw)
        Update_RawFile
        ;;
    esac

    ## 更新定时任务
    Update_Cron
}

## 自定义脚本
function ExtraShell() {
    if [[ ${EnableExtraShell} = true || ${EnableExtraShellSync} = true ]]; then
        echo -e "-------------------------------------------------------------\n"
    fi
    ## 同步用户的 extra.sh
    if [[ $EnableExtraShellSync == true ]] && [[ $ExtraShellSyncUrl ]]; then
        echo -e "$WORKING 开始同步自定义脚本：$ExtraShellSyncUrl\n"
        wget -q --no-check-certificate $ExtraShellSyncUrl -O $FileExtra.new -T 20
        if [ $? -eq 0 ]; then
            mv -f "$FileExtra.new" "$FileExtra"
            echo -e "$COMPLETE 自定义脚本同步完成\n"
            sleep 1s
        else
            if [ -f $FileExtra ]; then
                echo -e "$FAIL 自定义脚本同步失败，保留之前的版本...\n"
            else
                echo -e "$FAIL 自定义脚本同步失败，请检查原因...\n"
            fi
            sleep 2s
        fi
        [ -f "$FileExtra.new" ] && rm -rf "$FileExtra.new"
    fi
    ## 执行用户的 extra.sh
    if [[ $EnableExtraShell == true ]]; then
        ## 执行
        if [ -f $FileExtra ]; then
            echo -e "$WORKING 开始执行自定义脚本：$FileExtra\n"
            . $FileExtra
            echo -e "\n$COMPLETE 自定义脚本执行完毕\n"
        else
            echo -e "$ERROR 自定义脚本不存在，跳过执行...\n"
        fi
    fi
}

## 更新指定路径下的仓库
function Update_Designated() {
    local InputContent AbsolutePath PwdTmp
    ## 去掉最后一个/
    echo $1 | grep "/$" -q
    if [ $? -eq 0 ]; then
        local InputContent="${1%?}"
    else
        local InputContent="$1"
    fi
    ## 判定传入的是绝对路径还是相对路径
    echo "${InputContent}" | grep "^$RootDir" -q
    if [ $? -eq 0 ]; then
        AbsolutePath="${InputContent}"
    else
        ## 处理上级目录
        echo "${InputContent}" | grep "\.\./" -q
        if [ $? -eq 0 ]; then
            PwdTmp=$(pwd | sed "s|/$(pwd | awk -F '/' '{printf$NF}')||g")
            AbsolutePath=$(echo "${InputContent}" | sed "s|\.\./|${PwdTmp}/|g")
        else
            AbsolutePath=$(echo "${InputContent}" | sed "s|\.\/||g; s|^*|$(pwd)/|g")
        fi
    fi
    ## 判定是否存在仓库
    if [ -d ${AbsolutePath}/.git ]; then
        if [[ "${AbsolutePath}" = "$RootDir" ]]; then
            Title "source"
            Update_SourceCode
        else
            Make_Dir $ReposDir
            Make_Dir $LogTmpDir

            import sync
            import cron

            Count_RepoSum
            Gen_RepoConf

            ## 清空定时任务关联脚本清单内容
            CleanListScripts
            ## 判断仓库是否在配置文件中
            # 根据目标仓库是否为已配置的仓库
            local configured_repo=false # 是否为已配置的仓库
            if [[ $RepoSum -ge 1 && ${#Array_Repo_url[*]} -ge 1 ]]; then
                for ((i = 0; i < ${#Array_Repo_url[*]}; i++)); do
                    echo "${AbsolutePath}" | grep "${Array_Repo_path[i]}" -q
                    [ $? -eq 0 ] && local current_num=$i && configured_repo=true && break
                done
            fi
            Title "designated"
            echo -e "-------------------------------------------------------------"
            if [ $configured_repo == true ]; then
                # 生成旧的定时脚本清单
                if [[ ${Array_Repo_cronSettings_updateTaskList[current_num]} == "true" ]]; then
                    Gen_RepoCronList "old" "${Array_Repo_path[current_num]}" "${Array_Repo_cronSettings_scriptsPath[current_num]}" "${Array_Repo_cronSettings_scriptsType[current_num]}" "${Array_Repo_cronSettings_whiteList[current_num]}" "${Array_Repo_cronSettings_blackList[current_num]}" "${Array_Repo_cronSettings_autoDisable[current_num]}" "${Array_Repo_cronSettings_addNotify[current_num]}" "${Array_Repo_cronSettings_delNotify[current_num]}"
                fi
                Reset_Romote_Url ${Array_Repo_path[current_num]} ${Array_Repo_url[current_num]} ${Array_Repo_branch[current_num]}
                Git_Pull ${Array_Repo_path[current_num]} ${Array_Repo_branch[current_num]}
                if [[ $ExitStatus -eq 0 ]]; then
                    echo -e "\n$COMPLETE ${BLUE}${Array_Repo_name[current_num]}${PLAIN} 仓库更新完成"
                else
                    echo -e "\n$FAIL ${BLUE}${Array_Repo_name[current_num]}${PLAIN} 仓库更新失败，请检查原因..."
                fi
                # 生成新的定时脚本清单
                if [[ ${Array_Repo_cronSettings_updateTaskList[current_num]} == "true" ]]; then
                    Gen_RepoCronList "new" "${Array_Repo_path[current_num]}" "${Array_Repo_cronSettings_scriptsPath[current_num]}" "${Array_Repo_cronSettings_scriptsType[current_num]}" "${Array_Repo_cronSettings_whiteList[current_num]}" "${Array_Repo_cronSettings_blackList[current_num]}" "${Array_Repo_cronSettings_autoDisable[current_num]}" "${Array_Repo_cronSettings_addNotify[current_num]}" "${Array_Repo_cronSettings_delNotify[current_num]}"
                fi

                ## 更新定时任务
                Update_Cron
            else
                Git_Pull "${AbsolutePath}" $(grep "branch" ${AbsolutePath}/.git/config | awk -F '\"' '{print$2}')
                if [[ $ExitStatus -eq 0 ]]; then
                    echo -e "\n$COMPLETE 仓库更新完成"
                else
                    echo -e "\n$FAIL 仓库更新失败，请检查原因..."
                fi
            fi
        fi
    else
        if [ -d ${AbsolutePath} ]; then
            echo -e "\n$ERROR 未检测到 ${BLUE}${AbsolutePath}${PLAIN} 路径下存在任何仓库，请重新确认！\n"
        else
            echo -e "\n$ERROR 未检测到 ${BLUE}${AbsolutePath}${PLAIN} 路径不存在，请重新确认！\n"
        fi
        exit ## 终止退出
    fi
}

function Title() {
    local p=$1
    local RunMod
    case $1 in
    all)
        RunMod=" 全 部 内 容 "
        ;;
    source)
        RunMod=" 项 目 源 码 "
        ;;
    repo)
        RunMod=" 所 有 仓 库 "
        ;;
    raw)
        RunMod=" 扩 展 脚 本 "
        ;;
    extra)
        RunMod=" 自 定 脚 本 "
        ;;
    designated)
        RunMod=" 指 定 仓 库 "
        ;;
    esac
    echo -e "\n+-------------------- 执 行 更 新 程 序 --------------------+"
    echo -e ''
    echo -e "                   更新模式：${BLUE}${RunMod}${PLAIN}  "
    echo -e ''
    echo -e "                系统时间：${BLUE}$(date "+%Y-%m-%d %T")${PLAIN}"
    echo -e ''
}

function Main() {
    case $# in
    0)
        Help $UpdateCmd
        ;;
    1)
        case $1 in
        all)
            Title $1
            Update_SourceCode
            UpdateMain "all"
            ExtraShell
            echo ''
            ;;
        shell | source)
            Title "source"
            Update_SourceCode
            ;;
        repo)
            Title $1
            UpdateMain "repo"
            echo ''
            ;;
        raw)
            Title $1
            UpdateMain "raw"
            echo ''
            ;;
        extra)
            if [[ $EnableExtraShellSync == true ]] || [[ $EnableExtraShell == true ]]; then
                Title $1
                ExtraShell
            else
                echo -e "\n$ERROR 请先在 $FileConfUser 中启用关于 Extra 自定义脚本的相关变量！\n"
            fi
            ;;
        *)
            ## 判断传入参数
            echo $1 | grep "\/" -q
            if [ $? -eq 0 ]; then
                Update_Designated $1
            else
                if [ -d "$(pwd)/$1" ]; then
                    if [[ "$1" = "." ]]; then
                        Update_Designated "$(pwd)"
                    elif [[ "$1" = "./" ]]; then
                        Update_Designated "$(pwd)"
                    else
                        Update_Designated "$(pwd)/$1"
                    fi
                else
                    Output_Command_Error 1 # 命令错误
                    exit                   ## 终止退出
                fi
            fi
            ;;
        esac
        exit ## 终止退出
        ;;
    *)
        Output_Command_Error 2 # 命令过多
        ;;
    esac
}

Main "$@" | tee -a $LogDir/update.log
