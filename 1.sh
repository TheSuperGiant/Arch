#!/bin/bash
# Disclaimer:
# This script is provided as-is, without any warranty or guarantee.
# By using this script, you acknowledge that you do so at your own risk.
# I am not responsible for any damage, data loss, or other issues that may result from the use of this script.
 

sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman -Sy git --noconfirm

#All credits to christitus.com for creating archtitus.
git clone --depth=1 https://github.com/ChrisTitusTech/ArchTitus.git
cd ArchTitus
sed -i '/xterm/d' pkg-files/pacman-pkgs.txt
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

#declare -a login_sc=(
	#"lightdm:	lightdm lightdm-gtk-greeter"
#)

#declare -a desktop_env=(
	#"cinnamon:	cinnamon"
#)

install=$(list App_Install__[@] "$terminal")
#install+=" $( list desktop_env[@] "$desktop_environment")"
#install+=" $( list login_sc[@] "$login_screen")"
#login_manager=$(list login_sc[@] "$login_screen" | awk '{print $1}')

mkdir -p /mnt/etc/xdg/autostart
cat << 'EOF' > /mnt/etc/xdg/autostart/firstboot.desktop
[Desktop Entry]
Type=Application
Exec=gnome-terminal -- bash -c "nm-online -q && sleep 1 && bash <(curl -fsSL $2); exec bash"
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name[en_NG]=Terminal
Name=Terminal
Comment[en_NG]=Start Terminal On Startup
Comment=Start Terminal On Startup
EOF

arch-chroot /mnt /bin/bash <<EOF
	pacman -S $install --needed --noconfirm
EOF
	#systemctl enable $login_manager

#reboot
