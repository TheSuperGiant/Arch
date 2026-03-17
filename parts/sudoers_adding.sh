box_part "sudoers adding"
while IFS= read -r line; do
	add_sudo "$line"
done <<< "$sudoers_adding"
