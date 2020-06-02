#!/usr/bin/env bash
# author: feihai
#  install pyenv (python 版本管理)

log() {
  echo -e  "\e[1;35m------------------------ $@ ------------------------------\e[0m"
}

[[ `id -u` -ne 0 ]] && {
    echo "Please run as root"; 
    exit 1;
}

log 下载依赖
yum install -y @development zlib-devel bzip2 bzip2-devel readline-devel sqlite \
sqlite-devel openssl-devel xz xz-devel libffi-devel findutils

yum install -y compat-openssl10-devel --allowerasing

log 安装
curl https://pyenv.run | bash
