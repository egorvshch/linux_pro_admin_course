Домашнее задание "Настройка мониторинга"
-----------------------------------------
Настроить дашборд с 4-мя графиками:
- память;
- процессор;
- диск;
- сеть.
Настроить на одной из систем:
- zabbix (использовать screen (комплексный экран);
- prometheus - grafana.

В качестве результата прислать скриншот экрана - дашборд должен содержать в названии имя приславшего.

Результаты:
-----------------------------------------
Решение ДЗ выполнено с использованием prometheus - grafana.
В качестве хостовой системы использовалась VM c OS Ubuntu 22.04.4 LTS, развернутая в VirtualBox

Краткое описание процесса выполнения:
- установлен prometheus-2.45.3.linux-amd64 согласно инструкции;
- на эту же ВМ установлен экспортер prometheus-node-exporter (smartmontools.service/smartd);
- выполнена настройка конфигурационного файла prometheus.yml, добавлены соответсвующие job и targets;
- установлена grafana-enterprise_10.2.3_amd64 согласно инструкции;
- выполнил интеграцию grafana и prometheus, добавив адрес prometheus в Data Sources в Connections;
- для настройки графиков использовал готовый [Dashboards](https://grafana.com/grafana/dashboards/6126-node-dashboard/) с id 6126.
  К названию дашборда добавил свои имя и фамилию; 
- скорретировал состав графиков и перераспределил их по требуемым категориям и `row` в соответствии с заданием.

### Скрины графиков:
- сводные данные по статусу CPU, Memory, Disk:
![Image 1](https://github.com/egorvshch/linux_pro_admin_course/blob/main/homework15/screenshots/screen_01.JPG)
- CPU:
![Image 1](https://github.com/egorvshch/linux_pro_admin_course/blob/main/homework15/screenshots/screen_02.JPG)
- Memory:
![Image 1](https://github.com/egorvshch/linux_pro_admin_course/blob/main/homework15/screenshots/screen_03.JPG)
- Disk:
![Image 1](https://github.com/egorvshch/linux_pro_admin_course/blob/main/homework15/screenshots/screen_04.JPG)
- Network:
![Image 1](https://github.com/egorvshch/linux_pro_admin_course/blob/main/homework15/screenshots/screen_05.JPG)


