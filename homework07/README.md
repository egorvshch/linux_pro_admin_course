Домашнее задание по NFS
-----------------------------------------
В данном репозитории содержится Vagrant стенд из 2х VM, одна из которых - сервер NFS и вторая - клиент NFS.
На сервере экспортирована директория /srv/share/ с вложенной поддиректорией upload с правами на запись в нее.

На клиенте  монтирование и работа NFS организована с использованием NFSv3 по протоколу UDP

Запуск, настройка NFS, firewall и экспорт директории на стороне сервера выполняется с использованием скрипта nfss_script.sh

Запуск, настройка NFS, firewall, автоматического монтирования экспортированной директории на стороне клиента выполняется с использованием скрипта nfsс_script.sh


**Стек:**
- VirtualBox 7.0.12, 
- Vagrant 2.4.1, 
- Vagrant Box centos/7 v2004.01
- хостовая система: Ubuntu 22.04

*Запуск стенда:*

   ```
vagrant up
vagrant ssh nfsс #For connection to nfs server VM
vagrant ssh nfsс #For connection to nfs client VM
   ```
   
   
   
   - [Старт vagrant и исходный статус файловой системы](https://github.com/egorvshch/linux_pro_admin_course/blob/main/homework05/command%20execution%20logs/start%20vagrant.txt)