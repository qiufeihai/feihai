安装
---------
```
curl -L https://raw.githubusercontent.com/qiufeihai/feihai/master/script/oss_backup/oss_backup.sh -o oss_backup.sh &&
sudo chmod +x oss_backup.sh && sudo mv oss_backup.sh /usr/local/bin/oss_backup.sh
```


使用
---------
```
# 配置oss
vim /etc/default/oss_backup.conf

# 手动
oss_backup.sh src_path dest_oss_url  # 本地文件上传到oss, oss_url格式：oss://bucket-name/path
oss_backup.sh src_oss_url dest_path  # 从oss下载文件到本地

# 定时任务进行备份
vim /etc/default/oss_backup.conf # 编辑PUSH_FILE_TO_OSS_ARRAY和TAR_AND_PUSH_FILE_TO_OSS_ARRAY数组

crontab -e
*/1 * * * * /usr/local/bin/oss_backup.sh  # 每分钟执行一次
```