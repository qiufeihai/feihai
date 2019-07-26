
#!/usr/bin/env bash
# author: feihai
# rds data to mysql

log() {
  echo -e  "\e[1;35m------------------------ $@ ------------------------------\e[0m"
}

if ! type -p xtrabackup &>/dev/null; then
log 安装xtrabackup
yum install -y http://www.percona.com/downloads/percona-release/redhat/0.1-4/percona-release-0.1-4.noarch.rpm
fi

xtrabackup -v

log 恢复备份文件
innobackupex --defaults-file=./backup-my.cnf --apply-log .

log 注释backup-my.cnf自建数据库不支持的参数
sed -i '{
  /innodb_log_checksum_algorithm/c #innodb_log_checksum_algorithm
  /innodb_fast_checksum/c #innodb_fast_checksum
  /innodb_log_block_size/c #innodb_log_block_size
  /innodb_doublewrite_file/c #innodb_doublewrite_file
  /rds_encrypt_data/c #rds_encrypt_data
  /innodb_encrypt_algorithm/c #innodb_encrypt_algorithm
  /redo_log_version/c #redo_log_version
  /master_key_id/c #master_key_id
}' backup-my.cnf


if ! type -p docker &>/dev/null; then
    log 安装docker
    curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/docker.sh | bash
fi

log 启动临时数据库命令：
cat << EOF
docker run --name tmpmysql  \
-p 3308:3306 \
-v $PWD:/var/lib/mysql \
-d mysql:5.6 \
--skip-grant-tables
EOF