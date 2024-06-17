
Домашнее задание по ZFS
-----------------------------------------
В данном репозитории содержатся файлы конфигурации стенда и результаты выполнения домашнего задания по ZFS

**Используемый стек:**
- VirtualBox 7.0.12, 
- Vagrant 2.4.1, 
- Vagrant Box centos/7 v2004.01
- хостовая система: Ubuntu 22.04

*Запуск стенда:*

   ```
vagrant up
vagrant ssh
   ```

***Ход выполнения заданий:***
-----------------------------------------

**1. Определение алгоритма с наилучшим сжатием, которые поддерживает zfs (gzip,zle, lzjb, lz4)**
 
**Порядок настройки и результаты:**

1.1 Cоздание 4х файловых систем и применение различных алгоритмов сжатия;
<details>
<summary>- Проверка списка всех дисков, которые доступны в виртуальной машине: lsblk</summary>

Доступно 8 дисков:

   ```[vagrant@zfs ~]$ sudo -i
[root@zfs ~]# lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda      8:0    0   40G  0 disk 
└─sda1   8:1    0   40G  0 part /
sdb      8:16   0  512M  0 disk 
sdc      8:32   0  512M  0 disk 
sdd      8:48   0  512M  0 disk 
sde      8:64   0  512M  0 disk 
sdf      8:80   0  512M  0 disk 
sdg      8:96   0  512M  0 disk 
sdh      8:112  0  512M  0 disk 
sdi      8:128  0  512M  0 disk 
   ```
  </details>
<details>
<summary>- Создаём 4 пула из двух дисков в режиме RAID 1:</summary>

   ```[root@zfs ~]# zpool create otus1 mirror /dev/sdb /dev/sdc
[root@zfs ~]# zpool create otus2 mirror /dev/sdd /dev/sde
[root@zfs ~]# zpool create otus3 mirror /dev/sdf /dev/sdg
[root@zfs ~]# zpool create otus4 mirror /dev/sdh /dev/sdi
   ```
  </details>


<details>
<summary>- Проверка статуса и информации о zpool'ах: zpool status и zpool list</summary>
<details>
<summary>[root@zfs ~]# zpool list</summary>
   
  ```[root@zfs ~]# zpool list
NAME    SIZE  ALLOC   FREE  CKPOINT  EXPANDSZ   FRAG    CAP  DEDUP    HEALTH  ALTROOT
otus1   480M   106K   480M        -         -     0%     0%  1.00x    ONLINE  -
otus2   480M  91.5K   480M        -         -     0%     0%  1.00x    ONLINE  -
otus3   480M  91.5K   480M        -         -     0%     0%  1.00x    ONLINE  -
otus4   480M   106K   480M        -         -     0%     0%  1.00x    ONLINE  -
   ```
  </details>
<details>
<summary>[root@zfs ~]# zpool status</summary>
   
  ```[root@zfs ~]# zpool status
  pool: otus1
 state: ONLINE
  scan: none requested
config:

	NAME        STATE     READ WRITE CKSUM
	otus1       ONLINE       0     0     0
	  mirror-0  ONLINE       0     0     0
	    sdb     ONLINE       0     0     0
	    sdc     ONLINE       0     0     0

errors: No known data errors

  pool: otus2
 state: ONLINE
  scan: none requested
config:

	NAME        STATE     READ WRITE CKSUM
	otus2       ONLINE       0     0     0
	  mirror-0  ONLINE       0     0     0
	    sdd     ONLINE       0     0     0
	    sde     ONLINE       0     0     0

errors: No known data errors

  pool: otus3
 state: ONLINE
  scan: none requested
config:

	NAME        STATE     READ WRITE CKSUM
	otus3       ONLINE       0     0     0
	  mirror-0  ONLINE       0     0     0
	    sdf     ONLINE       0     0     0
	    sdg     ONLINE       0     0     0

errors: No known data errors

  pool: otus4
 state: ONLINE
  scan: none requested
config:

	NAME        STATE     READ WRITE CKSUM
	otus4       ONLINE       0     0     0
	  mirror-0  ONLINE       0     0     0
	    sdh     ONLINE       0     0     0
	    sdi     ONLINE       0     0     0

errors: No known data errors
   ```
  </details>

 <details>
