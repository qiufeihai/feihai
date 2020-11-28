安装
---------
```
curl -o- https://raw.staticdn.net/qiufeihai/feihai/master/script/autoxtrabackup/autoxtrabackup_install.sh | bash
```

备份
---------
每小时创建增量备份，每24小时创建一次完整备份。保留时间设置为1周。
  - 将“ hoursBeforeFull”设置为24  
  - 将“ keepDays”设置为7
  - 添加一个cronjob"0 * * * * /usr/local/bin/autoxtrabackup"

在星期日创建完整备份，其余所有几天进行增量备份。保留备份1个月。
  - 将“ hoursBeforeFull”设置为168
  - 将“ keepDays”设置为31
  - 在周日的所需时间创建第一个备份，以23h为例
  - 添加一个cronjob"0 23 * * * /usr/local/bin/autoxtrabackup"

不要创建增量备份。每天23小时创建一个完整备份，保留时间设置为1周。（默认）
  - 将“ hoursBeforeFull”设置为1
  - 将“ keepDays”设置为7
  - 添加一个cronjob "0 23 * * * /usr/local/bin/autoxtrabackup"


全量备份恢复
---------
```
docker stop mysql # 停掉mysqld
xtrabackup --copy-back --target-dir=/path/to/YYYY-MM-DD_hh-mm-ss_full # 解压
xtrabackup --prepare --target-dir=/path/to/YYYY-MM-DD_hh-mm-ss_full # 准备
xtrabackup --copy-back --target-dir=/path/to/YYYY-MM-DD_hh-mm-ss_full -h /mnt/mysql/data # 恢复 -h 指定最终存储数据的目录
docer restart mysql # 开启mysql
```
增量备份恢复的具体看autoxtrabackup -h

各个配置路径
---------
命令路径/usr/local/bin/autoxtrabackup  
配置文件路径/etc/default/autoxtrabackup  
定时任务配置/etc/cron.d/mysql_backup  
