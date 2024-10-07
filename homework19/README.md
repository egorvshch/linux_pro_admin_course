Домашнее задание "Архитектура сетей (Сетевая лаборатория)"
-----------------------------------------

#### Описание задания

**Дано:**

https://github.com/erlong15/otus-linux/tree/network
(ветка network)
Vagrantfile с начальным построением сети

inetRouter
centralRouter
centralServer
тестировалось на virtualbox

Планируемая архитектура

построить следующую архитектуру
Сеть office1

192.168.2.0/26 - dev
192.168.2.64/26 - test servers
192.168.2.128/26 - managers
192.168.2.192/26 - office hardware
Сеть office2
192.168.1.0/25 - dev
192.168.1.128/26 - test servers
192.168.1.192/26 - office hardware
Сеть central
192.168.0.0/28 - directors
192.168.0.32/28 - office hardware
192.168.0.64/26 - wifi
```
Office1 ---\
----> Central --IRouter --> internet
Office2----/
```

Итого должны получится следующие сервера
inetRouter
centralRouter
office1Router
office2Router
centralServer
office1Server
office2Server

***Теоретическая часть***
- Найти свободные подсети
- Посчитать сколько узлов в каждой подсети, включая свободные
- Указать broadcast адрес для каждой подсети
-  проверить нет ли ошибок при разбиении

***Практическая часть***
- Соединить офисы в сеть согласно схеме и настроить роутинг
- Все сервера и роутеры должны ходить в инет черз inetRouter
- Все сервера должны видеть друг друга
- у всех новых серверов отключить дефолт на нат (eth0), который вагрант поднимает для связи
- при нехватке сетевых интервейсов добавить по несколько адресов на интерфейс

***Схема:***

