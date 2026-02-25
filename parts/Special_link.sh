box_part "Special links creating"
if [[ ${s_links%% *} == "-f" ]]; then
	force="$s_links"
	s_links="${s_links#* }"
fi
if [[ -n "$s_links" ]]; then
	for s_li in "${s_links[@]}" ; do
		s_link ${s_li[@]} ${force:-}
	done
fi
