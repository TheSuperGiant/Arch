#!/bin/bash
# Disclaimer:
# This script is provided as-is, without any warranty or guarantee.
# By using this script, you acknowledge that you do so at your own risk.
# I am not responsible for any damage, data loss, or other issues that may result from the use of this script.


sudo -v
while true; do
    sudo -n true
    sleep 60
done &

http_check() {
	if [[ "$1" == *"http"* ]]; then
		source <(curl -L $1)
	else
		source $1
	fi
}

http_check $1

if [ "$linutil__christitus" == "1" ]; then
	#All credits to christitus.com for creating linutil.
	#https://github.com/ChrisTitusTech/linutil
	curl -fsSL https://christitus.com/linux | sh
fi



#. "$HOME/.bashrc"
#while IFS= read -r line; do
    #if [[ $line == alias* ]]; then
      # eval "$line"
    #fi
#done < ~/.bashrc


LIGHTDM_CONF="/etc/lightdm/lightdm.conf"

add_alias() {
	alias_name=$1
	alias_command=$2
	if ! grep -q "^alias $alias_name" ~/.bashrc; then
		echo "alias $alias_name=\"$alias_command\"" >> ~/.bashrc
		eval "$alias_name() {
			$alias_command
		}"
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
			#mdr $mountpoint
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
		if ! grep -q "^$third" "$LIGHTDM_CONF"; then
			echo -e "\n$2" | sudo tee -a "$LIGHTDM_CONF"
		fi
	else
		if ! grep -q "^$1" "$LIGHTDM_CONF"; then
			sudo sed -i "$2 $1" "$LIGHTDM_CONF"
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
		bool=true
	else
		bool=false
	fi
}

add_alias md "mkdir -p \$1"
add_alias mds "sudo mkdir -p \$1"
add_function mdr "sudo mkdir -p \$1
	sudo chown \$USER:\$USER \$1"
#add_function mdc "sudo mkdir -p \$1
	#sudo chown \$USER:\$USER \$1"
#add_function mdsc "sudo mkdir -p \$1
	#sudo chown \$USER:\$USER \$1"
#add_function mdrc "sudo mkdir -p \$1
	#sudo chown \$USER:\$USER \$1"

sudo pacman -Syu --noconfirm

#----------maby to personal--------

#Script_configfile_folder=$HOME/Scripts/config
#Script_configfile_name=config.sh
#Script_configfile_location=$Script_configfile_folder/$Script_configfile_name
#md $Script_configfile_folder
#chmod +x $Script_configfile_name
#./$Script_configfile_location

#----------maby to personal--------


if [ "$sudo_reboot" == "1" ]; then
	add_sudo "$USER ALL=(ALL) NOPASSWD: /usr/bin/reboot, /usr/bin/shutdown, /usr/bin/poweroff"
fi

if [ -n "$StartScript" ]; then
	md $HOME/Scripts
	md ~/.config/autostart
	
	startup_location="$HOME/Scripts/startup_script.sh"
	
	if [ ! -f "$startup_location" ] || ! echo "$StartScript" | diff -q - "$startup_location" > /dev/null; then
		echo -e "$StartScript" > $startup_location
	fi
	autostart_location="$HOME/.config/autostart/startup_script.desktop"
	if [ ! -f $autostart_location ]; then
		echo "[Desktop Entry]
Type=Application
Exec=sudo $startup_script_file_location
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=My Startup Script
Comment=Runs my startup script at login" > $autostart_location
	fi

	add_sudo "$USER ALL=(ALL) NOPASSWD: $HOME/Scripts/*"

	chmod +x $startup_location
fi

if [ -n "$add_device_labels" ]; then
	for label in "${add_device_labels[@]}"; do
		add_device_label $label
	done
fi

if [[ "$numlock_startup" == "on" || "$numlock_startup" == "off" ]]; then
	add_lightdm e "[Seat:*]" "\[Seat:\*\]"
fi

if [[ "$numlock_startup" == "on" || "$numlock_startup" == "off" ]]; then
	App_Install__numlockx=1
	add_lightdm "greeter-setup-script=/usr/bin/numlockx $numlock_startup" "/^\[Seat:\*\]/a"
	echo "NumLock $numlock_startup configuration added to [Seat:*] section."
fi

declare -a App_Install__=(
	"wine:					wine"
	"wine_mono:				wine-mono"
	"7_zip:					7-zip-full"
	"adwaita_theme:			adwaita-icon-theme"
	"anydesk:				anydesk-bin"
	"audacity:				audacity"
	"biglybt:				biglybt"
	"bleachbit:				bleachbit"
	"brave:					brave"
	"calibre:				calibre"
	"discord:				discord"
	"dropbox:				dropbox"
	"filezilla:				filezilla"
	"firefox:				firefox"
	"font_dejavu:			ttf-dejavu"
	"git:					git"
	"gimp:					gimp"
	"gnome_terminal:		gnome-terminal"
	"google_chrome:			google-chrome"
	"handbrake:				handbrake"
	"heroic_launcher:		heroic-games-launcher-bin"
	"jitsi_meet:			jitsi-meet-desktop-bin"
	"keepass:				keepass"
	"libreoffice:			libreoffice"
	"librewolf:				librewolf-bin"
	"minecraft_launcher:	minecraft-launcher;1"
	"notepadqq:				notepadqq"
	"notepadPlusPlus:				notepad++"
	"numlockx:				numlockx"
	"obs_studio:			obs-studio"
	"opera:					opera"
	"paradox_launcher:		paradox-launcher"
	"pcloud:				pcloud-drive"
	"peazip:				peazip"
	"pidgin:				pidgin"
	"scrcpy:				scrcpy"
	"session:				session-desktop-bin"
	"signal:				signal-desktop-desktop-bin"
	"steam:					steam"
	"teamviewer:			teamviewer"
	"thorium:				thorium-browser-bin"
	"torbrowser:			torbrowser-launcher"
	"thunderbird:			thunderbird"
	"tigervnc:				tigervnc"
	"virtualbox:			virtualbox"
	"visual_studio_code:	visual-studio-code-bin"
	"vlc:					vlc"
	"vuze:					vuze"
	"waterfox:				waterfox-bin"
	"wire:					wire-desktop"
)

