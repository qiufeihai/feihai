#!/usr/bin/env bash
# author: feihai
# system manage


##########################
#      配置静态IP地址     #
##########################
function config_static_ip() {
local INTERFACE;
local INTERFACE_FILE;
local IPADDR;
local NETMASK;
local GATEWAY;
local DNS1;
local DNS2;
read -p '请输入接口名(默认：enp0s3)：' INTERFACE;
INTERFACE=${INTERFACE:-enp0s3}
INTERFACE_FILE="/etc/sysconfig/network-scripts/ifcfg-${INTERFACE}"

while [ ! -e "${INTERFACE_FILE}" ]
do
read -p '接口不存在，请重新输入接口名(默认：enp0s3)：' INTERFACE;
INTERFACE=${INTERFACE:-enp0s3}
INTERFACE_FILE="/etc/sysconfig/network-scripts/ifcfg-${INTERFACE}"
done

while [ -z "$IPADDR" ]
do
read -p '请输入ip地址：' IPADDR;
IPADDR=${IPADDR}
done

read -p '请输入子网掩码(默认：255.255.255.0)：' NETMASK;
NETMASK=${NETMASK:-255.255.255.0}

while [ -z "$GATEWAY" ]
do
read -p '请输入网关地址：' GATEWAY;
GATEWAY=${GATEWAY}
done

read -p '请输入DNS1(默认：223.5.5.5)：' DNS1;
DNS1=${DNS1:-223.5.5.5}

read -p '请输入DNS2(默认：114.114.114.114)：' DNS2;
DNS2=${DNS2:-114.114.114.114}

# 注释旧配置
sed -Ei s/BOOTPROTO\s*=/#\&/ $INTERFACE_FILE
sed -Ei s/ONBOOT\s*=/#\&/ $INTERFACE_FILE
sed -Ei s/DEVICE\s*=/#\&/ $INTERFACE_FILE
sed -Ei s/IPADDR\s*=/#\&/ $INTERFACE_FILE
sed -Ei s/PREFIX=/#\&/ $INTERFACE_FILE
sed -Ei s/NETMASK\s*=/#\&/ $INTERFACE_FILE
sed -Ei s/GATEWAY\s*=/#\&/ $INTERFACE_FILE
sed -Ei s/DNS1\s*=/#\&/ $INTERFACE_FILE
sed -Ei s/DNS2\s*=/#\&/ $INTERFACE_FILE

# 添加配置
cat >> $INTERFACE_FILE <<EOF

# static 
BOOTPROTO=static
ONBOOT=yes
DEVICE=$INTERFACE
IPADDR=$IPADDR
NETMASK=$NETMASK
GATEWAY=$GATEWAY
DNS1=$DNS1
DNS2=$DNS2
EOF

cat << EOF
    接口: $INTERFACE
  IP地址: $IPADDR
子网掩码: $NETMASK
网络地址: $GATEWAY
    DNS1: $DNS1
    DNS2: $DNS2 
配置文件: $INTERFACE_FILE
EOF
echo 请执行重启网络服务命令: systemctl restart  network
}


function config_github_hosts() {
cat >> /etc/hosts <<EOF
# GitHub Start
52.74.223.119 github.com
192.30.253.119 gist.github.com
54.169.195.247 api.github.com
185.199.111.153 assets-cdn.github.com
151.101.76.133 raw.githubusercontent.com
151.101.108.133 user-images.githubusercontent.com
151.101.76.133 gist.githubusercontent.com
151.101.76.133 cloud.githubusercontent.com
151.101.76.133 camo.githubusercontent.com
151.101.76.133 avatars0.githubusercontent.com
151.101.76.133 avatars1.githubusercontent.com
151.101.76.133 avatars2.githubusercontent.com
151.101.76.133 avatars3.githubusercontent.com
151.101.76.133 avatars4.githubusercontent.com
151.101.76.133 avatars5.githubusercontent.com
151.101.76.133 avatars6.githubusercontent.com
151.101.76.133 avatars7.githubusercontent.com
151.101.76.133 avatars8.githubusercontent.com
# GitHub End
EOF
}



PS3='请选择: '
options=(
  "配置静态IP地址"
  "设置GitHub的Hosts"
  "退出"
)
select opt in "${options[@]}"
do
    case $opt in
        "配置静态IP地址")
        config_static_ip
            ;;
        "设置GitHub的Hosts")
        config_github_hosts
            ;;
        "退出")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done
