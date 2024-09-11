from https://stackoverflow.com/questions/27878880/too-many-storage-controllers-of-the-type-in-vagrant

Vagrant.configure(2) do |config|

    config.vm.box = "ubuntu/trusty64"

    config.vm.provider "virtualbox" do |vb|
        vb.customize ["modifyvm", :id, "--memory", "2048", "--cpus", "1"]
        vb.customize ["storagectl", :id, "--name", "SATA Controller", "--add", "sata"]
    end

    config.vm.define "machine1" do |machine1|

        machine1.vm.hostname = "machine1"

        machine1.vm.provider "virtualbox" do |vb|
            vb.customize ["createhd",  "--filename", "machine1_disk0", "--size", 4096]
            vb.customize ["createhd",  "--filename", "machine1_disk1", "--size", 4096]
            vb.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--port", 1, "--type", "hdd", "--medium", "machine1_disk0.vdi"]
            vb.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--port", 2, "--type", "hdd", "--medium", "machine1_disk1.vdi"]
        end

        machine1.vm.network "private_network", ip: "192.168.10.10"
        machine1.vm.network "private_network", ip: "192.168.10.15"
    end

    config.vm.define "machine2" do |machine2|

        machine2.vm.hostname = "machine2"

        machine2.vm.provider "virtualbox" do |vb|
            vb.customize ["createhd",  "--filename", "machine2_disk0", "--size", 4096]
            vb.customize ["createhd",  "--filename", "machine2_disk1", "--size", 4096]
            vb.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--port", 1, "--type", "hdd", "--medium", "machine2_disk0.vdi"]
            vb.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--port", 2, "--type", "hdd", "--medium", "machine2_disk1.vdi"]
        end

        machine2.vm.network "private_network", ip: "192.168.10.20"
        machine2.vm.network "private_network", ip: "192.168.10.25"
    end

    config.vm.define "machine3" do |machine3|

        machine3.vm.hostname = "machine3"

        machine3.vm.provider "virtualbox" do |vb|
            vb.customize ["createhd",  "--filename", "machine3_disk0", "--size", 4096]
            vb.customize ["createhd",  "--filename", "machine3_disk1", "--size", 4096]
            vb.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--port", 1, "--type", "hdd", "--medium", "machine3_disk0.vdi"]
            vb.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--port", 2, "--type", "hdd", "--medium", "machine3_disk1.vdi"]
        end

        machine3.vm.network "private_network", ip: "192.168.10.30"
    end

    config.vm.define "machine4" do |machine4|

        machine4.vm.hostname = "machine4"

        machine4.vm.provider "virtualbox" do |vb|
            vb.customize ["createhd",  "--filename", "machine4_disk0", "--size", 4096]
            vb.customize ["createhd",  "--filename", "machine4_disk1", "--size", 4096]
            vb.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--port", 1, "--type", "hdd", "--medium", "machine4_disk0.vdi"]
            vb.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--port", 2, "--type", "hdd", "--medium", "machine4_disk1.vdi"]
        end

        machine4.vm.network "private_network", ip: "192.168.10.40"
    end

    config.vm.define "machine5" do |machine5|

        machine5.vm.hostname = "machine5"

        machine5.vm.provider "virtualbox" do |vb|
            vb.customize ["createhd",  "--filename", "machine5_disk0", "--size", 4096]
            vb.customize ["createhd",  "--filename", "machine5_disk1", "--size", 4096]
            vb.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--port", 1, "--type", "hdd", "--medium", "machine5_disk0.vdi"]
            vb.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--port", 2, "--type", "hdd", "--medium", "machine5_disk1.vdi"]
        end

        machine5.vm.network "private_network", ip: "192.168.10.50"
    end

    config.vm.define "machine6" do |machine6|

        machine6.vm.hostname = "machine6"

        machine6.vm.provider "virtualbox" do |vb|
            vb.customize ["createhd",  "--filename", "machine6_disk0", "--size", 4096]
            vb.customize ["createhd",  "--filename", "machine6_disk1", "--size", 4096]
            vb.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--port", 1, "--type", "hdd", "--medium", "machine6_disk0.vdi"]
            vb.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--port", 2, "--type", "hdd", "--medium", "machine6_disk1.vdi"]
        end

        machine6.vm.network "private_network", ip: "192.168.10.60"
    end

    config.vm.define "machine7" do |machine7|

        machine7.vm.hostname = "machine7"

        machine7.vm.provider "virtualbox" do |vb|
            vb.customize ["createhd",  "--filename", "machine7_disk0", "--size", 4096]
            vb.customize ["createhd",  "--filename", "machine7_disk1", "--size", 4096]
            vb.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--port", 1, "--type", "hdd", "--medium", "machine7_disk0.vdi"]
            vb.customize ["storageattach", :id, "--storagectl", "SATA Controller", "--port", 2, "--type", "hdd", "--medium", "machine7_disk1.vdi"]
        end

        machine7.vm.network "private_network", ip: "192.168.10.70"
    end

end
