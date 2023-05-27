#!/bin/bash
## Modified: 2023-05-27

## 克隆仓库
## 注释  $1：仓库地址，$2：仓库保存路径，$3：分支（可省略）
function git_clone() {
    local url=$1
    local dir=$2
    local branch=$3
    local text="${4:-"开始克隆仓库 ${BLUE}$url${PLAIN}"}"
    [[ $branch ]] && local command="-b $branch "
    echo -e "\n$WORKING ${text}\n"
    export GIT_TERMINAL_PROMPT=0
    git clone $command$url $dir
    EXITSTATUS=$?
}

## 更新仓库
## 注释  $1：仓库保存路径
function git_pull() {
    local current_dir=$(pwd)
    local work_dir=$1
    local branch=$2
    local text="${3:-"开始更新仓库 ${BLUE}$work_dir${PLAIN}"}"
    cd $work_dir
    echo -e "\n$WORKING ${text}\n"
    export GIT_TERMINAL_PROMPT=0
    git fetch --all
    EXITSTATUS=$?
    git pull
    git reset --hard origin/$branch
    cd $current_dir
}

## 重置仓库远程链接 remote url
## 注释  $1：要重置的目录，$2：要重置为的网址
function reset_romote_url() {
    local current_dir=$(pwd)
    local work_dir=$1
    local url=$2
    local branch=$3
    if [ -d "$work_dir/.git" ]; then
        cd $work_dir
        export GIT_TERMINAL_PROMPT=0
        git remote set-url origin $url >/dev/null 2>&1
        git fetch --all >/dev/null 2>&1
        git reset --hard origin/$branch >/dev/null 2>&1
        cd $current_dir
    fi
}
