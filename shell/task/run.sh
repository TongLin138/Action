#!/bin/bash
## Modified: 2023-05-21

## 查找脚本
function Find_Script() {

    ## 通过各种判断将得到的必要信息传给接下来运行的函数或命令

    ##   "FileName"     脚本名称（去后缀）
    ##   "FileSuffix"   脚本后缀名
    ##   "FileFormat"   脚本类型
    ##   "FileDir"      脚本所在目录（绝对路径）

    ## 不论何种匹配方式或查找方式，当未指定脚本类型但存在同名脚本时，执行优先级为 JavaScript > Python > TypeScript > Shell

    local InputContent=$1
    FileName=""
    FileDir=""
    FileFormat=""

    ## 匹配指定路径下的脚本
    function MatchingPathFile() {
        local AbsolutePath PwdTmp FileNameTmp FileDirTmp

        ## 判定路径格式
        echo $1 | grep "/$" -q
        if [ $? -eq 0 ]; then
            echo -e "\n$ERROR 请输入正确的脚本路径！\n"
            exit ## 终止退出
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
                if [ -d "$ReposDir/$TmpDirName" ]; then
                    AbsolutePath=$(echo "${InputContent}" | sed "s|^|$ReposDir/|g")
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
                    echo -e "\n$ERROR 项目不支持运行 .${FileSuffix} 类型的脚本！\n"
                    exit ## 终止退出
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
            [[ ${FileFormat} == "JavaScript" ]] && Check_Moudules $FileDir
            ## 定义日志路径
            if [[ $(echo ${AbsolutePath} | awk -F '/' '{print$3}') == "repo" ]]; then
                LogPath="$LogDir/$(echo ${AbsolutePath} | awk -F '/' '{print$4}')_${FileName}"
            else
                LogPath="$LogDir/${FileName}"
            fi
            Make_Dir ${LogPath}
        else
            echo -e "\n$ERROR 在 ${BLUE}${AbsolutePath%/*}${PLAIN} 目录未检测到 ${BLUE}${AbsolutePath##*/}${PLAIN} 脚本的存在，请重新确认！\n"
            exit ## 终止退出
        fi
    }

    ## 匹配 Scripts 目录下的脚本
    function MatchingScriptsFile() {
        local FileNameTmp SeekDir SeekExtension
        ## 定义目录范围，优先级为 /jd/scripts > /jd/scripts/utils > /jd/scripts/backUp
        SeekDir="$ScriptsDir $ScriptsDir/utils $ScriptsDir/backUp"
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
                echo -e "\n$ERROR 项目不支持运行 .${FileSuffix} 类型的脚本！\n"
                exit ## 终止退出
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
            [[ ${FileFormat} == "JavaScript" ]] && Check_Moudules $FileDir
            ## 定义日志路径
            LogPath="$LogDir/${FileName}"
            Make_Dir ${LogPath}
        else
            echo -e "\n$ERROR 在 ${BLUE}$ScriptsDir${PLAIN} 根目录以及 ${BLUE}./backUp${PLAIN} ${BLUE}./utils${PLAIN} 二个子目录下均未检测到 ${BLUE}${InputContent}${PLAIN} 脚本的存在，请重新确认！\n"
            exit ## 终止退出
        fi
    }

    ## 匹配位于远程仓库的脚本
    function MatchingRemoteFile() {
        local DownloadJudge RepoJudge ProxyJudge RepoName FormatInputContent
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
            echo -e "\n$ERROR 未能识别脚本类型，请检查链接地址是否正确！\n"
            exit ## 终止退出
            ;;
        *)
            echo -e "\n$ERROR 本项目不支持运行 ${BLUE}.${FileSuffix}${PLAIN} 类型的脚本！\n"
            exit ## 终止退出
            ;;
        esac

        ## 判断来源仓库并处理链接
        RepoName=$(echo "${InputContent}" | grep -Eo "github|gitee|gitlab|jsdelivr")
        case ${RepoName} in
        github | jsdelivr)
            RepoJudge=" GitHub "
            ## 地址纠正
            echo "${InputContent}" | grep "github\.com\/.*\/blob\/.*" -q
            if [ $? -eq 0 ]; then
                local Tmp=$(echo "${InputContent}" | sed "s|github\.com/|raw\.githubusercontent\.com/|g; s|\/blob\/|\/|g")
            else
                local Tmp=${InputContent}
            fi
            ## 验证 GitHub 地址格式
            echo "${Tmp}" | grep "raw\.githubusercontent\.com|github\.io|jsdelivr\.net\/gh" -Eq
            if [ $? -ne 0 ]; then
                echo -e "\n$FAIL 格式错误，请输入正确的 GitHub 地址！\n"
                exit ## 终止退出
            fi
            ## 判定是否使用下载代理参数
            if [[ ${DOWNLOAD_PROXY} == true ]]; then
                local Branch=$(echo "${Tmp}" | sed "s/https:\/\/raw\.githubusercontent\.com\///g" | awk -F '/' '{print$3}')
                FormatInputContent=$(echo "${Tmp}" | sed "s|raw\.githubusercontent\.com|cdn\.jsdelivr\.net\/gh|g; s|\/${Branch}\/|\@${Branch}\/|g")
                ProxyJudge="使用代理"
            else
                FormatInputContent="${Tmp}"
                ProxyJudge=""
            fi
            ;;
        gitee)
            RepoJudge=" Gitee "
            ## 地址纠正
            echo "${InputContent}" | grep "gitee\.com\/.*\/blob\/.*" -q
            if [ $? -eq 0 ]; then
                FormatInputContent=$(echo "${InputContent}" | sed "s/\/blob\//\/raw\//g")
            else
                FormatInputContent="${InputContent}"
            fi
            ProxyJudge=""
            ;;
        gitlab)
            RepoJudge=" GitLab "
            ## 地址纠正
            echo "${InputContent}" | grep "gitlab\.com\/.*\/blob\/.*" -q
            if [ $? -eq 0 ]; then
                FormatInputContent=$(echo "${InputContent}" | sed "s/\/blob\//\/raw\//g")
            else
                FormatInputContent="${InputContent}"
            fi
            ProxyJudge=""
            ;;
        *)
            RepoJudge=""
            ## 其它托管仓库或链接不进行处理
            FormatInputContent="${InputContent}"
            ProxyJudge=""
            ;;
        esac

        ## 拉取脚本
        echo -en "\n$WORKING 正在从${BLUE}${RepoJudge}${PLAIN}远程仓库${ProxyJudge}下载 ${BLUE}${FileNameTmp}${PLAIN} 脚本..."
        wget -q --no-check-certificate "${FormatInputContent}" -O "$ScriptsDir/${FileNameTmp}.new" -T 20
        local ExitStatus=$?
        echo ''

        ## 判定拉取结果
        if [[ $ExitStatus -eq 0 ]]; then
            mv -f "$ScriptsDir/${FileNameTmp}.new" "$ScriptsDir/${FileNameTmp}"
            case ${RUN_MODE} in
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
            [[ ${FileFormat} == "JavaScript" ]] && Check_Moudules $FileDir
            ## 定义日志路径
            LogPath="$LogDir/${FileName}"
            Make_Dir ${LogPath}
            RUN_REMOTE="true"
        else
            [ -f "$ScriptsDir/${FileNameTmp}.new" ] && rm -rf "$ScriptsDir/${FileNameTmp}.new"
            echo -e "\n$FAIL 脚本 ${FileNameTmp} 下载异常，请检查网络连通性并对目标 URL 地址是否正确进行验证！\n"
            exit ## 终止退出
        fi
    }

    ## 检测环境，添加依赖文件
    function Check_Moudules() {
        local WorkDir=$1
        ## 拷贝核心组件
        for file in ${CoreFiles}; do
            [ ! -f $WorkDir/$file ] && cp -rf $UtilsDir/$file $WorkDir
        done
        ## 拷贝推送通知模块
        Apply_SendNotify $WorkDir
    }

    ## 根据传入内容判断匹配方式（主要）
    echo ${InputContent} | grep "/" -q
    if [ $? -eq 0 ]; then
        ## 判定传入的是路径还是URL
        echo ${InputContent} | grep -Eq "http.*:"
        if [ $? -eq 0 ]; then
            MatchingRemoteFile
        else
            MatchingPathFile
        fi
    else
        MatchingScriptsFile
    fi

    ## 针对较旧的处理器架构进行一些处理
    case ${ARCH} in
    armv7l | armv6l)
        if [[ ${RUN_MODE} == "conc" ]]; then
            echo -e "\n$ERROR 检测到当前使用的是32位处理器，由于性能不佳故禁用并发功能！\n"
            exit ## 终止退出
        fi
        case ${FileFormat} in
        Python | TypeScript)
            echo -e "\n$ERROR 当前宿主机的处理器架构不支持运行 Python 和 TypeScript 脚本，建议更换运行环境！\n"
            exit ## 终止退出
            ;;
        esac
        ;;
    esac
}

