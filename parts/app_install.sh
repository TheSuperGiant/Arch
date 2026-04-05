#app install list
source <(curl -s -L https://raw.githubusercontent.com/TheSuperGiant/Arch/refs/heads/main/program_install_list.sh)

for app in "${App_Install__[@]}"; do
	key="${app%%:*}"
	if [[ "$(var_val App_Install__$key)" == "1" ]]; then
		box_sub "$key"
		value=$(echo "${app##*:}" | sed -E 's/^[[:space:]]+//')
		#$function --needed --noconfirm $value <<< 1
		$AUR_helper --needed --noconfirm $value <<< 1
	fi
done
