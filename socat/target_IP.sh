#!/bin/bash

# 定义 CSV 文件路径
CSV_FILE="/root/canat/CloudflareST/result.csv"

# 定义端口文件路径
PORT_FILE="/root/canat/socat/port.txt"

# 从 PORT_FILE 中读取 LOCAL_PORT
LOCAL_PORT=$(grep '^LOCAL_PORT=' "$PORT_FILE" | cut -d'=' -f2)

TARGET_PORT=$(grep '^TARGET_PORT=' "$PORT_FILE" | cut -d'=' -f2)

# 读取第二行的 IP 地址
TARGET_IP=$(sed -n '2p' "$CSV_FILE" | cut -d',' -f1)

# 检查是否成功获取到 IP 地址
if [ -z "$TARGET_IP" ]; then
    echo "未能获取到目标 IP 地址。"
    exit 1
fi

# 输出获取到的 IP 地址
echo "获取到的目标 IP 地址: $TARGET_IP"

# 创建 socat 脚本路径
SOCAT_SCRIPT="/root/canat/socat/socat.sh"

# 检查 socat 脚本是否存在
if [ -f "$SOCAT_SCRIPT" ]; then
    # 使用 sed 替换现有脚本中的 TARGET_IP
    sed -i "s|^TARGET_IP=.*|TARGET_IP=$TARGET_IP|" "$SOCAT_SCRIPT"
    sed -i "s|^TARGET_PORT=.*|TARGET_PORT=$TARGET_PORT|" "$SOCAT_SCRIPT"
    sed -i "s|^LOCAL_PORT=.*|LOCAL_PORT=$LOCAL_PORT|" "$SOCAT_SCRIPT"
    echo "已更新 socat 脚本中的 TARGET_IP 为: $TARGET_IP"
else
    # 如果脚本不存在，创建新的 socat 脚本
    cat <<EOL > "$SOCAT_SCRIPT"
#!/bin/bash

# socat 转发脚本
# 将本地端口 $LOCAL_PORT 转发到目标 IP（Cloudflare CDN 的 IP）和端口 TARGET_PORT

LOCAL_PORT=$LOCAL_PORT
TARGET_IP=$TARGET_IP  # 使用从 CSV 文件中获取的目标 IP
TARGET_PORT=$TARGET_PORT

# 启动 socat
socat TCP-LISTEN:\$LOCAL_PORT,fork TCP:\$TARGET_IP:\$TARGET_PORT
EOL

    # 给 socat 脚本添加执行权限
    chmod +x "$SOCAT_SCRIPT"
    echo "socat 脚本已创建: $SOCAT_SCRIPT"
fi

# 确保 socat 脚本具有执行权限
chmod +x "$SOCAT_SCRIPT"

# 检查端口是否被占用
if lsof -i :$LOCAL_PORT; then
    echo "端口 $LOCAL_PORT 已被占用，正在查找并杀掉占用该端口的进程..."
    
    # 获取占用该端口的进程 ID
    PID=$(lsof -t -i :$LOCAL_PORT)
    
    if [ -n "$PID" ]; then
        # 杀掉占用该端口的进程
        kill -9 $PID
        echo "已杀掉进程 $PID，释放端口 $LOCAL_PORT。"
    else
        echo "未找到占用该端口的进程。"
    fi
else
    echo "端口 $LOCAL_PORT 可用。"
fi

# 执行 socat 脚本
echo "正在执行 socat 脚本..."
/bin/bash "$SOCAT_SCRIPT" &  # 在后台运行
disown  # 使后台进程与当前终端分离