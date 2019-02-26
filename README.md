## install

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

### nodejs
```
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/node.sh | bash
```

### redis
```
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/redis.sh | bash
```

### sshkey
```
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/sshkey.sh | bash
```

### zsh_autosuggestions
```
curl -o- https://raw.githubusercontent.com/qiufeihai/feihai/master/install/zsh_autosuggestions.sh | bash
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
