#!/bin/bash
# -*- coding: utf-8 -*-

# loadkeys de-latin1

# pacman -Sy

# pacman -S git

# git clone <repo>

# chmod +x *

# /installer.bash

ping 1.1.1.1 -W 5 -c 1

clear

if [ $? -eq 0 ]; then
	echo "Online."
else
	echo "Offline, can't proceed."
	echo "-> https://wiki.archlinux.org/title/Installation_guide"
	exit
fi

echo "Warning: only run this script in a Virtual Machine"



read -p "Press enter to install to /dev/sda, THIS WILL WIPE ALL DATA."
read -p "Are you sure?"
clear

wipefs --all /dev/sda

parted -s -f -a optimal /dev/sda -- mklabel gpt \
	mkpart primary fat32 0.0 1GiB \
	mkpart primary linux-swap 1GiB 5GiB \
	mkpart primary ext4 5GiB -1 \
	set 1 boot on

mkfs.fat -F 32 /dev/sda1 # efi
mkswap /dev/sda2         # swap
mkfs.ext4 /dev/sda3      # root

mount /dev/sda3 /mnt
mount --mkdir /dev/sda1 /mnt/boot
swapon /dev/sda2

pacman-key --init

pacstrap -K /mnt base linux linux-firmware sudo nano vi vim neovim

genfstab -U /mnt >> /mnt/etc/fstab

cp ./in-chroot.bash /mnt/chroot.bash

arch-chroot /mnt bash /chroot.bash



#
sync
umount -R /mnt
echo "Rebooting now."
sleep 2
reboot

