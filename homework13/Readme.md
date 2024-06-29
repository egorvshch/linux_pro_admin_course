Домашнее задание по SELinux
-----------------------------------------

#### Описание задания

1. Запустить nginx на нестандартном порту 3-мя разными способами:
- переключатели setsebool;
- добавление нестандартного порта в имеющийся тип;
- формирование и установка модуля SELinux.

2. Обеспечить работоспособность приложения при включенном selinux.
- развернуть приложенный стенд https://github.com/mbfx/otus-linux-adm/tree/master/selinux_dns_problems;
- выяснить причину неработоспособности механизма обновления зоны (см. README);
- редложить решение (или решения) для данной проблемы;
- выбрать одно из решений для реализации, предварительно обосновав выбор;
- реализовать выбранное решение и продемонстрировать его работоспособность.

Результаты:
----------

### ЗАДАНИЕ 1. Запуск nginx на нестандартном порту 3-мя разными способами: 
- переключатели setsebool;
- добавление нестандартного порта в имеющийся тип;
- формирование и установка модуля SELinux.

**Задания выполняются на ВМ с использованием:**
- VirtualBox 7.0.12,
- Vagrant 2.4.1,
- Vagrant Box "centos/7" (version 2004.01)
- Хостовая система: Ubuntu  22.04

***Запуск стенда:***

```
vagrunt up
vagrunt ssh
```
Результатом выполнения команды vagrant up станет созданная виртуальная машина с установленным nginx, который работает на порту TCP 4881. Порт TCP 4881 уже проброшен до хоста. SELinux включен.

После запуска ВМ, проверяем запущен ли nginx:
 
 ```[root@selinux ~]# systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
   Active: failed (Result: exit-code) since Sat 2024-06-29 09:54:22 UTC; 1s ago
  Process: 4210 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
  Process: 23074 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=1/FAILURE)
  Process: 23073 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
 Main PID: 4212 (code=exited, status=0/SUCCESS)

Jun 29 09:54:22 selinux systemd[1]: Stopped The nginx HTTP and reverse proxy server.
Jun 29 09:54:22 selinux systemd[1]: Starting The nginx HTTP and reverse proxy server...
Jun 29 09:54:22 selinux nginx[23074]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
Jun 29 09:54:22 selinux nginx[23074]: nginx: [emerg] bind() to 0.0.0.0:4881 failed (13: Permission denied)
Jun 29 09:54:22 selinux nginx[23074]: nginx: configuration file /etc/nginx/nginx.conf test failed
Jun 29 09:54:22 selinux systemd[1]: nginx.service: control process exited, code=exited status=1
Jun 29 09:54:22 selinux systemd[1]: Failed to start The nginx HTTP and reverse proxy server.
Jun 29 09:54:22 selinux systemd[1]: Unit nginx.service entered failed state.
Jun 29 09:54:22 selinux systemd[1]: nginx.service failed.
```

Хотя сама конфигурация nginx выполнена без ошибок:
```
[root@selinux ~]# nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```
Проверим режим работы SELinux: getenforce:
```
[root@selinux ~]# getenforce 
Enforcing
```
Enforcing. Данный режим означает, что SELinux будет блокировать запрещенную активность.

Для работы с инструментами SELinux установим соответствующие пакеты (вывод журнала установки не представлен):

```
[root@selinux ~]# yum install -y setroubleshoot-server selinux-policy-mls setools-console policycoreutils-newrole
```

#### Способ 1. Разрешим в SELinux работу nginx на порту TCP 4881 c помощью переключателей setsebool

- Находим в логах (/var/log/audit/audit.log) информацию о блокировании порта:
```
[root@selinux ~]# cat /var/log/audit/audit.log | grep permi
type=AVC msg=audit(1719654862.733:887): avc:  denied  { name_bind } for  pid=3065 comm="nginx" src=4881 scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:unreserved_port_t:s0 tclass=tcp_socket permissive=0
[root@selinux ~]#
```
- Копируем время, в которое был записан этот лог, и с помощью утилиты **audit2why** смотрим grep 1719654862.733:887 /var/log/audit/audit.log | audit2why

