## install

### init
```
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/init.sh | bash
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
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/zsh_autosuggestions.sh | bash
```

### docker
```
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/docker.sh | bash
```

### mongodb
```
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/mongodb.sh | bash
```

### mysql
```
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/mysql.sh | bash
```

### nginx
```
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/nginx.sh | bash
```

### openresty
```
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/openresty.sh | bash
```

### nodejs
```
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/node.sh | bash
```

### redis
```
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/redis.sh | bash
```

### redis   yum安装，启动服务
```
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/redis_yum.sh | bash
```

### java
```
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/java.sh | bash
```

### pyenv (python 版本管理)
```
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/pyenv.sh | bash
```

### sshkey
```
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/sshkey.sh | bash
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

### n2n
```
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/n2n.sh | bash
```

### docker vm 
```
docker run -d -p 2222:22 --name vm1 ilemonrain/centos-sshd  
用户名：root 密码：centos
```

### ffmpeg
```
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/ffmpeg.sh | bash
```

### xtrabackup
```
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/xtrabackup.sh | bash
```

### bbr,选择bbrplus
```
wget -N --no-check-certificate "https://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/tcp.sh"
chmod +x tcp.sh
./tcp.sh
```