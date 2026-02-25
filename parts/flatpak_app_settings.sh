box_part "Flatpak app settings"
if [[ -n "$Flatpak_app_settings" ]]; then
	for flat_app in "$Flatpak_app_settings" ; do
		flat ${flat_app[@]}
	done
fi
