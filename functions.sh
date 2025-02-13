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
pa() {
	sudo pacman -Syu --noconfirm
	par $@
}
par() {
	while true; do
		while read line; do
			if echo "$line" | grep -q "invalid or corrupted.*(PGP signature)"; then
				local PGP_signature_error=1
			fi
		done < <(paru -S $@ | tee /dev/tty)
		if [[ $PGP_signature_error == 1 ]]; then
			sudo pacman -Sy archlinux-keyring --noconfirm
			sudo pacman-key --populate archlinux
			sudo pacman-key --refresh-keys --keyserver hkps://keyserver.ubuntu.com
		else
			break
		fi
		local PGP_signature_error=0
	done
}
paru_clean() {
	paru -Sc --noconfirm
	rm -rf ~/.cache/paru/clone/*
	rm -rf /home/$USER/.cache/paru/clone/*
}
sp() {
	while [[ $# -gt 0 ]]; do
        case "$1" in
            -help)
                echo "startup personal

arguments
	Filename Type Execution
	
	Type can only be:
	Application, Link, or Directory

parameters (optional)
	sp -a 	autostart disabled
	sp -d 	invisble - possible to run visible applications
	sp -n	invisble - not possible to run visible applications 
	sp -t	terminal - run in terminal
	sp -s	startup animation
	sp -b	if supports DBus activation
	sp -e	[text]	explorer name
	sp -c	[text]	comment
	sp -h	[text]	hoverover name - (work in some environments)
	sp -o	[text]	only show in specifies desktop environments
	sp -x	[text]	not show in specifies desktop environments
	sp -y	[text]	supported file types (MimeTypes)
	sp -m	[text]	window menu class
	sp -g	[text]	categories start menu
	sp -k	[text]	search keywords
	sp -i	[path]	icon
	sp -w	[path]	working directory
	sp -r	[path]	program path - (only show in menu when program exists)
	
Translations
	Translations codes can be:
	af am an ar as ast be bn br bs ca cs cy da de de_AT de_CH el en en_GB en_US eo es es_AR es_CO et eu fa fi fo fr fr_BE fr_CA ga gl gu he hi hr hu hy id is it ja jv ka kk km kn ko ky la lb lo lt lv mk ml mr ms mt nb ne nl nn oc pl ps pt pt_BR qu ro ru rw se si sk sl sq sr sv sw ta te th tl tr uk uz vi wa xh yi zh zh_CN zh_TW zu

parameters (optional)
	sp -Name[*]	[text]	explorer name (translations)
	sp -Comment[*]	[text]	comment (translations)

example:
sp filename application \"execution command\" -a -b -d -n -e -s -t \"explorer name\" -c \"comment\" -i \"/path/to/icon/\" -w \"/path/to/working/directory/\" -h \"hoverover name\" -r \"/path/to/program/\" -o \"GNOME;KDE;\" -x \"GNOME;KDE;\" -m firefox -g \"Office;\" -y \"text/plain;image/png;\" -k \"browser;internet;\" -Name[it] \"avvio personale\" -Comment[id] \"Buat file aplikasi startup pribadi dengan mudah\"

if you need an \" in startup file then you must use \\\"...\\\""
                return 1
                ;;
            -a)
                local a=1
                shift
                ;;
            -b)
                local b=1
                shift
                ;;
            -c)
                local c="$2"
                shift 2
                ;;
            -Comment\[*\])
                local Comment+=("$1=$2\n")
                shift 2
                ;;
            -d)
                local d=1
                shift
                ;;
            -e)
                local e="$2"
                shift 2
                ;;
            -g)
                local g="$2"
                shift 2
                ;;
            -h)
                local h="$2"
                shift 2
                ;;
            -i)
                local i="$2"
                shift 2
                ;;
            -k)
                local k="$2"
                shift 2
                ;;
            -m)
                local m="$2"
                shift 2
                ;;
            -n)
                local n=1
                shift
                ;;
            -Name\[*\])
                local Name+=("$1=$2\n")
                shift 2
                ;;
            -o)
                local o="$2"
                shift 2
                ;;
            -r)
                local r="$2"
                shift 2
                ;;
            -s)
                local s=1
                shift
                ;;
            -t)
                local t=1
                shift
                ;;
            -w)
                local w="$2"
                shift 2
                ;;
            -x)
                local x="$2"
                shift 2
                ;;
            -y)
                local y="$2"
                shift 2
                ;;
            -*)
                echo "Unknown option: $1"
                return 1
                ;;
            *)
                local info+=("$1")
                shift
                ;;
        esac
    done
	save_file="/etc/xdg/autostart/${info[0]}.desktop"
	if [[ $(echo "${info[@]}" | wc -w ) -ge 4 ]]; then
		read -ra exec <<< "${info[@]}"
		local exec=$(echo "${exec[@]: -2}")
	else 
		local exec=${info[2]}
	fi
	data=$(echo "[Desktop Entry]
		Type=${info[1]}
		Exec=$exec
		$( [[ "$n" == 1 ]] && echo "Hidden=true" )
		$( [[ "$d" == 1 ]] && echo "NoDisplay=true" )
		$( [[ "$a" == 1 ]] && echo "X-GNOME-Autostart-enabled=false" )
		$( [[ "$t" == 1 ]] && echo "Terminal=true" )
		$( [[ "$s" == 1 ]] && echo "StartupNotify=true" )
		$( [[ "$b" == 1 ]] && echo "DBusActivatable=true" )
		$( [[ -n $e ]] && echo "Name=$e" )
		$( [[ -n $Name[@] ]] && echo -e ${Name[@]} | sed 's/-//' )
		$( [[ -n $c ]] && echo "Comment=$c" )
		$( [[ -n $Comment[@] ]] && echo -e ${Comment[@]} | sed 's/-//' )
		$( [[ -n $i ]] && echo "Icon=$i" )
		$( [[ -n $w ]] && echo "Path=$w" )
		$( [[ -n $h ]] && echo "GenericName=$h" )
		$( [[ -n $r ]] && echo "TryExec=$r" )
		$( [[ -n $o ]] && echo "OnlyShowIn=$o" )
		$( [[ -n $x ]] && echo "NotShowIn=$x" )
		$( [[ -n $m ]] && echo "StartupWMClass=$m" )
		$( [[ -n $g ]] && echo "Categories=$g" )
		$( [[ -n $y ]] && echo "MimeType=$y" )
		$( [[ -n $k ]] && echo "Keywords=$k" )" | sed 's/^[[:space:]]*//' | sed '/^$/d')
	if [[ "$(cat $save_file 2>/dev/null)" != "$data" ]]; then
		sudo bash -c "cat << EOF | sed 's/^\t\+//' > $save_file
		$data
EOF"
		echo "${info[0]} - startup created"
	else
		echo "${info[0]} - startup already has the value"
	fi
	echo "------------------------------------"
}
ssu() {
	sudo -v
	while true; do
		sudo -n true
		sleep 60
	done &
}

alias md="mkdir -p $1"
alias mds="sudo mkdir -p $1"
mdr() {
	sudo mkdir -p $1
	sudo chown $USER:$USER $1
}
