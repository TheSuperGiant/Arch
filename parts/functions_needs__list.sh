declare -a required=(
	#1
	"function__add_sudo:	update_row nested_expension"
	"function__dcor:	dco_value"
	"function__dcow:	dco_value"
	"function__ext4setup:	error"
	"function__flat:	error"
	"function__git_u:	error ssh_agt"
	"function__pf:	error"
	"function__s_link:	error"
	"function__ssh_key:	ssh_agt"
	#2
	"function__box_sub:	box"
	"function__nested_expension:	error"
	"function__update_row:	error"
)

source <(curl -s -L https://raw.githubusercontent.com/TheSuperGiant/Arch/refs/heads/main/parts/functions_needs__require_loop.sh)
