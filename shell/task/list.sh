#!/bin/bash
## Modified: 2023-05-27

## 列出本地脚本清单功能
# task list <path>
function list_local_scripts() {
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
    ## 内置规则
    ShieldingScripts="jd_update\.js|env_copy\.js|index\.js|ql\.js|jCkSeq\.js|jd_CheckCK\.js|jd_disable\.py|jd_updateCron\.ts|scripts_check_dependence\.py|UpdateUIDtoRemark\.js|magic\.|test\.|wskey\.|h5\.js|h5st\.js|getToken\.js|telecom\.py|main\.py|depend\.py"
    ShieldingKeywords="AGENTS|^TS_|Cookie|cookie|Token|ShareCodes|sendNotify\.|^JDJR|Validator|validate|ZooFaker|MovementFaker|tencentscf|^api_test|^app\.|^main\.|\.bak\b|jdEnv|identical|${ShieldingScripts}"

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

    ## 查询脚本大小，$1 为脚本名
    function query_script_size() {
        local FileName=$1
        ScriptSize=$(ls -lth | grep "\b$FileName\b" | awk -F ' ' '{print$5}')
    }

    ## 查询脚本修改时间，$1 为脚本名
    function query_script_edittimes() {
        local FileName=$1
        local Data=$(ls -lth | grep "\b$FileName\b" | awk -F 'root' '{print$NF}')
        local MonthTmp=$(echo $Data | awk -F ' ' '{print$2}')
        local Month="$(echo '{"Jan": "1", "Feb": "2", "Mar": "3", "Apr": "4", "May": "5", "Jun": "6", "Jul": "7", "Aug": "8", "Sept": "9", "Oct": "10", "Nov": "11", "Dec": "12"}' | jq -r ".${MonthTmp}")"
        local Day=$(echo $Data | awk -F ' ' '{print$3}')
        if [[ $Day -lt "10" ]]; then
            Day="0$Day"
        fi
        local Time=$(echo $Data | awk -F ' ' '{print$4}')
        ScriptEditTimes="$Month-$Day $Time"
    }

    ## 列出指定目录下的脚本
    function list_designated() {
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
            output_error "目标路径 ${BLUE}$WorkDir${PLAIN} 不存在，请重新确认！"
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
        printf "\n${BLUE}%$((28 + ${TmpNum}))s${PLAIN} ${BLUE}%30s${PLAIN} ${BLUE}%6s${PLAIN}             ${BLUE}%s${PLAIN}\n" "[文件名称]" "[修改时间]" " [大小]" "[脚本名称]"
        echo ''

        for ((i = 0; i < ${#ListFiles[*]}; i++)); do
            query_script_name ${ListFiles[i]}
            query_script_size ${ListFiles[i]}
            query_script_edittimes ${ListFiles[i]}
            LengthTmp1=$(string_length $(echo ${ListFiles[i]} | perl -pe '{s|[0-9a-zA-Z\,\.\=\:\_\-\(\)\[\]\<\>\~]||g;}'))
            spacesNums1=$(($((34 - ${LengthTmp1} - ${#ListFiles[i]})) / 2))
            for ((a = 1; a <= ${spacesNums1}; a++)); do
                ListFiles[i]=" ${ListFiles[i]}"
            done
            LengthTmp2=$(string_length $(echo ${ScriptName} | perl -pe '{s|[0-9a-zA-Z\,\.\=\:\_\-\(\)\[\]\<\>\~]||g;}'))
            spacesNums2=$(($((34 - ${LengthTmp2} - ${#ScriptName})) / 2))
            for ((a = 1; a <= ${spacesNums2}; a++)); do
                ScriptName=" ${ScriptName}"
            done
            printf "%${TmpNum}s  %-$((34 + ${LengthTmp1}))s %14s %6s  %-$((34 + ${LengthTmp2}))s\n" "$(($i + 1))" "${ListFiles[i]}" "${ScriptEditTimes}" "${ScriptSize}" "${ScriptName}"
        done
    }

    list_designated "$1"
    echo ''
}
