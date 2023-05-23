#!/bin/bash
## Modified: 2023-05-23

function Add_Raw() {
    echo '{ "name": "abc", url: "abc", cronSettings: { updateTaskList: true }' | jq
}
