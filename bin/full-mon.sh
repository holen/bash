#!/bin/bash

Rsync=`which rsync`
First_day=`date --date='today' +%Y%m2311`
Backup_one="/data/backup/mysql/mysql-one"
Backup_two="/data/backup/mysql/mysql-two"
Backup_three="/data/backup/mysql/mysql-three"
Backup_mon="/data/backup/mysql/mysql-mon"
Date_one=`date -r $Backup_one +%Y%m%d%H`
Date_two=`date -r $Backup_two +%Y%m%d%H`
Date_three=`date -r $Backup_three +%Y%m%d%H`
LOG_DIR='/var/log/bak_log'
LOG="${LOG_DIR}/monbak-$(date +%Y%m%d%H%M).log"
Back_result=0

if [ ! -d $Backup_mon ];then
	mkdir -p $Backup_mon
fi

if [ ! -d $LOG_DIR ];then
	mkdir -p $LOG_DIR
fi

Print_error()
{
        if [ $? -eq 0 ];then
		echo $(date) >> $LOG
                echo "### Rsync to $1 is success !" >> $LOG
        else
                echo "### Rsync to $1 is false !" >> $LOG
                Back_result=1
                exit 0
        fi
}

if [ "$First_day" == "$Date_one" ];then
	$Rsync -a ${Backup_one}/* ${Backup_mon}/ 2>> $LOG
	Print_error ${Backup_mon}
elif [ "$First_day" == "$Date_two" ];then 
	$Rsync -a ${Backup_two}/* ${Backup_mon}/ 2>> $LOG
	Print_error ${Backup_mon}
elif [ "$First_day" == "$Date_three" ];then 
	$Rsync -a ${Backup_three}/* ${Backup_mon}/ 2>> $LOG
	Print_error ${Backup_mon}
else
	echo "nothing to do " >> $LOG
fi

echo "---> $Back_result <---" >>$LOG
exit 0
