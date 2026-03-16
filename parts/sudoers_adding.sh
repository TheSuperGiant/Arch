box_part "sudoers adding"
#echo "sudoers string: $sudoers_adding" #temp
#last comma remove
#for sudoers_add in "$sudoers_adding"#; do
while IFS= read -r line; do
	#sudoers_add="${sudoers_add%,*}"
	#add_sudo "$sudoers_add"
	add_sudo "$line"
	#add_sudo "${sudoers_add%,*}"
done <<< "$sudoers_adding"
