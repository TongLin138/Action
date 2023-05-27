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
function update_sync() {
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

function print_title_start() {
    local p=$1
    local update_mod
    case $1 in
    all)
        update_mod="全部内容"
        ;;
    source)
        update_mod="项目源码"
        ;;
    repo)
        update_mod="所有仓库"
        ;;
    raw)
        update_mod="扩展脚本"
        ;;
    extra)
        update_mod="额外脚本"
        ;;
    designated)
        update_mod="指定仓库"
        ;;
    esac
    echo -e "\n[\033[1;34m$(date "+%Y-%m-%d %T")${PLAIN}] 执行更新程序开始 - ${update_mod}"
}

function print_title_end() {
    echo -e "\n[\033[1;34m$(date "+%Y-%m-%d %T")${PLAIN}] 执行更新程序结束\n"
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
        print_help $UpdateCmd
        ;;
    1)
        case $1 in
        all)
            print_title_start $1
            import update/source
            update_sourcecode
            update_sync "all"
            import update/extra
            update_extra
            ;;
        source)
            print_title_start "source"
            import update/source
            update_sourcecode
            ;;
        repo)
            print_title_start $1
            update_sync "repo"
            ;;
        raw)
            print_title_start $1
            update_sync "raw"
            ;;
        extra)
            if [[ $EnableUpdateExtraSync == true ]] || [[ $EnableUpdateExtra == true ]]; then
                print_title_start $1
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
        print_title_end
        ;;
    *)
        output_command_error 2 # 命令过多
        ;;
    esac
}

main "$@" | tee -a $LogDir/update.log
