#!/usr/bin/env bash
# author: feihai
#  install oss client
#  https://github.com/aliyun/ossutil
#  https://help.aliyun.com/document_detail/120072.html?spm=a2c4g.11186623.2.23.71d6448aEWAqb0#concept-303826
# 交互式配置：ossutil config
# 非交互式配置：ossutil config -e oss-cn-beijing.aliyuncs.com -i LTAIbZcdVCmQ**** -k D26oqKBudxDRBg8Wuh2EWDBrM0****  -L CH -c ~/.ossutilconfig
#
log() {
  echo -e  "\e[1;35m------------------------ $@ ------------------------------\e[0m"
}

log 下载ossutil
wget http://gosspublic.alicdn.com/ossutil/1.6.14/ossutil64 -O /usr/local/bin/ossutil && chmod +x /usr/local/bin/ossutil

log 执行ossutil查看帮助信息