# Xtrabackup

##Install xtrabckup

add key 

    apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A

add repo

    vim /etc/apt/source-list
    deb http://repo.percona.com/apt precise main
    deb-src http://repo.percona.com/apt precise main
    
install xtrabackup

    apt-get update
    apt-get install percona-xtrabackup

##Grant privileges
create user and grant privileges

    GRANT RELOAD, LOCK TABLES, REPLICATION CLIENT, CREATE TABLESPACE, SUPER ON *.* TO 'innobackup'@'10.10.10.35' identified by '1234qwer'; 
    flush privileges; 
    
##Mount nfs
NFS server
    
    vim /etc/exports
    /data/backup/mysql      10.0.0.10(rw,sync,no_root_squash,no_subtree_check)
    
Mysql (nfs client)

    apt-get install nfs-common
    showmount -e 10.0.0.10
    mount -t nfs 10.0.0.10:/data/backup/mysql /data/backup/mysql

##Full backup
full backup with xbstream

    innobackupex --no-timestamp --stream=xbstream --compress --compress-threads=4 /data/backup/mysql/ > /data/backup/mysql/full.xbstream
    
full backup with tar

    innobackupex --stream=tar /data/backup/mysql/full > /data/backup/mysql/full.tar
    
full backup to remote

    innobackupex --stream=xbstream --compress /data/backup/ |ssh root@10.0.80.10 "cat - > /data/backup/backup.xbstream"
    innobackupex --stream=tar ./ | ssh root@10.0.80.10 "cat - > /data/backup/full.tar"
    
full backup with gzip

    innobackupex --rsync --parallel=4 --no-timestamp --stream=tar ./ | gzip - > full.tar.gz
