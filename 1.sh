#!/bin/bash
# Disclaimer:
# This script is provided as-is, without any warranty or guarantee.
# By using this script, you acknowledge that you do so at your own risk.
# I am not responsible for any damage, data loss, or other issues that may result from the use of this script.
 
#All credits to christitus.com for creating this archtitus.

sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman -Syu --noconfirm
sudo pacman -S git --noconfirm
git clone --depth=1 https://github.com/ChrisTitusTech/ArchTitus.git
cd ArchTitus
chmod +x archtitus.sh
bash archtitus.sh

arch-chroot /mnt

#envoirement
sudo pacman -S lightdm lightdm-gtk-greeter cinnamon --noconfirm

sudo systemctl enable lightdm

#terminal


exit

#reboot
