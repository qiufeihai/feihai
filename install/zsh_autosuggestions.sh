#!/usr/bin/env bash
log () {
  echo "------------------- $@ ----------------------"
}
which zsh > /dev/null
if [ $? -eq 1 ]; then
log "install zsh"
yum install -y zsh
fi

log "install zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

cat >> ~/.zshrc << EOF
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
EOF

log "zsh as default shell"
chsh -s `which zsh`

log "安装完成，把~/.bashrc中有用的配置复制到~/.zshrc并重新启动shell"
