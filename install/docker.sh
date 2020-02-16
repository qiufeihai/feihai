#!/usr/bin/env bash
# author: feihai
#  install docker

log() {
  echo -e  "\e[1;35m------------------------ $@ ------------------------------\e[0m"
}

log 卸载旧版本
sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

log SET UP THE REPOSITORY
sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2

log set up the stable repository
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

log 安装docker
sudo yum install -y docker-ce

log 安装docker-compose 1.25.3
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

log 开启docker服务
sudo systemctl enable docker
sudo systemctl start docker



cat << EOF
若开启不了服务，那可以通过设置DOCKER_HOST指向远端的docker服务：
echo 'export DOCKER_HOST=tcp://127.0.0.1:2375' >> ~/.zshrc && source ~/.zshrc
EOF

