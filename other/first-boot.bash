#!/bin/bash
# -*- coding: utf-8 -*-

# run on the first boot

if [ -f "/no-de" ]; do
	rm -f /no-de
	rm -f /runme.desktop
else
	# wait until folder exists
	while [ ! -d "/home/user/Desktop/" ]; do
		sleep 1
	done
	mv /runme.desktop /home/user/Desktop/
fi



systemctl disable first-boot.service
rm -f /etc/systemd/system/first-boot.service
rm -f /first-boot.bash
exit
