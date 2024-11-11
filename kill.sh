#!/bin/bash

# 查找并杀掉所有 socat 进程
pkill socat

# 检查是否成功
if [ $? -eq 0 ]; then
    echo "All socat processes have been terminated."
else
    echo "No socat processes were found or could not be terminated."
fi