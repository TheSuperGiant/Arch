exec > >(tee -a 2.sh.log) 2>&1

unset sudoers_adding
#sudoers_adding=""

#pre function for if local exists else use curl


distro=$(source /etc/os-release; echo "$NAME")
distro_family=$(source /etc/os-release; echo "${ID_LIKE##* }"); distro_family="${distro_family:=${distro%% *}}"; distro_family="${distro_family,,}"
function_sh=$(curl -s https://raw.githubusercontent.com/TheSuperGiant/Arch/refs/heads/main/functions.sh)
#local if internet isnt availble
if [[ "$distro_family" == "debian" ]]; then
	function_sh_mint=$(curl -s "https://raw.githubusercontent.com/TheSuperGiant/Linux-Mint/refs/heads/main/functions.sh")
	#local if internet isnt availble
fi
for function in "$function_sh" "$function_sh_mint"; do
	while IFS= read -r line; do
		if [[ "$line" == alias* ]]; then
			alias=$(echo "$line" | cut -d' ' -f2 | cut -d'=' -f1)
			unalias -a "$alias"
		fi
	done < <(echo "$function")
	source <(echo "$function" | sed -E '/^alias / s/\\"/"/g' | sed -E 's/^alias ([^=]+)=["](.*)["]$/\1() {\n  \2\n}/')
done


#ram
while IFS=' ' read -r key value unit; do
	if [[ $key == "MemTotal:" ]]; then
		ram=$((value/1000))
		break
	fi
done < /proc/meminfo

nested_expension "display_manager" $(readlink -f /etc/systemd/system/display-manager.service) '##*/' '%%.*'
