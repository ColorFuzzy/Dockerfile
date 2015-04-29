#! /bin/bash
shopt -s expand_aliases

cd /docker/src/DeliveryHeroChina
source /opt/virtualenv/deliveryherochina/bin/activate
export OPERATION_MODE='LIVEDEV'
export PYTHONPATH=/opt/virtualenv/deliveryherochina/bin/
export DJANGO_SETTINGS_MODULE=dowant.settings
export MANAGEMENT_PREFIX='http://127.0.0.1:8000'
export CALL_CENTER_HOST='http://127.0.0.1:8000'
export REPORT_CACHE_HOST='0.0.0.0'  # ignore
export REPORT_CACHE_PORT='6379'
export REPORT_RAW_CACHE_HOST='0.0.0.0'  # 6G, ignore
export REPORT_RAW_CACHE_PORT='6380'
export COUPON_USAGE_CACHE_HOST="127.0.0.1"
export COUPON_USAGE_CACHE_PORT="6381"
export COUPON_USAGE_CACHE_HOST="127.0.0.1"
export COUPON_USAGE_CACHE_PORT="6382"
export TIMER_RESOURCE_HOST='http://127.0.0.1:23459'
export TIMER_CALLBACK_HOST='http://127.0.0.1:4003'
export CACHE_SERVER_HOST='http://190.0.0.1:23457'

# -------------------------------------------------------------------------------
export WIRELESS_PRINT_SERVICE_HOST="http://127.0.0.1:8008"
export RESTAURANT_ADMIN_WEB_SOCKET_ADDR="http://0.0.0.0:0000"
export RESTAURANT_ADMIN_WEB_SOCKET_ADDR_FOR_CLIENT="http://0.0.0.0:0000"
export QINIU_CALLBACK_HOST="http://127.0.0.1:8008"  # ignore
export SMS_MONITOR_SERVER_ADDR="http://127.0.0.1:8080"
export SMS_SENDING_SERVER_ADDR="http://127.0.0.1:8080"
export ONLINE_PAY_SERVER="http://114.215.135.238:8080"
export ALIPAY_SELLER_EMAIL=""
export ONLINE_PAY_IP_ADDRESSES=""
export ONLINE_PAY_ALLOWED_IP_ADDRESSES=[]
export RESTAURANT_ADMIN_REFUND_SOCKET_ADDR=''
export RESTAURANT_ADMIN_REFUND_SOCKET_ADDR_FOR_CLIENT=''
export ONLINE_PAY_SERVER_TOKEN=''
export RESTAURANT_ADMIN_WEB_SOCKET_HTTPS_ADDR_FOR_CLIENT=''
# -------------------------------------------------------------------------------

alias _START_="(/opt/virtualenv/deliveryherochina/bin/python dowant/manage.py collectstatic --noinput) ;
               (nohup python dowant/manage.py runserver 0.0.0.0:8888 &) ;
               (sleep 3)"
alias _PID_="ps axw | egrep '/opt/virtualenv/deliveryherochina/bin/python\ dowant/manage\.py\ runserver' | awk '{ print \$1 }'"
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

