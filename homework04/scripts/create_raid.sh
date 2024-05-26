#!/bin/bash

echo "--------------------------------"
echo ">>> Create RAID 5 and 1"
echo "--------------------------------"
sudo su
mdadm --zero-superblock --force /dev/sd{b,c,d,e,f}
mdadm --create --verbose /dev/md0 -l 5 -n 3 /dev/sd{b,c,d}
#
mdadm --create --verbose --metadata=0.90 /dev/md1 -l 1 -n 2 /dev/sd{e,f}
#
mkdir /etc/mdadm
echo "DEVICE partitions" > /etc/mdadm/mdadm.conf
mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' >> /etc/mdadm/mdadm.conf
#
echo "--------------------------------"
echo ">>> Create GPT and Partition on RAID 5"
echo "--------------------------------"
#
parted -s /dev/md0 mklabel gpt
#
parted /dev/md0 mkpart primary ext4 0% 20%
parted /dev/md0 mkpart primary ext4 20% 40%
parted /dev/md0 mkpart primary ext4 40% 60%
parted /dev/md0 mkpart primary ext4 60% 80%
parted /dev/md0 mkpart primary ext4 80% 100%
#
echo "--------------------------------"
echo ">>> Create FileSystem on partition of RAID 5"
echo "--------------------------------"
#
for i in $(seq 1 5); do sudo mkfs.ext4 /dev/md0p$i; done
#
echo "--------------------------------"
echo ">>> Mount FileSystem on partition of RAID 5"
echo "--------------------------------"
mkdir -p /raid/part{1,2,3,4,5}
for i in $(seq 1 5); do mount /dev/md0p$i /raid/part$i; done
#
echo "--------------------------------"
echo ">>> Create FileSystem on RAID 1"
echo "--------------------------------"
#
mkfs.ext4 /dev/md1
#
echo "--------------------------------"
echo ">>> Mount FileSystem on RAID 1"
echo "--------------------------------"
mkdir -p /raid1/part1
mount /dev/md1 /raid1/part1
#
exit
#
echo "--------------------------------"
echo ">>> Complete success"
echo "--------------------------------"
#
