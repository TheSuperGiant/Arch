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
		source <(curl -s -L $1)
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

function_sh="https://raw.githubusercontent.com/TheSuperGiant/Arch/refs/heads/Arch/functions.sh"


source <(curl -s -L "$function_sh" | sed 's/^alias \(.*\)="\(.*\)"$/\1() {\n  \2\n}/g')

for function in $(curl -s $function_sh | grep -oP '^\s*\K\w+(?=\()'); do
	if [ "$(eval echo \${function__$function})" == "1" ] && [[ "$(curl -s -L "$function_sh" | awk "/^$function\\(\\)/ {f=1} f; /^}/ {f=0}")" != "$(sed -n "/^$function()/,/^}/p" ~/.bashrc)" ]]; then
		echo "Updating .bashrc with the latest $function function code."
		if [[ "$(sed -n "/^$function()/,/^}/p" ~/.bashrc)" != "" ]]; then
			sed -i "/^$function()/,/^}/d" ~/.bashrc
		fi
		curl -s -L $function_sh | awk "/^$function\\(\\)/ {f=1} f; /^}/ {f=0}" >> ~/.bashrc
	fi
done

for alias in $(curl -s $function_sh | grep -oP '^\s*alias\s+\K\w+'); do
	alias_code=$(curl -s -L $function_sh | grep "^alias $alias=")
	if [ "$(eval echo \${function__$alias})" == "1" ] && [[ $alias_code != "$(sed -n "/^alias $alias=/p" ~/.bashrc)" ]]; then
		echo "Updating .bashrc with the latest $alias alias code."
		if [[ "$(sed -n "/^alias $alias=/p" ~/.bashrc)" != "" ]]; then
			sed -i "/^alias $alias=/d" ~/.bashrc
		fi
		echo $alias_code >> ~/.bashrc
	fi
done

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

if [ "$App_Install__notepadPlusPlus" == "1" ]; then
	App_Install__wine=1
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
	"keepassxc:				keepassxc"
	"leafpad:				leafpad"
	"libreoffice:			libreoffice"
	"librewolf:				librewolf-bin"
	"mega:					megasync"
	"mousepad:				mousepad"
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
	"xed:					xed"
	"game_independedies:	gamemode,mangohud"
)

for app in "${App_Install__[@]}"; do
	key="${app%%:*}"
	if [ "$(eval echo \$App_Install__$key)" == "1" ]; then
		value=$(echo "${app##*:}" | tr -d '[:space:]')
		if [[ "$app" == *";"* ]]; then
			value=$(echo "${value%%;*}" | tr -d '[:space:]')
			number=$(echo "${app##*;}")
			echo $number | paru -S --needed --noconfirm $value
		else
			paru -S --needed --noconfirm $value
		fi
	fi
done

#themes
if [ "$theme__pack__Windows_10_Dark" == "1" ]; then
	theme='Windows-10-Dark'
	git clone https://github.com/B00merang-Project/"$theme".git
	mds /usr/share/themes/
	sudo cp -r "$theme" /usr/share/themes/
fi

