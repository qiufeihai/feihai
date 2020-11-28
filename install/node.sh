#!/usr/bin/env bash
# install nvm and node

log() {
  echo -e  "\e[1;35m------------------------ $@ ------------------------------\e[0m"
}

log 下载nvm
curl -o- https://raw.staticdn.net/nvm-sh/nvm/v0.37.1/install.sh | bash

log 引入nvm到zshrc
echo  'export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.zshrc
source $HOME/.zshrc
nvm -v
log nvm加速
export NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node
log 安装node
nvm install --lts
node -v
log 设置npm淘宝镜像
npm config set registry https://registry.npm.taobao.org
npm config set ELECTRON_MIRROR http://npm.taobao.org/mirrors/electron/
