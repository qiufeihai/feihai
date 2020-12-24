#!/usr/bin/env bash
# install nvm and node

log() {
  echo -e  "\e[1;35m------------------------ $@ ------------------------------\e[0m"
}

log 安装nvm
export NVM_DIR="$HOME/.nvm" && (
  git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
  cd "$NVM_DIR"
  git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
) && \. "$NVM_DIR/nvm.sh"

log 引入nvm到zshrc
echo  'export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.zshrc
source $HOME/.zshrc

log nvm加速
export NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node
log 安装node
nvm install --lts
node -v
log 设置npm淘宝镜像
npm config set registry https://registry.npm.taobao.org
npm config set ELECTRON_MIRROR http://npm.taobao.org/mirrors/electron/
