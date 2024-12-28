#!/bin/bash
# Disclaimer:
# This script is provided as-is, without any warranty or guarantee.
# By using this script, you acknowledge that you do so at your own risk.
# I am not responsible for any damage, data loss, or other issues that may result from the use of this script.


#LIGHTDM_CONF="/etc/lightdm/lightdm.conf"

add_alias() {
	if ! grep -q "^alias $1=" ~/.bashrc; then
		code="alias $1=\"$2\""
		eval $code && echo $code >> ~/.bashrc
		echo "Alias '$1' added and saved to ~/.bashrc."
	fi
}
add_device_label() {
	if ! sudo grep -q "^LABEL=$1 " /etc/fstab; then
		fs_type=$(lsblk -o NAME,LABEL,FSTYPE | grep -w $1 | awk '{print $3}')
		if [ -n "$fs_type" ]; then
			mountpoint="/mnt/$1"
			sudo bash -c "echo \"LABEL=$1 $mountpoint $fs_type defaults,nofail 0 2\" >> /etc/fstab"
			sudo mkdir -p $mountpoint
			sudo chown $USER:$USER $mountpoint
		fi
	fi
}
add_dns() {
	sudo chattr -i /etc/resolv.conf
	nameservers=$(grep '^nameserver' /etc/resolv.conf | awk '{print $2}')
	for serverips in $nameservers; do
		for values in "$@"; do
			if [[ $serverips != $values ]]; then
				compare=1
			else
				compare=0
				break
			fi
		done
		if [ $compare == 1 ]; then
			echo "Removed: \"nameserver $serverips\" from /etc/resolv.conf"
			sudo sed -i "/^nameserver $serverips/d" /etc/resolv.conf
		fi
	done
	for ips in $@; do
		for serverips in $nameservers; do
			if [[ $serverips != $ips ]]; then
				compare=1
			else
				compare=0
				break
			fi
		done
		if [[ $compare == 1 || $nameservers == "" ]]; then
			echo "nameserver $ips" | sudo tee -a /etc/resolv.conf > /dev/null
			echo "\"nameserver $ips\" add to /etc/resolv.conf"
		fi
	done
	sudo chattr +i /etc/resolv.conf
}
add_function() {
    if ! grep -q "^$1()" ~/.bashrc; then
		echo -e "$1() {\n\t$2\n}" >> ~/.bashrc
		eval "$1() {
			$2
		}"
		echo "Function '$1' added and is now available."
	fi
}
add_lightdm() {
	if [[ -n "$2" && -z "$3" ]]; then
		local third="$2"
	else
		local third="$3"
	fi
	if [ "$1" == "e" ]; then
		if ! grep -q "^$third$" "/etc/lightdm/lightdm.conf"; then
			echo -e "\n$2" | sudo tee -a "/etc/lightdm/lightdm.conf"
		fi
	else
		if ! grep -q "^$1$" "/etc/lightdm/lightdm.conf"; then
			sudo sed -i "$2 $1" "/etc/lightdm/lightdm.conf"
		fi
	fi
}
add_sudo() {
	if ! sudo grep -q "^$1$" /etc/sudoers; then
		echo "$1" | sudo tee -a /etc/sudoers
	fi
}
#add_wirless_network() {
#	echo -e "network={\n	ssid=\"$1\"\n	psk=\"$2\"\n	scan_ssid=1\n}" | sudo tee -a "/etc/wpa_supplicant/multi_networks.conf"
#}
bool() {
	if [ "$1" == "1" ]; then
		echo "true"
	else
		echo "false"
	fi
}
alias dco="dconf dump /"
paru_clean() {
	paru -Sc --noconfirm
	rm -rf ~/.cache/paru/clone/*
	rm -rf /home/$USER/.cache/paru/clone/*
}

alias md="mkdir -p $1"
alias mds="sudo mkdir -p $1"
mdr() {
	sudo mkdir -p $1
	sudo chown $USER:$USER $1
}
