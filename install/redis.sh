#!/usr/bin/env bash
# install redis 

log() {
  echo -e  "\e[1;35m------------------------ $@ ------------------------------\e[0m"
}

log 下载
wget http://download.redis.io/releases/redis-4.0.11.tar.gz
tar xzf redis-4.0.11.tar.gz
cd redis-4.0.11
log 编译
make
log 软连接
[ ! -d $HOME/bin ] &&  mkdir $HOME/bin
ln -s $PWD/redis-4.0.11/src/redis-server $HOME/bin/redis-server
ln -s $PWD/redis-4.0.11/src/redis-cli $HOME/bin/redis-cli


