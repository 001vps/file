#!/bin/bash
wget https://raw.githubusercontent.com/001vps/blog/refs/heads/main/v22
wget https://raw.githubusercontent.com/001vps/blog/refs/heads/main/v2ctl
wget https://raw.githubusercontent.com/001vps/blog/refs/heads/main/config.json
chmod +x v2ctl
chmod +x v22
nohup ./v22 -config=./config.json >out.txt 2>&1 &