```
[root@selinux ~]# grep 1719654862.733:887 /var/log/audit/audit.log 
type=AVC msg=audit(1719654862.733:887): avc:  denied  { name_bind } for  pid=3065 comm="nginx" src=4881 scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:unreserved_port_t:s0 tclass=tcp_socket permissive=0
type=SYSCALL msg=audit(1719654862.733:887): arch=c000003e syscall=49 success=no exit=-13 a0=6 a1=55e88c82f7e8 a2=10 a3=7ffddb98ec70 items=0 ppid=1 pid=3065 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="nginx" exe="/usr/sbin/nginx" subj=system_u:system_r:httpd_t:s0 key=(null)
type=PROCTITLE msg=audit(1719654862.733:887): proctitle=2F7573722F7362696E2F6E67696E78002D74
[root@selinux ~]# 
[root@selinux ~]# grep 1719654862.733:887 /var/log/audit/audit.log | audit2why
type=AVC msg=audit(1719654862.733:887): avc:  denied  { name_bind } for  pid=3065 comm="nginx" src=4881 scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:unreserved_port_t:s0 tclass=tcp_socket permissive=0

	Was caused by:
	The boolean nis_enabled was set incorrectly. 
	Description:
	Allow nis to enabled

	Allow access by executing:
	# setsebool -P nis_enabled 1
[root@selinux ~]#
```
Утилита audit2why покажет почему трафик блокируется. Исходя из вывода утилиты, мы видим, что нам нужно поменять параметр nis_enabled.

- Включим параметр nis_enabled и перезапустим nginx: setsebool -P nis_enabled on:

```
[root@selinux ~]# setsebool -P nis_enabled on
[root@selinux ~]# systemctl restart nginx
[root@selinux ~]# systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
   Active: active (running) since Sat 2024-06-29 10:08:38 UTC; 10s ago
  Process: 4087 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
  Process: 4085 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
  Process: 4083 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
 Main PID: 4089 (nginx)
   CGroup: /system.slice/nginx.service
           ├─4089 nginx: master process /usr/sbin/nginx
           └─4091 nginx: worker process

Jun 29 10:08:38 selinux systemd[1]: Starting The nginx HTTP and reverse proxy server...
Jun 29 10:08:38 selinux nginx[4085]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
Jun 29 10:08:38 selinux nginx[4085]: nginx: configuration file /etc/nginx/nginx.conf test is successful
Jun 29 10:08:38 selinux systemd[1]: Started The nginx HTTP and reverse proxy server.

```

Также можно проверить работу nginx открыв страницу по адресу http://127.0.0.1:4881 :

<details>
  <summary>  [root@selinux ~]# curl http://127.0.0.1:4881  </summary>
	
