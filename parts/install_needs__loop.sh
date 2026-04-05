for needs in "${install_needs[@]}"; do
	needing="${needs%%:*}"
	if [[ ${!needing} == "1" ]]; then
		need=$(echo "${needs##*:}" | sed -E 's/^[[:space:]]+//')
		for n in ${need[@]}; do
			declare -g "App_Install__$n=1"
		done
	fi
done
