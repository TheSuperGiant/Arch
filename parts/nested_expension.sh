nested_expension() {
	usage="<output variable name> <string to change> <string transformation code> [<string transformation code> ...]"
	help_text() {
		echo "nested expension

multiple nesting variable.

arguments
	1.	Name of the output variable
	2.	String to be changed
	3..	String transformation code

${FUNCNAME[1]} $usage
"
	}
	if [[ $# == 0 ]] || [[ " $* " =~ [[:space: ]](-h|-help|--help)[[:space: ]] ]]; then
		help_text
		return
	elif [[ $# -lt 4 ]]; then
		help_text
		error "Usage: $usage"
		return
	fi
	out_var_name="$1"
	temp="$2"
	shift 2
	for nes in $@; do
		eval "temp=\${temp${nes}}"
	done
	eval "$out_var_name=$temp"
}
