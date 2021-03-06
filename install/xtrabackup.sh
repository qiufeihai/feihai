
#!/usr/bin/env bash
# author: feihai
# install xtrabackup
# mysql 备份恢复工具

log() {
  echo -e  "\e[1;35m------------------------ $@ ------------------------------\e[0m"
}

if ! type -p xtrabackup &>/dev/null; then
log 安装xtrabackup
yum install -y https://repo.percona.com/yum/percona-release-latest.noarch.rpm
percona-release enable-only tools release
yum install -y percona-xtrabackup-24
fi

xtrabackup -v
