#!/bin/bash

# 要定时执行的脚本路径
CLOUDFLARE="/root/canat.sh"

# 定义 cron 任务
CLOUDFLARE_CRON_JOB="0 3 * * * $CLOUDFLARE"  # 凌晨3点执行

# 检查当前用户的 crontab 是否已存在该任务
(crontab -l | grep -F "$CLOUDFLARE_CRON_JOB") && {
    echo "CLOUDFLARE CRON JOB already exists."
} || {
    (crontab -l; echo "$CLOUDFLARE_CRON_JOB") | crontab -
    echo "CLOUDFLARE CRON JOB: $CLOUDFLARE_CRON_JOB"
}
