#!/bin/bash
# -*- coding: utf-8 -*-

# running in chroot


echo "[CHROOT]"

source /config.bash
[ -d "/sys/firmware/efi" ] && uefi=1 || uefi=0

root_passwd=$(cat /rt-pw)
user_passwd=$(cat /us-pw)
rm -f /*-pw
passwd <<!
$root_passwd
$root_passwd
!


ln -sf /usr/share/zoneinfo/Etc/GMT /etc/localtime
hwclock --systohc

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=de-latin1" >> /etc/vconsole.conf

pacman -S grub dhcpcd htop wget git --noconfirm

grub-install --target=i386-pc $drive
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable dhcpcd.service

if   [ "$de" == "xfce4" ]; then
	pacman -S xfce4 xfce4-goodies lightdm lightdm-gtk-greeter xdg-user-dirs xorg-xmessage --noconfirm
	systemctl enable lightdm.service
elif [ "$de" == "i3" ]; then
	pacman -S i3 xfce4-terminal lightdm lightdm-gtk-greeter --noconfirm # TODO: different terminal?
	systemctl enable lightdm.service # TODO: use a login script to xinit instead
	touch /mnt/no-de # FIX
elif [ "$de" == "plasma" ]; then
	pacman -S plasma kde-applications plasma-login-manager --noconfirm
	systemctl enable plasmalogin.service
elif [ "$de" == "gnome" ]; then
	pacman -S gnome --noconfirm
	systemctl enable gdm.service
else
	touch /mnt/no-de
fi
systemctl enable first-boot.service

useradd -m -G wheel,audio,disk,floppy,input,kvm,optical,scanner,storage,video user
passwd user <<!
$user_passwd
$user_passwd
!

mv /first-login.bash /home/user/
chown user: /runme.desktop

echo "%wheel ALL=(ALL:ALL) ALL" > /etc/sudoers #unsafe?

pacman -Syu
echo "Chroot done."
exit
