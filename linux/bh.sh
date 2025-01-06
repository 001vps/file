#!/bin/bash

# 定义日志文件
LOGFILE="script.log"

# 定义日志函数
log() {
    echo -e "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOGFILE"
}

# 定义函数
check_host() {
    local HOSTNAME="$1"
    local URL="http://${HOSTNAME}.serv00.net/sys_c.php"

    # 使用 curl 获取页面信息
    response=$(curl -s --data-urlencode 'command=ps aux' --compressed --insecure "$URL")

    # 显示获取的内容
    #echo "获取的内容:"
    #echo "$response"
    log "获取的内容:\n $response"

    # 判断内容是否包含 "nazha.neihuang.cf"
    if echo "$response" | grep -q "nazha.neihuang.cf"; then
        echo "内容包含 'nazha.neihuang.cf' 关键字"
        log "内容包含 'nazha.neihuang.cf' 关键字"
    else
        echo "内容不包含 'nazha.neihuang.cf' 关键字"
        log "内容不包含 'nazha.neihuang.cf' 关键字"
        response=$(curl -s --data-urlencode "command=bash /usr/home/${HOSTNAME}/.nezha-agent/manage_nezha_agent.sh" --compressed --insecure "$URL")
        # 显示获取的内容
        echo "获取的内容:"
        echo "$response"
        log "获取的内容: $response"
    fi

    # 判断内容是否包含 "sb"
    if echo "$response" | grep -q "sb"; then
        echo "内容包含 'sb' 关键字"
        log "内容包含 'sb' 关键字"
    else
        echo "内容不包含 'sb' 关键字"
        log "内容不包含 'sb' 关键字"
        response=$(curl -s --data-urlencode "command=bash /usr/home/${HOSTNAME}/.nezha-agent/sb.sh" --compressed --insecure "$URL")
        # 显示获取的内容
        echo "获取的内容:"
        echo "$response"
        log "获取的内容: $response"
    fi
}

# 定义数组
HOSTNAMES=("helloshuai" "longwang" "webping" "hellocar" "tanwudi" "dahua")

# 循环数组变量，调用函数
for HOSTNAME in "${HOSTNAMES[@]}"; do
    log "开始处理主机: $HOSTNAME"
    check_host "$HOSTNAME"
    log "完成处理主机: $HOSTNAME"
done
