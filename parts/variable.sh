distro=$(grep '^NAME=' /etc/os-release | cut -d'"' -f2)
ram=$(awk '/MemTotal/ {print int($2/1000)}' /proc/meminfo) #in mb
