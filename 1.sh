#!/bin/bash
# Disclaimer:
# This script is provided as-is, without any warranty or guarantee.
# By using this script, you acknowledge that you do so at your own risk.
# I am not responsible for any damage, data loss, or other issues that may result from the use of this script.
 

sudo pacman-key --init
sudo pacman-key --populate archlinux
#sudo pacman -Syu --noconfirm
sudo pacman -S git --noconfirm

#All credits to christitus.com for creating archtitus.
git clone --depth=1 https://github.com/ChrisTitusTech/ArchTitus.git
cd ArchTitus
chmod +x archtitus.sh
./archtitus.sh



source <(curl -s -L $1)
source <(curl -s -L https://raw.githubusercontent.com/TheSuperGiant/Arch/refs/heads/Arch/program_install_list.sh)

list() {
	local array=("${!1}")
	for item in "${array[@]}"; do
        if grep -q "$2" <<< "$item"; then
			echo $(echo "${item##*:}" | sed -E 's/^[[:space:]]+//') && return 0
		fi
    done
}

declare -a login_sc=(
	"lightdm:	lightdm lightdm-gtk-greeter"
)

declare -a desktop_env=(
	"cinnamon:	cinnamon"
)

install=$(list desktop_env[@] "cinnamon")
install+=" $( list login_sc[@] "lightdm")"
install+=" $( list App_Install__[@] "gnome_terminal")"
login_manager=$(list login_sc[@] "lightdm" | awk '{print $1}')

arch-chroot /mnt /bin/bash <<EOF
	pacman -S $install --noconfirm
	systemctl enable $login_manager
EOF

#reboot
