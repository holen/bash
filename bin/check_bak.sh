#!/bin/bash

Today_bak="`find /data/backup/mysql/ -maxdepth 1 -ctime -1 | head -n 1`"
Mon_bak="/data/backup/mysql/mysql-mon"
Limit_size=840000
Check_result=0
LOG_DIR='/var/log/bak_log'
LOG="${LOG_DIR}/chkbak-$(date +%Y%m%d%H%M).log"

if [ ! -d $LOG_DIR ];then
        mkdir -p $LOG_DIR
fi

if [ -d $Today_bak ];then
	Dir_size=`du -s $Today_bak | awk '{print $1}'`
	Mon_size=`du -s $Mon_bak | awk '{print $1}'`
	echo "The $Today_bak size is $Dir_size !" >> $LOG
	echo "The $Mon_bak size is $Mon_size !" >> $LOG
	if [ $Dir_size -lt $Limit_size ];then
		Check_result=1
		echo "[error] The Dir_size is less than $Limit_size !" >> $LOG
		exit $Check_result
	else 
		echo "[info] The mysql backup $Today_bak size is right!" >> $LOG
	fi
	if [ $Dir_size -lt $Mon_size ];then
		Check_result=1
		echo "[error] The Dir_size is less than $Mon_size !" >> $LOG
		exit $Check_result
	else 
		echo "[info] The mysql backup size is right!" >> $LOG
	fi
else 
	Check_result=1
	echo "[error] Today mysql backup is false!" >> $LOG 
	exit $Check_result
fi	

find /var/log/bak_log/ -mtime +7 | xargs -I {} rm -rf {}

exit $Check_result
