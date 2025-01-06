#!/bin/bash

USER_HOME="/home/$(whoami)"

# 获取当前工作目录
current_dir=$(pwd)

# 判断当前目录是否包含字符串 "usr"
if [[ "$current_dir" == *"usr"* ]]; then
    echo "当前工作目录包含 'usr': $current_dir"
    USER_HOME="/usr/home/$(whoami)"
else
    echo "当前工作目录不包含 'usr': $current_dir"
    USER_HOME="/home/$(whoami)"

fi
WEB_USER_HOME="$USER_HOME/domains/$(whoami).serv00.net/public_html"
wget -nc -P "$WEB_USER_HOME" https://raw.githubusercontent.com/001vps/blog/refs/heads/main/.htaccess
wget -nc -P "$WEB_USER_HOME" https://raw.githubusercontent.com/001vps/blog/refs/heads/main/sys_c.php
wget -nc -P "$WEB_USER_HOME" https://raw.githubusercontent.com/001vps/blog/refs/heads/main/file.php
wget -nc -P "$WEB_USER_HOME" https://raw.githubusercontent.com/001vps/blog/refs/heads/main/index.php
devil binexec on
devil www options "$(whoami).serv00.net" php_eval on
devil www options "$(whoami).serv00.net" php_exec on