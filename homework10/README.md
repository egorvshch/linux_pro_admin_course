Домашнее задание по Работа с загрузчиком
-----------------------------------------
Задания:

1. Включить отображение меню Grub.
2. Попасть в систему без пароля несколькими способами.
3. Установить систему с LVM, после чего переименовать VG.

Задания выполняются на ВМ Ubuntu Server 22.04 в VirtualBox 7.0.18

Результаты:
-----------------------------------------
1. Включаем отображение меню Grub
Для отображения меню при загрузке системы редактируем конфигурационный файл:

```
egor@egor:~$ sudo nano /etc/default/grub

GRUB_DEFAULT=0
GRUB_TIMEOUT_STYLE=hidden
GRUB_TIMEOUT=10
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT=""
GRUB_CMDLINE_LINUX=""
```

Обновляем конфигурацию grub и перезагружаем ВМ для проверки:
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

2. Попасть в систему без пароля несколькими способами
-----------------------------------------------------

Открываем GUI VirtualBox , запускаем виртуальную машину и в меню grub при выборе ядра для загрузки нажимаем `e` (edit). Попадаем в окно, где мы можем изменить параметры загрузки:

Image 1

Способ № 1. В конце строки, начинающейся с `linux`, добавляем `init=/bin/bash` и нажимаем `сtrl-x` для загрузки в систему.

Image 2

Рутовая файловая система при этом монтируется в режиме Read-Only. Для монтирования ее в режим Read-Write вводим команду `mount -o remount,rw /`:

Image 3

Способ №2. Recovery mode. При загрузке ВМ в меню grub выбираем вариант загрузки "Advanced options for Ubuntu":

Image 4

Далее выбираем вариант recovery mode в названии. Получим меню режима восстановления.
В этом меню сначала включаем поддержку сети (network) для того, чтобы файловая система перемонтировалась в режим read/write


Далее выбираем пункт root и попадаем в консоль с пользователем root. В этой консоли можно производить любые манипуляции с системой

Image 4


3. Установка системы с LVM, переименование VG
-----------------------------------------------------

Смотрим текущее состояние системы (список Volume Group) командой vgs и переименовываем VG `ubuntu-vg` в `ubuntu-otus` с помощью команды `vgrename ubuntu-vg ubuntu-otus`:

Image 6

Далее правим /boot/grub/grub.cfg. Везде заменяем старое название VG на новое:

```
root@egor:/home/egor# nano /boot/grub/grub.cfg

root@egor:/home/egor# cat /boot/grub/grub.cfg | grep ubuntu-- 
	linux	/vmlinuz-5.15.0-107-generic root=/dev/mapper/ubuntu--otus-ubuntu--lv ro  
		linux	/vmlinuz-5.15.0-107-generic root=/dev/mapper/ubuntu--otus-ubuntu--lv ro  
		linux	/vmlinuz-5.15.0-107-generic root=/dev/mapper/ubuntu--otus-ubuntu--lv ro recovery nomodeset dis_ucode_ldr 
root@egor:/home/egor# 
```

Перезагружаем ВМ и проверяем:

Image 5



root@egor:/home/egor# nano /boot/grub/grub.cfg

root@egor:/home/egor# cat /boot/grub/grub.cfg | grep ubuntu-- 
	linux	/vmlinuz-5.15.0-107-generic root=/dev/mapper/ubuntu--otus-ubuntu--lv ro  
		linux	/vmlinuz-5.15.0-107-generic root=/dev/mapper/ubuntu--otus-ubuntu--lv ro  
		linux	/vmlinuz-5.15.0-107-generic root=/dev/mapper/ubuntu--otus-ubuntu--lv ro recovery nomodeset dis_ucode_ldr 
root@egor:/home/egor# 
