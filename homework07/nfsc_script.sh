#!/bin/bash

#
echo "--------------------------------"
echo ">>> Install nfs-utils"
echo "--------------------------------"
#
sudo -i
yum -y install nfs-utils
#
echo "--------------------------------"
echo ">>> Enable FW"
echo "--------------------------------"
#
systemctl enable firewalld --now
#
echo "--------------------------------"
echo ">>> Configuration of mount NFS dir to /mnt into fstab "
echo "--------------------------------"
#
echo "192.168.56.10:/srv/share/ /mnt  nfs vers=3,proto=udp,noauto,x-systemd.automount 0 0" >> /etc/fstab
#
echo "--------------------------------"
echo ">>> Reloading systemctl-daemon"
echo "--------------------------------"
#
systemctl daemon-reload
systemctl restart remote-fs.target
#
echo "--------------------------------"
echo ">>> Check mount NFS dir "
echo "--------------------------------"
#
cd /mnt/
mount | grep mnt
#
echo "--------------------------------"
echo ">>> Check RPC work and mount points "
echo "--------------------------------"
#
showmount -a 192.168.56.10
#
echo "--------------------------------"
echo ">>> NFS client configuration complited"
echo "--------------------------------"
#
exit 0
#
