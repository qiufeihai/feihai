#!/usr/bin/env bash
# author: feihai
#  install mysql5.6 or mysql5.7

log() {
  echo -e  "\e[1;35m------------------------ $@ ------------------------------\e[0m"
}

[[ `id -u` -ne 0 ]] && {
    echo "Please run as root" >&2
    exit 1;
}

if ! type -p docker &>/dev/null; then
  echo "请安装docker" >&2
  exit 1;
fi


read -p '请输入容器名(默认：mysql)：' CONTAINER_NAME;
CONTAINER_NAME=${CONTAINER_NAME:-mysql}

read -p '请输入mysql版本(默认：5.7)：' MYSQL_VERSION;
MYSQL_VERSION=${MYSQL_VERSION:-5.7}

read -p '请输入端口(默认：3306)：' PORT;
PORT=${PORT:-3306}

read -p '请输入数据目录(默认：/mnt/mysql/data)：' DATA_DIR;
DATA_DIR=${DATA_DIR:-/mnt/mysql/data}

read -p '请输入配置文件目录(默认：/mnt/mysql/conf.d)：' CONF_DIR;
CONF_DIR=${CONF_DIR:-/mnt/mysql/conf.d}

read -p '请输入roo密码(默认：123456)：' ROOT_PASSWORD;
ROOT_PASSWORD=${ROOT_PASSWORD:-123456}

echo $CONTAINER_NAME $PORT $DATA_DIR $CONF_DIR $ROOT_PASSWORD

docker run --name $CONTAINER_NAME \
--restart always \
-p $PORT:3306 \
-v $DATA_DIR:/var/lib/mysql \
-v $CONF_DIR:/etc/mysql/conf.d \
-e MYSQL_ROOT_PASSWORD=$ROOT_PASSWORD \
-d mysql:$MYSQL_VERSION

cat >> $CONF_DIR/my.cnf << EOF
[mysqld]
innodb_large_prefix = TRUE
innodb_file_format = BARRACUDA
max_connections = 2000

#server-id        = 1
#binlog_format    = row
#log_bin          = mysql-bin
#binlog_do_db     = db_name   # Optional, limit which databases to log
#expire_logs_days = 10          # Optional, purge old logs
#max_binlog_size  = 100M        # Optional, limit log size
EOF