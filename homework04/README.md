This repository contains a Vagrantfile and scripts that create a VM on Centos 7 with two RAID arrays: RAID 5 (sdb, sdc, sdd disks) and RAID 1 (sde, sdf disks).
RAID5 disks are divided into 5 partitions, on which an ext4 file system is created and /raid/partX/ directories are mounted.
For RAID1, an ext4 file system was also created and the /raid1/part1/ directory was mounted.