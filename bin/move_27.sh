ssh 10.10.10.18
umount /backup/

ssh 10.10.10.130 131 132 133
umount /data/tomcat6/appfiles
mount -t nfs -o vers=3 10.10.10.27:/data/share1 /data/tomcat6/appfiles

/etc/init.d/tomcat6 restart

ip addr add 10.10.10.27/24 dev eth0

