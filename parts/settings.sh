#!/usr/bin/env bash
# Disclaimer:
# This script is provided as-is, without any warranty or guarantee.
# By using this script, you acknowledge that you do so at your own risk.
# I am not responsible for any damage, data loss, or other issues that may result from the use of this script.

declare -a Setting__=()



if [[ "$XDG_CURRENT_DESKTOP" == "X-Cinnamon" ]]; then
	if [[ -n $Setting__background_image ]];then
		Setting__background_image_total="file://$Setting__background_image"
	fi
	if [[ $Setting__first_day_of_the_weak == "sunday" ]];then
		Setting__first_day_of_the_weak="0"
	elif [[ $Setting__first_day_of_the_weak == "monday" ]];then
		Setting__first_day_of_the_weak="1"
	fi
	Setting__+=(
		"autorun:	/org/cinnamon/desktop/media-handling/autorun-never;b"
		"background_color:	/org/cinnamon/desktop/background/primary-color;'"
		"background_image_total:	/org/cinnamon/desktop/background/picture-uri;'"
		"clock__show_date:	/org/cinnamon/desktop/interface/clock-show-date;b"
		"Default_calculator:	/org/cinnamon/desktop/applications/calculator/exec;'"
		"Default_terminal:	/org/cinnamon/desktop/applications/terminal/exec;'"
		"first_day_of_the_weak:	/org/cinnamon/desktop/interface/first-day-of-week"
		"font__default:	/org/cinnamon/desktop/interface/font-name;'"
		"font__titlebar:	/org/cinnamon/desktop/wm/preferences/titlebar-font;'"
		"mouse__locate_pointer:	/org/cinnamon/desktop/peripherals/mouse/locate-pointer;b"
		"mouse__size:	/org/cinnamon/desktop/interface/cursor-size"
		"night_light__enable:	/org/cinnamon/settings-daemon/plugins/color/night-light-enabled;b"
		"night_light__schedule_from:	/org/cinnamon/settings-daemon/plugins/color/night-light-schedule-from"
		"night_light__schedule_to:	/org/cinnamon/settings-daemon/plugins/color/night-light-schedule-to"
		"night_light__schedule_mode:	/org/cinnamon/settings-daemon/plugins/color/night-light-schedule-mode;'"
		"night_light__temperature:	/org/cinnamon/settings-daemon/plugins/color/night-light-temperature;u"
		"notifications__bottom_notifications:	/org/cinnamon/desktop/notifications/bottom-notifications;b"
		"notifications__display_notifications:	/org/cinnamon/desktop/notifications/display-notifications;b"
		"notifications__fullscreen_notifications:	/org/cinnamon/desktop/notifications/fullscreen-notifications;b"
		"notifications__notification_duration:	/org/cinnamon/desktop/notifications/notification-duration"
		"notifications__remove_old:	/org/cinnamon/desktop/notifications/remove-old;b"
		"power__button__power:	/org/cinnamon/settings-daemon/plugins/power/button-power;'"
		"power__close_lid:	/org/cinnamon/settings-daemon/plugins/power/lid-close-ac-action;'"
		"power__display_sleep_ac:	/org/cinnamon/settings-daemon/plugins/power/sleep-display-ac"
		"power__display_sleep_battery:	/org/cinnamon/settings-daemon/plugins/power/sleep-display-battery"
		"power__inactive_suspend_ac:	/org/cinnamon/settings-daemon/plugins/power/sleep-inactive-ac-timeout"
		"power__inactive_suspend_battery:	/org/cinnamon/settings-daemon/plugins/power/sleep-inactive-battery-timeout"
		"privicy__dis_camera:	/org/cinnamon/desktop/privacy/disable-camera;b"
		"privicy__dis_mic:	/org/cinnamon/desktop/privacy/disable-microphone;b"
		"privicy__dis_sound:	/org/cinnamon/desktop/privacy/disable-sound-output;b"
		"privicy__old_age_files:	/org/cinnamon/desktop/privacy/old-files-age;u"
		"privicy__old_temp_files:	/org/cinnamon/desktop/privacy/remove-old-temp-files;b"
		"privicy__old_trash_files:	/org/cinnamon/desktop/privacy/remove-old-trash-files;b"
		"privicy__recent_files:	/org/cinnamon/desktop/privacy/remember-recent-files;b"
		"privicy__recent_files_age:	/org/cinnamon/desktop/privacy/recent-files-max-age"
		"sounds__login:	/org/cinnamon/sounds/login-enabled;b"
		"sounds__logout:	/org/cinnamon/sounds/logout-enabled;b"
		"sounds__inserting:	/org/cinnamon/sounds/plug-enabled;b"
		"sounds__notification:	/org/cinnamon/sounds/notification-enabled;b"
		"sounds__removing:	/org/cinnamon/sounds/unplug-enabled;b"
		"sounds__switch_workspace:	/org/cinnamon/sounds/switch-enabled;b"
		"sounds__volume_sound:	/org/cinnamon/desktop/sound/volume-sound-enabled;b"
		"sounds__window_close:	/org/cinnamon/sounds/close-enabled;b"
		"sounds__window_maximize:	/org/cinnamon/sounds/maximize-enabled;b"
		"sounds__window_minimize:	/org/cinnamon/sounds/minimize-enabled;b"
		"sounds__window_new:	/org/cinnamon/sounds/map-enabled;b"
		"sounds__window_tile_snap:	/org/cinnamon/sounds/tile-enabled;b"
		"sounds__window_unmaximize:	/org/cinnamon/sounds/unmaximize-enabled;b"
		"screensaver:	/org/cinnamon/desktop/session/idle-delay;u"
		"theme__applications:	/org/cinnamon/desktop/interface/gtk-theme;'"
		"theme__dekstop:	/org/cinnamon/theme/name;'"
		"theme__mouse:	/org/cinnamon/desktop/interface/cursor-theme;'"
	)
