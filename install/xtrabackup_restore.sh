
#!/usr/bin/env bash
# author: feihai
# xtrabackup 进行备份恢复

log() {
  echo -e  "\e[1;35m------------------------ $@ ------------------------------\e[0m"
}

check_xtrabackup_install() {
  if ! type -p xtrabackup &>/dev/null; then
  log 安装xtrabackup
  sudo yum install -y https://repo.percona.com/yum/percona-release-latest.noarch.rpm
  sudo percona-release enable-only tools release
  sudo yum install -y percona-xtrabackup-24
  fi
}

read_input() {
  while [ -z "$DATA_DIR" ]
  do
  read -p '请输入数据目录(默认:/var/lib/mysql)：' DATA_DIR;
  DATA_DIR=${DATA_DIR:="/var/lib/mysql"}
  done

  while [ -z "$TARGE_DIR" ]
  do
  read -p '请输入备份保存目录：' TARGE_DIR;
  TARGE_DIR=${TARGE_DIR}
  done

  BACKUP_DIR_NAME=full-`date '+%Y-%m-%d-%H-%M'`-`uuidgen -t`

}

# 如果是压缩文件就解压
uncompressing() {
  echo $TARGE_DIR  | grep -qE 'tar.gz$' && {
    BACKUP_DIR=`dirname $TARGE_DIR`/`tar -ztvf $TARGE_DIR | awk '{print $6}'`
    tar -zxvf $TARGE_DIR -C `dirname $TARGE_DIR` && rm -f $TARGE_DIR
    TARGE_DIR=$BACKUP_DIR
  }
}

exec_cmd() {
  log 停止mysqld
  systemctl stop mysqld
  log 备份数据目录
  mv $DATA_DIR{,.`date '+%Y-%m-%d-%H-%M'.bak`} -v
  log 解压
  uncompressing
  log 准备
  xtrabackup --prepare --target-dir=$TARGE_DIR && \
  log 恢复
  xtrabackup --move-back --datadir=$DATA_DIR  --target-dir=$TARGE_DIR
  log 设置数据目录所属用户和用户组为mysql
  chown -R mysql:mysql $DATA_DIR
}

main() {
  check_xtrabackup_install
  read_input
  exec_cmd
}

main