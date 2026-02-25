box_part "Flatpak app settings"
if [[ ${s_links%% *} == "-f" ]]; then
	echo hello
	force="$s_links"
	s_links="${s_links#* }"
fi
if [[ -n "$flatpak_app_settings" ]]; then
	for flat_app in "${flatpak_app_settings[@]}" ; do
		flat ${flat_app[@]} ${force:-}
	done
fi


#if [[ ${s_links:0:1} == "-f" ]]; then
#if [[ ${s_links%% *} == "-f" ]]; then
	#echo hello
	#force="$s_links"
#fi
