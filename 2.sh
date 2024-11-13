curl -fsSL https://christitus.com/linux | sh


sudo mkdir -p /mnt/Data
sudo mkdir -p /mnt/Games
sudo mkdir -p $HOME/Scripts
mkdir -p ~/.config/autostart

sudo chown $USER:$USER /mnt/Data
sudo chown $USER:$USER /mnt/Data
sudo chown $USER:$USER $HOME/Scripts

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

echo "$USER ALL=(ALL) NOPASSWD: $HOME/Scripts/*" | sudo tee -a /etc/sudoers

chmod +x $startup_script_file_location

for LABEL in Data Games; do
	sudo bash -c "echo \"LABEL=$LABEL /mnt/$LABEL ext4 defaults,nofail 0 2\" >> /etc/fstab"
done


echo yes | sudo pacman -S gnome-terminal

#themes
theme='Windows-10-Dark'
echo yes | sudo pacman -S git
git clone https://github.com/B00merang-Project/"$theme".git
sudo mkdir -p /usr/share/themes/
sudo cp -r "$theme" /usr/share/themes/

#Applications
gsettings set org.cinnamon.desktop.interface gtk-theme "$theme"
sudo pacman -S --noconfirm adwaita-icon-theme
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

#font
font='DejaVu Sans Mono Book 13'
echo yes | sudo pacman -S ttf-dejavu
gsettings set org.cinnamon.desktop.interface font-name "$font"
dconf write /org/nemo/desktop/font "'$font'"
gsettings set org.gnome.desktop.interface document-font-name "$font"
gsettings set org.gnome.desktop.interface monospace-font-name "$font"
gsettings set org.cinnamon.desktop.wm.preferences titlebar-font "$font"



gsettings set org.cinnamon.desktop.interface cursor-size 36

sudo pacman -Syu --noconfirm
#paru -S yay --noconfirm
#paru -S notepadqq --noconfirm
#sudo pacman -S --noconfirm wine
#paru -S notepad++ --noconfirm
#librewolf wire

#programs
#mega
wget https://mega.nz/linux/repo/Arch_Extra/x86_64/megasync-x86_64.pkg.tar.zst && sudo pacman -U --noconfirm "$PWD/megasync-x86_64.pkg.tar.zst"

#games
#?wine-mono?
echo 1 | paru -S --noconfirm minecraft-launcher
#heroic-games-launcher-bin #epicgames launcher unofficial
#paradox-launcher

#browsers
#brave
#firefox
#google-chrome
#librewolf-bin
#opera

#testing by hand
#paru -S --noconfirm nvidia


for PROGRAM in wine firefox obs-studio steam; do
	sudo pacman -S --noconfirm $PROGRAM
done

for PROGRAM in 7-zip-full anydesk-bin audacity biglybt bleachbit brave calibre discord dropbox filezilla gimp google-chrome handbrake heroic-games-launcher-bin jitsi-meet-desktop-bin keepass libreoffice librewolf-bin notepadqq notepad++ opera paradox-launcher pcloud-drive peazip pidgin scrcpy session-desktop-bin signal-desktop teamviewer vlc wire-desktop; do
	paru -S $PROGRAM --noconfirm
done

teamviewer --daemon start


echo "test 12-2"

#reboot
