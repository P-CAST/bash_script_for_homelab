#!/bin/bash

# update & upgrade
sudo apt-get -qq update && sudo apt-get upgrade -y > /dev/null 2>&1
echo "PASS: update & upgrade linux package"

# install qemu-guest
sudo apt-get install qemu-guest-agent -y > /dev/null 2>&1
echo "PASS: install qemu-guest-agent"

# start service
sudo systemctl start qemu-guest-agent > /dev/null 2>&1
echo "PASS: start qemu-guest-agent"