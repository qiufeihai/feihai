#!/usr/bin/env bash
# author: feihai
# nginx add module script
log() {
  echo -e  "\e[1;35m------------------------ $@ ------------------------------\e[0m"
}
[[ "$1" == '-h' || "$1" == '--help' || "$1" == "" ]] && {
  echo "Usage: $0 <configue options> [nginx_version]"
  exit 0
}

if ! type -p nginx &>/dev/null; then
  log 请先安装nginx
  exit 0
fi

log 安装 pcre-devel openssl openssl-devel
sudo yum -y install pcre-devel openssl openssl-devel
sudo yum groups install -y "Development Tools" 

dir=/tmp/nginx
mkdir -p $dir
cd $dir
nginx_version=`nginx -v 2>&1 | grep -oP '/\K.*'`
nginx_version=${nginx_version:-1.16.0}
[ $2 ] && nginx_version=$2
log nginx_version: $nginx_version
[ -f nginx-${nginx_version}.tar.gz ] || {
wget http://nginx.org/download/nginx-${nginx_version}.tar.gz
tar -zxvf nginx-${nginx_version}.tar.gz -C .
}
cd nginx-${nginx_version}
cp `which nginx`{,.bak}
log 备份旧nginx命令为 `which nginx`.bak
#echo " `nginx -V 2>&1 | sed "s/\s\+--/ --/g" | grep -oP 'configure arguments:\K.*'` $1" | xargs -I {} ./configure {}
echo " `nginx -V 2>&1 | sed "s/\s\+--/ --/g" | grep -oP 'configure arguments:\K.*'` $1" > $dir/args
log 复制以下语句执行
echo "cd $dir/nginx-${nginx_version}/ && ./configure  `cat $dir/args` && make && make install && cp $dir/nginx-${nginx_version}/objs/nginx `which nginx`"
#log 覆盖nginx命令，复制并执行：cp $dir/nginx-${nginx_version}/objs/nginx `which nginx`
