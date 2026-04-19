if [[ "$Firewall__Default" == "1" ]]; then
	App_Install__ufw=1
	if [[ "$firewall_Recommanded_rules" == "1" ]]; then
		App_Install__fail2ban=1
	fi
fi
if [[ "$numlock_startup" =~ ^(on|off)$ ]]; then
	App_Install__numlockx=1
fi

declare -a install_need+=(
	"App_Install__flatpak:	flathub"
)