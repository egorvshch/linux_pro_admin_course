Домашнее задание по Работа с загрузчиком
-----------------------------------------
Задания:

1. Включить отображение меню GRUB.
2. Попасть в систему без пароля несколькими способами.
3. Установить систему с LVM, после чего переименовать VG.

Задания выполняются на ВМ Ubuntu Server 22.04 в VirtualBox 7.0.18

Результаты:
-----------------------------------------
### 1. Включаем отображение меню GRUB:
 - Для отображения меню при загрузке системы редактируем параметр `GRUB_TIMEOUT=` в конфигурационном файле `/etc/default/grub`:

```
egor@egor:~$ sudo nano /etc/default/grub

GRUB_DEFAULT=0
GRUB_TIMEOUT_STYLE=hidden
GRUB_TIMEOUT=10
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT=""
GRUB_CMDLINE_LINUX=""
```

 - Обновляем конфигурацию grub и перезагружаем ВМ для проверки:
```
egor@egor:~$ sudo update-grub
Sourcing file `/etc/default/grub'
Sourcing file `/etc/default/grub.d/init-select.cfg'
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-5.15.0-107-generic
Found initrd image: /boot/initrd.img-5.15.0-107-generic
Warning: os-prober will not be executed to detect other bootable partitions.
Systems on them will not be added to the GRUB boot configuration.
Check GRUB_DISABLE_OS_PROBER documentation entry.
done
egor@egor:~$ sudo reboot
```
В результате при загрузке ВМ будет появляться меню GRUB на 10 секунд

### 2. Попасть в систему без пароля несколькими способами

- Открываем GUI VirtualBox , запускаем виртуальную машину и в меню GRUB при выборе ядра для загрузки нажимаем `e` (edit):
![Image 1](https://github.com/egorvshch/linux_pro_admin_course/blob/main/homework09/images/grub-menu.JPG)

- Попадаем в окно, где мы можем изменить параметры загрузки:
![Image 2](https://github.com/egorvshch/linux_pro_admin_course/blob/main/homework09/images/grub-edit.JPG)

#### Способ № 1. c `init=/bin/bash`
- В конце строки, начинающейся с `linux`, добавляем `init=/bin/bash` и нажимаем `сtrl-x` для загрузки в систему.
![Image 3](https://github.com/egorvshch/linux_pro_admin_course/blob/main/homework09/images/grub-edit-add.JPG)

- Рутовая файловая система при этом монтируется в режиме Read-Only. Для монтирования ее в режим Read-Write вводим команду `mount -o remount,rw /`:

![Image 4](https://github.com/egorvshch/linux_pro_admin_course/blob/main/homework09/images/remount.JPG)

#### Способ №2. Recovery mode. 
- При загрузке ВМ в меню grub выбираем вариант загрузки "Advanced options for Ubuntu":

![Image 5](https://github.com/egorvshch/linux_pro_admin_course/blob/main/homework09/images/Advanced%20options%E2%80%A6.JPG)

- Далее выбираем вариант recovery mode в названии:

![Image 6](https://github.com/egorvshch/linux_pro_admin_course/blob/main/homework09/images/Advanced%20options%E2%80%A62.JPG)

- Получим меню режима восстановления:

![Image 7](https://github.com/egorvshch/linux_pro_admin_course/blob/main/homework09/images/Network.JPG)

- В этом меню сначала включаем поддержку сети (network) для того, чтобы файловая система перемонтировалась в режим read/write.
Далее выбираем пункт root и попадаем в консоль с пользователем root. В этой консоли можно производить любые манипуляции с системой:

![Image 8](https://github.com/egorvshch/linux_pro_admin_course/blob/main/homework09/images/root.JPG)

### 3. Установка системы с LVM, переименование VG
У нас используется Ubuntu 22.04 со стандартной разбивкой диска с использованием  LVM.

-Смотрим текущее состояние системы (список Volume Group) командой vgs и переименовываем VG `ubuntu-vg` в `ubuntu-otus` с помощью команды `vgrename ubuntu-vg ubuntu-otus`:

![Image 9](https://github.com/egorvshch/linux_pro_admin_course/blob/main/homework09/images/lvm_rename.JPG)

- Далее правим `/boot/grub/grub.cfg`. Везде заменяем старое название VG `ubuntu--vg`на новое `ubuntu--otus`:

![Image 10](https://github.com/egorvshch/linux_pro_admin_course/blob/main/homework09/images/boot_grub.cfg.JPG)

- Перезагружаем ВМ и проверяем:

```
root@egor:/home/egor# vgs
  VG          #PV #LV #SN Attr   VSize   VFree 
  ubuntu-otus   1   1   0 wz--n- <30.00g 15.00g
```