<summary>[root@zfs ~]# df -h</summary>
   
  ```[root@zfs ~]# df -h
Filesystem      Size  Used Avail Use% Mounted on
devtmpfs        489M     0  489M   0% /dev
tmpfs           496M     0  496M   0% /dev/shm
tmpfs           496M  6.8M  489M   2% /run
tmpfs           496M     0  496M   0% /sys/fs/cgroup
/dev/sda1        40G  7.3G   33G  19% /
tmpfs           100M     0  100M   0% /run/user/1000
tmpfs           100M     0  100M   0% /run/user/0
otus1           352M  128K  352M   1% /otus1
otus2           352M  128K  352M   1% /otus2
otus3           352M  128K  352M   1% /otus3
otus4           352M  128K  352M   1% /otus4
   ```
  </details>
  
  </details>

<details>
<summary>- Добавим разные алгоритмы сжатия в каждую файловую систему:</summary>
<details>
<summary>● Алгоритм lzjb для zpool otus1</summary>

   ```[root@zfs ~]# zfs set compression=lzjb otus1
   ```
  </details>
  <details>
<summary>Алгоритм lz4 для zpool otus2</summary>

   ```[root@zfs ~]#  zfs set compression=lz4 otus2
   ```
  </details>
  <details>
<summary>Алгоритм gzip для zpool otus3</summary>

   ```[root@zfs ~]# zfs set compression=gzip-9 otus3
   ```
  </details>
  <details>
<summary>Алгоритм zle для zpool  otus4</summary>

   ```[root@zfs ~]#  zfs set compression=zle otus4
   ```
  </details>
  </details>


  <details>
<summary>- Проверим, что все файловые системы имеют разные методы сжатия:</summary>

  <details>
<summary>[root@zfs ~]# zfs get all | grep compressio</summary>

   ```[root@zfs ~]# zfs get all | grep compression
otus1  compression           lzjb                   local
otus2  compression           lz4                    local
otus3  compression           gzip-9                 local
otus4  compression           zle                    local
   ```
  </details>
  </details>

1.2 Проверка сжатия файлов:

 <details>
    <summary>- Проверим, что все файловые системы имеют разные методы сжатия:</summary>
Скачаем один и тот же текстовый файл во все пулы: 
   ```[root@zfs ~]# for i in {1..4}; do wget -P /otus$i https://gutenberg.org/cache/epub/2600/pg2600.converter.log; done
      ``` 
  <details>
<summary>Проверим, что файл был скачан во все пулы: ls -l /otus*</summary>

   ```[root@zfs ~]# ls -l /otus*
/otus1:
total 22079
-rw-r--r--. 1 root root 41052631 Jun 17 11:12 pg2600.converter.log

/otus2:
total 17999
-rw-r--r--. 1 root root 41052631 Jun 17 11:12 pg2600.converter.log

/otus3:
total 10962
-rw-r--r--. 1 root root 41052631 Jun 17 11:12 pg2600.converter.log

/otus4:
total 40118
-rw-r--r--. 1 root root 41052631 Jun 17 11:13 pg2600.converter.log
   ```
  </details>
  </details>

  <details>
<summary>- Проверим, сколько места занимает один и тот же файл в разных пулах и проверим степень сжатия файлов:</summary>

  <details>
<summary>[root@zfs ~]# zfs list</summary>
     
Уже на этом этапе видно, что самый оптимальный метод сжатия у нас используется в пуле otus3.


 ```[root@zfs ~]# zfs list
NAME    USED  AVAIL     REFER  MOUNTPOINT
otus1  21.7M   330M     21.6M  /otus1
otus2  17.7M   334M     17.6M  /otus2
otus3  10.8M   341M     10.7M  /otus3
otus4  39.3M   313M     39.2M  /otus4
 ```
  </details>
  <details>
<summary>zfs get all | grep compressratio | grep -v ref</summary>
 ```[root@zfs ~]# zfs get all | grep compressratio | grep -v ref
otus1  compressratio         1.82x                  -
otus2  compressratio         2.23x                  -
otus3  compressratio         3.66x                  -
otus4  compressratio         1.00x                  -
 ```
  </details>
  
