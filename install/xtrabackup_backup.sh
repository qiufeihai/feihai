
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

  if type -p mysql_config_editor &>/dev/null; then
      read -p '请输入--login-path，不输入则需要输入账号密码：' LOGIN_PATH;
      while [ ! -z "$LOGIN_PATH" ] && [ -z `mysql_config_editor print | grep -qE "\[$LOGIN_PATH\]" && echo 1` ]
      do
        read -p '请输入--login-path，不输入则需要输入host,port,username,port：' LOGIN_PATH;
      done
  fi

  IS_LOGIN_PATH_EXIST=`mysql_config_editor print | grep -qE "\[$LOGIN_PATH\]"`
  [ -z "$LOGIN_PATH" ] && {
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
    done
  }


  while [ -z "$DATABASE" ]
  do
  read -p '请输入database：' DATABASE;
  done

  while [ -z "$DATA_DIR" ]
  do
  read -p '请输入数据目录(默认:/var/lib/mysql)：' DATA_DIR;
  DATA_DIR=${DATA_DIR:="/var/lib/mysql"}
  done

  while [ -z "$TARGE_DIR" ]
  do
  read -p '请输入备份保存目录：' TARGE_DIR;
  TARGE_DIR=`realpath $TARGE_DIR`
  done

  BACKUP_DIR_NAME=full-`date '+%Y-%m-%d-%H-%M'`-`uuidgen -t`

}

exec_cmd() {
  [ -z "$LOGIN_PATH" ] && {
    LOGIN_PATH="--host=$HOST --port=$PORT --username=$USERNAME --password=$PASSWORD"
  } || {
    LOGIN_PATH="--login-path=$LOGIN_PATH"
  }
  echo "xtrabackup $LOGIN_PATH --database=$DATABASE --datadir=$DATA_DIR  --backup --target-dir=$TARGE_DIR/$BACKUP_DIR_NAME"
  xtrabackup $LOGIN_PATH --database=$DATABASE --datadir=$DATA_DIR  --backup --target-dir=$TARGE_DIR/$BACKUP_DIR_NAME 2>&1 | tee /dev/tty | \
  grep -q "completed OK" && {
    echo "tar -zcf $TARGE_DIR/$BACKUP_DIR_NAME.tar.gz -C $TARGE_DIR $BACKUP_DIR_NAME --remove-files"
    tar -zcf $TARGE_DIR/$BACKUP_DIR_NAME.tar.gz -C $TARGE_DIR $BACKUP_DIR_NAME --remove-files
  }
}

main() {
  check_xtrabackup_install
  read_input
  exec_cmd
}

main