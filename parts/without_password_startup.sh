if [[ "$EUID" -eq 0 ]]; then
	if [[ -n "$SUDO_USER" ]]; then
		echo "Running as root via sudo by user: $SUDO_USER"
	else
		echo "Running as root (maybe direct root login)"
	fi
else
	SUDO_USER=$USER
	echo "Running as normal user: $USER"
fi
