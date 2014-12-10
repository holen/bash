#!/bin/sh
echo "address=/www.w.cn/113.107.160.244" > /etc/dnsmasq.d/dns-wcn.conf 
echo "address=/.w.cn/113.107.160.244" >> /etc/dnsmasq.d/dns-wcn.conf
echo "www.w.cn -> qy:proxy1:113.107.160.244"
