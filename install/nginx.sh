#!/usr/bin/env bash
# author: feihai
# install nginx

log() {
  echo -e  "\e[1;35m------------------------ $@ ------------------------------\e[0m"
}

log 添加yum.repo
cat > /etc/yum.repos.d/nginx.repo << EOF
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/7/\$basearch/
gpgcheck=0
enabled=1
EOF

log 安装nginx
sudo yum install -y nginx



