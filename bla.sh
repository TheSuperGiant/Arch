source ~/Scripts/config/config.sh

declare -a App_Install__=(
	"wine:					wine"
	"wine_mono:				wine-mono"
	"7_zip:					7-zip-full"
	"adwaita_theme:			adwaita-icon-theme"
	"minecraft_launcher:	minecraft-launcher;1"
	
)

for app in "${App_Install__[@]}"; do
	key="${app%%:*}"
	#value maby a row down in the if statemant later to do with echo writing
	value=$(echo "${app##*:}" | tr -d '[:space:]')
	if [ "$(eval echo \$App_Install__$key)" == "1" ]; then
		if [[ "$app" == *";"* ]]; then
			value=$(echo "${value%%;*}" | tr -d '[:space:]')
			number=$(echo "${app##*;}")
			echo $number | paru -S --noconfirm $value
		else
			paru -S --noconfirm $value
		fi
	fi
    echo "$key"
    echo "$value"
done