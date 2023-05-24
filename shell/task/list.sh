#!/bin/bash
## Modified: 2023-05-21

## 列出本地脚本清单功能
# task list
function List_Local_Scripts() {
    local ScriptType Tmp1 Tmp2
    ## 根据处理器架构判断匹配脚本类型
    case ${ARCH} in
    armv7l | armv6l)
        ScriptType="\.js$"
        ;;
    *)
        if [ -x /usr/bin/python3 ]; then
            Tmp1="|\.py$"
        else
            Tmp1=""
        fi
        if [ -x /usr/bin/ts-node ]; then
            Tmp2="|\.ts$"
        else
            Tmp2=""
        fi
        ScriptType="\.js\$${Tmp1}${Tmp2}"
        ;;
    esac

    ## 列出所有 Own 仓库中的脚本
    function List_Own() {
        local FileName FileDir Tmp1 Tmp2 Tmp3 repo_num
        Import_Config_Not_Check

        if [[ ${OwnRepoUrl1} ]]; then
            for ((i = 1; i <= 0x64; i++)); do
                Tmp1=OwnRepoUrl$i
                Tmp2=${!Tmp1}
                [[ $Tmp2 ]] && RepoSum=$i || break
            done

            if [[ $RepoSum -ge 1 ]]; then
                for ((i = 1; i <= $RepoSum; i++)); do
                    repo_num=$((i - 1))
                    Tmp1=OwnRepoUrl$i
                    array_own_repo_url[$repo_num]=${!Tmp1}
                    array_own_repo_dir[$repo_num]=$(echo ${array_own_repo_url[$repo_num]} | sed "s|\.git||g" | awk -F "/|:" '{print $((NF - 1)) "_" $NF}')
                    Tmp3=OwnRepoPath$i
                    if [[ -z ${!Tmp3} ]]; then
                        array_own_repo_path[$repo_num]="$ReposDir/${array_own_repo_dir[$repo_num]}"
                    else
                        array_own_repo_path[$repo_num]="$ReposDir/${array_own_repo_dir[$repo_num]}/${!Tmp3}"
                    fi
                done
            fi

            local ListFiles=($(
                for ((i = 1; i <= $RepoSum; i++)); do
                    repo_num=$((i - 1))
                    ls ${array_own_repo_path[repo_num]} 2>/dev/null | grep -E "${ScriptType}" | grep -Ev "/|${ShieldingKeywords}" | sed "s|^|${array_own_repo_path[repo_num]}/|g"
                done
                if [[ ${#RawFile[*]} -ge 1 ]]; then
                    ls $RawDir 2>/dev/null | grep -E "${ScriptType}" | grep -Ev "/|${ShieldingKeywords}" | sed "s|^|$RawDir/|g"
                fi
            ))

            echo -e "\n❖ Own 扩展脚本："
            for ((i = 0; i < ${#ListFiles[*]}; i++)); do
                FileName=${ListFiles[i]##*/}
                FileDir=$(echo ${ListFiles[i]} | awk -F "$FileName" '{print$1}')
                cd $FileDir
                Query_ScriptName $FileName
                printf "%4s  %-50s %s\n" "$(($i + 1))" "${ListFiles[i]:8}" "${ScriptName}"
            done
        fi
    }

    ## 列出 scripts 目录下的第三方脚本
    function List_Other() {
        if [ -d $ScriptsDir/.git ]; then
            cd $ScriptsDir
            local ListFiles=($(
                ls | grep -E "${ScriptType}" | grep -Ev "$(git ls-files)|${ShieldingKeywords}"
            ))
            if [ ${#ListFiles[*]} != 0 ]; then
                echo -e "\n❖ 第三方脚本："
                for ((i = 0; i < ${#ListFiles[*]}; i++)); do
                    Query_ScriptName ${ListFiles[i]}
                    printf "%3s  %-36s   %s\n" "$(($i + 1))" "${ListFiles[i]}" "${ScriptName}"
                done
            fi
        fi
    }

    ## 列出指定目录下的脚本
    function List_Designated() {
        local InputContent WorkDir PwdTmp LengthTmp spacesNums
        ## 去掉传入参数中的最后一个/
        echo $1 | grep "/$" -q
        if [ $? -eq 0 ]; then
            InputContent=${1%?}
        else
            InputContent=$1
        fi
        ## 判断传入参数
        echo ${InputContent} | grep "\/" -q
        if [ $? -eq 0 ]; then
            ## 判定传入的是绝对路径还是相对路径
            echo ${InputContent} | grep "^$RootDir" -q
            if [ $? -eq 0 ]; then
                WorkDir=${InputContent}
            else
                ## 处理上级目录
                echo ${InputContent} | grep "\.\./" -q
                if [ $? -eq 0 ]; then
                    PwdTmp=$(pwd | perl -pe "{s|/$(pwd | awk -F '/' '{printf$NF}')||g;}")
                    WorkDir=$(echo "${InputContent}" | sed "s|\.\./|${PwdTmp}/|g")
                else
                    WorkDir=$(echo "${InputContent}" | sed "s|\.\/||g; s|^*|$(pwd)/|g")
                fi
            fi
        else
            if [[ "${InputContent}" = "." ]]; then
                WorkDir="$(pwd)"
            elif [[ "${InputContent}" = "./" ]]; then
                WorkDir="$(pwd)"
            else
                WorkDir="$(pwd)/${InputContent}"
            fi
        fi
        ## 判断路径是否存在
        if [ -d $WorkDir ]; then
            if [ "$(ls -A $WorkDir | grep -E "${ScriptType}")" = "" ]; then
                if [ "$(ls -A $WorkDir)" = "" ]; then
                    echo -e "\n$ERROR 路径 ${BLUE}$WorkDir${PLAIN} 为空！\n"
                else
                    echo -e "\n$FAIL 在 ${BLUE}$WorkDir${PLAIN} 路径下未检测到任何脚本！\n"
                fi
                exit ## 终止退出
            fi
        else
            Output_Error "目标路径 ${BLUE}$WorkDir${PLAIN} 不存在，请重新确认！"
        fi

        cd $WorkDir
        ## 打印仓库地址
        if [ -d .git ]; then
            local RemoteUrl=$(git remote -v | head -n 1 | awk -F ' ' '{print$2}')
            echo "$RemoteUrl" | grep "git@" -q
            if [ $? -ne 0 ]; then
                echo -e "\n❖ 远程仓库地址: ${BLUE}${RemoteUrl%\.*}${PLAIN}"
            fi
        fi
        local ListFiles=(
            $(ls | grep -E "${ScriptType}" | grep -Ev "${ShieldingKeywords}")
        )
        [ ${#ListFiles[*]} = 0 ] && exit ## 终止退出
        if [[ ${#ListFiles[*]} -ge "10" ]]; then
            if [[ ${#ListFiles[*]} -ge "100" ]]; then
                TmpNum="3"
            else
                TmpNum="2"
            fi
        else
            TmpNum="1"
        fi
        printf "\n${BLUE}%$((28 + ${TmpNum}))s${PLAIN} ${BLUE}%29s${PLAIN}  ${BLUE}%6s${PLAIN}             ${BLUE}%s${PLAIN}\n" "[文件名称]" "[修改时间]" " [大小]" "[脚本名称]"

        for ((i = 0; i < ${#ListFiles[*]}; i++)); do
            echo ''
            Query_ScriptName ${ListFiles[i]}
            Query_ScriptSize ${ListFiles[i]}
            Query_ScriptEditTimes ${ListFiles[i]}
            LengthTmp1=$(StringLength $(echo ${ListFiles[i]} | perl -pe '{s|[0-9a-zA-Z\,\.\=\:\_\-\(\)\[\]\<\>\~]||g;}'))
            spacesNums1=$(($((34 - ${LengthTmp1} - ${#ListFiles[i]})) / 2))
            for ((a = 1; a <= ${spacesNums1}; a++)); do
                ListFiles[i]=" ${ListFiles[i]}"
            done
            LengthTmp2=$(StringLength $(echo ${ScriptName} | perl -pe '{s|[0-9a-zA-Z\,\.\=\:\_\-\(\)\[\]\<\>\~]||g;}'))
            spacesNums2=$(($((34 - ${LengthTmp2} - ${#ScriptName})) / 2))
            for ((a = 1; a <= ${spacesNums2}; a++)); do
                ScriptName=" ${ScriptName}"
            done
            printf "%${TmpNum}s  %-$((34 + ${LengthTmp1}))s %14s %6s  %-$((34 + ${LengthTmp2}))s\n" "$(($i + 1))" "${ListFiles[i]}" "$(echo ${ScriptEditTimes} | sed "s/ /  /g")" "${ScriptSize}" "${ScriptName}"
        done
    }

    case $# in
    0)
        List_Own
        List_Other
        ;;
    1)
        List_Designated $1
        ;;
    esac
    echo ''
}
