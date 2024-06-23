Домашнее задание: Systemd — создание unit-файла
-----------------------------------------
### Задания:

1. Написать service, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова (файл лога и ключевое слово должны задаваться в /etc/default).
2. Установить spawn-fcgi и создать unit-файл (spawn-fcgi.sevice) с помощью переделки init-скрипта (https://gist.github.com/cea2k/1318020).
3. Доработать unit-файл Nginx (nginx.service) для запуска нескольких инстансов сервера с разными конфигурационными файлами одновременно.

**Задания выполняются на ВМ с использованием:**
- VirtualBox 7.0.12,
- Vagrant 2.4.1,
- Vagrant Box "ubuntu/jammy64" (Ubuntu 22.04.4 LTS)
- Хостовая система: Ubuntu  22.04
- ВМ Ubuntu Server 22.04 в VirtualBox 7.0.18

`Vagrantfile` выглядит следующим образом:
```# -*- mode: ruby -*-
# vi: set ft=ruby :

MACHINES = {
  :"systemd-lab" => {
              :box_name => "ubuntu/jammy64",
              :box_version => "0",
              :cpus => 2,
              :memory => 1024,
            }
}

Vagrant.configure("2") do |config|
  MACHINES.each do |boxname, boxconfig|
    config.vm.define boxname do |box|
      box.vm.box = boxconfig[:box_name]
      box.vm.box_version = boxconfig[:box_version]
      box.vm.host_name = boxname.to_s
      box.vm.provider "virtualbox" do |v|
        v.memory = boxconfig[:memory]
        v.cpus = boxconfig[:cpus]
      end
     box.vm.provision "shell", inline: <<-SHELL
	mkdir -p ~root/.ssh
	cp ~vagrant/.ssh/auth* ~root/.ssh
       SHELL
     end 
    config.vm.provision "file", source: "./watchlog_files/", destination: "/tmp/"
    config.vm.provision "file", source: "./spawn-fcgi_files/", destination: "/tmp/"
    config.vm.provision "file", source: "./nginx_files/", destination: "/tmp/"
    
    config.vm.provision "shell", path: "provision_script.sh"
end
``` 

В файле сконфигурировано 3 директории для каждого из заданий и один `provision_script.sh` скрипт.

*Запуск стенда:*

   ```
vagrant up
vagrant ssh 
   ```

## Результаты:

### 1. Service, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова
- В директории `/etc/default` создается конфигурационный файл `/etc/default/watchlog`, из которого будут браться переменные для сервиса:

```
WORD="ALERT"
LOG=/var/log/watchlog.log
```

- В качестве подопытного журнала лога использeтся предварительно созданный `/var/log/watchlog.log` с содержимым:

```
root@systemd-lab:/home/vagrant# cat /var/log/watchlog.log
‘ALERT’
‘ALERT’
‘ALERT’
```

- Скрипт `/opt/watchlog.sh`, который анализирует наличие ключевого слова в созданном журнале и с помощью команды `logger` отправляет лог в системный журнал:

```root@systemd-lab:/home/vagrant# /opt/watchlog.sh
#!/bin/bash

WORD=$1
LOG=$2
DATE=`date`

if grep $WORD $LOG &> /dev/null
then
logger "$DATE: I found word, Master!"
else
exit 0
fi
```
- Скрипт должен быть исполняемым: `chmod +x /opt/watchlog.sh`

- Создаются два unit файла:
  
a) `/etc/systemd/system/watchlog.service` - сам сервис запускающий скрипт мониторинга логов:

```[Unit]
Description=My watchlog service

[Service]
Type=oneshot
EnvironmentFile=/etc/default/watchlog
ExecStart=/opt/watchlog.sh $WORD $LOG
```
б) `/etc/systemd/system/watchlog.timer` - unit-таймер для периодического запуска сервиса мониторинга логов:

