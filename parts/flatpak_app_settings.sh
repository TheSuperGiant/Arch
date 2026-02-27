box_part "Flatpak app settings"
#if [[ -n "$flatpak_app_settings" ]]; then
if [[ -n "$flatpak_app_settings" ]] && command -v flatpak >/dev/null; then
	for flat_app in "${flatpak_app_settings[@]}" ; do
		flat ${flat_app[@]}
	done
fi
