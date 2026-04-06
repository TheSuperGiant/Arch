declare -a install_needs=(
	"App_Install__keepass:	xdotool"
	"App_Install__notepadPlusPlus:	wine winetricks"
	#"App_Install__winboat:	docker flatpak"
	"script_main:	git"
)

#install needs loops
source <(curl -s -L https://raw.githubusercontent.com/TheSuperGiant/Arch/refs/heads/main/parts/install_needs__loop.sh)
