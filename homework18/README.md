Домашнее задание "Пользователи и группы. Авторизация и аутентификация_РАМ"
-----------------------------------------

#### Описание задания

1.  Запретить всем пользователям кроме группы admin логин в выходные (суббота и воскресенье), без учета праздников.

****Формат сдачи:****
Vagrantfile + ansible

****Используемый стек для стенда:****
- VirtualBox 7.0.12,
- Vagrant 2.4.1,
- Vagrant Box "ubuntu/jammy64" (version v20240823.0.1)
- Хостовая система: Ubuntu 22.04.4 LTS
- Ansible 2.10.8

***Запуск стенда:***

```
vagrant up
vagrant ssh
```

Результатом выполнения команды ```vagrant up``` станет созданная виртуальная машина с IP 192.168.57.11:
- с добавленными пользователями ```otus```, ```otusadm```;
- с созданной группой  ```admin```;
- в группу ```admin``` добавлены пользователи  ```otusadm```,  ```root``` и  ```vagrant```;
- всем пользователям кроме группы ```admin``` будет запрещено логин в выходные (суббота и воскресенье), без учета праздников.


Описание решения:
----------
1. Настройки для запуска стенда ВМ Vagrant расположены в [Vagrantfile](https://github.com/egorvshch/linux_pro_admin_course/blob/main/homework16/Vagrantfile)
2. В секции ```provision "shell"``` для удобства  SSH выполнена настройка разрешения аутентификация пользователя по паролю:
```
      box.vm.provision "shell", inline: <<-SHELL
          sed -i 's/^PasswordAuthentication.*$/PasswordAuthentication yes/' /etc/ssh/sshd_config
          sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config.d/*.conf
          systemctl restart sshd.service
         SHELL
```    
3. В секции ```provision "ansible"``` выполняется настройка всей логики выполнения задания с использованием Ansible:
``` 
    config.vm.provision "ansible" do |ansible|
           ansible.playbook = "add_user_and_group_and_PAM.yml"
``` 
Playbook-файл [add_user_and_group_and_PAM.yml](https://github.com/egorvshch/linux_pro_admin_course/blob/main/homework16/add_user_and_group_and_PAM.yml) содержит следующие задачи:

* ``` Create group``` cоздает группу ``` admin```:
``` 
- name: Create users and groups
  hosts: pamtest
  become: 'yes'
  tasks:
   - name: Create group
     group:
      name: admin
      state: present
 ```
* ``` Create user otusadm ``` cоздает пользователя  ```otusadm``` с паролем ```Otus2022!```:
 ```
   - name: Create user otusadm
     user:
        name: otusadm
        password: "{{ 'Otus2022!' | password_hash('sha512') }}"
        shell: /bin/bash
        createhome: yes
        state: present
 ```
* ``` Create user otusadm ``` cоздает пользователя  ```otus``` с паролем ```Otus2022!```:
 ```
 - name: Create user otus
     user:
        name: otus
        password: "{{ 'Otus2022!' | password_hash('sha512') }}"
        shell: /bin/bash
        createhome: yes
        state: present
 ```
* ``` Adding root to group admin ``` добавляет пользователей ```otusadm```,  ```root``` и  ```vagrant``` в группу  ``` admin```:
 ```
   - name: Adding root to group admin
     user:
        name: "{{ item }}"
        groups: admin
        append: yes
     loop:
        - root
        - otusadm
        - vagrant
 ```
* ``` Copy script file to VM ``` копирует скрипт   [login.sh](https://github.com/egorvshch/linux_pro_admin_course/blob/main/homework16/script/login.sh) в директорию ```/usr/local/bin/login.sh``` с правом на исполнения, проверяющий принадлежность пользователя на принадлежность группе  ```admin``` и день подключения (выходной или нет):
 ```
   - name: Copy script file to VM
     copy:
      src: script/login.sh
      dest: /usr/local/bin/login.sh
      mode: '0755'
 ```
* ``` Restrict Access through sshdCommand ``` настройка модуля PAM  ```pam_exec.so``` для sshd и проверки подключаемого пользователя при аутентификации в соответствии с скриптом [login.sh](https://github.com/egorvshch/linux_pro_admin_course/blob/main/homework16/script/login.sh). Данная таска добавляет соответствующую строку в файл  ```/etc/pam.d/sshd ```:
 ```
   - name: Restrict Access through sshdCommand
     lineinfile:
      path: /etc/pam.d/sshd
      regexp: 'auth'
      firstmatch: yes
      line: 'auth  required  pam_exec.so debug /usr/local/bin/login.sh'
      state: present
 ```  
### Результаты: 
- Запускаем стенд: ```vagrant up```, в логе видно что создалась ВМ c соответствующими ```provisioning```:

```  
root@evengtest:/home/eve/homework16# vagrant up
Bringing machine 'pamtest' up with 'virtualbox' provider...
==> pamtest: Importing base box 'ubuntu/jammy64'...
==> pamtest: Matching MAC address for NAT networking...
==> pamtest: Setting the name of the VM: homework16_pamtest_1725223355137_61282
==> pamtest: Fixed port collision for 22 => 2222. Now on port 2202.
==> pamtest: Clearing any previously set network interfaces...
==> pamtest: Preparing network interfaces based on configuration...
    pamtest: Adapter 1: nat
    pamtest: Adapter 2: hostonly
==> pamtest: Forwarding ports...
    pamtest: 22 (guest) => 2202 (host) (adapter 1)
==> pamtest: Running 'pre-boot' VM customizations...
==> pamtest: Booting VM...
==> pamtest: Waiting for machine to boot. This may take a few minutes...
    pamtest: SSH address: 127.0.0.1:2202
    pamtest: SSH username: vagrant
    pamtest: SSH auth method: private key
    pamtest: Warning: Connection reset. Retrying...
    pamtest: Warning: Connection reset. Retrying...
    pamtest: 
    pamtest: Vagrant insecure key detected. Vagrant will automatically replace
    pamtest: this with a newly generated keypair for better security.
    pamtest: 
    pamtest: Inserting generated public key within guest...
    pamtest: Removing insecure key from the guest if it's present...
    pamtest: Key inserted! Disconnecting and reconnecting using new SSH key...
==> pamtest: Machine booted and ready!
==> pamtest: Checking for guest additions in VM...
    pamtest: The guest additions on this VM do not match the installed version of
    pamtest: VirtualBox! In most cases this is fine, but in rare cases it can
    pamtest: prevent things such as shared folders from working properly. If you see
    pamtest: shared folder errors, please make sure the guest additions within the
    pamtest: virtual machine match the version of VirtualBox you have installed on
    pamtest: your host and reload your VM.
    pamtest: 
    pamtest: Guest Additions Version: 6.0.0 r127566
    pamtest: VirtualBox Version: 6.1
==> pamtest: Setting hostname...
==> pamtest: Configuring and enabling network interfaces...
==> pamtest: Running provisioner: ansible...
Vagrant gathered an unknown Ansible version:


and falls back on the compatibility mode '1.8'.

Alternatively, the compatibility mode can be specified in your Vagrantfile:
https://www.vagrantup.com/docs/provisioning/ansible_common.html#compatibility_mode

    pamtest: Running ansible-playbook...

PLAY [Create users and groups] *************************************************

TASK [Gathering Facts] *********************************************************
ok: [pamtest]

TASK [Create group] ************************************************************
ok: [pamtest]

TASK [Create user otusadm] *****************************************************
changed: [pamtest]

TASK [Create user otus] ********************************************************
changed: [pamtest]

TASK [Adding root to group admin] **********************************************
changed: [pamtest] => (item=root)
changed: [pamtest] => (item=otusadm)
changed: [pamtest] => (item=vagrant)

TASK [Copy script file to VM] **************************************************
changed: [pamtest]

TASK [Restrict Access through sshdCommand] *************************************
changed: [pamtest]

PLAY RECAP *********************************************************************
pamtest                    : ok=7    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

==> pamtest: Running provisioner: shell...
    pamtest: Running: inline script
root@evengtest:/home/eve/homework16# 

```
 - Пробуем подключиться под пользователем, относящегося к группе ```admin```, обращаем внимание, что день недели воскресение ```Sun Sep  1```:
```
root@evengtest:/home/eve/homework16# ssh otusadm@192.168.57.11
The authenticity of host '192.168.57.11 (192.168.57.11)' can't be established.
ED25519 key fingerprint is SHA256:ihGhH0rRQDh4nCFJWhvlNwQLOam0C5UTZFIb8i7L0E8.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '192.168.57.11' (ED25519) to the list of known hosts.
otusadm@192.168.57.11's password: 
otusadm@192.168.57.11's password: 
Welcome to Ubuntu 22.04.4 LTS (GNU/Linux 5.15.0-119-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Sun Sep  1 20:47:03 UTC 2024

  System load:  0.45              Processes:               109
  Usage of /:   3.7% of 38.70GB   Users logged in:         0
  Memory usage: 20%               IPv4 address for enp0s3: 10.0.2.15
  Swap usage:   0%


Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


The list of available updates is more than a week old.
To check for new updates run: sudo apt update
New release '24.04.1 LTS' available.
Run 'do-release-upgrade' to upgrade to it.



The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.
```
Т.е. подключение выполнено успешно в выходной день под пользователем, относящегося к группе ```admin``` в соотвтетствии с задачей.

****Проверяем, что все настройки в рамках тасков Ansible применились успешно:****
- Созданы соответствующие пользователи ```otusadm``` и ```otus```:
```
otusadm@pamtest:~$ sudo cat /etc/shadow | grep otus
otusadm:$6$AxwaX9rrYpdfq6XS$h83h4aGL7PFGMO4IITr5TpWeYpAYi08Gmv5mdoM9Kmd04H2Bgi9nzTCNis9TdwN80V0SmGFyJBtiY2uuqFa2Z.:19967:0:99999:7:::
otus:$6$ev9bI7VLZ9rhegjm$CrtVuhtYgKWskZRAbpswpLPE4fHS3a9RjiePX0wCL.wwjO4x7P4FloIzDZEi9UFk9S2d5i/c54AVt1EN813fL.:19967:0:99999:7:::
otusadm@pamtest:~$ 
```
- Создана группа и принадлежность к ней пользователей ```root```,```otusadm```,```vagrant```:
```
otusadm@pamtest:~$ sudo cat /etc/group | grep otus
admin:x:118:root,otusadm,vagrant
otusadm:x:1002:
otus:x:1003:
otusadm@pamtest:~$ 
```
- Проверим, что файл скрипта [login.sh](https://github.com/egorvshch/linux_pro_admin_course/blob/main/homework16/script/login.sh) добавлен в соответствующую директорию и является исполняемым:
```
root@pamtest:/home/vagrant# ll /usr/local/bin/login.sh
-rwxr-xr-x 1 root root 719 Sep  1 20:45 /usr/local/bin/login.sh*
root@pamtest:/home/vagrant# 
```
- Настроен модуль PAM для проверки аутентификации с использованием логики скрипта [login.sh](https://github.com/egorvshch/linux_pro_admin_course/blob/main/homework16/script/login.sh):
```
otusadm@pamtest:~$ cat /etc/pam.d/sshd 
# PAM configuration for the Secure Shell service

auth  required  pam_exec.so debug /usr/local/bin/login.sh
@include common-auth

# Disallow non-root logins when /etc/nologin exists.
account    required     pam_nologin.so
...
```
- Проверим, что пользователь не относящийся к группе ```admin``` не имеет доступа в воскресный день, для этого попробуем подключиться к ВМ под пользователем ```otus```:

```
root@evengtest:/home/eve/homework16# ssh otus@192.168.57.11
otus@192.168.57.11's password: 
Permission denied, please try again.
```
- При этом в ```auth.log``` видим, что отработал модуль ```pam_exec.so``` скрипт  ```login.sh``` c результатом ```exit code 1```, т.е. доступ запрещен:

```
otusadm@pamtest:~$ sudo cat /var/log/auth.log 
...
Sep  1 20:50:10 ubuntu-jammy sshd[2591]: pam_exec(sshd:auth): Calling /usr/local/bin/login.sh ...
Sep  1 20:50:10 ubuntu-jammy sshd[2589]: pam_exec(sshd:auth): /usr/local/bin/login.sh failed: exit code 1
Sep  1 20:50:12 ubuntu-jammy sshd[2589]: Failed password for otus from 192.168.57.1 port 37884 ssh2
Sep  1 20:50:18 ubuntu-jammy sshd[2598]: pam_exec(sshd:auth): Calling /usr/local/bin/login.sh ...
Sep  1 20:50:18 ubuntu-jammy sshd[2589]: pam_exec(sshd:auth): /usr/local/bin/login.sh failed: exit code 1
Sep  1 20:50:21 ubuntu-jammy sshd[2589]: Failed password for otus from 192.168.57.1 port 37884 ssh2
Sep  1 20:50:48 ubuntu-jammy sshd[2605]: pam_exec(sshd:auth): Calling /usr/local/bin/login.sh ...
Sep  1 20:50:48 ubuntu-jammy sshd[2603]: Accepted password for otusadm from 192.168.57.1 port 50074 ssh2
Sep  1 20:50:48 ubuntu-jammy sshd[2603]: pam_unix(sshd:session): session opened for user otusadm(uid=1002) by (uid=0)
Sep  1 20:50:48 ubuntu-jammy systemd-logind[730]: New session 9 of user otusadm.
Sep  1 20:50:48 ubuntu-jammy systemd: pam_unix(systemd-user:session): session opened for user otusadm(uid=1002) by (uid=0)
Sep  1 20:50:55 ubuntu-jammy sshd[2685]: pam_exec(sshd:auth): Calling /usr/local/bin/login.sh ...
Sep  1 20:50:55 ubuntu-jammy sshd[2589]: pam_exec(sshd:auth): /usr/local/bin/login.sh failed: exit code 1
Sep  1 20:50:57 ubuntu-jammy sshd[2589]: Failed password for otus from 192.168.57.1 port 37884 ssh2
Sep  1 20:50:58 ubuntu-jammy sshd[2589]: Connection closed by authenticating user otus 192.168.57.1 port 37884 [preauth]
...
```
- Проверим, что пользователь не относящийся к группе ```admin``` имеет доступ в рабочий день, для этого попробуем подключиться к ВМ под пользователем ```otus``` в рабочий день (обратите внимание на день и дату ``` Mon Sep  2```):
   
```
root@evengtest:/home/eve/homework16# ssh otus@192.168.57.11
otus@192.168.57.11's password: 
Permission denied, please try again.
otus@192.168.57.11's password: 
Welcome to Ubuntu 22.04.4 LTS (GNU/Linux 5.15.0-119-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Mon Sep  2 04:02:22 UTC 2024

  System load:  0.0               Processes:               105
  Usage of /:   3.9% of 38.70GB   Users logged in:         1
  Memory usage: 21%               IPv4 address for enp0s3: 10.0.2.15
  Swap usage:   0%


Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


The list of available updates is more than a week old.
To check for new updates run: sudo apt update
New release '24.04.1 LTS' available.
Run 'do-release-upgrade' to upgrade to it.



The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

otus@pamtest:~$ 
```
Пользователь подключился успешно. Т.е. условия задачи выполнены.
