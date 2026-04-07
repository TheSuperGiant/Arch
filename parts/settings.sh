#!/usr/bin/env bash
# Disclaimer:
# This script is provided as-is, without any warranty or guarantee.
# By using this script, you acknowledge that you do so at your own risk.
# I am not responsible for any damage, data loss, or other issues that may result from the use of this script.

declare -a Setting__=()



if [[ "$XDG_CURRENT_DESKTOP" == "X-Cinnamon" ]]; then
	time_converd() {
		H=${1%%:*}; H=${H//24/0}
		M="${1##*:}" && M=$(( (M * 100) / 60 ))
		echo "$H.$M"
	}
	if [[ "$Setting__autorun" == "0" ]]; then
		Setting__autorun=1
	elif [[ "$Setting__autorun" == "1" ]]; then
		Setting__autorun=0
	fi
	if [[ $Setting__background_color_type == "none" ]]; then
		Setting__background_color_type="solid"
	fi
	if [[ $Setting__background_image == "none" ]]; then
		Setting__background_options="none"
		Setting__background_image_total="-r"
	elif [[ -n $Setting__background_image ]]; then
		Setting__background_image_total="file:///${Setting__background_image// /%20}"
	fi
	if [[ $Setting__first_day_of_the_weak == "sunday" ]]; then
		Setting__first_day_of_the_weak="0"
	elif [[ $Setting__first_day_of_the_weak == "monday" ]]; then
		Setting__first_day_of_the_weak="1"
	fi
	if [[ "$Setting__night_light__schedule_from" != "" ]]; then
		Setting__night_light__schedule_from=$(time_converd $Setting__night_light__schedule_from)
	fi
	if [[ "$Setting__night_light__schedule_to" != "" ]]; then
		Setting__night_light__schedule_to=$(time_converd $Setting__night_light__schedule_to)
	fi
	#if [[ "$Setting__night_light__schedule_mode=0" != "" ]]; then
	if [[ "$Setting__night_light__schedule_mode" != "" ]]; then
		if [[ "$Setting__night_light__schedule_mode" == "1" ]]; then
			Setting__night_light__schedule_mode="manual"
		else
			Setting__night_light__schedule_mode="auto"
		fi
	fi
	Setting__+=(
		"autorun:	/org/cinnamon/desktop/media-handling/autorun-never;b"
		"background_color:	/org/cinnamon/desktop/background/primary-color;'"
		"background_color_type:	/org/cinnamon/desktop/background/color-shading-type;'"
		"background_image_total:	/org/cinnamon/desktop/background/picture-uri;'"
		"background_options:	/org/cinnamon/desktop/background/picture-options;'"
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
		"font__monospace:	/org/gnome/desktop/interface/monospace-font-name;'"
		"font__titlebar:	/org/gnome/desktop/wm/preferences/titlebar-font;'"
		"mouse__size:	/org/gnome/desktop/interface/cursor-size"
		"sounds__event:	/org/gnome/desktop/sound/event-sounds;b"
		"sounds__feedback:	/org/gnome/desktop/sound/input-feedback-sounds;b"
		"theme__applications:	/org/gnome/desktop/interface/gtk-theme;'"
		"theme__mouse:	/org/gnome/desktop/interface/cursor-theme;'"
	)
fi
if [[ "$(xdg-mime query default inode/directory)" == "nemo.desktop" ]]; then
	if [[ "$Setting__explorer__always_open_in_a_new_window" == "0" ]]; then
		Setting__explorer__new_window="1"
	elif [[ "$Setting__explorer__always_open_in_a_new_window" == "1" ]]; then
		Setting__explorer__new_window="0"
	fi
	Setting__+=(
		"explorer__new_window:	/org/nemo/preferences/always-use-browser;b"
		"explorer__click:	/org/nemo/preferences/click-policy;'"
		"explorer__confirm_files_to_trash:	/org/nemo/preferences/confirm-move-to-trash;b"
		"explorer__date_format:	/org/nemo/preferences/date-format;'"
		"explorer__folder_viewer:	/org/nemo/preferences/default-folder-viewer;'"
		"explorer__show_hiden_files:	/org/nemo/preferences/show-hidden-files;b"
		"font__explorer:	/org/nemo/desktop/font;'"
	)
fi
if [[ "$(xdg-mime query default inode/directory)" == "thunar.desktop" ]]; then
	:
	#~/.config/xfce4/xfconf/xfce-perchannel-xml/thunar.xml

fi

box_part "Updating settings"

for Setting in "${Setting__[@]}"; do
	key="${Setting%%:*}"
	value=$(echo "${Setting##*:}" | cut -d';' -f1 | sed -E 's/^[[:space:]]+//')
	desired_value="$(var_val Setting__$key)"
	if [[ "$desired_value" == "-r" ]]; then
		dcor $value
		continue
	fi
	type=$(echo "${Setting##*;}")
	if [[ "$type" == "b" ]]; then
		if [[ " 0 1 " == *" $(var_val Setting__$key) "* ]]; then
			desired_value=$(bool "$desired_value")
			dcow $value "$desired_value"
		fi
	elif [[ -n "$desired_value" ]]; then
		if [[ "$type" == "u" ]]; then
			desired_value="uint32 $desired_value"
		elif [[ "$type" == "'" ]]; then
			desired_value="'$desired_value'"
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
		order=$(var_val start_munu__favorite_app__$program)
		if [[ "$order" != "0" && -n "$order" ]]; then
			favorite_order+="$order:$program_install_name|"
		elif [[ "$order" == "0" ]]; then
			startmenu_add="1"
		else
			:
			#favorite_apps=$(dcod $program_install_name "$favorite_apps")
		fi
	done
	favorites=($(echo "$favorite_order" | tr '|' '\n' | sort -V))
	for i in "${favorites[@]}"; do
		echo $i
		row="${i%%:*}"
		i="${i##*:}"
		favorite[$row]="$i"
	done
	for add_favorite in ${favorite[@]}; do
		add_favorites=$(dcoa "$add_favorite" "$add_favorites")
	done
	if [[ -z "$add_favorites" && $startmenu_add == "1" ]]; then
		add_favorites="['']"
	elif [[ -z "$add_favorites" ]]; then
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
		if [[ "$(var_val applet__$name)" == "1" ]]; then
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
		user_value="$(var_val Setting__menu__$program_name)"
		if [[ -n "$user_value" ]]; then
			type=$(echo "${menu##*;}")
			if [[ "$type" == "b" ]]; then
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

if [[ "$Setting__audio__hdmi_dp" =~ ^(0|1)$ ]]; then
	box_sub "audio - hdmi dp - toggle"
	unset audio__toggle
	while read -r num name; do
		if ( [[ "$Setting__audio__hdmi_dp" == "0" ]] && [[ "$num" == "GPU" ]] ) || ( [[ "$Setting__audio__hdmi_dp" == "1" ]] && [[ "$num" == "motherboard" ]] ); then
			audio__toggle+="0,"
		else
			audio__toggle+="1,"
		fi
	done < <(awk -F'[][]' '
		/\[/{
			split($3,a," - ")
			gsub(/^: /,"",a[1])
			sub(/-.*/,"",a[1])

			if (a[1] == "HDA") {
				if ($2 ~ /NVidia|AMD|Intel/)
					print "GPU audio :" $1 " (" $2 ")"
				else
					print "motherboard audio :" $1 " (" $2 ")"
			}
		}' /proc/asound/cards)
	if [[ -n "$audio__toggle" ]]; then
		audio__toggle="${audio__toggle%,*}"
		hda_intel="options snd_hda_intel enable="
		audio__toggle="${hda_intel}${audio__toggle}"
		update_row "$audio__toggle" "$audio__toggle" "${filtered%%=*}" "/etc/modprobe.d/no-hdmi-audio.conf"; [[ $? -eq 1 ]] && restart=1
	fi
fi

if [[ "$numlock_startup" =~ ^(on|off)$ ]]; then
	box_sub "numlock startup"
	if [[ "$display_manager" == "lightdm" ]]; then
		add_lightdm e "[Seat:*]" "\[Seat:\*\]"
		add_lightdm "greeter-setup-script=/usr/bin/numlockx $numlock_startup" "/^\[Seat:\*\]/a" && echo "NumLock $numlock_startup configuration added to [Seat:*] section."
	fi
fi

if [[ "$IPv6_hardening" == 1 ]]; then
	CONFIG_FILE="/etc/sysctl.d/99-ipv6-privacy.conf"
	adding() {
		update_row "$1" "$2" "${1%% *}" "$CONFIG_FILE"
		if ! grep -q "^$2" "$CONFIG_FILE"; then
			network_restart=1
		fi
	}
	box_sub "IPv6 hardening"
	for ipV6 in "net.ipv6.conf.all.use_tempaddr = 2" "net.ipv6.conf.default.use_tempaddr = 2"; do
		adding "$ipV6" "$ipV6"
	done
	for iface in /sys/class/net/*; do
		if [[ -d "$iface/device" ]]; then
			secret=$(openssl rand -hex 16 | sed 's/\(....\)/\1:/g;s/:$//')
			iface_txt=net.ipv6.conf.${iface##*/}.stable_secret
			adding "$iface_txt = $secret" "$iface_txt"
		fi
	done
	if [[ "$network_restart" == 1 ]]; then
		sudo sysctl --system > /dev/null
		echo "IPv6 hardening added"
	fi
fi

box_part "services boot toggle"
declare -a service_boot_toggle___=(
	"bluetooth:	bluetooth"
	"rustdesk:	rustdesk"
)

for service_boot_toggle in "${service_boot_toggle___[@]}"; do
	name_string="${service_boot_toggle%%:*}"
	#echo "$name_string" #temp
	value="$(var_val service_boot_toggle__$name_string)"
	if [[ "$value" =~ ^(0|1)$ ]]; then
		box_sub "$service"
		service_toggle "$(echo "${service_boot_toggle##*:}" | cut -d';' -f1 | sed -E 's/^[[:space:]]+//')" "$value"
		#service=$(echo "${service_boot_toggle##*:}" | cut -d';' -f1 | sed -E 's/^[[:space:]]+//')
		#printf '%s\n' "$service" #temp
		#name_app=($application); unset name_app[-1]
		#read -ra type <<< "$application"
		#sp $name_string "${type[@]: -1}" "${name_app[@]}"
	fi
done

#if [[ "$app_service_startup__rustdesk" =~ ^(0|1)$ ]]; then
	#box_sub "rustdesk"
	#service_toggle "rustdesk" "$app_service_startup__rustdesk"
#fi

box_part "Startup programs"
if [[ -n "$XDG_CURRENT_DESKTOP" ]]; then
	declare -a App_Startup___=(
		"audacity:	audacity Application"
		"biglybt:	biglybt Application"
		"brave:	brave Application"
		"calibre:	calibre Application"
		"discord:	discord Application"
		"dropbox:	dropbox Application"
		"filezilla:	filezilla Application"
		"firefox:	firefox Application"
		"gnome_terminal:	gnome-terminal Application"
		"google_chrome:	google-chrome-stable  Application"
		"handbrake:	ghb Application"
		"heroic_launcher:	heroic Application"
		"jitsi_meet:	jitsi-meet-desktop Application"
		"keepass:	keepass Application"
		"keepassxc:	keepassxc Application"
		"leafpad:	leafpad Application"
		"libreWolf:	LibreWolf Application"
		"mega:	megasync Application"
		"minecraft_launcher:	minecraft-launcher Application"
		"mpv_Media_player:	mpv Application"
		"mullvad_browser:	mullvad-browser Application"
		"nautilus:	nautilus Application"
		"nemo:	nemo Application"
		"notepadqq:	notepadqq Application"
		"notepadPlusPlus:	notepad++ Application"
		"obs_studio:	obs Application"
		"opera:	opera Application"
		"paradox_launcher:	dowser Application"
		"pcloud:	pcloud Application"
		"peazip:	peazip Application"
		"pidgin:	pidgin Application"
		"rustdesk:	rustdesk Application"
		"session:	/opt/Session/session-desktop Application"
		"signal:	signal-desktop Application"
		"smplayer:	smplayer Application"
		"steam:	steam Application"
		"teamviewer:	teamviewer Application"
		"thorium:	thorium-browser Application"
		"torbrowser:	torbrowser-launcher Application"
		"thunderbird:	thunderbird Application"
		"tigervnc:	vncviewer Application"
		"virtualbox:	VirtualBox Application"
		"visual_studio_code:	code Application"
		"vlc:	vlc Application"
		"vuze:	vuze Application"
		"waterfox:	waterfox Application"
		"wire:	wire-desktop Application"
	)

	for App_Startup in "${App_Startup___[@]}"; do
		name_string="${App_Startup%%:*}"
		if [[ "$(var_val App_Startup__$name_string)" == "1" ]]; then
			application=$(echo "${App_Startup##*:}" | cut -d';' -f1 | sed -E 's/^[[:space:]]+//')
			name_app=($application); unset name_app[-1]
			read -ra type <<< "$application"
			sp $name_string "${type[@]: -1}" "${name_app[@]}"
		fi
	done
fi

box_part "Updating default program"
if command -v xdg-open; then
	default_app () {
		if [[ "$1" == $(ls /usr/share/applications/ | grep -i $1) ]] && ! [[ "$1" == $(xdg-mime query default "$2") ]]; then
			xdg-mime default "$1" "$2"
			echo "${1%%.desktop} ${2##*/} - Updated to the default program"
		else
			echo "${1%%.desktop} ${2##*/} - Already set as the default program"
		fi
		echo "------------------------------------"
	}

	declare -a Default_Apps=(
		"biglybt:				biglybt.desktop"
		"brave:					brave-browser.desktop"
		"calibre:				calibre-ebook-viewer.desktop"
		"eye_of_gnome:				org.gnome.eog.desktop"
		"firefox:				firefox.desktop"
		"google_chrome:			google-chrome.desktop"
		"keepass:				keepass.desktop"
		"keepassxc:				org.keepassxc.KeePassXC.desktop"
		"leafpad:				leafpad.desktop"
		"libreoffice_database:			libreoffice-base.desktop"
		"libreoffice_graphics:			libreoffice-draw.desktop"
		"libreoffice_math:			libreoffice-math.desktop"
		"libreoffice_presentation:			libreoffice-impress.desktop"
		"libreoffice_spreadsheet:			libreoffice-calc.desktop"
		"libreoffice_word:			libreoffice-writer.desktop"
		"librewolf:				librewolf.desktop"
		"mousepad:					org.xfce.mousepad.desktop"
		"mpv_Media_player:					mpv.desktop"
		"nautilus:					org.gnome.Nautilus.desktop"
		"nemo:					nemo.desktop"
		"nomacs:				org.nomacs.ImageLounge.desktop"
		"notepadqq:				notepadqq.desktop"
		"notepad++:		notepad++.desktop"
		"opera:					opera.desktop"
		"peazip:				peazip.desktop"
		"smplayer:				smplayer.desktop"
		"thorium:				thorium-browser.desktop"
		"torbrowser:			torbrowser-launcher"
		"thunderbird:			org.mozilla.Thunderbird.desktop"
		##"virtualbox:			virtualbox.desktop"
		#"visual_studio_code:	visual-studio-code-bin"
		"vlc:					vlc.desktop"
		"vuze:					vuze.desktop"
		"waterfox:				waterfox.desktop"
		"wire:					wire-desktop.desktop"
	)

	declare -a Default_category=(
		"Default_archive:		application"
		"Default_browser:	x-scheme-handler/http x-scheme-handler/https"
		"Default_e_books:		application"
		"Default_file_manager:		inode/directory"
		"Default_mail:		x-scheme-handler/mailto"
		"Default_multimedia_audio:		audio"
		"Default_multimedia_video:		video"
		"Default_multimedia_image:		image"
		"Default_office_database:		application"
		"Default_office_graphics:		application"
		"Default_office_math:		application"
		"Default_office_presentation:		application"
		"Default_office_spreadsheet"
		"Default_office_word:		application"
		"Default_pdf:		application/pdf application/x-pdf"
		"Default_scripts:		text/javascript text/xml text/x-python text/x-c text/x-c++ text/x-java text/x-shellscript text/x-php text/x-perl text/x-ruby text/x-lua text/x-markdown text/x-yaml text/x-toml text/x-sql text/x-asm text/x-csharp text/x-go text/x-rust text/x-d text/x-swift text/x-kotlin text/x-scala text/x-haskell text/x-erlang text/x-elisp text/x-lisp text/x-clojure text/x-scheme text/x-ocaml text/x-vbscript text/x-pascal text/x-fortran text/x-r"
		"Default_text_files:		text/plain"
		"Default_torrent:		application/x-bittorrent"
		"Default_web_edditor:		text/html text/css"
	)

	declare -a Default_archive=(
		"peazip:	x-7z-compressed x-zip-compressed x-rar-compressed x-tar x-gzip x-bzip2 x-xz x-lzma x-ace-compressed x-arj x-lha x-tar+gzip x-tar+bzip2 x-tar+xz x-iso9660-image x-cpio x-lz4 x-zip x-rar x-bzip x-bz2"
	)

	declare -a Default_browser=(
		"brave"
		"firefox"
		"google_chrome"
		"librewolf"
		"opera"
		"thorium"
		"torbrowser"
		"waterfox"
	)

	declare -a Default_e_books=(
		"calibre:	epub+zip x-mobipocket-ebook x-msbook x-fictionbook+xml x-sony-bbeb x-azw3 x-kobo-book x-chm x-html x-plain-text x-lrf"
	)

	declare -a Default_file_manager=(
		"nautilus"
		"nemo"
	)

	declare -a Default_mail=(
		"brave"
		"firefox"
		"google_chrome"
		"librewolf"
		"opera"
		"thorium"
		"thunderbird"
		"torbrowser"
		"waterfox"
	)

	declare -a Default_multimedia_audio=(
		"smplayer:	wav mpeg aac x-ms-wma flac alac mp4 ogg opus x-ape midi x-midi x-matroska"
		"mpv_Media_player:	wav mpeg aac x-ms-wma flac alac mp4 ogg opus x-ape midi x-midi x-matroska x-vorbis basic vnd.wave"
		"vlc:	wav mpeg aac x-ms-wma flac alac mp4 ogg opus x-ape midi x-midi x-matroska x-vorbis basic vnd.wave 3gpp 3gpp2 x-mod x-s3m x-it x-xm"
	)

	declare -a Default_multimedia_video=(
		"smplayer:	avi flv mp4 mpeg quicktime vnd.rn-realvideo webm x-matroska x-ms-asf x-ms-wmv x-msvideo x-ogm+ogg x-theora 3gp 3gpp divx mp4v-es msvideo ogg vivo vnd.divx x-anim x-avi x-flc x-fli x-flic x-flv x-m4v x-mng x-mpeg x-mpeg2 x-ms-afs x-ms-asx x-ms-wm x-ms-wvx x-ms-wvxvideo x-nsv x-theora+ogg"
		"mpv_Media_player:	avi flv mp4 mpeg quicktime vnd.rn-realvideo webm x-matroska x-ms-asf x-ms-wmv x-msvideo x-ogm+ogg x-theora 3gpp divx mp4v-es msvideo ogg vivo vnd.divx x-anim x-avi x-flc x-fli x-flic x-flv x-m4v x-mng x-mpeg x-mpeg2 x-ms-afs x-ms-asx x-ms-wm x-ms-wvx x-ms-wvxvideo x-nsv x-theora+ogg 3gpp2 dv fli mkv mp2t vnd.avi vnd.mpegurl x-mpeg3 x-ms-wmx x-ogm"
		"vlc:	avi flv mp4 mpeg quicktime vnd.rn-realvideo webm x-matroska x-ms-asf x-ms-wmv x-msvideo x-ogm+ogg x-theora 3gp 3gpp divx mp4v-es msvideo ogg vivo vnd.divx x-anim x-avi x-flc x-fli x-flic x-flv x-m4v x-mng x-mpeg x-mpeg2 x-ms-afs x-ms-asx x-ms-wm x-ms-wvx x-ms-wvxvideo x-nsv x-theora+ogg 3gpp2 dv fli mp2t vnd.mpegurl x-ms-wmx x-ogm mpeg-system x-mpeg-system x-ms-asf-plugin"
	)

	declare -a Default_multimedia_image=(
		"eye_of_gnome:	bmp gif jpeg jxl png tiff webp x-ico x-portable-bitmap x-portable-graymap x-portable-pixmap x-xbitmap x-xpixmap jpg pjpeg svg+xml svg+xml-compressed vnd.wap.wbmp x-bmp x-gray x-icb x-icns x-pcx x-png x-portable-anymap "
		"nomacs:	avif bmp gif heic heif jpeg jxl png tiff webp x-eps x-ico x-portable-bitmap x-portable-graymap x-portable-pixmap x-xbitmap x-xpixmap"
	)

	declare -a Default_office_database=(
		"libreoffice_database:	vnd.oasis.opendocument.database x-sql vnd.ms-access vnd.ms-access.accdb x-dbase x-dbf vnd.ms-office x-msaccess mdb"
	)

	declare -a Default_office_graphics=(
		"libreoffice_graphics:	vnd.oasis.opendocument.graphics vnd.oasis.opendocument.graphics-template vnd.oasis.opendocument.graphics-flat-xml vnd.sun.xml.draw vnd.sun.xml.draw.template vnd.stardivision.draw vnd.openxmlformats-officedocument.drawingml.diagram+xml vnd.visio vnd.visio2013 x-coreldraw x-coreldrawtemplate x-coreldrawpattern x-coreldrawpresentation x-fig"
	)

	declare -a Default_office_math=(
		"libreoffice_math:	vnd.oasis.opendocument.formula vnd.oasis.opendocument.formula-template vnd.sun.xml.math x-tex x-latex x-texinfo x-troff x-dvi"
	)

	declare -a Default_office_presentation=(
		"libreoffice_presentation:	vnd.oasis.opendocument.presentation vnd.oasis.opendocument.presentation-template vnd.openxmlformats-officedocument.presentationml.presentation vnd.openxmlformats-officedocument.presentationml.template vnd.ms-powerpoint vnd.ms-powerpoint.presentation.macroEnabled.12 vnd.ms-powerpoint.template.macroEnabled.12 vnd.ms-powerpoint.addin.macroEnabled.12 vnd.ms-powerpoint.slideshow.macroEnabled.12 vnd.sun.xml.impress vnd.sun.xml.impress.template vnd.stardivision.impress vnd.ms-powerpoint.slideshow.macroEnabled.12 x-iwork-keynote-sffkey vnd.apple.keynote"
	)

	declare -a Default_office_spreadsheet=(
		"libreoffice_spreadsheet:	application/vnd.oasis.opendocument.spreadsheet application/vnd.oasis.opendocument.spreadsheet-template application/vnd.ms-excel application/vnd.openxmlformats-officedocument.spreadsheetml.sheet application/vnd.ms-excel.sheet.macroEnabled.12 application/vnd.ms-excel.template.macroEnabled.12 application/vnd.ms-excel.addin.macroEnabled.12 application/vnd.ms-excel.sheet.binary.macroEnabled.12 text/csv text/tab-separated-values application/vnd.lotus-1-2-3 application/vnd.stardivision.calc application/vnd.sun.xml.calc application/vnd.sun.xml.calc.template application/x-dbase application/x-dbf application/x-dos_ms_excel application/x-excel application/x-xls application/x-msexcel application/x-quattro-pro application/x-sylk text/spreadsheet application/vnd.gnumeric application/x-gnumeric application/x-spreadsheet application/vnd.openxmlformats-officedocument.spreadsheetml.template"
	)

	declare -a Default_office_word=(
		"libreoffice_word:	msword rtf vnd.ms-works vnd.oasis.opendocument.text vnd.oasis.opendocument.text-template vnd.openxmlformats-officedocument.wordprocessingml.document vnd.stardivision.writer vnd.wordperfect x-abiword"
	)

	declare -a Default_pdf=(
		"brave"
		"firefox"
		"google_chrome"
		"librewolf"
		"opera"
		"thorium"
		"torbrowser"
		"waterfox"
	)

	declare -a Default_scripts=(
		"notepad++"
		"notepadqq"
	)

	declare -a Default_text_files=(
		"leafpad"
		"mousepad"
	)

	declare -a Default_torrent=(
		"biglybt"
		"vuze"
	)

	declare -a Default_web_edditor=(
		""
	)

	for default in "${Default_category[@]}"; do
		category="${default%%:*}"
		category_verb="${category}__app"
		default_app=${!category_verb}; default_app="${default_app,,}"
		if [[ -n "$default_app" ]]; then
			program_install_name=$(printf "%s\n" "${Default_Apps[@]}" | grep "^$default_app:" | awk -F: '{print $2}' | sed -E 's/^[[:space:]]+//')
			file_association_type=$(echo "${default##*:}" | sed -E 's/^[[:space:]]+//')
			if [[ "$file_association_type" == */* ]]; then
				for asso in $file_association_type; do
					if [[ -n $(declare -n list="$category"; printf "%s\n" "${list[@]}" | grep -x "^$default_app") ]]; then
						default_app "$program_install_name" "$asso"
					fi
				done
			else
				catergory_scheme=$(echo "${default##*:}" | sed -E 's/^[[:space:]]+//')
				for asso in $(declare -n list="$category"; printf "%s\n" "${list[@]}" | grep "^$default_app:" | awk -F: '{print $2}' | sed -E 's/^[[:space:]]+//'); do
					if [[ "$catergory_scheme" == "$default" ]]; then
						default_app "$program_install_name" "$asso"
					else
						default_app "$program_install_name" "$catergory_scheme/$asso"
					fi
				done
			fi
		fi
	done
fi

#if [[ "$network_check_on_boot" == 1 ]]; then
	#sudo systemctl disable NetworkManager-wait-online.service
	#sudo systemctl mask NetworkManager-wait-online.service
#fi
