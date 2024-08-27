#!/bin/bash
# -*- coding: utf-8 -*-

# loadkeys de-latin1

# pacman -Sy

# pacman -S git

# git clone <repo>

# chmod +x *

# /installer.bash


chmod +x .bash


clear

ping 1.1.1.1 -W 5 -c 1
if [ $? -eq 0 ]; then
	echo "Online."
else
	echo "Offline, can't proceed."
	echo "-> https://wiki.archlinux.org/title/Installation_guide"
	exit
fi

pacman-key --init
clear

echo       "Warning: only run this script in a Virtual Machine"
read -s -p "Press enter to install to /dev/sda, THIS WILL WIPE ALL DATA."
read -s -p "Are you sure?"
clear


wipefs --all /dev/sda

parted -s -f -a optimal /dev/sda -- mklabel gpt \
	mkpart primary fat32      0.0  1GiB \
	mkpart primary linux-swap 1GiB 5GiB \
	mkpart primary ext4       5GiB -1   \
	set 1 boot on

mkfs.fat -F 32 /dev/sda1  # efi
mkswap         /dev/sda2  # swap
mkfs.ext4      /dev/sda3  # root

swaplabel --uuid "4F68BCE3-E8CD-4DB1-96E7-FBCAF984B709" /dev/sda3 # 4.2.3 https://wiki.archlinux.org/title/GPT_fdisk
swaplabel --label "linux-arch" /dev/sda3

mount /dev/sda3 /mnt
mount --mkdir /dev/sda1 /mnt/boot
swapon /dev/sda2

#

pacstrap -K /mnt base linux linux-firmware sudo nano vi vim neovim
genfstab -U /mnt >> /mnt/etc/fstab

cp ./in-chroot.bash /mnt/chroot.bash
cp ./first-login.bash /mnt/first-login.bash

arch-chroot /mnt bash /chroot.bash

rm -f /mnt/chroot.bash

#

sync
umount -R /mnt
echo "Rebooting now."
sleep 2
reboot now
