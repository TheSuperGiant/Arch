#!/usr/bin/env bash
# Disclaimer:
# This script is provided as-is, without any warranty or guarantee.
# By using this script, you acknowledge that you do so at your own risk.
# I am not responsible for any damage, data loss, or other issues that may result from the use of this script.

#sudo without password
source <(curl -s -L https://raw.githubusercontent.com/TheSuperGiant/Arch/refs/heads/main/parts/without_password_startup.sh)

#variable
source <(curl -s -L https://raw.githubusercontent.com/TheSuperGiant/Arch/refs/heads/main/parts/variable.sh)





http_check() {
	if [[ "$1" == *"http"* ]]; then
		source <(curl -s -L $1)
	else
		source $1
	fi
}

http_check $1

if [[ "$linutil__christitus" == "1" ]]; then
	#All credits to christitus.com for creating linutil.
	#https://github.com/ChrisTitusTech/linutil
	curl -fsSL https://christitus.com/linux | sh
fi

function_sh=$(curl -s https://raw.githubusercontent.com/TheSuperGiant/Arch/refs/heads/main/functions.sh)

while IFS= read -r line; do
	if [[ "$line" == alias* ]]; then
		alias=$(echo "$line" | cut -d' ' -f2 | cut -d'=' -f1)
		unalias -a "$alias"
	fi
done < <(echo "$function_sh")
source <(echo "$function_sh" | sed -E '/^alias / s/\\"/"/g' | sed -E 's/^alias ([^=]+)=["](.*)["]$/\1() {\n  \2\n}/')

ssu

#special links
source <(curl -s -L https://raw.githubusercontent.com/TheSuperGiant/Arch/refs/heads/main/parts/dns.sh)

#special links
source <(curl -s -L https://raw.githubusercontent.com/TheSuperGiant/Arch/refs/heads/main/parts/Special_link.sh)

#functions needs
source <(curl -s -L https://raw.githubusercontent.com/TheSuperGiant/Arch/refs/heads/main/parts/functions_needs__list.sh)

#functions + alias adding
source <(curl -s -L https://raw.githubusercontent.com/TheSuperGiant/Arch/refs/heads/main/parts/functions_alias_adding.sh)
for function in $(functi "$function_sh"); do
	function_adding "$function" "$function_sh"
done

for alias in $(aliasi "$function_sh"); do
	alias_adding "$alias" "$function_sh"
done

#add_function mdc "sudo mkdir -p \$1
	#sudo chown \$USER:\$USER \$1"
#add_function mdsc "sudo mkdir -p \$1
	#sudo chown \$USER:\$USER \$1"
#add_function mdrc "sudo mkdir -p \$1
	#sudo chown \$USER:\$USER \$1"

#----------maby to personal--------

#Script_configfile_folder=$HOME/Scripts/config
#Script_configfile_name=config.sh
#Script_configfile_location=$Script_configfile_folder/$Script_configfile_name
#md $Script_configfile_folder
#chmod +x $Script_configfile_name
#./$Script_configfile_location

#----------maby to personal--------


if [[ "$sudo_reboot" == "1" ]]; then
	add_sudo "$USER ALL=(ALL) NOPASSWD: /usr/bin/reboot, /usr/bin/shutdown, /usr/bin/poweroff"
fi

#add_device_label
source <(curl -s -L https://raw.githubusercontent.com/TheSuperGiant/Arch/refs/heads/main/parts/add_device_label.sh)

#personal folders
source <(curl -s -L https://raw.githubusercontent.com/TheSuperGiant/Arch/refs/heads/main/parts/personal_folders.sh)

box_part "System update"
#box_part "updating"

#function update later
sudo pacman -Syu --noconfirm

if [[ "$numlock_startup" == "on" || "$numlock_startup" == "off" ]]; then
	App_Install__numlockx=1
	add_lightdm e "[Seat:*]" "\[Seat:\*\]"
	add_lightdm "greeter-setup-script=/usr/bin/numlockx $numlock_startup" "/^\[Seat:\*\]/a"
	echo "NumLock $numlock_startup configuration added to [Seat:*] section."
fi

if [[ "$App_Install__notepadPlusPlus" == "1" ]]; then
	App_Install__wine=1
fi

if [[ "$Firewall__Default" == "1" ]]; then
	ufw=1
	if [[ "$firewall_Recommanded_rules" == "1" ]]; then
		fail2ban=1
	fi
fi

box_part "Install AUR helper"

declare -a AUR_Helpers=(
	"paru:	base-devel rust git; par"
	"yay:	base-devel git go; yay"
)

for AUR_Helper in "${AUR_Helpers[@]}"; do
	AUR="${AUR_Helper%%:*}"
	pacman_packages=$(echo "${AUR_Helper##*:}" | cut -d';' -f1 | sed -E 's/^[[:space:]]+//')
	AUR_installer=$(echo "${AUR_Helper##*;}")
	cd ~
	if ! command -v $AUR >/dev/null; then
		box_sub "$AUR installing"
		sudo pacman -S --needed $pacman_packages --noconfirm
		rm -rf $AUR
		git clone https://aur.archlinux.org/$AUR.git
		cd ~/$AUR
		makepkg -si --noconfirm
		if command -v $AUR >/dev/null; then
			function=$AUR_installer
			break
		fi
	else
		function=$AUR_installer
		break
	fi
done
cd ~

box_part "Installing programs"

if [[ "$App_Install__virt_viewer" == 1 ]] && systemd-detect-virt | grep -q "kvm\|qemu"; then
	sudo pacman -S --noconfirm spice-vdagent
	sudo systemctl enable spice-vdagentd
	sudo systemctl start spice-vdagentd
fi

#aur helper/pacman install
source <(curl -s -L https://raw.githubusercontent.com/TheSuperGiant/Arch/refs/heads/main/program_install_list.sh)

for app in "${App_Install__[@]}"; do
	key="${app%%:*}"
	if [[ "$(eval echo \$App_Install__$key)" == "1" ]]; then
		box_sub "$key"
		value=$(echo "${app##*:}" | sed -E 's/^[[:space:]]+//')
		$function --needed --noconfirm $value <<< 1
	fi
done

box_part "Secutity settings"

if [[ "$Firewall__Default" == "1" ]]; then
	sudo ufw enable
	if [[ "$firewall_Recommanded_rules" == "1" ]]; then
		sudo ufw default deny incoming
		sudo ufw default allow outgoing
		#sudo systemctl enable --now fail2ban
	fi
fi

if [[ "$App_Install__bluetooth" == "1" ]]; then
	sudo systemctl enable --now bluetooth.service
fi

#themes
if [[ "$theme__pack__Windows_10_Dark" == "1" ]]; then
	theme='Windows-10-Dark'
	git clone https://github.com/B00merang-Project/"$theme".git
	mds /usr/share/themes/
	sudo cp -r "$theme" /usr/share/themes/
fi

#settings
source <(curl -s -L https://raw.githubusercontent.com/TheSuperGiant/Arch/refs/heads/main/parts/settings.sh)

#time_converd + Setting__night_light__schedule_from not in settings file
#test run remove: declare -a,     Setting__ dcow,     for Setting in "${Setting__[@]}"; do,     declare -a applet__=(,   if [ "$ipV6_disable" == 1 ]; then

time_converd() {
	H=${1%%:*}; H=${H//24/0}
	M="${1##*:}" && M=$(( (M * 100) / 60 ))
	echo "$H.$M"
}

if [[ "$Setting__night_light__schedule_from" != "" ]]; then
	Setting__night_light__schedule_from=$(time_converd $Setting__night_light__schedule_from)
fi

if [[ "$Setting__night_light__schedule_to" != "" ]]; then
	Setting__night_light__schedule_to=$(time_converd $Setting__night_light__schedule_to)
fi

if [[ "$Setting__night_light__schedule_mode=0" != "" ]]; then
	if [[ "$Setting__night_light__schedule_mode" == "0" ]]; then
		Setting__night_light__schedule_mode="auto"
	else
		Setting__night_light__schedule_mode="manual"
	fi
fi

#Flatpak app settings
source <(curl -s -L https://raw.githubusercontent.com/TheSuperGiant/Arch/refs/heads/main/parts/flatpak_app_settings.sh)


box_part "Updating default program"

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
	"openoffice_database:			openoffice4-base.desktop"
	"openoffice_graphics:			openoffice4-draw.desktop"
	"openoffice_math:			openoffice4-math.desktop"
	"openoffice_presentation:			openoffice4-impress.desktop"
	"openoffice_spreadsheet:			openoffice4-calc.desktop"
	"openoffice_word:			openoffice4-writer.desktop"
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
	"openoffice_database:	vnd.oasis.opendocument.database x-sql vnd.ms-access vnd.ms-access.accdb x-dbase x-dbf vnd.ms-office x-msaccess mdb"
)

declare -a Default_office_graphics=(
	"libreoffice_graphics:	vnd.oasis.opendocument.graphics vnd.oasis.opendocument.graphics-template vnd.oasis.opendocument.graphics-flat-xml vnd.sun.xml.draw vnd.sun.xml.draw.template vnd.stardivision.draw vnd.openxmlformats-officedocument.drawingml.diagram+xml vnd.visio vnd.visio2013 x-coreldraw x-coreldrawtemplate x-coreldrawpattern x-coreldrawpresentation x-fig"
	"openoffice_graphics:	vnd.oasis.opendocument.graphics vnd.oasis.opendocument.graphics-template vnd.oasis.opendocument.graphics-flat-xml vnd.sun.xml.draw vnd.sun.xml.draw.template vnd.stardivision.draw x-fig"
)

declare -a Default_office_math=(
	"libreoffice_math:	vnd.oasis.opendocument.formula vnd.oasis.opendocument.formula-template vnd.sun.xml.math x-tex x-latex x-texinfo x-troff x-dvi"
	"openoffice_math:	vnd.oasis.opendocument.formula vnd.oasis.opendocument.formula-template vnd.sun.xml.math x-tex x-latex x-texinfo x-troff x-dvi"
)

declare -a Default_office_presentation=(
	"libreoffice_presentation:	vnd.oasis.opendocument.presentation vnd.oasis.opendocument.presentation-template vnd.openxmlformats-officedocument.presentationml.presentation vnd.openxmlformats-officedocument.presentationml.template vnd.ms-powerpoint vnd.ms-powerpoint.presentation.macroEnabled.12 vnd.ms-powerpoint.template.macroEnabled.12 vnd.ms-powerpoint.addin.macroEnabled.12 vnd.ms-powerpoint.slideshow.macroEnabled.12 vnd.sun.xml.impress vnd.sun.xml.impress.template vnd.stardivision.impress vnd.ms-powerpoint.slideshow.macroEnabled.12 x-iwork-keynote-sffkey vnd.apple.keynote"
	"openoffice_presentation:	vnd.oasis.opendocument.presentation vnd.oasis.opendocument.presentation-template vnd.openxmlformats-officedocument.presentationml.presentation vnd.openxmlformats-officedocument.presentationml.template vnd.ms-powerpoint vnd.ms-powerpoint.presentation.macroEnabled.12 vnd.ms-powerpoint.template.macroEnabled.12 vnd.ms-powerpoint.addin.macroEnabled.12 vnd.ms-powerpoint.slideshow.macroEnabled.12 vnd.sun.xml.impress vnd.sun.xml.impress.template vnd.stardivision.impress"
)

declare -a Default_office_spreadsheet=(
	"libreoffice_spreadsheet:	application/vnd.oasis.opendocument.spreadsheet application/vnd.oasis.opendocument.spreadsheet-template application/vnd.ms-excel application/vnd.openxmlformats-officedocument.spreadsheetml.sheet application/vnd.ms-excel.sheet.macroEnabled.12 application/vnd.ms-excel.template.macroEnabled.12 application/vnd.ms-excel.addin.macroEnabled.12 application/vnd.ms-excel.sheet.binary.macroEnabled.12 text/csv text/tab-separated-values application/vnd.lotus-1-2-3 application/vnd.stardivision.calc application/vnd.sun.xml.calc application/vnd.sun.xml.calc.template application/x-dbase application/x-dbf application/x-dos_ms_excel application/x-excel application/x-xls application/x-msexcel application/x-quattro-pro application/x-sylk text/spreadsheet application/vnd.gnumeric application/x-gnumeric application/x-spreadsheet application/vnd.openxmlformats-officedocument.spreadsheetml.template"
	"openoffice_spreadsheet:	application/vnd.oasis.opendocument.spreadsheet application/vnd.oasis.opendocument.spreadsheet-template application/vnd.ms-excel application/vnd.openxmlformats-officedocument.spreadsheetml.sheet application/vnd.ms-excel.sheet.macroEnabled.12 application/vnd.ms-excel.template.macroEnabled.12 application/vnd.ms-excel.addin.macroEnabled.12 application/vnd.ms-excel.sheet.binary.macroEnabled.12 text/csv text/tab-separated-values application/vnd.lotus-1-2-3 application/vnd.stardivision.calc application/vnd.sun.xml.calc application/vnd.sun.xml.calc.template application/x-dbase application/x-dbf application/x-dos_ms_excel application/x-excel application/x-xls application/x-msexcel application/x-quattro-pro application/x-sylk text/spreadsheet application/vnd.gnumeric application/x-gnumeric application/x-spreadsheet application/vnd.openxmlformats-officedocument.spreadsheetml.template"
)

declare -a Default_office_word=(
	"libreoffice_word:	msword rtf vnd.ms-works vnd.oasis.opendocument.text vnd.oasis.opendocument.text-template vnd.openxmlformats-officedocument.wordprocessingml.document vnd.stardivision.writer vnd.wordperfect x-abiword"
	"openoffice4-writer.desktop:	msword rtf vnd.ms-works vnd.oasis.opendocument.text vnd.oasis.opendocument.text-template vnd.openxmlformats-officedocument.wordprocessingml.document vnd.stardivision.writer vnd.wordperfect x-abiword"
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

box_part "Startup programs"

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
	if [[ "$(eval echo \$App_Startup__$name_string)" == "1" ]]; then
		application=$(echo "${App_Startup##*:}" | cut -d';' -f1 | sed -E 's/^[[:space:]]+//')
		name_app=($application); unset name_app[-1]
		read -ra type <<< "$application"
		sp $name_string "${type[@]: -1}" "${name_app[@]}"
	fi
done

#github repos
if [[ "$script_main" == 1 || "$script_startup" == 1 ]]; then
	git_repo__thesupergiant__arch=1
fi

#github updater
source <(curl -s -L https://raw.githubusercontent.com/TheSuperGiant/Arch/refs/heads/main/parts/github_git_repo.sh)

#startup script download to $HOME/Scripts
#md $HOME/Scripts
#sp ... -t -d
#Exec=bash -c "nm-online -q && sleep 1 && bash <(curl -fsSL $2); exec bash"

#if [ -n "$StartScript" ]; then
	#md $HOME/Scripts
	#md ~/.config/autostart

	#startup_location="$HOME/Scripts/startup_script.sh"

	#if [ ! -f "$startup_location" ] || ! echo "$StartScript" | diff -q - "$startup_location" > /dev/null; then
		#echo -e "$StartScript" > $startup_location
	#fi
	#autostart_location="$HOME/.config/autostart/startup_script.desktop"
	#if [ ! -f $autostart_location ]; then
		#sp?
		#echo "[Desktop Entry]
#Type=Application
#Exec=sudo $startup_script_file_location
#Hidden=false
#NoDisplay=false
#X-GNOME-Autostart-enabled=true
#Name=My Startup Script
#Comment=Runs my startup script at login" > $autostart_location
	#fi

	#add_sudo "$USER ALL=(ALL) NOPASSWD: $HOME/Scripts/*"

	#chmod +x $startup_location
#fi

#------------------------------------

#------------------
#games
	#indipendesies
		#wine-mono
		#dotnet-sdk
		#gnutls
		#lib32-gnutls
		#winetricks
		#winetricks corefonts vcrun2015
		#winetricks vcrun2019
		#winetricks dotnet48
		#WINEPREFIX=~/.wine64 WINEARCH=win64 winecfg
		#WINEPREFIX=~/.wine64 wine setup_vcredist_x64.exe
		#winecfg
		#?wine setup_vcredist_x64.exe?


#testing by hand
	#paru -S --noconfirm nvidia #already installing it in pre install with archtitus.

#later
	#qemu

http_check $2

sudo rm -f /etc/xdg/autostart/firstboot.desktop