time_converd() {
	H=${1%%:*}; H=${H//24/0}
	M="${1##*:}" && M=$(( (M * 100) / 60 ))
	echo "$H.$M"
}
Setting__night_light__schedule_from="00:30"
if [ "$Setting__night_light__schedule_from" != "" ]; then
	Setting__night_light__schedule_from=$(time_converd $Setting__night_light__schedule_from)
fi
Setting__night_light__schedule_to="9:15"
if [ "$Setting__night_light__schedule_to" != "" ]; then
	Setting__night_light__schedule_to=$(time_converd $Setting__night_light__schedule_to)
fi

if [[ "$Setting__night_light__schedule_mode" != "" ]]; then
	if [ "$Setting__night_light__schedule_mode" == "0" ]; then
		Setting__night_light__schedule_mode="auto"
	else
		Setting__night_light__schedule_mode="manual"
	fi
fi

declare -a Setting__=(
	"clock__show_date:	/org/cinnamon/desktop/interface/clock-show-date;b"
	"clock__show_date:	/org/gnome/desktop/interface/clock-show-date;b"
	"explorer__show_hiden_files:	/org/nemo/preferences/show-hidden-files;b"
	"font__default:	/org/cinnamon/desktop/interface/font-name;'"
	"font__default:	/org/gnome/desktop/interface/font-name;'"
	"font__document:	/org/gnome/desktop/interface/document-font-name;'"
	"font__explorer:	/org/nemo/desktop/font;'"
	"font__monospace:	/org/gnome/desktop/interface/monospace-font-name;'"
	"font__titlebar:	/org/cinnamon/desktop/wm/preferences/titlebar-font;'"
	"font__titlebar:	/org/gnome/desktop/wm/preferences/titlebar-font;'"
	"mouse__locate_pointer:	/org/cinnamon/desktop/peripherals/mouse/locate-pointer;b"
	"mouse__size:	/org/cinnamon/desktop/interface/cursor-size"
	"mouse__size:	/org/gnome/desktop/interface/cursor-size"
	"night_light__enable:	/org/cinnamon/settings-daemon/plugins/color/night-light-enabled;b"
	"night_light__schedule_from:	/org/cinnamon/settings-daemon/plugins/color/night-light-schedule-from"
	"night_light__schedule_to:	/org/cinnamon/settings-daemon/plugins/color/night-light-schedule-to"
	"night_light__schedule_mode:	/org/cinnamon/settings-daemon/plugins/color/night-light-schedule-mode;'"
	"night_light__temperature:	/org/cinnamon/settings-daemon/plugins/color/night-light-temperature;u"
	"power__display_sleep_ac:	/org/cinnamon/settings-daemon/plugins/power/sleep-display-ac"
	"power__display_sleep_battery:	/org/cinnamon/settings-daemon/plugins/power/sleep-display-battery"
	"privicy__dis_camera:	/org/cinnamon/desktop/privacy/disable-camera;b"
	"privicy__dis_mic:	/org/cinnamon/desktop/privacy/disable-microphone;b"
	"privicy__dis_sound:	/org/cinnamon/desktop/privacy/disable-sound-output;b"
	"privicy__old_age_files:	/org/cinnamon/desktop/privacy/old-files-age;u"
	"privicy__old_temp_files:	/org/cinnamon/desktop/privacy/remove-old-temp-files;b"
	"privicy__old_trash_files:	/org/cinnamon/desktop/privacy/remove-old-trash-files;b"
	"privicy__recent_files:	/org/cinnamon/desktop/privacy/remember-recent-files;b"
	"privicy__recent_files_age:	/org/cinnamon/desktop/privacy/recent-files-max-age"
	"sounds__event:	/org/gnome/desktop/sound/event-sounds;b"
	"sounds__feedback:	/org/gnome/desktop/sound/input-feedback-sounds;b"
	"sounds__login:	/org/cinnamon/sounds/login-enabled;b"
	"sounds__logout:	/org/cinnamon/sounds/logout-enabled;b"
	"sounds__inserting:	/org/cinnamon/sounds/plug-enabled;b"
	"sounds__notification:	/org/cinnamon/sounds/notification-enabled;b"
	"sounds__removing:	/org/cinnamon/sounds/unplug-enabled;b"
	"sounds__switch_workspace:	/org/cinnamon/sounds/switch-enabled;b"
	"sounds__volume_sound:	/org/cinnamon/desktop/sound/volume-sound-enabled;b"
	"sounds__window_close:	/org/cinnamon/sounds/close-enabled;b"
	"sounds__window_maximize:	/org/cinnamon/sounds/maximize-enabled;b"
	"sounds__window_minimize:	/org/cinnamon/sounds/minimize-enabled;b"
	"sounds__window_new:	/org/cinnamon/sounds/map-enabled;b"
	"sounds__window_tile_snap:	/org/cinnamon/sounds/tile-enabled;b"
	"sounds__window_unmaximize:	/org/cinnamon/sounds/unmaximize-enabled;b"
	"screensaver:	/org/cinnamon/desktop/session/idle-delay;u"
	"theme__applications:	/org/cinnamon/desktop/interface/gtk-theme;'"
	"theme__applications:	/org/gnome/desktop/interface/gtk-theme;'"
	"theme__dekstop:	/org/cinnamon/theme/name;'"
	"theme__mouse:	/org/cinnamon/desktop/interface/cursor-theme;'"
	"theme__mouse:	/org/gnome/desktop/interface/cursor-theme;'"
)
	
for Setting in "${Setting__[@]}"; do
	key="${Setting%%:*}"
	value=$(echo "${Setting##*:}" | cut -d';' -f1 | tr -d '[:space:]')
	type=$(echo "${Setting##*;}")
	current_value=$(dconf read $value)
	if [[ "$type" == "b" ]]; then
		if [[ "$(eval echo \$Setting__$key)" == "0" || "$(eval echo \$Setting__$key)" == "1" ]]; then
			desired_value=$(bool "$(eval echo \${Setting__$key})")
			if [ "$current_value" != "$desired_value" ]; then
				dconf write $value $desired_value
				#echo "dconf write $value $desired_value"
			fi
		fi
	elif [ -n "$(eval echo \${Setting__$key})" ]; then
		if [[ "$type" == "u" ]]; then
			desired_value="uint32 $(eval echo \${Setting__$key})"
			if [ "$current_value" != "$desired_value" ]; then
				dconf write $value "$desired_value"
				#echo "dconf write $value $desired_value"
			fi
		elif [[ "$type" == "'" ]]; then
			desired_value="'$(eval echo \${Setting__$key})'"
			if [ "$current_value" != "$desired_value" ]; then
				dconf write $value "$desired_value"
				#echo "dconf write $value $desired_value"
			fi
		else
			desired_value="$(eval echo \${Setting__$key})"
			if [ "$current_value" != "$desired_value" ]; then
				dconf write $value "$desired_value"
				#echo "dconf write $value $desired_value"
			fi
		#echo "dconf write $value $desired_value"
		fi
	fi
done



#------------------
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

#sudo reboot