#-------samba----------
#read -sp "Enter your Windows  Adminstartor password: " password
#-------samba----------
#
#
#bash <(curl -L christitus.com/archtitus)
#
#
#
#echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/reboot, /usr/bin/shutdown, /usr/bin/poweroff" | sudo tee -a /etc/sudoers
#
for drive in /dev/sr*; do
    if [ -b "$drive" ]; then
        echo "Ejecting $drive..."
        eject "$drive"
    fi
done
#
#sudo Reboot