fi
if [[ "$XDG_CURRENT_DESKTOP" == *"GNOME"* || "$XDG_CURRENT_DESKTOP" == "X-Cinnamon" ]]; then
	Setting__+=(
		"autorun:	/org/gnome/desktop/media-handling/autorun-never;b"
		"clock__show_date:	/org/gnome/desktop/interface/clock-show-date;b"
		"font__default:	/org/gnome/desktop/interface/font-name;'"
		"font__document:	/org/gnome/desktop/interface/document-font-name;'"
		"font__explorer:	/org/nemo/desktop/font;'"
		"font__monospace:	/org/gnome/desktop/interface/monospace-font-name;'"
		"font__titlebar:	/org/gnome/desktop/wm/preferences/titlebar-font;'"
		"mouse__size:	/org/gnome/desktop/interface/cursor-size"
		"sounds__event:	/org/gnome/desktop/sound/event-sounds;b"
		"sounds__feedback:	/org/gnome/desktop/sound/input-feedback-sounds;b"
		"theme__applications:	/org/gnome/desktop/interface/gtk-theme;'"
		"theme__mouse:	/org/gnome/desktop/interface/cursor-theme;'"
	)
fi
if [[ "$(xdg-mime query default inode/directory)" == "nemo.desktop" ]];then
	if [[ "$Setting__explorer__always_open_in_a_new_window" == "0" ]];then
		Setting__explorer__new_window="1"
	elif [[ "$Setting__explorer__always_open_in_a_new_window" == "1" ]];then
		Setting__explorer__new_window="0"
	fi
	Setting__+=(
		"explorer__new_window:	/org/nemo/preferences/always-use-browser;b"
		"explorer__click:	/org/nemo/preferences/click-policy;'"
		"explorer__confirm_files_to_trash:	/org/nemo/preferences/confirm-move-to-trash;b"
		"explorer__date_format:	/org/nemo/preferences/date-format;'"
		"explorer__folder_viewer:	/org/nemo/preferences/default-folder-viewer;'"
		"explorer__show_hiden_files:	/org/nemo/preferences/show-hidden-files;b"
	)
fi
if [[ "$(xdg-mime query default inode/directory)" == "thunar.desktop" ]];then
	:
	#~/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml

fi

box_part "Updating settings"

for Setting in "${Setting__[@]}"; do
	key="${Setting%%:*}"
	value=$(echo "${Setting##*:}" | cut -d';' -f1 | sed -E 's/^[[:space:]]+//')
	type=$(echo "${Setting##*;}")
	if [[ "$type" == "b" ]]; then
		if [[ " 0 1 " == *" $(eval echo \$Setting__$key) "* ]]; then
			desired_value=$(bool "$(eval echo \${Setting__$key})")
			dcow $value "$desired_value"
		fi
	elif [ -n "$(eval echo \${Setting__$key})" ]; then
		if [[ "$type" == "u" ]]; then
			desired_value="uint32 $(eval echo \${Setting__$key})"
		elif [[ "$type" == "'" ]]; then
			desired_value="'$(eval echo \${Setting__$key})'"
		else
			desired_value="$(eval echo \${Setting__$key})"
		fi
		dcow $value "$desired_value"
	fi
