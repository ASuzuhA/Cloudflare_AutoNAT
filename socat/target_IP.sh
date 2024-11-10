#!/bin/bash

# ���� CSV �ļ�·��
CSV_FILE="/root/canat/CloudflareST/result.csv"

# ����˿��ļ�·��
PORT_FILE="/root/canat/socat/port.txt"

# �� PORT_FILE �ж�ȡ LOCAL_PORT
LOCAL_PORT=$(grep '^LOCAL_PORT=' "$PORT_FILE" | cut -d'=' -f2)

TARGET_PORT=$(grep '^TARGET_PORT=' "$PORT_FILE" | cut -d'=' -f2)

# ��ȡ�ڶ��е� IP ��ַ
TARGET_IP=$(sed -n '2p' "$CSV_FILE" | cut -d',' -f1)

# ����Ƿ�ɹ���ȡ�� IP ��ַ
if [ -z "$TARGET_IP" ]; then
    echo "δ�ܻ�ȡ��Ŀ�� IP ��ַ��"
    exit 1
fi

# �����ȡ���� IP ��ַ
echo "��ȡ����Ŀ�� IP ��ַ: $TARGET_IP"

# ���� socat �ű�·��
SOCAT_SCRIPT="/root/canat/socat/socat.sh"

# ��� socat �ű��Ƿ����
if [ -f "$SOCAT_SCRIPT" ]; then
    # ʹ�� sed �滻���нű��е� TARGET_IP
    sed -i "s|^TARGET_IP=.*|TARGET_IP=$TARGET_IP|" "$SOCAT_SCRIPT"
    sed -i "s|^TARGET_PORT=.*|TARGET_PORT=$TARGET_PORT|" "$SOCAT_SCRIPT"
    sed -i "s|^LOCAL_PORT=.*|LOCAL_PORT=$LOCAL_PORT|" "$SOCAT_SCRIPT"
    echo "�Ѹ��� socat �ű��е� TARGET_IP Ϊ: $TARGET_IP"
else
    # ����ű������ڣ������µ� socat �ű�
    cat <<EOL > "$SOCAT_SCRIPT"
#!/bin/bash

# socat ת���ű�
# �����ض˿� $LOCAL_PORT ת����Ŀ�� IP��Cloudflare CDN �� IP���Ͷ˿� TARGET_PORT

LOCAL_PORT=$LOCAL_PORT
TARGET_IP=$TARGET_IP  # ʹ�ô� CSV �ļ��л�ȡ��Ŀ�� IP
TARGET_PORT=$TARGET_PORT

# ���� socat
socat TCP-LISTEN:\$LOCAL_PORT,fork TCP:\$TARGET_IP:\$TARGET_PORT
EOL

    # �� socat �ű����ִ��Ȩ��
    chmod +x "$SOCAT_SCRIPT"
    echo "socat �ű��Ѵ���: $SOCAT_SCRIPT"
fi

# ȷ�� socat �ű�����ִ��Ȩ��
chmod +x "$SOCAT_SCRIPT"

# ���˿��Ƿ�ռ��
if lsof -i :$LOCAL_PORT; then
    echo "�˿� $LOCAL_PORT �ѱ�ռ�ã����ڲ��Ҳ�ɱ��ռ�øö˿ڵĽ���..."
    
    # ��ȡռ�øö˿ڵĽ��� ID
    PID=$(lsof -t -i :$LOCAL_PORT)
    
    if [ -n "$PID" ]; then
        # ɱ��ռ�øö˿ڵĽ���
        kill -9 $PID
        echo "��ɱ������ $PID���ͷŶ˿� $LOCAL_PORT��"
    else
        echo "δ�ҵ�ռ�øö˿ڵĽ��̡�"
    fi
else
    echo "�˿� $LOCAL_PORT ���á�"
fi

# ִ�� socat �ű�
echo "����ִ�� socat �ű�..."
/bin/bash "$SOCAT_SCRIPT" &  # �ں�̨����
disown  # ʹ��̨�����뵱ǰ�ն˷���