#!/bin/bash
## innobackupex full back bash
 
###### Dedine Parameters ###############
Local_dir='/data/backup'
Remote_dir='/data/backup/mysql'
Rsync=`which rsync`
Num=$[`date +%s`/86400%3]
Full_bak='mysql-bak'
Full_one='mysql-one'
Full_two='mysql-two'
Full_three='mysql-three'
USER='innobackup'
PASSWORD='backup'
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

Dir_mkdir $Local_dir
Dir_mkdir $LOG_DIR
Dir_mkdir ${Remote_dir}

if [ "`df -h | grep -c "10.0.0.35"`" != "1" ];then
	echo "The nfs storge is not mount!" >> $LOG
	Back_result=1
	exit 0
fi

Dir_mkdir ${Remote_dir}/${Full_one}
Dir_mkdir ${Remote_dir}/${Full_two}
Dir_mkdir ${Remote_dir}/${Full_three}

if [ -d ${Local_dir}/${Full_bak} ]; then
	/bin/rm -rf ${Local_dir}/${Full_bak}
fi
  
echo "############################################" >> $LOG
echo "Start to full backup at $(date +%Y-%m-%d-%H:%M)" >> $LOG
 
################ Full Backup  #######################  
innobackupex --user=$USER --password=$PASSWORD --no-timestamp ${Local_dir}/${Full_bak} 2>>$LOG

Print_error()
{
	if [ $? -eq 0 ];then
		echo "### Rsync to $1 is success at $(date +%Y-%m-%d-%H:%M) !" >> $LOG
	else
		echo "### Rsync to $1 is false at $(date +%Y-%m-%d-%H:%M) !" >> $LOG
		Back_result=1
		exit 0
	fi
}
  
if [ $? -eq 0 ]; then
        echo "###### Mysql full backup is Finished at $(date +%Y-%m-%d-%H:%M)! #########" >> $LOG
	echo "" >> $LOG
	#########  Rsync to remote  ###############  
	echo $Num >> $LOG
	echo "Start rsync at $(date +%Y-%m-%d-%H:%M) !" >> $LOG
	case "$Num" in 
		"0")
			$Rsync -a ${Local_dir}/${Full_bak}/* ${Remote_dir}/${Full_one}/ 2>>$LOG
			Print_error ${Remote_dir}/${Full_one}
			;;
		"1")
			$Rsync -a ${Local_dir}/${Full_bak}/* ${Remote_dir}/${Full_two}/ 2>>$LOG
			Print_error ${Remote_dir}/${Full_two}
			;;
		"2")
			$Rsync -a ${Local_dir}/${Full_bak}/* ${Remote_dir}/${Full_three}/ 2>>$LOG
			Print_error ${Remote_dir}/${Full_three}
			;;
		*)
			echo "The day num get error !" >> $LOG
			;;
	esac
else
	echo "" >> $LOG
        echo "### Mysql full backup Fail at $(date +%Y-%m-%d-%H:%M)! ###" >> $LOG
	Back_result=1
	exit 0
fi

echo "" >> $LOG
echo "[info] -----> $Back_result <-----" >> $LOG

exit 0
