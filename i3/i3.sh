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

# aira2 --> download tool
# apvlv --> pdf tool
# cmus  --> Music player
# vlc   --> Media player
# wicd  --> wireless network connection manager
# scrot --> capture a screenshot 
# feh   --> image viewer and cataloguer
# sdcv  --> console version of StarDict program
apt-get install -y aria2 apvlv cmus vlc wicd scrot feh sdcv ttf-wqy-microhei ttf-wqy-microhei