```[Unit]
Description=Run watchlog script every 30 second

[Timer]
OnActiveSec=1
# Run every 30 second
OnUnitActiveSec=30
Unit=watchlog.service

[Install]
WantedBy=multi-user.target
```
- Запуск и результаты работы:

 ```
vagrant@systemd-lab:~$ sudo systemctl start watchlog.timer
vagrant@systemd-lab:~$ sudo systemctl status watchlog
○ watchlog.service - My watchlog service
     Loaded: loaded (/etc/systemd/system/watchlog.service; static)
     Active: inactive (dead) since Sun 2024-06-23 19:13:30 UTC; 15s ago
TriggeredBy: ● watchlog.timer
    Process: 12133 ExecStart=/opt/watchlog.sh $WORD $LOG (code=exited, status=0/SUCCESS)
   Main PID: 12133 (code=exited, status=0/SUCCESS)
        CPU: 34ms

Jun 23 19:13:30 systemd-lab systemd[1]: Starting My watchlog service...
Jun 23 19:13:30 systemd-lab root[12136]: Sun Jun 23 19:13:30 UTC 2024: I found word, Master!
Jun 23 19:13:30 systemd-lab systemd[1]: watchlog.service: Deactivated successfully.
Jun 23 19:13:30 systemd-lab systemd[1]: Finished My watchlog service.

vagrant@systemd-lab:~$ sudo tail -n 1000 /var/log/syslog  | grep word
Jun 23 19:08:08 ubuntu-jammy kernel: [   16.279713] systemd[1]: Started Forward Password Requests to Wall Directory Watch.
Jun 23 19:08:50 ubuntu-jammy root: Sun Jun 23 19:08:50 UTC 2024: I found word, Master!
Jun 23 19:08:51 ubuntu-jammy root: Sun Jun 23 19:08:51 UTC 2024: I found word, Master!
Jun 23 19:09:21 ubuntu-jammy root: Sun Jun 23 19:09:21 UTC 2024: I found word, Master!
Jun 23 19:10:01 ubuntu-jammy root: Sun Jun 23 19:10:01 UTC 2024: I found word, Master!
Jun 23 19:10:37 ubuntu-jammy root: Sun Jun 23 19:10:37 UTC 2024: I found word, Master!
Jun 23 19:11:07 ubuntu-jammy root: Sun Jun 23 19:11:07 UTC 2024: I found word, Master!
```

### 2.  Установить spawn-fcgi и создать unit-файл (spawn-fcgi.sevice):

- Устанавливаем spawn-fcgi и необходимые для него пакеты:
```
apt update
apt install -y spawn-fcgi php php-cgi php-cli apache2 libapache2-mod-fcgid
```
- Настройки сервиса содержатся в файле `/etc/spawn-fcgi/fcgi.conf`:

```
SOCKET=/var/run/php-fcgi.sock
OPTIONS="-u www-data -g www-data -s $SOCKET -S -M 0600 -C 32 -F 1 -- /usr/bin/php-cgi"
```
- конфигурация unit-файла сервиса `/etc/systemd/system/spawn-fcgi.service`:
```
[Unit]
Description=Spawn-fcgi startup service by Otus
After=network.target

[Service]
Type=simple
PIDFile=/var/run/spawn-fcgi.pid
EnvironmentFile=/etc/spawn-fcgi/fcgi.conf
ExecStart=/usr/bin/spawn-fcgi -n $OPTIONS
KillMode=process

[Install]
WantedBy=multi-user.target

```
- Запуск и проверка статуса сервиса:
```
root@systemd-lab:/home/vagrant# systemctl start spawn-fcgi
```
```
root@systemd-lab:/home/vagrant# systemctl status spawn-fcgi
● spawn-fcgi.service - Spawn-fcgi startup service by Otus
     Loaded: loaded (/etc/systemd/system/spawn-fcgi.service; disabled; vendor preset: enabled)
     Active: active (running) since Sun 2024-06-23 19:12:10 UTC; 5min ago
   Main PID: 11440 (php-cgi)
      Tasks: 33 (limit: 1102)
     Memory: 14.4M
        CPU: 123ms
     CGroup: /system.slice/spawn-fcgi.service
             ├─11440 /usr/bin/php-cgi
             ├─11444 /usr/bin/php-cgi
             ├─11445 /usr/bin/php-cgi
             ├─11446 /usr/bin/php-cgi
             ├─11447 /usr/bin/php-cgi
             ├─11448 /usr/bin/php-cgi
             ├─11449 /usr/bin/php-cgi
             ├─11450 /usr/bin/php-cgi
             ├─11451 /usr/bin/php-cgi
             ├─11452 /usr/bin/php-cgi
             ├─11453 /usr/bin/php-cgi
             ├─11454 /usr/bin/php-cgi
             ├─11455 /usr/bin/php-cgi
             ├─11456 /usr/bin/php-cgi
             ├─11457 /usr/bin/php-cgi
             ├─11458 /usr/bin/php-cgi
             ├─11459 /usr/bin/php-cgi
             ├─11460 /usr/bin/php-cgi
             ├─11461 /usr/bin/php-cgi
             ├─11462 /usr/bin/php-cgi
             ├─11463 /usr/bin/php-cgi
             ├─11464 /usr/bin/php-cgi
             ├─11465 /usr/bin/php-cgi
             ├─11466 /usr/bin/php-cgi
             ├─11467 /usr/bin/php-cgi
             ├─11468 /usr/bin/php-cgi
             ├─11469 /usr/bin/php-cgi
             ├─11470 /usr/bin/php-cgi
             ├─11471 /usr/bin/php-cgi
             ├─11472 /usr/bin/php-cgi
             ├─11473 /usr/bin/php-cgi
             ├─11474 /usr/bin/php-cgi
             └─11475 /usr/bin/php-cgi

Jun 23 19:12:10 systemd-lab systemd[1]: Started Spawn-fcgi startup service by Otus.
Jun 23 19:12:23 systemd-lab systemd[1]: /etc/systemd/system/spawn-fcgi.service:7: PIDFile= references a path below legacy directory /var/run/, updating /var/run/spawn-fcgi.pid → /run/spawn-fcgi.pid; please update the unit file accordingly.
Jun 23 19:12:26 systemd-lab systemd[1]: /etc/systemd/system/spawn-fcgi.service:7: PIDFile= references a path below legacy directory /var/run/, updating /var/run/spawn-fcgi.pid → /run/spawn-fcgi.pid; please update the unit file accordingly.
Jun 23 19:12:27 systemd-lab systemd[1]: /etc/systemd/system/spawn-fcgi.service:7: PIDFile= references a path below legacy directory /var/run/, updating /var/run/spawn-fcgi.pid → /run/spawn-fcgi.pid; please update the unit file accordingly.
```


