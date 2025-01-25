#!/bin/bash
# Disclaimer:
# This script is provided as-is, without any warranty or guarantee.
# By using this script, you acknowledge that you do so at your own risk.
# I am not responsible for any damage, data loss, or other issues that may result from the use of this script.
 
#All credits to christitus.com for creating this archtitus.

#bash <(curl -L christitus.com/archtitus)

#archfiles="/mnt/ramdisk/ArchTitus"
#sudo mount -t tmpfs -o size=1G tmpfs /mnt/ramdisk
sudo pacman git --noconfirm
git clone --depth=1 https://github.com/ChrisTitusTech/ArchTitus.git #$archfiles
#cd $archfiles
cd ArchTitus
chmod +x archtitus.sh
./archtitus.sh

#reboot