```
[root@selinux ~]# curl http://127.0.0.1:4881
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <title>Welcome to CentOS</title>
  <style rel="stylesheet" type="text/css"> 

	html {
	background-image:url(img/html-background.png);
	background-color: white;
	font-family: "DejaVu Sans", "Liberation Sans", sans-serif;
	font-size: 0.85em;
	line-height: 1.25em;
	margin: 0 4% 0 4%;
	}

	body {
	border: 10px solid #fff;
	margin:0;
	padding:0;
	background: #fff;
	}

	/* Links */

	a:link { border-bottom: 1px dotted #ccc; text-decoration: none; color: #204d92; }
	a:hover { border-bottom:1px dotted #ccc; text-decoration: underline; color: green; }
	a:active {  border-bottom:1px dotted #ccc; text-decoration: underline; color: #204d92; }
	a:visited { border-bottom:1px dotted #ccc; text-decoration: none; color: #204d92; }
	a:visited:hover { border-bottom:1px dotted #ccc; text-decoration: underline; color: green; }
 
	.logo a:link,
	.logo a:hover,
	.logo a:visited { border-bottom: none; }

	.mainlinks a:link { border-bottom: 1px dotted #ddd; text-decoration: none; color: #eee; }
	.mainlinks a:hover { border-bottom:1px dotted #ddd; text-decoration: underline; color: white; }
	.mainlinks a:active { border-bottom:1px dotted #ddd; text-decoration: underline; color: white; }
	.mainlinks a:visited { border-bottom:1px dotted #ddd; text-decoration: none; color: white; }
	.mainlinks a:visited:hover { border-bottom:1px dotted #ddd; text-decoration: underline; color: white; }

	/* User interface styles */

	#header {
	margin:0;
	padding: 0.5em;
	background: #204D8C url(img/header-background.png);
	text-align: left;
	}

	.logo {
	padding: 0;
	/* For text only logo */
	font-size: 1.4em;
	line-height: 1em;
	font-weight: bold;
	}

	.logo img {
	vertical-align: middle;
	padding-right: 1em;
	}

	.logo a {
	color: #fff;
	text-decoration: none;
	}

	p {
	line-height:1.5em;
	}

	h1 { 
		margin-bottom: 0;
		line-height: 1.9em; }
	h2 { 
		margin-top: 0;
		line-height: 1.7em; }

	#content {
	clear:both;
	padding-left: 30px;
	padding-right: 30px;
	padding-bottom: 30px;
	border-bottom: 5px solid #eee;
	}

    .mainlinks {
        float: right;
        margin-top: 0.5em;
        text-align: right;
    }

    ul.mainlinks > li {
    border-right: 1px dotted #ddd;
    padding-right: 10px;
    padding-left: 10px;
    display: inline;
    list-style: none;
    }

    ul.mainlinks > li.last,
    ul.mainlinks > li.first {
    border-right: none;
    }

  </style>

</head>

<body>

<div id="header">

    <ul class="mainlinks">
        <li> <a href="http://www.centos.org/">Home</a> </li>
        <li> <a href="http://wiki.centos.org/">Wiki</a> </li>
        <li> <a href="http://wiki.centos.org/GettingHelp/ListInfo">Mailing Lists</a></li>
        <li> <a href="http://www.centos.org/download/mirrors/">Mirror List</a></li>
        <li> <a href="http://wiki.centos.org/irc">IRC</a></li>
        <li> <a href="https://www.centos.org/forums/">Forums</a></li>
        <li> <a href="http://bugs.centos.org/">Bugs</a> </li>
        <li class="last"> <a href="http://wiki.centos.org/Donate">Donate</a></li>
    </ul>

	<div class="logo">
		<a href="http://www.centos.org/"><img src="img/centos-logo.png" border="0"></a>
	</div>

</div>

<div id="content">

	<h1>Welcome to CentOS</h1>

	<h2>The Community ENTerprise Operating System</h2>

	<p><a href="http://www.centos.org/">CentOS</a> is an Enterprise-class Linux Distribution derived from sources freely provided
to the public by Red Hat, Inc. for Red Hat Enterprise Linux.  CentOS conforms fully with the upstream vendors
redistribution policy and aims to be functionally compatible. (CentOS mainly changes packages to remove upstream vendor
branding and artwork.)</p>

	<p>CentOS is developed by a small but growing team of core
developers.&nbsp; In turn the core developers are supported by an active user community
including system administrators, network administrators, enterprise users, managers, core Linux contributors and Linux enthusiasts from around the world.</p>

	<p>CentOS has numerous advantages including: an active and growing user community, quickly rebuilt, tested, and QA'ed errata packages, an extensive <a href="http://www.centos.org/download/mirrors/">mirror network</a>, developers who are contactable and responsive, Special Interest Groups (<a href="http://wiki.centos.org/SpecialInterestGroup/">SIGs</a>) to add functionality to the core CentOS distribution, and multiple community support avenues including a <a href="http://wiki.centos.org/">wiki</a>, <a
href="http://wiki.centos.org/irc">IRC Chat</a>, <a href="http://wiki.centos.org/GettingHelp/ListInfo">Email Lists</a>, <a href="https://www.centos.org/forums/">Forums</a>, <a href="http://bugs.centos.org/">Bugs Database</a>, and an <a
href="http://wiki.centos.org/FAQ/">FAQ</a>.</p>

	</div>

</div>


</body>
</html>
```
</details>

