#!/bin/bash
# -*- coding: utf-8 -*-

# running in chroot

sleep 1
clear

echo "[CHROOT]"
echo "> Set root account password. <"
passwd
read -r -p "User account password (will be displayed): " user_passwd
read -p "Hostname: " hostname
sleep 2
clear
echo "Installing now, the system will boot into arch automatically."
read -s -r -p "Press enter to continue.."
clear

pacman-key --init
pacman -Sy

ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" >> /etc/locale.conf
echo "KEYMAP=de-latin1" >> /etc/vconsole.conf

echo -n "$hostname" > /etc/hostname



pacman -S grub efibootmgr dhcpcd virtualbox-guest-utils xfce4 lightdm lightdm-gtk-greeter xdg-user-dirs xorg-xmessage neofetch wget git --noconfirm
#^xfce4-goodies

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable dhcpcd.service
systemctl enable lightdm.service

#

useradd -m -G wheel,audio,disk,floppy,input,kvm,optical,scanner,storage,video user
passwd user <<!
$user_passwd
$user_passwd
!


mv /first-login.bash /home/user/
chown user: /runme.desktop
mkdir /home/user/Desktop/ # bad idea but too lazy to fix (kinda makes /Desktop/ weird)
mv /runme.desktop /home/user/Desktop/
chown user: /home/user/Desktop/

echo "%wheel ALL=(ALL:ALL) ALL" > /etc/sudoers #unsafe?

# set font to ubuntus font or something

pacman -Syu --noconfirm
exit
