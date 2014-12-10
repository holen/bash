#!/bin/sh

y=`date "+%Y"`

m=`date "+%m"`

d=`date "+%d"`

cd /opt/apache-tomcat-6.0.37/logs/

cp catalina.out catalina.out.$y$m$d

echo > catalina.out

find /opt/apache-tomcat-6.0.37/logs/ -mtime +30 | xargs -I {} rm -rf {}

exit
