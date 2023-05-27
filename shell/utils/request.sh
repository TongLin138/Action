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
