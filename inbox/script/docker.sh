#! /bin/bash

# usage:
# sudo docker.sh status/start/stop/restart <CONTAINER_NAME>

# ================== BEGIN SETTINGS ==================
# these host ports are used to map to the container's
# service port
declare -A HOST_PORTS=(
  ["ssh"]=4009  # map to 22 [ssh]
  ["ws"]=4006  # map to 4001 [web socket]
  ["cc"]=4007  # map to 8000 [management]
  ["django"]=4008  # map to 8888 [deliveryherochina]
)

# docker settings for running a new container
declare -A DOCKER_SETTINGS=(
  ["image"]="lilei_img:latest"
  ["entrypoint"]="/bin/bash"
)
# =================== END SETTINGS ===================


# =================== BEGIN TOOLS ====================
declare -A CONTAINER_STATUS=(
  ["stopped"]="container stopped"
  ["running"]="container running"
  ["not_existed"]="contianer not existed"
)

function exit_on_empty() {
  local var_to_check=$1
  if [ -z "${var_to_check}" ]; then
    echo "empty param string"
    exit -1
  fi
}


function mounted_folder() {
  # todo: this will raise error if
  # the user doesn't run this file on its folder
  echo $(pwd)/..
}


function host_ip() {
  echo $(ifconfig |
         egrep '192.168.1' |
         awk '{ print $2 }' |
         awk 'BEGIN { FS=":" }; { print $2 }')
}


function get_container_id() {
  # if no such id, returns an empty string
  local container_name_or_id=$1
  exit_on_empty ${container_name_or_id}
  echo $(docker ps -a |
         awk 'NR>1 { print $1, $NF }' |
         grep "${container_name_or_id}" |
         awk '{ print $1}')
}


function get_container_status() {
  local container_id=$(get_container_id $1)
  if [ -z "${container_id}" ]; then
    echo ${CONTAINER_STATUS["not_existed"]}
  else
    local grep_id_and_up=$(docker ps -a |
                           grep "${container_id}" |
                           grep "Up ")
    if [ ! -z "${grep_id_and_up}" ]; then
      echo ${CONTAINER_STATUS["running"]}
    else
      echo ${CONTAINER_STATUS["stopped"]}
    fi
  fi
}


function start_container() {
  local container_name=$1
  local container_id=$(get_container_id ${container_name})
  local container_status=$(get_container_status ${container_id})

  # check whether the container already exists
  if [ "${container_status}" == "${CONTAINER_STATUS["running"]}" ]; then
    echo "container already running"
    exit 1
  fi

    docker run \
           -t \
           -i \
           -v $(mounted_folder):/docker \
           -p ${HOST_PORTS["ssh"]}:22 \
           -p ${HOST_PORTS["ws"]}:4001 \
           -p ${HOST_PORTS["cc"]}:8000 \
           -p ${HOST_PORTS["django"]}:8888 \
           --name="${container_name}" \
           --entrypoint=${DOCKER_SETTINGS["entrypoint"]} \
           --env HOST_IP=$(host_ip) \
           --env HOST_WS_PORT=${HOST_PORTS["ws"]} \
           ${DOCKER_SETTINGS["image"]}
}


function stop_container() {
  local container_id=$(get_container_id $1)
  local container_status=$(get_container_status ${container_id})
  case ${container_status} in
    ${CONTAINER_STATUS["not_existed"]})
      echo "container $1 not exist"
      ;;
    ${CONTAINER_STATUS["stopped"]})
      echo "container $1 already stoped, nothing todo"
      ;;
    ${CONTAINER_STATUS["running"]})
      docker stop ${container_id}
      ;;
    *)
      echo "ASK X TO FIX THIS BUG"
      ;;
  esac
}
# ==================== END TOOLS =====================


#=====================================================
function process() {
  local script_name=$1
  local command=$2
  local container_name_or_id=$3
  local container_id=$(get_container_id ${container_name_or_id})
  local container_status=$(get_container_status ${container_id})

  case ${command} in
    status)
      if [ "${container_status}" == "${CONTAINER_STATUS["running"]}" ]; then
        echo "running - [${container_id}]"
      elif [ "${container_status}" == "${CONTAINER_STATUS["stopped"]}" ]; then
        echo "stopped - [${container_id}]"
      else
        echo "container not exist"
      fi
      ;;
    start)
      if [ "${container_status}" == "${CONTAINER_STATUS["running"]}" ]; then
        echo "already running, nothing to do"
      else
        start_container ${container_name_or_id}
      fi
      ;;
    stop)
      if [ "${container_status}" == "${CONTAINER_STATUS["running"]}" ]; then
        stop_container ${container_id}
      else
        echo "already stopped, nothing to do"
      fi
      ;;
    restart)
      if [ "${container_status}" == "${CONTAINER_STATUS["running"]}" ]; then
        stop_container ${container_id}
      fi
      start_container ${container_name_or_id}
      ;;
    *)
      echo "${script_name} status/start/stop/restart ${container_name_or_id}"
      ;;
  esac
}

process $0 $1 $2