- Проверить статус параметра можно с помощью команды: getsebool -a | grep nis_enabled

```
[root@selinux ~]# getsebool -a | grep nis_enabled
nis_enabled --> on
[root@selinux ~]# 
```
- Вернём запрет работы nginx на порту 4881 обратно. Для этого отключим nis_enabled: setsebool -P nis_enabled off
После отключения nis_enabled служба nginx снова не запустится:

```
[root@selinux ~]# setsebool -P nis_enabled off
[root@selinux ~]# systemctl restart nginx
Job for nginx.service failed because the control process exited with error code. See "systemctl status nginx.service" and "journalctl -xe" for details.
[root@selinux ~]# 
```
#### Способ 2. Разрешение в SELinux работы nginx на порту TCP 4881 c помощью добавления нестандартного порта в имеющийся тип:

- Поиск имеющегося типа, для http трафика: semanage port -l | grep http
```
[root@selinux ~]# 
[root@selinux ~]# semanage port -l | grep http
http_cache_port_t              tcp      8080, 8118, 8123, 10001-10010
http_cache_port_t              udp      3130
http_port_t                    tcp      80, 81, 443, 488, 8008, 8009, 8443, 9000
pegasus_http_port_t            tcp      5988
pegasus_https_port_t           tcp      5989
[root@selinux ~]# 
```
- Добавим порт в тип http_port_t: emanage port -a -t http_port_t -p tcp 4881:
```
[root@selinux ~]# semanage port -a -t http_port_t -p tcp 4881
[root@selinux ~]# 
[root@selinux ~]# 
[root@selinux ~]# semanage port -l | grep http
http_cache_port_t              tcp      8080, 8118, 8123, 10001-10010
http_cache_port_t              udp      3130
http_port_t                    tcp      4881, 80, 81, 443, 488, 8008, 8009, 8443, 9000
pegasus_http_port_t            tcp      5988
pegasus_https_port_t           tcp      5989
[root@selinux ~]# 
```
- Теперь перезапустим службу nginx и проверим её работу: systemctl restart nginx
```
[root@selinux ~]# 
[root@selinux ~]# systemctl restart nginx
[root@selinux ~]# 
[root@selinux ~]# systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
   Active: active (running) since Sat 2024-06-29 10:11:29 UTC; 6s ago
  Process: 4148 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
  Process: 4146 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
  Process: 4145 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
 Main PID: 4150 (nginx)
   CGroup: /system.slice/nginx.service
           ├─4150 nginx: master process /usr/sbin/nginx
           └─4151 nginx: worker process

Jun 29 10:11:29 selinux systemd[1]: Starting The nginx HTTP and reverse proxy server...
Jun 29 10:11:29 selinux nginx[4146]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
Jun 29 10:11:29 selinux nginx[4146]: nginx: configuration file /etc/nginx/nginx.conf test is successful
Jun 29 10:11:29 selinux systemd[1]: Started The nginx HTTP and reverse proxy server.
[root@selinux ~]# 

```
- Также можно проверить работу nginx открыв страницу по адресу http://127.0.0.1:4881 :

<details>
  <summary>  [root@selinux ~]# curl http://127.0.0.1:4881  </summary>
	
