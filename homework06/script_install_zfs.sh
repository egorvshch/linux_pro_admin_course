#!/bin/bash

#
echo "--------------------------------"
echo ">>> create and provisioning zfs system on this mashine"
echo "--------------------------------"
#
echo "--------------------------------"
echo ">>> install zfs repo"
echo "--------------------------------"
#
sudo su
yum install -y http://download.zfsonlinux.org/epel/zfs-release.el7_8.noarch.rpm
#
echo "--------------------------------"
echo ">>> import gpg key"
echo "--------------------------------"
#
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-zfsonlinux
#
echo "--------------------------------"
echo ">>> install DKMS style packages for correct work ZFS"
echo "--------------------------------"
#
yum install -y epel-release kernel-devel zfs
#
echo "--------------------------------"
echo ">>> change ZFS repo"
echo "--------------------------------"
#
yum-config-manager --disable zfs
yum-config-manager --enable zfs-kmod
yum install -y zfs
#
echo "--------------------------------"
echo ">>> Add kernel module zfs"
echo "--------------------------------"
#
modprobe zfs
#
echo "--------------------------------"
echo ">>> install wget"
echo "--------------------------------"
#
yum install -y wget
#
exit
#
echo "--------------------------------"
echo ">>> Complete success"
echo "--------------------------------"
#