done
if [[ "$XDG_CURRENT_DESKTOP" == "X-Cinnamon" ]]; then
	#favories apps menu
	
	#app list source - if variable app list is empty
	source <(curl -s -L https://raw.githubusercontent.com/TheSuperGiant/Arch/refs/heads/main/parts/app_list.sh)
	path="/org/cinnamon/favorite-apps"
	#favorite_apps=$(dconf read $path)
	#echo $favorite_apps
	for app in "${app_list[@]}"; do
		program="${app%%:*}"
		program_install_name=$(echo "${app##*:}" | sed -E 's/^[[:space:]]+//')
		order=$(eval echo \${start_munu__favorite_app__$program})
		if [[ "$order" != "0" && -n "$order" ]]; then
			favorite_order+="$order:$program_install_name|"
		elif [[ "$order" == "0" ]];then
			startmenu_add="1"
		else
			:
			#favorite_apps=$(dcod $program_install_name "$favorite_apps")
		fi
	done
	favorites=($(echo "$favorite_order" | tr '|' '\n' | sort -V))
	for i in "${favorites[@]}";do	
		echo $i
		row="${i%%:*}"
		i="${i##*:}"
		favorite[$row]="$i"
	done
	for add_favorite in ${favorite[@]};do
		add_favorites=$(dcoa "$add_favorite" "$add_favorites")
	done
	if [[ -z "$add_favorites" && $startmenu_add == "1" ]];then
		add_favorites="['']"
	elif [[ -z "$add_favorites" ]];then
		add_favorites=$(dconf read $path)
	fi
	dcow $path "$add_favorites"

	#----------------------------
	#applets
	declare -a applet__=(
		"notfication:	notifications@cinnamon.org"
		"printer:	printers@cinnamon.org"
	)
	path="/org/cinnamon/enabled-applets"
	updated_applets=$(dconf read $path)
	for applet in "${applet__[@]}"; do
		name="${applet%%:*}"
		if [ "$(eval echo \${applet__$name})" == "1" ]; then
			key=$(echo "${applet##*:}" | sed -E 's/^[[:space:]]+//')
			updated_applets=$(echo "$updated_applets" | sed "s/'[^']*$key[^']*',\?//g" | sed -E 's/\[ *,/\[/; s/, *\]/\]/')
		fi
	done
	dcow $path "$updated_applets"

	#----------------------------
	#cinnamon menu
	declare -a cinnamon_menu=(
		"on_hover__activate:	activate-on-hover;b"
	)
	CONFIG="$HOME/.config/cinnamon/spices/menu@cinnamon.org/0.json"
	for menu in "${cinnamon_menu[@]}"; do
		program_name="${menu%%:*}"
		block_name=$(echo "${menu##*:}" | cut -d';' -f1 | sed -E 's/^[[:space:]]+//')
		user_value="$(eval echo   \$Setting__menu__$program_name)"
		if [ -n "$user_value" ]; then
			type=$(echo "${menu##*;}")
			if [[ "$type" == "b" ]];then
				user_value=$(bool $(echo "${menu##*:}" | cut -d';' -f1 | sed -E 's/^[[:space:]]+//'))
			fi
			current_value=$(awk -v block="$block_name" '
				$0 ~ "\""block"\": *\\{" {flag=1}
				flag && /"value":/ {
					gsub(/[ ,]/,"",$2)
					print $2
					exit
				}
				/}/ && flag {flag=0}
			' "$CONFIG")
			if [[ "$current_value" != "$user_value" ]]; then
				sed -i "/\"$block_name\": {/,/},/ s/\"value\":[[:space:]]*$current_value/\"value\": $user_value/" "$CONFIG"
				echo "$block_name set to $user_value"
			fi
		fi
	done	
fi

if [ "$ipV6_disable" == 1 ]; then
	echo "IPv6 disabled"
	CONFIG_FILE="/etc/sysctl.d/99-disable-ipv6.conf"
	for ipV6 in "net.ipv6.conf.all.disable_ipv6 = 1" "net.ipv6.conf.default.disable_ipv6 = 1" "net.ipv6.conf.lo.disable_ipv6 = 1"; do
		if ! sudo grep -q "^$ipV6" $CONFIG_FILE; then
			echo -e "$ipV6" | sudo tee -a $CONFIG_FILE
			network_restart=1
		fi
	done
	if [ "$network_restart" == 1 ]; then 
		sudo sysctl --system
	fi
fi
