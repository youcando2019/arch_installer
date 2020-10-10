#!/bin/bash

loadkeys fr-latin1
wifi-menu
timedatectl set-ntp true

fdisk -l
echo "Enter the disk : "
read disk
cfdisk /dev/$disk
echo "Enter the partition : "
read partition
echo "Enter the swap : "
read swap
mkfs.ext4 /dev/$partition
mkswap /dev/$swap
swapon /dev/$swap

# Variable needed
# IFS= read -r -> To read spaces characters
IFS= read -r -p "Create the Password for ROOT : " a
IFS= read -r -p "Retype Password for ROOT : " b
if [[ "$a" = "$b" ]]; then
    pass_root="$a"
    a="null"
fi
read -p "Enter the User Name : " user
IFS= read -r -p "Create the Password for $user : " a
IFS= read -r -p "Retype Password for $user : " b
if [[ "$a" = "$b" ]]; then
    pass_user="$a"
    a="null"
fi

mount /dev/$partition /mnt

# Package configuration
# Add 32 Bit
mv /etc/pacman.conf /etc/pacman.conf.old
echo "[multilib]" >> /etc/pacman.conf
echo "include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf

pacman -Sy --noconfirm

pacstrap /mnt base linux linux-firmware nano sudo bash-completion base-devel git xorg xorg-server grub os-prober intel-ucode amd-ucode lightdm lightdm-deepin-greeter lightdm-gtk-greeter wpa_supplicant networkmanager deepin deepin-extra firefox xterm libreoffice okular vlc yay lib32-libcanberra-pulse
genfstab -U /mnt >> /mnt/etc/fstab

cp install_online_2.sh /mnt

# Variable needed 1-disk 2-pass_root 3-user 4-pass_user
arch-chroot /mnt /bin/bash ./install_online_2.sh $disk "$pass_root" "$user" "$pass_user"

rm /mnt/install_online_2.sh
umount -R /mnt
echo "Instalation Completed."

#reboot
