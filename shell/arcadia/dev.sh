#!/bin/bash
## Modified: 2023-08-15

function change_dev_version() {
    git remote -v | grep -q 'arcadia_github'
    if [ $? -eq 0 ]; then
        git remote set-url origin git@arcadia:SuperManito/ArcadiaBase.git
        echo -e "\n$COMPLETE 已切换回用户版本\n"
    else
        cat /root/.ssh/config | grep -q 'arcadia_github'
        [ $? -ne 0 ] && echo -e "Host arcadia_github\n\tHostName github.com\n\tIdentityFile=/root/.ssh/arcadia\n" >>/root/.ssh/config
        git remote set-url origin git@arcadia_github:SuperManito/ArcadiaBase.git
        echo -e "\n$COMPLETE 已为您切换至开发版本，感谢参与测试\n"
    fi
}
