#!/usr/bin/env bash
# Disclaimer:
# This script is provided as-is, without any warranty or guarantee.
# By using this script, you acknowledge that you do so at your own risk.
# I am not responsible for any damage, data loss, or other issues that may result from the use of this script.


#sudo without password
#source <(curl -s -L https://raw.githubusercontent.com/TheSuperGiant/Arch/refs/heads/main/parts/without_password_startup.sh)

#pre_2
source <(curl -s -L https://raw.githubusercontent.com/TheSuperGiant/Arch/refs/heads/main/parts/pre_2.sh)





http_check() {
	if [[ "$1" == *"http"* ]]; then
		source <(curl -s -L $1)
	else
		source $1
	fi
}

http_check $1

#if [[ "$linutil__christitus" == "1" ]]; then
	#All credits to christitus.com for creating linutil.
	#https://github.com/ChrisTitusTech/linutil
	#curl -fsSL https://christitus.com/linux | sh
#fi

#sud

#dns
source <(curl -s -L $TheSuperGiant_Arch_repo_uri__parts/dns.sh)

#special links
source <(curl -s -L $TheSuperGiant_Arch_repo_uri__parts/Special_link.sh)

#functions needs
source <(curl -s -L $TheSuperGiant_Arch_repo_uri__parts/functions_needs__list.sh)

#functions + alias adding
source <(curl -s -L $TheSuperGiant_Arch_repo_uri__parts/functions_alias_adding__Arch.sh)

#add_function mdc "sudo mkdir -p \$1
	#sudo chown \$USER:\$USER \$1"
#add_function mdsc "sudo mkdir -p \$1
	#sudo chown \$USER:\$USER \$1"
#add_function mdrc "sudo mkdir -p \$1
	#sudo chown \$USER:\$USER \$1"

#----------maby to personal--------

#Script_configfile_folder=$HOME/Scripts/config
#Script_configfile_name=config.sh
#Script_configfile_location=$Script_configfile_folder/$Script_configfile_name
#md $Script_configfile_folder
#chmod +x $Script_configfile_name
#./$Script_configfile_location

#----------maby to personal--------


if [[ "$sudo_reboot" == "1" ]]; then
	#add_sudo "$USER ALL=(ALL) NOPASSWD: /usr/bin/reboot, /usr/bin/shutdown, /usr/bin/poweroff"
	add_sudo "$SUDO_USER ALL=(ALL) NOPASSWD: /usr/bin/reboot, /usr/bin/shutdown, /usr/bin/poweroff"
fi

#add device label
source <(curl -s -L $TheSuperGiant_Arch_repo_uri__parts/add_device_label.sh)

#personal folders
source <(curl -s -L $TheSuperGiant_Arch_repo_uri__parts/personal_folders.sh)

box_part "System update"
#box_part "updating"

#function update later
sudo pacman -Syu --noconfirm

#if [[ "$App_Install__notepadPlusPlus" == "1" ]]; then
	#App_Install__wine=1
#fi

#install needs
source <(curl -s -L $TheSuperGiant_Arch_repo_uri__parts/install_needs.sh)

# if [[ "$Firewall__Default" == "1" ]]; then
	# ufw=1
	# if [[ "$firewall_Recommanded_rules" == "1" ]]; then
		# fail2ban=1
	# fi
# fi

box_part "Install AUR helper"

declare -a AUR_Helpers=(
	"paru:	base-devel rust git; par"
	"yay:	base-devel git go; yay"
)

for AUR_Helper in "${AUR_Helpers[@]}"; do
	AUR="${AUR_Helper%%:*}"
	pacman_packages=$(echo "${AUR_Helper##*:}" | cut -d';' -f1 | sed -E 's/^[[:space:]]+//')
	AUR_installer=$(echo "${AUR_Helper##*;}")
	cd ~
	if ! command -v $AUR >/dev/null; then
		box_sub "$AUR installing"
		sudo pacman -S --needed $pacman_packages --noconfirm
		rm -rf $AUR
		git clone https://aur.archlinux.org/$AUR.git
		cd ~/$AUR
		makepkg -si --noconfirm
		if command -v $AUR >/dev/null; then
			AUR_helper=$AUR_installer
			break
		fi
	else
		AUR_helper=$AUR_installer
		break
	fi
done
cd ~

box_part "Installing programs"

if [[ "$App_Install__virt_viewer" == 1 ]] && systemd-detect-virt | grep -q "kvm\|qemu"; then
	sudo pacman -S --noconfirm spice-vdagent
	sudo systemctl enable spice-vdagentd
	sudo systemctl start spice-vdagentd
fi

#aur helper/pacman install
#source <(curl -s -L https://raw.githubusercontent.com/TheSuperGiant/Arch/refs/heads/main/program_install_list.sh

#app install
source <(curl -s -L $TheSuperGiant_Arch_repo_uri__parts/app_install.sh)

#security
source <(curl -s -L $TheSuperGiant_Arch_repo_uri__parts/security.sh)

# box_part "Secutity settings"

# if [[ "$Firewall__Default" == "1" ]]; then
	# sudo ufw enable
	# if [[ "$firewall_Recommanded_rules" == "1" ]]; then
		# sudo ufw default deny incoming
		# sudo ufw default allow outgoing
		#sudo systemctl enable --now fail2ban
	# fi
# fi

#themes
if [[ "$theme__pack__Windows_10_Dark" == "1" ]]; then
	theme='Windows-10-Dark'
	git clone https://github.com/B00merang-Project/"$theme".git
	mds /usr/share/themes/
	sudo cp -r "$theme" /usr/share/themes/
fi

#Flatpak app settings
source <(curl -s -L $TheSuperGiant_Arch_repo_uri__parts/flatpak_app_settings.sh)

# box_part "Startup programs"

# declare -a App_Startup___=(
	# "audacity:	audacity Application"
	# "biglybt:	biglybt Application"
	# "brave:	brave Application"
	# "calibre:	calibre Application"
	# "discord:	discord Application"
	# "dropbox:	dropbox Application"
	# "filezilla:	filezilla Application"
	# "firefox:	firefox Application"
	# "gnome_terminal:	gnome-terminal Application"
	# "google_chrome:	google-chrome-stable  Application"
	# "handbrake:	ghb Application"
	# "heroic_launcher:	heroic Application"
	# "jitsi_meet:	jitsi-meet-desktop Application"
	# "keepass:	keepass Application"
	# "keepassxc:	keepassxc Application"
	# "leafpad:	leafpad Application"
	# "libreWolf:	LibreWolf Application"
	# "mega:	megasync Application"
	# "minecraft_launcher:	minecraft-launcher Application"
	# "mpv_Media_player:	mpv Application"
	# "mullvad_browser:	mullvad-browser Application"
	# "nautilus:	nautilus Application"
	# "nemo:	nemo Application"
	# "notepadqq:	notepadqq Application"
	# "notepadPlusPlus:	notepad++ Application"
	# "obs_studio:	obs Application"
	# "opera:	opera Application"
	# "paradox_launcher:	dowser Application"
	# "pcloud:	pcloud Application"
	# "peazip:	peazip Application"
	# "pidgin:	pidgin Application"
	# "rustdesk:	rustdesk Application"
	# "session:	/opt/Session/session-desktop Application"
	# "signal:	signal-desktop Application"
	# "smplayer:	smplayer Application"
	# "steam:	steam Application"
	# "teamviewer:	teamviewer Application"
	# "thorium:	thorium-browser Application"
	# "torbrowser:	torbrowser-launcher Application"
	# "thunderbird:	thunderbird Application"
	# "tigervnc:	vncviewer Application"
	# "virtualbox:	VirtualBox Application"
	# "visual_studio_code:	code Application"
	# "vlc:	vlc Application"
	# "vuze:	vuze Application"
	# "waterfox:	waterfox Application"
	# "wire:	wire-desktop Application"
# )

# for App_Startup in "${App_Startup___[@]}"; do
	# name_string="${App_Startup%%:*}"
	# if [[ "$(var_val App_Startup__$name_string)" == "1" ]]; then
		# application=$(echo "${App_Startup##*:}" | cut -d';' -f1 | sed -E 's/^[[:space:]]+//')
		# name_app=($application); unset name_app[-1]
		# read -ra type <<< "$application"
		# sp $name_string "${type[@]: -1}" "${name_app[@]}"
	# fi
# done

#settings
source <(curl -s -L $TheSuperGiant_Arch_repo_uri__parts/settings.sh)

#github repos
if [[ "$script_main" == 1 || "$script_startup" == 1 ]]; then
	git_repo__thesupergiant__arch=1
fi

#github updater
source <(curl -s -L $TheSuperGiant_Arch_repo_uri__parts/github_git_repo.sh)

#suders adding
source <(curl -s -L $TheSuperGiant_Arch_repo_uri__parts/sudoers_adding.sh)



#startup script download to $HOME/Scripts
#md $HOME/Scripts
#sp ... -t -d
#Exec=bash -c "nm-online -q && sleep 1 && bash <(curl -fsSL $2); exec bash"

#if [ -n "$StartScript" ]; then
	#md $HOME/Scripts
	#md ~/.config/autostart

	#startup_location="$HOME/Scripts/startup_script.sh"

	#if [ ! -f "$startup_location" ] || ! echo "$StartScript" | diff -q - "$startup_location" > /dev/null; then
		#echo -e "$StartScript" > $startup_location
	#fi
	#autostart_location="$HOME/.config/autostart/startup_script.desktop"
	#if [ ! -f $autostart_location ]; then
		#sp?
		#echo "[Desktop Entry]
#Type=Application
#Exec=sudo $startup_script_file_location
#Hidden=false
#NoDisplay=false
#X-GNOME-Autostart-enabled=true
#Name=My Startup Script
#Comment=Runs my startup script at login" > $autostart_location
	#fi

	#add_sudo "$USER ALL=(ALL) NOPASSWD: $HOME/Scripts/*"

	#chmod +x $startup_location
#fi

#------------------------------------

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
	#paru -S --noconfirm nvidia #already installing it in pre install with archtitus.

http_check $2

sudo rm -f /etc/xdg/autostart/firstboot.desktop
