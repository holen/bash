#!/bin/bash
IPT=/sbin/iptables

$IPT -F
$IPT -X
$IPT -t nat -F
$IPT -t nat -X
$IPT -t mangle -F
$IPT -t mangle -X
$IPT -P INPUT ACCEPT
$IPT -P OUTPUT ACCEPT

# Max connections per IP
BLOCKCOUNT=40

# Max connections per IP ZONE
BLOCKZONECOUNT=300

# default action can be DROP or REJECT
DACTION="REJECT"

# $IPT -I INPUT -i eth3 -p tcp --syn --dport 80 -s 110.80.33.200/29 -j ACCEPT
# $IPT -I INPUT -i eth3 -p tcp --syn --dport 80 -j DROP

$IPT -I INPUT -i eth3 -p tcp --syn --dport 80 -m connlimit --connlimit-above ${BLOCKCOUNT} -j ${DACTION} --reject-with tcp-reset
$IPT -I INPUT -i eth3 -p tcp --syn --dport 80 -m connlimit --connlimit-above ${BLOCKZONECOUNT} --connlimit-mask 24 -j REJECT

$IPT -I INPUT -i eth3 -p tcp --syn --dport 80 -s 110.87.108.248 -j ACCEPT
# Allow Baidu Spider
$IPT -I INPUT -i eth3 -p tcp --syn --dport 80 -s 220.76.210.0/24 -j ACCEPT
$IPT -I INPUT -i eth3 -p tcp --syn --dport 80 -s 220.181.0.0/16 -j ACCEPT
$IPT -I INPUT -i eth3 -p tcp --syn --dport 80 -s 123.125.0.0/16 -j ACCEPT
# Allow Google Spider
$IPT -I INPUT -i eth3 -p tcp --syn --dport 80 -s 66.249.74.0/24 -j ACCEPT

# Drop DDOS
$IPT -I INPUT -i eth3 -p tcp --syn --dport 80 -s 222.94.113.72 -j DROP
$IPT -I INPUT -i eth3 -p tcp --syn --dport 80 -s 125.35.75.150 -j DROP
$IPT -I INPUT -i eth3 -p tcp --syn --dport 80 -s 27.154.170.40 -j DROP
$IPT -I INPUT -i eth3 -p tcp --syn --dport 80 -s 110.84.25.173 -j DROP
$IPT -I INPUT -i eth3 -p tcp --syn --dport 80 -s 120.42.93.106 -j DROP
$IPT -I INPUT -i eth3 -p tcp --syn --dport 80 -s 59.174.206.247 -j DROP
$IPT -I INPUT -i eth3 -p tcp --syn --dport 80 -s 14.219.128.199 -j DROP
$IPT -I INPUT -i eth3 -p tcp --syn --dport 80 -s 222.85.82.3 -j DROP

$IPT -I INPUT -i eth3 -p tcp --syn --dport 80 -s 120.42.88.73 -j ACCEPT
$IPT -I INPUT -i eth3 -p tcp --syn --dport 80 -s 58.23.3.160/28 -j ACCEPT
$IPT -I INPUT -i eth3 -p tcp --syn --dport 80 -s 110.80.33.200/29 -j ACCEPT
$IPT -I INPUT -i eth3 -p tcp --syn --dport 80 -s 110.84.29.199 -j ACCEPT
$IPT -I INPUT -i eth3 -p tcp --syn --dport 80 -s 222.76.156.189 -j ACCEPT
$IPT -I INPUT -i eth3 -p tcp --syn --dport 80 -s 59.57.218.7 -j ACCEPT
$IPT -I INPUT -i eth3 -p tcp --syn --dport 80 -s 120.42.88.73 -j ACCEPT
$IPT -I INPUT -i eth3 -p tcp --syn --dport 80 -s 218.85.113.203 -j ACCEPT


