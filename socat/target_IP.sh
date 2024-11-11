#!/bin/bash

CSV_FILE="/root/canat/CloudflareST/result.csv"

PORT_FILE="/root/canat/socat/port.txt"

LOCAL_PORT=$(grep '^LOCAL_PORT=' "$PORT_FILE" | cut -d'=' -f2)

TARGET_PORT=$(grep '^TARGET_PORT=' "$PORT_FILE" | cut -d'=' -f2)

TARGET_IP=$(sed -n '2p' "$CSV_FILE" | cut -d',' -f1)

if [ -z "$TARGET_IP" ]; then
    echo "未能获取到目标 IP 地址。"
    exit 1
fi

echo "获取到的目标 IP 地址: $TARGET_IP"

SOCAT_SCRIPT="/root/canat/socat/socat.sh"

if [ -f "$SOCAT_SCRIPT" ]; then
    sed -i "s|^TARGET_IP=.*|TARGET_IP=$TARGET_IP|" "$SOCAT_SCRIPT"
    sed -i "s|^TARGET_PORT=.*|TARGET_PORT=$TARGET_PORT|" "$SOCAT_SCRIPT"
    sed -i "s|^LOCAL_PORT=.*|LOCAL_PORT=$LOCAL_PORT|" "$SOCAT_SCRIPT"
    echo "已更新 socat 脚本中的 TARGET_IP 为: $TARGET_IP"
else
    cat <<EOL > "$SOCAT_SCRIPT"
#!/bin/bash

# socat 转发脚本
# 将本地端口 $LOCAL_PORT 转发到目标 IP（Cloudflare CDN 的 IP）和端口 TARGET_PORT

LOCAL_PORT=$LOCAL_PORT
TARGET_IP=$TARGET_IP  # 使用从 CSV 文件中获取的目标 IP
TARGET_PORT=$TARGET_PORT

socat TCP-LISTEN:\$LOCAL_PORT,fork TCP:\$TARGET_IP:\$TARGET_PORT
EOL

    chmod +x "$SOCAT_SCRIPT"
    echo "socat 脚本已创建: $SOCAT_SCRIPT"
fi

chmod +x "$SOCAT_SCRIPT"

if lsof -i :$LOCAL_PORT; then
    echo "端口 $LOCAL_PORT 已被占用，正在查找并杀掉占用该端口的进程..."
    
    PID=$(lsof -t -i :$LOCAL_PORT)
    
    if [ -n "$PID" ]; then
        kill -9 $PID
        echo "已杀掉进程 $PID，释放端口 $LOCAL_PORT。"
    else
        echo "未找到占用该端口的进程。"
    fi
else
    echo "端口 $LOCAL_PORT 可用。"
fi

echo "正在执行 socat 脚本..."
/bin/bash "$SOCAT_SCRIPT" &  # 在后台运行
disown  # 使后台进程与当前终端分离
