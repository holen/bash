#!/bin/bash 

apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A
echo "deb http://repo.percona.com/apt precise main 
deb-src http://repo.percona.com/apt precise main" >> /etc/apt/sources.list 
apt-get update
apt-get install percona-xtrabackup 

#innobackupex --no-timestamp /data/backup/full/
#innobackupex --apply-log /data/backup/full/ 
#innobackupex --copy-back /data/backup/full/
