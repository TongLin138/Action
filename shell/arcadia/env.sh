#!/bin/bash
## Modified: 2023-05-23

## 检测项目配置文件完整性
function Check_Files() {
    echo ''
    Make_Dir $LogDir
    JsonFiles="config.sh auth.json bot.json account.json sync_config.yml"
    for file in $JsonFiles; do
        if [ ! -s "$ConfigDir/$file" ]; then
            cp -fv "$SampleDir/$file" "$ConfigDir/$file"
            echo -e "检测到 $ConfigDir 配置文件目录下不存在 $file ，已生成...\n"
        fi
    done
}

## 处理环境软件包和模块
function Environment_Deployment() {
    case $1 in
    install)
        npm install -g npm >/dev/null 2>&1
        case ${ARCH} in
        armv7l | armv6l)
            echo -e "\n$WORKING 开始安装常用模块...\n"
            npm install -g date-fns crypto dotenv png-js ws@7.4.3
            ;;
        *)
            if [ ! -x /usr/bin/python3 ]; then
                echo -e "\n$WORKING 开始安装 ${BLUE}Python3${PLAIN} 运行环境...\n"
                apk --no-cache add -f python3 py3-pip
                pip3 install --upgrade pip --no-cache-dir
            fi
            if [ ! -x /usr/bin/ts-node ]; then
                echo -e "\n$WORKING 开始安装 ${BLUE}TypeScript${PLAIN} 运行环境...\n"
                npm install -g ts-node typescript @types/node
            fi
            echo -e "\n$WORKING 开始安装常用模块...\n"
            npm install -g date-fns file-system-cache dotenv png-js ws@7.4.3 tunnel prettytable js-base64 ds ts-md5 tslib
            ;;
        esac
        echo -e "\n$TIPS 忽略 ${YELLOW}WARN${PLAIN} 警告类输出内容，如有 ${RED}ERR!${PLAIN} 类报错，自行解读日志。"
        echo -e "\n$SUCCESS 安装完成\n"
        ;;
    repairs)
        echo -e "\n$WORKING 开始暴力修复 npm ...\n"
        apk del -f nodejs-lts npm
        apk --no-cache add -f nodejs-lts npm
        echo -e "\n$SUCCESS 修复完成\n"
        ;;
    esac
}
