#!/bin/bash

SOCAT_PROCESS="socat"

FAIL_SCRIPT="/root/canat/canat.sh"

ERROR_LOG="/root/canat/self_test/error.log"

if pgrep -x "$SOCAT_PROCESS" > /dev/null; then
    echo "$SOCAT_PROCESS is running."
else
    echo "$SOCAT_PROCESS is not running."

    bash "$FAIL_SCRIPT"
    exit 1
fi

CURRENT_TIME=$(date +%s)

TIME_LIMIT=$(($CURRENT_TIME - 660))  # 660 Ãë = 11 ·ÖÖÓ

if awk -v limit="$TIME_LIMIT" '
{
    split(\$1, date, "/");
    split(\$2, time, ":");
    log_time = mktime(date[1] " " date[2] " " date[3] " " time[1] " " time[2] " " time[3]);
    
    if (log_time >= limit && \$0 ~ /Connection timed out/) {
        print \$0;
    }
}' "$ERROR_LOG" | grep -q "Connection timed out"; then
    echo "Found 'Connection timed out' in the last 11 minutes."

    bash /root/canat/self_test/kill.sh
    bash /root/canat/canat.sh
else
    echo "'Connection timed out' not found in the last 11 minutes."
fi
