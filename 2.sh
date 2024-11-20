curl -fsSL https://christitus.com/linux | sh

LIGHTDM_CONF="/etc/lightdm/lightdm.conf"

add_alias() {
    alias_name=$1
    alias_command=$2
	if ! grep -q "^alias $alias_name" ~/.bashrc; then
		echo "alias $alias_name=\"$alias_command\"" >> ~/.bashrc
		alias "$alias_name=$alias_command"
		echo "Alias '$alias_name' added and saved to ~/.bashrc."
	fi
}
add_device_label() {
	if ! sudo grep -q "LABEL=$1" /etc/fstab; then
		sudo bash -c "echo \"LABEL=$1 /mnt/$1 ext4 defaults,nofail 0 2\" >> /etc/fstab"
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


add_alias md "mkdir -p \$1"
add_alias mds "sudo mkdir -p \$1"
add_function mdr "sudo mkdir -p \$1
	sudo chown \$USER:\$USER \$1"
#add_function mdg "sudo mkdir -p \$1
	#sudo chown \$USER:\$USER \$1"
#add_function mdsg "sudo mkdir -p \$1
	#sudo chown \$USER:\$USER \$1"
#add_function mdrg "sudo mkdir -p \$1
	#sudo chown \$USER:\$USER \$1"


sudo pacman -Syu --noconfirm

 
add_sudo "$USER ALL=(ALL) NOPASSWD: /usr/bin/reboot, /usr/bin/shutdown, /usr/bin/poweroff"

mdr /mnt/Data
mdr /mnt/Games
mdr $HOME/Scripts
mdr ~/.config/autostart

#sudo mkdir -p /mnt/Data
#sudo mkdir -p /mnt/Games
#sudo mkdir -p $HOME/Scripts
#mkdir -p ~/.config/autostart

#sudo chown $USER:$USER /mnt/Data
#sudo chown $USER:$USER /mnt/Data
#sudo chown $USER:$USER $HOME/Scripts

startup_script_file_location="$HOME/Scripts/startup_script.sh"

echo -e "" > $startup_script_file_location

echo "[Desktop Entry]
Type=Application
Exec=sudo $startup_script_file_location
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=My Startup Script
Comment=Runs my startup script at login" > ~/.config/autostart/startup_script.desktop

add_sudo "$USER ALL=(ALL) NOPASSWD: $HOME/Scripts/*"

chmod +x $startup_script_file_location

add_device_label Data
add_device_label Games

for PROGRAM in wine wine-mono 7-zip-full adwaita-icon-theme anydesk-bin audacity biglybt bleachbit brave calibre discord dropbox filezilla firefox git gimp gnome-terminal google-chrome handbrake heroic-games-launcher-bin jitsi-meet-desktop-bin keepass libreoffice librewolf-bin notepadqq notepad++ numlockx obs-studio opera paradox-launcher pcloud-drive peazip pidgin scrcpy session-desktop-bin signal-desktop steam teamviewer thorium-browser-bin torbrowser-launcher thunderbird tigervnc torbrowser-launcher ttf-dejavu virtualbox visual-studio-code-bin vlc vuze waterfox-bin wire-desktop; do
	paru -S $PROGRAM --noconfirm
done

#echo yes | sudo pacman -S gnome-terminal

#themes
theme='Windows-10-Dark'
#echo yes | sudo pacman -S git
git clone https://github.com/B00merang-Project/"$theme".git
#sudo mkdir -p /usr/share/themes/
mds /usr/share/themes/
sudo cp -r "$theme" /usr/share/themes/

#Applications
gsettings set org.cinnamon.desktop.interface gtk-theme "$theme"
#sudo pacman -S --noconfirm adwaita-icon-theme
#Desktop
dconf write /org/cinnamon/theme/name "'$theme'"
#mouse pointer
gsettings set org.cinnamon.desktop.interface cursor-theme 'Adwaita'

#clock
dconf write /org/cinnamon/desktop/interface/clock-show-date false

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
#echo yes | sudo pacman -S ttf-dejavu
gsettings set org.cinnamon.desktop.interface font-name "$font"
dconf write /org/nemo/desktop/font "'$font'"
gsettings set org.gnome.desktop.interface document-font-name "$font"
gsettings set org.gnome.desktop.interface monospace-font-name "$font"
gsettings set org.cinnamon.desktop.wm.preferences titlebar-font "$font"



gsettings set org.cinnamon.desktop.interface cursor-size 36

#paru -S yay --noconfirm
#paru -S notepadqq --noconfirm
#sudo pacman -S --noconfirm wine
#paru -S notepad++ --noconfirm
#librewolf wire

#programs
#mega
wget https://mega.nz/linux/repo/Arch_Extra/x86_64/megasync-x86_64.pkg.tar.zst && sudo pacman -U --noconfirm "$PWD/megasync-x86_64.pkg.tar.zst"



#------------------
#numlockx #numlock on/off at startup

#terminals
	#gnome-terminal

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
	#Launchers
	echo 1 | paru -S --noconfirm minecraft-launcher
	#heroic-games-launcher-bin #epicgames launcher unofficial
	#paradox-launcher

#browsers
	#brave
	#firefox
	#google-chrome
	#librewolf-bin
	#opera
	#thorium-browser-bin
	#torbrowser-launcher
	#waterfox-bin

#Themes
	#adwaita-icon-theme
	#Windows-10-Dark

#testing by hand
	#paru -S --noconfirm nvidia

#later
	#qemu

#for PROGRAM in wine firefox obs-studio steam thunderbird tigervnc torbrowser-launcher; do
	#sudo pacman -S --noconfirm $PROGRAM
#done



add_lightdm e "[Seat:*]" "\[Seat:\*\]"

#numlock on at startup
#numlockx
add_lightdm "greeter-setup-script=/usr/bin/numlockx on" "/^\[Seat:\*\]/a"
echo "NumLock on configuration added to [Seat:*] section."
#numlock on at startup

echo "test 13"

#sudo reboot