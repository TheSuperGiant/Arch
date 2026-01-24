#!/usr/bin/env bash
# Disclaimer:
# This script is provided as-is, without any warranty or guarantee.
# By using this script, you acknowledge that you do so at your own risk.
# I am not responsible for any damage, data loss, or other issues that may result from the use of this script.

clear

#checks for 64 or 32 bit installer
echo "

$([[ $(uname -m) == x86_64 ]] && echo 64-bit installer || echo 32-bit installer)

"

if dmesg | grep -qi "efi:"; then
	echo "UEFI"
else
	echo "BIOS"
fi

echo -e "\n\nupdating keyrings"
#disable RCU messeges output
dmesg -n 1
systemctl default >/dev/null 2>&1

source <(curl -s -L $1)

if [[ "$numlock_startup" == "on" ]]; then
	setleds +num < $(tty)
fi

for EXPORT in time_zone install_type; do
	value="${!EXPORT}"
	if [[ "$value" ]]; then
		export "$EXPORT=$value"
	fi
done

pacman-key --init >/dev/null 2>&1
pacman-key --populate archlinux >/dev/null 2>&1
pacman -Sy git glibc --needed --noconfirm

#All credits to christitus.com for creating archtitus. #https://github.com/ChrisTitusTech/ArchTitus
git clone --depth=1 https://github.com/TheSuperGiant/ArchTitus.git
cd ArchTitus
chmod +x archtitus.sh
./archtitus.sh



source <(curl -s -L https://raw.githubusercontent.com/TheSuperGiant/Arch/refs/heads/main/program_install_list.sh)

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
Exec=/bin/bash -c "nm-online -q && sleep 1 && bash <(curl -fsSL $2); exec bash"
Terminal=true
EOF

reboot
