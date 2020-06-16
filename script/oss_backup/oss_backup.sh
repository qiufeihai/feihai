#!/usr/bin/env bash
# author: feihai
# oss backup script
#

#  aliyun configure set \
# --profile akProfile \
# --mode AK \
# --region cn-hangzhou \
# --access-key-id AccessKeyId \
# --access-key-secret AccessKeySecret

DEBUG=1
CONFIG_FILE=/etc/default/oss_backup.conf
LOG_FILE=/var/log/oss_backup.log


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
EOF
}

check_aliyun_cli() {
  if ! type -p aliyun &>/dev/null; then
      curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/aliyun_cli.sh | bash
  fi
}

config_oss() {
  [[ $OSS_PROFILE == "" || $OSS_REGION == "" || $OSS_ACCESS_KEY_ID == "" || $OSS_ACCESS_KEY_SECRET == "" ]] && die "请配置文件$CONFIG_FILE"
  log configure aliyun-cli oss
  aliyun configure set \
  --profile $OSS_PROFILE \
  --mode AK \
  --region $OSS_REGION \
  --access-key-id $OSS_ACCESS_KEY_ID \
  --access-key-secret $OSS_ACCESS_KEY_SECRET
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
    # log 下载配置文件
    # curl -L https://raw.githubusercontent.com/qiufeihai/feihai/master/script/oss_backup/oss_backup.conf -o oss_backup.conf &&
    # sudo mv oss_backup.conf /etc/default/oss_backup.conf
      cat > $CONFIG_FILE <<EOF
  OSS_PROFILE=akProfile
  OSS_REGION=cn-shenzhen
  OSS_ACCESS_KEY_ID=
  OSS_ACCESS_KEY_SECRET=

  # 数组元素格式：src_path\$oss_url\$exec_interval_seconds 或 src_path\$oss_url
  # src_path: 本地文件  oss_url：oss地址  exec_interval_seconds：至少多少秒后才能上传，不指定则默认为0秒
  PUSH_FILE_TO_OSS_ARRAY=(
  )    
EOF
  }
}


check_aliyun_cli

load_config_file

config_oss



[ $# -ge 2 ] && {
  aliyun oss cp $1 $2 2>&1 | tee $LOG_FILE
} || {
  for item in "${PUSH_FILE_TO_OSS_ARRAY[@]}"
  do
    IFS=$ read -ra arr <<<$item
    # 源文件
    src_path=${arr[0]}
    # oss地址
    dest_oss_url=${arr[1]}
    # 执行间隔，单位: 秒
    exec_interval_seconds=${arr[2]}
    cmd_str="aliyun oss cp $src_path $dest_oss_url"
    # echo $cmd_str

    latest_do_timestamp=$(get_latest_do_timestamp $cmd_str $LOG_FILE)
    now=$(date +%s)

    echo 上次执行  $cmd_str  时间：$latest_do_timestamp
    echo 相差$(($now - $latest_do_timestamp))秒
    echo 至少相差${exec_interval_seconds:-0}秒才执行
    [[ $exec_interval_seconds = "" || $(($now - $latest_do_timestamp > $exec_interval_seconds)) == "1" ]] && {
      echo 执行：$cmd_str
      set_do_timestamp $cmd_str $LOG_FILE
      exec $cmd_str 2>&1 | tee $LOG_FILE
    } || {
      echo 不执行
    }
  done
}