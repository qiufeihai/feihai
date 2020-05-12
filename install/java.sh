#!/usr/bin/env bash
# author: feihai
#  install Oracle jdk8  maven

log() {
  echo -e  "\e[1;35m------------------------ $@ ------------------------------\e[0m"
}

log 安装Oracle jdk8
wget  -O  jdk-8u131-linux-x64.rpm --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.rpm
rpm -ivh jdk-8u131-linux-x64.rpm

log 安装maven 
wget http://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -O /etc/yum.repos.d/epel-apache-maven.repo
yum install -y apache-maven
