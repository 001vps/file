#!/bin/bash

# 获取当前脚本的绝对路径
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
KEEP_ALIVE_SCRIPT="$SCRIPT_DIR/manage_dashboard.sh"

current_dir=$(pwd)

# 判断当前目录是否包含字符串 "usr"
if [[ "$current_dir" == *"usr"* ]]; then
    echo "当前工作目录包含 'usr': $current_dir"
    USER_HOME="/usr/home/$(whoami)"
else
    echo "当前工作目录不包含 'usr': $current_dir"
    USER_HOME="/home/$(whoami)"
fi

# 启动 dashboard 的命令
DASHBOARD_CMD="nohup $USER_HOME/.nezha-dashboard/dashboard >/dev/null 2>&1 &"

# 检查进程是否在运行
if ! pgrep -f "dashboard" > /dev/null; then
    # 如果没有运行，则启动进程
    eval $DASHBOARD_CMD
    echo "dashboard 进程已启动。"
else
    echo "dashboard 进程正在运行。"
fi

# 检查 crontab 中是否已经存在保活脚本
if ! crontab -l | grep -q "$KEEP_ALIVE_SCRIPT"; then
    # 如果没有找到，则添加到 crontab
    (crontab -l; echo "*/12 * * * * $KEEP_ALIVE_SCRIPT") | crontab -
    echo "保活脚本已添加到 crontab。"
else
    echo "保活脚本已存在于 crontab 中。"
fi

# 确保保活脚本具有执行权限
chmod +x "$KEEP_ALIVE_SCRIPT"
