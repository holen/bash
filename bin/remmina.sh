#!/bin/bash

case "$1" in
    "-h")
        echo "$0 [win7|cn2]"
        ;;
	"win7")
		remmina -c /root/.remmina/1384305874335.remmina
		;;
	"cn2")
		remmina	-c /root/.remmina/1384314564583.remmina
		;;
	"*")
		echo "Input some argument"
		exit 1
		;;
esac
