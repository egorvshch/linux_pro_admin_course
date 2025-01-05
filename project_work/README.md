## Автоматизация развертывания и восстановления после сбоя WEB-сервиса с использованием Ansible

WEB-сервис реализован на базе CMS Wordpress с балансировщиком NGINX на Frontend, двумя Backend серверами на Apache, базой данных MySQL с репликацией Master-Slave, системой сбора логов ELK, системой сбора метрик и мониторинга Prometheus/Grafana с оповещением в Telegram

#### Задание:
Разаработать WEB-проект с развертыванием нескольких виртуальных машин, который должен отвечать следующим требованиям:
- включен https;
- основная инфраструктура в DMZ зоне;
- файрвалл на входе;
- сбор метрик и настроенный алертинг;
- организован централизованный сбор логов;
- организован backup.

### Описание решения:
***Используемый стек для стенда:***
- VirtualBox 7.0.12,
- Vagrant 2.4.1,
- Vagrant Box "bento/ubuntu-22.04", "bento/ubuntu-24.04"
- Хостовая система: Ubuntu 22.04.4 LTS
- Ansible 2.16.8

***Схема стенда:***

![Text](https://github.com/egorvshch/linux_pro_admin_course/blob/main/project_work/ext_files/schema_web_project_.jpg)

***Запуск стенда:***

```
vagrant up
vagrant ssh
```

В результате поднимется шесть VM:<br/>
```
root@evengtest:/home/eve/otus_exam/ansible# vagrant status
Current machine states:

frontngnx                 running (virtualbox)
backend1                  running (virtualbox)
backend2                  running (virtualbox)
dbmaster                  running (virtualbox)
dbslave                   running (virtualbox)
servermon                 running (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
```
***Настройка VM:***
Вся логика настройки VM с использованием Ansible описана в файле ```ansible/provision.yml```.<br/>
Запуск плейбука для соответствующей VM осуществляется с помощью тега, соответствующего названию VM.<br/>
Пример:<br/>
```
ansible-playbook provision.yml --tags frontngnx
```
Для первоначальной настройки и восстановления всех VM используется тот же тег, кроме основного сервера MySQL ```dbmaster```, для восстановления конфигурации после сбоя которого используется тег ```dbmaster_restore```;<br/>

Все задачи выполняемые в плейбуках имеют соответствующие названия и комментарии, и разбиты на следующие блоки:<br/>
- ```{{название_VM }}/main.yml``` - реализует основную конфигурацию VM (установка дистрибутива и конфигурацию приложений);<br/>
- ```{{название_VM }}/preinstall.yml``` - реализует дополнительные, но не основные настройки, т.к. настройка часового пояса, синхронизация времени, установка пакета prometheus-node-exporter, конфигурация маршрутов и пр.;<br/>
- ```{{название_VM }}/firewall.yml``` - реализует конфигурацию iptables на каждой VM;<br/>
- ```{{название_VM }}/main_restore.yml``` - реализует логику восстановления VM после сбоя;<br/>
<br/>

***Стек основного ПО для WEB-сервиса***:
  
- **frontngnx**: nginx, prometheus-node-exporter, filebeat_8.9.1;<br/>
- **backend1, backend2**: apache2, wordpress_6.7.1, prometheus-node-exporter;<br/>
- **dbmaster, dbslave**: mysql-server-8.0, prometheus-node-exporter;<br/>
- **servermon**: prometheus, prometheus-alertmanager, prometheus-node-exporter, default-jdk, grafana_11.4.0, logstash-8.16.2, elasticsearch-8.16.2, kibana-8.16.2.<br/>

### Результаты:
Доступ к сайту осуществляется по адресу https://my-stend.ru/, DNS прописан локально на ПК в hosts, для https используется самоподписной сертификат выпущенный также для my-stend.ru.<br/>

Проверка работы стенда и восстановления его работы без потери данных после сбоя на примере вывода из строя основного сервера БД ```dbmaster``` продемонстированы на [видео](https://disk.yandex.ru/i/S5LD1Chx6wmKlA).
<br/>
