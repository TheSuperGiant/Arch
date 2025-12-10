box_part "Updating functions"
alias_adding(){
	local alias_code=$(echo "$2" | grep "^alias $1=")
	if [[ "$(eval echo \${function__$1})" == "1" ]] && [[ $alias_code != "$(sed -n "/^alias $1=/p" ~/.bashrc)" ]]; then
		if [[ "$(sed -n "/^alias $1=/p" ~/.bashrc)" != "" ]]; then
			sed -i "/^alias $1=/d" ~/.bashrc
		fi
		echo $alias_code >> ~/.bashrc && echo "Updating .bashrc with the latest $1 alias code."
	fi
}
function_adding(){
	local funcation_code=$(echo "$2" | awk "/^$1\\(\\)/ {f=1} f; /^}/ {f=0}")
	if [[ "$(eval echo \${function__$1})" == "1" ]] && [[ "$funcation_code" != "$(sed -n "/^$1()/,/^}/p" ~/.bashrc)" ]]; then
		if [[ "$(sed -n "/^$1()/,/^}/p" ~/.bashrc)" != "" ]]; then
			sed -i "/^$1()/,/^}/d" ~/.bashrc
		fi
		echo "$funcation_code" >> ~/.bashrc && echo "Updating .bashrc with the latest $1 function code."
	fi
}
aliasi(){
	echo "$1" | grep -oP '^\s*alias\s+\K\w+'
}
functi(){
	echo "$1" | grep -oP '^\s*\K\w+(?=\()'
}

if [[ -n "$function_personal" ]];then
	#source <($function_personal_conf)
	source <(cat $function_personal_conf)
	personal_sh="$(cat $function_personal)"
	for function in $(functi "$personal_sh"); do
		function_adding "$function" "$personal_sh"
	done
	for alias in $(aliasi "$personal_sh"); do
		alias_adding "$alias" "$personal_sh"
	done
fi