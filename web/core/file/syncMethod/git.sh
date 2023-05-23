#!/bin/bash
## Modified: 2023-04-12
ShellDir=${ARCADIA_DIR}/shell
. $ShellDir/template.sh

## 克隆仓库
## 注释  $1：仓库地址，$2：仓库保存路径，$3：分支（可省略）
function Git_Clone() {
    local Url=$1
    local Dir=$2
    local Branch=$3
    [[ $Branch ]] && local Command="-b $Branch "
    echo -e "\n$WORKING 开始克隆仓库 ${BLUE}$Url${PLAIN}\n"
    GIT_TERMINAL_PROMPT=0 git clone $Command $Url $Dir
    ExitStatus=$?
}

## 更新仓库
## 注释  $1：仓库保存路径
function Git_Pull() {
    local CurrentDir=$(pwd)
    local WorkDir=$1
    local Branch=$2
    cd $WorkDir
    echo -e "\n$WORKING 开始更新仓库：${BLUE}$WorkDir${PLAIN}\n"
    GIT_TERMINAL_PROMPT=0 git fetch --all
    ExitStatus=$?
    GIT_TERMINAL_PROMPT=0 git pull
    GIT_TERMINAL_PROMPT=0 git reset --hard origin/$Branch
    cd $CurrentDir
}

## 重置仓库远程链接 remote url
## 注释  $1：要重置的目录，$2：要重置为的网址
function Reset_Romote_Url() {
    local CurrentDir=$(pwd)
    local WorkDir=$1
    local Url=$2
    local Branch=$3
    if [ -d "$WorkDir/.git" ]; then
        cd $WorkDir
        git remote set-url origin $Url >/dev/null 2>&1
        GIT_TERMINAL_PROMPT=0 git fetch --all >/dev/null 2>&1
        GIT_TERMINAL_PROMPT=0 git reset --hard origin/$Branch >/dev/null 2>&1
        cd $CurrentDir
    fi
}

# 仓库名称 name
# 远程地址 url
# 分支名称 branch
# 存放仓库文件夹名 dir
# 仓库本地绝对路径 path
function Main() {
    local ARGS Repo_Name Repo_Url Repo_Branch Repo_Dir Repo_Path

    ## 读取传参
    ARGS=$(getopt -a -o n:u:b: -l name:,url:,branch: -- "$@")
    [ $? -ne 0 ] && echo "help"
    #set -- "${ARGS}"
    eval set -- "${ARGS}"
    while true; do
        case "$1" in
        -n | --name)
            Repo_Name="$2"
            shift
            ;;
        -u | --url)
            Repo_Url="$2"
            shift
            ;;
        -b | --branch)
            Repo_Branch="$2"
            shift
            ;;
        --)
            shift
            break
            ;;
        esac
        shift
    done

    # 定义仓库文件夹名称
    Repo_Dir="$(echo "$Repo_Url" | sed "s|\.git||g" | awk -F "/|:" '{print $((NF - 1)) "_" $NF}')"
    # 定义仓库路径
    Repo_Path="$ReposDir/$Repo_Dir"

    # 处理仓库
    if [ -d ${Repo_Path}/.git ]; then
        Reset_Romote_Url ${Repo_Path} ${Repo_Url} ${Repo_Branch}
        Git_Pull ${Repo_Path} ${Repo_Branch}
        if [[ $ExitStatus -eq 0 ]]; then
            echo -e "\n$COMPLETE ${BLUE}${Repo_Dir}${PLAIN} 仓库更新完成"
        else
            echo -e "\n$FAIL ${BLUE}${Repo_Dir}${PLAIN} 仓库更新失败，请检查原因..."
        fi
    else
        Git_Clone ${Repo_Url} ${Repo_Path} ${Repo_Branch}
        if [[ $ExitStatus -eq 0 ]]; then
            echo -e "\n$SUCCESS ${BLUE}${Repo_Dir}${PLAIN} 克隆仓库成功"
        else
            echo -e "\n$FAIL ${BLUE}${Repo_Dir}${PLAIN} 克隆仓库失败，请检查原因..."
        fi
    fi
}

Main "$@"