```
[root@selinux ~]# curl http://127.0.0.1:4881
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <title>Welcome to CentOS</title>
  <style rel="stylesheet" type="text/css"> 

	html {
	background-image:url(img/html-background.png);
	background-color: white;
	font-family: "DejaVu Sans", "Liberation Sans", sans-serif;
	font-size: 0.85em;
	line-height: 1.25em;
	margin: 0 4% 0 4%;
	}

	body {
	border: 10px solid #fff;
	margin:0;
	padding:0;
	background: #fff;
	}

	/* Links */

	a:link { border-bottom: 1px dotted #ccc; text-decoration: none; color: #204d92; }
	a:hover { border-bottom:1px dotted #ccc; text-decoration: underline; color: green; }
	a:active {  border-bottom:1px dotted #ccc; text-decoration: underline; color: #204d92; }
	a:visited { border-bottom:1px dotted #ccc; text-decoration: none; color: #204d92; }
	a:visited:hover { border-bottom:1px dotted #ccc; text-decoration: underline; color: green; }
 
	.logo a:link,
	.logo a:hover,
	.logo a:visited { border-bottom: none; }

	.mainlinks a:link { border-bottom: 1px dotted #ddd; text-decoration: none; color: #eee; }
	.mainlinks a:hover { border-bottom:1px dotted #ddd; text-decoration: underline; color: white; }
	.mainlinks a:active { border-bottom:1px dotted #ddd; text-decoration: underline; color: white; }
	.mainlinks a:visited { border-bottom:1px dotted #ddd; text-decoration: none; color: white; }
	.mainlinks a:visited:hover { border-bottom:1px dotted #ddd; text-decoration: underline; color: white; }

	/* User interface styles */

	#header {
	margin:0;
	padding: 0.5em;
	background: #204D8C url(img/header-background.png);
	text-align: left;
	}

	.logo {
	padding: 0;
	/* For text only logo */
	font-size: 1.4em;
	line-height: 1em;
	font-weight: bold;
	}

	.logo img {
	vertical-align: middle;
	padding-right: 1em;
	}

	.logo a {
	color: #fff;
	text-decoration: none;
	}

	p {
	line-height:1.5em;
	}

	h1 { 
		margin-bottom: 0;
		line-height: 1.9em; }
	h2 { 
		margin-top: 0;
		line-height: 1.7em; }

	#content {
	clear:both;
	padding-left: 30px;
	padding-right: 30px;
	padding-bottom: 30px;
	border-bottom: 5px solid #eee;
	}

    .mainlinks {
        float: right;
        margin-top: 0.5em;
        text-align: right;
    }

    ul.mainlinks > li {
    border-right: 1px dotted #ddd;
    padding-right: 10px;
    padding-left: 10px;
    display: inline;
    list-style: none;
    }

    ul.mainlinks > li.last,
    ul.mainlinks > li.first {
    border-right: none;
    }

  </style>

</head>

<body>

<div id="header">

    <ul class="mainlinks">
        <li> <a href="http://www.centos.org/">Home</a> </li>
        <li> <a href="http://wiki.centos.org/">Wiki</a> </li>
        <li> <a href="http://wiki.centos.org/GettingHelp/ListInfo">Mailing Lists</a></li>
        <li> <a href="http://www.centos.org/download/mirrors/">Mirror List</a></li>
        <li> <a href="http://wiki.centos.org/irc">IRC</a></li>
        <li> <a href="https://www.centos.org/forums/">Forums</a></li>
        <li> <a href="http://bugs.centos.org/">Bugs</a> </li>
        <li class="last"> <a href="http://wiki.centos.org/Donate">Donate</a></li>
    </ul>

	<div class="logo">
		<a href="http://www.centos.org/"><img src="img/centos-logo.png" border="0"></a>
	</div>

</div>

<div id="content">

	<h1>Welcome to CentOS</h1>

	<h2>The Community ENTerprise Operating System</h2>

	<p><a href="http://www.centos.org/">CentOS</a> is an Enterprise-class Linux Distribution derived from sources freely provided
to the public by Red Hat, Inc. for Red Hat Enterprise Linux.  CentOS conforms fully with the upstream vendors
redistribution policy and aims to be functionally compatible. (CentOS mainly changes packages to remove upstream vendor
branding and artwork.)</p>

	<p>CentOS is developed by a small but growing team of core
developers.&nbsp; In turn the core developers are supported by an active user community
including system administrators, network administrators, enterprise users, managers, core Linux contributors and Linux enthusiasts from around the world.</p>

	<p>CentOS has numerous advantages including: an active and growing user community, quickly rebuilt, tested, and QA'ed errata packages, an extensive <a href="http://www.centos.org/download/mirrors/">mirror network</a>, developers who are contactable and responsive, Special Interest Groups (<a href="http://wiki.centos.org/SpecialInterestGroup/">SIGs</a>) to add functionality to the core CentOS distribution, and multiple community support avenues including a <a href="http://wiki.centos.org/">wiki</a>, <a
href="http://wiki.centos.org/irc">IRC Chat</a>, <a href="http://wiki.centos.org/GettingHelp/ListInfo">Email Lists</a>, <a href="https://www.centos.org/forums/">Forums</a>, <a href="http://bugs.centos.org/">Bugs Database</a>, and an <a
href="http://wiki.centos.org/FAQ/">FAQ</a>.</p>

	</div>

</div>


</body>
</html>
```
</details>

