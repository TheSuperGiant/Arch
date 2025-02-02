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
./archtitus.sh

source <(curl -s -L $1)

echo $1
echo $login_screen
echo $terminal
echo $desktop_environment

echo "The script is paused. Press Enter to continue..."
read
echo "Continuing the script..."

lightdm="lightdm lightdm-gtk-greeter"
cinnamon="cinnamon"
terminal="gnome-terminal"
install="$lightdm $cinnamon"
login_manager="lightdm"


arch-chroot /mnt /bin/bash <<EOF
	pacman -S $cinnamon --noconfirm
	lightdm_service
	systemctl enable $login_manager
EOF

#reboot
