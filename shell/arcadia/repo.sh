#!/bin/bash
## Modified: 2023-05-23

function Add_Repo() {
    echo '{ "name": "", "url": "", "branch": "", "enable": true, "cronSettings": { "updateTaskList": true, "scriptsPath": "", "scriptsType": ["js", "py", "ts"], "whiteList": "", "blackList": "", "autoDisable": false, "addNotify": true, "delNotify": true } }' | jq
}
