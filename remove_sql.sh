#!/bin/bash
shopt -s xpg_echo

# check if run with sudo
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

sudo apt remoce --purge mysql* -y > /dev/null 2>&1
sudo apt purge -mysql* -y > /dev/null 2>&1
sudo apt autoremove -y > /dev/null 2>&1
sudo apt autoclean -y > /dev/null 2>&1
sudo apt remove dbconfig-mysql -y > /dev/null 2>&1
sudo apt dist-upgrade -y > /dev/null 2>&1

echo "PASS: mySQL server removed"