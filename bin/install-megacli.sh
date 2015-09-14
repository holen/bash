#!/bin/bash

if [ `uname -v | grep Ubuntu | wc -l` == "1" ];
then
    echo "deb http://hwraid.le-vert.net/ubuntu/ $(lsb_release -s -c) main" >> /etc/apt/sources.list
else
    echo "deb http://hwraid.le-vert.net/debian/ $(lsb_release -s -c) main" >> /etc/apt/sources.list
fi
wget -O - http://hwraid.le-vert.net/debian/hwraid.le-vert.net.gpg.key | apt-key add -
apt-get update 
apt-get install megacli -y
