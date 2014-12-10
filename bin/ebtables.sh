#!/bin/bash

ebtables -F

ebtables -A FORWARD -s 2A:3A:11:FE:CF:14 -p ipv4 --ip-src ! 10.20.10.118 -j DROP
ebtables -A FORWARD -s 26:E7:4E:64:28:E9 -p ipv4 --ip-src ! 10.20.10.119 -j DROP
ebtables -A FORWARD -s 1A:78:57:FE:47:8C -p ipv4 --ip-src ! 10.20.10.120 -j DROP
ebtables -A FORWARD -s 4A:2F:F2:50:50:65 -p ipv4 --ip-src ! 10.20.10.121 -j DROP
ebtables -A FORWARD -s 52:0A:BF:AF:A0:BE -p ipv4 --ip-src ! 10.20.10.122 -j DROP

ebtables -L
