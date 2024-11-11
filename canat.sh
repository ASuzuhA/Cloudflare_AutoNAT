#!/bin/bash
set -e

chmod +x ./*.sh
chmod +x CloudflareST
chmod +x socat
chmod +x other
chmod +x self_test

./other/set_cron_jobs.sh
./other/run_cloudflare.sh
./socat/target_IP.sh
