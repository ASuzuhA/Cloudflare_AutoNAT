#!/bin/bash
set -e

chmod +x ./*.sh
chmod +x CloudflareST
chmod +x socat

./set_cron_jobs.sh
./run_cloudflare.sh
./socat/target_IP.sh