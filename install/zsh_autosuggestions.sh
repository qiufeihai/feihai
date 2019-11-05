#!/usr/bin/env bash
log () {
  echo "------------------- $@ ----------------------"
}

if ! type -p zsh &>/dev/null; then
    log 安装zsh
    sudo yum install -y zsh
fi

log "install zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

cat >> ~/.zshrc << EOF
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
EOF


if type -p zsh &>/dev/null; then
    log "zsh as default shell"
    chsh -s `grep zsh /etc/shells`
fi

log "安装完成，把~/.bashrc中有用的配置复制到~/.zshrc并重新启动shell"
