#!/bin/bash
# Disclaimer:
# This script is provided as-is, without any warranty or guarantee.
# By using this script, you acknowledge that you do so at your own risk.
# I am not responsible for any damage, data loss, or other issues that may result from the use of this script.
 

pacman-key --init
pacman-key --populate archlinux
pacman -Sy git glibc --needed --noconfirm

#All credits to christitus.com for creating archtitus.
git clone --depth=1 https://github.com/ChrisTitusTech/ArchTitus.git
cd ArchTitus
sed -i '/xterm/d' pkg-files/pacman-pkgs.txt
sed -i 's/formating/formatting/g' scripts/startup.sh
sed -i '/^    after formatting your disk there is no way to get data back$/ { N; N; s/$/\n------------------------------------------------------------------------\n$(lsblk -n --output TYPE,KNAME,SIZE,LABEL)\n------------------------------------------------------------------------/ }' scripts/startup.sh
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

arch-chroot /mnt /bin/bash <<EOF
	pacman -S $install --needed --noconfirm
EOF
	#systemctl enable $login_manager

mkdir -p /mnt/etc/xdg/autostart
cat << EOF > /mnt/etc/xdg/autostart/firstboot.desktop
[Desktop Entry]
Type=Application
Exec=bash -c "nm-online -q && sleep 1 && bash <(curl -fsSL $2); exec bash"
Terminal=true
EOF

reboot
