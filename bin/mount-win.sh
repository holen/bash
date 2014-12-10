#!/bin/bash

if [ ! -d '/data/share/' ];then
        mkdir -p /data/share
fi

mount -t cifs -o username=wop,password=w.cn1234 //10.0.80.80/data /data/share
#mount -t cifs -o username=4p,password=4p1234qazx //10.0.80.198/share /data/share01

