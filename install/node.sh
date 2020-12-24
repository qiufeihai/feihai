#!/usr/bin/env bash
# install nvm and node

log() {
  echo -e  "\e[1;35m------------------------ $@ ------------------------------\e[0m"
}

log 安装nvm
git clone https://github.com/cnpm/nvm.git ~/.nvm && cd ~/.nvm && git checkout `git describe --abbrev=0 --tags`
echo ". ~/.nvm/nvm.sh" >> /etc/profile
source /etc/profile

log nvm加速
export NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node
log 安装node
nvm install --lts
node -v
log 设置npm淘宝镜像
npm config set registry https://registry.npm.taobao.org
npm config set ELECTRON_MIRROR http://npm.taobao.org/mirrors/electron/
