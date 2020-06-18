#!/usr/bin/env bash
# MySQL backup script 
# fork from https://github.com/gstorme/autoxtrabackup
# Copyright (c) 2014 Gregory Storme
# Version: 0.2

if [ -f /etc/default/autoxtrabackup ] ; then
        . /etc/default/autoxtrabackup
else

backupDir=/mnt/mysql/backup
mysqlDataDir=/mnt/mysql/data
mysqlHost=127.0.0.1
mysqlPort=3306
hoursBeforeFull=48
mysqlUser=dbuser
mysqlPwd=password
compression=true
keepDays=7
sendEmail=never
emailAddress=
ossUrl=oss://bucket/path
fi

#####
# No editing should be required below this line
#####

usage_zh () {
        echo -e "\t恢复全量备份";
        echo -e "\t\t恢复压缩过的全量备份:";
        echo -e "\t\t\tinnobackupex --decompress $backupDir/BACKUP-DIR";
        echo -e "\t\t\tFollow same steps as for non-compressed backups";
        echo -e "\t\t恢复未被压缩过的全量备份:";
        echo -e "\t\t\tinnobackupex --apply-log $backupDir/BACKUP-DIR";
        echo -e "\t\t\t停止 MySQL 服务";
        echo -e "\t\t\t清空 MySQL 数据目录 (通常是 /var/lib/mysql)";
        echo -e "\t\t\tinnobackupex --copy-back $backupDir/BACKUP-DIR";
        echo -e "\t\t\t恢复 数据目录 权限 (chown -R mysql:mysql /var/lib/mysql/)";
        echo -e "\t\t\t启动 MySQL 服务";
        echo -e "\t恢复增量备份";
        echo -e "\t\t\t如果被压缩过, 先解压备份 (see above)";
        echo -e "\t\t\t首先, 准备基础备份，即初始的全量备份";
        echo -e "\t\t\tinnobackupex --apply-log --redo-only $backupDir/FULL-BACKUP-DIR";
        echo -e "\t\t\t合并增量备份到该基础全量备份.";
        echo -e "\t\t\t如果你有多个增量备份, 通过 --redo-only 按照增量备份的生成顺序来合并成最终的全量备份";
        echo -e "\t\t\tinnobackupex --apply-log --redo-only $backupDir/FULL-BACKUP-DIR --incremental-dir=$backupDir/INC-BACKUP-DIR";
        echo -e "\t\t\t一旦你合并完所有增量备份，就可以使它回滚为一个未提交的事务:";
        echo -e "\t\t\tinnobackupex --apply-log $backupDir/BACKUP-DIR";
        echo -e "\t\t\t现在合并成了一个全量备份文件，然后执行上面的全量备份恢复的命令即可";
}

usage () {
        echo -e "\tRestore a full backup";
        echo -e "\t\tRestore a compressed backup:";
        echo -e "\t\t\tinnobackupex --decompress $backupDir/BACKUP-DIR";
        echo -e "\t\t\tFollow same steps as for non-compressed backups";
        echo -e "\t\tRestore a non-compressed backup:";
        echo -e "\t\t\tinnobackupex --apply-log $backupDir/BACKUP-DIR";
        echo -e "\t\t\tStop your MySQL server";
        echo -e "\t\t\tDelete everything in the MySQL data directory (usually /var/lib/mysql)";
        echo -e "\t\t\tinnobackupex --copy-back $backupDir/BACKUP-DIR";
        echo -e "\t\t\tRestore the ownership of the files in the MySQL data directory (chown -R mysql:mysql /var/lib/mysql/)";
        echo -e "\t\t\tStart your MySQL server";
        echo -e "\tRestore an incremental backup";
        echo -e "\t\t\tIf compressed, first decompress the backup (see above)";
        echo -e "\t\t\tFirst, prepare the base backup";
        echo -e "\t\t\tinnobackupex --apply-log --redo-only $backupDir/FULL-BACKUP-DIR";
        echo -e "\t\t\tNow, apply the incremental backup to the base backup.";
        echo -e "\t\t\tIf you have multiple incrementals, pass the --redo-only when merging all incrementals except for the last one. Also, merge them in the chronological order that the backups were made";
        echo -e "\t\t\tinnobackupex --apply-log --redo-only $backupDir/FULL-BACKUP-DIR --incremental-dir=$backupDir/INC-BACKUP-DIR";
        echo -e "\t\t\tOnce you merge the base with all the increments, you can prepare it to roll back the uncommitted transactions:";
        echo -e "\t\t\tinnobackupex --apply-log $backupDir/BACKUP-DIR";
        echo -e "\t\t\tFollow the same steps as for a full backup restore now";
}

while getopts ":h" opt; do
  case $opt in
        h)
                usage_zh;
                exit 0
                ;;
        \?)
                echo "Invalid option: -$OPTARG" >&2
                exit 1
                ;;
  esac
done

dateNow=`date +%Y-%m-%d_%H-%M-%S`
dateNowUnix=`date +%s`
backupLog=/tmp/backuplog
delDay=`date -d "-$keepDays days" +%Y-%m-%d`

