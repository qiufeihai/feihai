#!/usr/bin/env bash
# install nvm and node

log() {
  echo -e  "\e[1;35m------------------------ $@ ------------------------------\e[0m"
}

log 下载nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
log 引入nvm到zshrc
echo  'export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.zshrc
source $HOME/.zshrc
nvm -v
log 安装node
nvm install --lts
node -v

