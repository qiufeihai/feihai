#!/usr/bin/env bash
# init linux 
[[ `id -u` -ne 0 ]] && {
    echo "Please run as root" >&2
    exit 1;
}

log() {
  echo -e  "\e[1;35m------------------------ $@ ------------------------------\e[0m"
}

if ! type -p sudo &>/dev/null; then
    log 安装sudo
    yum install -y sudo
fi

log 安装epel源
sudo yum install -y epel-release

log 设置上海时区
timedatectl set-timezone "Asia/Shanghai"

log 安装基础工具
sudo yum groups install -y "Minimal Install" 
sudo yum groups install -y "Development Tools" 
sudo yum groups install -y "Chinese Support" 
sudo yum groups install -y "fonts" 
sudo yum install -y "net-tools"
sodu yum install -y bash-completion
sudo yum install -y wget
sudo yum install -y iproute
sudo yum install -y lrzsz
sudo yum install -y psmisc # killall命令
sudo yum install -y nc
sudo yum install -y bind-utils # dig命令

log 安装常用工具
sudo yum install -y tmux
sudo yum install -y htop
sudo yum install -y ncdu
sudo yum install -y telnet

if ! type -p vim &>/dev/null; then
    log 安装vim
    sudo yum install -y vim
fi

if ! type -p ansible &>/dev/null; then
    log 安装ansible
    sudo yum install -y ansible
    sudo yum install -y python-argcomplete
    sudo activate-global-python-argcomplete
fi

if ! type -p zsh &>/dev/null; then
    log 安装zsh
    sudo yum install -y zsh
fi

# tmux auto start
cat >> ~/.zshrc <<EOF
if [ -z "\$TMUX" ]
then
    tmux attach -t tmux || tmux new -s tmux
fi
EOF