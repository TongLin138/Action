#!/bin/bash
## Modified: 2023-10-24

## 查找脚本
# 通过各种判断将得到的必要信息传给接下来运行的函数或命令
#   "FileName"     脚本名称（去后缀）
#   "FileSuffix"   脚本后缀名
#   "FileFormat"   脚本类型
#   "FileDir"      脚本所在目录（绝对路径）
# 不论何种匹配方式或查找方式，当未指定脚本类型但存在同名脚本时，执行优先级为 JavaScript > Python > TypeScript > Shell
function find_script() {
    local InputContent=$1
    FileName=""
    FileDir=""
    FileFormat=""

    ## 匹配指定路径下的脚本
    function match_path_file() {
        local AbsolutePath PwdTmp FileNameTmp FileDirTmp

        ## 判定路径格式
        echo $1 | grep "/$" -q
        if [ $? -eq 0 ]; then
            output_error "请输入正确的脚本路径！"
        fi

        ## 判定传入的是绝对路径还是相对路径
        echo ${InputContent} | grep "^$RootDir" -q
        if [ $? -eq 0 ]; then
            AbsolutePath=${InputContent}
        else
            echo ${InputContent} | grep "\.\./" -q
            if [ $? -eq 0 ]; then
                PwdTmp=$(pwd | sed "s|/$(pwd | awk -F '/' '{printf$NF}')||g")
                AbsolutePath=$(echo "${InputContent}" | sed "s|\.\./|${PwdTmp}/|g")
            else
                local TmpDirName=$(echo ${InputContent} | awk -F '/' '{printf$1}')
                if [ -d "$RepoDir/$TmpDirName" ]; then
                    AbsolutePath=$(echo "${InputContent}" | sed "s|^|$RepoDir/|g")
                else
                    ## 适配在定时清单中使用相对路径时将自动纠正为绝对路径
                    if [[ $(pwd) == "/root" ]]; then
                        AbsolutePath=$(echo "${InputContent}" | sed "s|\.\/||g; s|^*|$RootDir/|g")
                    else
                        AbsolutePath=$(echo "${InputContent}" | sed "s|\.\/||g; s|^*|$(pwd)/|g")
                    fi
                fi
            fi
            echo ${InputContent} | grep "\.\./" -q
        fi
        ## 判定传入是否含有后缀格式
        FileNameTmp=${AbsolutePath##*/}
        FileDirTmp=${AbsolutePath%/*}
        echo ${FileNameTmp} | grep "\." -q
        if [ $? -eq 0 ]; then
            if [ -f ${AbsolutePath} ]; then
                FileSuffix=${FileNameTmp##*.}
                ## 判断并定义脚本类型
                case ${FileSuffix} in
                js)
                    FileFormat="JavaScript"
                    ;;
                py)
                    FileFormat="Python"
                    ;;
                ts)
                    FileFormat="TypeScript"
                    ;;
                sh)
                    FileFormat="Shell"
                    ;;
                *)
                    output_error "项目不支持运行 .${FileSuffix} 类型的脚本！"
                    ;;
                esac
                FileName=${FileNameTmp%.*}
                FileDir=${FileDirTmp}
            fi
        else
            if [ -f ${FileDirTmp}/${FileNameTmp}.js ]; then
                FileName=${FileNameTmp}
                FileFormat="JavaScript"
                FileDir=${FileDirTmp}
            elif [ -f ${FileDirTmp}/${FileNameTmp}.py ]; then
                FileName=${FileNameTmp}
                FileFormat="Python"
                FileDir=${FileDirTmp}
            elif [ -f ${FileDirTmp}/${FileNameTmp}.ts ]; then
                FileName=${FileNameTmp}
                FileFormat="TypeScript"
                FileDir=${FileDirTmp}
            elif [ -f ${FileDirTmp}/${FileNameTmp}.sh ]; then
                FileName=${FileNameTmp}
                FileFormat="Shell"
                FileDir=${FileDirTmp}
            fi
        fi

        ## 判定变量是否存在否则报错终止退出
        if [ -n "${FileName}" ] && [ -n "${FileDir}" ]; then
            ## 添加依赖文件
            check_moudules $FileDir
            ## 定义日志路径
            if [[ $(echo ${AbsolutePath} | awk -F '/' '{print$3}') == "repo" ]]; then
                LogPath="$LogDir/$(echo ${AbsolutePath} | awk -F '/' '{print$4}')_${FileName}"
            elif [[ $(echo ${AbsolutePath} | awk -F '/' '{print$3}') == "raw" ]]; then
                LogPath="$LogDir/raw_${FileName}"
            else
                LogPath="$LogDir/${FileName}"
            fi
            make_dir ${LogPath}
        else
            output_error "在 ${BLUE}${AbsolutePath%/*}${PLAIN} 目录未检测到 ${BLUE}${AbsolutePath##*/}${PLAIN} 脚本的存在，请重新确认！"
        fi
    }

    ## 匹配 scripts 目录下的脚本
    function match_scripts_file() {
        local FileNameTmp SeekDir SeekExtension
        ## 定义目录范围
        SeekDir="$ScriptsDir"
        ## 定义后缀格式
        SeekExtension="js py ts sh"

        ## 判定传入是否含有后缀格式
        ## 如果存在后缀格式则为精确查找，否则为模糊查找，仅限关于脚本名称的定位目录除外

        ## 判定是否传入了后缀格式
        echo ${InputContent} | grep "\." -q
        ## 精确查找
        if [ $? -eq 0 ]; then
            ## 判断并定义脚本类型
            FileSuffix=${InputContent##*.}
            case ${FileSuffix} in
            js)
                FileFormat="JavaScript"
                ;;
            py)
                FileFormat="Python"
                ;;
            ts)
                FileFormat="TypeScript"
                ;;
            sh)
                FileFormat="Shell"
                ;;
            *)
                output_error "项目不支持运行 .${FileSuffix} 类型的脚本！"
                ;;
            esac
            for dir in ${SeekDir}; do
                if [ -f ${dir}/${InputContent} ]; then
                    FileName=${InputContent%.*}
                    FileDir=${dir}
                    break
                fi
            done

        else
            ## 模糊查找
            FileNameTmp=$(echo ${InputContent} | sed "s/\.js//g; s/\.py//g; s/\.ts//g; s/\.sh//g")
            for dir in ${SeekDir}; do
                for ext in ${SeekExtension}; do
                    if [ -f ${dir}/${FileNameTmp}\.${ext} ]; then
                        FileName=${FileNameTmp}
                        FileDir=${dir}
                        FileSuffix=${ext}
                        break 2
                    fi
                done
            done

            ## 判断并定义脚本类型
            if [ -n "${FileName}" ] && [ -n "${FileDir}" ]; then
                case ${FileSuffix} in
                js)
                    FileFormat="JavaScript"
                    ;;
                py)
                    FileFormat="Python"
                    ;;
                ts)
                    FileFormat="TypeScript"
                    ;;
                sh)
                    FileFormat="Shell"
                    ;;
                esac
            fi
        fi

        ## 判定变量是否存在否则报错终止退出
        if [ -n "${FileName}" ] && [ -n "${FileDir}" ]; then
            ## 添加依赖文件
            check_moudules $FileDir
            ## 定义日志路径
            LogPath="$LogDir/${FileName}"
            make_dir ${LogPath}
        else
            output_error "在 ${BLUE}$ScriptsDir${PLAIN} 根目录以及 ${BLUE}./backUp${PLAIN} ${BLUE}./utils${PLAIN} 二个子目录下均未检测到 ${BLUE}${InputContent}${PLAIN} 脚本的存在，请重新确认！"
        fi
    }

    ## 匹配位于远程仓库的脚本
    function match_remote_file() {
        local ProxyJudge
        local FileNameTmp=${InputContent##*/}

        ## 判断并定义脚本类型
        FileSuffix=${FileNameTmp##*.}
        case ${FileSuffix} in
        js)
            FileFormat="JavaScript"
            ;;
        py)
            FileFormat="Python"
            ;;
        ts)
            FileFormat="TypeScript"
            ;;
        sh)
            FileFormat="Shell"
            ;;
        "")
            output_error "未能识别脚本类型，请检查链接地址是否正确！"
            ;;
        *)
            output_error "本项目不支持运行 ${BLUE}.${FileSuffix}${PLAIN} 类型的脚本！"
            ;;
        esac

        ## 仓库原始文件地址自动纠正
        import utils/request
        if [[ "$(get_correct_raw_url "${InputContent}")" ]]; then
            InputContent="$(get_correct_raw_url "${InputContent}")"
        fi
        ## 判定是否使用下载代理参数
        if [[ "${DOWNLOAD_PROXY}" == true ]]; then
            echo "${InputContent}" | grep "raw\.githubusercontent\.com/" -q
            if [ $? -eq 0 ]; then
                local repo_branch=$(echo "${InputContent}" | sed "s/https:\/\/raw\.githubusercontent\.com\///g" | awk -F '/' '{print$3}')
                InputContent=$(echo "${InputContent}" | sed "s|raw\.githubusercontent\.com|cdn\.jsdelivr\.net\/gh|g; s|\/${repo_branch}\/|\@${repo_branch}\/|g")
                ProxyJudge="使用代理"
            else
                output_error "下载代理命令选项仅支持位于 GitHub 仓库的文件！"
            fi
        else
            InputContent="${Tmp}"
            ProxyJudge=""
        fi

        ## 拉取脚本
        echo -en "\n$WORKING 正在从远程仓库${ProxyJudge}下载 ${BLUE}${FileNameTmp}${PLAIN} 脚本..."
        wget -q --no-check-certificate "${InputContent}" -O "$ScriptsDir/${FileNameTmp}.new" -T 30
        local EXITSTATUS=$?
        echo ''

        ## 判定拉取结果
        if [[ $EXITSTATUS -eq 0 ]]; then
            mv -f "$ScriptsDir/${FileNameTmp}.new" "$ScriptsDir/${FileNameTmp}"
            case "${RUN_MODE}" in
            run)
                RunModJudge=""
                ;;
            conc)
                RunModJudge="并发"
                ;;
            esac
            echo ''
            ## 等待动画
            local spin=('.   ' '..  ' '... ' '....')
            local n=0
            tput civis
            while (true); do
                ((n++))
                echo -en "$COMPLETE 下载完毕，倒计时 3 秒后开始${RunModJudge}执行${spin[$((n % 4))]}${PLAIN}" "\r"
                sleep 0.3
                [ $n = 10 ] && echo -e "\033[?25h\n${PLAIN}" && break
            done
            tput cnorm
            FileName=${FileNameTmp%.*}
            FileDir=$ScriptsDir
            ## 添加依赖文件
            check_moudules $FileDir
            ## 定义日志路径
            LogPath="$LogDir/${FileName}"
            make_dir ${LogPath}
            RUN_REMOTE="true"
        else
            [ -f "$ScriptsDir/${FileNameTmp}.new" ] && rm -rf "$ScriptsDir/${FileNameTmp}.new"
            echo -e "\n$FAIL 脚本 ${FileNameTmp} 下载异常，请检查网络连通性并对目标 URL 地址是否正确进行验证！\n"
            exit ## 终止退出
        fi
    }

    ## 检测环境，添加依赖文件
    function check_moudules() {
        local WorkDir=$1
        if [[ "${FileFormat}" == "JavaScript" || "${FileFormat}" == "TypeScript" ]]; then
            ## 拷贝核心组件
            local CoreFiles="jdCookie.js USER_AGENTS.js"
            for file in ${CoreFiles}; do
                [ ! -f $WorkDir/$file ] && cp -rf $UtilsDir/$file $WorkDir
            done
            ## 拷贝推送通知模块
            import_config_not_check
            if [[ "${EnableCustomNotify}" == true ]] && [ -s $FileSendNotifyUser ]; then
                cp -rf $FileSendNotifyUser $WorkDir
            else
                cp -rf $FileSendNotify $WorkDir
            fi
        fi
    }

    ## 根据传入内容判断匹配方式（主要）
    echo ${InputContent} | grep "/" -q
    if [ $? -eq 0 ]; then
        ## 判定传入的是路径还是URL
        echo ${InputContent} | grep -Eq "^https?:"
        if [ $? -eq 0 ]; then
            match_remote_file
        else
            match_path_file
        fi
    else
        match_scripts_file
    fi

    ## 针对较旧的处理器架构进行一些处理
    case ${ARCH} in
    armv7l | armv6l | i686)
        if [[ ${RUN_MODE} == "conc" ]]; then
            output_error "检测到当前使用的是32位处理器，由于性能不佳故禁用并发功能！"
        fi
        case "${FileFormat}" in
        Python | TypeScript)
            output_error "当前宿主机的处理器架构不支持运行 Python 和 TypeScript 脚本，建议更换运行环境！"
            ;;
        esac
        ;;
    esac
}
