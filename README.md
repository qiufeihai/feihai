## install

### Github Hosts
```
https://gitlab.com/ineo6/hosts/-/raw/master/next-hosts

https://github.com/ineo6/hosts/blob/master/next-hosts
```

### Github 加速
地址前面加：https://hub.gitmirror.com/ 或 https://mirror.ghproxy.com/ ,如：
```
https://hub.gitmirror.com/https://raw.githubusercontent.com/xxxxxxxxxxxx
```

### systemctl
```
# github
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/script/systemctl.sh | bash
# gitee
curl -o- https://gitee.com/SImMon_Fo4r/feihai/raw/master/script/systemctl.sh | bash
```

### init
```
# github
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/init.sh | bash
# gitee
curl -o- https://gitee.com/SImMon_Fo4r/feihai/raw/master/install/init.sh | bash
```

### 自定义终端[username@hostname(ip)]pwd#
```
# zsh
grep 'export PS1' -q ~/.zshrc || echo 'export PS1="[%n@%m(`curl ifconfig.me 2>/dev/null`)]%~%# "' >> ~/.zshrc
# bash
grep 'export PS1' -q ~/.bashrc || echo 'export PS1="[\\u@\h(`curl ifconfig.me 2>/dev/null`) \W]\\$ "' >> ~/.bashrc
```

### zsh_autosuggestions
```
# github
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/zsh_autosuggestions.sh | bash
# gitee
curl -o- https://gitee.com/SImMon_Fo4r/feihai/raw/master/install/zsh_autosuggestions.sh | bash

```

### nodejs
```
// 如果用zsh先切到zsh再装
# github
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/node.sh | bash
# gitee
curl -o- https://gitee.com/SImMon_Fo4r/feihai/raw/master/install/node.sh | bash
# nvm 加速安装nodejs
export NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node && nvm install --lts
# npm 设置淘宝镜像
npm config set registry https://registry.npm.taobao.org
# npm 设置Electron淘宝镜像
npm config set ELECTRON_MIRROR http://npm.taobao.org/mirrors/electron/
```

### docker
```
# github
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/docker.sh | bash
# gitee 
curl -o- https://gitee.com/SImMon_Fo4r/feihai/raw/master/install/docker.sh | bash
```

### docker mysql
```
# github
bash <(curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/docker_mysql.sh)
# gitee
bash <(curl -o- https://gitee.com/SImMon_Fo4r/feihai/raw/master/install/docker_mysql.sh)

```

### docker postgresql
```
# github
bash <(curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/docker_postgresql.sh)
# gitee
bash <(curl -o- https://gitee.com/SImMon_Fo4r/feihai/raw/master/install/docker_postgresql.sh)

```

### redis   yum安装，启动服务
```
# github
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/redis_yum.sh | bash
# gitee
curl -o- https://gitee.com/SImMon_Fo4r/feihai/raw/master/install/redis_yum.sh | bash
```

### openresty
```
# github
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/openresty.sh | bash
# gitee
curl -o- https://gitee.com/SImMon_Fo4r/feihai/raw/master/install/openresty.sh | bash
```

### docker rabbit
```
# github
bash <(curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/docker_rabbit.sh)
# gitee
bash <(curl -o- https://gitee.com/SImMon_Fo4r/feihai/raw/master/install/docker_rabbit.sh)
```

### docker mongodb
```
# github
bash <(curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/docker_mongodb.sh)
# gitee
bash <(curl -o- https://gitee.com/SImMon_Fo4r/feihai/raw/master/install/docker_mongodb.sh)
```

### mongodb
```
# github
bash <(curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/mongodb.sh)
# gitee
bash <(curl -o- https://gitee.com/SImMon_Fo4r/feihai/raw/master/install/mongodb.sh)
# 卸载mongodb
bash <(curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/uninstall_mongodb.sh)
```

### mysql
```
# github
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/mysql.sh | bash
# gitee
curl -o- https://gitee.com/SImMon_Fo4r/feihai/raw/master/install/mysql.sh | bash
```

### nginx
```
# github
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/nginx.sh | bash
# gitee
curl -o- https://gitee.com/SImMon_Fo4r/feihai/raw/master/install/nginx.sh | bash
```

### redis
```
# github
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/redis.sh | bash
# gitee
curl -o- https://gitee.com/SImMon_Fo4r/feihai/raw/master/install/redis.sh | bash
```

