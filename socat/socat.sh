#!/bin/bash

LOCAL_PORT=7896
TARGET_IP=104.18.146.197
TARGET_PORT=8080

# 启动 socat
socat TCP-LISTEN:$LOCAL_PORT,fork TCP:$TARGET_IP:$TARGET_PORT 2>> /root/canat/self_test/error.log
