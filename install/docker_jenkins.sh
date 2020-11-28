#!/usr/bin/env bash
#
# docker install jenkins
#

log() {
  echo -e  "\e[1;35m------------------------ $@ ------------------------------\e[0m"
}

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
  # add_cmd_arg_prompt "请输入参数" "args {{default_value}}"
  local prompt=$1
  local arg=$2
  local default_input=$(echo $arg | sed -nE 's/^.*\{\{(.*)\}\}.*$/\1/p')

  [ -z "$prompt" ] && die "缺少参数prompt"
  [ -z "$arg" ] && die "缺少参数arg"

  # echo $default_input
  prompt=${prompt}${default_input:+(默认：$default_input)}:
  read -p $prompt input
  cmd_str=$cmd_str' '${arg//\{\{*\}\}/${input:-$default_input}}
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
  # add_cmd_arg_yn_prompt "是否添加某参数" "请输入参数" "args {{default_value}}"
  local prompt=$1
  [ -z "$prompt" ] && die "缺少参数yn_prompt"
  yn $prompt && {
    shift;
    add_cmd_arg_prompt $@
  }
}

add_cmd_arg "docker run -d --restart always"
add_cmd_arg_prompt "请输入容器名称" "--name {{jenkins}}"
add_cmd_arg_prompt "请输入web端口" "-p {{8080}}:8080"
add_cmd_arg_prompt "请输入api端口" "-p {{50000}}:50000" 
add_cmd_arg_prompt "请输入数据目录" "-v {{/mnt/jenkins/data}}:/var/jenkins_home" 
add_cmd_arg "-u 0 jenkins"

echo $cmd_str
exec $cmd_str

echo "执行：docker exec -it jenkins cat /var/jenkins_home/secrets/initialAdminPassword  获取初始密码"