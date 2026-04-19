box_part "Secutity settings"

if [[ "$Firewall__Default" == "1" ]]; then
	sudo ufw enable
	if [[ "$firewall__Recommanded_rules" == "1" ]]; then
		sudo ufw default deny incoming
		sudo ufw default allow outgoing
		#sudo systemctl enable --now fail2ban
	fi

	if [[ "$App_Install__waydroid" == "1" ]]; then
		sudo ufw allow in on waydroid0
		sudo ufw allow out on waydroid0
		#building in function later that it can add row of code in it if needed for some programs
		#sudo nano /etc/ufw/before.rules
		#under this
		# End required lines
		#-A FORWARD -i waydroid0 -o $interface_name -j ACCEPT
		#-A FORWARD -i $interface_name -o waydroid0 -m state --state ESTABLISHED,RELATED -j ACCEPT
		#sudo ufw reload #maby adding this after file eddit to automatic reload.


		#restart=1 #only needed if ufw reload does not go to add in the g_firewall function
	fi
fi
