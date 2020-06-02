#!/usr/bin/env bash
# author: feihai
#  install pyenv (python 版本管理)

log() {
  echo -e  "\e[1;35m------------------------ $@ ------------------------------\e[0m"
}

[[ `id -u` -ne 0 ]] && {
    echo "Please run as root"; 
    exit 1;
}

install_pyenv() {
  [ ! type -p pyenv &>/dev/null ] && {
    log 下载依赖
    yum install -y @development zlib-devel bzip2 bzip2-devel readline-devel sqlite \
    sqlite-devel openssl-devel xz xz-devel libffi-devel findutils

    yum install -y compat-openssl10-devel --allowerasing

    log 安装pyenv
    curl https://pyenv.run | bash && sleep 3 && load_pyenv
  } || {
    log 已存在pyenv
    load_pyenv
  }
}

load_pyenv() {
  [[ $SHELL =~ zsh ]] && {
    SHELL_RC=~/.zshrc
  } || {
    SHELL_RC=~/.bashrc
  }
  grep -q pyenv $SHELL_RC || {
cat >> $SHELL_RC <<-EOF
  export PATH="/root/.pyenv/bin:$PATH"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
EOF
  }
}

install_pyenv_virtualenv() {
  if ! type -p pyenv &>/dev/null; then
    log 请先安装pyenv
    exit 1;
  fi
  log 安装pyenv-virtualenv
}

install_pipenv() {
  [ ! type -p pipenv &>/dev/null ] && {
    log 安装pipenv
    pip install pipenv
  } || {
    log 已存在pipenv
  }
}

install_pyenv && install_pyenv_virtualenv && install_pipenv
