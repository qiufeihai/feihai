#!/usr/bin/env bash
# author: feihai
# install ffmpeg
log() {
  echo -e  "\e[1;35m------------------------ $@ ------------------------------\e[0m"
}
log 添加Nux源
sudo rpm -v --import http://li.nux.ro/download/nux/RPM-GPG-KEY-nux.ro
sudo rpm -Uvh http://li.nux.ro/download/nux/dextop/el7/x86_64/nux-dextop-release-0-5.el7.nux.noarch.rpm

log 安装ffmpeg ffmpeg-devel
sudo yum install -y ffmpeg ffmpeg-devel

ffmpeg -version
