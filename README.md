# Bash script to automate install/setup process (for Debian-based linux only)
- [QEMU guest agent](https://github.com/P-CAST/bash_script_for_homelab/new/main?readme=1#qemu-guest-agent-install)
- [Samba](https://github.com/P-CAST/bash_script_for_homelab/new/main?readme=1#samba-installsetup-explain)

---

## QEMU guest agent install
This task is simple, what's it do is install package [qemu-guest-agent](https://packages.ubuntu.com/bionic/qemu-guest-agent) like ```apt-get install qemu-guest-agent```, but advantage is it will enable service without you touching it again.

---

## Samba install/setup explain
First of all, [Samba](https://ubuntu.com/server/docs/samba-file-server) is a service that will create network share on folder you selected displayed to device on network, and can be access via username and password you created.

To make setup process more quickly and simple I wrote shell script to automate all the basic setup process, if you're super user/require additional config you might consider add your own config to config file.

> Process walkthrough
>> - install update and required package (NTFS,exFat,Samba itself)
>> - create directory that will be shared (this will create folder under root directory)
>> - disk that will be used/mounted to created folder (Choose carefully and aware of drive sub-partition, it will not be displayed, if you need to view, use ```lsblk```)
>> - select to wipe disk or not (In case of reusing drive that's still got data on it)
>> - server name, just whatever you wanna called it
>> - create user that will be used to access server

and your service will be up and running. *run and config with your own risk
