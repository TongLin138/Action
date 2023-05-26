#!/bin/bash
## Modified: 2023-05-23

## 清空定时任务关联脚本清单内容
function CleanListScripts() {
    local Dirs=("$ListOldScripts $ListNewScripts $ListAddScripts $ListDelScripts $ListConfScripts")
    for file in ${Dirs}; do
        [ -f $file ] && sed -i '1,$d' $file || touch $file
    done
    echo "{}" >$ListConfScripts
}

## 更新 Repo 仓库和 RawFile 脚本
function UpdateMain() {
    import sync
    import update/cron

    ## 创建目录
    Make_Dir $ReposDir
    Make_Dir $RawDir
    Make_Dir $LogTmpDir

    ## 清空定时任务关联脚本清单内容
    CleanListScripts
    ## 根据模式进行跟香港
    case $1 in
    all)
        import update/repo
        import update/raw
        Update_AllRepo
        Update_RawFile
        ;;
    repo)
        import update/repo
        Update_AllRepo
        ;;
    raw)
        import update/raw
        Update_RawFile
        ;;
    esac

    ## 更新定时任务
    Update_Cron
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
        RunMod=" 额 外 脚 本 "
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

    import update/git
    ## 创建日志文件夹
    Make_Dir $LogDir
    ## 导入配置文件（不检查）
    Import_Config_Not_Check

    case $# in
    0)
        import core/help
        Help $UpdateCmd
        ;;
    1)
        case $1 in
        all)
            Title $1
            import update/source
            Update_SourceCode

            UpdateMain "all"

            import update/extra
            UpdateExtra
            echo ''
            ;;
        source)
            Title "source"
            import update/source
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
            if [[ $EnableUpdateExtraSync == true ]] || [[ $EnableUpdateExtra == true ]]; then
                Title $1
                import update/extra
                UpdateExtra
            else
                echo -e "\n$ERROR 请先在 $FileConfUser 中启用关于 Extra 自定义脚本的相关变量！\n"
            fi
            ;;
        *)
            ## 判断传入参数
            echo $1 | grep "\/" -q
            if [ $? -eq 0 ]; then
                import update/repo
                Update_Designated $1
            else
                if [ -d "$(pwd)/$1" ]; then
                    import update/repo
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
