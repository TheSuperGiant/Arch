#!/bin/bash
# Disclaimer:
# This script is provided as-is, without any warranty or guarantee.
# By using this script, you acknowledge that you do so at your own risk.
# I am not responsible for any damage, data loss, or other issues that may result from the use of this script.


#LIGHTDM_CONF="/etc/lightdm/lightdm.conf"

add_alias() {
	alias_name=$1
	alias_command=$2
	if ! grep -q "^alias $alias_name" ~/.bashrc; then
		echo "alias $alias_name=\"$alias_command\"" >> ~/.bashrc
		eval "alias $alias_name=\"$alias_command\""
		#eval "$alias_name() {
		#	$alias_command
		#}"
		echo "Alias '$alias_name' added and saved to ~/.bashrc."
	fi
}
add_device_label() {
	if ! sudo grep -q "LABEL=$1" /etc/fstab; then
		fs_type=$(lsblk -o NAME,LABEL,FSTYPE | grep -w $1 | awk '{print $3}')
		if [ -n "$fs_type" ]; then
			mountpoint="/mnt/$1"
			sudo bash -c "echo \"LABEL=$1 $mountpoint $fs_type defaults,nofail 0 2\" >> /etc/fstab"
			sudo mkdir -p $mountpoint
			sudo chown $USER:$USER $mountpoint
		fi
	fi
}
add_function() {
    func_name=$1
    func_body=$2
	if ! grep -q "^function $func_name" ~/.bashrc; then
		echo -e "function $func_name {\n\t$func_body\n}" >> ~/.bashrc
		eval "$func_name() {
			$func_body
		}"
		echo "Function '$func_name' added and is now available."
	fi
}
add_lightdm() {
	if [[ -n "$2" && -z "$3" ]]; then
		local third="$2"
	else
		local third="$3"
	fi
	if [ "$1" == "e" ]; then
		if ! grep -q "^$third" "/etc/lightdm/lightdm.conf"; then
			echo -e "\n$2" | sudo tee -a "/etc/lightdm/lightdm.conf"
		fi
	else
		if ! grep -q "^$1" "/etc/lightdm/lightdm.conf"; then
			sudo sed -i "$2 $1" "/etc/lightdm/lightdm.conf"
		fi
	fi
}
add_sudo() {
	if ! sudo grep -q "$1" /etc/sudoers; then
		echo "$1" | sudo tee -a /etc/sudoers
	fi
}
bool() {
	if [ "$1" == "1" ]; then
		echo "true"
	else
		echo "false"
	fi
}


alias md="mkdir -p $1"
alias mds="sudo mkdir -p $1"
function mdr {
	sudo mkdir -p $1
	sudo chown $USER:$USER $1
}
