#!/bin/bash
shopt -s xpg_echo

# update & upgrade
sudo apt-get update && sudo apt-get upgrade -y
echo "PASS: update & upgrade linux package\n"

# install NTFS & exFat
sudo apt-get install ntfs-3g exfat-utils exfat-fuse -y
echo "PASS: install NTFS & exFat support\n"

# install Samba
sudo apt-get install samba samba-common-bin -y
echo "PASS: install Samba\n"

# create Samba directory
sudo mkdir /nas
sudo chmod 777 /nas
echo "PASS: create directory\n"

# mount drive
lsblk

echo "\nselect disk to mount"
read DiskName
echo "PASS:mount $DiskName to /nas successful\n"

# edit Samba config
echo "enter server name"
read ServerName

sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.bck
sudo rm /etc/samba/smb.conf
sudo cp /etc/samba/smb.conf.bck /etc/samba/smb.conf
echo "config file backup at /etc/samba/smb.conf.bck\n"
sudo echo -en "[$ServerName]\npath=/nas\nbrowseable=yes\nread only=no\nwriteable=yes\ncreate mask=0777\ndirectory mask=0777\npublic=no\nforce user=root" >> /etc/samba/smb.conf
echo "PASS: edit Samba config\n"

# add user to Samba
echo "What's username you want to connect with"
read UserName
sudo adduser $UserName

sudo smbpasswd -a $UserName
echo "PASS: user created\n"

# restart Samba
sudo /etc/init.d/smbd restart
sudo /etc/init.d/nmbd restart

# auto mount drive on reboot
sudo echo "/dev/&DiskName /nas auto defaults,user 0 2"
echo "PASS: auto mount drive on reboot\n"