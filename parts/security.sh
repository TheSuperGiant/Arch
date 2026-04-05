box_part "Secutity settings"

if [[ "$Firewall__Default" == "1" ]]; then
	sudo ufw enable
	if [[ "$firewall_Recommanded_rules" == "1" ]]; then
		sudo ufw default deny incoming
		sudo ufw default allow outgoing
		#sudo systemctl enable --now fail2ban
	fi
fi
