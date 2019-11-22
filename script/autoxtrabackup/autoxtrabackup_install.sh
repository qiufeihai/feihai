#!/usr/bin/env bash

log() {
  echo -e  "\e[1;35m------------------------ $@ ------------------------------\e[0m"
}

if ! type -p xtrabackup &>/dev/null; then
log 安装xtrabackup
yum install -y https://repo.percona.com/yum/percona-release-latest.noarch.rpm
percona-release enable-only tools release
yum install -y percona-xtrabackup-24
fi

if ! type -p qpress &>/dev/null; then
log 安装压缩工具qpress
yum install -y qpress
fi

log 下载命令
curl -L https://raw.githubusercontent.com/qiufeihai/feihai/master/script/autoxtrabackup/autoxtrabackup.sh -o autoxtrabackup &&
sudo chmod +x autoxtrabackup && sudo mv autoxtrabackup /usr/local/bin/autoxtrabackup

log 下载配置文件
curl -L https://raw.githubusercontent.com/qiufeihai/feihai/master/script/autoxtrabackup/autoxtrabackup.config -o autoxtrabackup &&
sudo mv autoxtrabackup /etc/default/autoxtrabackup

log 命令路径/usr/local/bin/autoxtrabackup
log 配置文件路径/etc/default/autoxtrabackup
