#!/bin/bash

echo "deb http://hwraid.le-vert.net/ubuntu/ $(lsb_release -s -c) main" >> /etc/apt/sources.list
wget -O - http://hwraid.le-vert.net/debian/hwraid.le-vert.net.gpg.key | apt-key add -
apt-get update 
apt-get install megacli -y
