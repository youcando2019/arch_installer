#!/bin/bash

loadkeys fr

read -p "Enter your disk name : " disk
read -p "Enter your user name : " user

# Variable needed
# IFS= read -r -> To read spaces characters
until [[ "$a" = "$b" ]]; do
    IFS= read -r -p "Create the Password for ROOT : " a
    IFS= read -r -p "Retype Password for ROOT : " b
done
if [[ "$a" = "$b" ]]; then
    pass_root="$a"
    a="null"
fi

until [[ "$a" = "$b" ]]; do
    read -p "Enter the User Name : " user
    IFS= read -r -p "Create the Password for $user : " a
    IFS= read -r -p "Retype Password for $user : " b
done
if [[ "$a" = "$b" ]]; then
    pass_user="$a"
    a="null"
fi

#passwd
echo -e "$pass_root\n$pass_root" | passwd
sed -i -e 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/g' /etc/sudoers
useradd -m -G wheel -s /bin/bash $user
#passwd $user
echo -e "$pass_user\n$pass_user" | passwd $user

timedatectl set-timezone Africa/Algiers
ln -sf /usr/share/zoneinfo/Africa/Algiers /etc/localtime
hwclock --systohc
sed -i -e 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
locale-gen
locale -a
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

echo "KEYMAP=fr-latin1" >> /etc/vconsole.conf

echo "myhostname" >> /etc/hostname

echo "127.0.0.1	localhost" >> /etc/hosts
echo "::1		localhost" >> /etc/hosts
echo "127.0.1.1	myhostname.localdomain	myhostname" >> /etc/hosts

mkinitcpio -P

system="sudo xorg xorg-server grub os-prober intel-ucode amd-ucode"
deepin="lightdm lightdm-deepin-greeter lightdm-gtk-greeter wpa_supplicant networkmanager deepin deepin-extra"
cinnamon="cinnamon cinnamon-wallpapers cinnamon-sounds gnome-terminal parcellite lightdm lightdm-slick-greeter lightdm-settings"
gnome="gnome gnome-extra"
kde="sddm plasma kde-applications"

os-prober
grub-install /dev/$disk
CONFIG_BLK_DEV_INITRD=Y
CONFIG_MICROCODE=y
CONFIG_MICROCODE_INTEL=Y
CONFIG_MICROCODE_AMD=y
grub-mkconfig -o /boot/grub/grub.cfg

sed -i -e 's/#greeter-session=example-gtk-gnome/greeter-session=lightdm-deepin-greeter/g' /etc/lightdm/lightdm.conf
systemctl enable gdm.service
systemctl enable wpa_supplicant.service
systemctl enable NetworkManager.service
systemctl enable bluetooth.service

echo "[multilib]" >> /etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf

exit
