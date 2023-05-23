#!/bin/bash
## 容器 EntryPoint 入口脚本

if [ ! -d ${ARCADIA_DIR}/config ]; then
    echo -e "$ERROR 没有映射 config 配置文件目录给本容器，请先按教程映射该目录...\n"
    exit 1
fi

# ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ 第 一 区 域 ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ #
echo -e "\n\033[1;34m$(date "${TIME_FORMAT}")${PLAIN} ----- ➀ 同步最新源码开始 -----\n"
cd ${ARCADIA_DIR}
sleep 2
git fetch --all
git reset --hard origin/$(git status | head -n 1 | awk -F ' ' '{print$NF}')
sleep 2

## 执行最新的初始化脚本
import init

set -e
Init
exec "$@"
