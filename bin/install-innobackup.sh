#!/bin/bash 

apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A
echo "deb http://repo.percona.com/apt precise main 
deb-src http://repo.percona.com/apt precise main" >> /etc/apt/sources.list 
apt-get update
apt-get install percona-xtrabackup 

#innobackupex --copy-back /data/mysql-two/
# CREATE USER 'innobackup'@'localhost' IDENTIFIED BY '1234qwer';
# GRANT RELOAD, LOCK TABLES, REPLICATION CLIENT, CREATE TABLESPACE, SUPER ON *.* TO 'innobackup'@'localhost';
# flush privileges;
# mount 10.10.11.104:/data/backup/10-10-11-103/ /backup/
