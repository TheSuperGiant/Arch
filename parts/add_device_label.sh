box_part "Adding mounted partitions"

if [[ -n "$add_device_labels" ]]; then
	add_device_label ${add_device_labels[@]}
fi