### java
```
# github
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/java.sh | bash
# gitee
curl -o- https://gitee.com/SImMon_Fo4r/feihai/raw/master/install/java.sh | bash
```

### pyenv (python 版本管理)
```
# github
bash <(curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/pyenv.sh)
# gitee
bash <(curl -o- https://gitee.com/SImMon_Fo4r/feihai/raw/master/install/pyenv.sh)
```

### golang
```
# github
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/golang.sh | bash
# gitee
curl -o- https://gitee.com/SImMon_Fo4r/feihai/raw/master/install/golang.sh | bash
```

### autoxtrabackup
```
# github
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/script/autoxtrabackup/autoxtrabackup_install.sh | bash
# gitee
curl -o- https://gitee.com/SImMon_Fo4r/feihai/raw/master/script/autoxtrabackup/autoxtrabackup_install.sh | bash

```

### oss_backup.sh
```
# github
curl -L https://raw.githubusercontent.com/qiufeihai/feihai/master/script/oss_backup/oss_backup.sh -o oss_backup.sh &&
sudo chmod +x oss_backup.sh && sudo mv oss_backup.sh /usr/local/bin/oss_backup.sh

# gitee
curl -L https://gitee.com/SImMon_Fo4r/feihai/raw/master/script/oss_backup/oss_backup.sh -o oss_backup.sh &&
sudo chmod +x oss_backup.sh && sudo mv oss_backup.sh /usr/local/bin/oss_backup.sh
```

### cachecloud
```
DB_URL=127.0.0.1 \
&& DB_PORT=3306 \
&& DB_NAME=cachecloud \
&& DB_USER=root \
&& DB_PASSWORD=123456789 \
&& WEB_PORT=8585 \
&& curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/cachecloud.sh | bash

```

### dsvpn
```
// server
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/dsvpn_server.sh | bash

// client
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/dsvpn_client.sh | bash

```

### docker minio
```
# github
bash <(curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/docker_minio.sh)
# gitee
bash <(curl -o- https://gitee.com/SImMon_Fo4r/feihai/raw/master/install/docker_minio.sh)
```

### docker webhook
```
# github
bash <(curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/docker_webhook.sh)
# gitee
bash <(curl -o- https://gitee.com/SImMon_Fo4r/feihai/raw/master/install/docker_webhook.sh)
```

### docker jenkins
```
# github
bash <(curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/docker_jenkins.sh)
# gitee
bash <(curl -o- https://gitee.com/SImMon_Fo4r/feihai/raw/master/install/docker_jenkins.sh)
```

### aliyun-cli、oss bash client
```
# github
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/aliyun_cli.sh | bash
# gitee
curl -o- https://gitee.com/SImMon_Fo4r/feihai/raw/master/install/aliyun_cli.sh | bash
```

### ossutil
```
# github
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/ossutil.sh | bash
# gitee
curl -o- https://gitee.com/SImMon_Fo4r/feihai/raw/master/install/ossutil.sh | bash
```

### n2n
```
# github
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/n2n.sh | bash
# gitee
curl -o- https://gitee.com/SImMon_Fo4r/feihai/raw/master/install/n2n.sh | bash
```

### docker vm 
```
docker run -d -p 2222:22 --name vm1 ilemonrain/centos-sshd  
用户名：root 密码：centos
```

### ffmpeg
```
# github
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/ffmpeg.sh | bash
# gitee
curl -o- https://gitee.com/SImMon_Fo4r/feihai/raw/master/install/ffmpeg.sh | bash
```

### xtrabackup
```
# github
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/xtrabackup.sh | bash
# gitee
curl -o- https://gitee.com/SImMon_Fo4r/feihai/raw/master/install/xtrabackup.sh | bash
# 备份
bash <(curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/xtrabackup_backup.sh)
bash <(curl -o- https://gitee.com/SImMon_Fo4r/feihai/raw/master/install/xtrabackup_backup.sh)
# 恢复
bash <(curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/xtrabackup_restore.sh)
bash <(curl -o- https://gitee.com/SImMon_Fo4r/feihai/raw/master/install/xtrabackup_restore.sh)
```

### bbr,选择bbrplus
```
wget -N --no-check-certificate "https://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/tcp.sh"
chmod +x tcp.sh
./tcp.sh
```