# Check if innobackupex is installed (percona-xtrabackup)
if [[ -z "$(command -v innobackupex)" ]]; then
        echo "The innobackupex executable was not found, check if you have installed percona-xtrabackup."
        exit 1
fi

# Check if backup directory exists
if [ ! -d "$backupDir" ]; then
        echo "Backup directory does not exist. Check your config and create the backup directory"
        exit 1
fi

# Check if mail is installed
if [[ $sendEmail == always ]] || [[ $sendEmail == onerror ]]; then
        if [[ -z "$(command -v mail)" ]]; then
                echo "You have enabled mail, but mail is not installed or not in PATH environment variable"
                exit 1
        fi
fi

# Check if you set a correct retention
if [ $(($keepDays * 24)) -le $hoursBeforeFull ]; then
        echo "ERROR: You have set hoursBeforeFull to $hoursBeforeFull and keepDays to $keepDays, this will delete all your backups... Change this"
        exit 1
fi

# If you enabled sendEmail, check if you also set a recipient
if [[ -z $emailAddress ]] && [[ $sendEmail == onerror ]]; then
        echo "Error, you have enabled sendEmail but you have not configured any recipient"
        exit 1
elif [[ -z $emailAddress ]] && [[ $sendEmail == always ]]; then
        echo "Error, you have enabled sendEmail but you have not configured any recipient"
        exit 1
fi

# If compression is enabled, pass it on to the backup command
if [[ $compression == true ]]; then
        compress="--compress"
        compressThreads="--compress-threads=$compressThreads"
else
        compress=
        compressThreads=
fi

if [ -f "$backupDir"/latest_full ]; then
        lastFull=`cat "$backupDir"/latest_full`
fi

# Check for an existing full backup
if [ ! -f "$backupDir"/latest_full ]; then
        #echo "Latest full backup information not found... taking a first full backup now"
        echo $dateNowUnix > "$backupDir"/latest_full
        lastFull=`cat "$backupDir"/latest_full`
        /usr/bin/innobackupex --user=$mysqlUser --password=$mysqlPwd --host=${mysqlHost:-127.0.0.1} --port=${mysqlPort:-3306} --datadir=$mysqlDataDir --no-timestamp $compress $compressThreads --rsync "$backupDir"/"$dateNow"_full > $backupLog 2>&1
        # oss_backup.sh "$backupDir"/"$dateNow"_full $ossUrl 2>&1 | tee -a $backupLog # 上传到oss
else
        # Calculate the time since the last full backup
        difference=$((($dateNowUnix - $lastFull) / 60 / 60))

        # Check if we must take a full or incremental backup
        if [ $difference -lt $hoursBeforeFull ]; then
                #echo "It's been $difference hours since last full, doing an incremental backup"
                lastFullDir=`date -d@"$lastFull" '+%Y-%m-%d_%H-%M-%S'`
                /usr/bin/innobackupex --user=$mysqlUser --password=$mysqlPwd --host=${mysqlHost:-127.0.0.1} --port=${mysqlPort:-3306} --datadir=$mysqlDataDir --no-timestamp $compress $compressThreads --rsync --incremental --incremental-basedir="$backupDir"/"$lastFullDir"_full "$backupDir"/"$dateNow"_incr > $backupLog 2>&1
                # oss_backup.sh "$backupDir"/"$dateNow"_incr $ossUrl 2>&1 | tee -a $backupLog # 上传到oss

        else
                #echo "It's been $difference hours since last full backup, time for a new full backup"
                echo $dateNowUnix > "$backupDir"/latest_full
                /usr/bin/innobackupex --user=$mysqlUser --password=$mysqlPwd --host=${mysqlHost:-127.0.0.1} --port=${mysqlPort:-3306} --datadir=$mysqlDataDir --no-timestamp $compress $compressThreads --rsync "$backupDir"/"$dateNow"_full > $backupLog 2>&1
                # oss_backup.sh "$backupDir"/"$dateNow"_full $ossUrl 2>&1 | tee -a $backupLog # 上传到oss

        fi
fi

# Check if the backup succeeded or failed, and e-mail the logfile, if enabled
if grep -q "completed OK" $backupLog; then
        echo "Backup completed OK"
        if [[ $sendEmail == always ]]; then
                cat $backupLog | mail -s "AutoXtraBackup log" $emailAddress
        fi
else
        echo "Backup FAILED"
        if [[ $sendEmail == always ]] || [[ $sendEmail == onerror ]]; then
                cat $backupLog | mail -s "AutoXtraBackup log" $emailAddress
        fi
        exit 1
fi

# Delete backups older than retention date
rm -rf $backupDir/$delDay*

# Delete incremental backups with full backup base directory that was deleted
for i in `find "$backupDir"/*incr -type f -iname xtrabackup_info 2>/dev/null |  xargs grep $delDay | awk '{print $10}' | cut -d '=' -f2`; do rm -rf $i; done

exit 0