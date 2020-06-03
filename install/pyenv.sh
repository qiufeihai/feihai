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
    curl https://pyenv.run | bash
  } || {
    log 已存在pyenv
  }
}

load_pyenv() {
  [ ! type -p pyenv &>/dev/null ] && {
    log 请先安装pyenv
  } || {
    [[ $SHELL =~ zsh ]] && {
      SHELL_RC=~/.zshrc
    } || {
      SHELL_RC=~/.bashrc
    }
    log 加载pyenv配置
    grep -q pyenv $SHELL_RC || {
      cat >> $SHELL_RC <<-EOF
        export PATH="/root/.pyenv/bin:$PATH"
        eval "$(pyenv init -)"
        eval "$(pyenv virtualenv-init -)"
EOF
    }
  }

}

install_pyenv_virtualenv() {
  if ! type -p pyenv &>/dev/null; then
    log 请先安装pyenv
    return 1;
  fi
  log 安装pyenv-virtualenv
  git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv
}

install_pipenv() {
  [ ! type -p pipenv &>/dev/null ] && {
    log 安装pipenv
    pip install pipenv
  } || {
    log 已存在pipenv
  }
}

PS3='请选择命令: '
options=(
  "安装pyenv"
  "加载pyenv配置"
  "安装pyenv-virtualenv"
  "安装pipenv"
  "退出"
)
select opt in "${options[@]}"
do
    case $opt in
        "安装pyenv")
        install_pyenv
            ;;
        "加载pyenv配置")
        load_pyenv
            ;;
        "安装pyenv-virtualenv")
        install_pyenv_virtualenv
            ;;
        "安装pipenv")
        install_pipenv
            ;;
        "退出")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
