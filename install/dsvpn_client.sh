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
É<8b>úç<8e>Ìbæ^Z«å±ü×l5ýòª|?;^D.áu<9b>Ys<9b>Q8
EOF

cat > /etc/systemd/system/dsvpn.service << EOF
[Unit]
Description=Dead Simple VPN - Client

[Service]
ExecStart=/usr/local/bin/dsvpn client /etc/dsvpn/vpn.key {serverip} 443 auto 10.8.0.1 10.8.0.0
Restart=always
RestartSec=15

[Install]
WantedBy=network.target
EOF

log 安装完成
log 密钥文件 vim /etc/dsvpn/vpn.key
log vim /etc/systemd/system/dsvpn.service 替换serverip,修改参数