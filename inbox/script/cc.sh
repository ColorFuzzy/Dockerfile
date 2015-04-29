#! /bin/bash
shopt -s expand_aliases

CONTAINER_IP=$(ifconfig | grep 172 | awk '{ print $2 }' | awk 'BEGIN { FS=":" }; { print $2 }')
source /opt/virtualenv/management/bin/activate
export MANAGEMENT_POLLING_URL="http://${HOST_IP}:${HOST_WS_PORT}"
export MANAGEMENT_MODEL_URL="http://127.0.0.1:8888"
export MANAGEMENT_ALLOWED_ORDER_POST_IPS="127.0.0.1,${CONTAINER_IP}"
export MANAGEMENT_MONGODB_URI="mongodb://127.0.0.1:27017/management"
export MANAGEMENT_LOG_FILE_PREFIX="/var/log/Management/management.log"
export MANAGEMENT_LOG_TO_STDERR="0"
export MANAGEMENT_DEBUG="1"
cd /docker/src/Management

alias _START_="nohup python run.py --port=8000 1> /dev/null 2> /dev/null &"
alias _PID_="ps axw | egrep 'python\ run\.py\ --port=8000' | awk '{ print \$1 }'"
alias _KILL_="kill -9"

COMMAND="$1"
PID=$(_PID_)

case ${COMMAND} in
status)
        if [ ! -z "${PID}" ]; then
            echo "running pid: ${PID}"
        else
            echo "stoped"
        fi
        ;;
start)
        if [ -z "${PID}" ]; then
            _START_
            PID=$(_PID_)
            echo "running ${PID}"
        else
            echo "already running: nothing to start"
        fi
        ;;
stop)
        if [ -z "${PID}" ]; then
            echo "not running: nothing to stop"
        else
            _KILL_ ${PID}
            echo "kill -9 ${PID}"
        fi
        ;;
restart)
        if [ ! -z "${PID}" ]; then
            _KILL_ ${PID}
        fi
        _START_
        PID=$(_PID_)
        echo "new pid: ${PID}"
        ;;
*)
        echo
        echo "$0 status/start/stop/restart"
        echo
esac        