### 3. Запуск нескольких экземляров Nginx с разными конфигурационными файлами одновременно:

- Установка Nginx из стандартного репозитория:
```
apt install nginx -y
```
- Для запуска нескольких экземпляров сервиса модифицируется исходный service для использования различной конфигурации, а также PID-файлов. Для этого создадим новый Unit для работы с шаблонами (`/etc/systemd/system/nginx@.service`):

```
root@systemd-lab:/home/vagrant# cat /etc/systemd/system/nginx@.service

# Stop dance for nginx
# =======================
#
# ExecStop sends SIGSTOP (graceful stop) to the nginx process.
# If, after 5s (--retry QUIT/5) nginx is still running, systemd takes control
# and sends SIGTERM (fast shutdown) to the main process.
# After another 5s (TimeoutStopSec=5), and if nginx is alive, systemd sends
# SIGKILL to all the remaining processes in the process group (KillMode=mixed).
#
# nginx signals reference doc:
# http://nginx.org/en/docs/control.html
#
[Unit]
Description=A high performance web server and a reverse proxy server
Documentation=man:nginx(8)
After=network.target nss-lookup.target

[Service]
Type=forking
PIDFile=/run/nginx-%I.pid
ExecStartPre=/usr/sbin/nginx -t -c /etc/nginx/nginx-%I.conf -q -g 'daemon on; master_process on;'
ExecStart=/usr/sbin/nginx -c /etc/nginx/nginx-%I.conf -g 'daemon on; master_process on;'
ExecReload=/usr/sbin/nginx -c /etc/nginx/nginx-%I.conf -g 'daemon on; master_process on;' -s reload
ExecStop=-/sbin/start-stop-daemon --quiet --stop --retry QUIT/5 --pidfile /run/nginx-%I.pid
TimeoutStopSec=5
KillMode=mixed

[Install]
WantedBy=multi-user.target
```

