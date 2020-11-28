#!/usr/bin/env bash
# install redis 

log() {
  echo -e  "\e[1;35m------------------------ $@ ------------------------------\e[0m"
}

log 下载
wget https://download.redis.io/releases/redis-6.0.9.tar.gz
tar xzf redis-6.0.9.tar.gz
cd redis-6.0.9
log 编译
make
log 软连接
[ ! -d $HOME/bin ] &&  mkdir $HOME/bin
ln -s $PWD/redis-6.0.9/src/redis-server $HOME/bin/redis-server
ln -s $PWD/redis-6.0.9/src/redis-cli $HOME/bin/redis-cli


