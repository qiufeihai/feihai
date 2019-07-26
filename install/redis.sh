#!/usr/bin/env bash
# install redis 

log() {
  echo -e  "\e[1;35m------------------------ $@ ------------------------------\e[0m"
}

log 下载
wget http://download.redis.io/releases/redis-5.0.5.tar.gz
tar xzf redis-5.0.5.tar.gz
cd redis-5.0.5
log 编译
make
log 软连接
[ ! -d $HOME/bin ] &&  mkdir $HOME/bin
ln -s $PWD/redis-5.0.5/src/redis-server $HOME/bin/redis-server
ln -s $PWD/redis-5.0.5/src/redis-cli $HOME/bin/redis-cli