Таким образом, у нас получается, что алгоритм gzip-9 самый эффективный по сжатию. 
 </details>

**2. Определение настроек пула**
 
**Порядок настройки и результаты:**
2.1 Загрузка архива и импорт пула : 
- Загрузка архива
<details>
  <summary>wget -O archive.tar.gz --no-check-certificate 'https://drive.usercontent.google.com/download?id=1MvrcEp-WgAQe57aDEzxSRalPAwbNN1Bb&export=download' </summary>
   
   ```[root@zfs ~]# wget -O archive.tar.gz --no-check-certificate 'https://drive.usercontent.google.com/download?id=1MvrcEp-WgAQe57aDEzxSRalPAwbNN1Bb&export=download'
--2024-06-17 11:17:14--  https://drive.usercontent.google.com/download?id=1MvrcEp-WgAQe57aDEzxSRalPAwbNN1Bb&export=download
Resolving drive.usercontent.google.com (drive.usercontent.google.com)... 64.233.161.132, 2a00:1450:4010:c0e::84
Connecting to drive.usercontent.google.com (drive.usercontent.google.com)|64.233.161.132|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 7275140 (6.9M) [application/octet-stream]
Saving to: ‘archive.tar.gz’

100%[=========================================================================================================================================================================================================>] 7,275,140   6.97MB/s   in 1.0s   

2024-06-17 11:17:22 (6.97 MB/s) - ‘archive.tar.gz’ saved [7275140/7275140]
   ```
  
</details>

- Разархивация файла:

<details>
  <summary>[root@zfs ~]# tar -xzvf archive.tar.gz </summary>
 
   ```[root@zfs ~]# tar -xzvf archive.tar.gz
zpoolexport/
zpoolexport/filea
zpoolexport/fileb
[root@zfs ~]#
   ```
  
</details>


- Проверим, возможно ли импортировать данный каталог в пул:

<details>
  <summary>[root@zfs ~]# zpool import -d zpoolexport/</summary>
     
   ```[root@zfs ~]# zpool import -d zpoolexport/
   pool: otus
     id: 6554193320433390805
  state: ONLINE
 action: The pool can be imported using its name or numeric identifier.
 config:

	otus                         ONLINE
	  mirror-0                   ONLINE
	    /root/zpoolexport/filea  ONLINE
	    /root/zpoolexport/fileb  ONLINE
[root@zfs ~]#
   ```
Данный вывод показывает нам имя пула, тип raid и его состав. 
  </details>

- Импорт загруженного пула к нам в ОС (имя пула otus):

 ```[root@zfs ~]# zpool import -d zpoolexport/ otus
   ```

- Проверка результата загрузки пула: 
<details>
     <summary>[root@zfs ~]# zpool status otus</summary>
Команда zpool status выдаст нам информацию о составе импортированного пула.
   
   ```[root@zfs ~]# zpool status otus
  pool: otus
 state: ONLINE
  scan: none requested
config:

	NAME                         STATE     READ WRITE CKSUM
	otus                         ONLINE       0     0     0
	  mirror-0                   ONLINE       0     0     0
	    /root/zpoolexport/filea  ONLINE       0     0     0
	    /root/zpoolexport/fileb  ONLINE       0     0     0

errors: No known data errors
   ```
 
</details>


