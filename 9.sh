#!/bin/bash
# Disclaimer:
# This script is provided as-is, without any warranty or guarantee.
# By using this script, you acknowledge that you do so at your own risk.
# I am not responsible for any damage, data loss, or other issues that may result from the use of this script.
 
#All credits to christitus.com for creating this archtitus.

#bash <(curl -L christitus.com/archtitus)

sudo pacman -Syu git
git clone --depth=1 https://github.com/ChrisTitusTech/ArchTitus.git
cd ArchTitus
chmod +x archtitus.sh
./archtitus.sh

#reboot
