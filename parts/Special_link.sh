box_part "Special links creating"
if [ -n "$s_links" ]; then
	for s_li in "$s_links" ;do
		s_link ${s_li[@]}
	done
fi