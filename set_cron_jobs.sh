#!/bin/bash

# 要定时执行的脚本路径
CLOUDFLARE="/root/canat/run_cloudflare.sh"
SOCAT_IP="/root/canat/socat/target_IP.sh"

# 定义 cron 任务
CLOUDFLARE_CRON_JOB="0 3 * * * $CLOUDFLARE"  # 凌晨3点执行
SOCAT_IP_CRON_JOB="10 3 * * * $SOCAT_IP"     # 凌晨3点10分执行

# 检查当前用户的 crontab 是否已存在该任务
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
