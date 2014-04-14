#!/bin/bash
## install i3 shell, i3 improved tiling vm

echo "deb http://debian.sur5r.net/i3/ $(lsb_release -c -s) universe" >> /etc/apt/sources.list
apt-get update
apt-get --allow-unauthenticated install sur5r-keyring
apt-get update
apt-get install i3 unclutter
add-apt-repository ppa:diodon-team/stable
apt-get update

# diodon --> Access clipboard history with an application indicator.
apt-get install diodon

# vlc    --> Media player
# feh    --> image viewer and cataloguer
# cmus   --> Music player
# wicd   --> wireless network connection manager
# sdcv   --> console version of StarDict program
# aira2  --> download tool
# apvlv  --> pdf tool
# scrot  --> capture a screenshot 
# ipcalc --> An IP Netmask/broadcast/etc calculator
# StarDict --> A Cross-Platform and international dictionary written in Gtk2 http://www.stardict.org/
# alsamixer - soundcard mixer for ALSA soundcard driver, with ncurses interface
apt-get install -y aria2 apvlv cmus vlc wicd scrot feh stardict sdcv ipcalc alsamixer ttf-wqy-microhei ttf-wqy-microhei

# Download dictionary and mv to /usr/share/stardict/dic/
wget http://abloz.com/huzheng/stardict-dic/zh_CN/stardict-cedict-gb-2.4.2.tar.bz2
wget http://abloz.com/huzheng/stardict-dic/zh_CN/stardict-stardict1.3-2.4.2.tar.bz2
