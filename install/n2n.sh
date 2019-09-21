#!/usr/bin/env bash
if ! type -p wget &>/dev/null; then
    sudo yum install -y wget
fi
cd /etc/yum.repos.d/
wget http://packages.ntop.org/centos-stable/ntop.repo -O ntop.repo
rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum erase zeromq3
yum install -y fring n2disk nprobe ntopng ntopng-data cento
