box_part "Adding mounted partitions"
#echo "------------------------------------"
#echo "|   Adding mounted partitions...   |"
#echo "------------------------------------"

if [ -n "$add_device_labels" ]; then
	add_device_label ${add_device_labels[@]}
fi