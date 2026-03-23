for require in "${required[@]}"; do
	requiring="${require%%:*}"
	if [[ ${!requiring} == "1" ]]; then
		req=$(echo "${require##*:}" | sed -E 's/^[[:space:]]+//')
		for re in ${req[@]}; do
			declare -g "function__$re=1"
		done
	fi
done
