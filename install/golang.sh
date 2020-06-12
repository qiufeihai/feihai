#!/usr/bin/env bash
# author: feihai
#  install golang

log() {
  echo -e  "\e[1;35m------------------------ $@ ------------------------------\e[0m"
}

log 安装golang
rpm --import https://mirror.go-repo.io/centos/RPM-GPG-KEY-GO-REPO
curl -s https://mirror.go-repo.io/centos/go-repo.repo | tee /etc/yum.repos.d/go-repo.repo
yum install -y golang
