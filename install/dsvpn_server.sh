#!/usr/bin/env bash
# install dsvpn 

log() {
  echo -e  "\e[1;35m------------------------ $@ ------------------------------\e[0m"
}

log 下载
cd /opt/
git clone https://github.com/jedisct1/dsvpn.git
cd dsvpn
log 编译
make
log 软连接
ln -s $PWD/dsvpn /usr/local/bin

mkdir -p /etc/dsvpn/
cat > /etc/dsvpn/vpn.key << EOF
iysrecwznViROoQM
EOF

cat > /etc/systemd/system/dsvpn.service << EOF
[Unit]
Description=Dead Simple VPN - Server

[Service]
ExecStart=/usr/local/bin/dsvpn server /etc/dsvpn/vpn.key auto 443 auto 10.8.0.0 auto
Restart=always
RestartSec=15

[Install]
WantedBy=network.target
EOF

log 安装完成
log 密钥文件vim /etc/dsvpn/vpn.key
log vim /etc/systemd/system/dsvpn.service 修改参数