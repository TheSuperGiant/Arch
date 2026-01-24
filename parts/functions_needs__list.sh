declare -a required=(
	#1
	"function__ext4setup:	error"
	"function__git_u:	error"
	#2
	"function__box_sub:	box"
)

source <(curl -s -L https://raw.githubusercontent.com/TheSuperGiant/Arch/refs/heads/main/parts/functions_needs__require_loop.sh)
