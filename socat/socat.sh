#!/bin/bash

# socat ת���ű�
# �����ض˿� 9876 ת����Ŀ�� IP��Cloudflare CDN �� IP���Ͷ˿�

LOCAL_PORT=7896
TARGET_IP=104.18.146.197
TARGET_PORT=8080

# ���� socat
socat TCP-LISTEN:$LOCAL_PORT,fork TCP:$TARGET_IP:$TARGET_PORT
