#functions + alias adding
source <(curl -s -L $TheSuperGiant_Arch_repo_uri__parts/functions_alias_adding.sh)
for function in $(functi "$function_sh"); do
	function_adding "$function" "$function_sh"
done

for alias in $(aliasi "$function_sh"); do
	alias_adding "$alias" "$function_sh"
done