2.2 Определение настроек пула: 
<details>
  <summary> - Запрос всех настроек пула [root@zfs ~]# zpool get all otus</summary>

   ```[root@zfs ~]# zpool get all otus
NAME  PROPERTY                       VALUE                          SOURCE
otus  size                           480M                           -
otus  capacity                       0%                             -
otus  altroot                        -                              default
otus  health                         ONLINE                         -
otus  guid                           6554193320433390805            -
otus  version                        -                              default
otus  bootfs                         -                              default
otus  delegation                     on                             default
otus  autoreplace                    off                            default
otus  cachefile                      -                              default
otus  failmode                       wait                           default
otus  listsnapshots                  off                            default
otus  autoexpand                     off                            default
otus  dedupditto                     0                              default
otus  dedupratio                     1.00x                          -
otus  free                           478M                           -
otus  allocated                      2.09M                          -
otus  readonly                       off                            -
otus  ashift                         0                              default
otus  comment                        -                              default
otus  expandsize                     -                              -
otus  freeing                        0                              -
otus  fragmentation                  0%                             -
otus  leaked                         0                              -
otus  multihost                      off                            default
otus  checkpoint                     -                              -
otus  load_guid                      8083342592654445986            -
otus  autotrim                       off                            default
otus  feature@async_destroy          enabled                        local
otus  feature@empty_bpobj            active                         local
otus  feature@lz4_compress           active                         local
otus  feature@multi_vdev_crash_dump  enabled                        local
otus  feature@spacemap_histogram     active                         local
otus  feature@enabled_txg            active                         local
otus  feature@hole_birth             active                         local
otus  feature@extensible_dataset     active                         local
otus  feature@embedded_data          active                         local
otus  feature@bookmarks              enabled                        local
otus  feature@filesystem_limits      enabled                        local
otus  feature@large_blocks           enabled                        local
otus  feature@large_dnode            enabled                        local
otus  feature@sha512                 enabled                        local
otus  feature@skein                  enabled                        local
otus  feature@edonr                  enabled                        local
otus  feature@userobj_accounting     active                         local
otus  feature@encryption             enabled                        local
otus  feature@project_quota          active                         local
otus  feature@device_removal         enabled                        local
otus  feature@obsolete_counts        enabled                        local
otus  feature@zpool_checkpoint       enabled                        local
otus  feature@spacemap_v2            active                         local
otus  feature@allocation_classes     enabled                        local
otus  feature@resilver_defer         enabled                        local
otus  feature@bookmark_v2            enabled                        local
   ```
  
</details>

-

<details>
  <summary> - Запрос сразу всех параметром файловой системы: [root@zfs ~]# zfs get all otus </summary>

   ```[root@zfs ~]# zfs get all otus
NAME  PROPERTY              VALUE                  SOURCE
otus  type                  filesystem             -
otus  creation              Fri May 15  4:00 2020  -
otus  used                  2.04M                  -
otus  available             350M                   -
otus  referenced            24K                    -
otus  compressratio         1.00x                  -
otus  mounted               yes                    -
otus  quota                 none                   default
otus  reservation           none                   default
otus  recordsize            128K                   local
otus  mountpoint            /otus                  default
otus  sharenfs              off                    default
otus  checksum              sha256                 local
otus  compression           zle                    local
otus  atime                 on                     default
otus  devices               on                     default
otus  exec                  on                     default
otus  setuid                on                     default
otus  readonly              off                    default
otus  zoned                 off                    default
otus  snapdir               hidden                 default
otus  aclinherit            restricted             default
otus  createtxg             1                      -
otus  canmount              on                     default
otus  xattr                 on                     default
otus  copies                1                      default
otus  version               5                      -
otus  utf8only              off                    -
otus  normalization         none                   -
otus  casesensitivity       sensitive              -
otus  vscan                 off                    default
otus  nbmand                off                    default
otus  sharesmb              off                    default
otus  refquota              none                   default
otus  refreservation        none                   default
otus  guid                  14592242904030363272   -
otus  primarycache          all                    default
otus  secondarycache        all                    default
otus  usedbysnapshots       0B                     -
otus  usedbydataset         24K                    -
otus  usedbychildren        2.01M                  -
otus  usedbyrefreservation  0B                     -
otus  logbias               latency                default
otus  objsetid              54                     -
otus  dedup                 off                    default
otus  mlslabel              none                   default
otus  sync                  standard               default
otus  dnodesize             legacy                 default
otus  refcompressratio      1.00x                  -
otus  written               24K                    -
otus  logicalused           1020K                  -
otus  logicalreferenced     12K                    -
otus  volmode               default                default
otus  filesystem_limit      none                   default
otus  snapshot_limit        none                   default
otus  filesystem_count      none                   default
otus  snapshot_count        none                   default
otus  snapdev               hidden                 default
otus  acltype               off                    default
otus  context               none                   default
otus  fscontext             none                   default
otus  defcontext            none                   default
otus  rootcontext           none                   default
otus  relatime              off                    default
otus  redundant_metadata    all                    default
otus  overlay               off                    default
otus  encryption            off                    default
otus  keylocation           none                   default
otus  keyformat             none                   default
otus  pbkdf2iters           0                      default
otus  special_small_blocks  0                      default
   ```
  
