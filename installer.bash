#!/bin/bash
# -*- coding: utf-8 -*-

# loadkeys de-latin1
# pacman -Sy git
# git clone <repo.git>
# cd *
# chmod +x *
# ./installer.bash

# TODO: make sure hostname and passwords are valid
# TODO: "eject cd/usb" message
# FIX: "resulting partition not properly aligned for best perfomance"
# config: select: keymap, timezone, username, base-devel pkg
# config: multi-select: browsers, virtual machine host(s), window manager AND/OR desktop environment, python

## Initialization ##

if [ ! -f /etc/arch-release ]; then
	echo "This does not appear to be arch. Can't install."
	exit
fi

if [ ! -f $drive ]; then
	echo "The configured drive does not exist (see config.bash). Can't install."
	exit
fi

[ -d "/sys/firmware/efi" ] && uefi=1 || uefi=0
if [ $uefi -eq 1 ]; then
	echo "UEFI detected. Can't install." ; exit
	# cat /sys/firmware/efi/fw_platform_size
else
	echo "BIOS" ; echo
fi

chmod +x *.bash
chmod +x ./other/*.bash
chmod +x ./other/*.desktop

source ./config.bash

#ping 1.1.1.1 -W 5 -c 1
#pacman-key --init
pacman -Sy
if [ $? -eq 1 ]; then
	echo "Offline, can't proceed."
	echo "-> https://wiki.archlinux.org/title/Installation_guide"
	exit
fi

clear
echo       "> WARNING: only run this script in a Virtual Machine <"
read -s -p "Press enter to install to $drive, THIS WILL WIPE ALL DATA." ; echo
read -s -p "Are you sure?"
clear
read -r -p "Root account password (will be displayed): " root_passwd
read -r -p "User account password (will be displayed): " user_passwd
read -p    "Hostname: " hostname

echo          "Installing now, the system will boot into arch automatically."
read -s -r -p "Press enter to continue.."
clear


## Partitioning ##

wipefs --all $drive

parted --script --fix --align=optimal $drive -- mklabel msdos \
	mkpart primary fat32      2MiB  1GiB \
	mkpart primary linux-swap 1GiB 5GiB  \
	mkpart primary ext4       5GiB -1

mkfs.fat -F 32 "${drive}1" # efi | TODO: this partition shouldn't be required for BIOS install
mkswap         "${drive}2" # swap
mkfs.ext4      "${drive}3" # root

#fatlabel "${drive}1" "EFI" # $uefi
swaplabel --label "linux-swap" "${drive}2"
e2label "${drive}3" "linux-arch"

mount "${drive}3" /mnt
mount --mkdir "${drive}1" /mnt/boot
swapon "${drive}2"

## Chroot ##

pacstrap -K /mnt base linux linux-firmware sudo nano vi vim # optional: base-devel
genfstab -U /mnt >> /mnt/etc/fstab

echo -n "$root_passwd" > /mnt/rt-pw
echo -n "$user_passwd" > /mnt/us-pw
echo -n "$hostname"    > /mnt/etc/hostname

cp ./config.bash /mnt/

cp ./other/in-chroot.bash /mnt/chroot.bash

cp ./other/first-login.bash /mnt/

cp ./other/runme.desktop /mnt/

cp ./other/first-boot.bash /mnt/
cp ./other/first-boot.service /mnt/etc/systemd/system/

arch-chroot /mnt bash /chroot.bash
echo "Left chroot."

rm -f /mnt/chroot.bash

## Finalization ##

sync
umount -R /mnt
echo "Rebooting now."
sleep 5
reboot now
