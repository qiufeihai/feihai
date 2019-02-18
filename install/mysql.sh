#!/usr/bin/env bash
# author: feihai
#  install mysql5.6 or mysql5.7

log() {
  echo -e  "\e[1;35m------------------------ $@ ------------------------------\e[0m"
}

log 添加yum源
release=`awk  -F "[ .]" '{print $4}' /etc/redhat-release`
cat << eof > /etc/yum.repos.d/mysql.repo
[mysql56]
name=MySQL
baseurl=http://repo.mysql.com/yum/mysql-5.6-community/el/$release/\$basearch/
enabled=1
gpgcheck=0

[mysql57]
name=MySQL
baseurl=http://repo.mysql.com/yum/mysql-5.7-community/el/$release/\$basearch/
enabled=1
gpgcheck=0
eof

log 安装
sudo yum install -y mysql-community-server