- Удалим нестандартный порт из имеющегося типа с помощью команды: semanage port -d -t http_port_t -p tcp 4881 и перезапустим nginx и убедимся, что nginx не запустится:

```
[root@selinux ~]# semanage port -d -t http_port_t -p tcp 4881
[root@selinux ~]# systemctl restart nginx
Job for nginx.service failed because the control process exited with error code. See "systemctl status nginx.service" and "journalctl -xe" for details.
[root@selinux ~]# 
[root@selinux ~]# systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
   Active: failed (Result: exit-code) since Sat 2024-06-29 10:12:42 UTC; 7s ago
  Process: 4148 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
  Process: 4169 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=1/FAILURE)
  Process: 4168 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
 Main PID: 4150 (code=exited, status=0/SUCCESS)

Jun 29 10:12:41 selinux systemd[1]: Stopped The nginx HTTP and reverse proxy server.
Jun 29 10:12:41 selinux systemd[1]: Starting The nginx HTTP and reverse proxy server...
Jun 29 10:12:42 selinux nginx[4169]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
Jun 29 10:12:42 selinux nginx[4169]: nginx: [emerg] bind() to 0.0.0.0:4881 failed (13: Permission denied)
Jun 29 10:12:42 selinux nginx[4169]: nginx: configuration file /etc/nginx/nginx.conf test failed
Jun 29 10:12:42 selinux systemd[1]: nginx.service: control process exited, code=exited status=1
Jun 29 10:12:42 selinux systemd[1]: Failed to start The nginx HTTP and reverse proxy server.
Jun 29 10:12:42 selinux systemd[1]: Unit nginx.service entered failed state.
Jun 29 10:12:42 selinux systemd[1]: nginx.service failed.
```

#### Способ 3. Разрешение в SELinux работы nginx на порту TCP 4881 c помощью формирования и установки модуля SELinux:
- Посмотрим логи SELinux, которые относятся к nginx: grep nginx /var/log/audit/audit.log

