box_part "Program settings"
box_sub "syncthing"
#syncthing
if [[ "$App_Install__syncthing" == 1 ]]; then
	systemctl --user enable syncthing.service
	systemctl --user start syncthing.service
	#sudo loginctl enable-linger $USER
	sudo loginctl enable-linger $SUDO_USER
fi

syncthing device-id
