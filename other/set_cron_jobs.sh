#!/bin/bash

CLOUDFLARE="/root/canat.sh"
self_test="/root/canat/self_test/examine.sh"

CLOUDFLARE_CRON_JOB="0 3 * * * $CLOUDFLARE"  # ¡Ë≥ø3µ„÷¥––
self_test_CRON_JOB="10 0 * * * $self_test"  #√ø∏Ù10∑÷÷”ºÏ≤‚

(crontab -l | grep -F "$CLOUDFLARE_CRON_JOB") && {
    echo "CLOUDFLARE CRON JOB already exists."
} || {
    (crontab -l; echo "$CLOUDFLARE_CRON_JOB") | crontab -
    echo "CLOUDFLARE CRON JOB: $CLOUDFLARE_CRON_JOB"
}

(crontab -l | grep -F "$self_test_CRON_JOB") && {
    echo "SELF_TEST CRON JOB already exists."
} || {
    (crontab -l; echo "$self_test_CRON_JOB") | crontab -
    echo "SELF_TEST CRON JOB: $self_test_CRON_JOB"
}