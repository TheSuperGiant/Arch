declare -a required=(
	#1
	"function__ext4setup:	error"
	"function__git_u:	error"
	"function__github_program_updater:	box_sub"
	"function__update:	ap github_program_updater"
	#2
	"function__ap:	apt_fail"
	"function__box_sub:	box"
)

for require in "${required[@]}"; do
	requiring="${require%%:*}"
	if [[ ${!requiring} == "1" ]];then
		req=$(echo "${require##*:}" | sed -E 's/^[[:space:]]+//')
		for re in ${req[@]}; do
			eval "function__$re=1"
		done
	fi
done