![Image 1](https://github.com/egorvshch/linux_pro_admin_course/blob/main/homework19/files/Schema.png)


****Формат сдачи:****
Vagrantfile + ansible

****Используемый стек для стенда:****
- VirtualBox 7.0.12,
- Vagrant 2.4.1,
- Vagrant Box "generic/ubuntu2204" (box_version 4.3.0)
- Хостовая система: Ubuntu 22.04.4 LTS (ОЗУ 32Гб, 8 CPU)
- Ansible 2.10.8

### Результат теоретической части: 
- совпадает с описанным в [методичке](https://docs.google.com/document/d/1rQH5M2MYclBkvmv3SO4wl4F_IErcojl86hD10ric6Lk)

### Результат практической части:
- Скорректированный [Vagrantfile](https://github.com/egorvshch/linux_pro_admin_course/blob/main/homework19/Vagrantfile)
- Playbook Ansible с коментариями настройки машин стенда: [provision.yml](https://github.com/egorvshch/linux_pro_admin_course/blob/main/homework19/ansible/provision.yml)
- Журнал лога запуска vagrant, настройки машин и выводов статусов настроек лежит здесь: [vagrant_up_output_logs.log](https://github.com/egorvshch/linux_pro_admin_course/blob/main/homework19/vagrant_up_output_logs.log)

***Запуск стенда:***

```
vagrant up
```
В результате разворачиваются 7 машин с требуемыми настройками:
```
root@evengtest:/home/eve/homework19# vagrant status
Current machine states:

inetRouter                running (virtualbox)
centralRouter             running (virtualbox)
centralServer             running (virtualbox)
office1Router             running (virtualbox)
office1Server             running (virtualbox)
office2Router             running (virtualbox)
office2Server             running (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
root@evengtest:/home/eve/homework19# 
```
Зайдем на сервер ```office1Server``` и проверим доступность сервера ```centralServer``` по IP ```192.168.0.2``` и DNS Google ```8.8.8.8```, плюс запустим трассировки, в которых видно, что маршрут в Интернет проходит через требуемый ```netRouter```:
```
root@evengtest:/home/eve/homework19/ansible# 
root@evengtest:/home/eve/homework19/ansible# vagrant ssh office1Server
Last login: Mon Oct  7 18:38:00 2024 from 192.168.50.1
vagrant@office1Server:~$ ping 192.168.0.2
PING 192.168.0.2 (192.168.0.2) 56(84) bytes of data.
64 bytes from 192.168.0.2: icmp_seq=1 ttl=62 time=10.8 ms
64 bytes from 192.168.0.2: icmp_seq=2 ttl=62 time=6.75 ms
64 bytes from 192.168.0.2: icmp_seq=3 ttl=62 time=11.2 ms
64 bytes from 192.168.0.2: icmp_seq=4 ttl=62 time=6.60 ms
^C
--- 192.168.0.2 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3004ms
rtt min/avg/max/mdev = 6.595/8.838/11.210/2.171 ms
vagrant@office1Server:~$ ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=57 time=55.3 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=57 time=56.9 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=57 time=55.4 ms
64 bytes from 8.8.8.8: icmp_seq=4 ttl=57 time=53.5 ms
^C
--- 8.8.8.8 ping statistics ---
5 packets transmitted, 4 received, 20% packet loss, time 4005ms
rtt min/avg/max/mdev = 53.456/55.255/56.872/1.211 ms
vagrant@office1Server:~$ traceroute 192.168.0.2
traceroute to 192.168.0.2 (192.168.0.2), 30 hops max, 60 byte packets
 1  _gateway (192.168.2.129)  1.527 ms  2.674 ms  2.567 ms
 2  192.168.255.9 (192.168.255.9)  3.222 ms  11.748 ms  9.358 ms
 3  192.168.0.2 (192.168.0.2)  18.574 ms  18.425 ms  17.728 ms
vagrant@office1Server:~$ 
vagrant@office1Server:~$ traceroute 8.8.8.8
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
 1  _gateway (192.168.2.129)  1.464 ms  1.389 ms  1.658 ms
 2  192.168.255.9 (192.168.255.9)  7.869 ms  8.617 ms  10.831 ms
 3  192.168.255.1 (192.168.255.1)  11.109 ms  10.482 ms  10.569 ms
 4  10.0.2.2 (10.0.2.2)  11.768 ms  13.755 ms  13.176 ms
 5  * * *
 6  * * *
 7  * * *
 8  10.0.1.4 (10.0.1.4)  13.560 ms  14.373 ms  14.648 ms
 9  10.0.4.1 (10.0.4.1)  10.584 ms  12.063 ms  11.894 ms
10  79x135x87x6.static-business.ekb.ertelecom.ru (79.135.87.6)  10.987 ms  7.650 ms  7.527 ms
11  pe107.sr32-27.ekb.ru.mirasystem.net (212.49.97.25)  12.580 ms  14.948 ms  14.290 ms
12  asb-cr01-ae9.200.ekt.mts-internet.net (212.188.22.33)  14.183 ms  17.250 ms  17.145 ms
13  asb-cr02-be3.66.ekt.mts-internet.net (212.188.56.134)  17.053 ms  16.022 ms  24.019 ms
14  psshag-cr01-ae5.74.chel.mts-internet.net (212.188.56.94)  47.086 ms  46.537 ms  47.618 ms
15  che-cr02-ae10.63.sam.mts-internet.net (212.188.42.129)  47.496 ms  46.892 ms  50.351 ms
16  * * *
17  a197-cr01-ae16.0.msk.mts-internet.net (212.188.56.137)  51.680 ms  82.350 ms  47.839 ms
18  as15169.asbr.router (195.34.36.221)  46.064 ms  45.035 ms  43.059 ms
19  * * *
20  209.85.143.20 (209.85.143.20)  42.057 ms  42.628 ms  43.900 ms
21  142.250.238.138 (142.250.238.138)  54.071 ms 142.251.238.82 (142.251.238.82)  57.818 ms *
22  209.85.254.6 (209.85.254.6)  57.831 ms 66.249.95.224 (66.249.95.224)  73.572 ms 142.251.238.68 (142.251.238.68)  54.040 ms
23  216.239.58.69 (216.239.58.69)  58.156 ms 142.250.210.103 (142.250.210.103)  57.360 ms 142.250.56.215 (142.250.56.215)  55.526 ms
24  * * *
25  * * *
26  * * *
27  * * *
28  * * *
29  * * *
30  * * *
vagrant@office1Server:~$ exit
logout

```

По аналогии зайдем на сервер ```office2Server``` и проверим доступность сервера ```office1Server``` по IP ```192.168.2.130``` и DNS Google ```8.8.8.8```, плюс запустим трассировки, в которых видно, что маршрут в Интернет прохоит через требуемый ```netRouter```:

```
oot@evengtest:/home/eve/homework19/ansible# vagrant ssh office2Server
Last login: Mon Oct  7 18:37:53 2024 from 192.168.50.1
vagrant@office2Server:~$ ping 192.168.1.130
PING 192.168.1.130 (192.168.1.130) 56(84) bytes of data.
^C
--- 192.168.1.130 ping statistics ---
3 packets transmitted, 0 received, 100% packet loss, time 2028ms

vagrant@office2Server:~$ ping 192.168.2.130
PING 192.168.2.130 (192.168.2.130) 56(84) bytes of data.
64 bytes from 192.168.2.130: icmp_seq=1 ttl=61 time=7.94 ms
64 bytes from 192.168.2.130: icmp_seq=2 ttl=61 time=8.54 ms
^C
--- 192.168.2.130 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 7.937/8.236/8.535/0.299 ms
vagrant@office2Server:~$ ping 192.168.2.130
PING 192.168.2.130 (192.168.2.130) 56(84) bytes of data.
64 bytes from 192.168.2.130: icmp_seq=1 ttl=61 time=8.58 ms
64 bytes from 192.168.2.130: icmp_seq=2 ttl=61 time=9.08 ms
64 bytes from 192.168.2.130: icmp_seq=3 ttl=61 time=7.00 ms
64 bytes from 192.168.2.130: icmp_seq=4 ttl=61 time=7.30 ms
^C
--- 192.168.2.130 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3004ms
rtt min/avg/max/mdev = 7.002/7.993/9.084/0.865 ms
vagrant@office2Server:~$ ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=57 time=57.7 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=57 time=55.3 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=57 time=56.7 ms
64 bytes from 8.8.8.8: icmp_seq=4 ttl=57 time=57.0 ms
^C
--- 8.8.8.8 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3005ms
rtt min/avg/max/mdev = 55.298/56.673/57.734/0.881 ms
vagrant@office2Server:~$ traceroute 192.168.2.130
traceroute to 192.168.2.130 (192.168.2.130), 30 hops max, 60 byte packets
 1  _gateway (192.168.1.1)  1.103 ms  1.336 ms  1.501 ms
 2  192.168.255.5 (192.168.255.5)  3.703 ms  7.247 ms  7.020 ms
 3  192.168.255.10 (192.168.255.10)  9.730 ms  9.087 ms  9.971 ms
 4  192.168.2.130 (192.168.2.130)  11.619 ms  10.977 ms  15.732 ms
vagrant@office2Server:~$ traceroute 8.8.8.8
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
 1  _gateway (192.168.1.1)  1.642 ms  0.912 ms  1.685 ms
 2  192.168.255.5 (192.168.255.5)  6.408 ms  5.858 ms  5.689 ms
 3  192.168.255.1 (192.168.255.1)  6.923 ms  6.821 ms  8.730 ms
 4  10.0.2.2 (10.0.2.2)  9.985 ms  12.354 ms  11.908 ms
 5  * * *
 6  * * *
 7  * * *
 8  10.0.1.4 (10.0.1.4)  16.164 ms  16.254 ms  16.016 ms
 9  10.0.4.1 (10.0.4.1)  10.654 ms  9.202 ms  9.066 ms
10  79x135x87x6.static-business.ekb.ertelecom.ru (79.135.87.6)  9.670 ms  11.053 ms  14.693 ms
11  pe107.sr32-27.ekb.ru.mirasystem.net (212.49.97.25)  15.666 ms  15.112 ms  14.988 ms
12  asb-cr01-ae9.200.ekt.mts-internet.net (212.188.22.33)  14.128 ms  15.283 ms  15.152 ms
13  asb-cr02-be3.66.ekt.mts-internet.net (212.188.56.134)  12.660 ms  13.347 ms  12.062 ms
14  psshag-cr01-ae5.74.chel.mts-internet.net (212.188.56.94)  42.086 ms  41.079 ms  42.835 ms
15  che-cr02-ae10.63.sam.mts-internet.net (212.188.42.129)  42.954 ms  40.168 ms  41.528 ms
16  a197-cr08-eth-trunk1.msk.mts-internet.net (212.188.29.25)  43.262 ms *  49.676 ms
17  a197-cr01-ae16.0.msk.mts-internet.net (212.188.56.137)  54.143 ms  44.065 ms  42.908 ms
18  as15169.asbr.router (195.34.36.221)  43.591 ms  42.874 ms  51.021 ms
19  192.178.241.65 (192.178.241.65)  36.578 ms 192.178.241.181 (192.178.241.181)  42.036 ms 192.178.241.251 (192.178.241.251)  40.485 ms
20  192.178.241.66 (192.178.241.66)  43.608 ms 192.178.241.148 (192.178.241.148)  40.725 ms 209.85.143.20 (209.85.143.20)  39.784 ms
21  * 216.239.51.32 (216.239.51.32)  57.591 ms *
22  72.14.232.76 (72.14.232.76)  56.178 ms 142.251.238.72 (142.251.238.72)  55.764 ms  59.874 ms
23  209.85.251.41 (209.85.251.41)  54.183 ms 142.250.236.77 (142.250.236.77)  70.735 ms 142.250.232.179 (142.250.232.179)  70.595 ms
24  * * *
25  * * *
26  * * *
27  * * *
28  * * *
29  * * *
30  * * *
vagrant@office2Server:~$ 
```
