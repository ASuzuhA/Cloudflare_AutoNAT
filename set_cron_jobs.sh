#!/bin/bash

# Ҫ��ʱִ�еĽű�·��
CLOUDFLARE="/root/canat/run_cloudflare.sh"
SOCAT_IP="/root/canat/socat/target_IP.sh"

# ���� cron ����
CLOUDFLARE_CRON_JOB="0 3 * * * $CLOUDFLARE"  # �賿3��ִ��
SOCAT_IP_CRON_JOB="10 3 * * * $SOCAT_IP"     # �賿3��10��ִ��

# ��鵱ǰ�û��� crontab �Ƿ��Ѵ��ڸ�����
(crontab -l | grep -F "$CLOUDFLARE_CRON_JOB") && {
    echo "CLOUDFLARE CRON JOB already exists."
} || {
    (crontab -l; echo "$CLOUDFLARE_CRON_JOB") | crontab -
    echo "CLOUDFLARE CRON JOB: $CLOUDFLARE_CRON_JOB"
}

(crontab -l | grep -F "$SOCAT_IP_CRON_JOB") && {
    echo "SOCAT_IP CRON JOB already exists."
} || {
    (crontab -l; echo "$SOCAT_IP_CRON_JOB") | crontab -
    echo "SOCAT_IP CRON JOB: $SOCAT_IP_CRON_JOB"
}
