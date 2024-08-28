#!/bin/bash
# -*- coding: utf-8 -*-

# running in chroot


source /config.bash

root_passwd=$(cat /rt-pw)
user_passwd=$(cat /us-pw)
rm -f /*-pw
passwd <<!
$root_passwd
$root_passwd
!

clear

echo "[CHROOT]"

pacman-key --init
pacman -Syu

ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=de-latin1" >> /etc/vconsole.conf



pacman -S grub efibootmgr dhcpcd virtualbox-guest-utils htop neofetch wget git --noconfirm
#^xfce4-goodies
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable dhcpcd.service
<

if [ "$de" == "xfce4" ]; then
	pacman -S xfce4 lightdm lightdm-gtk-greeter xdg-user-dirs xorg-xmessage --noconfirm
	systemctl enable lightdm.service
else
	touch /mnt/no-de
fi

systemctl enable first-boot.service

#

useradd -m -G wheel,audio,disk,floppy,input,kvm,optical,scanner,storage,video user
passwd user <<!
$user_passwd
$user_passwd
!


mv /first-login.bash /home/user/
chown user: /runme.desktop

echo "%wheel ALL=(ALL:ALL) ALL" > /etc/sudoers #unsafe?

# set font to ubuntus font or something

pacman -Syu --noconfirm
sleep 1
clear
neofetch
sleep 2
exit
