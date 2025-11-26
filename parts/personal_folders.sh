#!/usr/bin/env bash
# Disclaimer:
# This script is provided as-is, without any warranty or guarantee.
# By using this script, you acknowledge that you do so at your own risk.
# I am not responsible for any damage, data loss, or other issues that may result from the use of this script.

box_part "Moving personal folders"

declare -a folder_parameters=(
	"Downloads:-d"
	"Desktop:-e"
	"Music:-m"
	"Documents:-o"
	"Pictures:-p"
	"Templates:-t"
	"Public:-u"
	"Videos:-v"
)

if [ -n "$personal_folder_place" ]; then
	for folders in "${folder_parameters[@]}"; do
		folder_name="${folders%%:*}"
		if [ "$(eval echo \$personal_folder__$folder_name)" == "1" ]; then
			parameter="${folders##*:}"
			folder+=" $parameter"
		fi
	done
	pf $personal_folder_place $folder -y
fi