- Создаются два файла конфигурации nginx `/etc/nginx/nginx-first.conf` и `/etc/nginx/nginx-second.conf` путем модификации исходного, путем изменения путей до PID-файлов и назначения отдельных портов `9001` и `9002` соответственно:
```
pid /run/nginx-first.pid;

http {
…
	server {
		listen 9001;
	}
#include /etc/nginx/sites-enabled/*;
….
}
```
Полное содержимое файлов конфигурации можно увидеть здесь: [nginx-first.conf](https://github.com/egorvshch/linux_pro_admin_course/blob/main/homework10/nginx_files/nginx-first.conf) и [nginx-second.conf](https://github.com/egorvshch/linux_pro_admin_course/blob/main/homework10/nginx_files/nginx-second.conf)

- Запуск и проверка статуса сервиса:

```
root@systemd-lab:/home/vagrant# systemctl start nginx@first
root@systemd-lab:/home/vagrant# systemctl start nginx@second
```
#Статус первого процесса `nginx@first`
```
root@systemd-lab:/home/vagrant# systemctl status nginx@first
● nginx@first.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/etc/systemd/system/nginx@.service; disabled; vendor preset: enabled)
     Active: active (running) since Sun 2024-06-23 19:12:43 UTC; 5min ago
       Docs: man:nginx(8)
    Process: 11995 ExecStartPre=/usr/sbin/nginx -t -c /etc/nginx/nginx-first.conf -q -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
    Process: 11996 ExecStart=/usr/sbin/nginx -c /etc/nginx/nginx-first.conf -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
   Main PID: 11997 (nginx)
      Tasks: 3 (limit: 1102)
     Memory: 3.7M
        CPU: 141ms
     CGroup: /system.slice/system-nginx.slice/nginx@first.service
             ├─11997 "nginx: master process /usr/sbin/nginx -c /etc/nginx/nginx-first.conf -g daemon on; master_process on;"
             ├─11998 "nginx: worker process" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" ""
             └─11999 "nginx: worker process" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" ""

Jun 23 19:12:43 systemd-lab systemd[1]: Starting A high performance web server and a reverse proxy server...
Jun 23 19:12:43 systemd-lab systemd[1]: Started A high performance web server and a reverse proxy server.
root@systemd-lab:/home/vagrant#
```
#Статус второго процесса `nginx@second`
```
root@systemd-lab:/home/vagrant#  systemctl status nginx@second
● nginx@second.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/etc/systemd/system/nginx@.service; disabled; vendor preset: enabled)
     Active: active (running) since Sun 2024-06-23 19:12:44 UTC; 5min ago
       Docs: man:nginx(8)
    Process: 12001 ExecStartPre=/usr/sbin/nginx -t -c /etc/nginx/nginx-second.conf -q -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
    Process: 12002 ExecStart=/usr/sbin/nginx -c /etc/nginx/nginx-second.conf -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
   Main PID: 12003 (nginx)
      Tasks: 3 (limit: 1102)
     Memory: 3.3M
        CPU: 123ms
     CGroup: /system.slice/system-nginx.slice/nginx@second.service
             ├─12003 "nginx: master process /usr/sbin/nginx -c /etc/nginx/nginx-second.conf -g daemon on; master_process on;"
             ├─12004 "nginx: worker process" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" ""
             └─12005 "nginx: worker process" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" "" ""

Jun 23 19:12:43 systemd-lab systemd[1]: Starting A high performance web server and a reverse proxy server...
Jun 23 19:12:44 systemd-lab systemd[1]: Started A high performance web server and a reverse proxy server.
```
#Проверка прослушиваемых портов:
```
root@systemd-lab:/home/vagrant# ss -tnulp | grep nginx
tcp   LISTEN 0      511             0.0.0.0:9002      0.0.0.0:*    users:(("nginx",pid=12005,fd=6),("nginx",pid=12004,fd=6),("nginx",pid=12003,fd=6))                                                                                                                  
tcp   LISTEN 0      511             0.0.0.0:9001      0.0.0.0:*    users:(("nginx",pid=11999,fd=6),("nginx",pid=11998,fd=6),("nginx",pid=11997,fd=6))
```
#Проверка количества работающих процессов nginx:
```
root@systemd-lab:/home/vagrant# ps afx | grep nginx
  12299 pts/1    S+     0:00                              \_ grep --color=auto nginx
  11997 ?        Ss     0:00 nginx: master process /usr/sbin/nginx -c /etc/nginx/nginx-first.conf -g daemon on; master_process on;
  11998 ?        S      0:00  \_ nginx: worker process
  11999 ?        S      0:00  \_ nginx: worker process
  12003 ?        Ss     0:00 nginx: master process /usr/sbin/nginx -c /etc/nginx/nginx-second.conf -g daemon on; master_process on;
  12004 ?        S      0:00  \_ nginx: worker process
  12005 ?        S      0:00  \_ nginx: worker process
```
