#!/usr/bin/env bash
# author: feihai
# oss backup script
#

DEBUG=0
CONFIG_FILE=/etc/default/oss_backup.conf
LOG_FILE=/var/log/oss_backup.log
OSS_UTIL_CONFIG_FILE=~/.ossutilconfig

log() {
  echo -e  "\e[1;35m------------------------ $@ ------------------------------\e[0m"
}

die() {
    printf 'error: %s.\n' "$1" >&2
    exit 1
}

debug() {
  [ $DEBUG -eq 1 ] && echo $@
}

usage() {
  cat <<EOF
  Usage: 
    oss_backup.sh src_path dest_oss_url  本地文件上传到oss
    oss_backup.sh src_oss_url dest_path  从oss下载文件到本地
    ossutil -h                           查看更多ossutil帮助信息
EOF
exit 0;
}

check_ossutil() {
  if ! type -p ossutil &>/dev/null; then
      log 安装ossutil
      wget http://gosspublic.alicdn.com/ossutil/1.6.14/ossutil64 -O /usr/local/bin/ossutil && chmod +x /usr/local/bin/ossutil
  fi
}

config_oss() {
  [[ $OSS_REGION == "" || $OSS_ACCESS_KEY_ID == "" || $OSS_ACCESS_KEY_SECRET == "" ]] && die "请配置文件$CONFIG_FILE"
  ossutil config -e $OSS_REGION -i $OSS_ACCESS_KEY_ID -k $OSS_ACCESS_KEY_SECRET -L CH -c $OSS_UTIL_CONFIG_FILE
}

md5() {
  echo -n $@ | md5sum | awk '{print $1}'
}

set_do_timestamp() {
  # Usage: set_do_timestamp "str" "LOG_FILE"
    local str_md5=$(md5 $1)
    local log_file=$2
    local timestamp=$(date +%s)
    echo $str_md5 $timestamp  | tee $log_file
}

get_latest_do_timestamp() {
  # Usage: set_do_timestamp "str" "LOG_FILE"
  local str_md5=$(md5 $1)
  local log_file=$2
  grep "$str_md5" $log_file | awk '{print $2}' | tail -1
}



load_config_file() {
  [ -e $CONFIG_FILE ] && {
    . $CONFIG_FILE
  } || {
      cat > $CONFIG_FILE <<EOF
  OSS_REGION=oss-cn-shenzhen.aliyuncs.com
  OSS_ACCESS_KEY_ID=
  OSS_ACCESS_KEY_SECRET=

  # 数组元素格式：'src_path\$oss_url\$exec_interval_seconds' 或 'src_path\$oss_url', 注意：使用单引号
  # src_path: 本地文件，如果是目录则上传目录里的所有文件  oss_url：oss地址  exec_interval_seconds：至少多少秒后才能上传，不指定则默认为0秒
  PUSH_FILE_TO_OSS_ARRAY=(
  #  '/path/to/file\$oss_url\$exec_interval_seconds'
  )
  # 区别上面的数组在于，上传前先压缩    
  TAR_AND_PUSH_FILE_TO_OSS_ARRAY=(
  #  '/path/to/file\$oss_url\$exec_interval_seconds'

  ) 
EOF
  . $CONFIG_FILE
  }
}

tar_file() {
  local tar_file_name=/tmp/$(date +%s)_${1##*/}.tar.gz
  tar -Pzcvf $tar_file_name $1 2>&1 > /dev/null
  echo $tar_file_name
}

cron_job_push_to_oss() {
  for item in "${PUSH_FILE_TO_OSS_ARRAY[@]}"
  do
  echo 111
    handle_item $item
  done

  for item2 in "${TAR_AND_PUSH_FILE_TO_OSS_ARRAY[@]}"
  do
  echo 2222
    handle_item $item2 1
  done
}

handle_item() {
  local item=$1
  echo $item
  local is_tar=$2
  IFS=$ read -ra arr <<<$item
  # 源文件
  src_path=${arr[0]}
  # 压缩
  [ $is_tar -eq 1 ] && src_path=$(tar_file $src_path)
  # oss地址
  dest_oss_url=${arr[1]}
  # 执行间隔，单位: 秒
  exec_interval_seconds=${arr[2]}

  cmd_str="ossutil cp -r $src_path $dest_oss_url"

  latest_do_timestamp=$(get_latest_do_timestamp $cmd_str $LOG_FILE)
  now=$(date +%s)
  
  echo 上次执行  $cmd_str  时间：$latest_do_timestamp
  echo 相差$((${now:-0} - ${latest_do_timestamp:-0}))秒
  echo 至少相差${exec_interval_seconds:-0}秒才执行
  [[ $exec_interval_seconds = "" || $(($now - $latest_do_timestamp > $exec_interval_seconds)) == "1" ]] && {
    echo 执行：$cmd_str
    set_do_timestamp $cmd_str $LOG_FILE
    exec $cmd_str 2>&1 | tee $LOG_FILE
  } || {
    echo 不执行
  }
}

manual_oss_push_or_pull() {
  cmd_str="ossutil cp -r $1 $2"
  echo 执行：$cmd_str
  exec $cmd_str 2>&1 | tee $LOG_FILE
}

main() {
  check_ossutil

  load_config_file

  config_oss

  [[ $1 == "-h" || $1 == "--help" ]] && usage

  [ $# -ge 2 ] && {
    manual_oss_push_or_pull $@
  } || {
    cron_job_push_to_oss
  }
}

main $@