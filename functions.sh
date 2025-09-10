#!/bin/bash
# Disclaimer:
# This script is provided as-is, without any warranty or guarantee.
# By using this script, you acknowledge that you do so at your own risk.
# I am not responsible for any damage, data loss, or other issues that may result from the use of this script.


add_alias() {
	if ! grep -q "^alias $1=" ~/.bashrc; then
		code="alias $1=\"$2\""
		eval $code && echo $code >> ~/.bashrc
		echo "Alias '$1' added and saved to ~/.bashrc."
	fi
}
add_device_label() {
	for devices in "$@"; do
		if ! sudo grep -q "^LABEL=$devices " /etc/fstab; then
			fs_type=$(lsblk -o NAME,LABEL,FSTYPE | grep -w $devices | awk '{print $3}')
			if [ -n "$fs_type" ]; then
				mountpoint="/mnt/$devices"
				sudo bash -c "echo \"LABEL=$devices $mountpoint $fs_type defaults,nofail 0 2\" >> /etc/fstab"
				sudo mkdir -p $mountpoint
				sudo chown $USER:$USER $mountpoint
				local device_added=1
			fi
		fi
	done
	if [[ $device_added == 1 ]]; then
		sudo mount -a >/dev/null 2>&1
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
Clean_Folder() {
	find $1/* -mtime $2 -exec rm -f {} \; && find -L "$1" -type d -empty -delete
}
alias dco="dconf dump /"
pa() {
	sudo pacman -Syu --noconfirm
	par $@
}
par() {
	while true; do
		while IFS= read -r line1 && IFS= read -r line2; do
			if echo "$line1" | grep -q "invalid or corrupted.*(PGP signature)"; then
				local PGP_signature_error=1
			elif echo "$line1" | grep -q ":: keys need to be imported:"; then
				gpg_key=$(echo "$line2" | awk '{print $1}')
				local gpg_key_error=1
			fi
		done < <(paru -S $@ | tee /dev/tty)
		if [[ $PGP_signature_error == 1 ]]; then
			sudo pacman -Sy archlinux-keyring --noconfirm
			sudo pacman-key --populate archlinux
			sudo pacman-key --refresh-keys --keyserver hkps://keyserver.ubuntu.com
		elif [[ $gpg_key_error == 1 ]]; then
			gpg --keyserver keyserver.ubuntu.com --recv-keys $gpg_key
			gpg --keyserver hkps://keys.openpgp.org --recv-keys $gpg_key
		else
			break
		fi
		local PGP_signature_error=0
		local gpg_key_error=0
	done
}
paru_clean() {
	paru -Sc --noconfirm
	rm -rf ~/.cache/paru/clone/*
	rm -rf /home/$USER/.cache/paru/clone/*
}
#alias pause="read -p \"Press [Enter] to continue...\""
pf() {
	if [[ $# == 0 || $1 =~ -h|-help|--help ]]; then
		echo "personal folders
		
moving to new location

pf <path to new location> <personal folder(s)>
pf <path to new location> <parameters>
pf <path to new location> <personal folder(s)> <parameters>

parameters folders
	pf -d	Downloads
	pf -e	Desktop
	pf -m	Music
	pf -o	Documents
	pf -p	Pictures
	pf -t	Templates
	pf -u	Public
	pf -v	Videos

example:
pf \mnt\Data Downloads Documents -v -t
pf \mnt\Data Downloads"
		return
	else
		new_path="$1"
		shift
	fi
	while [[ $# -gt 0 ]]; do
        case "$1" in
            -d)
                local folders+=("Downloads")
                shift
                ;;
            -e)
                local folders+=("Desktop")
                shift
                ;;
            -m)
                local folders+=("Music")
                shift
                ;;
            -o)
                local folders+=("Documents")
                shift
                ;;
            -p)
                local folders+=("Pictures")
                shift
                ;;
            -t)
                local folders+=("Templates")
                shift
                ;;
            -u)
                local folders+=("Public")
                shift
                ;;
            -v)
                local folders+=("Videos")
                shift
                ;;
            -*)
                echo "Unknown option: $1"
                return
                ;;
            *)
				folder="${1,,}"; folder="${folder^}"
				if [[ " $folder " =~ Downloads|Documents|Pictures|Videos|Music|Desktop|Public|Templates ]]; then
					local folders+=("$folder")
					shift
				else
					echo "Unknown Folder: $folder"
					return
				fi
				;;
        esac
    done
	mkdir -p "$new_path" 2>/dev/null
	if ! [[ -d "$new_path" ]]; then
		echo "personal data Folder cannot be created."
		return
	fi
	declare -a old_location=(
		"Downloads:		DOWNLOAD"
		"Documents:		DOCUMENTS"
		"Pictures:		PICTURES"
		"Videos:		VIDEOS"
		"Music:			MUSIC"
		"Desktop:		DESKTOP"
		"Public:		PUBLICSHARE"
		"Templates:		TEMPLATES"
	)
	folders=($(printf "%s\n" "${folders[@]}" | awk '!seen[$0]++'))
	for userfolder in "${folders[@]}"; do
		echo $userfolder
		old_location_dir=$(printf "%s\n" "${old_location[@]}" | grep "$userfolder" | awk -F':' '{print $2}' | sed -E 's/^[[:space:]]+//')
		old_location_path=$(xdg-user-dir $old_location_dir)
		new_path_userfolder="$new_path/$userfolder"
		if [[ $(grep "^XDG_${old_location_dir}_DIR=" ~/.config/user-dirs.dirs | awk -F'=' '{print $2}' | sed 's/"//g') == "$new_path_userfolder" ]]; then
			echo "$new_path_userfolder: is already set to this location"
			echo "------------------------------------"
			continue
		fi
		local sync_error=0
		while (( $sync_error < 3 )); do
			sudo rsync -avuc $old_location_path $new_path
			local error=0
			while read line; do
				if echo "$line" | grep "^Only in $old_location_path" > /dev/null; then
					((sync_error++))
					local error=1
					break
				elif echo "$line" | grep "differ" > /dev/null; then
					if [[ "$(echo "$line" | grep -oP '/[^ ]+' | sed -n '2p')" != "$(ls -lt $(echo "$line" | grep -oP '/[^ ]+') | head -n 1 | grep -oP '/[^ ]+')" ]]; then
						((sync_error++))
						local error=1
						break
					fi
				fi
			done < <(sudo diff -qr $old_location_path $new_path_userfolder 2>/dev/null)
			if [[ (( $error = 0 )) ]]; then
				sudo sed -i "/^XDG_${old_location_dir}_DIR=/c\XDG_${old_location_dir}_DIR=\"$new_path_userfolder\"" ~/.config/user-dirs.dirs
				rm -rf $old_location_path
				sudo ln -sf $new_path_userfolder $old_location_path
				break
			fi 
		done
		echo "------------------------------------"
	done
}
sp() {
	local ShowIn="Budgie;Deepin;Enlightenment;GNOME;KDE;LXDE;LXQt;MATE;Old;Pantheon;ROX;Sugar;TDE;Unity;X-Cinnamon;XFCE;"
	help_text() {
		echo "startup personal
				
Creating program startup for this user.

Usage:	sp [arguments] [parameters]

arguments
	Filename Type Execution
	
	Filename:
	a space is not allowed use instead _ or -
	
	Type can only be:
	Application, Link, or Directory

parameters (optional)
    -a --Autostart		autostart disabled
    -d --NoDisplay		invisble - possible to run visible applications
    -e --Hidden			invisble - not possible to run visible applications 
    -t --Terminal		run in a visual terminal
    -s --StartupNotify		startup animation
    -b --DBusActivatable	if supports DBus activation
    -D --Delay			[text] autostartdelay (seconds, digits only)
    -n --Name			[text]	explorer name
    -c --Comment		[text]	comment
    -H --GenericName		[text]	hoverover name - (work in some environments)
    -o --OnlyShowIn		[text]	only show in specifies desktop environments {$ShowIn}
    -x --NotShowIn		[text]	not show in specifies desktop environments {$ShowIn}
    -y --MimeType		[text]	supported file types (MimeTypes) common one {text/plain;text/html;text/css;image/png;image/jpeg;image/gif;audio/mpeg;audio/ogg;video/mp4;video/webm;application/pdf;application/zip;application/x-tar;application/json;application/xml;}
    -m --StartupWMClass		[text]	window menu class
    -g --Categories		[text]	categories start menu
    -k --Keywords		[text]	search keywords
    -i --Icon			[path]	icon
    -w --Path			[path]	working directory
    -r --TryExec		[path]	program path - (only show in menu when program exists)
	
Translations
    Translations codes can be:
    af am an ar as ast be bn br bs ca cs cy da de de_AT de_CH el en en_GB en_US eo es es_AR es_CO et eu fa fi fo fr fr_BE fr_CA ga gl gu he hi hr hu hy id is it ja jv ka kk km kn ko ky la lb lo lt lv mk ml mr ms mt nb ne nl nn oc pl ps pt pt_BR qu ro ru rw se si sk sl sq sr sv sw ta te th tl tr uk uz vi wa xh yi zh zh_CN zh_TW zu

parameters (optional)
    -Name[*]	[text]	explorer name (translations)
    -Comment[*]	[text]	comment (translations)

example:
sp filename Application \"execution command\" -a -b -d -e -s -t -n \"explorer name\" -c \"comment\" -D \"25\" -i \"/path/to/icon/\" -w \"/path/to/working/directory/\" -H \"hoverover name\" -r \"/path/to/program/\" -o \"GNOME;KDE;\" -x \"GNOME;KDE;\" -m firefox -g \"Office;\" -y \"text/plain;image/png;\" -k \"browser;internet;\" -Name[it] \"avvio personale\" -Comment[id] \"Buat file aplikasi startup pribadi dengan mudah\"

if you need an \" in startup file then you must use \\\"...\\\"

---------------------------------
Removing startup file
sp -R --Remove \"filename\"
"
	}
	if [[ $# -eq 0 ]]; then
		help_text
		return
	fi
	valid_option() {
		local VO_splits=(${2//;/ })
		local VO_valid=(${3//;/ })
		for VO_split in ${VO_splits[@]}; do
			if ! [[ " ${VO_valid[@]} " == *" $VO_split "* ]]; then
				echo -e "\n\nNo valid option for $1; the only valid options are: ($3)"
				return 2
			fi
		done
	}
	local save_path="/etc/xdg/autostart"
	while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|-help|--help)
                help_text
                return
                ;;
            -a|--Autostart)
                local Autostart="Autostart-enabled=false\nX-GNOME-Autostart-enabled=false"
                shift
                ;;
            -b|--DBusActivatable)
                local DBusActivatable="true"
                shift
                ;;
            -c|--Comment)
                local Comment="$2"
                shift 2
                ;;
            -Comment\[*\])
                [[ -n $comment ]] && comment+=$(echo "\n")
				local comment+=$(echo "$1=$2")
                shift 2
                ;;
            -d|--NoDisplay)
                local NoDisplay="NoDisplay=true"
                shift
                ;;
            -D|--Delay)
                local Delay=$2
                shift 2
                ;;
            -e|--Hidden)
                local Hidden="Hidden=true"
                shift
                ;;
            -g|--Categories)
                local Categories="$2"
                shift 2
                ;;
            -H|--GenericName)
                local GenericName="$2"
                shift 2
                ;;
            -i|--Icon)
                local Icon="$2"
                shift 2
                ;;
            -k|--Keywords)
                local Keywords="$2"
                shift 2
                ;;
            -m|--StartupWMClass)
                local StartupWMClass="$2"
                shift 2
                ;;
            -n|--Name)
                local Name="$2"
                shift 2
                ;;
            -Name\[*\])
				#valid_option "-Name[*]" $2 "" #the possible translation options
				[[ -n $name ]] && name+=$(echo "\n")
				local name+=$(echo "$1=$2")
                shift 2
                ;;
            -o|--OnlyShowIn)
				valid_option $1 $2 $ShowIn; [[ $? -eq 2 ]] && return || local OnlyShowIn="$2"
                shift 2
                ;;
            -r|--TryExec)
                local TryExec="$2"
                shift 2
                ;;
			-R|--Remove)
				sudo rm -f "$save_path/$2.desktop"
				echo "$2.desktop has been removed from the startup directory"
                return
                ;;
            -s|--StartupNotify)
                local StartupNotify="StartupNotify=true"
                shift
                ;;
            -t|--Terminal)
                local Terminal="true"
                shift
                ;;
            -w|--Path)
                local Path="$2"
                shift 2
                ;;
            -x|--NotShowIn)
                valid_option $1 $2 $ShowIn; [[ $? -eq 2 ]] && return || local NotShowIn="$2"
                shift 2
                ;;
            -y|--MimeType)
                local MimeType="$2"
                shift 2
                ;;
            -*)
                echo "Unknown option: $1"
                return
                ;;
            *)
                local info+=("$1")
                shift
                ;;
        esac
    done
	valid_option "Type" ${info[1]} "Application;Link;Directory"; [[ $? -eq 2 ]] && return
	save_file="$save_path/${info[0]}.desktop"
	data=$(echo -e "[Desktop Entry]
		Type=${info[1]}
		$( [[ -n $Delay ]] && echo "Exec=/bin/bash -c \"sleep $Delay; ${info[2]}\"" || echo "Exec=/bin/bash -c \"${info[2]}\"" )
		$( for list in Autostart  Categories comment DBusActivatable GenericName Hidden Icon Keywords MimeType Name name NoDisplay OnlyShowIn NotShowIn Path StartupNotify StartupWMClass Terminal TryExec; do
			if [[ ${!list} == *=* ]]; then
				echo ${!list}
			else
				[[ -n ${!list} ]] && echo "$list=${!list}"
			fi
		done)" | sed 's/^[[:space:]]*//' | sed '/^$/d' | sed 's/^\([^=\[]*\)-/\1/')
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
#start_s()
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