for app in "${App_Install__[@]}"; do
	key="${app%%:*}"
	#value maby a row down in the if statemant later to do with echo writing
	value=$(echo "${app##*:}" | tr -d '[:space:]')
	if [ "$(eval echo \$App_Install__$key)" == "1" ]; then
		if [[ "$app" == *";"* ]]; then
			value=$(echo "${value%%;*}" | tr -d '[:space:]')
			number=$(echo "${app##*;}")
			echo $number | paru -S --noconfirm $value
		else
			paru -S --noconfirm $value
		fi
	fi
    echo "$value"
done

if [ "$App_Install__mega" == "1" ]; then
	wget https://mega.nz/linux/repo/Arch_Extra/x86_64/megasync-x86_64.pkg.tar.zst && sudo pacman -U --noconfirm "$PWD/megasync-x86_64.pkg.tar.zst"
fi

#themes
if [ "$theme__pack__Windows_10_Dark" == "1" ]; then
	theme='Windows-10-Dark'
	git clone https://github.com/B00merang-Project/"$theme".git
	mds /usr/share/themes/
	sudo cp -r "$theme" /usr/share/themes/
fi

#Applications
if [ -n "$theme__setting__applications" ]; then
	gsettings set org.cinnamon.desktop.interface gtk-theme "$theme__setting__applications"
fi
#Desktop
if [ -n "$theme__setting__dekstop" ]; then
	dconf write /org/cinnamon/theme/name "'$theme__setting__dekstop'"
fi
#mouse pointer
if [ -n "$theme__setting__dekstop" ]; then
	gsettings set org.cinnamon.desktop.interface cursor-theme "'$theme__setting__mouse'"
fi

#clock
dconf write /org/cinnamon/desktop/interface/clock-show-date false

#Explorer
#show hidden files
if [[ "$explorer_show_hiden_files" == "0" || "$explorer_show_hiden_files" == "1" ]]; then
	#bool $explorer_show_hiden_files
	dconf write /org/nemo/preferences/show-hidden-files $(bool)
fi

# Sound settings.
#starting
dconf write /org/cinnamon/sounds/login-enabled false
#leaving
dconf write /org/cinnamon/sounds/logout-enabled false
#Switching worksapce
dconf write /org/cinnamon/sounds/switch-enabled false
#Opening new windows
dconf write /org/cinnamon/sounds/map-enabled false
#closing windows
dconf write /org/cinnamon/sounds/close-enabled false
#Minimizing windows
dconf write /org/cinnamon/sounds/minimize-enabled false
#Maximizing windows
dconf write /org/cinnamon/sounds/maximize-enabled false
#Unmaxizizing windows
dconf write /org/cinnamon/sounds/unmaximize-enabled false
#tiling and snapping windows
dconf write /org/cinnamon/sounds/tile-enabled false
#inserting device
dconf write /org/cinnamon/sounds/plug-enabled false
#Removing device
dconf write /org/cinnamon/sounds/unplug-enabled false
#Show Notifications
dconf write /org/cinnamon/sounds/notification-enabled false
#Changing the sound volume
dconf write /org/cinnamon/desktop/sound/volume-sound-enabled false
#Event sound
dconf write /org/cinnamon/desktop/sound/event-sounds false
dconf write /org/gnome/desktop/sound/event-sounds false
#Input Feedback sound
dconf write /org/gnome/desktop/sound/input-feedback-sounds false






#privicy
gsettings set org.cinnamon.desktop.privacy remember-recent-files false

#Power Management
gsettings set org.cinnamon.settings-daemon.plugins.power sleep-display-ac 600
gsettings set org.cinnamon.settings-daemon.plugins.power sleep-display-battery 600

#mouse
gsettings set org.cinnamon.desktop.interface locate-pointer true

#Screensaver
#digit in seconds
dconf write /org/cinnamon/desktop/session/idle-delay "uint32 0"

#font
font='DejaVu Sans Mono Book 13'
gsettings set org.cinnamon.desktop.interface font-name "$font"
dconf write /org/nemo/desktop/font "'$font'"
gsettings set org.gnome.desktop.interface document-font-name "$font"
gsettings set org.gnome.desktop.interface monospace-font-name "$font"
gsettings set org.cinnamon.desktop.wm.preferences titlebar-font "$font"



gsettings set org.cinnamon.desktop.interface cursor-size 36

#------------------
#numlockx #numlock on/off at startup

#games
	#indipendesies
		#wine-mono
		#dotnet-sdk
		#gnutls
		#lib32-gnutls
		#winetricks
		#winetricks corefonts vcrun2015
		#winetricks vcrun2019
		#winetricks dotnet48
		#WINEPREFIX=~/.wine64 WINEARCH=win64 winecfg
		#WINEPREFIX=~/.wine64 wine setup_vcredist_x64.exe
		#winecfg
		#?wine setup_vcredist_x64.exe?


#testing by hand
	#paru -S --noconfirm nvidia

#later
	#qemu



http_check $2

echo "test 48"

#sudo reboot