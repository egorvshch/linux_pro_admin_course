Домашнее задание "Резервное копирование. Borg"
-----------------------------------------

#### Описание задания

Настроить стенд Vagrant с двумя виртуальными машинами: backup_server и client.

Настроить удаленный бекап каталога /etc c сервера client при помощи borgbackup. Резервные копии должны соответствовать следующим критериям:

директория для резервных копий /var/backup. Это должна быть отдельная точка монтирования. В данном случае для демонстрации размер не принципиален, достаточно будет и 2GB;
репозиторий дле резервных копий должен быть зашифрован ключом или паролем - на ваше усмотрение;
имя бекапа должно содержать информацию о времени снятия бекапа;
глубина бекапа должна быть год, хранить можно по последней копии на конец месяца, кроме последних трех.
Последние три месяца должны содержать копии на каждый день. Т.е. должна быть правильно настроена политика удаления старых бэкапов;
резервная копия снимается каждые 5 минут. Такой частый запуск в целях демонстрации;
написан скрипт для снятия резервных копий. Скрипт запускается из соответствующей Cron джобы, либо systemd timer-а - на ваше усмотрение;
настроено логирование процесса бекапа. Для упрощения можно весь вывод перенаправлять в logger с соответствующим тегом. Если настроите не в syslog, то обязательна ротация логов.

Запустите стенд на 30 минут.

Убедитесь что резервные копии снимаются.

Остановите бекап, удалите (или переместите) директорию /etc и восстановите ее из бекапа.

Для сдачи домашнего задания ожидаем настроенные стенд, логи процесса бэкапа и описание процесса восстановления.

****Формат сдачи ДЗ:**** - vagrant + ansible


****Используемый стек для стенда:****
- VirtualBox 7.0.12,
- Vagrant 2.4.1,
- Vagrant Box "ubuntu/jammy64" (version 20240801.0.0)
- Хостовая система: Ubuntu 22.04.4 LTS
- Ansible 2.10.8

***Запуск стенда:***

```
vagrant up
```

Результатом выполнения команды ```vagrant up``` станет две VM:

- ```borgs``` - backup-сервер borg с IP 192.168.57.160;
     
- ```borgс``` - клиент borg с IP 192.168.57.150.
     
На сервере бекапы складываются в директорию ```/var/backup/``` примонтированной на отдельный диск. 

