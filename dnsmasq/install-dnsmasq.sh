#!/bin/bash

####
apt-get install dnsmasq

####
sed -i 's/dns-nameservers.*/dns-nameservers 127.0.0.1/g' /etc/network/interfaces
/etc/init.d/networking restart

####
cp /etc/dnsmasq.conf /etc/dnsmasq.conf.bak
echo ''> /etc/dnsmasq.conf

echo "conf-dir=/etc/dnsmasq.d
resolv-file=/etc/dnsmasq-resolv
addn-hosts=/etc/dnsmasq-hosts
log-queries" >> /etc/dnsmasq.conf

echo "nameserver 8.8.8.8" > /etc/dnsmasq-resolv

service dnsmasq restart
