if [[ $DNS_Quad9 == 1 ]]; then
	add_dns 9.9.9.9 149.112.112.112 2620:fe::fe 2620:fe::9 $adding_dns
elif [[ $DNS_Cloudflare == 1 ]]; then
	add_dns 1.1.1.1 1.0.0.1 2606:4700:4700::1111 2606:4700:4700::1001 $adding_dns
fi
