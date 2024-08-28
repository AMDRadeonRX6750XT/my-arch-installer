#!/bin/bash
# -*- coding: utf-8 -*-

# run on the first boot




while [ ! -d "/home/user/Desktop/" ]; do
	sleep 1
done

mv /runme.desktop /home/user/Desktop/


systemctl disable first-boot.service
rm -f /etc/systemd/system/first-boot.service
rm -f /first-boot.bash
exit
