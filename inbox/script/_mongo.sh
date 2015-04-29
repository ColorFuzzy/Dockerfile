#! /bin/bash
shopt -s expand_aliases
alias _START_="nohup mongod -f /etc/mongod.conf 1> /dev/null 2> /dev/null &"
alias _PID_="ps axw | egrep 'mongod\ -f\ /etc/mongod.conf' | awk '{ print \$1 }'"
alias _KILL_="kill -9"

COMMAND="$1"
PID=$(_PID_)

case ${COMMAND} in
status)
        if [ ! -z "${PID}" ]; then
            echo "running pid: $PID"
        else
            echo "stoped"
        fi
        ;;
start)
        if [ -z "${PID}" ]; then
            _START_
            PID=$(_PID_)
            echo "running $PID"
        else
            echo "already running: nothing to start"
        fi
        ;;
stop)
        if [ -z "${PID}" ]; then
            echo "not running: nothing to stop"
        else
            _KILL_ ${PID}
            echo "kill -9 $PID"
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