## 随机延迟
function Random_Delay() {
    if [[ -n ${RandomDelay} ]] && [[ ${RandomDelay} -gt 0 ]]; then
        local CurMin=$(date "+%-M")
        local CurDelay=$((${RANDOM} % ${RandomDelay} + 1))
        echo -en "\n$WORKING 已启用随机延迟，此任务将在 ${CurDelay} 秒后开始运行..."
        sleep ${CurDelay}
    fi
}

## 等待执行
function RunWait() {
    local FormatPrint
    echo ${RUN_WAIT_TIMES} | grep -E "\.[smd]$|\.$"
    if [ $? -eq 0 ]; then
        echo -e "\n$ERROR 等待时间值格式有误！\n"
        exit ## 终止退出
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
    echo -en "\n$WORKING 此任务将在${FormatPrint}后开始运行..."
    sleep ${RUN_WAIT_TIMES}
    echo ''
}

## 判定账号是否存在
function Account_ExistenceJudgment() {
    local Num=$1
    local Tmp=Cookie$Num
    if [[ -z ${!Tmp} ]]; then
            Output_Error "账号 ${BLUE}$Num${PLAIN} 不存在，请重新确认！"
    fi
}

## 判断账号区间语法合法性
function CheckAccountsRangeFormat() {
    local String=$1
    if [[ $(echo "${String}" | grep -o "-" | wc -l) -ge 2 ]]; then
        echo -e "\n$ERROR 账号区间语法有误，检测到无效参数值 ${BLUE}${String}${PLAIN} ，存在多个 ${BLUE}-${PLAIN} 连接符！\n"
        exit ## 终止退出
    elif [[ $(echo "${String}" | grep -o "%" | wc -l) -ge 2 ]]; then
        echo -e "\n$ERROR 账号区间语法有误，检测到无效参数值 ${BLUE}${String}${PLAIN} ，存在多个 ${BLUE}%${PLAIN} 账号总数代符！\n"
        exit ## 终止退出
    fi
}

