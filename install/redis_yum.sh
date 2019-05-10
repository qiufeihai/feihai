#!/usr/bin/env bash
# install redis with yum 

log() {
  echo -e  "\e[1;35m------------------------ $@ ------------------------------\e[0m"
}

log 安装并启用remi源
sudo yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum-config-manager --enable remi

log 安装redis
sudo yum install -y redis

log systemctl 启动和开机启动
sudo systemctl start redis
sudo systemctl enable redis