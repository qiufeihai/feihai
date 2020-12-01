#!/usr/bin/env bash
# author: feihai
# install mongodb
log() {
  echo -e  "\e[1;35m------------------------ $@ ------------------------------\e[0m"
}

while [ -z "$VERSION" ]
do
read -p '请输入mongodb版本(默认:4.4)：' VERSION;
VERSION=${VERSION:-4.4}
done


log 删除mongodb yum.repo
rm -f /etc/yum.repos.d/mongodb-org*
log 添加yum.repo
# 注意\$releasever的$前面有\
cat > /etc/yum.repos.d/mongodb-org-${VERSION}.repo << EOF
[mongodb-org-${VERSION}]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/\$releasever/mongodb-org/${VERSION}/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-${VERSION}.asc
EOF

log 安装mongodb
sudo yum install -y mongodb-org

log 开启服务
sudo systemctl enable mongod
sudo systemctl start mongod

# systemd配置ulimit
# [Service]
# # Other directives omitted
# # (file size)
# LimitFSIZE=infinity
# # (cpu time)
# LimitCPU=infinity
# # (virtual memory size)
# LimitAS=infinity
# # (locked-in-memory size)
# LimitMEMLOCK=infinity
# # (open files)
# LimitNOFILE=64000
# # (processes/threads)
# LimitNPROC=64000


# 非 systemd配置ulimit
# limit fsize unlimited unlimited    # (file size)
# limit cpu unlimited unlimited      # (cpu time)
# limit as unlimited unlimited       # (virtual memory size)
# limit memlock unlimited unlimited  # (locked-in-memory size)
# limit nofile 64000 64000           # (open files)
# limit nproc 64000 64000            # (processes/threads)