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
echo ">>> Configuration FW"
echo "--------------------------------"
#
firewall-cmd --add-service="nfs3" \
--add-service="rpc-bind" \
--add-service="mountd" \
--permanent
firewall-cmd --reload
#
echo "--------------------------------"
echo ">>> Enable NFS server"
echo "--------------------------------"
#
systemctl enable nfs --now
#
echo "--------------------------------"
echo ">>> Create dir for NFS server and grant privelegies"
echo "--------------------------------"
#
mkdir -p /srv/share/upload
chown -R nfsnobody:nfsnobody /srv/share
chmod 0777 /srv/share/upload
#
echo "--------------------------------"
echo ">>> Export dir of our NFS server"
echo "--------------------------------"
#
cat << EOF > /etc/exports
/srv/share 192.168.56.11/32(rw,sync,root_squash)
EOF
#
exportfs -r
#
echo "--------------------------------"
echo ">>> Check export our dir of NFS server "
echo "--------------------------------"
#
exportfs -s
#
echo "--------------------------------"
echo ">>> Check RPC work and mount points "
echo "--------------------------------"
#
showmount -a 192.168.56.10
#
echo "--------------------------------"
echo ">>> NFS server configuration complited"
echo "--------------------------------"
#
exit 0
#
