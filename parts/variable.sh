#pre function for if local exists else use curl


distro=$(source /etc/os-release; echo "$NAME")
distro_family=$(source /etc/os-release; echo "${ID_LIKE##* }"); distro_family="${distro_family:=${distro%% *}}"; distro_family="${distro_family,,}"
function_sh=$(curl -s https://raw.githubusercontent.com/TheSuperGiant/Arch/refs/heads/main/functions.sh)
if [[ "$distro_family" == "debian" ]]; then
	function_sh_mint=$(curl -s "https://raw.githubusercontent.com/TheSuperGiant/Linux-Mint/refs/heads/main/functions.sh")
fi

#ram
while IFS=' ' read -r key value unit; do
	if [[ $key == "MemTotal:" ]]; then
		ram=$((value/1000))
		break
	fi
done < /proc/meminfo
