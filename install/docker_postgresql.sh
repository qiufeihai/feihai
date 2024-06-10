#!/usr/bin/env bash
# author: feihai
#  install postgresql

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


read -p '请输入容器名(默认：postgresql)：' CONTAINER_NAME;
CONTAINER_NAME=${CONTAINER_NAME:-postgresql}

read -p '请输入postgresql版本(默认：latest)：' VERSION;
VERSION=${VERSION:-latest}

read -p '请输入端口(默认：5432)：' PORT;
PORT=${PORT:-5432}

read -p '请输入数据目录(默认：/mnt/postgresql)：' DATA_DIR;
DATA_DIR=${DATA_DIR:-/mnt/postgresql}

# read -p '请输入配置文件目录(默认：/mnt/mysql/conf.d)：' CONF_DIR;
# CONF_DIR=${CONF_DIR:-/mnt/mysql/conf.d}

read -p '请输入roo密码(默认：123456)：' ROOT_PASSWORD;
ROOT_PASSWORD=${ROOT_PASSWORD:-123456}

echo $CONTAINER_NAME $PORT $DATA_DIR $CONF_DIR $ROOT_PASSWORD

docker run --name $CONTAINER_NAME \
--restart always \
-p $PORT:5432 \
-e POSTGRES_PASSWORD=$ROOT_PASSWORD \
-e PGDATA=/var/lib/postgresql/data/pgdata \
-v $DATA_DIR:/var/lib/postgresql/data \
-d mysql:$VERSION
