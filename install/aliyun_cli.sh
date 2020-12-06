#!/usr/bin/env bash
# author: feihai
#  install aliyun cli 、oss client
#  https://github.com/aliyun/aliyun-cli
#
#  
#  配置AccessKey凭证: https://help.aliyun.com/document_detail/121259.html?spm=a2c4g.11186623.6.551.63fd1213DAdeVH
#  aliyun configure set \
# --profile akProfile \
# --mode AK \
# --region cn-hangzhou \
# --access-key-id AccessKeyId \
# --access-key-secret AccessKeySecret
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
  # Usage: add_cmd_arg_prompt "请输入参数" "args {{default_value}}" "input_var_name" "input_var_name"
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


log 下载aliyun_cli到/tmp/aliyun-cli-linux-3.0.46-amd64.tgz解压为/usr/local/bin/aliyun
wget https://aliyuncli.alicdn.com/aliyun-cli-linux-3.0.46-amd64.tgz -O /tmp/aliyun-cli-linux-3.0.46-amd64.tgz \
&& tar -zxvf /tmp/aliyun-cli-linux-3.0.46-amd64.tgz -C /usr/local/bin/

log 执行aliyun查看帮助信息