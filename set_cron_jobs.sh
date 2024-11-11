#!/bin/bash

CLOUDFLARE="/root/canat.sh"

CLOUDFLARE_CRON_JOB="0 3 * * * $CLOUDFLARE"  # 凌晨3点执行

(crontab -l | grep -F "$CLOUDFLARE_CRON_JOB") && {
    echo "CLOUDFLARE CRON JOB already exists."
} || {
    (crontab -l; echo "$CLOUDFLARE_CRON_JOB") | crontab -
    echo "CLOUDFLARE CRON JOB: $CLOUDFLARE_CRON_JOB"
}
