#!/bin/bash
# -*- coding: utf-8 -*-
# zsh

# running in chroot


clear
echo "IN CHROOT."

echo "SET ROOT USER PASSWORD:"
passwd



ln -sf /usr/share/zoneinfo/US/Eastern /etc/localtime
hwclock --systohc

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=de-latin1" >> /etc/vconsole.conf

echo -n "arch-installed" > /etc/hostname

pacman -S grub efibootmgr --noconfirm
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

pacman -S xfce4 lightdm lightdm-gtk-greeter xdg-user-dirs neofetch wget git --noconfirm

systemctl enable lightdm.service

xfce4-setting-manager --gtk-theme Adwaita-dark # set dark theme

pacman -Syu --noconfirm

clear
echo "IN CHROOT."
useradd -m -G wheel,audio,video user
echo "SET USER USER PASSWORD:"
passwd user

rm /chroot.bash
exit