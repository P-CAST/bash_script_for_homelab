#!/bin/bash
shopt -s xpg_echo

# check if run with sudo
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

# update & upgrade
sudo apt-get -qq update && sudo apt-get upgrade -y > /dev/null 2>&1
echo "PASS: update & upgrade linux package"

# install NTFS & exFat
sudo apt-get -qq install ntfs-3g exfat-utils exfat-fuse -y > /dev/null 2>&1
echo "PASS: install NTFS & exFat support"

# install Samba
sudo apt-get -qq install samba samba-common-bin -y > /dev/null 2>&1
echo "PASS: install Samba"

# create Samba directory
echo "\nEnter folder name"
read FolderName
sudo mkdir /$FolderName > /dev/null 2>&1
sudo chmod 777 /$FolderName
echo "PASS: create directory, name: $FolderName"

# mount drive
lsblk -nd --output name,size | grep sd*
echo "\nSelect disk to use *choose wrong drive can cause system failure*"
read DiskName
echo "\nDo you want to wipe all data on the disk?[y/N]"
read DelAns
case "$DelAns" in
  [yY]) sudo mkfs.ext4 /dev/$DiskName > /dev/null 2>&1 && echo "PASS: $DiskName has been wiped";;
  [nN]) echo "PASS: No disk wiped";;
  * ) echo "PASS: No disk wiped";;
esac
sudo mount -t auto /dev/$DiskName /$FolderName
echo "PASS:mount $DiskName to /$FolderName successful"

# edit Samba config
echo "\nEnter server name"
read ServerName
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.bck
sudo rm /etc/samba/smb.conf
sudo cp /etc/samba/smb.conf.bck /etc/samba/smb.conf
echo "Samba config file got backup at /etc/samba/smb.conf.bck"
sudo echo -en "[$ServerName]\npath=/$FolderName\nbrowseable=yes\nread only=no\nwriteable=yes\ncreate mask=0777\ndirectory mask=0777\npublic=no\nforce user=root" >> /etc/samba/smb.conf
sudo rm -rf /$FolderName/lost+found > /dev/null 2>&1
echo "PASS: edit Samba config"

# add user to Samba
echo "\nEnter the username you want to connect with"
read UserName
sudo adduser --system --no-create-home --disabled-password --gecos "" $UserName > /dev/null 2>&1
sudo passwd -d $UserName > /dev/null 2>&1

sudo smbpasswd -a $UserName
echo "PASS: user created"

# restart Samba
sudo /etc/init.d/smbd restart
sudo /etc/init.d/nmbd restart

# auto mount drive on reboot
sudo echo -en "/dev/$DiskName /$FolderName auto defaults,user 0 2" >> /etc/fstab
echo "PASS: auto mount drive on reboot\n"