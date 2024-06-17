
Домашнее задание по ZFS
-----------------------------------------
В данном репозитории содержатся файлы конфигурации стенда и результаты выполнения домашнего задания по ZFS

**Используемый стек:**
- VirtualBox 7.0.12, 
- Vagrant 2.4.1, 
- Vagrant Box centos/7 v2004.01
- хостовая система: Ubuntu 22.04

Запуск стенда:

   ```
vagrant up
vagrant ssh
   ```

Задания:
-----------------------------------------

**Определение алгоритма с наилучшим сжатием**
**Цель:** Определить какие алгоритмы сжатия поддерживает zfs (gzip,zle, lzjb, lz4)
**Порядок настройки и результаты:**
● создание 4х файловых систем и применение различных алгоритмов сжатия;
Проверка списка всех дисков, которые доступны в виртуальной машине: lsblk

Создаём 4 пула из двух дисков в режиме RAID 1:

Проверка статуса и информации о zpool'ах

zpool status

zpool list п


Добавим разные алгоритмы сжатия в каждую файловую систему:
● Алгоритм lzjb: zfs set compression=lzjb otus1
● Алгоритм lz4: zfs set compression=lz4 otus2
● Алгоритм gzip: zfs set compression=gzip-9 otus3
● Алгоритм zle: zfs set compression=zle otus4

Проверим, что все файловые системы имеют разные методы сжатия:
Проверим, что все файловые системы имеют разные методы сжатия:
[root@zfs ~]# zfs get all | grep compression
otus1  compression           lzjb                   local
otus2  compression           lz4                    local
otus3  compression           gzip-9                 local
otus4  compression           zle                    local

Сжатие файлов будет работать только с файлами, которые были добавлены после включение настройки сжатия. 
Скачаем один и тот же текстовый файл во все пулы: 
[root@zfs ~]# for i in {1..4}; do wget -P /otus$i https://gutenberg.org/cache/epub/2600/pg2600.converter.log; done
...
Проверим, что файл был скачан во все пулы:
[root@zfs ~]# ls -l /otus*
/otus1:
total 22005
-rw-r--r--. 1 root root 40750827 Oct  2 08:07 pg2600.converter.log


/otus2:
total 17966
-rw-r--r--. 1 root root 40750827 Oct  2 08:07 pg2600.converter.log


/otus3:
total 10945
-rw-r--r--. 1 root root 40750827 Oct  2 08:07 pg2600.converter.log


/otus4:
total 39836
-rw-r--r--. 1 root root 40750827 Oct  2 08:07 pg2600.converter.log


Уже на этом этапе видно, что самый оптимальный метод сжатия у нас используется в пуле otus3.
Проверим, сколько места занимает один и тот же файл в разных пулах и проверим степень сжатия файлов:
[root@zfs ~]# zfs list
NAME    USED  AVAIL     REFER  MOUNTPOINT
otus1  21.6M   330M     21.5M  /otus1
otus2  17.7M   334M     17.6M  /otus2
otus3  10.8M   341M     10.7M  /otus3
otus4  39.0M   313M     38.9M  /otus4


[root@zfs ~]# zfs get all | grep compressratio | grep -v ref
otus1  compressratio         1.80x                  -
otus2  compressratio         2.21x                  -
otus3  compressratio         3.63x                  -
otus4  compressratio         1.00x                  -

Таким образом, у нас получается, что алгоритм gzip-9 самый эффективный по сжатию. 
 Определение настроек пула
Скачиваем архив в домашний каталог: 
[root@zfs ~]# wget -O archive.tar.gz --no-check-certificate 'https://drive.usercontent.google.com/download?id=1MvrcEp-WgAQe57aDEzxSRalPAwbNN1Bb&export=download' 
Разархивируем его:
[root@zfs ~]# tar -xzvf archive.tar.gz
zpoolexport/
zpoolexport/filea
zpoolexport/fileb
[root@zfs ~]#

Проверим, возможно ли импортировать данный каталог в пул:
[root@zfs ~]# zpool import -d zpoolexport/
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

Данный вывод показывает нам имя пула, тип raid и его состав. 
Сделаем импорт данного пула к нам в ОС:
[root@zfs ~]# zpool import -d zpoolexport/ otus
[root@zfs ~]# zpool status
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

Команда zpool status выдаст нам информацию о составе импортированного пула.
Если у Вас уже есть пул с именем otus, то можно поменять его имя во время импорта: zpool import -d zpoolexport/ otus newotus
Далее нам нужно определить настройки: zpool get all otus
Запрос сразу всех параметром файловой системы: zfs get all otus
[root@zfs ~]# zfs get all otus
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


C помощью команды grep можно уточнить конкретный параметр, например:
Размер: zfs get available otus
[root@zfs ~]# zfs get available otus
NAME  PROPERTY   VALUE  SOURCE
otus  available  350M   -


Тип: zfs get readonly otus
[root@zfs ~]# zfs get readonly otus
NAME  PROPERTY  VALUE   SOURCE
otus  readonly  off     default
По типу FS мы можем понять, что позволяет выполнять чтение и запись
Значение recordsize: zfs get recordsize otus
[root@zfs ~]# zfs get recordsize otus
NAME  PROPERTY    VALUE    SOURCE
otus  recordsize  128K     local


Тип сжатия (или параметр отключения): zfs get compression otus
[root@zfs ~]# zfs get compression otus
NAME  PROPERTY     VALUE     SOURCE
otus  compression  zle       local


Тип контрольной суммы: zfs get checksum otus
[root@zfs ~]# zfs get checksum otus
NAME  PROPERTY  VALUE      SOURCE
otus  checksum  sha256     local

Работа со снапшотом, поиск сообщения от преподавателя
Скачаем файл, указанный в задании:
[root@zfs ~]# wget -O otus_task2.file --no-check-certificate https://drive.usercontent.google.com/download?id=1wgxjih8YZ-cqLqaZVa0lA3h3Y029c3oI&export=download
Восстановим файловую систему из снапшота:
zfs receive otus/test@today < otus_task2.file
Далее, ищем в каталоге /otus/test файл с именем “secret_message”:
[root@zfs ~]# find /otus/test -name "secret_message"
/otus/test/task1/file_mess/secret_message

Смотрим содержимое найденного файла:
[root@zfs ~]# cat /otus/test/task1/file_mess/secret_message
https://otus.ru/lessons/linux-hl/


Тут мы видим ссылку на курс OTUS, задание выполнено.


2. Определить настройки пула.
С помощью команды zfs import собрать pool ZFS.
Командами zfs определить настройки:
- размер хранилища;
- тип pool;
- значение recordsize;
- какое сжатие используется;
- какая контрольная сумма используется.
3. Работа со снапшотами:
- скопировать файл из удаленной директории;
- восстановить файл локально. zfs receive;
- найти зашифрованное сообщение в файле secret_message.



<details>
  <summary>Click to here. </summary>
   
   ### You can add a message here

   You can add text within a collapsed section. 

   You can add an image or a code block, too.

   ```ruby
     puts "Hello World"
   ```
  
</details>


