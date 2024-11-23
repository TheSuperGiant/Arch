source ~/Scripts/config/config.sh

declare -a App_Install__=(
	"wine:					wine"
	"wine_mono:				wine-mono"
	"7_zip:					7-zip-full"
	"minecraft_launcher:	minecraft-launcher;1"
	"adwaita_theme:			adwaita-icon-theme"
	
)

for app in "${App_Install__[@]}"; do
	key="${app%%:*}"
	if [ "$(eval echo \$App_Install__$key)" == "1" ]; then
		value=$(echo "${app##*:}" | tr -d '[:space:]')
		if [[ "$app" == *";"* ]]; then
			#echo 1 | paru -S --noconfirm minecraft-launcher
			#split ;
			#echo $..| paru -S --noconfirm $value
			echo "have ;"
		else
			echo "not ;"
		fi
	fi
    echo "$key"
    echo "$value"
	value=""
done