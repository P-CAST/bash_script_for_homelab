#!/bin/bash
shopt -s xpg_echo

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
sudo mkdir /nas > /dev/null 2>&1
sudo chmod 777 /nas
echo "PASS: create directory"

# mount drive
lsblk -nd --output name,size | grep sd*
echo "\nselect disk to use *choose wrong drive can cause system failure*"
read DiskName
sudo mkfs.ext4 /dev/$DiskName > /dev/null 2>&1
sudo mount -t auto /dev/$DiskName /nas
echo "PASS:mount $DiskName to /nas successful"

# edit Samba config
echo "\nenter server name"
read ServerName

sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.bck
sudo rm /etc/samba/smb.conf
sudo cp /etc/samba/smb.conf.bck /etc/samba/smb.conf
echo "config file backup at /etc/samba/smb.conf.bck"
sudo echo -en "[$ServerName]\npath=/nas\nbrowseable=yes\nread only=no\nwriteable=yes\ncreate mask=0777\ndirectory mask=0777\npublic=no\nforce user=root" >> /etc/samba/smb.conf
sudo rm -rf /nas/lost+found > /dev/null 2>&1
echo "PASS: edit Samba config"

# add user to Samba
echo "\nenter username you want to connect with"
read UserName
sudo adduser --system --no-create-home --disabled-password --gecos "" $UserName > /dev/null 2>&1
sudo passwd -d $UserName > /dev/null 2>&1

sudo smbpasswd -a $UserName
echo "PASS: user created"

# restart Samba
sudo /etc/init.d/smbd restart
sudo /etc/init.d/nmbd restart

# auto mount drive on reboot
sudo echo "/dev/&DiskName /nas auto defaults,user 0 2"
echo "PASS: auto mount drive on reboot\n"