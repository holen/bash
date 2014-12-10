#!/bin/bash

###### Dedine Parameters ###############
BACKUP_DIR='/data/backup'
TIME=`date +%Y%m%d-%H%M%S`
USER='backup'
PASSWORD='1234qwer'
LAST_BACKUP=$(ls -tr /data/backup/ | tail -1)
LOG_DIR='/var/log/bak_log/'
LOG=${LOG_DIR}incrbak-$(date +%Y%m%d%H%M).log

############################################
echo "############################################" >> $LOG
echo "Start to incr backup at $(date +%Y%m%d%H%M)" >> $LOG
echo "############################################" >> $LOG

################ Incr Backup  #######################
innobackupex --user=$USER --password=$PASSWORD --no-timestamp --incremental --incremental-basedir=$BACKUP_DIR/$LAST_BACKUP ${BACKUP_DIR}/incr-$TIME 2>>$LOG 

############### Save log ##################################
if [ $? -eq 0 ]; then
    echo "################# Mysql Increment backup is Finished Successful at $(date +%Y%m%d%H%M)! #################" >> $LOG
    exit 0  
else  
    echo "################# Mysql full backup Fail at $(date +%Y%m%d%H%M)! #################" >> $LOG
    exit 1  
fi
