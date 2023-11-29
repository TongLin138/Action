#!/bin/bash
## Modified: 2023-11-29

function main() {

    ## 选择执行模式
    function choose_run_mod() {
        local Input1 Input2 Input3 UserNum TmpParam1 TmpParam2

        ## 判定账号是否存在
        function ExistenceJudgment() {
            local Num=$1
            local Tmp=Cookie$Num
            if [[ -z ${!Tmp} ]]; then
                output_error "账号 ${BLUE}$Num${PLAIN} 不存在，请重新确认！"
            fi
        }

        ## 指定账号参数
        while true; do
            read -p "$(echo -e "\n${BOLD}└ 是否指定账号? [Y/n] ${PLAIN}")" Input1
            [ -z ${Input1} ] && Input1=Y
            case $Input1 in
            [Yy] | [Yy][Ee][Ss])
                ## 导入配置文件
                import_config ${FileName}
                while true; do
                    read -p "$(echo -e "\n${BOLD}  └ 请输入账号对应的序号（多个号用逗号隔开，支持区间）：${PLAIN}")" Input2
                    echo "${Input2}" | grep -Eq "[a-zA-Z./\!@#$%^&*|]|\(|\)|\[|\]|\{|\}"
                    if [ $? -eq 0 ]; then
                        echo -e "\n$ERROR 无效的账号序号，请确认后重新输入！"
                    else
                        local Accounts=$(echo ${Input2} | perl -pe '{s|,| |g}')
                        for UserNum in ${Accounts}; do
                            echo ${UserNum} | grep "-" -q
                            if [ $? -eq 0 ]; then
                                if [[ ${UserNum%-*} -lt ${UserNum##*-} ]]; then
                                    for ((i = ${UserNum%-*}; i <= ${UserNum##*-}; i++)); do
                                        ExistenceJudgment $i
                                    done
                                else
                                    output_error "检测到无效参数值 ${BLUE}${UserNum}${PLAIN} ，账号区间语法有误，请重新输入！"
                                fi
                            else
                                ExistenceJudgment $UserNum
                            fi
                        done
                        break
                    fi
                done
                TmpParam1=" --cookie ${Input2}"
                break
                ;;
            [Nn] | [Nn][Oo])
                TmpParam1=""
                break
                ;;
            esac
            echo -e "\n$ERROR 输入错误，请重新执行！\n"
        done
        ## 静默推送通知参数
        while true; do
            read -p "$(echo -e "\n${BOLD}└ 是否推送通知消息? [Y/n] ${PLAIN}")" Input3
            [ -z ${Input3} ] && Input3=Y
            case $Input3 in
            [Yy] | [Yy][Ee][Ss])
                TmpParam2=""
                break
                ;;
            [Nn] | [Nn][Oo])
                TmpParam2=" --silent"
                break
                ;;
            esac
            echo -e "\n$ERROR 输入错误，请重新执行！\n"
        done
        ## 组合命令
        RunOptions="${TmpParam1}${TmpParam2}"
    }

    ## 查询脚本名，$1 为脚本名
    function query_script_name() {
        local FileName=$1
        case ${FileName##*.} in
        js)
            grep "\$ \=" $FileName | grep -Eiq ".*new Env\(.*\)"
            if [ $? -eq 0 ]; then
                local Tmp=$(grep "\$ \=" $FileName | grep -Ei ".*new Env\(.*\)" | head -1 | perl -pe "{s|.*nv\([\'\"](.*)[\'\"]\).*|\1|g}")
            else
                local Tmp=$(grep -w "script-path" $FileName | head -1 | sed "s/\W//g" | sed "s/[0-9a-zA-Z_]//g")
            fi
            ;;
        *)
            cat $FileName | sed -n "1,10p" | grep -Eiq ".*new Env\(.*\)"
            if [ $? -eq 0 ]; then
                local Tmp=$(grep "new Env(" $FileName | grep -Ei ".*new Env\(.*\)" | head -1 | perl -pe "{s|.*nv\([\'\"](.*)[\'\"]\).*|\1|g}")
            else
                local Tmp=$(grep -E "^脚本名称" $FileName | head -1 | awk -F "[\'\":,：]" '{print $2}' | awk -F "[\'\":,：]" '{print $1}')
            fi
            ;;
        esac
        if [[ ${Tmp} ]]; then
            ScriptName=${Tmp}
        else
            ScriptName="<未知>"
        fi
    }

    local CurrentDir=$(pwd)
    local Input3 Input4 Input5 ScriptType Tmp1 Tmp2
    local RunFile=$RootDir/.runall_tmp.sh
    [ -f $RunFile ] && rm -rf $RunFile
    case ${ARCH} in
    armv7l | armv6l)
        ScriptType=".js\b"
        ;;
    *)
        if [ -x /usr/bin/python3 ]; then
            Tmp1="|\.py\b"
        else
            Tmp1=""
        fi
        if [ -x /usr/bin/ts-node ]; then
            Tmp2="|\.ts\b"
        else
            Tmp2=""
        fi
        ScriptType="\.js\b${Tmp1}${Tmp2}"
        ;;
    esac
    ## 内置规则
    ShieldingScripts="jd_update\.js|env_copy\.js|index\.js|ql\.js|jCkSeq\.js|jd_CheckCK\.js|jd_disable\.py|jd_updateCron\.ts|scripts_check_dependence\.py|UpdateUIDtoRemark\.js|magic\.|test\.|wskey\.|h5\.js|h5st\.js|getToken\.js|telecom\.py|main\.py|depend\.py"
    ShieldingKeywords="AGENTS|^TS_|Cookie|cookie|Token|ShareCodes|sendNotify\.|^JDJR|Validator|validate|ZooFaker|MovementFaker|tencentscf|^api_test|^app\.|^main\.|\.bak\b|jdEnv|identical|${ShieldingScripts}"

    echo -e "\n❖ ${BOLD}RunAll${PLAIN}\n"
    echo -e '1)   指定路径下的所有脚本（非递归）'
    echo -e '2)   个人目录下的所有脚本（scripts）'
    while true; do
        read -p "$(echo -e "\n${BOLD}└ 请选择执行脚本范围 [ 1-4 ]：${PLAIN}")" Input3
        case $Input3 in
        1)
            import sync
            count_reposum
            if [[ $RepoSum -ge 1 ]]; then
                echo -e "\n❖ 检测到的脚本仓库："
                ls $RepoDir | egrep -v "node_modules|package" | perl -pe "{s|^|$RepoDir/|g}"
                echo -e "\n${GREEN}Tips${PLAIN}：可以指定任何一个目录并非仅限于上方检测到的仓库"
            fi
            while true; do
                read -p "$(echo -e "\n${BOLD}└ 请输入绝对路径：${PLAIN}")" Input4
                local AbsolutePath=$(echo "$Input4" | perl -pe "{s|/arcadia/||; s|^*|$RootDir/|;}")
                if [[ $Input4 ]] && [ -d ${AbsolutePath} ]; then
                    break
                else
                    echo -e "\n$ERROR 目录不存在或输入有误！"
                fi
            done
            ls ${AbsolutePath} | egrep "${ScriptType}" | grep -Ev "/|${ShieldingKeywords}" | perl -pe "{s|^|${AbsolutePath}/|g; s|//|/|;}" | sort -u 2>/dev/null >$RunFile
            local WorkDir=${AbsolutePath}
            break
            ;;
        2)
            local WorkDir=$ScriptsDir
            ls $ScriptsDir | egrep "${ScriptType}" | grep -Ev "/|${ShieldingKeywords}" | sort -u 2>/dev/null >$RunFile
            break
            ;;
        esac
        echo -e "\n$ERROR 输入错误！"
    done
    if [ -s $RunFile ]; then
        ## 去除不适合在此执行的常见脚本
        local ExcludeScripts="bean_change jd_delCoupon jd_family"
        for del in ${ExcludeScripts}; do
            sed -i "/$del/d" $RunFile
        done
        ## 列出选中脚本清单
        cd $WorkDir
        local ListFiles=($(
            cat $RunFile | perl -pe '{s|^.*/||g;}'
        ))
        echo -e "\n❖ 当前选择的脚本："
        for ((i = 0; i < ${#ListFiles[*]}; i++)); do
            query_script_name ${ListFiles[i]}
            echo -e "$(($i + 1)).${ScriptName}：${ListFiles[i]}"
        done
        cd $CurrentDir
        read -p "$(echo -e "\n${BOLD}└ 请确认是否继续? [Y/n] ${PLAIN}")" Input5
        [ -z ${Input5} ] && Input5=Y
        case $Input5 in
        [Yy] | [Yy][Ee][Ss])
            choose_run_mod
            ## 补全命令
            sed -i "s/^/$TaskCmd run &/g" $RunFile
            sed -i "s/$/&${RunOptions}/g" $RunFile
            sed -i '1i\#!/bin/env bash' $RunFile
            ## 执行前提示
            echo -e "\n$TIP ${BLUE}Ctrl + Z${PLAIN} 跳过执行当前脚本（若中途卡住可尝试跳过），${BLUE}Ctrl + C${PLAIN} 终止执行全部任务\n"
            ## 等待动画
            local spin=('.   ' '..  ' '... ' '....')
            local n=0
            while (true); do
                ((n++))
                echo -en "\033[?25l$WORKING 倒计时 3 秒后开始${spin[$((n % 4))]}${PLAIN}" "\r"
                sleep 0.3
                [ $n = 10 ] && echo -e "\033[?25h\n${PLAIN}" && break
            done
            ## 开始执行
            echo -e "[$(date "+%Y-%m-%d %H:%M:%S")] 全部执行开始\n"
            source $RunFile
            echo -e "\n[$(date "+%Y-%m-%d %H:%M:%S")] 全部执行完毕\n"
            ;;
        [Nn] | [Nn][Oo])
            echo -e "\n$ERROR 中途退出！\n"
            ;;
        *)
            echo -e "\n$ERROR 输入错误，请重新执行！\n"
            ;;
        esac
    else
        echo -e "\n$ERROR 该路径下未检测到任何脚本，请检查原因后重试！\n"
    fi
    rm -rf $RunFile
}

source ${ARCADIA_DIR}/shell/core/main.sh

main
