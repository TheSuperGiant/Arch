#!/bin/bash
# Disclaimer:
# This script is provided as-is, without any warranty or guarantee.
# By using this script, you acknowledge that you do so at your own risk.
# I am not responsible for any damage, data loss, or other issues that may result from the use of this script.
 
#All credits to christitus.com for creating this archtitus.

#bash <(curl -L christitus.com/archtitus)

#ArchTitus_files="/mnt/ramdisk/ArchTitus"
#sudo mount -t tmpfs -o size=1G tmpfs /mnt/ramdisk
sudo pacman -Syu --noconfirm
sudo pacman git --noconfirm
git clone --depth=1 https://github.com/ChrisTitusTech/ArchTitus.git #$ArchTitus_files
#cd $ArchTitus_files
cd ArchTitus
chmod +x archtitus.sh
./archtitus.sh

#reboot
