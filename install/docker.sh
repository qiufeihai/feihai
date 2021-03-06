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
                  docker-engine

log SET UP THE REPOSITORY
sudo yum install -y yum-utils
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo


log 安装docker
sudo yum install -y docker-ce docker-ce-cli containerd.io

log 国内镜像加速
mkdir -p /etc/docker/
cat > /etc/docker/daemon.json << EOF
{
  "registry-mirrors": [
    "https://registry.docker-cn.com",
    "http://hub-mirror.c.163.com",
    "https://docker.mirrors.ustc.edu.cn"
  ]
}
EOF

log DaoCloud加速安装docker-compose
sudo curl -L https://get.daocloud.io/docker/compose/releases/download/1.27.4/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

log 开启docker服务
sudo systemctl enable docker
sudo systemctl start docker



cat << EOF
若开启不了服务，那可以通过设置DOCKER_HOST指向远端的docker服务：
echo 'export DOCKER_HOST=tcp://127.0.0.1:2375' >> ~/.zshrc && source ~/.zshrc
EOF

