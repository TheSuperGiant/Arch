echo "test 1"

curl -fsSL https://christitus.com/linux | sh

sudo mkdir /mnt/Data
sudo mkdir /mnt/Games
mkdir -p ~/.config/autostart

sudo chown $USER:$USER /mnt/Data
sudo chown $USER:$USER /mnt/Games

startup_script_file_location="$HOME/Scripts/startup_script.sh"

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


#themes
theme='Windows-10-Dark'
echo yes | sudo pacman -S git
git clone https://github.com/B00merang-Project/"$theme".git
sudo mkdir -p /usr/share/themes/
sudo cp -r "$theme" /usr/share/themes/

#these settings maby later in script
#Applications
gsettings set org.cinnamon.desktop.interface gtk-theme "$theme"
#Desktop
dconf write /org/cinnamon/theme/name "'$theme'"
#mouse pointer
gsettings set org.cinnamon.desktop.interface cursor-theme 'Adwaita'

#maby needed if it doenst take it direclty
#sudo reboot


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