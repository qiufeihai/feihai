#!/usr/bin/env bash
# author: feihai
# install openresty
# 目录对比nginx -->  openresty
# home: /etc/nginx  -->  /usr/local/openresty/nginx
# html: /usr/share/nginx/html  -->  /usr/local/openresty/nginx/html
# logs: /var/log/nginx  -->  /usr/local/openresty/nginx/logs
log() {
  echo -e  "\e[1;35m------------------------ $@ ------------------------------\e[0m"
}

log 安装openresty
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://openresty.org/package/centos/openresty.repo
sudo yum install -y openresty
sudo yum install -y openresty-resty

log 配置PATH
[ -e ~/.zshrc ] && echo 'export PATH=/usr/local/openresty/nginx/sbin:$PATH' >> ~/.zshrc
[ -e ~/.bashrc ] && echo 'export PATH=/usr/local/openresty/nginx/sbin:$PATH' >> ~/.bashrc

mkdir -p /usr/local/openresty/nginx/conf/conf.d

log 启动服务，开机自启动
systemctl start openresty
systemctl enable openresty

log 请手动添加：include /usr/local/openresty/nginx/conf/conf.d/*.conf; 到http块
