#!/bin/bash

loadkeys fr
iwctl
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

mount /dev/$partition /mnt

# Package configuration
# Add 32 Bit
cp /etc/pacman.conf /etc/pacman.conf.old
echo "[multilib]" >> /etc/pacman.conf
echo "include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf

pacman -Sy --noconfirm

#pacstrap /mnt base linux linux-firmware nano sudo bash-completion base-devel git xorg xorg-server grub os-prober intel-ucode amd-ucode wpa_supplicant networkmanager blueberry lightdm lightdm-deepin-greeter lightdm-gtk-greeter deepin deepin-extra firefox xterm libreoffice okular vlc yay lib32-libcanberra-pulse
pacstrap /mnt base linux linux-firmware nano sudo bash-completion base-devel git xorg xorg-server grub os-prober intel-ucode amd-ucode wpa_supplicant networkmanager blueberry gnome gnome-extra firefox libreoffice okular vlc yay lib32-libcanberra-pulse
genfstab -U /mnt >> /mnt/etc/fstab

cp install_online_2.sh /mnt

echo "Type this command : ./install_online_2.sh"

# Variable needed 1-disk 2-pass_root 3-user 4-pass_user
arch-chroot /mnt

rm /mnt/install_online_2.sh
umount -R /mnt
echo "Instalation Completed."

#reboot
