﻿#-------samba----------
#read -sp "Enter your Windows  Adminstartor password: " password
#-------samba----------
#
#
bash <(curl -L christitus.com/archtitus)
#
#
#
echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/reboot, /usr/bin/shutdown, /usr/bin/poweroff" | sudo tee -a /etc/sudoers
#
Sudo Reboot