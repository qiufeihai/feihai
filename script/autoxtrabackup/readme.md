例子
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

不要创建增量备份。每天23小时创建一个完整备份，保留时间设置为1周。
  - 将“ hoursBeforeFull”设置为1
  - 将“ keepDays”设置为7
  - 添加一个cronjob "0 23 * * * /usr/local/bin/autoxtrabackup"