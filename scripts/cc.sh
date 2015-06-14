#!/usr/bin/env bash

CONTAINER_IP=$(ifconfig | grep 172 | awk '{ print $2 }' | awk 'BEGIN { FS=":" }; { print $2 }')

source /venv/Management/bin/activate
export MANAGEMENT_POLLING_URL="http://${HOST_IP}:${HOST_WS_PORT}"
export MANAGEMENT_MODEL_URL="http://127.0.0.1:8888"
export MANAGEMENT_ALLOWED_ORDER_POST_IPS="127.0.0.1,${CONTAINER_IP}"
export MANAGEMENT_MONGODB_URI="mongodb://127.0.0.1:27017/management"
export MANAGEMENT_LOG_FILE_PREFIX="/var/log/Management/management.log"
export MANAGEMENT_LOG_TO_STDERR="0"
export MANAGEMENT_DEBUG="1"

cd /src/Management
nohup python run.py --port=8002 1> /dev/null 2> /dev/null &
echo "--------- start cc.sh ----------"
