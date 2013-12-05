#!/bin/bash

####
apt-get install dnsmasq

####
if [[ $(grep dns-nameservers /etc/network/interfaces) ]]; then
	sed -i 's/dns-nameservers.*/dns-nameservers 127.0.0.1/g' /etc/network/interfaces
else
	sed -i "/gateway/a dns-nameservers 127.0.0.1" >> /etc/network/interfaces
fi
/etc/init.d/networking restart

####
echo "IGNORE_RESOLVCONF=yes" >> /etc/default/dnsmasq

cp /etc/dnsmasq.conf /etc/dnsmasq.conf.bak
echo ''> /etc/dnsmasq.conf

echo "
resolv-file=/etc/dnsmasq-resolv
interface=br0
bind-interfaces
addn-hosts=/etc/dnsmasq-hosts
#dhcp-range=10.10.10.200,10.10.10.250,48h
#log-dhcp
log-queries" >> /etc/dnsmasq.conf

echo "nameserver 8.8.8.8" > /etc/dnsmasq-resolv

service dnsmasq restart
