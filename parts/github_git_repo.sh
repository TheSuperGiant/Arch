user="thesupergiant"

declare -a needed=(
	"arch:	${user}__arch"
	"linux_mint:	${user}__arch ${user}__linux_mint"
)

declare -a repos=(
	"${user}__arch:	$user Arch"
	"${user}__archtitus:	$user ArchTitus"
	"${user}__GTA_V:	$user GTA-V"
	"${user}__GTA_V__Macro:	$user GTA-V---Macro"
	"${user}__linux_mint:	$user Linux-Mint"
	"${user}__linux_tools:	$user Linux-Tools"
)

if [[ -n "$git_repo" ]];then
	for needs in "${needed[@]}"; do
		need="${needs%%:*}"
		if [[ $need == "$git_repo" ]];then
			repo=$(echo "${needs##*:}" | sed -E 's/^[[:space:]]+//')
			for r in $repo;do
				declare "git_repo__$r=1"
			done
			break
		fi
	done
fi

github_repo_location="/opt/github_repo"
if [[ ! -d "$github_repo_location" ]]; then
	sudo mkdir -p $github_repo_location
	sudo chown -R :users $github_repo_location
	sudo chmod -R u+rwX,g+rwX,o+rwX  $github_repo_location
fi

for re in "${repos[@]}"; do
	repo_name="${re%%:*}"
	printf "%s\n" $repo_name
	if [[ "$(eval echo \${git_repo__$repo_name})" == "1" ]];then
		repo_user=$(echo "${re##*:}" | awk '{print $1}')
		repo=$(echo "${re##*:}" | awk '{print $2}')
		printf "%s\n" $repo_user
		printf "%s\n" $repo
		git_adding $repo_user $repo "$github_repo_location/$repo"
	fi
done