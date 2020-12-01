#!/usr/bin/env bash
# author: feihai
# uninstall mongodb
log() {
  echo -e  "\e[1;35m------------------------ $@ ------------------------------\e[0m"
}
log 卸载mongodb
sudo yum erase -y  $(rpm -qa | grep mongodb-org)
sudo yum clean all
echo "执行："
echo "sudo rm -r /var/log/mongodb"
echo "sudo rm -r /var/lib/mongo"