```
[root@selinux ~]# grep nginx /var/log/audit/audit.log
type=SOFTWARE_UPDATE msg=audit(1719654860.810:885): pid=2889 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='sw="nginx-filesystem-1:1.20.1-10.el7.noarch" sw_type=rpm key_enforce=0 gpg_res=1 root_dir="/" comm="yum" exe="/usr/bin/python2.7" hostname=? addr=? terminal=? res=success'
type=SOFTWARE_UPDATE msg=audit(1719654861.666:886): pid=2889 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='sw="nginx-1:1.20.1-10.el7.x86_64" sw_type=rpm key_enforce=0 gpg_res=1 root_dir="/" comm="yum" exe="/usr/bin/python2.7" hostname=? addr=? terminal=? res=success'
type=AVC msg=audit(1719654862.733:887): avc:  denied  { name_bind } for  pid=3065 comm="nginx" src=4881 scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:unreserved_port_t:s0 tclass=tcp_socket permissive=0
type=SYSCALL msg=audit(1719654862.733:887): arch=c000003e syscall=49 success=no exit=-13 a0=6 a1=55e88c82f7e8 a2=10 a3=7ffddb98ec70 items=0 ppid=1 pid=3065 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="nginx" exe="/usr/sbin/nginx" subj=system_u:system_r:httpd_t:s0 key=(null)
type=SERVICE_START msg=audit(1719654862.733:888): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=nginx comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=failed'
type=SERVICE_START msg=audit(1719655718.395:989): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=nginx comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=SERVICE_STOP msg=audit(1719655809.207:994): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=nginx comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=AVC msg=audit(1719655809.207:995): avc:  denied  { name_bind } for  pid=4113 comm="nginx" src=4881 scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:unreserved_port_t:s0 tclass=tcp_socket permissive=0
type=SYSCALL msg=audit(1719655809.207:995): arch=c000003e syscall=49 success=no exit=-13 a0=6 a1=5627a72527e8 a2=10 a3=7ffd6831f8f0 items=0 ppid=1 pid=4113 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="nginx" exe="/usr/sbin/nginx" subj=system_u:system_r:httpd_t:s0 key=(null)
type=SERVICE_START msg=audit(1719655809.333:996): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=nginx comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=failed'
type=SERVICE_START msg=audit(1719655889.936:1000): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=nginx comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=SERVICE_STOP msg=audit(1719655961.943:1004): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=nginx comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=AVC msg=audit(1719655961.988:1005): avc:  denied  { name_bind } for  pid=4169 comm="nginx" src=4881 scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:unreserved_port_t:s0 tclass=tcp_socket permissive=0
type=SYSCALL msg=audit(1719655961.988:1005): arch=c000003e syscall=49 success=no exit=-13 a0=6 a1=55a2f24357e8 a2=10 a3=7ffd31507820 items=0 ppid=1 pid=4169 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="nginx" exe="/usr/sbin/nginx" subj=system_u:system_r:httpd_t:s0 key=(null)
type=SERVICE_START msg=audit(1719655961.988:1006): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=nginx comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=failed'
[root@selinux ~]# 
```
- Воспользуемся утилитой **audit2allow** для того, чтобы на основе логов SELinux сделать модуль, разрешающий работу nginx на нестандартном порту:
grep nginx /var/log/audit/audit.log | audit2allow -M nginx

```
[root@selinux ~]# 
[root@selinux ~]# grep nginx /var/log/audit/audit.log | audit2allow -M nginx
******************** IMPORTANT ***********************
To make this policy package active, execute:

semodule -i nginx.pp
[root@selinux ~]# 
```
- **Audit2allow** сформировал модуль, и сообщил нам команду, с помощью которой можно применить данный модуль: semodule -i nginx.pp
Запустим команду и проверим работу nginx, запустив его повторно:

```
[root@selinux ~]# semodule -i nginx.pp
[root@selinux ~]# 
[root@selinux ~]# systemctl start nginx
[root@selinux ~]# systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
   Active: **active** (running) since Sat 2024-06-29 10:14:46 UTC; 2s ago
  Process: 4210 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
  Process: 4207 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
  Process: 4206 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
 Main PID: 4212 (nginx)
   CGroup: /system.slice/nginx.service
           ├─4212 nginx: master process /usr/sbin/nginx
           └─4214 nginx: worker process

Jun 29 10:14:46 selinux systemd[1]: Starting The nginx HTTP and reverse proxy server...
Jun 29 10:14:46 selinux nginx[4207]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
Jun 29 10:14:46 selinux nginx[4207]: nginx: configuration file /etc/nginx/nginx.conf test is **successful**
Jun 29 10:14:46 selinux systemd[1]: Started The nginx HTTP and reverse proxy server.
[root@selinux ~]# 
```
После добавления модуля nginx запустился без ошибок. При использовании модуля изменения сохранятся после перезагрузки.

- Просмотр всех установленных модулей: semodule -l
- Удаление модуля командой: semodule -r nginx
```
[root@selinux ~]# 
[root@selinux ~]# semodule -l | grep nginx
nginx	1.0
[root@selinux ~]#  semodule -r nginx
libsemanage.semanage_direct_remove_key: Removing last nginx module (no other nginx module exists at another priority).
[root@selinux ~]# 
```
### ЗАДАНИЕ 2. Обеспечение работоспособности приложения при включенном SELinux
