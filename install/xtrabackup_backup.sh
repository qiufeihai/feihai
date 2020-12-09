
#!/usr/bin/env bash
# author: feihai
# xtrabackup 进行备份

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
  while [ -z "$HOST" ]
  do
  read -p '请输入host(默认:localhost)：' HOST;
  HOST=${HOST:=localhost}
  done

  while [ -z "$PORT" ]
  do
  read -p '请输入port(默认:3306)：' PORT;
  PORT=${PORT:=3306}
  done


  while [ -z "$USERNAME" ]
  do
  read -p '请输入username(默认:root)：' USERNAME;
  USERNAME=${USERNAME:=root}
  done


  while [ -z "$PASSWORD" ]
  do
  read -p '请输入password：' -s PASSWORD;
  echo;
  PASSWORD=${PASSWORD}
  done


  while [ -z "$DATABASE" ]
  do
  read -p '请输入database：' DATABASE;
  DATABASE=${DATABASE}
  done

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

exec_cmd() {
  echo "xtrabackup --host=$HOST --port=$PORT --username=$USERNAME --password=$PASSWORD  --database=$DATABASE --datadir=$DATA_DIR  --backup --target-dir=$TARGE_DIR/$BACKUP_DIR_NAME"
  BACK_LOG=/var/log/mysql_backup.log
  xtrabackup --host=$HOST --port=$PORT --username=$USERNAME --password=$PASSWORD  --database=$DATABASE --datadir=$DATA_DIR  --backup --target-dir=$TARGE_DIR/$BACKUP_DIR_NAME > $BACK_LOG 2>&1
  grep -q "completed OK" $BACK_LOG && {
    tar -cf $TARGE_DIR/$BACKUP_DIR_NAME.tar.gz $TARGE_DIR/$BACKUP_DIR_NAME --remove-files
  }
}

main() {
  check_xtrabackup_install
  read_input
  exec_cmd
}

main