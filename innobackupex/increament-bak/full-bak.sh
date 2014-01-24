#!/bin/bash  
## innobackupex full back bash
 
###### Dedine Parameters ###############  
BACKUP_DIR='/data/backup'  
TIME=`date +%Y%m%d-%H%M%S`
USER='backup'  
PASSWORD='1234qwer'  
LOG_DIR='/var/log/bak_log/'  
LOG="${LOG_DIR}fullbak-$(date +%Y%m%d%H%M).log"  
 
############################################  
if [ ! -d $LOG_DIR ]; then  
	mkdir -p $LOG_DIR
fi  
  
echo "############################################" >> $LOG  
echo "Start to full backup at $(date +%Y%m%d%H%M)" >> $LOG  
echo "############################################" >> $LOG  
 
################ Full Backup  #######################  
innobackupex --user=$USER --password=$PASSWORD --no-timestamp ${BACKUP_DIR}/full-$TIME 2>$LOG  
  
if [ $? -eq 0 ]; then  
	echo "####### Mysql full backup is Finished at $(date +%Y%m%d%H%M)! #########" >> $LOG  
else  
	echo "################# Mysql full backup Fail at $(date +%Y%m%d%H%M)! #################" >> $LOG  
fi  
