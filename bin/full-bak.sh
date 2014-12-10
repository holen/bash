#!/bin/bash
## innobackupex full back bash
 
###### Dedine Parameters ###############
Remote_dir='/backup/mysql'
Rsync=`which rsync`
Num=$[`date +%s`/86400%3]
Full_bak='mysql-bak'
Full_one='mysql-one'
Full_two='mysql-two'
Full_three='mysql-three'
Full_mon='mysql-mon'
Today=`date +%d`
USER='innobackup'
PASSWORD='1234qwer'
LOG_DIR='/var/log/bak_log'
LOG="${LOG_DIR}/fullbak-$(date +%Y%m%d%H%M).log"
Back_result=0
 
############################################
Dir_mkdir()
{
	if [ ! -d $1 ]; then
		mkdir -p $1
	fi	
}

Dir_mkdir $LOG_DIR
Dir_mkdir ${Remote_dir}

if [ "`df -h | grep -c "10.10.11.104"`" != "1" ];then
	echo "The nfs storge is not mount!" >> $LOG
	Back_result=1
	exit 0
fi

Dir_mkdir ${Remote_dir}/${Full_one}
Dir_mkdir ${Remote_dir}/${Full_two}
Dir_mkdir ${Remote_dir}/${Full_three}
Dir_mkdir ${Remote_dir}/${Full_mon}

if [ -d ${Remote_dir}/${Full_bak} ]; then
	/bin/rm -rf ${Remote_dir}/${Full_bak}
fi
  
echo "############################################" >> $LOG
echo "Start to full backup at $(date +%Y%m%d%H%M)" >> $LOG
 
################ Full Backup  #######################  
innobackupex --user=$USER --password=$PASSWORD --no-timestamp ${Remote_dir}/${Full_bak} 2>>$LOG

Print_error()
{
	if [ $? -eq 0 ];then
		echo " " >> $LOG
		echo "### Rsync to $1 is success at $(date) !" >> $LOG
		echo "[info] -----> $Back_result <-----" >> $LOG
	else
		echo "### Rsync to $1 is false at $(date) !" >> $LOG
		echo "[error] -----> $Back_result <-----" >> $LOG
		Back_result=1
		exit 0
	fi
}

Rsync_to_mon()
{
	if [ "$Today" == "01" ];then
		echo "$Today Start rsync $1 to ${Full_mon} .. " >> $LOG
		$Rsync -a $1 ${Remote_dir}/${Full_mon}/ 2>> $LOG
		Print_error ${Remote_dir}/${Full_mon}
	else
		echo "$Today is no first day of this month " >> $LOG
	fi
}
  
if [ $? -eq 0 ]; then
        echo "###### Mysql full backup is Finished at $(date +%Y%m%d%H%M)! #########" >> $LOG
	echo "" >> $LOG
	echo " #########  Rsync to remote  ###############  " >> $LOG
	echo $Num >> $LOG
	case "$Num" in 
		"0")
			$Rsync -a ${Remote_dir}/${Full_bak}/ ${Remote_dir}/${Full_one}/ 2>>$LOG
			Print_error ${Remote_dir}/${Full_one}
			Rsync_to_mon ${Remote_dir}/${Full_one}/
			;;
		"1")
			$Rsync -a ${Remote_dir}/${Full_bak}/ ${Remote_dir}/${Full_two}/ 2>>$LOG
			Print_error ${Remote_dir}/${Full_two}
			Rsync_to_mon ${Remote_dir}/${Full_two}/
			;;
		"2")
			$Rsync -a ${Remote_dir}/${Full_bak}/ ${Remote_dir}/${Full_three}/ 2>>$LOG
			Print_error ${Remote_dir}/${Full_three}
			Rsync_to_mon ${Remote_dir}/${Full_three}/
			;;
		*)
			echo "The day num get error !" >> $LOG
			;;
	esac
else
	echo "" >> $LOG
        echo "### Mysql full backup Fail at $(date +%Y%m%d%H%M)! ###" >> $LOG
	Back_result=1
	exit 0
fi

find /var/log/bak_log/ -mtime +7 | xargs -I {} rm -rf {}

exit 0
