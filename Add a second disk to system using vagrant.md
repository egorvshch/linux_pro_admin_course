gist.github.com/leifg/4713995
from
https://stackoverflow.com/questions/27501019/vb-customize-storageattach-mounts-my-disk-first-time-but-changes-are-lost-aft

Vagrant.require_version ">= 1.4.3"
VAGRANTFILE_API_VERSION = "2"

disk = './secondDisk.vdi' 
BOX_NAME="test"


Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.define :master do |master|
        master.vm.box = "centos65"
        master.vm.box_url = "https://github.com/2creatives/vagrant-centos/releases/download/v6.5.1/centos65-x86_64-20131205.box"
        master.vm.provider "virtualbox" do |v|
          v.customize ["modifyvm", :id, "--memory", "4196"]
          v.name = BOX_NAME
        end
        master.vm.network :private_network, ip: "192.168.33.10"
        master.vm.hostname = BOX_NAME
    end

    config.vm.synced_folder(".", "/vagrant",
        :owner => "vagrant",
        :group => "vagrant",
        :mount_options => ['dmode=777','fmode=777']
    )

    # create the second disk and attach it
    config.vm.provider "virtualbox" do |vb|
        unless File.exist?(disk)
            vb.customize ['createhd', '--filename', disk, '--variant', 'Fixed', '--size', 1 * 1024]
        end

        vb.customize ['storageattach', :id,  '--storagectl', 'SATA', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', disk]
    end

    # NEW - invoke script which  partitions the new disk (/dev/sdb) 
    # and create mount directives in /etc/fstab
    #config.vm.provision :shell, path: "bootstrap.sh"  
    config.vm.provision "shell" do |shell|
        shell.inline = "sudo /vagrant/bootstrap.sh"  
    end
end

/vagrant/bootstrap.sh
#!/bin/bash  -x

#   configure and mount second disk 
#
yum install -y parted
parted /dev/sdb mklabel msdos
parted /dev/sdb mkpart primary 512 100%
mkfs.xfs /dev/sdb1
mkdir /mnt/disk
echo `blkid /dev/sdb1 | awk '{print$2}' | sed -e 's/"//g'` /mnt/disk   xfs   noatime,nobarrier   0   0 >> /etc/fstab
mount /mnt/disk
