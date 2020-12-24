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

log 设置中科大yum源
sudo sed -e 's|^mirrorlist=|#mirrorlist=|g' \
         -e 's|^#baseurl=http://mirror.centos.org/centos|baseurl=https://mirrors.ustc.edu.cn/centos|g' \
         -i.bak \
         /etc/yum.repos.d/CentOS-Base.repo
log 安装epel源
sudo yum install -y epel-release
log epel设置中科大源
sed -e 's!^mirrorlist=!#mirrorlist=!g' \
	-e 's!^#baseurl=!baseurl=!g' \
	-e 's!^metalink!#metalink!g' \
	-e 's!//download\.fedoraproject\.org/pub!//mirrors.ustc.edu.cn!g' \
	-e 's!http://mirrors\.ustc!https://mirrors.ustc!g' \
	-i.bak /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel-testing.repo

sudo yum clean all
sudo yum makecache

log 重装man pages，处理No manual entry 问题
[ -e /etc/yum.conf ] && grep -qE 'tsflags=nodocs' /etc/yum.conf && {
    sudo sed -i '/tsflags=nodocs/d' /etc/yum.conf
    sudo yum remove -y man-pages man-db
    sudo yum install -y man-pages man-db
    # Reinstall all packages to get man pages for them
    sudo yum -y reinstall "*" && yum clean all 
} 



log 安装yum-utils
sudo yum install -y yum-utils

log 安装ntp服务，同步时间
sudo yum install -y ntp
systemctl enable ntpd
systemctl start ntpd
timedatectl set-ntp yes
ntpq -p
# todo 设置时间服务器地址

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

# tmux 设置vi模式
cat >> ~/.tmux.conf <<EOF
setw -g mode-keys vi
bind-key -t vi-copy 'v' begin-selection
bind-key -t vi-copy 'y' copy-selection
EOF
tmux source ~/.tmux.conf > /dev/null 2>&1
