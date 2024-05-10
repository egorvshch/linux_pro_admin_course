#!/bin/bash

sudo apt-get update -y
echo "--------------------------------"
echo ">>> Downloads new kernel version"
echo "--------------------------------"
#Загрузка latest kernel version .deb
wget -c https://kernel.ubuntu.com/mainline/v6.8.8/amd64/linux-headers-6.8.8-060808_6.8.8-060808.202404271536_all.deb -O /tmp/linux-headers-6.8.8-060808_6.8.8-060808.202404271536_all.deb
wget -c https://kernel.ubuntu.com/mainline/v6.8.8/amd64/linux-headers-6.8.8-060808-generic_6.8.8-060808.202404271536_amd64.deb -O /tmp/linux-headers-6.8.8-060808-generic_6.8.8-060808.202404271536_amd64.deb
wget -c https://kernel.ubuntu.com/mainline/v6.8.8/amd64/linux-image-unsigned-6.8.8-060808-generic_6.8.8-060808.202404271536_amd64.deb -O /tmp/linux-image-unsigned-6.8.8-060808-generic_6.8.8-060808.202404271536_amd64.deb
wget -c https://kernel.ubuntu.com/mainline/v6.8.8/amd64/linux-modules-6.8.8-060808-generic_6.8.8-060808.202404271536_amd64.deb -O /tmp/linux-modules-6.8.8-060808-generic_6.8.8-060808.202404271536_amd64.deb

# Установка нового ядра
echo "--------------------------------"
echo "Downloads of new kernel complited"
echo "--------------------------------"
echo "--------------------------------"
echo "Install new  kernel"
echo "--------------------------------"
sudo dpkg -i /tmp/*.deb
echo "--------------------------------"
echo "Install latest kernel complited"
echo "--------------------------------"
echo "Start rebooting VM"
echo "--------------------------------"
# Перезагрузка ВМ
shutdown -r now
