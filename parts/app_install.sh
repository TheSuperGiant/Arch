#app install list
# source <(curl -s -L https://raw.githubusercontent.com/TheSuperGiant/Arch/refs/heads/main/program_install_list.sh)

#set the ini file in an variable.
app_install_list="$(curl -s -L https://raw.githubusercontent.com/TheSuperGiant/Arch/refs/heads/main/program_install_list.ini)"

# for app in "${App_Install__[@]}"; do
	# key="${app%%:*}"
	# if [[ "$(var_val App_Install__$key)" == "1" ]]; then
		# box_sub "$key"
		# value=$(echo "${app##*:}" | sed -E 's/^[[:space:]]+//')
		# $AUR_helper --needed --noconfirm $value <<< 1
	# fi
# done
