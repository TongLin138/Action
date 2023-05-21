#!/bin/bash
## Modified: 2023-05-21

## 账号控制功能
# task cookie
function Accounts_Control() {
    local SUCCESS_ICON="[✔]"
    local FAIL_ICON="[×]"
    local Valid="${GREEN}${SUCCESS_ICON}${PLAIN}"
    local Invalid="${RED}${FAIL_ICON}${PLAIN}"
    local INTERFACE_URL="https://me-api.jd.com/user_new/info/GetJDUserInfoUnion"

    ## 检测
    function CheckCookie() {
        local InputContent=$1
        local Check="$(curl -s --noproxy "*" "${INTERFACE_URL}" -H "cookie: ${InputContent}" | jq -r '.retcode' 2>/dev/nul)"
        case $Check in
        0)
            echo -e "${Valid}"
            ;;
        1001)
            echo -e "${Invalid}"
            ;;
        *)
            echo -e "${RED}未知${PLAIN}"
            ;;
        esac
    }

    case $1 in
    ## 检测账号是否有效
    check)
        ## 导入配置文件
        Import_Config

        ## 检测全部账号
        function CheckCookie_All() {
            local TmpA TmpB pt_pin pt_pin_temp FormatPin EscapePin EscapePin_Length_Add State CookieUpdatedDate UpdateTimes TmpDays TmpTime Tmp1 Tmp2 Tmp3 num

            ## 统计账号数量
            Count_UserSum

            ## 生成 pt_pin 数组
            for ((user_num = 1; user_num <= $UserSum; user_num++)); do
                TmpA=Cookie$user_num
                TmpB=${!TmpA}
                i=$(($user_num - 1))
                pt_pin_temp=$(echo ${TmpB} | perl -pe "{s|.*pt_pin=([^; ]+)(?=;?).*|\1|}")
                pt_pin[i]=$pt_pin_temp
            done

            echo -e "\n$WORKING 当前本地共有 ${BLUE}$UserSum${PLAIN} 个账号，开始检测...\n"

            ## 汇总输出
            for ((m = 0; m < $UserSum; m++)); do
                ## 定义格式化后的pt_pin
                FormatPin=$(echo ${pt_pin[m]} | sed "s|[\.\<\>\/\[\]\!\@\#\$\%\^\&\*\(\)\-\+]|\\$&|g")
                ## 转义pt_pin中的汉字
                EscapePin=$(ParseEncodeStringToChinese "${pt_pin[m]}")
                ## 定义pt_pin中的长度（受限于编码，汉字多占1长度，短横杠长度为0）
                EscapePin_Length_Add=$(StringLength $(echo ${EscapePin} | sed "s|[0-9a-zA-Z\.\=\:\_-]||g"))
                ## 定义账号状态
                State="$(CheckCookie $(grep -E "Cookie[1-9].*${FormatPin}" $FileConfUser | awk -F "[\"\']" '{print$2}'))"
                ## 查询上次更新时间并计算过期时间
                CookieUpdatedDate=$(grep "\#.*上次更新：" $FileConfUser | grep "${FormatPin}" | head -1 | awk -F '上次更新：' '{print$NF}' | awk -F '  ' '{print$1}' | sed "s|;||g")
                if [[ ${CookieUpdatedDate} ]]; then
                    UpdateTimes="${CookieUpdatedDate}"
                else
                    UpdateTimes="未知"
                fi
                sleep 1 ## 降低频率以减少出现因查询太快导致API请求失败的情况
                num=$((m + 1))
                ## 格式化输出
                printf "%-3s ${BLUE}%-$((18 + ${EscapePin_Length_Add}))s${PLAIN} %-s${BLUE}%-s${PLAIN}\n" "$num." "${EscapePin}" " ${State}   上次更新: " "${UpdateTimes}"
            done

            ## 检测 wskey
            ## 统计 account.json 的数组总数，即最多配置了多少个账号，即使数组为空值
            local ArrayLength=$(cat $FileAccountUser | jq 'length')
            if [[ ${ArrayLength} -ge 1 ]]; then
                num=1
                for ((i = 0; i < ${ArrayLength}; i++)); do
                    PT_PIN_TMP=$(cat $FileAccountUser | jq -r ".[$i] | .pt_pin" | sed "s/null//g; s/ //g")
                    WS_KEY_TMP=$(cat $FileAccountUser | jq -r ".[$i] | .ws_key" | sed "s/null//g; s/ //g")
                    ## 没有配置相应值就跳出当前循环
                    [ -z ${PT_PIN_TMP} ] && continue
                    if [ -z ${WS_KEY_TMP} ]; then
                        continue
                    else
                        echo -e "\n$WORKING 开始检测 wskey 状态...\n"
                        break
                    fi
                done

                for ((i = 0; i < ${ArrayLength}; i++)); do
                    local PT_PIN_TMP=$(cat $FileAccountUser | jq -r ".[$i] | .pt_pin" | sed "s/null//g; s/ //g")
                    local WS_KEY_TMP=$(cat $FileAccountUser | jq -r ".[$i] | .ws_key" | sed "s/null//g; s/ //g")
                    ## 没有配置相应值就跳出当前循环
                    [ -z ${PT_PIN_TMP} ] && continue
                    [ -z ${WS_KEY_TMP} ] && continue
                    ## 转义pt_pin中的汉字
                    EscapePin=$(ParseEncodeStringToChinese "${PT_PIN_TMP}")
                    ## 定义pt_pin中的长度（受限于编码，汉字多占1长度，短横杠长度为0）
                    EscapePin_Length_Add=$(StringLength $(echo ${EscapePin} | sed "s|[0-9a-zA-Z\.\=\:\_-]||g"))
                    ## 打印
                    printf "%-3s ${BLUE}%-$((19 + ${EscapePin_Length_Add}))s${PLAIN} %-s\n" "$num." "${EscapePin}" "$(CheckCookie "wskey=${WS_KEY_TMP}")"
                    sleep 1 ## 降低频率以减少出现因查询太快导致API请求失败的情况
                    let num++
                done
            fi
        }

        ## 检测指定账号
        function CheckCookie_Designated() {
            local pt_pin FormatPin State CookieUpdatedDate UpdateTimes TmpDays TmpTime Tmp1 Tmp2 Tmp3
            local UserNum=$1
            ## 判定账号是否存在
            Account_ExistenceJudgment ${UserNum}
            echo -e "\n$WORKING 开始检测第 ${BLUE}${UserNum}${PLAIN} 个账号...\n"
            ## 定义pt_pin
            pt_pin=$(grep "Cookie${UserNum}=" $FileConfUser | head -1 | awk -F "[\"\']" '{print$2}' | perl -pe "{s|.*pt_pin=([^; ]+)(?=;?).*|\1|}")
            FormatPin=$(echo ${pt_pin} | sed "s|[\.\<\>\/\[\]\!\@\#\$\%\^\&\*\(\)\-\+]|\\$&|g")
            ## 转义 pt_pin 中的 UrlEncode 输出中文
            EscapePin=$(ParseEncodeStringToChinese "${FormatPin}")
            echo -e "账号：${BLUE}${EscapePin}${PLAIN}\n"
            ## 定义账号状态
            State="$(CheckCookie $(grep -E "Cookie[1-9].*${FormatPin}" $FileConfUser | awk -F "[\"\']" '{print$2}'))"
            ## 查询上次更新时间并计算过期时间
            CookieUpdatedDate=$(grep "\#.*上次更新：" $FileConfUser | grep "${FormatPin}" | head -1 | awk -F '上次更新：' '{print$NF}' | awk -F '  ' '{print$1}' | sed "s|;||g")
            if [[ ${CookieUpdatedDate} ]]; then
                UpdateTimes="${CookieUpdatedDate}"
            else
                UpdateTimes="未知"
            fi
            ## 输出
            echo -en "Cookie => ${State}"

            ## 检测 wskey
            grep -q "${pt_pin}" $FileAccountUser
            if [[ $? -eq 0 ]]; then
                ## 统计 account.json 数组中的元素数量，即最多配置了多少个账号，即使元素为空值
                local ArrayLength=$(cat $FileAccountUser | jq 'length')

                for ((i = 0; i < ${ArrayLength}; i++)); do
                    local PT_PIN_TMP=$(cat $FileAccountUser | jq -r ".[$i] | .pt_pin" | sed "s/null//g; s/ //g")
                    local WS_KEY_TMP=$(cat $FileAccountUser | jq -r ".[$i] | .ws_key" | sed "s/null//g; s/ //g")
                    ## 没有配置相应值就跳出当前循环
                    [ -z ${PT_PIN_TMP} ] && continue
                    if [[ ${PT_PIN_TMP} == ${pt_pin} ]]; then
                        ## 输出
                        echo -en "   ws_key => $(CheckCookie "wskey=${WS_KEY_TMP}")"
                        break
                    else
                        continue
                    fi
                    [ -z ${WS_KEY_TMP} ] && continue
                done
            fi
            echo -e "\n上次更新: ${BLUE}${UpdateTimes}${PLAIN}"
        }

        ## 先检测网络环境
        for ((n = 1; n <= 3; n++)); do
            if [[ "$(curl -I -s --connect-timeout 5 ${INTERFACE_URL} -w \%{http_code} | tail -n 1)" == "200" ]]; then
                break
            fi
            sleep 0.5
            if [[ $n -eq 3 ]]; then
                echo -e "$ERROR API 请求失败，请检查当前网络环境！"
                exit
            fi
        done

        ## 汇总
        case $# in
        1)
            CheckCookie_All
            ;;
        2)
            CheckCookie_Designated $2
            ;;
        esac

        echo -e "\n$COMPLETE 检测完毕\n"
        ;;

    ## 使用 WSKEY 更新账号
    update)
        Import_Config_Not_Check "UpdateCookies"
        local ExitStatus LogPath LogFile
        [ -f $FileSendMark ] && rm -rf $FileSendMark

        ## 更新 sign 签名
        function UpdateSign() {
            Make_Dir $SignDir
            if [ ! -d $SignDir/.git ]; then
                git clone -b master ${SignsRepoGitUrl} $SignDir >/dev/null
                ExitStatus=$?
            else
                cd $SignDir
                if [[ $(date "+%-H") -eq 1 || $(date "+%-H") -eq 9 || $(date "+%-H") -eq 17 ]] && [[ $(date "+%-S") -eq 0 ]]; then
                    local Tmp=$((${RANDOM} % 10))
                    echo -en "\n检测到当前处于整点，已启用随机延迟，此任务将在 $Tmp 秒后开始执行..."
                    sleep $Tmp
                    echo ''
                fi
                git fetch --all >/dev/null
                ExitStatus=$?
                git reset --hard origin/master >/dev/null
            fi
        }

        ## 更新全部账号
        function UpdateCookie_All() {
            local UserNum PT_PIN_TMP WS_KEY_TMP FormatPin EscapePin EscapePin_Length_Add CookieTmp LogFile
            ## 统计 account.json 的数组总数，即最多配置了多少个账号，即使数组为空值
            local ArrayLength=$(cat $FileAccountUser | jq 'length')
            ## 生成 pt_pin 数组
            local pt_pin_array=(
                $(cat $FileAccountUser | jq -r '.[] | {pt_pin:.pt_pin,} | .pt_pin' | grep -Ev "pt_pin的值|null|^$")
            )
            if [[ ${#pt_pin_array[@]} -ge 1 ]]; then
                local num=1
                ## 定义日志文件路径
                LogFile="${LogPath}/$(date "+%Y-%m-%d-%H-%M-%S").log"
                echo -e "\n$WORKING 检测到已配置 ${BLUE}${#pt_pin_array[@]}${PLAIN} 个账号，开始更新...\n"
                ## 记录执行开始时间
                echo -e "[$(date "${TIME_FORMAT}" | cut -c1-23)] 执行开始\n" >>${LogFile}

                for ((i = 0; i < ${ArrayLength}; i++)); do
                    PT_PIN_TMP=$(cat $FileAccountUser | jq -r ".[$i] | .pt_pin" | sed "s/null//g; s/ //g")
                    WS_KEY_TMP=$(cat $FileAccountUser | jq -r ".[$i] | .ws_key" | sed "s/null//g; s/ //g")
                    ## 没有配置相应值就跳出当前循环
                    [ -z ${PT_PIN_TMP} ] && continue
                    [ -z ${WS_KEY_TMP} ] && continue
                    ## 声明变量
                    export JD_PT_PIN=${PT_PIN_TMP}
                    ## 定义格式化后的pt_pin
                    FormatPin=$(echo ${PT_PIN_TMP} | sed "s|[\.\<\>\/\[\]\!\@\#\$\%\^\&\*\(\)\-\+]|\\$&|g")
                    ## 转义pt_pin中的汉字
                    EscapePin=$(ParseEncodeStringToChinese "${PT_PIN_TMP}")
                    ## 定义pt_pin中的长度（受限于编码，汉字多占1长度，短横杠长度为0）
                    EscapePin_Length_Add=$(StringLength $(echo ${EscapePin} | sed "s|[0-9a-zA-Z\.\=\:\_ -]||g"))
                    ## 执行脚本
                    if [[ ${EnableGlobalProxy} == true ]]; then
                        node -r 'global-agent/bootstrap' ${FileUpdateCookie##*/} &>>${LogFile} &
                    else
                        node ${FileUpdateCookie##*/} &>>${LogFile} &
                    fi
                    wait $! 2>/dev/null
                    ## 判断结果
                    if [[ $(grep "Cookie => \[${FormatPin}\]  更新成功" ${LogFile}) ]]; then
                        ## 格式化输出
                        printf "%-3s ${BLUE}%-$((20 + ${EscapePin_Length_Add}))s${PLAIN} ${GREEN}%-s${PLAIN}\n" "$num." "${EscapePin}" "${SUCCESS_ICON}"
                    else
                        printf "%-3s ${BLUE}%-$((20 + ${EscapePin_Length_Add}))s${PLAIN} ${RED}%-s${PLAIN}\n" "$num." "${EscapePin}" "${FAIL_ICON}"
                        ## 账号更新异常告警与状态检测
                        local UserNum=$(grep -E "Cookie[0-9]{1,3}=.*pt_pin=${FormatPin}" $FileConfUser | awk -F '=' '{print$1}' | awk -F 'Cookie' '{print$2}')
                        local CheckTmp="$(curl -s --noproxy "*" "${INTERFACE_URL}" -H "cookie: wskey=${WS_KEY_TMP}" | jq -r '.retcode')"
                        if [[ ${CheckTmp} == "0" ]]; then
                            echo -e "    该账号的WSKEY状态 => ${Valid}\n"
                        elif [[ ${CheckTmp} == "1001" ]]; then
                            echo -e "    该账号的WSKEY状态 => ${Invalid}\n"
                        else
                            echo -e "    该账号的WSKEY状态 => ${RED}未知${PLAIN}\n"
                        fi
                        if [[ ${EnableCookieUpdateFailureNotify} == true ]]; then
                            if [[ ${CheckTmp} == "1001" ]]; then
                                Notify "账号更新异常通知" "检测到第$UserNum个账号 ${EscapePin} 的 wskey 已经失效，导致未能正常更新，请尽快处理"
                            else
                                Notify "账号更新异常通知" "检测到第$UserNum个账号 ${EscapePin} 的 wskey 更新出现异常，请尽快处理"
                            fi
                            echo ''
                        fi
                    fi
                    let num++
                done
                ## 优化日志排版
                sed -i '/更新Cookies,.*\!/d; /^$/d; s/===.*//g' ${LogFile}
                ## 记录执行结束时间
                echo -e "\n[$(date "${TIME_FORMAT}" | cut -c1-23)] 执行结束" >>${LogFile}
                ## 推送通知
                grep "Cookie => \[" ${LogFile} >>$FileSendMark
                if [[ $(grep "Cookie =>" ${LogFile}) ]]; then
                    ## 转义中文用户名
                    local tmp_array=(
                        $(cat $FileSendMark | grep -o "\[.*\%.*\]" | sed "s|\[||g; s|\]||g")
                    )
                    if [[ ${#tmp_array[@]} -ge 1 ]]; then
                        for ((i = 1; i <= ${#tmp_array[@]}; i++)); do
                            UserNum=$((i - 1))
                            EscapePin=$(ParseEncodeStringToChinese "${tmp_array[$UserNum]}")
                            sed -i "s/${tmp_array[$UserNum]}/${EscapePin}/g" $FileSendMark
                        done
                    fi
                    ## 格式化通知内容
                    perl -pe '{s|Cookie => ||g; s|\[||g; s|\]|\ \ \-|g}' -i $FileSendMark
                    echo "" >>$FileSendMark
                    echo -e "\n$COMPLETE 更新完毕\n"
                else
                    echo -e "\n$ERROR 更新异常，请检查当前网络环境并查看 ${BLUE}log/UpdateCookies${PLAIN} 目录下的运行日志！\n"
                fi
            else
                echo -e "\n$ERROR 请先在 ${BLUE}$FileAccountUser${PLAIN} 中配置好 ${BLUE}pt_pin${PLAIN} ！\n"
                exit ## 终止退出
            fi
        }

        ## 更新指定账号
        function UpdateCookie_Designated() {
            local UserNum=$1
            local ArrayNum PT_PIN_TMP WS_KEY_TMP FormatPin EscapePin CookieTmp LogFile
            local COOKIE_TMP=Cookie$UserNum
            ## 判定账号是否存在
            Account_ExistenceJudgment $UserNum
            PT_PIN_TMP=$(echo ${!COOKIE_TMP} | perl -pe "{s|.*pt_pin=([^; ]+)(?=;?).*|\1|}")
            ## 定义格式化后的pt_pin
            FormatPin="$(echo ${PT_PIN_TMP} | perl -pe '{s|[\.\<\>\/\[\]\!\@\#\$\%\^\&\*\(\)\-\+]|\\$&|g;}')"
            ## 判定在 account.json 中是否存在该 pt_pin
            grep "${FormatPin}" -q $FileAccountUser
            if [ $? -eq 0 ]; then
                ArrayNum=$(($(cat $FileAccountUser | jq 'map_values(.pt_pin)' | grep -n "${FormatPin}" | awk -F ':' '{print$1}') - 2))
                WS_KEY_TMP=$(cat $FileAccountUser | jq -r ".[$ArrayNum] | .ws_key" | sed "s/null//g; s/ //g")
                ## 没有配置 ws_key 就退出
                if [ -z ${WS_KEY_TMP} ]; then
                    echo -e "\n$ERROR 请先在 ${BLUE}$FileAccountUser${PLAIN} 中配置该账号的 ${BLUE}ws_key${PLAIN} ！\n"
                    exit ## 终止退出
                else
                    ## 定义日志文件路径
                    LogFile="${LogPath}/$(date "+%Y-%m-%d-%H-%M-%S")_$UserNum.log"
                    echo -e "\n$WORKING 开始更新第 ${BLUE}$UserNum${PLAIN} 个账号...\n"
                    ## 声明变量
                    export JD_PT_PIN=${PT_PIN_TMP}
                    ## 转义pt_pin中的汉字
                    EscapePin=$(ParseEncodeStringToChinese "${PT_PIN_TMP}")
                    ## 记录执行开始时间
                    echo -e "[$(date "${TIME_FORMAT}" | cut -c1-23)] 执行开始\n" >>${LogFile}
                    ## 执行脚本
                    if [[ ${EnableGlobalProxy} == true ]]; then
                        node -r 'global-agent/bootstrap' ${FileUpdateCookie##*/} &>>${LogFile} &
                    else
                        node ${FileUpdateCookie##*/} &>>${LogFile} &
                    fi
                    wait $! 2>/dev/null
                    ## 优化日志排版
                    sed -i '/更新Cookies,.*\!/d; /^$/d; s/===.*//g' ${LogFile}
                    ## 记录执行结束时间
                    echo -e "\n[$(date "${TIME_FORMAT}" | cut -c1-23)] 执行结束" >>${LogFile}
                    ## 判断结果
                    if [[ $(grep "Cookie => \[${FormatPin}\]  更新成功" ${LogFile}) ]]; then
                        echo -e "${BLUE}${EscapePin}${PLAIN}  ${Valid}"
                        ## 打印 Cookie
                        # echo -e "Cookie：$(grep -E "^Cookie[1-9].*pt_pin=${FormatPin}" $FileConfUser | awk -F "[\"\']" '{print$2}')\n"
                    else
                        echo -e "${BLUE}${EscapePin}${PLAIN}  ${Invalid}"
                        ## 账号状态检测
                        local CheckTmp="$(curl -s --noproxy "*" "${INTERFACE_URL}" -H "cookie: wskey=${WS_KEY_TMP}" | jq -r '.retcode')"
                        if [[ ${CheckTmp} == "0" ]]; then
                            echo -e "该账号wskey状态 => ${Valid}\n"
                        elif [[ ${CheckTmp} == "1001" ]]; then
                            echo -e "该账号wskey状态 => ${Invalid}\n"
                        else
                            echo -e "该账号wskey状态 => ${RED}未知${PLAIN}\n"
                        fi
                    fi
                    ## 推送通知
                    grep "Cookie => \[" ${LogFile} >>$FileSendMark
                    if [[ $(grep "Cookie =>" ${LogFile}) ]]; then
                        ## 转义中文用户名
                        local tmp_pt_pin=$(cat $FileSendMark | grep -o "\[.*\%.*\]" | sed "s|\[||g; s|\]||g")
                        if [[ ${tmp_pt_pin} ]]; then
                            EscapePin=$(ParseEncodeStringToChinese "${tmp_pt_pin}")
                            sed -i "s/${tmp_pt_pin}/${EscapePin}/g" $FileSendMark
                        fi
                        ## 格式化通知内容
                        perl -pe '{s|Cookie => ||g; s|\[||g; s|\]|\ \ \-|g}' -i $FileSendMark
                        echo "" >>$FileSendMark
                        echo -e "\n$COMPLETE 更新完毕\n"
                    else
                        echo -e "\n$ERROR 更新异常，请检查当前网络环境并查看 ${BLUE}log/UpdateCookies${PLAIN} 目录下的运行日志！\n"
                    fi
                fi
            else
                echo -e "\n$ERROR 请先在 ${BLUE}$FileAccountUser${PLAIN} 中配置该账号的 ${BLUE}pt_pin${PLAIN} ！\n"
                exit ## 终止退出
            fi
        }

        ## 汇总
        if [ -f $FileUpdateCookie ]; then
            if [[ $(cat $FileAccountUser | jq '.[] | {ws_key:.ws_key,}' | grep -F "\"ws_key\"" | grep -v "wskey的值" | awk -F '\"' '{print$4}' | grep -v '^$') ]]; then
                UpdateSign
                if [[ $ExitStatus -eq 0 ]]; then
                    LogPath="$LogDir/UpdateCookies"
                    Make_Dir ${LogPath}
                    cd $UtilsDir
                    case $# in
                    1)
                        UpdateCookie_All
                        ;;
                    2)
                        UpdateCookie_Designated $2
                        ;;
                    esac
                    ## 推送通知
                    [ -f $FileSendMark ] && sed -i "/未设置ws_key跳过更新/d" $FileSendMark
                    if [ -s $FileSendMark ]; then
                        [[ ${EnableCookieUpdateNotify} == true ]] && Notify "账号更新结果通知" "$(cat $FileSendMark)"
                    fi
                    [ -f $FileSendMark ] && rm -rf $FileSendMark
                else
                    echo -e "\n$FAIL 签名更新异常，请检查网络环境后重试！\n"
                fi
            else
                echo -e "\n$ERROR 请先在 ${BLUE}$FileAccountUser${PLAIN} 中配置好 ${BLUE}ws_key${PLAIN} ！\n"
            fi
        else
            echo -e "\n$ERROR 账号更新脚本不存在，请确认是否移动！\n"
        fi
        ;;
    beans)
        Import_Config
        Count_UserSum

        function getJingBeanBalanceDetail() {
            local pageNum=$1
            body="body=$(UrlEncode "{\"pageSize\": \"20\",\"page\": \"${pageNum}\"}")&appid=ld"
            curl -s -X POST "https://api.m.jd.com/client.action?functionId=getJingBeanBalanceDetail" \
                -H "Host: api.m.jd.com" \
                -H "Content-Type: application/x-www-form-urlencoded" \
                -H "Accept-Charset: UTF-8" \
                -H "User-Agent: jdapp;iPhone;9.4.4;14.3;network/4g;Mozilla/5.0 (iPhone; CPU iPhone OS 14_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148;supportJDSHWK/1" \
                -H "Cookie: ${CK}" \
                --data-raw "$body" | jq .detailList | jq -c '.[]'
        }

        function QueryBeanInfo() {
            local TMP_LOG=".tmp.log"
            local DATA_LOG=".data.log"
            local DATA_FILE=".data.json"
            rm -rf $TMP_LOG $DATA_LOG $DATA_FILE
            local page lines todayStr data date dateStr amount eventMassage Name_Array Beans_Array Name LengthTmp Time Beans Income Expense defaultLength

            todayStr=$(date +%s -d "$(date "+%Y-%m-%d")")
            for ((page = 1; page <= 100; page++)); do
                ## 获取页面数据（一页20条）
                getJingBeanBalanceDetail $page >$DATA_LOG
                if [ -s $DATA_LOG ]; then
                    for ((lines = 0; lines <= 19; lines++)); do
                        date=$(cat $DATA_LOG | sed -n "$(($lines + 1)),$(($lines + 1))p" | jq -r ".date")
                        dateStr=$(date -d "${date}" +%s)
                        amount=$(cat $DATA_LOG | sed -n "$(($lines + 1)),$(($lines + 1))p" | jq -r ".amount")
                        eventMassage=$(cat $DATA_LOG | sed -n "$(($lines + 1)),$(($lines + 1))p" | jq -r ".eventMassage")
                        data="{\"date\":\"${dateStr}\",\"amount\":\"${amount}\",\"eventMassage\":\"${eventMassage}\"}"
                        ## 判断是否为今天的数据，否则跳出
                        # echo $data
                        if [[ ${dateStr} -lt ${todayStr} ]]; then
                            break 2
                        fi
                        if [[ $page == "1" ]] && [[ $lines == "0" ]]; then
                            echo "$data" | jq >>$TMP_LOG
                        else
                            echo -e "," >>$TMP_LOG
                            echo "$data" | jq >>$TMP_LOG
                        fi
                    done
                else
                    echo -e "$FAIL 查询接口请求异常，目标账号已被官方接口限制或当前网络环境异常！"
                    return
                fi
                sleep 1
            done
            if [[ ! -s $TMP_LOG ]]; then
                echo -e "未查询到今日京豆变动明细数据，快去参与活动获取吧~"
                return
            fi
            echo -e "[\n$(cat $TMP_LOG)\n]" >$TMP_LOG
            cat $TMP_LOG | jq >$DATA_FILE
            # cat $DATA_FILE

            ## 根据时间排序定义名称数组（空格临时换成了下划线）
            ## 减少使用管道出现的异常
            cat $DATA_FILE | jq .[] | jq '{eventMassage: .eventMassage}' >$TMP_LOG
            cat $TMP_LOG | jq -r '.eventMassage' >$DATA_LOG
            # cat $DATA_FILE
            Name_Array=(
                $(cat $DATA_LOG | sed "s/ /_/g" | awk '!a[$0]++')
            )
            if [[ ${#Name_Array[@]} -gt 0 ]]; then
                Income=0
                Expense=0
                echo -e "[最新时间]                         [变动渠道]                          [明细]\n"
                ## 遍历数组，打印数据
                for i in ${Name_Array[@]}; do
                    defaultLength=50
                    i=$(echo "$i" | sed "s/_/ /g")
                    Name=$(printf "%ls\n" "$i")
                    Beans_Array=$(cat $DATA_FILE | jq -c '.[]' | grep -F "\"$i\"" | jq -r .amount | tr "\n" " ")
                    Time=$(date -d @$(cat $DATA_FILE | jq -c '.[]' | grep -F "$i" | head -n 1 | jq -r .date) +"%H:%M:%S")
                    Time=$(echo $Time | sed "s/^0/ /g")
                    Beans=0
                    for i in ${Beans_Array[@]}; do
                        let Beans+=$i
                    done
                    ## 格式化名称
                    Name=$(echo "${Name}" | sed "s/（商品:.*）//g; s/订单.*使用京豆.*个/订单使用京豆/g")
                    echo "${Name}" | grep -q "参加\[.*\].*-奖励"
                    if [ $? -eq 0 ]; then
                        Name=$(echo "${Name}" | sed "s|参加\[||g; s|\].*||g")
                    fi
                    LengthTmp=$(StringLength $(echo "${Name}" | sed "s/ //g" | perl -pe "{s|[0-9a-zA-Z\.\=\:\_\(\)\'\"-\/\!]||g;}"))
                    ## 中文的引号在等宽字体中占1格而非2格
                    [[ $(echo "${Name}" | grep -c "“") -gt 0 ]] && let defaultLength+=$(echo "${Name}" | grep -c "“")
                    [[ $(echo "${Name}" | grep -c "”") -gt 0 ]] && let defaultLength+=$(echo "${Name}" | grep -c "”")
                    [[ $(echo "${Name}" | grep -c "‘") -gt 0 ]] && let defaultLength+=$(echo "${Name}" | grep -c "‘")
                    [[ $(echo "${Name}" | grep -c "’") -gt 0 ]] && let defaultLength+=$(echo "${Name}" | grep -c "’")
                    spacesNums=$(($(($defaultLength - ${LengthTmp} - ${#Name})) / 2))
                    for ((i = 1; i <= ${spacesNums}; i++)); do
                        Name=" ${Name}"
                    done
                    Name=$(echo "${Name}" | sed "s/“/ “/g; s/”/” /g; s/‘/ ‘/g; s/’/’ /g")
                    if [[ $Beans -gt 0 ]]; then
                        Income=$(($Income + $Beans))
                        printf "· %-12s ${BLUE}%-$(($defaultLength + ${LengthTmp}))s${PLAIN}    ${GREEN}%8s${PLAIN}\n" "$Time" "$Name" "+$Beans"
                    else
                        Expense=$(($Expense + $Beans))
                        printf "· %-12s ${BLUE}%-$(($defaultLength + ${LengthTmp}))s${PLAIN}    ${RED}%8s${PLAIN}\n" "$Time" "$Name" "-$((0 - $Beans))"
                    fi
                done
                echo -e "\n                [${BLUE}今日收入${PLAIN}] ${Income}🐶                    [${BLUE}今日支出${PLAIN}] $((0 - $Expense))🐶"
            else
                echo -e "未查询到今日京豆变动明细数据，快去参与活动获取吧~"
            fi
            rm -rf $DATA_FILE $TMP_LOG $DATA_LOG
        }

        function CheckStatus() {
            local InputContent="$1"
            local CHECK_LOG=".check.log"
            curl -s --noproxy "*" "${INTERFACE_URL}" -H "cookie: ${InputContent}" >$CHECK_LOG
            StatusCode="$(cat $CHECK_LOG | jq -r '.retcode')"
            [[ ${StatusCode} == "0" ]] && nickName="$(cat $CHECK_LOG | jq -r '.data.userInfo.baseInfo.nickname')"
            rm -rf $CHECK_LOG
        }

        local Cookie_Tmp CK nickName StatusCode
        ## 汇总
        case $# in
        1)
            for ((i = 1; i <= ${UserSum}; i++)); do
                echo -e "\n$WORKING 正在请求接口获取账号 ${BLUE}$i${PLAIN} 的今日收支数据...\n"
                nickName=""
                StatusCode=""
                Cookie_Tmp=Cookie$i
                CK=${!Cookie_Tmp}
                CheckStatus "${CK}"
                if [[ ${StatusCode} == "0" ]]; then
                    echo -e "❖ 账号$i · [${BLUE}${nickName}${PLAIN}]\n"
                    QueryBeanInfo
                else
                    echo -e "$WARN 账号$i · [${BLUE}$(echo "$CK" | perl -pe "{s|.*pt_pin=([^; ]+)(?=;?).*|\1|g;}")${PLAIN}] 无效，跳过查询..."
                fi
                echo -e "\n............................................."
                sleep 1
            done
            ;;
        2)
            echo -e "\n$WORKING 正在请求接口获取账号 ${BLUE}$2${PLAIN} 的今日收支数据...\n"
            nickName=""
            StatusCode=""
            Cookie_Tmp=Cookie$2
            CK=${!Cookie_Tmp}
            CheckStatus "${CK}"
            if [[ ${StatusCode} == "0" ]]; then
                echo -e "❖ ${BLUE}${nickName}${PLAIN}\n"
                QueryBeanInfo
            else
                echo -e "$WARN ${BLUE}$(echo "$CK" | perl -pe "{s|.*pt_pin=([^; ]+)(?=;?).*|\1|g;}")${PLAIN} 无效！"
            fi
            ;;
        esac

        echo -e "\n$COMPLETE 查询完毕\n"
        ;;

    list)
        Import_Config
        Count_UserSum
        local Tmp1 Tmp2 num pt_pin_arr pt_pin_len_add remark phone phone_len_add remark_len_add
        for ((n = 1; n <= $UserSum; n++)); do
            Tmp1=Cookie$n
            Tmp2=${!Tmp1}
            num=$(($n - 1))
            pt_pin_arr[num]=$(echo $Tmp2 | perl -pe "{s|.*pt_pin=([^; ]+)(?=;?).*|\1|g;}")
            pt_pin_len_add[num]=$(StringLength $(UrlDecode "${pt_pin_arr[num]}" | perl -pe '{s|[0-9a-zA-Z\.\=\:\_ -]||g;}'))
        done

        echo ''
        for ((i = 0; i < ${#pt_pin_arr[@]}; i++)); do
            grep -Eq "^## pt_pin=${pt_pin_arr[i]};  联系方式：.*;  上次更新：.*;  备注：.*;" $FileConfUser
            if [ $? -eq 0 ]; then
                remark=$(grep -E "^## pt_pin=${pt_pin_arr[i]};  联系方式：.*;  上次更新：.*;  备注：.*;" $FileConfUser | grep -Eo "备注：.*;" | awk -F ';' '{print$1}' | sed "s/备注：//g")

                if [[ -z ${remark} || ${remark} == "无" ]]; then
                    remark="未登记"
                fi
                phone=$(grep -E "^## pt_pin=${pt_pin_arr[i]};  联系方式：.*;  上次更新：.*;  备注：.*;" $FileConfUser | grep -Eo "联系方式：.*;" | awk -F ';' '{print$1}' | sed "s/联系方式：//g")
                if [[ -z ${phone} || ${phone} == "无" ]]; then
                    phone="未登记"
                fi
                phone_len_add=$(StringLength $(echo "${phone}" | perl -pe '{s|[0-9a-zA-Z\.\=\:\_\(\)\[\] \-]||g;}'))
                remark_len_add=$(StringLength $(echo "${remark}" | perl -pe '{s|[0-9a-zA-Z\.\=\:\_\(\)\[\] \-]||g;}'))

                printf "%-3s ${BLUE}%-$((22 + ${pt_pin_len_add[i]}))s${PLAIN} 备注：${BLUE}%-$((24 + ${remark_len_add}))s${PLAIN} 联系方式：${BLUE}%-s${PLAIN}\n" "$(($i + 1))." "$(UrlDecode "${pt_pin_arr[i]}")" "${remark}" "${phone}"
            else
                printf "%-3s ${BLUE}%-$((22 + ${pt_pin_len_add[i]}))s${PLAIN} 备注：${BLUE}未登记${PLAIN}                联系方式：${BLUE}未登记${PLAIN}\n" "$(($i + 1))." "$(UrlDecode "${pt_pin_arr[i]}")"
            fi
        done
        echo ''
        ;;
    esac
}
