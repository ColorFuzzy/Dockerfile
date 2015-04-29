#! /bin/bash
COMMAND=$1
PG_COMMAND=/etc/init.d/postgresql

case ${COMMAND} in
status)
        ${PG_COMMAND} status
        ;;
start)
        ${PG_COMMAND} start
        ;;
stop)
        ${PG_COMMAND} stop
        ;;
restart)
        ${PG_COMMAND} restart
        ;;
*)
        echo
        echo "$0 status/start/stop/restart"
        echo
esac
