#!/usr/bin/env bash
# author: feihai
# install mongodb4.2
log() {
  echo -e  "\e[1;35m------------------------ $@ ------------------------------\e[0m"
}
log 添加yum.repo
cat > /etc/yum.repos.d/mongodb-org-4.2.repo << EOF
[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/4.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.asc
EOF

log 安装mongodb
sudo yum install -y mongodb-org

log 开启服务
sudo systemctl enable mongod
sudo systemctl start mongod

