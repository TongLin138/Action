#!/bin/bash
## Modified: 2023-12-02

## 检测项目配置文件完整性
# arcadia check config
function check_conf_files() {
    echo ''
    make_dir $LogDir
    JsonFiles="config.sh auth.json bot.json account.json sync.yml"
    for file in $JsonFiles; do
        if [ ! -s "$ConfigDir/$file" ]; then
            cp -fv "$SampleDir/$file" "$ConfigDir/$file"
            echo -e "检测到 $ConfigDir 配置文件目录下不存在 $file ，已生成...\n"
        fi
    done
}

## 处理环境软件包和模块
# arcadia env install/repairs
function environment_package() {
    local npm_packages_armv7="date-fns qs dotenv png-js file-system-cache tunnel js-base64 ds ts-md5 tslib"
    local npm_packages_full="date-fns qs dotenv png-js file-system-cache tunnel js-base64 ds ts-md5 tslib"

    ## 安装 Python3
    function install_python3() {
        if [ ! -x /usr/bin/python3 ]; then
            echo -e "\n$WORKING 开始安装 ${BLUE}Python3${PLAIN} 运行环境...\n"
            apk --no-cache add -f python3 py3-pip
            local exit_code=$?
            if [ $exit_code -eq 0 ]; then
                pip3 install --upgrade pip --no-cache-dir
                echo -e "\n$SUCCESS Python3 已安装\n"
            else
                echo -e "\n$FAIL Python3 安装失败，请检查原因后重试！\n"
            fi
        fi
    }

    ## 安装 TypeScript
    function install_typescript() {
        if [ ! -x /usr/local/bin/ts-node ]; then
            echo -e "\n$WORKING 开始安装 ${BLUE}TypeScript${PLAIN} 运行环境...\n"
            local exit_code=$?
            if [ $exit_code -eq 0 ]; then
                npm install -g ts-node typescript @types/node
                echo -e "\n$SUCCESS TypeScript 已安装\n"
            else
                echo -e "\n$FAIL TypeScript 安装失败，请检查原因后重试！\n"
            fi
        fi
    }

    case $1 in
    install)
        npm install -g npm >/dev/null 2>&1
        case ${ARCH} in
        armv7l | armv6l)
            echo -e "\n$WORKING 开始安装常用依赖模块...\n"
            npm install -g $npm_packages_armv7
            ;;
        *)
            install_python3
            install_typescript
            echo -e "\n$WORKING 开始安装常用依赖模块...\n"
            npm install -g $npm_packages_full
            ;;
        esac
        echo -e "\n$TIP 忽略 ${YELLOW}WARN${PLAIN} 警告类输出内容，如有 ${RED}ERR!${PLAIN} 类报错，自行解读日志。"
        echo -e "\n$SUCCESS 安装完成\n"
        ;;
    repairs)
        echo -e "\n$WORKING 开始重装 nodejs 和 npm ...\n"
        apk del -f nodejs-lts npm
        apk --no-cache add -f nodejs-lts npm
        if [ $? -eq 0 ]; then
            echo -e "\n$SUCCESS 修复完成\n"
        else
            echo -e "\n$FAIL 修复失败\n"
        fi
        ;;
    esac
}
