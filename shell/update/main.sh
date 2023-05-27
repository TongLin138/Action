#!/bin/bash
## Modified: 2023-05-27

## 清空定时任务关联脚本清单内容
function clean_list_scripts() {
    local Dirs=("$ListOldScripts $ListNewScripts $ListAddScripts $ListDelScripts $ListConfScripts")
    for file in ${Dirs}; do
        [ -f $file ] && sed -i '1,$d' $file || touch $file
    done
    echo "{}" >$ListConfScripts
}

## 更新 Repo 仓库和 RawFile 脚本
function update_main() {
    import sync
    import update/cron

    ## 创建目录
    make_dir $ReposDir
    make_dir $RawDir
    make_dir $LogTmpDir

    ## 清空定时任务关联脚本清单内容
    clean_list_scripts
    ## 根据模式进行跟香港
    case $1 in
    all)
        import update/repo
        import update/raw
        update_all_repo
        update_raw
        ;;
    repo)
        import update/repo
        update_all_repo
        ;;
    raw)
        import update/raw
        update_raw
        ;;
    esac

    ## 更新定时任务
    update_cron
}

function print_title() {
    local p=$1
    local update_mod
    case $1 in
    all)
        update_mod=" 全 部 内 容 "
        ;;
    source)
        update_mod=" 项 目 源 码 "
        ;;
    repo)
        update_mod=" 所 有 仓 库 "
        ;;
    raw)
        update_mod=" 扩 展 脚 本 "
        ;;
    extra)
        update_mod=" 额 外 脚 本 "
        ;;
    designated)
        update_mod=" 指 定 仓 库 "
        ;;
    esac
    echo -e "\n+-------------------- 执 行 更 新 程 序 --------------------+"
    echo -e ''
    echo -e "                   更新模式：${BLUE}${update_mod}${PLAIN}  "
    echo -e ''
    echo -e "                系统时间：${BLUE}$(date "+%Y-%m-%d %T")${PLAIN}"
    echo -e ''
}

function main() {

    import update/git
    ## 创建日志文件夹
    make_dir $LogDir
    ## 导入配置文件（不检查）
    import_config_not_check

    case $# in
    0)
        import core/help
        Help $UpdateCmd
        ;;
    1)
        case $1 in
        all)
            print_title $1
            import update/source
            update_sourcecode

            update_main "all"

            import update/extra
            update_extra
            echo ''
            ;;
        source)
            print_title "source"
            import update/source
            update_sourcecode
            ;;
        repo)
            print_title $1
            update_main "repo"
            echo ''
            ;;
        raw)
            print_title $1
            update_main "raw"
            echo ''
            ;;
        extra)
            if [[ $EnableUpdateExtraSync == true ]] || [[ $EnableUpdateExtra == true ]]; then
                print_title $1
                import update/extra
                update_extra
            else
                echo -e "\n$ERROR 请先在 $FileConfUser 中启用关于 Extra 自定义脚本的相关变量！\n"
            fi
            ;;
        *)
            ## 判断传入参数
            echo $1 | grep "\/" -q
            if [ $? -eq 0 ]; then
                import update/repo
                update_designated_repo $1
            else
                if [ -d "$(pwd)/$1" ]; then
                    import update/repo
                    if [[ "$1" = "." ]]; then
                        update_designated_repo "$(pwd)"
                    elif [[ "$1" = "./" ]]; then
                        update_designated_repo "$(pwd)"
                    else
                        update_designated_repo "$(pwd)/$1"
                    fi
                else
                    output_command_error 1 # 命令错误
                    exit                   ## 终止退出
                fi
            fi
            ;;
        esac
        exit ## 终止退出
        ;;
    *)
        output_command_error 2 # 命令过多
        ;;
    esac
}

main "$@" | tee -a $LogDir/update.log