Лог развертывания настройки виртуальных машин приведен в файле: [output_logs.log](https://github.com/egorvshch/linux_pro_admin_course/blob/main/homework18/output_logs.log)
В данном логе также видно, что  ```/var/backup/``` примонтирована к отдельному диску и таймер бекапа работает..

#### Далее выводы логов, в соответствии с заданием: 

- На клиентской ВМ бекап отрабатывает каждые 5 минут:
```
root@borgc:/home/vagrant# journalctl -u borg-backup.service 
Oct 02 10:19:20 borgc systemd[1]: Starting Borg Backup...
Oct 02 10:19:31 borgc borg[3487]: ------------------------------------------------------------------------------
Oct 02 10:19:31 borgc borg[3487]: Repository: ssh://borg@192.168.57.160/var/backup
Oct 02 10:19:31 borgc borg[3487]: Archive name: etc-2024-10-02_10:19:22
Oct 02 10:19:31 borgc borg[3487]: Archive fingerprint: 6756e41a54d54fbd75f7242a324d57003509e58c2495eca6b2c68812bc2ce7be
Oct 02 10:19:31 borgc borg[3487]: Time (start): Wed, 2024-10-02 10:19:26
Oct 02 10:19:31 borgc borg[3487]: Time (end):   Wed, 2024-10-02 10:19:31
Oct 02 10:19:31 borgc borg[3487]: Duration: 4.86 seconds
Oct 02 10:19:31 borgc borg[3487]: Number of files: 700
Oct 02 10:19:31 borgc borg[3487]: Utilization of max. archive size: 0%
Oct 02 10:19:31 borgc borg[3487]: ------------------------------------------------------------------------------
Oct 02 10:19:31 borgc borg[3487]:                        Original size      Compressed size    Deduplicated size
Oct 02 10:19:31 borgc borg[3487]: This archive:                2.12 MB            945.21 kB            917.03 kB
Oct 02 10:19:31 borgc borg[3487]: All archives:                2.12 MB            944.64 kB            984.23 kB
Oct 02 10:19:31 borgc borg[3487]:                        Unique chunks         Total chunks
Oct 02 10:19:31 borgc borg[3487]: Chunk index:                     664                  690
Oct 02 10:19:31 borgc borg[3487]: ------------------------------------------------------------------------------
Oct 02 10:19:42 borgc systemd[1]: borg-backup.service: Deactivated successfully.
Oct 02 10:19:42 borgc systemd[1]: Finished Borg Backup.
Oct 02 10:19:42 borgc systemd[1]: borg-backup.service: Consumed 10.616s CPU time.
Oct 02 10:24:38 borgc systemd[1]: Starting Borg Backup...
Oct 02 10:24:47 borgc borg[3527]: ------------------------------------------------------------------------------
Oct 02 10:24:47 borgc borg[3527]: Repository: ssh://borg@192.168.57.160/var/backup
Oct 02 10:24:47 borgc borg[3527]: Archive name: etc-2024-10-02_10:24:40
Oct 02 10:24:47 borgc borg[3527]: Archive fingerprint: 1cb82c08a6c255d38955081735a82f309448366f468e211fe30dace5188979db
Oct 02 10:24:47 borgc borg[3527]: Time (start): Wed, 2024-10-02 10:24:46
Oct 02 10:24:47 borgc borg[3527]: Time (end):   Wed, 2024-10-02 10:24:47
Oct 02 10:24:47 borgc borg[3527]: Duration: 1.36 seconds
Oct 02 10:24:47 borgc borg[3527]: Number of files: 700
Oct 02 10:24:47 borgc borg[3527]: Utilization of max. archive size: 0%
Oct 02 10:24:47 borgc borg[3527]: ------------------------------------------------------------------------------
Oct 02 10:24:47 borgc borg[3527]:                        Original size      Compressed size    Deduplicated size
Oct 02 10:24:47 borgc borg[3527]: This archive:                2.12 MB            945.21 kB                568 B
Oct 02 10:24:47 borgc borg[3527]: All archives:                4.24 MB              1.89 MB            984.80 kB
Oct 02 10:24:47 borgc borg[3527]:                        Unique chunks         Total chunks
Oct 02 10:24:47 borgc borg[3527]: Chunk index:                     665                 1380
Oct 02 10:24:47 borgc borg[3527]: ------------------------------------------------------------------------------
Oct 02 10:24:59 borgc systemd[1]: borg-backup.service: Deactivated successfully.
Oct 02 10:24:59 borgc systemd[1]: Finished Borg Backup.
Oct 02 10:24:59 borgc systemd[1]: borg-backup.service: Consumed 10.239s CPU time.
Oct 02 10:29:43 borgc systemd[1]: Starting Borg Backup...
Oct 02 10:29:52 borgc borg[3536]: ------------------------------------------------------------------------------
Oct 02 10:29:52 borgc borg[3536]: Repository: ssh://borg@192.168.57.160/var/backup
Oct 02 10:29:52 borgc borg[3536]: Archive name: etc-2024-10-02_10:29:43
Oct 02 10:29:52 borgc borg[3536]: Archive fingerprint: f5d91c6288b0f20434a2252bf86982ef5c71c3f904587adfc55bd3d8943c6ad4
Oct 02 10:29:52 borgc borg[3536]: Time (start): Wed, 2024-10-02 10:29:50
Oct 02 10:29:52 borgc borg[3536]: Time (end):   Wed, 2024-10-02 10:29:52
Oct 02 10:29:52 borgc borg[3536]: Duration: 1.48 seconds
Oct 02 10:29:52 borgc borg[3536]: Number of files: 700
Oct 02 10:29:52 borgc borg[3536]: Utilization of max. archive size: 0%
Oct 02 10:29:52 borgc borg[3536]: ------------------------------------------------------------------------------
Oct 02 10:29:52 borgc borg[3536]:                        Original size      Compressed size    Deduplicated size
Oct 02 10:29:52 borgc borg[3536]: This archive:                2.12 MB            945.21 kB                569 B
Oct 02 10:29:52 borgc borg[3536]: All archives:                6.37 MB              2.83 MB            985.37 kB
Oct 02 10:29:52 borgc borg[3536]:                        Unique chunks         Total chunks
Oct 02 10:29:52 borgc borg[3536]:                        Unique chunks         Total chunks
Oct 02 10:29:52 borgc borg[3536]: Chunk index:                     666                 2070
Oct 02 10:29:52 borgc borg[3536]: ------------------------------------------------------------------------------
Oct 02 10:30:02 borgc systemd[1]: borg-backup.service: Deactivated successfully.
Oct 02 10:30:02 borgc systemd[1]: Finished Borg Backup.
Oct 02 10:30:02 borgc systemd[1]: borg-backup.service: Consumed 9.532s CPU time.
```

- Бэкапы создаются на сервере:

```
root@borgc:/home/vagrant# borg list borg@192.168.57.160:/var/backup
Enter passphrase for key ssh://borg@192.168.57.160/var/backup: 
etc-2024-10-02_10:19:22              Wed, 2024-10-02 10:19:26 [6756e41a54d54fbd75f7242a324d57003509e58c2495eca6b2c68812bc2ce7be]
etc-2024-10-02_11:01:49              Wed, 2024-10-02 11:01:54 [b7e6553558328469d28b0de8710fa66ed17413bd8b139476eba4f299d0543db0]
root@borgc:/home/vagrant# 
```

- Проверим что в бекапе присутствуют файлы:
```
root@borgc:/home/vagrant# borg list borg@192.168.57.160:/var/backup::etc-2024-10-02_11:01:49 | head -n 15
Enter passphrase for key ssh://borg@192.168.57.160/var/backup: 
drwxr-xr-x root   root          0 Wed, 2024-10-02 10:18:38 etc
-rw-r--r-- root   root       9456 Thu, 2024-09-12 07:18:31 etc/locale.gen
-rw-r--r-- root   root        110 Thu, 2024-09-12 07:17:31 etc/kernel-img.conf
-rw-r--r-- root   root        280 Wed, 2024-10-02 10:13:19 etc/hosts
-rw-r--r-- root   root         37 Thu, 2024-09-12 07:18:30 etc/ec2_version
-rw-r----- root   shadow      648 Thu, 2024-09-12 07:32:57 etc/gshadow-
-rw-r--r-- root   root        112 Thu, 2024-09-12 07:18:34 etc/overlayroot.local.conf
-rw-r--r-- root   root         13 Sun, 2021-08-22 22:00:00 etc/debian_version
drwxr-xr-x root   root          0 Thu, 2024-09-12 07:18:36 etc/default
-rw-r--r-- root   root       1209 Thu, 2024-09-12 07:18:36 etc/default/grub
-rw-r--r-- root   root        284 Thu, 2024-09-12 07:18:30 etc/default/console-setup
-rw-r--r-- root   root       1118 Thu, 2021-11-11 20:42:38 etc/default/useradd
-rw-r--r-- root   root       2691 Wed, 2022-01-19 16:38:12 etc/default/open-iscsi
-rw-r--r-- root   root        150 Thu, 2021-03-18 04:14:10 etc/default/cron
-rw-r--r-- root   root        297 Mon, 2021-06-28 17:15:25 etc/default/dbus

root@borgc:/home/vagrant# borg list borg@192.168.57.160:/var/backup::etc-2024-10-02_11:01:49 | wc -l
Enter passphrase for key ssh://borg@192.168.57.160/var/backup: 
1505
root@borgc:/home/vagrant# 
```
***Остановите бекап, удалите (или переместите) директорию /etc и восстановите ее из бекапа.***

- останавливам бекап:
```
systemctl stop borg-backup.timer
```
- Проверяем и загружаем последний бекап директории ```/etc``` с сервера на клиента:
```
root@borgc:/home/vagrant# borg list borg@192.168.57.160:/var/backup
Enter passphrase for key ssh://borg@192.168.57.160/var/backup: 
etc-2024-10-02_10:19:22              Wed, 2024-10-02 10:19:26 [6756e41a54d54fbd75f7242a324d57003509e58c2495eca6b2c68812bc2ce7be]
etc-2024-10-02_11:07:50              Wed, 2024-10-02 11:07:55 [4b39539565dac3904765dd0c7aad03862901b32f65947716bdfa3add996a64a5]
root@borgc:/home/vagrant#
root@borgc:/home/vagrant#
root@borgc:/home/vagrant# borg extract borg@192.168.57.160:/var/backup::etc-2024-10-02_11:07:50 etc
Enter passphrase for key ssh://borg@192.168.57.160/var/backup: 
root@borgc:/home/vagrant# 
root@borgc:/home/vagrant# ll
total 36
drwxr-x---  6 vagrant vagrant 4096 Oct  2 11:12 ./
drwxr-xr-x  4 root    root    4096 Oct  2 10:12 ../
drwx------  3 vagrant vagrant 4096 Oct  2 10:13 .ansible/
-rw-r--r--  1 vagrant vagrant  220 Sep 12 07:32 .bash_logout
-rw-r--r--  1 vagrant vagrant 3771 Sep 12 07:32 .bashrc
drwx------  2 vagrant vagrant 4096 Oct  2 10:13 .cache/
**drwxr-xr-x 90 root    root    4096 Oct  2 10:18 etc/**
-rw-r--r--  1 vagrant vagrant  807 Sep 12 07:32 .profile
drwx------  2 vagrant vagrant 4096 Oct  2 10:13 .ssh/
root@borgc:/home/vagrant#
```
- Проверяем количество файлов в текущем каталоге ```/etc``` и удаляем его:
```
root@borgc:/home/vagrant# ls /etc/ | wc -l
177
root@borgc:/home/vagrant# rm -rf /etc/
root@borgc:/home/vagrant# ls /etc/ | wc -l
0
```
- Восстанавливаем директорию из бекапа:
```
root@borgc:/home/vagrant# cp -Rf etc/* /etc/
root@borgc:/home/vagrant# ls /etc/ | wc -l
177
root@borgc:/home/vagrant#
```