</details>


<details>
  <summary> - Размер пула  [root@zfs ~]# zfs get available otus</summary>

   ```[root@zfs ~]# zfs get available otus
NAME  PROPERTY   VALUE  SOURCE
otus  available  350M   -
[root@zfs ~]#
   ```
  
</details>


<details>
  <summary> - Тип файловой системы [root@zfs ~]# zfs get readonly otus </summary>

   ```[root@zfs ~]# zfs get readonly otus
NAME  PROPERTY  VALUE   SOURCE
otus  readonly  off     default
[root@zfs ~]#
   ```
  По типу FS мы можем понять, что позволяет выполнять чтение и запись
  
</details>

<details>
  <summary>Значение recordsize: [root@zfs ~]# zfs get recordsize otus  </summary>

   ```[root@zfs ~]# zfs get recordsize otus
NAME  PROPERTY    VALUE    SOURCE
otus  recordsize  128K     local
[root@zfs ~]#
   ```
  
</details>


<details>
  <summary> - Тип сжатия (или параметр отключения): [root@zfs ~]# zfs get compression otus </summary>

   ```[root@zfs ~]# zfs get compression otus
NAME  PROPERTY     VALUE     SOURCE
otus  compression  zle       local
[root@zfs ~]#
   ```
  
</details>
<details>
  <summary> - Тип контрольной суммы: [root@zfs ~]# zfs get checksum otus </summary>

   ```[root@zfs ~]# zfs get checksum otus
NAME  PROPERTY  VALUE      SOURCE
otus  checksum  sha256     local
[root@zfs ~]#
   ```
  
</details>

**3. Работа со снапшотом, поиск сообщения от преподавателя**

<details>
  <summary> 3.1 Скачиваем файл из удаленной директории: [root@zfs ~]# wget -O otus_task2.file  </summary>

   ```[root@zfs ~]# wget -O otus_task2.file --no-check-certificate https://drive.usercontent.google.com/download?id=1wgxjih8YZ-cqLqaZVa0lA3h3Y029c3oI&export=download
[1] 13845
[root@zfs ~]# --2024-06-17 11:21:58--  https://drive.usercontent.google.com/download?id=1wgxjih8YZ-cqLqaZVa0lA3h3Y029c3oI
Resolving drive.usercontent.google.com (drive.usercontent.google.com)... 173.194.220.132, 2a00:1450:4010:c05::84
Connecting to drive.usercontent.google.com (drive.usercontent.google.com)|173.194.220.132|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 5432736 (5.2M) [application/octet-stream]
Saving to: ‘otus_task2.file’

100%[=========================================================================================================================================================================================================>] 5,432,736   4.26MB/s   in 1.2s   

2024-06-17 11:22:06 (4.26 MB/s) - ‘otus_task2.file’ saved [5432736/5432736]


[1]+  Done                    wget -O otus_task2.file --no-check-certificate https://drive.usercontent.google.com/download?id=1wgxjih8YZ-cqLqaZVa0lA3h3Y029c3oI
[root@zfs ~]# 
   ```
  
</details>

<details>
  <summary>3.2 Восстановим файловую систему из снапшота: </summary>

   ```[root@zfs ~]# zfs receive otus/test@today < otus_task2.file
   ```
  
</details>

<details>
  <summary>3.3 Ищем сообщение в файле secret_message.а: </summary>
<details>
  <summary> - Ищем файл с именем “secret_message” в каталоге /otus/test : [root@zfs ~]# find /otus/test -name "secret_message"</summary>

   ```[root@zfs ~]# find /otus/test -name "secret_message"
/otus/test/task1/file_mess/secret_message
[root@zfs ~]# 
   ```
  </details>

<details>
  <summary> - Смотрим содержимое найденного файла "secret_message": [root@zfs ~]# cat /otus/test/task1/file_mess/secret_message </summary>

   ```[root@zfs ~]# cat /otus/test/task1/file_mess/secret_message
https://otus.ru/lessons/linux-hl/

[root@zfs ~]#
   ```
  
</details>

  
</details> 
 
