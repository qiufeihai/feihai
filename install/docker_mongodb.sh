#!/usr/bin/env bash
#
# docker install mongodb
#
die() {
    printf 'error: %s.\n' "$1" >&2
    exit 1
}

glob() {
    case $1 in $2) return 0; esac; return 1
}

yn() {
    printf '%s [y/n]: ' "$1"
    stty -icanon
    answer=$(dd ibs=1 count=1 2>/dev/null)
    stty icanon
    printf '\n'
    glob "$answer" '[yY]'
}

cmd_str=""

add_cmd_arg() {
  # add_cmd_arg "args"
    local arg=$1
    [ -z "$arg" ] && die "缺少参数arg"
    cmd_str=$cmd_str' '$arg
    # echo $cmd_str
}

add_cmd_arg_prompt() {
  # Usage: add_cmd_arg_prompt "请输入参数" "args {{default_value}}" "input_var_name"
  # __input数组和input_var_name可以获取prompt输入的值
  local prompt=$1
  local arg=$2
  local input_var_name=$3
  local default_input=$(echo $arg | sed -nE 's/^.*\{\{(.*)\}\}.*$/\1/p')

  [ -z "$prompt" ] && die "缺少参数prompt"
  [ -z "$arg" ] && die "缺少参数arg"

  # echo $default_input
  prompt=${prompt}${default_input:+(默认：$default_input)}:
  read -p $prompt input
  cmd_str=$cmd_str' '${arg//\{\{*\}\}/${input:=$default_input}}
  __input[${#__input[*]}]=$input;
  [ ! -z "$input_var_name" ] && eval "$input_var_name=$input"
  # echo $cmd_str
}
add_cmd_arg_yn() {
  # add_cmd_arg_yn "是否添加某参数" "args"
  local prompt=$1
  local arg=$2
  [ -z "$prompt" ] && die "缺少参数prompt"
  [ -z "$arg" ] && die "缺少参数arg"
  yn $prompt && {
    cmd_str=$cmd_str' '$arg
  }
  # echo $cmd_str
}

add_cmd_arg_yn_prompt() {
  # add_cmd_arg_yn_prompt "是否添加某参数" "请输入参数" "args {{default_value}}" "input_var_name"
  local prompt=$1
  [ -z "$prompt" ] && die "缺少参数yn_prompt"
  yn $prompt && {
    shift;
    add_cmd_arg_prompt $@
  }
}

init_config() {
mkdir -p /mnt/mongodb/conf/
cat > /mnt/mongodb/conf/mongod.conf <<EOF
# mongod.conf

# for documentation of all options, see:
#   http://docs.mongodb.org/manual/reference/configuration-options/

# where to write logging data.
systemLog:
  destination: file
  logAppend: true
  path: /var/log/mongodb/mongod.log

# Where and how to store data.
storage:
  dbPath: /data/db
  journal:
    enabled: true
#  engine:
#  wiredTiger:

# how the process runs
processManagement:
  fork: true  # fork and run in background
  pidFilePath: /var/run/mongodb/mongod.pid  # location of pidfile
  timeZoneInfo: /usr/share/zoneinfo

# network interfaces
net:
  port: 27017
  bindIp: 0.0.0.0  # Enter 0.0.0.0,:: to bind to all IPv4 and IPv6 addresses or, alternatively, use the net.bindIpAll setting.


#security:

#operationProfiling:

#replication:

#sharding:

## Enterprise-Only Options

#auditLog:

#snmp:
EOF
}

add_cmd_arg "docker run -d --restart always"
add_cmd_arg_prompt "请输入容器名称" "--name {{mongodb}}"
add_cmd_arg_prompt "请输入端口" "-p {{27017}}:27017" 
add_cmd_arg_prompt "请输入root用户名" "-e MONGO_INITDB_ROOT_USERNAME={{root}}" 
add_cmd_arg_prompt "请输入root密码" "-e MONGO_INITDB_ROOT_PASSWORD={{123456789}}" 
add_cmd_arg_prompt "请输入数据目录" " -v {{/mnt/mongodb/data}}:/data/db" 
add_cmd_arg_prompt "请输入配置文件目录" " -v {{/mnt/mongodb/conf}}:/etc/mongo" 
add_cmd_arg_prompt "请输入版本" "mongo:{{latest}}"
add_cmd_arg "--config /etc/mongo/mongod.conf"

init_config

echo $cmd_str
exec $cmd_str