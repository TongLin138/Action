#!/bin/bash
## Modified: 2023-5-21

set -e

if [ ! -d ${WORK_DIR}/config ]; then
  echo -e "$ERROR 没有映射 config 配置文件目录给本容器，请先按教程映射该目录...\n"
  exit 1
fi

source ${WORK_DIR}/shell/core/main.sh
SOFT_LINK="arcadia task update envm runall"
SOFT_LINK_OLD=""

# ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ 第 一 区 域 ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ #
echo -e "\n\033[1;34m$(date "${TIME_FORMAT}")${PLAIN} ----- ➀ 同步最新源码开始 -----\n"
cd ${WORK_DIR}
sleep 2
git fetch --all
git reset --hard origin/$(git status | head -n 1 | awk -F ' ' '{print$NF}')
sleep 2

## 检测软链接
for soft in ${SOFT_LINK}; do
  if [ ! -L "/usr/local/bin/${soft}" ]; then
    ln -sf "${WORK_DIR}/shell/${soft}.sh" "/usr/local/bin/${soft}"
    chmod 777 "/usr/local/bin/${soft}"
  fi
done
for soft_old in ${SOFT_LINK_OLD}; do
  if [ -L "/usr/local/bin/${soft_old}" ]; then
    rm -f "/usr/local/bin/${soft_old}"
  fi
done

## 检测配置文件
arcadia check files >/dev/null 2>&1

## 更新源码
update source

echo -e "\n\033[1;34m$(date "${TIME_FORMAT}")${PLAIN} ----- ➀ 同步最新源码结束 -----\n"

# ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ 第 二 区 域 ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ #
echo -e "\n\033[1;34m$(date "${TIME_FORMAT}")${PLAIN} ----- ➁ 启动控制面板和网页终端开始 -----\n"
cd ${WORK_DIR}
[ ! -x /usr/bin/npm ] && apk add -f nodejs-lts npm >/dev/null 2>&1
export PS1="\[\e[32;1m\]@Helloworld Cli\[\e[37;1m\] ➜\[\e[34;1m\]  \w\[\e[0m\] \\$ "
pm2 start ttyd --name "web_terminal" --log-date-format "YYYY-MM-DD HH:mm:ss" -- \
  -p 7685 \
  -t rendererType=canvas \
  -t fontFamily='SF Mono, JetBrains Mono, Courier New, Consolas, monospace' \
  -t cursorBlink=true \
  -t fontSize=14 \
  -t lineHeight=1.5 \
  -t disableLeaveAlert=true \
  -t macOptionIsMeta=true \
  -t macOptionClickForcesSelection=true \
  bash
echo -e "\n\033[1;34m$(date "${TIME_FORMAT}")${PLAIN} 网页终端启动成功 $SUCCESS\n"

cd ./web
echo -e "$WORKING 开始安装面板依赖模块...\n"
npm install
echo -e "\n$SUCCESS 模块安装完成\n"
pm2 start ecosystem.config.js
cd ${WORK_DIR}
echo -e "\n\033[1;34m$(date "${TIME_FORMAT}")${PLAIN} 控制面板启动成功 $SUCCESS\n"
echo -e "\n\033[1;34m$(date "${TIME_FORMAT}")${PLAIN} ----- ➁ 启动控制面板和网页终端结束 -----\n"

# ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ 第 三 区 域 ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ #
echo -e "\n\033[1;34m$(date "${TIME_FORMAT}")${PLAIN} ----- ➂ 启动电报机器人开始 -----\n"
case $(uname -m) in
armv7l | armv6l)
  echo -e "宿主机的处理器架构不支持使用此功能"
  ;;
*)
  if [[ -z $(grep -E "123456789" ${WORK_DIR}/config/bot.json) ]]; then
    arcadia jbot start
  else
    echo -e "检测到当前还没有配置 bot.json 可能是首次部署容器，因此不启动电报机器人..."
  fi
  ;;
esac
echo -e "\n\033[1;34m$(date "${TIME_FORMAT}")${PLAIN} ----- ➂ 启动电报机器人结束 -----\n"

echo -e "..." && sleep 1 && echo -e "...." && sleep 1 && echo -e "....." && sleep 1
echo -e "\n\033[1;34m$(date "${TIME_FORMAT}")${PLAIN} \033[1;32m容器启动成功${PLAIN}\n"
echo -e "$TIPS 请退出查看容器初始化日志\n"

crond -f >/dev/null

exec "$@"
