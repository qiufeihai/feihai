## 创建数据库账号

`https://docs.gitea.com/installation/database-prep`
```
// postgresql
// 创建账号
CREATE ROLE gitea WITH LOGIN PASSWORD 'gitea';
// 创建数据库
CREATE DATABASE gitea WITH OWNER gitea TEMPLATE template0 ENCODING UTF8 LC_COLLATE 'en_US.UTF-8' LC_CTYPE 'en_US.UTF-8';
```