distro=$(grep '^NAME=' /etc/os-release | cut -d'"' -f2)
total_ram=$(grep MemTotal /proc/meminfo | grep -o '[[:digit:]]*')
ram=$(echo $total_ram / 1000 | bc) #in mb
