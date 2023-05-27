#!/bin/bash
## Modified: 2023-05-27

function get_request() {
    local url=$1
    local response=$(curl -s -X GET "$url")
    # echo "$response"
}
# response=$(get_request "https://jsonplaceholder.typicode.com/todos/1")

function post_request() {
    local url=$1
    local data=$2
    local response=$(curl -s -X POST -H "Content-Type: application/json" -d "$data" "$url")
    # echo "$response"
}
# data='{"title": "foo", "body": "bar", "userId": 1}'
# response=$(post_request "https://jsonplaceholder.typicode.com/posts" "$data")

function put_request() {
    local url=$1
    local data=$2
    local response=$(curl -s -X PUT -H "Content-Type: application/json" -d "$data" "$url")
    # echo "$response"
}
# data='{"title": "foo", "body": "bar", "userId": 1}'
# response=$(put_request "https://jsonplaceholder.typicode.com/posts/1" "$data")

function delete_request() {
    local url=$1
    local response=$(curl -s -X DELETE "$url")
    # echo "$response"
}
# response=$(delete_request "https://jsonplaceholder.typicode.com/posts/1")

## URL编码
function url_encode() {
    local LANG=C
    local length="${#1}"
    local i=0
    while :; do
        [ $length -gt $i ] && {
            local c="${1:$i:1}"
            case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            *) printf '%%%02X' "'$c" ;;
            esac
        } || break
        let i++
    done
}

## URL解码
function url_decode() {
    local u="${1//+/ }"
    echo -e "${u//%/\\x}"
}

## 解析 Encode 中文字符串
function parse_encode_string_to_chinese() {
    local String=$1
    printf $(echo ${String} | sed "s|%|\\\x|g")
}

## 解析 json 数据
function json_parse() {
    jq -n "$1" | jq -rc "$2"
}
