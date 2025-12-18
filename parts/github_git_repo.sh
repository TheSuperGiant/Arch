box_part "Github repo updating"

user="thesupergiant"

declare -a needed=(
	"${user}__arch:	${user}__arch"
	"${user}__linux_mint:	${user}__arch ${user}__linux_mint"
)

declare -a repos=(
	"${user}__arch:	$user Arch"
	"${user}__archtitus:	$user ArchTitus"
	"${user}__GTA_V:	$user GTA-V"
	"${user}__GTA_V__Macro:	$user GTA-V---Macro"
	"${user}__linux_mint:	$user Linux-Mint"
	"${user}__linux_tools:	$user Linux-Tools"
)

declare -a sudo_scripts=(
	"${user}__arch:	Arch/2.sh"
	"${user}__linux_mint:	Linux-mint/mint_2.sh"
)

declare -a distro_list=(
	"${user}__arch:	Arch Linux"
	"${user}__linux_mint:	Linux Mint"
)

for needs in "${needed[@]}"; do
	need="${needs%%:*}"
	if [[ "$(eval echo \${git_repo__$need})" == "1" ]];then
		repo=$(echo "${needs##*:}" | sed -E 's/^[[:space:]]+//')
		for r in $repo;do
			declare "git_repo__$r=1"
		done
		break
	fi
done

github_repo_location="/opt/github_repo"
if [[ ! -d "$github_repo_location" ]]; then
	sudo mkdir -p $github_repo_location
	sudo chown -R :users $github_repo_location
	sudo chmod -R u+rwX,g+rwX,o+rwX  $github_repo_location
fi

for re in "${repos[@]}"; do
	repo_name="${re%%:*}"
	if [[ "$(eval echo \${git_repo__$repo_name})" == "1" ]];then
		box_sub "$repo_name"
		repo_user=$(echo "${re##*:}" | awk '{print $1}')
		repo=$(echo "${re##*:}" | awk '{print $2}')
		git_update "$github_repo_location/$repo" $repo_user $repo
		dis=$(printf '%s\n' "${distro_list[@]}" | grep "^$repo_name" | cut -d: -f2- | sed 's/^[[:space:]]*//')
		if [[ "$distro" == "$dis" ]];then
			files=$(printf '%s\n' "${sudo_scripts[@]}" | grep "^$repo_name" | cut -d: -f2- | sed 's/^[[:space:]]*//')
			for file in ${files[@]};do
				add_sudo "$SUDO_USER ALL=(ALL) NOPASSWD: $github_repo_location/$file"
			done
		fi
	fi
done
