# -*- mode: ruby -*-
# vi: set ft=ruby :

cpu = "1"
memory = "2048"
hostname = "demo"
vm_name = "Sample"
ip = "192.168.10.10"

disk_size = "20480"
disk = "./VirtualDisk.vdi"

Vagrant.configure(2) do |config|
  config.vm.define "test" do |test|

    test.vm.box = "ubuntu/trusty64"
    test.vm.hostname = "#{hostname}"
    test.vm.network :private_network, ip: "#{ip}"

    test.vm.provider "virtualbox" do |vb|
      unless File.exist?(disk)
        vb.customize ["createhd", "--filename", disk, "--variant", "Fixed", "--size", disk_size]
      end
      vb.customize ["modifyvm", :id, "--name", vm_name, "--memory", memory, "--cpus", cpu]
      vb.customize ["storageattach", :id, "--storagectl", "SATAController", "--port", 1, "--device", 0, "--type", "hdd", "--medium", disk]
    end
  end
end
