#!/bin/bash

echo "deb http://debian.sur5r.net/i3/ $(lsb_release -c -s) universe" >> /etc/apt/sources.list
apt-get update
apt-get --allow-unauthenticated install sur5r-keyring
apt-get update
apt-get install i3
apt-get install unclutter
add-apt-repository ppa:diodon-team/stable
apt-get update
apt-get install diodon

apt-get install unclutter
add-apt-repository ppa:diodon-team/stable
apt-get update
apt-get install diodon

apt-get install -y aria2 cmus vlc wicd ttf-wqy-microhei ttf-wqy-microhei
