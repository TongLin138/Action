#!/bin/bash
## Modified: 2023-05-21

## 克隆仓库
## 注释  $1：仓库地址，$2：仓库保存路径，$3：分支（可省略）
function Git_Clone() {
    local Url=$1
    local Dir=$2
    local Branch=$3
    local Text="${4:-"开始克隆仓库 ${BLUE}$Url${PLAIN}"}"
    [[ $Branch ]] && local Command="-b $Branch "
    echo -e "\n$WORKING ${Text}\n"
    export GIT_TERMINAL_PROMPT=0
    git clone $Command $Url $Dir
    ExitStatus=$?
}

## 更新仓库
## 注释  $1：仓库保存路径
function Git_Pull() {
    local CurrentDir=$(pwd)
    local WorkDir=$1
    local Branch=$2
    local Text="${3:-"开始更新仓库 ${BLUE}$WorkDir${PLAIN}"}"
    cd $WorkDir
    echo -e "\n$WORKING ${Text}\n"
    export GIT_TERMINAL_PROMPT=0
    git fetch --all
    ExitStatus=$?
    git pull
    git reset --hard origin/$Branch
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
        export GIT_TERMINAL_PROMPT=0
        git remote set-url origin $Url >/dev/null 2>&1
        git fetch --all >/dev/null 2>&1
        git reset --hard origin/$Branch >/dev/null 2>&1
        cd $CurrentDir
    fi
}