## 静默执行，不推送通知消息
function NoPushNotify() {
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
function Run_Normal() {
    local InputContent=$1
    local UserNum LogFile
    ## 匹配脚本
    Find_Script ${InputContent}
    ## 导入配置文件
    Import_Config ${FileName}
    ## 统计账号数量
    Count_UserSum
    ## 静默运行
    [[ ${RUN_MUTE} == true ]] && NoPushNotify

    ## 运行主命令
    function Run_Normal_Main() {
        if [[ ${RUN_BACKGROUND} == true ]]; then
            ## 记录执行开始时间
            echo -e "[$(date "${TIME_FORMAT}" | cut -c1-23)] 执行开始，后台运行不记录结束时间\n" >>${LogFile}
            case ${FileFormat} in
            JavaScript)
                if [[ ${EnableGlobalProxy} == true ]]; then
                    node -r 'global-agent/bootstrap' ${FileName}.js 2>&1 &>>${LogFile} &
                else
                    node ${FileName}.js 2>&1 &>>${LogFile} &
                fi
                ;;
            Python)
                python3 -u ${FileName}.py 2>&1 &>>${LogFile} &
                ;;
            TypeScript)
                ts-node-transpile-only ${FileName}.ts 2>&1 &>>${LogFile} &
                ;;
            Shell)
                bash ${FileName}.sh 2>&1 &>>${LogFile} &
                ;;
            esac
            echo -e "\n$COMPLETE 已部署当前任务并于后台运行中，如需查询脚本运行记录请前往 ${BLUE}${LogPath:4}${PLAIN} 目录查看最新日志\n"
        else
            ## 记录执行开始时间
            echo -e "[$(date "${TIME_FORMAT}" | cut -c1-23)] 执行开始\n" >>${LogFile}
            case ${FileFormat} in
            JavaScript)
                if [[ ${EnableGlobalProxy} == true ]]; then
                    node -r 'global-agent/bootstrap' ${FileName}.js 2>&1 | tee -a ${LogFile}
                else
                    node ${FileName}.js 2>&1 | tee -a ${LogFile}
                fi
                ;;
            Python)
                python3 -u ${FileName}.py 2>&1 | tee -a ${LogFile}
                ;;
            TypeScript)
                ts-node-transpile-only ${FileName}.ts 2>&1 | tee -a ${LogFile}
                ;;
            Shell)
                bash ${FileName}.sh 2>&1 | tee -a ${LogFile}
                ;;
            esac
            ## 记录执行结束时间
            echo -e "\n[$(date "${TIME_FORMAT}" | cut -c1-23)] 执行结束" >>${LogFile}
        fi
    }

    ## 组合账号变量
    function Combin_Designated_Cookie() {
        local Num="$1"
        local Tmp1=Cookie$Num
        local Tmp2=${!Tmp1}
        local CombinAll="${COOKIE_TMP}&${Tmp2}"
        COOKIE_TMP=$(echo $CombinAll | sed "s|^&||g")
    }

    ## 指定运行账号
    function Designated_Account() {
        local AccountsTmp="$1"
        for UserNum in ${AccountsTmp}; do
            echo "${UserNum}" | grep "-" -q
            if [ $? -eq 0 ]; then
                ## 格式检测
                CheckAccountsRangeFormat "${UserNum}"
                if [[ ${UserNum%-*} -lt ${UserNum##*-} ]]; then
                    for ((i = ${UserNum%-*}; i <= ${UserNum##*-}; i++)); do
                        ## 判定账号是否存在
                        Account_ExistenceJudgment $i
                        Combin_Designated_Cookie $i
                    done
                else
                    echo -e "\n$ERROR 检测到无效参数值 ${BLUE}${UserNum}${PLAIN} ，账号区间语法有误，请重新输入！\n"
                    exit ## 终止退出
                fi
            else
                ## 判定账号是否存在
                Account_ExistenceJudgment $UserNum
                Combin_Designated_Cookie $UserNum
            fi
        done
        ## 声明变量
        export JD_COOKIE=${COOKIE_TMP}
    }

    ## 后台挂起（守护进程）
    function Daemon_Process() {
        pm2 list | sed "/─/d" | sed "s| ||g; s#│#|#g" | sed "1d" >$FilePm2List
        cat $FilePm2List | awk -F '|' '{print$3}' | grep $FileName -wq
        ExitStatus=$?
        ## 删除原有
        pm2 stop $FileName >/dev/null 2>&1
        pm2 flush >/dev/null 2>&1
        pm2 delete $FileName >/dev/null 2>&1
        ## 启用
        echo -e "[$(date "${TIME_FORMAT}" | cut -c1-23)] 守护进程启动\n" >>${LogFile}
        case ${FileFormat} in
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
        if [[ $ExitStatus -eq 0 ]]; then
            echo -e "\n$COMPLETE 已重启 ${BLUE}$FileName${PLAIN} 守护进程，日志位于 ${BLUE}${LogFile}${PLAIN}\n"
        else
            echo -e "\n$SUCCESS 已启动 ${BLUE}$FileName${PLAIN} 守护进程，日志位于 ${BLUE}${LogFile}${PLAIN}\n"
        fi
        ## 删除 PM2 进程日志清单
        [ -f $FilePm2List ] && rm -rf $FilePm2List
    }

    ## 脚本代理
    if [[ ${RUN_GLOBAL_AGENT} == true ]]; then
        if [[ ${FileFormat} == "JavaScript" ]]; then
            EnableGlobalProxy="true"
        else
            echo -e "\n$ERROR 检测到无效参数 ${BLUE}--agent${PLAIN} ，仅支持运行 JavaScript 类型的脚本！\n"
            exit ## 终止退出
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
            Designated_Account "${Accounts}"

            ## 判断循环运行次数
            [[ ${RUN_LOOP} == true ]] && RunTimes=$(($RUN_LOOP_TIMES + 1))
            ## 执行脚本
            for ((i = 1; i <= ${RunTimes:-"1"}; i++)); do
                ## 随机延迟
                [[ ${RUN_DELAY} == true ]] && Random_Delay
                ## 等待执行
                [[ ${RUN_WAIT} == true ]] && RunWait
                ## 运行
                if [[ ${RUN_DAEMON} == true ]]; then
                    ## 后台挂起（守护进程）
                    Daemon_Process
                else
                    Run_Normal_Main
                fi
            done

            ## 账号分组清空变量重新组合
            COOKIE_TMP=""
        done
    else
        ## 指定账号
        if [[ ${RUN_DESIGNATED} == true ]]; then
            local Accounts=$(echo ${DESIGNATED_VALUE} | sed "s|%|${UserSum}|g; s|,| |g")
            Designated_Account "${Accounts}"
        else
            ## 加载全部账号
            Combin_AllCookie
        fi

        ## 判断循环运行次数
        [[ ${RUN_LOOP} == true ]] && RunTimes=$(($RUN_LOOP_TIMES + 1))
        ## 执行脚本
        for ((i = 1; i <= ${RunTimes:-"1"}; i++)); do
            ## 随机延迟
            [[ ${RUN_DELAY} == true ]] && Random_Delay
            ## 等待执行
            [[ ${RUN_WAIT} == true ]] && RunWait
            ## 运行
            if [[ ${RUN_DAEMON} == true ]]; then
                ## 后台挂起（守护进程）
                Daemon_Process
            else
                Run_Normal_Main
            fi
        done

    fi

    ## 判断远程脚本执行后是否删除
    if [[ ${RUN_REMOTE} == true && ${AutoDelRawFiles} == true ]]; then
        rm -rf "${FileDir}/${FileName}.${FileSuffix}"
    fi
}

## 并发执行
function Run_Concurrent() {
    local InputContent=$1
    local UserNum LogFile
    ## 匹配脚本
    Find_Script ${InputContent}
    ## 导入配置文件
    Import_Config ${FileName}
    ## 统计账号数量
    Count_UserSum
    ## 静默运行参数
    [[ ${RUN_MUTE} == true ]] && NoPushNotify

    ## 运行主命令
    function Run_Concurrent_Main() {
        local Num=$1
        local Tmp=Cookie${Num}
        export JD_COOKIE=${!Tmp}
        ## 定义日志文件路径
        LogFile="${LogPath}/$(date "+%Y-%m-%d-%H-%M-%S")_${Num}.log"
        ## 记录执行开始时间
        echo -e "[$(date "${TIME_FORMAT}" | cut -c1-23)] 执行开始，后台运行不记录结束时间\n" >>${LogFile}
        ## 执行脚本
        case ${FileFormat} in
        JavaScript)
            if [[ ${EnableGlobalProxy} == true ]]; then
                node -r 'global-agent/bootstrap' ${FileName}.js 2>&1 &>>${LogFile} &
            else
                node ${FileName}.js 2>&1 &>>${LogFile} &
            fi
            ;;
        Python)
            python3 -u ${FileName}.py 2>&1 &>>${LogFile} &
            ;;
        TypeScript)
            ts-node-transpile-only ${FileName}.ts 2>&1 &>>${LogFile} &
            ;;
        Shell)
            bash ${FileName}.sh 2>&1 &>>${LogFile} &
            ;;
        esac
    }

    ## 脚本代理
    if [[ ${RUN_GLOBAL_AGENT} == true ]]; then
        if [[ ${FileFormat} == "JavaScript" ]]; then
            EnableGlobalProxy="true"
        else
            echo -e "\n$ERROR 检测到无效参数 ${BLUE}--agent${PLAIN} ，仅支持运行 JavaScript 类型的脚本！\n"
            exit ## 终止退出
        fi
    fi

    ## 进入脚本所在目录
    cd ${FileDir}
    ## 随机延迟
    [[ ${RUN_DELAY} == true ]] && Random_Delay
    ## 等待执行
    [[ ${RUN_WAIT} == true ]] && RunWait

    ## 加载账号并执行
    if [[ ${RUN_DESIGNATED} == true ]]; then
        ## 判定账号是否存在
        local Accounts=$(echo ${DESIGNATED_VALUE} | sed "s|%|${UserSum}|g; s|,| |g")
        for UserNum in ${Accounts}; do
            echo "${UserNum}" | grep "-" -q
            if [ $? -eq 0 ]; then
                ## 格式检测
                CheckAccountsRangeFormat "${UserNum}"
                if [[ ${UserNum%-*} -lt ${UserNum##*-} ]]; then
                    for ((i = ${UserNum%-*}; i <= ${UserNum##*-}; i++)); do
                        ## 判定账号是否存在
                        Account_ExistenceJudgment $i
                    done
                else
                    echo -e "$ERROR 检测到无效参数值 ${BLUE}${UserNum}${PLAIN} ，账号区间语法有误，请重新输入！\n"
                    exit ## 终止退出
                fi
            else
                ## 判定账号是否存在
                Account_ExistenceJudgment $UserNum
            fi
        done

        ## 指定运行账号
        for UserNum in ${Accounts}; do
            echo "${UserNum}" | grep "-" -q
            if [ $? -eq 0 ]; then
                for ((i = ${UserNum%-*}; i <= ${UserNum##*-}; i++)); do
                    ## 执行脚本
                    Run_Concurrent_Main $i
                done
            else
                ## 执行脚本
                Run_Concurrent_Main ${UserNum}
            fi
        done
    else
        ## 加载全部账号
        ## 全局屏蔽
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
            Run_Concurrent_Main ${UserNum}
        done
    fi
    echo -e "\n$COMPLETE 已部署当前任务并于后台运行中，如需查询脚本运行记录请前往 ${BLUE}${LogPath:4}${PLAIN} 目录查看相关日志\n"

    ## 判断远程脚本执行后是否删除
    if [[ ${RUN_REMOTE} == true && ${AutoDelRawFiles} == true ]]; then
        rm -rf "${FileDir}/${FileName}.${FileSuffix}"
    fi
}

function Run_Script() {
    RUN_MODE="${1}"
    case "${RUN_MODE}" in
    run)
        Run_Normal "${2}"
        ;;
    conc)
        Run_Concurrent "${2}"
        ;;
    esac
}
