# README - Add a hard disk (block device) to a vagrant box

This original from https://gist.github.com/drmalex07/e9f543766eea14ececc6a8c668921871#file-readme-vagrant-add-disk-md

### Create disk image

Create using the VDI format (will allocate space lazily). For example:

    vboxmanage createmedium --filename $PWD/disk-2.vdi --size 1024 --format VDI 
   
### Configure VM

Create the `Vagrantfile` and use additional configuration in the virtualbox-specific part. For example:

```ruby
Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/xenial64"

  config.vm.network "private_network", ip: "10.0.4.91"

  # config.vm.synced_folder "../data", "/vagrant_data"
  config.vm.synced_folder ".", "/vagrant", type: "rsync"

  config.vm.provider "virtualbox" do |vb|
     vb.name = "ubuntu-16_04-1"
     vb.memory = 512
     
     # Attach another hard disk 
     # Note: Create a hard disk image: vboxmanage createmedium --filename $PWD/disk-2.vdi --size 1024 --format VDI 
     
     # see https://www.virtualbox.org/manual/ch08.html#vboxmanage-storageattach
     vb.customize [ 'storageattach', 
        :id, # the id will be replaced (by vagrant) by the identifier of the actual machine
        '--storagectl', 'SCSI Controller', # one of `SATA Controller` or `SCSI Controller` or `IDE Controller`; 
                                           # obtain the right name using: vboxmanage showvminfo  
        '--port', 2,     # port of storage controller. Note that port #0 is for 1st hard disk, so start numbering from 1.
        '--device', 0,   # the device number inside given port (usually is #0) 
        '--type', 'hdd', 
        '--medium', File.absolute_path('disk-2.vdi')] # path to our VDI image
            
  end

  #config.vm.provision "shell", inline: <<-SHELL
  #  sudo apt-get update
  #SHELL
end
```
If name of storage controller is not recognized, run `vboxmanage showvminfo` on a VM of the same base image (e.g. here is `ubuntu/xenial64`) and note the names of installed controllers. 
