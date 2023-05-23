#!/bin/bash
## Modified: 2023-05-23

## 生成 pm2 list 日志清单，以此判断各服务状态
function PM2_List_All_Services() {
    pm2 list | sed "/─/d" | perl -pe "{s| ||g; s#│#|#g}" | sed "1d" >$FilePm2List
}
