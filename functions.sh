#!/usr/bin/env bash
# Disclaimer:
# This script is provided as-is, without any warranty or guarantee.
# By using this script, you acknowledge that you do so at your own risk.
# I am not responsible for any damage, data loss, or other issues that may result from the use of this script.


error() {
	printf "\e[1;91m$1\e[0m\n"
}

add_alias() {
	if ! grep -q "^alias $1=" ~/.bashrc; then
		code="alias $1=\"$2\""
		eval $code && echo $code >> ~/.bashrc
		echo "Alias '$1' added and saved to ~/.bashrc."
	fi
}
add_device_label() {
	help_text() {
		echo "mounting paritions add boot

add_device_label <label name>

example:
add_device_label \"data\" \"games\""
	}
	if [[ $# == 0 ]] || printf '%s\n' "$@" | grep -qE '^-(h|help)$|^--help$'; then
		help_text
		return
	fi
	for devices in "$@"; do
		local old_value=$(grep "^LABEL=$devices " /etc/fstab)
		local fs_type=$(lsblk -o NAME,LABEL,FSTYPE | grep -w $devices | awk '{print $3}')
		if [[ -n "$fs_type" ]]; then
			mountpoint="/mnt/$devices"
			new_value="LABEL=$devices $mountpoint $fs_type defaults,nofail 0 2"
			old_mountpoints=$(awk -v mp="$mountpoint" '{for(i=1;i<=NF;i++) if($i==mp) print}' /etc/fstab)
			if [[ "$new_value" != "$old_value" && -n "$old_mountpoints" ]]; then
				sudo sed -i "\|$(printf '%s\n' "$mountpoint" | sed 's/[\/&]/\\&/g')|d" /etc/fstab
			fi
			if ! sudo grep -q "^LABEL=$devices " /etc/fstab; then
				sudo bash -c "echo \"$new_value\" >> /etc/fstab" && echo "✅ Added '$devices' partition to /etc/fstab"
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
	printf "⚠️ WARNING: This function may block access to websites on open business networks. ⚠️\n\n\n"
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
		if [[ $compare == 1 ]]; then
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
	if [[ "$1" == "e" ]]; then
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
	if [[ "$1" == "1" ]]; then
		echo "true"
	else
		echo "false"
	fi
}
box() {
	local char="${2:-=}"
	local width=40
	local text="$1"
	local fill=$(( (width - 2 - ${#text}) / 2 ))
	line() {
		awk -v w="$width" -v c="$char" 'BEGIN {for(i=0;i<w;i++) printf "%s", c; print ""}'
	}
	if [[ "$char" =~ ^("█"|"▒"|"░") ]]; then
		begin_end="$char"
	else
		begin_end="|"
	fi
	line
	printf "$begin_end%*s%s%*s$begin_end\n" "$fill" '' "$text" "$((width - 2 - ${#text} - fill))" ''
	line
}
box_part() {
	box "$1..." "="
}
box_sub() {
	box "$1" "-"
}
Clean_Folder() {
	find $1/* -mtime $2 -exec rm -f {} \; && find -L "$1" -type d -empty -delete
}
alias dco="dconf dump /"
dco_value() {
	echo $(dconf read $1)
}
dcoa() {
	if [[ "$2" != *[\[\]]* ]]; then
		echo "['$1']"
	else
		echo "${2%]}, '$1']"
	fi
}
dcod() {
	list="${2//\'$1\'/}"; list="${list//, , /, }"; echo "$list"
}
dcor() {
	local current_value=$(dco_value $1)
	if [[ -n "$current_value" ]]; then
		dconf reset $1 && echo "$1 - removed"
	else
		echo "$1 - already removed"
	fi
	echo "------------------------------------"
}
dcow() {
	local current_value=$(dco_value $1)
	if [[ "$2" != "$current_value" ]]; then
		dconf write $1 "$2" && echo "$1 $2 - updated"
	else
		echo "$1 $2 - already has the value"
	fi
	echo "------------------------------------"
}
ext4setup() {
	label_check() {
		while :; do
			printf "Enter label for the partition: "; read label
			if [[ "$label" =~ ^("root"|"home"|"swap"|"boot") || ! "$label" =~ ^[A-Za-z0-9_-]{1,16}$ ]]; then
				clear
				error "$label: is not allowed! \nAllowed: 1–16 letters, numbers, - or _ (no spaces or special characters)\nnot allowed names: root home swap boot\n\n"
			else
				return
			fi
		done
	}

	clear

	# Disclaimer message
	echo "Warning: I am not responsible for any data loss if you choose the wrong disk!"
	echo "Please double-check the disk you are selecting before proceeding."

	printf "\n\n⚠️ WARNING: This will erase all data on that disk.⚠️\n\n\n"

	while :; do
		while :; do
			lsblk -o NAME,TYPE,SIZE,LABEL,MODEL | awk 'NR==1{print;next} $2=="disk" && NR>1{print "--------------------------------------------------"} $2=="disk" || $2=="part"{print}'
			echo "--------------------------------------------------"

			printf "Enter disk (e.g., 'a-z' for /dev/sdX or '0,1,..' for /dev/nvmeXn1): "; read disk_letter; disk_letter=$(echo "$disk_letter" | tr '[:upper:]' '[:lower:]')
			if [[ $disk_letter =~ ^[a-z]$ ]]; then
			    DISK="/dev/sd${disk_letter}"
			else
				DISK="/dev/nvme${disk_letter}n1"
			fi
			if [[ ! -e "$DISK" ]]; then
				clear
				echo "Disk not found. Try again."
				echo
				echo
			else
				break
			fi
		done

		clear
		echo "Disk information for $DISK:"
		echo "----------------------------------"
		lsblk -o NAME,TYPE,SIZE,LABEL,MODEL $DISK

		echo
		echo
		printf "Are you sure you want to format disk $DISK? Type 'y' to proceed: "; read confirm; confirm=$(echo "$confirm" | tr '[:upper:]' '[:lower:]')
		if [[ $confirm = "y" ]]; then
			disk_type=$(lsblk -d -o ROTA -n "$DISK" | xargs)
			break
		fi
	done

	clear
	label_check

	partitions=$(ls ${DISK}* | grep -E "^${DISK}[0-9]$")
	partitions_count=$(echo "$partitions" | wc -l)

	for partion in $partitions; do
		echo "$partion"
		sudo umount "$partion"
	done

	for ((i=1; i<=partitions_count; i++)); do
		printf "d\n$i\n" | sudo fdisk "$DISK"
	done
	printf "g\nn\n\n\n\nw" | sudo fdisk "$DISK"

	if [[ $disk_letter =~ ^[0-9]$ ]]; then
		DISK="${DISK}p"
	fi

	if [[ "$disk_type" == "1" ]]; then #hdd
		sudo mkfs.ext4 -F -c -L $label "${DISK}1"
	elif [[ "$disk_type" == "0" ]]; then #flash drives
		sudo mkfs.ext4 -F -L $label "${DISK}1"
	fi
}
git_config() {
	while :; do
		printf "Enter global github push email: ";read email
		if [[ "$email" =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$ ]]; then
			break
		fi
	done
	printf "Enter global github push name: ";read name
	git config --global user.email "$email"
	git config --global user.name "$name"
}
git_u() {
	error_default() {
		error "\n\n$1"
	}
	help_text() {
		echo "git upload

github project upload with ssh

parameters
	-b --branch			[text]  branch
	-g --git			[text]  ssh project url
	-p --path			[text]  local path

parameters (optional)
	-s --ssh			[text]  ssh file
	-e --email			[text]  email
	-u --user			[text]  username
	-m --message			[text]  message
	-o --onetime			one-time ssh key usage. (-s/--ssh) required


example:
${FUNCNAME[1]} -b \"main\" -g \"git@github.com:username/respetory.git\" -p \"/path/to/local/project\"
${FUNCNAME[1]} -b \"main\" -g \"git@github.com:username/respetory.git\" -p \"/path/to/local/project\" -s \"filename\" -u \"username\" -m \"message\""
	}
	if [[ $# == 0 ]] || printf '%s\n' "$@" | grep -qE '^-(h|help)$|^--help$'; then
		help_text
		return
	fi
	while [[ $# -gt 0 ]]; do
		case "$1" in
			-b|--branch)
				local branch="$2"
				shift 2
				;;
			-e|--email)
				local email="$2"
				shift 2
				;;
			-g|--git)
				local git="$2"
				shift 2
				;;
			-m|--message)
				local message="$2"
				shift 2
				;;
			-o|--onetime)
				local one_time="1"
				shift
				;;
			-p|--path)
				local path="$2"
				shift 2
				;;
			-s|--ssh)
				local ssh="$2"
				shift 2
				;;
			-u|--user)
				local user="$2"
				shift 2
				;;
			*)
				help_text
				error_default "Unknown option: $1"
				return
				;;
		esac
	done
	if [[ -z "$branch" || -z "$git" || -z "$path" ]]; then
		help_text
		error_default "paramers reqired: -b/--branch -g/--git -p/--path"
		return
	fi
	if ! [[ -e "$path" ]]; then
		error "$path - not found"
		return
	fi
	if [[ -n "$one_time" && -z "$ssh" ]]; then
		help_text
		error_default "parameters reqired with -o/--onetime: -s/--ssh"
		return
	fi
	if [[ -z "$one_time" ]]; then
		if [[ $(pgrep ssh-agent) == "" ]]; then
			eval "$(ssh-agent -s)"
		fi
		if [[ -n $ssh ]]; then
			ssh-add ~/.ssh/"$ssh"
		fi
	fi
	cd "$path"
	if ! [[ -e ".git" ]]; then
		git init
	fi
	local remote_set=$(git remote -v)
	if [[ -z $remote_set ]]; then
		git remote add origin "$git"
		if [[ -n "$user" ]]; then
			git config user.name "$user"
		fi
		if [[ -n "$email" ]]; then
			git config user.email "$email"
		fi
	fi
	git add .
	git commit --allow-empty-message -m "$message"
	git branch -M "$branch"
	local pushing=" git push orig in $branch --porcelain 2>&1"
	if [[ -n "$one_time" ]]; then
		local pushing="GIT_SSH_COMMAND=ssh -i $HOME/.ssh/$ssh -o IdentitiesOnly=yes $pushing"
	fi
	while [[ $folder_sync != "0" ]]; do
		local folder_sync=0
		while IFS= read -r line1; do
			if echo "$line1" | grep -qE "error: failed to push some refs to"; then
				local folder_sync=1
			fi
		#done < <("{$pushing:-}" git push origin "$branch" --porcelain 2>&1)
		done < <(eval "$pushing")
		if [[ "$folder_sync" == "1" ]]; then
			mkdir -p "/tmp/$path"
			cp -r . "/tmp/$path"
			if [[ -z "$one_time" ]]; then
				git fetch origin
				echo hello #temp
			else
				#GIT_SSH_COMMAND="ssh -i \"$HOME/.ssh/$ssh -o IdentitiesOnly=yes\"" git fetch origin
				GIT_SSH_COMMAND="ssh -i $HOME/.ssh/$ssh -o IdentitiesOnly=yes" git fetch origin
				echo test #temp
			fi
			git reset --hard origin/"$branch"
			git merge origin/"$branch"
		else
			local folder_sync=0
		fi
	done
	cd ~
}
git_update() {
	#$1 path
	#$2 github user
	#$3	github repo
	#$- repo name for push
	if ! [[ -e "$1" ]]; then
		git clone https://github.com/"$2"/"$3".git "$1"
	else
		git -C "$1" pull
	fi
}
alias lsbl="lsblk -o NAME,TYPE,SIZE,LABEL,MOUNTPOINTS"
pa() {
	sudo pacman -Syu --noconfirm
	par $@
}
par() {
	while :; do
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
alias pause="read -p \"Press [Enter] to continue...\""
pf() {
	printf "⚠️ WARNING: Using this function will lock the userfolders file. If you want to make changes to the file, you must first give it root write privileges again.⚠️\n\n\n"
	local desktop_name=$(xdg-user-dir "DESKTOP" 2>/dev/null | awk -F'/' '{print $NF}')
	local download_name=$(xdg-user-dir "DOWNLOAD" 2>/dev/null | awk -F'/' '{print $NF}')
	local music_name=$(xdg-user-dir "MUSIC" 2>/dev/null | awk -F'/' '{print $NF}')
	local documents_name=$(xdg-user-dir "DOCUMENTS" 2>/dev/null | awk -F'/' '{print $NF}')
	local pictures_name=$(xdg-user-dir "PICTURES" 2>/dev/null | awk -F'/' '{print $NF}')
	local templates_name=$(xdg-user-dir "TEMPLATES" 2>/dev/null | awk -F'/' '{print $NF}')
	local public_name=$(xdg-user-dir "PUBLICSHARE" 2>/dev/null | awk -F'/' '{print $NF}')
	local videos_name=$(xdg-user-dir "VIDEOS" 2>/dev/null | awk -F'/' '{print $NF}')
	help_text() {
		echo "personal folders

moving to new location

${FUNCNAME[1]} <path to new location> <personal folder(s)>
${FUNCNAME[1]} <path to new location> <parameters>
${FUNCNAME[1]} <path to new location> <personal folder(s)> <parameters>

parameters
	${FUNCNAME[1]} -y	Create non-default user folders automatically. Skips the yes/no confirmation.

parameters folders
	${FUNCNAME[1]} -d	$download_name
	${FUNCNAME[1]} -e	$desktop_name
	${FUNCNAME[1]} -m	$music_name
	${FUNCNAME[1]} -o	$documents_name
	${FUNCNAME[1]} -p	$pictures_name
	${FUNCNAME[1]} -t	$templates_name
	${FUNCNAME[1]} -u	$public_name
	${FUNCNAME[1]} -v	$videos_name

example:
${FUNCNAME[1]} /mnt/Data $download_name $documents_name -v -t
${FUNCNAME[1]} /mnt/Data $download_name
${FUNCNAME[1]} /mnt/Data banana
${FUNCNAME[1]} /mnt/Data banana -y
${FUNCNAME[1]} /mnt/Data $download_name $documents_name -v -t banana -y"
	}
	if [[ $# == 0 ]] || printf '%s\n' "$@" | grep -qE '^-(h|help)$|^--help$'; then
		help_text
		return
	else
		new_path="$1"
		shift
	fi
	if [[ " $* " == *" -y "* ]]; then
		local yes_force="1"
	fi
	while [[ $# -gt 0 ]]; do
		case "$1" in
			-d)
				local folders+=("$download_name")
				shift
				;;
			-e)
				local folders+=("$desktop_name")
				shift
				;;
			-m)
				local folders+=("$music_name")
				shift
				;;
			-o)
				local folders+=("$documents_name")
				shift
				;;
			-p)
				local folders+=("$pictures_name")
				shift
				;;
			-t)
				local folders+=("$templates_name")
				shift
				;;
			-u)
				local folders+=("$public_name")
				shift
				;;
			-v)
				local folders+=("$videos_name")
				shift
				;;
			-y)
				shift
				;;
			-*)
				echo "Unknown option: $1"
				return
				;;
			*)
				folder="${1,,}"; folder="${folder^}"
				if [[ " $folder " =~ $download_name|$desktop_name|$music_name|$documents_name|$pictures_name|$templates_name|$public_name|$videos_name ]]; then
					local folders+=("$folder")
					shift
				else
					if [[ "$yes_force" == "1" ]]; then
						local folders+=("$folder")
						shift
					else
						printf "Is '$folder' the correct folder name? Type 'y' to confirm: "; read confirm; confirm=$(echo "$confirm" | tr '[:upper:]' '[:lower:]')
						if [[ $confirm = "y" ]]; then
							local folders+=("$folder")
							shift
						else
							echo "Unknown Folder: $folder"
							return
						fi
					fi
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
		"$download_name:		DOWNLOAD"
		"$documents_name:		DOCUMENTS"
		"$pictures_name:		PICTURES"
		"$videos_name:		VIDEOS"
		"$music_name:			MUSIC"
		"$desktop_name:		DESKTOP"
		"$public_name:		PUBLICSHARE"
		"$templates_name:		TEMPLATES"
	)
	userfolder_file="$HOME/.config/user-dirs.dirs"
	folders=($(printf "%s\n" "${folders[@]}" | awk '!seen[$0]++'))
	sudo chattr -i $userfolder_file
	for userfolder in "${folders[@]}"; do
		echo $userfolder
		local old_location_dir=$(printf "%s\n" "${old_location[@]}" | grep "$userfolder" | awk -F':' '{print $2}' | sed -E 's/^[[:space:]]+//')
		if [[ -z $old_location_dir ]]; then
			local old_locationd_found=0
			local old_location_dir=${userfolder^^}
			local old_user_path="$HOME/$userfolder"
			if [[ -d "$old_user_path" ]]; then
				local old_location_path="$old_user_path"
			else
				local userfolder_found=0
			fi
		else
			local old_location_path=$(grep "^XDG_${old_location_dir}_DIR=" $userfolder_file | sed -n 's/.*"\([^"]*\)".*/\1/p')
			local old_location_path=$(echo "$old_location_path" | envsubst)
		fi
		local new_path_userfolder="$new_path/$userfolder"
		if [[ $(grep "^XDG_${old_location_dir}_DIR=" $userfolder_file | awk -F'=' '{print $2}' | sed 's/"//g') == "$new_path_userfolder" ]]; then
			echo "$new_path_userfolder: is already set to this location"
			echo "------------------------------------"
			continue
		fi
		local sync_error=0
		while (( $sync_error < 3 )); do
			if [[ -n $old_location_path ]]; then
				sudo rsync -avuc $old_location_path $new_path
			fi
			local err=0
			while read line; do
				if echo "$line" | grep "^Only in $old_location_path" > /dev/null; then
					((sync_error++))
					local err=1
					break
				elif echo "$line" | grep "differ" > /dev/null; then
					if [[ "$(echo "$line" | grep -oP '/[^ ]+' | sed -n '2p')" != "$(ls -lt $(echo "$line" | grep -oP '/[^ ]+') | head -n 1 | grep -oP '/[^ ]+')" ]]; then
						((sync_error++))
						local err=1
						break
					fi
				fi
			done < <(sudo LC_ALL=C diff -qr $old_location_path $new_path_userfolder 2>/dev/null)
			if ! [[ -d "$new_path_userfolder" ]] && [[ "$userfolder_found" != 0 ]]; then
				((sync_error++))
				local err=1
			fi
			if [[ (( $err = 0 )) ]]; then
				if [[ -n $old_location_path ]]; then
					if [[ $old_locationd_found == 0 ]]; then
						sudo echo "XDG_${old_location_dir}_DIR=\"$new_path_userfolder\"" >> $userfolder_file
					else
						sudo sed -i "/^XDG_${old_location_dir}_DIR=/c\XDG_${old_location_dir}_DIR=\"$new_path_userfolder\"" $userfolder_file
					fi
					sudo rm -rf $old_location_path
				else
					sudo echo "XDG_${old_location_dir}_DIR=\"$new_path_userfolder\"" >> $userfolder_file
					sudo mkdir -p $new_path_userfolder
					sudo chown $USER:$USER $new_path_userfolder
				fi
				sudo ln -sf $new_path_userfolder "$HOME/$userfolder"
				break
			fi
		done
		echo "------------------------------------"
	done
	sudo chattr +i $userfolder_file
}
s_link() {
	if [[ "$2" != $(readlink "$2") ]]; then
		if [[ $3 == "-f" ]]; then
			rm -r "$2"
		else
			rm "$2"
		fi
		mkdir -p ${2%/*}
		ln -s "$1" "$2"
	fi
}
sp() {
	local ShowIn="Budgie;Deepin;Enlightenment;GNOME;KDE;LXDE;LXQt;MATE;Old;Pantheon;ROX;Sugar;TDE;Unity;X-Cinnamon;XFCE;"
	help_text() {
		echo "startup personal

Creating program startup for this user.

Usage:	${FUNCNAME[1]} [arguments] [parameters]

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
    -D --Delay			[text]  autostartdelay (seconds, digits only)
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
${FUNCNAME[1]} filename Application \"execution command\" -a -b -d -e -s -t -n \"explorer name\" -c \"comment\" -D \"25\" -i \"/path/to/icon/\" -w \"/path/to/working/directory/\" -H \"hoverover name\" -r \"/path/to/program/\" -o \"GNOME;KDE;\" -x \"GNOME;KDE;\" -m firefox -g \"Office;\" -y \"text/plain;image/png;\" -k \"browser;internet;\" -Name[it] \"avvio personale\" -Comment[id] \"Buat file aplikasi startup pribadi dengan mudah\"

if you need an \" in startup file then you must use \\\"...\\\"

---------------------------------
Removing startup file
${FUNCNAME[1]} -R --Remove \"filename\"
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
ssh_key() {
	if [[ $(pgrep ssh-agent) == "" ]]; then
		eval "$(ssh-agent -s)"
	fi
	for keygen_name in "$@"; do
		file_path="$HOME/.ssh/$keygen_name"
		ssh-keygen -t ed25519 -C "$keygen_name" -f "$file_path"
		ssh-add "$file_path"
		cat "$file_path.pub"
	done
}
ssu() {
	sudo -v
	while :; do
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
