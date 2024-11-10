#!/bin/bash

# socat 转发脚本
# 将本地端口 9876 转发到目标 IP（Cloudflare CDN 的 IP）和端口

LOCAL_PORT=7896
TARGET_IP=104.18.146.197
TARGET_PORT=8080

# 启动 socat
socat TCP-LISTEN:$LOCAL_PORT,fork TCP:$TARGET_IP:$TARGET_PORT
