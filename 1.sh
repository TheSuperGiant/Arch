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
#for drive in /dev/sr*; do
    #if [ -b "$drive" ]; then
        #sudo fuser -km "$drive"
        #sudo umount -l "$drive"
        #mount | grep "$drive" | awk '{print $3}' | while read mount_point; do
            #sudo umount "$mount_point"
       # done
       # sudo umount -f "$drive"
        #echo "Ejecting $drive..."
        #echo "test 6"
       # eject -f "$drive"
    #fi
#done
#
sudo reboot
