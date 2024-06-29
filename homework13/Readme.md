    selinux: Complete!
    selinux: Job for nginx.service failed because the control process exited with error code. See "systemctl status nginx.service" and "journalctl -xe" for details.
    selinux: ● nginx.service - The nginx HTTP and reverse proxy server
    selinux:    Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
    selinux:    Active: failed (Result: exit-code) since Sat 2024-06-29 09:54:22 UTC; 22ms ago
    selinux:   Process: 3065 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=1/FAILURE)
    selinux:   Process: 3063 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
    selinux: 
    selinux: Jun 29 09:54:22 selinux systemd[1]: Starting The nginx HTTP and reverse proxy server...
    selinux: Jun 29 09:54:22 selinux nginx[3065]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
    selinux: Jun 29 09:54:22 selinux nginx[3065]: nginx: [emerg] bind() to 0.0.0.0:4881 failed (13: Permission denied)
    selinux: Jun 29 09:54:22 selinux nginx[3065]: nginx: configuration file /etc/nginx/nginx.conf test failed
    selinux: Jun 29 09:54:22 selinux systemd[1]: nginx.service: control process exited, code=exited status=1
    selinux: Jun 29 09:54:22 selinux systemd[1]: Failed to start The nginx HTTP and reverse proxy server.
    selinux: Jun 29 09:54:22 selinux systemd[1]: Unit nginx.service entered failed state.
    selinux: Jun 29 09:54:22 selinux systemd[1]: nginx.service failed.
The SSH command responded with a non-zero exit status. Vagrant
assumes that this means the command failed. The output for this command
should be in the log above. Please read the output to determine what
went wrong.
root@evengtest:/home/eve/test_vm2# vagrant ssh
[vagrant@selinux ~]$ sudo -i
[root@selinux ~]# 
[root@selinux ~]# systemctl status firewalld
● firewalld.service - firewalld - dynamic firewall daemon
   Loaded: loaded (/usr/lib/systemd/system/firewalld.service; disabled; vendor preset: enabled)
   Active: inactive (dead)
     Docs: man:firewalld(1)
[root@selinux ~]# nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
[root@selinux ~]# getenforce 
Enforcing
[root@selinux ~]# cat /var/log/audit/audit.log | grep err
[root@selinux ~]# cat /var/log/audit/audit.log | grep rr
[root@selinux ~]# cat /var/log/audit/audit.log | grep ermos
[root@selinux ~]# cat /var/log/audit/audit.log | grep ermis
type=AVC msg=audit(1719654862.733:887): avc:  denied  { name_bind } for  pid=3065 comm="nginx" src=4881 scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:unreserved_port_t:s0 tclass=tcp_socket permissive=0
[root@selinux ~]# grep 1719654862.733:887 /var/log/audit/audit.log | audit2why
-bash: audit2why: command not found
[root@selinux ~]# grep 1719654862.733:887 /var/log/audit/audit.log 
type=AVC msg=audit(1719654862.733:887): avc:  denied  { name_bind } for  pid=3065 comm="nginx" src=4881 scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:unreserved_port_t:s0 tclass=tcp_socket permissive=0
type=SYSCALL msg=audit(1719654862.733:887): arch=c000003e syscall=49 success=no exit=-13 a0=6 a1=55e88c82f7e8 a2=10 a3=7ffddb98ec70 items=0 ppid=1 pid=3065 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="nginx" exe="/usr/sbin/nginx" subj=system_u:system_r:httpd_t:s0 key=(null)
type=PROCTITLE msg=audit(1719654862.733:887): proctitle=2F7573722F7362696E2F6E67696E78002D74
[root@selinux ~]# 
[root@selinux ~]# 
[root@selinux ~]# grep 1719654862.733:887 /var/log/audit/audit.log 
type=AVC msg=audit(1719654862.733:887): avc:  denied  { name_bind } for  pid=3065 comm="nginx" src=4881 scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:unreserved_port_t:s0 tclass=tcp_socket permissive=0
type=SYSCALL msg=audit(1719654862.733:887): arch=c000003e syscall=49 success=no exit=-13 a0=6 a1=55e88c82f7e8 a2=10 a3=7ffddb98ec70 items=0 ppid=1 pid=3065 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="nginx" exe="/usr/sbin/nginx" subj=system_u:system_r:httpd_t:s0 key=(null)
type=PROCTITLE msg=audit(1719654862.733:887): proctitle=2F7573722F7362696E2F6E67696E78002D74
[root@selinux ~]# cat /var/log/audit/audit.log 
type=DAEMON_START msg=audit(1719654694.997:6472): op=start ver=2.8.5 format=raw kernel=3.10.0-1127.el7.x86_64 auid=4294967295 pid=282 uid=0 ses=4294967295 subj=system_u:system_r:auditd_t:s0 res=success
type=CONFIG_CHANGE msg=audit(1719654696.002:5): audit_backlog_limit=8192 old=64 auid=4294967295 ses=4294967295 subj=system_u:system_r:unconfined_service_t:s0 res=1
type=CONFIG_CHANGE msg=audit(1719654696.002:6): audit_failure=1 old=1 auid=4294967295 ses=4294967295 subj=system_u:system_r:unconfined_service_t:s0 res=1
type=SERVICE_START msg=audit(1719654696.002:7): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=auditd comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=SYSTEM_BOOT msg=audit(1719654696.064:8): pid=311 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg=' comm="systemd-update-utmp" exe="/usr/lib/systemd/systemd-update-utmp" hostname=? addr=? terminal=? res=success'
type=SERVICE_START msg=audit(1719654696.064:9): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=systemd-update-utmp comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=SERVICE_START msg=audit(1719654696.249:10): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=systemd-vconsole-setup comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=SERVICE_START msg=audit(1719654697.488:11): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=systemd-hwdb-update comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=SERVICE_START msg=audit(1719654697.664:12): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=systemd-update-done comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=SERVICE_START msg=audit(1719654698.173:13): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=systemd-udev-trigger comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=SERVICE_START msg=audit(1719654698.606:14): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=dbus comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=SERVICE_START msg=audit(1719654698.687:15): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=irqbalance comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=SERVICE_START msg=audit(1719654698.954:16): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=rpcbind comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=SERVICE_START msg=audit(1719654699.251:17): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=rhel-dmesg comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=SERVICE_STOP msg=audit(1719654699.542:18): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=irqbalance comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=SERVICE_START msg=audit(1719654700.006:19): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=systemd-logind comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=SERVICE_START msg=audit(1719654700.261:20): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=gssproxy comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=SERVICE_START msg=audit(1719654701.200:21): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=chronyd comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=SERVICE_START msg=audit(1719654701.570:22): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=systemd-user-sessions comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=SERVICE_START msg=audit(1719654701.627:23): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=getty@tty1 comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=SERVICE_START msg=audit(1719654701.656:24): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=crond comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=SERVICE_START msg=audit(1719654702.246:25): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=NetworkManager comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=SERVICE_START msg=audit(1719654703.758:26): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=polkit comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=SERVICE_START msg=audit(1719654703.770:27): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=systemd-hostnamed comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=SERVICE_START msg=audit(1719654704.003:28): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=NetworkManager-dispatcher comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=SERVICE_START msg=audit(1719654704.211:29): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=sshd-keygen comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=SERVICE_START msg=audit(1719654705.016:30): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=NetworkManager-wait-online comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=SERVICE_START msg=audit(1719654711.182:31): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=network comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=SERVICE_START msg=audit(1719654711.523:32): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=rpc-statd-notify comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=SERVICE_STOP msg=audit(1719654711.523:33): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=rpc-statd-notify comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=SERVICE_START msg=audit(1719654711.681:34): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=rsyslog comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=SERVICE_START msg=audit(1719654711.736:35): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=sshd comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654712.041:36): pid=691 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:a2:6b:81:8b:eb:b5:57:05:f0:50:15:5d:b0:ad:19:5f:40:cc:f8:dd:94:64:89:6a:53:b4:eb:24:f0:b0:1d:2a direction=? spid=691 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654712.072:37): pid=691 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:05:47:69:24:3b:ec:0c:78:36:c6:28:e9:a8:68:58:4b:68:df:31:dc:c3:cb:8d:d2:65:cf:d9:ff:b1:b1:c9:41 direction=? spid=691 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654712.079:38): pid=691 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=691 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=SERVICE_START msg=audit(1719654715.070:39): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=postfix comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=SERVICE_START msg=audit(1719654715.618:40): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=tuned comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=SYSTEM_RUNLEVEL msg=audit(1719654715.618:41): pid=920 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='old-level=N new-level=3 comm="systemd-update-utmp" exe="/usr/lib/systemd/systemd-update-utmp" hostname=? addr=? terminal=? res=success'
type=SERVICE_START msg=audit(1719654715.704:42): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=systemd-update-utmp-runlevel comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=SERVICE_STOP msg=audit(1719654715.704:43): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=systemd-update-utmp-runlevel comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654715.882:44): pid=925 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:a2:6b:81:8b:eb:b5:57:05:f0:50:15:5d:b0:ad:19:5f:40:cc:f8:dd:94:64:89:6a:53:b4:eb:24:f0:b0:1d:2a direction=? spid=925 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654715.882:45): pid=925 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:05:47:69:24:3b:ec:0c:78:36:c6:28:e9:a8:68:58:4b:68:df:31:dc:c3:cb:8d:d2:65:cf:d9:ff:b1:b1:c9:41 direction=? spid=925 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654715.882:46): pid=925 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=925 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654715.901:47): pid=926 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:a2:6b:81:8b:eb:b5:57:05:f0:50:15:5d:b0:ad:19:5f:40:cc:f8:dd:94:64:89:6a:53:b4:eb:24:f0:b0:1d:2a direction=? spid=926 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654715.901:48): pid=926 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:05:47:69:24:3b:ec:0c:78:36:c6:28:e9:a8:68:58:4b:68:df:31:dc:c3:cb:8d:d2:65:cf:d9:ff:b1:b1:c9:41 direction=? spid=926 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654715.901:49): pid=926 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=926 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_SESSION msg=audit(1719654715.919:50): pid=923 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=start direction=from-server cipher=aes256-ctr ksize=256 mac=hmac-sha2-512-etm@openssh.com pfs=ecdh-sha2-nistp521 spid=926 suid=74 rport=53946 laddr=10.0.2.15 lport=22  exe="/usr/sbin/sshd" hostname=? addr=10.0.2.2 terminal=? res=success'
type=CRYPTO_SESSION msg=audit(1719654715.919:51): pid=923 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=start direction=from-client cipher=aes256-ctr ksize=256 mac=hmac-sha2-512-etm@openssh.com pfs=ecdh-sha2-nistp521 spid=926 suid=74 rport=53946 laddr=10.0.2.15 lport=22  exe="/usr/sbin/sshd" hostname=? addr=10.0.2.2 terminal=? res=success'
type=USER_AUTH msg=audit(1719654716.121:52): pid=923 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=pubkey acct="vagrant" exe="/usr/sbin/sshd" hostname=? addr=10.0.2.2 terminal=ssh res=failed'
type=USER_AUTH msg=audit(1719654716.135:53): pid=923 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=pubkey_auth rport=53946 acct="vagrant" exe="/usr/sbin/sshd" hostname=? addr=10.0.2.2 terminal=? res=success'
type=USER_AUTH msg=audit(1719654716.135:54): pid=923 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=key algo=ssh-rsa size=2048 fp=SHA256:d4:ce:11:ce:13:32:5a:e1:52:ff:ce:ae:3d:8f:dc:7b:6a:6b:87:f7:55:4c:75:bb:88:3d:91:86:9a:ae:39:90 rport=53946 acct="vagrant" exe="/usr/sbin/sshd" hostname=? addr=10.0.2.2 terminal=? res=success'
type=USER_ACCT msg=audit(1719654716.200:55): pid=923 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=PAM:accounting grantors=pam_unix,pam_localuser acct="vagrant" exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654761.967:56): pid=923 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=session fp=? direction=both spid=926 suid=74 rport=53946 laddr=10.0.2.15 lport=22  exe="/usr/sbin/sshd" hostname=? addr=10.0.2.2 terminal=? res=success'
type=USER_AUTH msg=audit(1719654761.967:57): pid=923 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=success acct="vagrant" exe="/usr/sbin/sshd" hostname=? addr=10.0.2.2 terminal=ssh res=success'
type=CRED_ACQ msg=audit(1719654762.013:58): pid=923 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="vagrant" exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=LOGIN msg=audit(1719654762.013:59): pid=923 uid=0 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 old-auid=4294967295 auid=1000 tty=(none) old-ses=4294967295 ses=1 res=1
type=USER_ROLE_CHANGE msg=audit(1719654762.359:60): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='pam: default-context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 selected-context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654762.536:61): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=PAM:session_open grantors=pam_selinux,pam_loginuid,pam_selinux,pam_namespace,pam_keyinit,pam_keyinit,pam_limits,pam_systemd,pam_unix,pam_lastlog acct="vagrant" exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654762.548:62): pid=928 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:a2:6b:81:8b:eb:b5:57:05:f0:50:15:5d:b0:ad:19:5f:40:cc:f8:dd:94:64:89:6a:53:b4:eb:24:f0:b0:1d:2a direction=? spid=928 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654762.548:63): pid=928 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:05:47:69:24:3b:ec:0c:78:36:c6:28:e9:a8:68:58:4b:68:df:31:dc:c3:cb:8d:d2:65:cf:d9:ff:b1:b1:c9:41 direction=? spid=928 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654762.548:64): pid=928 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=928 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRED_ACQ msg=audit(1719654762.548:65): pid=928 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="vagrant" exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654762.563:66): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654762.563:67): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654762.600:68): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=929 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654762.719:69): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654762.719:70): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654762.766:71): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654762.766:72): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654762.781:73): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=938 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654762.831:74): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654762.831:75): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654762.878:76): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654762.878:77): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654762.892:78): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=947 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654763.038:79): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654763.038:80): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654763.504:81): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654763.504:82): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654763.513:83): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=967 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654763.542:84): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654763.542:85): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654763.588:86): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654763.588:87): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654763.599:88): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=976 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654763.637:89): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654763.637:90): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654763.680:91): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654763.680:92): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654763.691:93): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=985 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654763.784:94): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654763.784:95): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654763.812:96): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654763.812:97): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654763.825:98): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1005 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654763.862:99): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654763.862:100): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654763.909:101): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654763.909:102): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654763.919:103): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1014 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654764.021:104): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654764.022:105): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654764.026:106): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654764.026:107): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654764.035:108): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1036 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654764.062:109): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654764.062:110): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654764.105:111): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654764.105:112): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654764.116:113): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1045 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654764.225:114): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654764.226:115): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654764.229:116): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654764.229:117): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654764.243:118): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1067 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654764.298:119): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654764.298:120): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654764.341:121): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654764.341:122): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654764.358:123): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1076 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654764.504:124): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654764.505:125): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654764.505:126): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654764.505:127): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654764.520:128): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1097 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654764.598:129): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654764.598:130): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654764.642:131): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654764.642:132): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654764.657:133): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1106 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654764.773:134): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654764.773:135): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654764.775:136): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654764.775:137): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654764.775:138): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1126 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654764.844:139): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654764.844:140): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654764.891:141): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654764.891:142): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654764.905:143): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1135 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654765.057:144): pid=1157 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:a2:6b:81:8b:eb:b5:57:05:f0:50:15:5d:b0:ad:19:5f:40:cc:f8:dd:94:64:89:6a:53:b4:eb:24:f0:b0:1d:2a direction=? spid=1157 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654765.057:145): pid=1157 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:05:47:69:24:3b:ec:0c:78:36:c6:28:e9:a8:68:58:4b:68:df:31:dc:c3:cb:8d:d2:65:cf:d9:ff:b1:b1:c9:41 direction=? spid=1157 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654765.057:146): pid=1157 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1157 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654765.064:147): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654765.064:148): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654765.065:149): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654765.065:150): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654765.075:151): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1158 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654765.122:152): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654765.122:153): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654765.166:154): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654765.166:155): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654765.179:156): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1167 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654765.295:157): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654765.295:158): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654765.295:159): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654765.295:160): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654765.310:161): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1188 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654765.347:162): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654765.347:163): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654765.394:164): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654765.394:165): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654765.410:166): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1197 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654765.548:167): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654765.548:168): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654765.556:169): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654765.556:170): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654765.573:171): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1218 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654765.619:172): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654765.619:173): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654765.666:174): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654765.666:175): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654765.675:176): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1227 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654765.820:177): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654765.820:178): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654765.820:179): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654765.820:180): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654765.835:181): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1249 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654765.883:182): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654765.883:183): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654765.927:184): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654765.927:185): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654765.941:186): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1258 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654766.071:187): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654766.071:188): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654766.074:189): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654766.074:190): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654766.083:191): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1280 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654766.117:192): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654766.117:193): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654766.162:194): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654766.162:195): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654766.174:196): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1289 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654766.278:197): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654766.278:198): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654766.281:199): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654766.281:200): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654766.293:201): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1311 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654766.333:202): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654766.333:203): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654766.378:204): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654766.378:205): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654766.391:206): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1320 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654766.492:207): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654766.493:208): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654766.493:209): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654766.493:210): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654766.504:211): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1342 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654766.538:212): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654766.538:213): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654766.586:214): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654766.586:215): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654766.599:216): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1351 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654766.693:217): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654766.693:218): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654766.693:219): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654766.693:220): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654766.704:221): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1372 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654766.738:222): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654766.738:223): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654766.786:224): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654766.786:225): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654766.802:226): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1381 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654766.927:227): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654766.927:228): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654766.934:229): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654766.934:230): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654766.942:231): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1401 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654766.972:232): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654766.972:233): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654767.018:234): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654767.018:235): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654767.018:236): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1410 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654767.073:237): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654767.073:238): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654767.119:239): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654767.119:240): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654767.130:241): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1419 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654767.221:242): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654767.221:243): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654767.221:244): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654767.221:245): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654767.234:246): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1439 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654767.269:247): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654767.269:248): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654767.314:249): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654767.314:250): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654767.323:251): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1448 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_ACCT msg=audit(1719654767.393:252): pid=1448 uid=1000 auid=1000 ses=1 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:accounting grantors=pam_unix,pam_localuser acct="vagrant" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_CMD msg=audit(1719654767.393:253): pid=1448 uid=1000 auid=1000 ses=1 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='cwd="/home/vagrant" cmd=62617368202D6C terminal=? res=success'
type=CRED_REFR msg=audit(1719654767.393:254): pid=1448 uid=0 auid=1000 ses=1 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_START msg=audit(1719654767.439:255): pid=1448 uid=0 auid=1000 ses=1 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:session_open grantors=pam_keyinit,pam_keyinit,pam_limits,pam_systemd,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654767.582:256): pid=1448 uid=0 auid=1000 ses=1 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:session_close grantors=pam_keyinit,pam_keyinit,pam_limits,pam_systemd,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=CRED_DISP msg=audit(1719654767.582:257): pid=1448 uid=0 auid=1000 ses=1 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654767.596:258): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654767.596:259): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654767.596:260): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654767.596:261): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654767.611:262): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1468 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654767.655:263): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654767.655:264): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=SERVICE_STOP msg=audit(1719654767.671:265): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=NetworkManager-dispatcher comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=USER_LOGIN msg=audit(1719654767.696:266): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654767.696:267): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654767.705:268): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1477 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654767.759:269): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654767.759:270): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654767.806:271): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654767.806:272): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654767.821:273): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1486 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654768.263:274): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654768.263:275): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654768.265:276): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654768.265:277): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654768.279:278): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1507 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654768.279:279): pid=1511 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:a2:6b:81:8b:eb:b5:57:05:f0:50:15:5d:b0:ad:19:5f:40:cc:f8:dd:94:64:89:6a:53:b4:eb:24:f0:b0:1d:2a direction=? spid=1511 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654768.279:280): pid=1511 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:05:47:69:24:3b:ec:0c:78:36:c6:28:e9:a8:68:58:4b:68:df:31:dc:c3:cb:8d:d2:65:cf:d9:ff:b1:b1:c9:41 direction=? spid=1511 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654768.279:281): pid=1511 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1511 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654768.321:282): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654768.321:283): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654768.366:284): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654768.366:285): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654768.377:286): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1517 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654768.410:287): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654768.410:288): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654768.468:289): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654768.468:290): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654768.479:291): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1526 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654768.636:292): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654768.636:293): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654768.639:294): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654768.639:295): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654768.654:296): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1547 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654768.761:297): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654768.761:298): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654768.806:299): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654768.806:300): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654768.817:301): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1556 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654768.855:302): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654768.855:303): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654768.902:304): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654768.902:305): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654768.912:306): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1565 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654769.015:307): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654769.015:308): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654769.022:309): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654769.022:310): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654769.032:311): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1590 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654769.067:312): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654769.067:313): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654769.114:314): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654769.114:315): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654769.124:316): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1599 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654769.158:317): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654769.158:318): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654769.206:319): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654769.206:320): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654769.206:321): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1608 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654769.314:322): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654769.314:323): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654769.320:324): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654769.320:325): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654769.333:326): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1628 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654769.387:327): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654769.387:328): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654769.434:329): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654769.434:330): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654769.448:331): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1637 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654769.494:332): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654769.494:333): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654769.542:334): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654769.542:335): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654769.557:336): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1646 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654769.662:337): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654769.662:338): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654769.662:339): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654769.662:340): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654769.675:341): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1667 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654769.776:342): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654769.776:343): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654769.823:344): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654769.823:345): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654769.836:346): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1676 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654769.881:347): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654769.881:348): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654769.926:349): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654769.926:350): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654769.940:351): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1685 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654770.095:352): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654770.095:353): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654770.102:354): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=session fp=? direction=both spid=928 suid=1000 rport=53946 laddr=10.0.2.15 lport=22  exe="/usr/sbin/sshd" hostname=? addr=10.0.2.2 terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654770.104:355): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=928 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654770.104:356): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=PAM:session_close grantors=pam_selinux,pam_loginuid,pam_selinux,pam_namespace,pam_keyinit,pam_keyinit,pam_limits,pam_systemd,pam_unix,pam_lastlog acct="vagrant" exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRED_DISP msg=audit(1719654770.104:357): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="vagrant" exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654770.104:358): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:a2:6b:81:8b:eb:b5:57:05:f0:50:15:5d:b0:ad:19:5f:40:cc:f8:dd:94:64:89:6a:53:b4:eb:24:f0:b0:1d:2a direction=? spid=923 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654770.104:359): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:05:47:69:24:3b:ec:0c:78:36:c6:28:e9:a8:68:58:4b:68:df:31:dc:c3:cb:8d:d2:65:cf:d9:ff:b1:b1:c9:41 direction=? spid=923 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654770.104:360): pid=923 uid=0 auid=1000 ses=1 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=923 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654770.554:361): pid=1712 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:a2:6b:81:8b:eb:b5:57:05:f0:50:15:5d:b0:ad:19:5f:40:cc:f8:dd:94:64:89:6a:53:b4:eb:24:f0:b0:1d:2a direction=? spid=1712 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654770.554:362): pid=1712 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:05:47:69:24:3b:ec:0c:78:36:c6:28:e9:a8:68:58:4b:68:df:31:dc:c3:cb:8d:d2:65:cf:d9:ff:b1:b1:c9:41 direction=? spid=1712 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654770.554:363): pid=1712 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1712 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_SESSION msg=audit(1719654770.561:364): pid=1711 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=start direction=from-server cipher=aes256-ctr ksize=256 mac=hmac-sha2-512-etm@openssh.com pfs=ecdh-sha2-nistp521 spid=1712 suid=74 rport=56616 laddr=10.0.2.15 lport=22  exe="/usr/sbin/sshd" hostname=? addr=10.0.2.2 terminal=? res=success'
type=CRYPTO_SESSION msg=audit(1719654770.561:365): pid=1711 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=start direction=from-client cipher=aes256-ctr ksize=256 mac=hmac-sha2-512-etm@openssh.com pfs=ecdh-sha2-nistp521 spid=1712 suid=74 rport=56616 laddr=10.0.2.15 lport=22  exe="/usr/sbin/sshd" hostname=? addr=10.0.2.2 terminal=? res=success'
type=USER_AUTH msg=audit(1719654770.675:366): pid=1711 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=pubkey_auth rport=56616 acct="vagrant" exe="/usr/sbin/sshd" hostname=? addr=10.0.2.2 terminal=? res=success'
type=USER_AUTH msg=audit(1719654770.675:367): pid=1711 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=key algo=ssh-ed25519 size=256 fp=SHA256:0a:65:cf:23:2f:77:98:a7:19:11:27:ee:38:86:25:1f:6f:46:72:03:5f:f2:60:cc:19:dc:61:99:cf:72:0c:cb rport=56616 acct="vagrant" exe="/usr/sbin/sshd" hostname=? addr=10.0.2.2 terminal=? res=success'
type=USER_ACCT msg=audit(1719654770.675:368): pid=1711 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=PAM:accounting grantors=pam_unix,pam_localuser acct="vagrant" exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654770.714:369): pid=1711 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=session fp=? direction=both spid=1712 suid=74 rport=56616 laddr=10.0.2.15 lport=22  exe="/usr/sbin/sshd" hostname=? addr=10.0.2.2 terminal=? res=success'
type=USER_AUTH msg=audit(1719654770.714:370): pid=1711 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=success acct="vagrant" exe="/usr/sbin/sshd" hostname=? addr=10.0.2.2 terminal=ssh res=success'
type=CRED_ACQ msg=audit(1719654770.714:371): pid=1711 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="vagrant" exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=LOGIN msg=audit(1719654770.714:372): pid=1711 uid=0 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 old-auid=4294967295 auid=1000 tty=(none) old-ses=4294967295 ses=2 res=1
type=USER_ROLE_CHANGE msg=audit(1719654770.995:373): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='pam: default-context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 selected-context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654771.123:374): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=PAM:session_open grantors=pam_selinux,pam_loginuid,pam_selinux,pam_namespace,pam_keyinit,pam_keyinit,pam_limits,pam_systemd,pam_unix,pam_lastlog acct="vagrant" exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654771.123:375): pid=1714 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:a2:6b:81:8b:eb:b5:57:05:f0:50:15:5d:b0:ad:19:5f:40:cc:f8:dd:94:64:89:6a:53:b4:eb:24:f0:b0:1d:2a direction=? spid=1714 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654771.123:376): pid=1714 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:05:47:69:24:3b:ec:0c:78:36:c6:28:e9:a8:68:58:4b:68:df:31:dc:c3:cb:8d:d2:65:cf:d9:ff:b1:b1:c9:41 direction=? spid=1714 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654771.123:377): pid=1714 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1714 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRED_ACQ msg=audit(1719654771.123:378): pid=1714 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="vagrant" exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654771.141:379): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654771.141:380): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654771.158:381): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1715 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654771.196:382): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654771.196:383): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654771.241:384): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654771.241:385): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654771.252:386): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1724 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654771.345:387): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654771.345:388): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654772.186:389): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654772.186:390): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654772.196:391): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1744 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654772.228:392): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654772.228:393): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654772.274:394): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654772.276:395): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654772.294:396): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1753 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654772.358:397): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654772.358:398): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654772.401:399): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654772.401:400): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654772.413:401): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1762 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654772.504:402): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654772.504:403): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654772.514:404): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654772.514:405): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654772.524:406): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1782 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654772.559:407): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654772.559:408): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654772.605:409): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654772.605:410): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654772.617:411): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1791 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654772.722:412): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654772.722:413): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654772.722:414): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654772.722:415): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654772.734:416): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1813 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654772.780:417): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654772.780:418): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654772.827:419): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654772.827:420): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654772.839:421): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1822 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_ACCT msg=audit(1719654772.930:422): pid=1822 uid=1000 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:accounting grantors=pam_unix,pam_localuser acct="vagrant" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_CMD msg=audit(1719654772.930:423): pid=1822 uid=1000 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='cwd="/home/vagrant" cmd=62617368202D6C terminal=? res=success'
type=CRED_REFR msg=audit(1719654772.930:424): pid=1822 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_START msg=audit(1719654772.930:425): pid=1822 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:session_open grantors=pam_keyinit,pam_keyinit,pam_limits,pam_systemd,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654773.027:426): pid=1822 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:session_close grantors=pam_keyinit,pam_keyinit,pam_limits,pam_systemd,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=CRED_DISP msg=audit(1719654773.030:427): pid=1822 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654773.038:428): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654773.038:429): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654773.038:430): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654773.038:431): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654773.047:432): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1844 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654773.075:433): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654773.075:434): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654773.123:435): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654773.123:436): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654773.137:437): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1853 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654773.259:438): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654773.259:439): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654773.259:440): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654773.259:441): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654773.277:442): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1874 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654773.324:443): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654773.324:444): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654773.370:445): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654773.370:446): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654773.383:447): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1883 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_ACCT msg=audit(1719654773.483:448): pid=1883 uid=1000 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:accounting grantors=pam_unix,pam_localuser acct="vagrant" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_CMD msg=audit(1719654773.483:449): pid=1883 uid=1000 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='cwd="/home/vagrant" cmd=62617368202D6C terminal=? res=success'
type=CRED_REFR msg=audit(1719654773.483:450): pid=1883 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_START msg=audit(1719654773.483:451): pid=1883 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:session_open grantors=pam_keyinit,pam_keyinit,pam_limits,pam_systemd,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654773.662:452): pid=1883 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:session_close grantors=pam_keyinit,pam_keyinit,pam_limits,pam_systemd,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=CRED_DISP msg=audit(1719654773.662:453): pid=1883 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654773.687:454): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654773.687:455): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654773.696:456): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654773.696:457): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654773.714:458): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1904 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=SERVICE_START msg=audit(1719654773.762:459): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=NetworkManager-dispatcher comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654773.871:460): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654773.871:461): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654773.918:462): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654773.918:463): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654773.928:464): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1931 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_ACCT msg=audit(1719654773.963:465): pid=1931 uid=1000 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:accounting grantors=pam_unix,pam_localuser acct="vagrant" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_CMD msg=audit(1719654773.963:466): pid=1931 uid=1000 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='cwd="/home/vagrant" cmd=62617368202D6C terminal=? res=success'
type=CRED_REFR msg=audit(1719654773.963:467): pid=1931 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_START msg=audit(1719654773.963:468): pid=1931 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:session_open grantors=pam_keyinit,pam_keyinit,pam_limits,pam_systemd,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654774.119:469): pid=1931 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:session_close grantors=pam_keyinit,pam_keyinit,pam_limits,pam_systemd,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=CRED_DISP msg=audit(1719654774.119:470): pid=1931 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654774.125:471): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654774.125:472): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654774.129:473): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654774.129:474): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654774.138:475): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1959 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654774.168:476): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654774.168:477): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654774.214:478): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654774.214:479): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654774.222:480): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1968 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_ACCT msg=audit(1719654774.278:481): pid=1968 uid=1000 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:accounting grantors=pam_unix,pam_localuser acct="vagrant" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_CMD msg=audit(1719654774.278:482): pid=1968 uid=1000 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='cwd="/home/vagrant" cmd=62617368202D6C terminal=? res=success'
type=CRED_REFR msg=audit(1719654774.278:483): pid=1968 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_START msg=audit(1719654774.278:484): pid=1968 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:session_open grantors=pam_keyinit,pam_keyinit,pam_limits,pam_systemd,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654774.335:485): pid=1968 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:session_close grantors=pam_keyinit,pam_keyinit,pam_limits,pam_systemd,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=CRED_DISP msg=audit(1719654774.335:486): pid=1968 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654774.356:487): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654774.356:488): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654774.356:489): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654774.356:490): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654774.365:491): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1987 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654774.400:492): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654774.400:493): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654774.446:494): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654774.446:495): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654774.458:496): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1996 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_ACCT msg=audit(1719654774.460:497): pid=1996 uid=1000 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:accounting grantors=pam_unix,pam_localuser acct="vagrant" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_CMD msg=audit(1719654774.460:498): pid=1996 uid=1000 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='cwd="/home/vagrant" cmd=62617368202D6C terminal=? res=success'
type=CRED_REFR msg=audit(1719654774.460:499): pid=1996 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_START msg=audit(1719654774.548:500): pid=1996 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:session_open grantors=pam_keyinit,pam_keyinit,pam_limits,pam_systemd,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654774.624:501): pid=1996 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:session_close grantors=pam_keyinit,pam_keyinit,pam_limits,pam_systemd,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=CRED_DISP msg=audit(1719654774.624:502): pid=1996 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654774.647:503): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654774.647:504): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654774.653:505): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654774.653:506): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654774.661:507): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2015 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654774.690:508): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654774.690:509): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654774.734:510): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654774.734:511): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654774.742:512): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2024 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_ACCT msg=audit(1719654774.795:513): pid=2024 uid=1000 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:accounting grantors=pam_unix,pam_localuser acct="vagrant" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_CMD msg=audit(1719654774.795:514): pid=2024 uid=1000 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='cwd="/home/vagrant" cmd=62617368202D6C terminal=? res=success'
type=CRED_REFR msg=audit(1719654774.795:515): pid=2024 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_START msg=audit(1719654774.795:516): pid=2024 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:session_open grantors=pam_keyinit,pam_keyinit,pam_limits,pam_systemd,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=SERVICE_STOP msg=audit(1719654774.838:517): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=NetworkManager-wait-online comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=SERVICE_STOP msg=audit(1719654774.884:518): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=NetworkManager comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=SERVICE_START msg=audit(1719654774.938:519): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=NetworkManager comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654774.938:520): pid=2024 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:session_close grantors=pam_keyinit,pam_keyinit,pam_limits,pam_systemd,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=CRED_DISP msg=audit(1719654774.938:521): pid=2024 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654774.968:522): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654774.968:523): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654774.970:524): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654774.970:525): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654775.061:526): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2049 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654775.471:527): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654775.471:528): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654775.471:529): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654775.471:530): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654775.489:531): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2070 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=SERVICE_START msg=audit(1719654775.720:532): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=NetworkManager-wait-online comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=USER_ACCT msg=audit(1719654775.720:533): pid=2070 uid=1000 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:accounting grantors=pam_unix,pam_localuser acct="vagrant" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_CMD msg=audit(1719654775.720:534): pid=2070 uid=1000 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='cwd="/home/vagrant" cmd=62617368202D6C terminal=? res=success'
type=CRED_REFR msg=audit(1719654775.720:535): pid=2070 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_START msg=audit(1719654775.781:536): pid=2070 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:session_open grantors=pam_keyinit,pam_keyinit,pam_limits,pam_systemd,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654775.864:537): pid=2070 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:session_close grantors=pam_keyinit,pam_keyinit,pam_limits,pam_systemd,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=CRED_DISP msg=audit(1719654775.864:538): pid=2070 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654775.896:539): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654775.896:540): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654776.148:541): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654776.148:542): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654776.160:543): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2143 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654776.186:544): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654776.186:545): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654776.229:546): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654776.229:547): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654776.241:548): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2152 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654776.274:549): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654776.274:550): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654776.317:551): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654776.317:552): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654776.328:553): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2161 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654776.423:554): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654776.423:555): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654776.431:556): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654776.431:557): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654776.443:558): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2181 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654776.479:559): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654776.479:560): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654776.529:561): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654776.529:562): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654776.542:563): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2190 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654776.582:564): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654776.582:565): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654776.626:566): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654776.626:567): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654776.626:568): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2199 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654776.721:569): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654776.721:570): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654776.725:571): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654776.725:572): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654776.735:573): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2219 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654776.773:574): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654776.773:575): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654776.818:576): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654776.818:577): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654776.832:578): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2228 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654776.938:579): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654776.938:580): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654777.386:581): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654777.386:582): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654777.395:583): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2249 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654777.422:584): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654777.422:585): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654777.469:586): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654777.469:587): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654777.480:588): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2258 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654777.516:589): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654777.516:590): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654777.561:591): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654777.561:592): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654777.570:593): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2267 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654777.657:594): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654777.657:595): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654777.660:596): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654777.660:597): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654777.669:598): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2287 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654777.697:599): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654777.697:600): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654777.741:601): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654777.743:602): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654777.752:603): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2296 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654777.792:604): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654777.792:605): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654777.838:606): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654777.838:607): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654777.849:608): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2305 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654777.937:609): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654777.937:610): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654777.942:611): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654777.942:612): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654777.953:613): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2325 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654777.988:614): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654777.988:615): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654778.039:616): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654778.039:617): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654778.050:618): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2334 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654778.084:619): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654778.084:620): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654778.129:621): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654778.129:622): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654778.140:623): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2343 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654778.230:624): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654778.230:625): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654778.233:626): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654778.233:627): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654778.243:628): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2363 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654778.279:629): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654778.279:630): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654778.326:631): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654778.326:632): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654778.337:633): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2372 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654778.376:634): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654778.376:635): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654778.422:636): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654778.422:637): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654778.433:638): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2381 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654778.531:639): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654778.531:640): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654778.535:641): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654778.535:642): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654778.550:643): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2401 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654778.591:644): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654778.591:645): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654778.638:646): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654778.638:647): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654778.649:648): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2410 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654778.692:649): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654778.692:650): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654778.739:651): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654778.739:652): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654778.752:653): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2419 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654778.852:654): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654778.853:655): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654778.856:656): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654778.856:657): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654778.865:658): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2439 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654778.896:659): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654778.896:660): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654778.942:661): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654778.942:662): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654778.952:663): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2448 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_ACCT msg=audit(1719654778.954:664): pid=2448 uid=1000 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:accounting grantors=pam_unix,pam_localuser acct="vagrant" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_CMD msg=audit(1719654778.954:665): pid=2448 uid=1000 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='cwd="/home/vagrant" cmd=62617368202D6C terminal=? res=success'
type=CRED_REFR msg=audit(1719654778.954:666): pid=2448 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_START msg=audit(1719654778.954:667): pid=2448 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:session_open grantors=pam_keyinit,pam_keyinit,pam_limits,pam_systemd,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654779.083:668): pid=2448 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:session_close grantors=pam_keyinit,pam_keyinit,pam_limits,pam_systemd,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=CRED_DISP msg=audit(1719654779.083:669): pid=2448 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654779.096:670): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654779.096:671): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654779.170:672): pid=2468 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:a2:6b:81:8b:eb:b5:57:05:f0:50:15:5d:b0:ad:19:5f:40:cc:f8:dd:94:64:89:6a:53:b4:eb:24:f0:b0:1d:2a direction=? spid=2468 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654779.170:673): pid=2468 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:05:47:69:24:3b:ec:0c:78:36:c6:28:e9:a8:68:58:4b:68:df:31:dc:c3:cb:8d:d2:65:cf:d9:ff:b1:b1:c9:41 direction=? spid=2468 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654779.170:674): pid=2468 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2468 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_SESSION msg=audit(1719654779.180:675): pid=2467 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=start direction=from-server cipher=chacha20-poly1305@openssh.com ksize=512 mac=<implicit> pfs=curve25519-sha256 spid=2468 suid=74 rport=47412 laddr=10.0.2.15 lport=22  exe="/usr/sbin/sshd" hostname=? addr=10.0.2.2 terminal=? res=success'
type=CRYPTO_SESSION msg=audit(1719654779.180:676): pid=2467 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=start direction=from-client cipher=chacha20-poly1305@openssh.com ksize=512 mac=<implicit> pfs=curve25519-sha256 spid=2468 suid=74 rport=47412 laddr=10.0.2.15 lport=22  exe="/usr/sbin/sshd" hostname=? addr=10.0.2.2 terminal=? res=success'
type=USER_AUTH msg=audit(1719654779.326:677): pid=2467 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=pubkey_auth rport=47412 acct="vagrant" exe="/usr/sbin/sshd" hostname=? addr=10.0.2.2 terminal=? res=success'
type=USER_AUTH msg=audit(1719654779.326:678): pid=2467 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=key algo=ssh-ed25519 size=256 fp=SHA256:0a:65:cf:23:2f:77:98:a7:19:11:27:ee:38:86:25:1f:6f:46:72:03:5f:f2:60:cc:19:dc:61:99:cf:72:0c:cb rport=47412 acct="vagrant" exe="/usr/sbin/sshd" hostname=? addr=10.0.2.2 terminal=? res=success'
type=USER_ACCT msg=audit(1719654779.326:679): pid=2467 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=PAM:accounting grantors=pam_unix,pam_localuser acct="vagrant" exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654779.368:680): pid=2467 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=session fp=? direction=both spid=2468 suid=74 rport=47412 laddr=10.0.2.15 lport=22  exe="/usr/sbin/sshd" hostname=? addr=10.0.2.2 terminal=? res=success'
type=USER_AUTH msg=audit(1719654779.368:681): pid=2467 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=success acct="vagrant" exe="/usr/sbin/sshd" hostname=? addr=10.0.2.2 terminal=ssh res=success'
type=CRED_ACQ msg=audit(1719654779.368:682): pid=2467 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="vagrant" exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=LOGIN msg=audit(1719654779.368:683): pid=2467 uid=0 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 old-auid=4294967295 auid=1000 tty=(none) old-ses=4294967295 ses=3 res=1
type=USER_ROLE_CHANGE msg=audit(1719654779.548:684): pid=2467 uid=0 auid=1000 ses=3 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='pam: default-context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 selected-context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654779.548:685): pid=2467 uid=0 auid=1000 ses=3 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=PAM:session_open grantors=pam_selinux,pam_loginuid,pam_selinux,pam_namespace,pam_keyinit,pam_keyinit,pam_limits,pam_systemd,pam_unix,pam_lastlog acct="vagrant" exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654779.787:686): pid=2470 uid=0 auid=1000 ses=3 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:a2:6b:81:8b:eb:b5:57:05:f0:50:15:5d:b0:ad:19:5f:40:cc:f8:dd:94:64:89:6a:53:b4:eb:24:f0:b0:1d:2a direction=? spid=2470 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654779.787:687): pid=2470 uid=0 auid=1000 ses=3 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:05:47:69:24:3b:ec:0c:78:36:c6:28:e9:a8:68:58:4b:68:df:31:dc:c3:cb:8d:d2:65:cf:d9:ff:b1:b1:c9:41 direction=? spid=2470 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654779.787:688): pid=2470 uid=0 auid=1000 ses=3 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2470 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRED_ACQ msg=audit(1719654779.787:689): pid=2470 uid=0 auid=1000 ses=3 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="vagrant" exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654779.799:690): pid=2467 uid=0 auid=1000 ses=3 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654779.799:691): pid=2467 uid=0 auid=1000 ses=3 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654779.799:692): pid=2467 uid=0 auid=1000 ses=3 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2471 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_ACCT msg=audit(1719654779.911:693): pid=2471 uid=1000 auid=1000 ses=3 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:accounting grantors=pam_unix,pam_localuser acct="vagrant" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_CMD msg=audit(1719654779.911:694): pid=2471 uid=1000 auid=1000 ses=3 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='cwd="/home/vagrant" cmd=7273796E63202D2D736572766572202D766C447470727A652E694C73667843497675202D2D64656C657465202E202F76616772616E74 terminal=? res=success'
type=CRED_REFR msg=audit(1719654779.911:695): pid=2471 uid=0 auid=1000 ses=3 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_START msg=audit(1719654779.911:696): pid=2471 uid=0 auid=1000 ses=3 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:session_open grantors=pam_keyinit,pam_keyinit,pam_limits,pam_systemd,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654779.987:697): pid=2471 uid=0 auid=1000 ses=3 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:session_close grantors=pam_keyinit,pam_keyinit,pam_limits,pam_systemd,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=CRED_DISP msg=audit(1719654779.987:698): pid=2471 uid=0 auid=1000 ses=3 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654779.997:699): pid=2467 uid=0 auid=1000 ses=3 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2470 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654779.997:700): pid=2467 uid=0 auid=1000 ses=3 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=session fp=? direction=both spid=2470 suid=1000 rport=47412 laddr=10.0.2.15 lport=22  exe="/usr/sbin/sshd" hostname=? addr=10.0.2.2 terminal=? res=success'
type=USER_LOGIN msg=audit(1719654780.018:701): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654780.018:702): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_END msg=audit(1719654780.018:703): pid=2467 uid=0 auid=1000 ses=3 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=PAM:session_close grantors=pam_selinux,pam_loginuid,pam_selinux,pam_namespace,pam_keyinit,pam_keyinit,pam_limits,pam_systemd,pam_unix,pam_lastlog acct="vagrant" exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRED_DISP msg=audit(1719654780.018:704): pid=2467 uid=0 auid=1000 ses=3 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="vagrant" exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_END msg=audit(1719654780.018:705): pid=2467 uid=0 auid=1000 ses=3 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654780.018:706): pid=2467 uid=0 auid=1000 ses=3 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654780.018:707): pid=2467 uid=0 auid=1000 ses=3 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:a2:6b:81:8b:eb:b5:57:05:f0:50:15:5d:b0:ad:19:5f:40:cc:f8:dd:94:64:89:6a:53:b4:eb:24:f0:b0:1d:2a direction=? spid=2467 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654780.018:708): pid=2467 uid=0 auid=1000 ses=3 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:05:47:69:24:3b:ec:0c:78:36:c6:28:e9:a8:68:58:4b:68:df:31:dc:c3:cb:8d:d2:65:cf:d9:ff:b1:b1:c9:41 direction=? spid=2467 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654780.018:709): pid=2467 uid=0 auid=1000 ses=3 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2467 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654780.076:710): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2481 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654780.147:711): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654780.147:712): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654780.150:713): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654780.150:714): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654780.161:715): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2491 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654780.196:716): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654780.196:717): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654780.242:718): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654780.242:719): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654780.255:720): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2500 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654780.350:721): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654780.350:722): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654780.352:723): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654780.352:724): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654780.363:725): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2520 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654780.402:726): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654780.402:727): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654780.446:728): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654780.446:729): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654780.458:730): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2529 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654780.497:731): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654780.497:732): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654780.545:733): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654780.545:734): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654780.556:735): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2538 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654780.645:736): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654780.647:737): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654780.650:738): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654780.650:739): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654780.660:740): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2558 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654780.712:741): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654780.712:742): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654780.759:743): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654780.759:744): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654780.774:745): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2567 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_ACCT msg=audit(1719654780.843:746): pid=2567 uid=1000 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:accounting grantors=pam_unix,pam_localuser acct="vagrant" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_CMD msg=audit(1719654780.843:747): pid=2567 uid=1000 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='cwd="/home/vagrant" cmd=62617368202D6C terminal=? res=success'
type=CRED_REFR msg=audit(1719654780.843:748): pid=2567 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_START msg=audit(1719654780.843:749): pid=2567 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:session_open grantors=pam_keyinit,pam_keyinit,pam_limits,pam_systemd,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654780.978:750): pid=2567 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:session_close grantors=pam_keyinit,pam_keyinit,pam_limits,pam_systemd,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=CRED_DISP msg=audit(1719654780.978:751): pid=2567 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654780.991:752): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654780.991:753): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654780.999:754): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654780.999:755): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654781.011:756): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2587 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654781.056:757): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654781.056:758): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654781.102:759): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654781.102:760): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654781.120:761): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2596 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654781.172:762): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654781.172:763): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654781.219:764): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654781.219:765): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654781.231:766): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2605 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654781.306:767): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654781.306:768): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654781.323:769): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654781.323:770): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654781.334:771): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2625 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654781.376:772): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654781.376:773): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654781.424:774): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654781.424:775): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654781.435:776): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2634 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654781.472:777): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654781.472:778): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654781.518:779): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654781.518:780): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654781.531:781): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2643 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654781.623:782): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654781.623:783): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654782.087:784): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654782.087:785): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654782.095:786): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2663 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654782.130:787): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654782.130:788): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654782.178:789): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654782.178:790): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654782.178:791): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2672 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654782.281:792): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654782.281:793): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654782.284:794): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654782.284:795): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654782.297:796): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2692 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654782.342:797): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654782.342:798): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654782.386:799): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654782.386:800): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654782.398:801): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2701 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_ACCT msg=audit(1719654782.399:802): pid=2701 uid=1000 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:accounting grantors=pam_unix,pam_localuser acct="vagrant" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_CMD msg=audit(1719654782.399:803): pid=2701 uid=1000 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='cwd="/home/vagrant" cmd=62617368202D6C terminal=? res=success'
type=CRED_REFR msg=audit(1719654782.399:804): pid=2701 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_START msg=audit(1719654782.496:805): pid=2701 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:session_open grantors=pam_keyinit,pam_keyinit,pam_limits,pam_systemd,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654782.548:806): pid=2701 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:session_close grantors=pam_keyinit,pam_keyinit,pam_limits,pam_systemd,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=CRED_DISP msg=audit(1719654782.548:807): pid=2701 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654782.567:808): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654782.567:809): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654782.568:810): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654782.568:811): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654782.579:812): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2720 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654782.614:813): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654782.614:814): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654782.662:815): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654782.662:816): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654782.677:817): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2729 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_ACCT msg=audit(1719654782.681:818): pid=2729 uid=1000 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:accounting grantors=pam_unix,pam_localuser acct="vagrant" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_CMD msg=audit(1719654782.681:819): pid=2729 uid=1000 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='cwd="/home/vagrant" cmd=62617368202D6C terminal=? res=success'
type=CRED_REFR msg=audit(1719654782.681:820): pid=2729 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_START msg=audit(1719654782.681:821): pid=2729 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:session_open grantors=pam_keyinit,pam_keyinit,pam_limits,pam_systemd,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654782.815:822): pid=2729 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:session_close grantors=pam_keyinit,pam_keyinit,pam_limits,pam_systemd,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=CRED_DISP msg=audit(1719654782.815:823): pid=2729 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654782.827:824): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654782.827:825): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654783.286:826): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654783.286:827): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654783.322:828): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2747 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654783.394:829): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654783.394:830): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654783.437:831): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654783.437:832): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654783.455:833): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2756 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654783.509:834): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654783.509:835): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654783.555:836): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654783.555:837): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654783.577:838): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2765 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654783.741:839): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654783.741:840): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654783.741:841): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654783.741:842): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654783.753:843): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2786 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654783.858:844): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654783.858:845): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654783.906:846): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654783.906:847): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654783.917:848): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2795 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654783.953:849): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654783.953:850): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654783.999:851): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654783.999:852): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654784.016:853): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2804 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_ACCT msg=audit(1719654784.027:854): pid=2804 uid=1000 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:accounting grantors=pam_unix,pam_localuser acct="vagrant" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_CMD msg=audit(1719654784.027:855): pid=2804 uid=1000 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='cwd="/home/vagrant" cmd=62617368202D6C terminal=? res=success'
type=CRED_REFR msg=audit(1719654784.027:856): pid=2804 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_START msg=audit(1719654784.027:857): pid=2804 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:session_open grantors=pam_keyinit,pam_keyinit,pam_limits,pam_systemd,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654784.214:858): pid=2804 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:session_close grantors=pam_keyinit,pam_keyinit,pam_limits,pam_systemd,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=CRED_DISP msg=audit(1719654784.214:859): pid=2804 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654784.227:860): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654784.228:861): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654784.230:862): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654784.230:863): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654784.239:864): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2823 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654784.267:865): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654784.267:866): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719654784.313:867): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719654784.313:868): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654784.326:869): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=2832 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_ACCT msg=audit(1719654784.329:870): pid=2832 uid=1000 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:accounting grantors=pam_unix,pam_localuser acct="vagrant" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_CMD msg=audit(1719654784.329:871): pid=2832 uid=1000 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='cwd="/home/vagrant" cmd=62617368202D6C terminal=? res=success'
type=CRED_REFR msg=audit(1719654784.329:872): pid=2832 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_START msg=audit(1719654784.329:873): pid=2832 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:session_open grantors=pam_keyinit,pam_keyinit,pam_limits,pam_systemd,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=SERVICE_STOP msg=audit(1719654786.671:874): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=NetworkManager-dispatcher comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=SERVICE_STOP msg=audit(1719654805.328:875): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=systemd-hostnamed comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=success'
type=SOFTWARE_UPDATE msg=audit(1719654823.193:876): pid=2852 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='sw="epel-release-7-11.noarch" sw_type=rpm key_enforce=0 gpg_res=1 root_dir="/" comm="yum" exe="/usr/bin/python2.7" hostname=? addr=? terminal=? res=success'
type=SOFTWARE_UPDATE msg=audit(1719654858.293:877): pid=2889 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='sw="centos-logos-70.0.6-3.el7.centos.noarch" sw_type=rpm key_enforce=0 gpg_res=1 root_dir="/" comm="yum" exe="/usr/bin/python2.7" hostname=? addr=? terminal=? res=success'
type=SOFTWARE_UPDATE msg=audit(1719654858.431:878): pid=2889 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='sw="centos-indexhtml-7-9.el7.centos.noarch" sw_type=rpm key_enforce=0 gpg_res=1 root_dir="/" comm="yum" exe="/usr/bin/python2.7" hostname=? addr=? terminal=? res=success'
type=SOFTWARE_UPDATE msg=audit(1719654860.077:879): pid=2889 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='sw="openssl11-libs-1:1.1.1k-7.el7.x86_64" sw_type=rpm key_enforce=0 gpg_res=1 root_dir="/" comm="yum" exe="/usr/bin/python2.7" hostname=? addr=? terminal=? res=success'
type=SOFTWARE_UPDATE msg=audit(1719654860.438:880): pid=2889 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='sw="gperftools-libs-2.6.1-1.el7.x86_64" sw_type=rpm key_enforce=0 gpg_res=1 root_dir="/" comm="yum" exe="/usr/bin/python2.7" hostname=? addr=? terminal=? res=success'
type=ADD_GROUP msg=audit(1719654860.574:881): pid=3030 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:groupadd_t:s0-s0:c0.c1023 msg='op=add-group id=994 exe="/usr/sbin/groupadd" hostname=? addr=? terminal=? res=success'
type=GRP_MGMT msg=audit(1719654860.597:882): pid=3030 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:groupadd_t:s0-s0:c0.c1023 msg='op=add-shadow-group id=994 exe="/usr/sbin/groupadd" hostname=? addr=? terminal=? res=success'
type=ADD_USER msg=audit(1719654860.662:883): pid=3035 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:useradd_t:s0-s0:c0.c1023 msg='op=add-user id=997 exe="/usr/sbin/useradd" hostname=? addr=? terminal=? res=success'
type=USER_MGMT msg=audit(1719654860.720:884): pid=3040 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:useradd_t:s0-s0:c0.c1023 msg='op=pam_tally2 reset=0 id=997 exe="/usr/sbin/pam_tally2" hostname=? addr=? terminal=? res=success'
type=SOFTWARE_UPDATE msg=audit(1719654860.810:885): pid=2889 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='sw="nginx-filesystem-1:1.20.1-10.el7.noarch" sw_type=rpm key_enforce=0 gpg_res=1 root_dir="/" comm="yum" exe="/usr/bin/python2.7" hostname=? addr=? terminal=? res=success'
type=SOFTWARE_UPDATE msg=audit(1719654861.666:886): pid=2889 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='sw="nginx-1:1.20.1-10.el7.x86_64" sw_type=rpm key_enforce=0 gpg_res=1 root_dir="/" comm="yum" exe="/usr/bin/python2.7" hostname=? addr=? terminal=? res=success'
type=AVC msg=audit(1719654862.733:887): avc:  denied  { name_bind } for  pid=3065 comm="nginx" src=4881 scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:unreserved_port_t:s0 tclass=tcp_socket permissive=0
type=SYSCALL msg=audit(1719654862.733:887): arch=c000003e syscall=49 success=no exit=-13 a0=6 a1=55e88c82f7e8 a2=10 a3=7ffddb98ec70 items=0 ppid=1 pid=3065 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="nginx" exe="/usr/sbin/nginx" subj=system_u:system_r:httpd_t:s0 key=(null)
type=PROCTITLE msg=audit(1719654862.733:887): proctitle=2F7573722F7362696E2F6E67696E78002D74
type=SERVICE_START msg=audit(1719654862.733:888): pid=1 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:init_t:s0 msg='unit=nginx comm="systemd" exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=? res=failed'
type=USER_END msg=audit(1719654862.957:889): pid=2832 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:session_close grantors=pam_keyinit,pam_keyinit,pam_limits,pam_systemd,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=CRED_DISP msg=audit(1719654862.957:890): pid=2832 uid=0 auid=1000 ses=2 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654862.973:891): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGOUT msg=audit(1719654862.973:892): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654863.253:893): pid=924 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=925 suid=74  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654863.253:894): pid=924 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:a2:6b:81:8b:eb:b5:57:05:f0:50:15:5d:b0:ad:19:5f:40:cc:f8:dd:94:64:89:6a:53:b4:eb:24:f0:b0:1d:2a direction=? spid=924 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654863.253:895): pid=924 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:05:47:69:24:3b:ec:0c:78:36:c6:28:e9:a8:68:58:4b:68:df:31:dc:c3:cb:8d:d2:65:cf:d9:ff:b1:b1:c9:41 direction=? spid=924 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654863.268:896): pid=924 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=924 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_LOGIN msg=audit(1719654863.268:897): pid=924 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login acct="(unknown)" exe="/usr/sbin/sshd" hostname=? addr=10.0.2.2 terminal=ssh res=failed'
type=CRYPTO_KEY_USER msg=audit(1719654863.268:898): pid=1155 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1157 suid=74  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654863.268:899): pid=1155 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:a2:6b:81:8b:eb:b5:57:05:f0:50:15:5d:b0:ad:19:5f:40:cc:f8:dd:94:64:89:6a:53:b4:eb:24:f0:b0:1d:2a direction=? spid=1155 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654863.268:900): pid=1155 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:05:47:69:24:3b:ec:0c:78:36:c6:28:e9:a8:68:58:4b:68:df:31:dc:c3:cb:8d:d2:65:cf:d9:ff:b1:b1:c9:41 direction=? spid=1155 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654863.268:901): pid=1155 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1155 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_LOGIN msg=audit(1719654863.268:902): pid=1155 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login acct="(unknown)" exe="/usr/sbin/sshd" hostname=? addr=10.0.2.2 terminal=ssh res=failed'
type=CRYPTO_KEY_USER msg=audit(1719654863.268:903): pid=1506 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1511 suid=74  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654863.268:904): pid=1506 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:a2:6b:81:8b:eb:b5:57:05:f0:50:15:5d:b0:ad:19:5f:40:cc:f8:dd:94:64:89:6a:53:b4:eb:24:f0:b0:1d:2a direction=? spid=1506 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654863.268:905): pid=1506 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:05:47:69:24:3b:ec:0c:78:36:c6:28:e9:a8:68:58:4b:68:df:31:dc:c3:cb:8d:d2:65:cf:d9:ff:b1:b1:c9:41 direction=? spid=1506 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654863.268:906): pid=1506 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1506 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_LOGIN msg=audit(1719654863.268:907): pid=1506 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login acct="(unknown)" exe="/usr/sbin/sshd" hostname=? addr=10.0.2.2 terminal=ssh res=failed'
type=CRYPTO_KEY_USER msg=audit(1719654863.268:908): pid=689 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=691 suid=74  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654863.268:909): pid=689 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:a2:6b:81:8b:eb:b5:57:05:f0:50:15:5d:b0:ad:19:5f:40:cc:f8:dd:94:64:89:6a:53:b4:eb:24:f0:b0:1d:2a direction=? spid=689 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654863.268:910): pid=689 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:05:47:69:24:3b:ec:0c:78:36:c6:28:e9:a8:68:58:4b:68:df:31:dc:c3:cb:8d:d2:65:cf:d9:ff:b1:b1:c9:41 direction=? spid=689 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654863.268:911): pid=689 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=689 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_LOGIN msg=audit(1719654863.268:912): pid=689 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login acct="(unknown)" exe="/usr/sbin/sshd" hostname=? addr=10.0.2.2 terminal=ssh res=failed'
type=CRYPTO_KEY_USER msg=audit(1719654863.294:913): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=session fp=? direction=both spid=1714 suid=1000 rport=56616 laddr=10.0.2.15 lport=22  exe="/usr/sbin/sshd" hostname=? addr=10.0.2.2 terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654863.300:914): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1714 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_END msg=audit(1719654863.305:915): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=PAM:session_close grantors=pam_selinux,pam_loginuid,pam_selinux,pam_namespace,pam_keyinit,pam_keyinit,pam_limits,pam_systemd,pam_unix,pam_lastlog acct="vagrant" exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRED_DISP msg=audit(1719654863.305:916): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="vagrant" exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719654863.305:917): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:a2:6b:81:8b:eb:b5:57:05:f0:50:15:5d:b0:ad:19:5f:40:cc:f8:dd:94:64:89:6a:53:b4:eb:24:f0:b0:1d:2a direction=? spid=1711 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654863.305:918): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:05:47:69:24:3b:ec:0c:78:36:c6:28:e9:a8:68:58:4b:68:df:31:dc:c3:cb:8d:d2:65:cf:d9:ff:b1:b1:c9:41 direction=? spid=1711 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719654863.305:919): pid=1711 uid=0 auid=1000 ses=2 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=1711 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719655191.727:920): pid=3081 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:a2:6b:81:8b:eb:b5:57:05:f0:50:15:5d:b0:ad:19:5f:40:cc:f8:dd:94:64:89:6a:53:b4:eb:24:f0:b0:1d:2a direction=? spid=3081 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719655191.727:921): pid=3081 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:05:47:69:24:3b:ec:0c:78:36:c6:28:e9:a8:68:58:4b:68:df:31:dc:c3:cb:8d:d2:65:cf:d9:ff:b1:b1:c9:41 direction=? spid=3081 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719655191.727:922): pid=3081 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=3081 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_SESSION msg=audit(1719655191.737:923): pid=3080 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=start direction=from-server cipher=chacha20-poly1305@openssh.com ksize=512 mac=<implicit> pfs=curve25519-sha256 spid=3081 suid=74 rport=38034 laddr=10.0.2.15 lport=22  exe="/usr/sbin/sshd" hostname=? addr=10.0.2.2 terminal=? res=success'
type=CRYPTO_SESSION msg=audit(1719655191.737:924): pid=3080 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=start direction=from-client cipher=chacha20-poly1305@openssh.com ksize=512 mac=<implicit> pfs=curve25519-sha256 spid=3081 suid=74 rport=38034 laddr=10.0.2.15 lport=22  exe="/usr/sbin/sshd" hostname=? addr=10.0.2.2 terminal=? res=success'
type=USER_AUTH msg=audit(1719655191.863:925): pid=3080 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=pubkey_auth rport=38034 acct="vagrant" exe="/usr/sbin/sshd" hostname=? addr=10.0.2.2 terminal=? res=success'
type=USER_AUTH msg=audit(1719655191.863:926): pid=3080 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=key algo=ssh-ed25519 size=256 fp=SHA256:0a:65:cf:23:2f:77:98:a7:19:11:27:ee:38:86:25:1f:6f:46:72:03:5f:f2:60:cc:19:dc:61:99:cf:72:0c:cb rport=38034 acct="vagrant" exe="/usr/sbin/sshd" hostname=? addr=10.0.2.2 terminal=? res=success'
type=USER_ACCT msg=audit(1719655191.863:927): pid=3080 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=PAM:accounting grantors=pam_unix,pam_localuser acct="vagrant" exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719655191.910:928): pid=3080 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=session fp=? direction=both spid=3081 suid=74 rport=38034 laddr=10.0.2.15 lport=22  exe="/usr/sbin/sshd" hostname=? addr=10.0.2.2 terminal=? res=success'
type=USER_AUTH msg=audit(1719655191.910:929): pid=3080 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=success acct="vagrant" exe="/usr/sbin/sshd" hostname=? addr=10.0.2.2 terminal=ssh res=success'
type=CRED_ACQ msg=audit(1719655191.910:930): pid=3080 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="vagrant" exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=LOGIN msg=audit(1719655191.910:931): pid=3080 uid=0 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 old-auid=4294967295 auid=1000 tty=(none) old-ses=4294967295 ses=4 res=1
type=USER_ROLE_CHANGE msg=audit(1719655192.263:932): pid=3080 uid=0 auid=1000 ses=4 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='pam: default-context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 selected-context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_START msg=audit(1719655192.429:933): pid=3080 uid=0 auid=1000 ses=4 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=PAM:session_open grantors=pam_selinux,pam_loginuid,pam_selinux,pam_namespace,pam_keyinit,pam_keyinit,pam_limits,pam_systemd,pam_unix,pam_lastlog acct="vagrant" exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=CRYPTO_KEY_USER msg=audit(1719655192.429:934): pid=3083 uid=0 auid=1000 ses=4 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:a2:6b:81:8b:eb:b5:57:05:f0:50:15:5d:b0:ad:19:5f:40:cc:f8:dd:94:64:89:6a:53:b4:eb:24:f0:b0:1d:2a direction=? spid=3083 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719655192.429:935): pid=3083 uid=0 auid=1000 ses=4 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:05:47:69:24:3b:ec:0c:78:36:c6:28:e9:a8:68:58:4b:68:df:31:dc:c3:cb:8d:d2:65:cf:d9:ff:b1:b1:c9:41 direction=? spid=3083 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRYPTO_KEY_USER msg=audit(1719655192.429:936): pid=3083 uid=0 auid=1000 ses=4 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=3083 suid=0  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=CRED_ACQ msg=audit(1719655192.429:937): pid=3083 uid=0 auid=1000 ses=4 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="vagrant" exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=ssh res=success'
type=USER_LOGIN msg=audit(1719655192.463:938): pid=3080 uid=0 auid=1000 ses=4 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=/dev/pts/0 res=success'
type=USER_START msg=audit(1719655192.463:939): pid=3080 uid=0 auid=1000 ses=4 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=login id=1000 exe="/usr/sbin/sshd" hostname=10.0.2.2 addr=10.0.2.2 terminal=/dev/pts/0 res=success'
type=CRYPTO_KEY_USER msg=audit(1719655192.486:940): pid=3080 uid=0 auid=1000 ses=4 subj=system_u:system_r:sshd_t:s0-s0:c0.c1023 msg='op=destroy kind=server fp=SHA256:93:62:40:1d:57:ce:34:8e:a2:a7:7f:0f:ad:2a:93:04:96:4b:ca:43:22:87:bd:ca:3c:05:4d:ef:cb:af:0a:3b direction=? spid=3084 suid=1000  exe="/usr/sbin/sshd" hostname=? addr=? terminal=? res=success'
type=USER_ACCT msg=audit(1719655196.988:941): pid=3105 uid=1000 auid=1000 ses=4 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:accounting grantors=pam_unix,pam_localuser acct="vagrant" exe="/usr/bin/sudo" hostname=? addr=? terminal=/dev/pts/0 res=success'
type=USER_CMD msg=audit(1719655196.988:942): pid=3105 uid=1000 auid=1000 ses=4 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='cwd="/home/vagrant" cmd="-bash" terminal=pts/0 res=success'
type=CRED_REFR msg=audit(1719655196.988:943): pid=3105 uid=0 auid=1000 ses=4 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=/dev/pts/0 res=success'
type=USER_START msg=audit(1719655196.988:944): pid=3105 uid=0 auid=1000 ses=4 subj=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 msg='op=PAM:session_open grantors=pam_keyinit,pam_keyinit,pam_keyinit,pam_limits,pam_systemd,pam_unix acct="root" exe="/usr/bin/sudo" hostname=? addr=? terminal=/dev/pts/0 res=success'
type=USER_ACCT msg=audit(1719655261.819:945): pid=3127 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:crond_t:s0-s0:c0.c1023 msg='op=PAM:accounting grantors=pam_access,pam_unix,pam_localuser acct="root" exe="/usr/sbin/crond" hostname=? addr=? terminal=cron res=success'
type=CRED_ACQ msg=audit(1719655261.819:946): pid=3127 uid=0 auid=4294967295 ses=4294967295 subj=system_u:system_r:crond_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="root" exe="/usr/sbin/crond" hostname=? addr=? terminal=cron res=success'
type=LOGIN msg=audit(1719655261.819:947): pid=3127 uid=0 subj=system_u:system_r:crond_t:s0-s0:c0.c1023 old-auid=4294967295 auid=0 tty=(none) old-ses=4294967295 ses=5 res=1
type=USER_START msg=audit(1719655261.914:948): pid=3127 uid=0 auid=0 ses=5 subj=system_u:system_r:crond_t:s0-s0:c0.c1023 msg='op=PAM:session_open grantors=pam_loginuid,pam_keyinit,pam_limits,pam_systemd acct="root" exe="/usr/sbin/crond" hostname=? addr=? terminal=cron res=success'
type=CRED_REFR msg=audit(1719655261.914:949): pid=3127 uid=0 auid=0 ses=5 subj=system_u:system_r:crond_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="root" exe="/usr/sbin/crond" hostname=? addr=? terminal=cron res=success'
type=CRED_DISP msg=audit(1719655262.029:950): pid=3127 uid=0 auid=0 ses=5 subj=system_u:system_r:crond_t:s0-s0:c0.c1023 msg='op=PAM:setcred grantors=pam_env,pam_unix acct="root" exe="/usr/sbin/crond" hostname=? addr=? terminal=cron res=success'
type=USER_END msg=audit(1719655262.029:951): pid=3127 uid=0 auid=0 ses=5 subj=system_u:system_r:crond_t:s0-s0:c0.c1023 msg='op=PAM:session_close grantors=pam_loginuid,pam_keyinit,pam_limits,pam_systemd acct="root" exe="/usr/sbin/crond" hostname=? addr=? terminal=cron res=success'
[root@selinux ~]# 
[root@selinux ~]#  grep 1636489992.273:967 /var/log/audit/audit.log | audit2why
-bash: audit2why: command not found
[root@selinux ~]#   grep permission /var/log/audit/audit.log | audit2why
-bash: audit2why: command not found
[root@selinux ~]# yum install -y setroubleshoot-server selinux-policy-mls setools-console policycoreutils-newrole
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: ftp.nsc.ru
 * epel: mirror.logol.ru
 * extras: mirror.docker.ru
 * updates: mirror.docker.ru
Resolving Dependencies
--> Running transaction check
---> Package policycoreutils-newrole.x86_64 0:2.5-34.el7 will be installed
---> Package selinux-policy-mls.noarch 0:3.13.1-268.el7_9.2 will be installed
--> Processing Dependency: selinux-policy = 3.13.1-268.el7_9.2 for package: selinux-policy-mls-3.13.1-268.el7_9.2.noarch
--> Processing Dependency: selinux-policy = 3.13.1-268.el7_9.2 for package: selinux-policy-mls-3.13.1-268.el7_9.2.noarch
--> Processing Dependency: setransd for package: selinux-policy-mls-3.13.1-268.el7_9.2.noarch
---> Package setools-console.x86_64 0:3.3.8-4.el7 will be installed
--> Processing Dependency: setools-libs = 3.3.8-4.el7 for package: setools-console-3.3.8-4.el7.x86_64
--> Processing Dependency: libqpol.so.1(VERS_1.5)(64bit) for package: setools-console-3.3.8-4.el7.x86_64
--> Processing Dependency: libqpol.so.1(VERS_1.2)(64bit) for package: setools-console-3.3.8-4.el7.x86_64
--> Processing Dependency: libqpol.so.1()(64bit) for package: setools-console-3.3.8-4.el7.x86_64
---> Package setroubleshoot-server.x86_64 0:3.2.30-8.el7 will be installed
--> Processing Dependency: systemd-python >= 206-1 for package: setroubleshoot-server-3.2.30-8.el7.x86_64
--> Processing Dependency: setroubleshoot-plugins >= 3.0.62 for package: setroubleshoot-server-3.2.30-8.el7.x86_64
--> Processing Dependency: audit-libs-python >= 1.2.6-3 for package: setroubleshoot-server-3.2.30-8.el7.x86_64
--> Processing Dependency: pygobject2 for package: setroubleshoot-server-3.2.30-8.el7.x86_64
--> Processing Dependency: policycoreutils-python for package: setroubleshoot-server-3.2.30-8.el7.x86_64
--> Running transaction check
---> Package audit-libs-python.x86_64 0:2.8.5-4.el7 will be installed
---> Package mcstrans.x86_64 0:0.3.4-5.el7 will be installed
---> Package policycoreutils-python.x86_64 0:2.5-34.el7 will be installed
--> Processing Dependency: libsemanage-python >= 2.5-14 for package: policycoreutils-python-2.5-34.el7.x86_64
--> Processing Dependency: python-IPy for package: policycoreutils-python-2.5-34.el7.x86_64
--> Processing Dependency: libcgroup for package: policycoreutils-python-2.5-34.el7.x86_64
--> Processing Dependency: checkpolicy for package: policycoreutils-python-2.5-34.el7.x86_64
---> Package pygobject2.x86_64 0:2.28.6-11.el7 will be installed
---> Package selinux-policy.noarch 0:3.13.1-266.el7 will be updated
--> Processing Dependency: selinux-policy = 3.13.1-266.el7 for package: selinux-policy-targeted-3.13.1-266.el7.noarch
--> Processing Dependency: selinux-policy = 3.13.1-266.el7 for package: selinux-policy-targeted-3.13.1-266.el7.noarch
---> Package selinux-policy.noarch 0:3.13.1-268.el7_9.2 will be an update
---> Package setools-libs.x86_64 0:3.3.8-4.el7 will be installed
---> Package setroubleshoot-plugins.noarch 0:3.0.67-4.el7 will be installed
---> Package systemd-python.x86_64 0:219-78.el7_9.9 will be installed
--> Processing Dependency: systemd-libs = 219-78.el7_9.9 for package: systemd-python-219-78.el7_9.9.x86_64
--> Processing Dependency: systemd = 219-78.el7_9.9 for package: systemd-python-219-78.el7_9.9.x86_64
--> Running transaction check
---> Package checkpolicy.x86_64 0:2.5-8.el7 will be installed
---> Package libcgroup.x86_64 0:0.41-21.el7 will be installed
---> Package libsemanage-python.x86_64 0:2.5-14.el7 will be installed
---> Package python-IPy.noarch 0:0.75-6.el7 will be installed
---> Package selinux-policy-targeted.noarch 0:3.13.1-266.el7 will be updated
---> Package selinux-policy-targeted.noarch 0:3.13.1-268.el7_9.2 will be an update
---> Package systemd.x86_64 0:219-73.el7_8.5 will be updated
--> Processing Dependency: systemd = 219-73.el7_8.5 for package: systemd-sysv-219-73.el7_8.5.x86_64
---> Package systemd.x86_64 0:219-78.el7_9.9 will be an update
---> Package systemd-libs.x86_64 0:219-73.el7_8.5 will be updated
---> Package systemd-libs.x86_64 0:219-78.el7_9.9 will be an update
--> Running transaction check
---> Package systemd-sysv.x86_64 0:219-73.el7_8.5 will be updated
---> Package systemd-sysv.x86_64 0:219-78.el7_9.9 will be an update
--> Finished Dependency Resolution

Dependencies Resolved

===================================================================================================================================================================================================================================================
 Package                                                             Arch                                               Version                                                          Repository                                           Size
===================================================================================================================================================================================================================================================
Installing:
 policycoreutils-newrole                                             x86_64                                             2.5-34.el7                                                       base                                                172 k
 selinux-policy-mls                                                  noarch                                             3.13.1-268.el7_9.2                                               updates                                             5.1 M
 setools-console                                                     x86_64                                             3.3.8-4.el7                                                      base                                                310 k
 setroubleshoot-server                                               x86_64                                             3.2.30-8.el7                                                     base                                                390 k
Installing for dependencies:
 audit-libs-python                                                   x86_64                                             2.8.5-4.el7                                                      base                                                 76 k
 checkpolicy                                                         x86_64                                             2.5-8.el7                                                        base                                                295 k
 libcgroup                                                           x86_64                                             0.41-21.el7                                                      base                                                 66 k
 libsemanage-python                                                  x86_64                                             2.5-14.el7                                                       base                                                113 k
 mcstrans                                                            x86_64                                             0.3.4-5.el7                                                      base                                                116 k
 policycoreutils-python                                              x86_64                                             2.5-34.el7                                                       base                                                457 k
 pygobject2                                                          x86_64                                             2.28.6-11.el7                                                    base                                                226 k
 python-IPy                                                          noarch                                             0.75-6.el7                                                       base                                                 32 k
 setools-libs                                                        x86_64                                             3.3.8-4.el7                                                      base                                                620 k
 setroubleshoot-plugins                                              noarch                                             3.0.67-4.el7                                                     base                                                358 k
 systemd-python                                                      x86_64                                             219-78.el7_9.9                                                   updates                                             146 k
Updating for dependencies:
 selinux-policy                                                      noarch                                             3.13.1-268.el7_9.2                                               updates                                             498 k
 selinux-policy-targeted                                             noarch                                             3.13.1-268.el7_9.2                                               updates                                             7.0 M
 systemd                                                             x86_64                                             219-78.el7_9.9                                                   updates                                             5.1 M
 systemd-libs                                                        x86_64                                             219-78.el7_9.9                                                   updates                                             419 k
 systemd-sysv                                                        x86_64                                             219-78.el7_9.9                                                   updates                                              98 k

Transaction Summary
===================================================================================================================================================================================================================================================
Install  4 Packages (+11 Dependent packages)
Upgrade             (  5 Dependent packages)

Total download size: 21 M
Downloading packages:
No Presto metadata available for updates
(1/20): audit-libs-python-2.8.5-4.el7.x86_64.rpm                                                                                                                                                                            |  76 kB  00:00:00     
(2/20): libcgroup-0.41-21.el7.x86_64.rpm                                                                                                                                                                                    |  66 kB  00:00:00     
(3/20): checkpolicy-2.5-8.el7.x86_64.rpm                                                                                                                                                                                    | 295 kB  00:00:00     
(4/20): mcstrans-0.3.4-5.el7.x86_64.rpm                                                                                                                                                                                     | 116 kB  00:00:00     
(5/20): libsemanage-python-2.5-14.el7.x86_64.rpm                                                                                                                                                                            | 113 kB  00:00:00     
(6/20): policycoreutils-newrole-2.5-34.el7.x86_64.rpm                                                                                                                                                                       | 172 kB  00:00:00     
(7/20): policycoreutils-python-2.5-34.el7.x86_64.rpm                                                                                                                                                                        | 457 kB  00:00:00     
(8/20): pygobject2-2.28.6-11.el7.x86_64.rpm                                                                                                                                                                                 | 226 kB  00:00:00     
(9/20): python-IPy-0.75-6.el7.noarch.rpm                                                                                                                                                                                    |  32 kB  00:00:00     
(10/20): setools-console-3.3.8-4.el7.x86_64.rpm                                                                                                                                                                             | 310 kB  00:00:00     
(11/20): setroubleshoot-plugins-3.0.67-4.el7.noarch.rpm                                                                                                                                                                     | 358 kB  00:00:00     
(12/20): selinux-policy-3.13.1-268.el7_9.2.noarch.rpm                                                                                                                                                                       | 498 kB  00:00:01     
(13/20): setools-libs-3.3.8-4.el7.x86_64.rpm                                                                                                                                                                                | 620 kB  00:00:01     
(14/20): setroubleshoot-server-3.2.30-8.el7.x86_64.rpm                                                                                                                                                                      | 390 kB  00:00:00     
(15/20): systemd-219-78.el7_9.9.x86_64.rpm                                                                                                                                                                                  | 5.1 MB  00:00:01     
(16/20): systemd-libs-219-78.el7_9.9.x86_64.rpm                                                                                                                                                                             | 419 kB  00:00:00     
(17/20): systemd-python-219-78.el7_9.9.x86_64.rpm                                                                                                                                                                           | 146 kB  00:00:00     
(18/20): systemd-sysv-219-78.el7_9.9.x86_64.rpm                                                                                                                                                                             |  98 kB  00:00:00     
(19/20): selinux-policy-mls-3.13.1-268.el7_9.2.noarch.rpm                                                                                                                                                                   | 5.1 MB  00:00:04     
(20/20): selinux-policy-targeted-3.13.1-268.el7_9.2.noarch.rpm                                                                                                                                                              | 7.0 MB  00:00:04     
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Total                                                                                                                                                                                                              3.6 MB/s |  21 MB  00:00:06     
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Updating   : systemd-libs-219-78.el7_9.9.x86_64                                                                                                                                                                                             1/25 
  Updating   : systemd-219-78.el7_9.9.x86_64                                                                                                                                                                                                  2/25 
  Installing : audit-libs-python-2.8.5-4.el7.x86_64                                                                                                                                                                                           3/25 
  Updating   : selinux-policy-3.13.1-268.el7_9.2.noarch                                                                                                                                                                                       4/25 
  Installing : setools-libs-3.3.8-4.el7.x86_64                                                                                                                                                                                                5/25 
  Installing : systemd-python-219-78.el7_9.9.x86_64                                                                                                                                                                                           6/25 
  Installing : mcstrans-0.3.4-5.el7.x86_64                                                                                                                                                                                                    7/25 
  Installing : libcgroup-0.41-21.el7.x86_64                                                                                                                                                                                                   8/25 
  Installing : policycoreutils-newrole-2.5-34.el7.x86_64                                                                                                                                                                                      9/25 
  Installing : libsemanage-python-2.5-14.el7.x86_64                                                                                                                                                                                          10/25 
  Installing : pygobject2-2.28.6-11.el7.x86_64                                                                                                                                                                                               11/25 
  Installing : python-IPy-0.75-6.el7.noarch                                                                                                                                                                                                  12/25 
  Installing : checkpolicy-2.5-8.el7.x86_64                                                                                                                                                                                                  13/25 
  Installing : policycoreutils-python-2.5-34.el7.x86_64                                                                                                                                                                                      14/25 
  Installing : setroubleshoot-plugins-3.0.67-4.el7.noarch                                                                                                                                                                                    15/25 
  Installing : setroubleshoot-server-3.2.30-8.el7.x86_64                                                                                                                                                                                     16/25 
  Installing : selinux-policy-mls-3.13.1-268.el7_9.2.noarch                                                                                                                                                                                  17/25 
  Installing : setools-console-3.3.8-4.el7.x86_64                                                                                                                                                                                            18/25 
  Updating   : selinux-policy-targeted-3.13.1-268.el7_9.2.noarch                                                                                                                                                                             19/25 
  Updating   : systemd-sysv-219-78.el7_9.9.x86_64                                                                                                                                                                                            20/25 
  Cleanup    : selinux-policy-targeted-3.13.1-266.el7.noarch                                                                                                                                                                                 21/25 
  Cleanup    : systemd-sysv-219-73.el7_8.5.x86_64                                                                                                                                                                                            22/25 
  Cleanup    : selinux-policy-3.13.1-266.el7.noarch                                                                                                                                                                                          23/25 
  Cleanup    : systemd-219-73.el7_8.5.x86_64                                                                                                                                                                                                 24/25 
  Cleanup    : systemd-libs-219-73.el7_8.5.x86_64                                                                                                                                                                                            25/25 
  Verifying  : setroubleshoot-server-3.2.30-8.el7.x86_64                                                                                                                                                                                      1/25 
  Verifying  : systemd-sysv-219-78.el7_9.9.x86_64                                                                                                                                                                                             2/25 
  Verifying  : systemd-219-78.el7_9.9.x86_64                                                                                                                                                                                                  3/25 
  Verifying  : selinux-policy-targeted-3.13.1-268.el7_9.2.noarch                                                                                                                                                                              4/25 
  Verifying  : checkpolicy-2.5-8.el7.x86_64                                                                                                                                                                                                   5/25 
  Verifying  : python-IPy-0.75-6.el7.noarch                                                                                                                                                                                                   6/25 
  Verifying  : policycoreutils-python-2.5-34.el7.x86_64                                                                                                                                                                                       7/25 
  Verifying  : pygobject2-2.28.6-11.el7.x86_64                                                                                                                                                                                                8/25 
  Verifying  : setools-libs-3.3.8-4.el7.x86_64                                                                                                                                                                                                9/25 
  Verifying  : selinux-policy-mls-3.13.1-268.el7_9.2.noarch                                                                                                                                                                                  10/25 
  Verifying  : libsemanage-python-2.5-14.el7.x86_64                                                                                                                                                                                          11/25 
  Verifying  : systemd-python-219-78.el7_9.9.x86_64                                                                                                                                                                                          12/25 
  Verifying  : mcstrans-0.3.4-5.el7.x86_64                                                                                                                                                                                                   13/25 
  Verifying  : policycoreutils-newrole-2.5-34.el7.x86_64                                                                                                                                                                                     14/25 
  Verifying  : selinux-policy-3.13.1-268.el7_9.2.noarch                                                                                                                                                                                      15/25 
  Verifying  : audit-libs-python-2.8.5-4.el7.x86_64                                                                                                                                                                                          16/25 
  Verifying  : setroubleshoot-plugins-3.0.67-4.el7.noarch                                                                                                                                                                                    17/25 
  Verifying  : systemd-libs-219-78.el7_9.9.x86_64                                                                                                                                                                                            18/25 
  Verifying  : setools-console-3.3.8-4.el7.x86_64                                                                                                                                                                                            19/25 
  Verifying  : libcgroup-0.41-21.el7.x86_64                                                                                                                                                                                                  20/25 
  Verifying  : selinux-policy-3.13.1-266.el7.noarch                                                                                                                                                                                          21/25 
  Verifying  : systemd-sysv-219-73.el7_8.5.x86_64                                                                                                                                                                                            22/25 
  Verifying  : selinux-policy-targeted-3.13.1-266.el7.noarch                                                                                                                                                                                 23/25 
  Verifying  : systemd-libs-219-73.el7_8.5.x86_64                                                                                                                                                                                            24/25 
  Verifying  : systemd-219-73.el7_8.5.x86_64                                                                                                                                                                                                 25/25 

Installed:
  policycoreutils-newrole.x86_64 0:2.5-34.el7                  selinux-policy-mls.noarch 0:3.13.1-268.el7_9.2                  setools-console.x86_64 0:3.3.8-4.el7                  setroubleshoot-server.x86_64 0:3.2.30-8.el7                 

Dependency Installed:
  audit-libs-python.x86_64 0:2.8.5-4.el7  checkpolicy.x86_64 0:2.5-8.el7  libcgroup.x86_64 0:0.41-21.el7     libsemanage-python.x86_64 0:2.5-14.el7        mcstrans.x86_64 0:0.3.4-5.el7           policycoreutils-python.x86_64 0:2.5-34.el7 
  pygobject2.x86_64 0:2.28.6-11.el7       python-IPy.noarch 0:0.75-6.el7  setools-libs.x86_64 0:3.3.8-4.el7  setroubleshoot-plugins.noarch 0:3.0.67-4.el7  systemd-python.x86_64 0:219-78.el7_9.9 

Dependency Updated:
  selinux-policy.noarch 0:3.13.1-268.el7_9.2         selinux-policy-targeted.noarch 0:3.13.1-268.el7_9.2         systemd.x86_64 0:219-78.el7_9.9         systemd-libs.x86_64 0:219-78.el7_9.9         systemd-sysv.x86_64 0:219-78.el7_9.9        

Complete!
[root@selinux ~]# dnf -y install setroubleshoot-server
-bash: dnf: command not found
[root@selinux ~]# 
[root@selinux ~]# 
[root@selinux ~]#   grep permission /var/log/audit/audit.log | audit2why
Nothing to do
[root@selinux ~]#  grep 1636489992.273:967 /var/log/audit/audit.log | audit2why
Nothing to do
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
[root@selinux ~]# getsebool -a | grep nis_enabled
nis_enabled --> on
[root@selinux ~]# 
[root@selinux ~]# setsebool -P nis_enabled off
[root@selinux ~]# systemctl restart nginx
Job for nginx.service failed because the control process exited with error code. See "systemctl status nginx.service" and "journalctl -xe" for details.
[root@selinux ~]# 
[root@selinux ~]# 
[root@selinux ~]# semanage port -l | grep http
http_cache_port_t              tcp      8080, 8118, 8123, 10001-10010
http_cache_port_t              udp      3130
http_port_t                    tcp      80, 81, 443, 488, 8008, 8009, 8443, 9000
pegasus_http_port_t            tcp      5988
pegasus_https_port_t           tcp      5989
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
[root@selinux ~]# 
[root@selinux ~]# 
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
[root@selinux ~]# 
[root@selinux ~]# grep nginx /var/log/audit/audit.log | audit2allow -M nginx
******************** IMPORTANT ***********************
To make this policy package active, execute:

semodule -i nginx.pp

[root@selinux ~]# semodule -i nginx.pp

[root@selinux ~]# 
[root@selinux ~]# systemctl start nginx
[root@selinux ~]# systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
   Active: active (running) since Sat 2024-06-29 10:14:46 UTC; 2s ago
  Process: 4210 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
  Process: 4207 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
  Process: 4206 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
 Main PID: 4212 (nginx)
   CGroup: /system.slice/nginx.service
           ├─4212 nginx: master process /usr/sbin/nginx
           └─4214 nginx: worker process

Jun 29 10:14:46 selinux systemd[1]: Starting The nginx HTTP and reverse proxy server...
Jun 29 10:14:46 selinux nginx[4207]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
Jun 29 10:14:46 selinux nginx[4207]: nginx: configuration file /etc/nginx/nginx.conf test is successful
Jun 29 10:14:46 selinux systemd[1]: Started The nginx HTTP and reverse proxy server.
[root@selinux ~]# 
[root@selinux ~]# semodule -l
abrt	1.4.1
accountsd	1.1.0
acct	1.6.0
afs	1.9.0
aiccu	1.1.0
aide	1.7.1
ajaxterm	1.0.0
alsa	1.12.2
amanda	1.15.0
amtu	1.3.0
anaconda	1.7.0
antivirus	1.0.0
apache	2.7.2
apcupsd	1.9.0
apm	1.12.0
application	1.2.0
arpwatch	1.11.0
asterisk	1.12.1
auditadm	2.2.0
authconfig	1.0.0
authlogin	2.5.1
automount	1.14.1
avahi	1.14.1
awstats	1.5.0
bacula	1.2.0
base	(null)
bcfg2	1.1.0
bind	1.13.1
bitlbee	1.5.0
blkmapd	1.0.0
blueman	1.1.0
bluetooth	3.5.0
boinc	1.1.1
boltd	1.0.0
bootloader	1.14.0
brctl	1.7.0
brltty	1.0.0
bugzilla	1.1.0
bumblebee	1.0.0
cachefilesd	1.1.0
calamaris	1.8.0
callweaver	1.1.0
canna	1.12.0
ccs	1.6.0
cdrecord	2.6.0
certmaster	1.3.0
certmonger	1.2.0
certwatch	1.8.0
cfengine	1.1.0
cgdcbxd	1.0.0
cgroup	1.2.0
chrome	1.0.0
chronyd	1.2.0
cinder	1.0.0
cipe	1.6.0
clock	1.7.0
clogd	1.1.0
cloudform	1.0
cmirrord	1.1.0
cobbler	1.2.0
cockpit	1.0.0
collectd	1.0.0
colord	1.1.0
comsat	1.8.0
condor	1.0.1
conman	1.0.0
consolekit	1.9.0
container	1.0.0
couchdb	1.1.1
courier	1.14.0
cpucontrol	1.4.0
cpufreqselector	1.4.0
cpuplug	1.0.0
cron	2.6.3
ctdb	1.1.0
cups	1.16.2
cvs	1.10.2
cyphesis	1.3.0
cyrus	1.13.1
daemontools	1.3.0
dbadm	1.1.0
dbskk	1.6.0
dbus	1.19.0
dcc	1.12.0
ddclient	1.10.0
denyhosts	1.1.0
devicekit	1.3.1
dhcp	1.11.0
dictd	1.8.0
dirsrv	1.0.0
dirsrv-admin	1.0.0
dmesg	1.3.0
dmidecode	1.5.1
dnsmasq	1.10.0
dnssec	1.0.0
dovecot	1.16.1
drbd	1.1.0
dspam	1.1.0
entropyd	1.8.0
exim	1.6.1
fail2ban	1.5.0
fcoe	1.1.0
fetchmail	1.13.2
finger	1.10.0
firewalld	1.1.1
firewallgui	1.1.0
firstboot	1.13.0
fprintd	1.2.0
freeipmi	1.0.0
freqset	1.0.0
fstools	1.16.1
ftp	1.15.1
games	2.3.0
ganesha	1.0.0
gdomap	1.0.1
geoclue	1.0.0
getty	1.10.0
git	1.3.2
gitosis	1.4.0
glance	1.1.0
glusterd	1.1.2
gnome	2.3.0
gpg	2.8.0
gpm	1.9.0
gpsd	1.2.0
gssproxy	1.0.0
guest	1.3.0
hddtemp	1.2.0
hostname	1.8.1
hsqldb	1.0.0
hwloc	1.0.0
hypervkvp	1.0.0
icecast	1.2.0
inetd	1.13.0
init	1.20.1
inn	1.11.0
iodine	1.1.0
iotop	1.0.0
ipa	1.0.0
ipmievd	1.0.0
ipsec	1.14.0
iptables	1.14.0
irc	2.3.1
irqbalance	1.6.0
iscsi	1.9.0
isns	1.0.0
jabber	1.10.0
jetty	1.0.0
jockey	1.0.0
journalctl	1.0.0
kdump	1.3.0
kdumpgui	1.2.0
keepalived	1.0.0
kerberos	1.12.0
keyboardd	1.1.0
keystone	1.1.0
kismet	1.7.0
kmscon	1.0
kpatch	1.0.0
ksmtuned	1.1.1
ktalk	1.9.2
l2tp	1.1.0
ldap	1.11.1
libraries	2.10.0
likewise	1.3.0
linuxptp	1.0.0
lircd	1.2.0
livecd	1.3.0
lldpad	1.1.0
loadkeys	1.9.0
locallogin	1.12.0
lockdev	1.5.0
logadm	1.0.0
logging	1.20.1
logrotate	1.15.0
logwatch	1.12.2
lpd	1.14.0
lsm	1.0.0
lttng-tools	1.0.0
lvm	1.15.2
mailman	1.10.0
mailscanner	1.1.0
man2html	1.0.0
mandb	1.1.1
mcelog	1.2.0
mediawiki	1.0.0
memcached	1.3.1
milter	1.5.0
minidlna	0.1
minissdpd	1.0.0
mip6d	1.0.0
mirrormanager	1.0.0
miscfiles	1.11.0
mock	1.0.0
modemmanager	1.2.1
modutils	1.14.0
mojomojo	1.1.0
mon_statd	1.0.0
mongodb	1.1.0
motion	1.0.0
mount	1.16.1
mozilla	2.8.0
mpd	1.1.1
mplayer	2.5.0
mrtg	1.9.0
mta	2.7.3
munin	1.9.1
mysql	1.14.1
mythtv	1.0.0
nagios	1.13.0
namespace	1.0.0
ncftool	1.2.0
netlabel	1.3.0
netutils	1.12.1
networkmanager	1.15.2
nginx	1.0
ninfod	1.0.0
nis	1.12.0
nova	1.0.0
nscd	1.11.0
nsd	1.8.0
nslcd	1.4.1
ntop	1.10.0
ntp	1.11.0
numad	1.1.0
nut	1.3.0
nx	1.7.0
obex	1.0.0
oddjob	1.10.0
openct	1.6.1
opendnssec	1.0.0
openhpid	1.0.0
openshift	1.0.0
openshift-origin	1.0.0
opensm	1.0.0
openvpn	1.12.2
openvswitch	1.1.1
openwsman	1.0.0
oracleasm	1.0.0
osad	1.0.0
pads	1.1.0
passenger	1.1.1
pcmcia	1.7.0
pcp	1.0.0
pcscd	1.8.0
pegasus	1.9.0
permissivedomains	(null)
pesign	1.0.0
pingd	1.1.0
piranha	1.0.0
pkcs	1.0.1
pki	10.0.11
plymouthd	1.2.0
podsleuth	1.7.0
policykit	1.3.0
polipo	1.1.1
portmap	1.11.0
portreserve	1.4.0
postfix	1.15.1
postgresql	1.16.0
postgrey	1.9.0
ppp	1.14.0
prelink	1.11.0
prelude	1.4.0
privoxy	1.12.0
procmail	1.13.1
prosody	1.0.0
psad	1.1.0
ptchown	1.2.0
publicfile	1.2.0
pulseaudio	1.6.0
puppet	1.4.0
pwauth	1.0.0
qmail	1.6.1
qpid	1.1.0
quantum	1.1.0
quota	1.6.0
rabbitmq	1.0.2
radius	1.13.0
radvd	1.14.0
raid	1.13.1
rasdaemon	1.0.0
rdisc	1.8.0
readahead	1.13.0
realmd	1.1.0
redis	1.0.1
remotelogin	1.8.0
rhcs	1.2.1
rhev	1.0
rhgb	1.9.0
rhnsd	1.0.0
rhsmcertd	1.1.1
ricci	1.8.0
rkhunter	1.0
rlogin	1.11.3
rngd	1.1.0
roundup	1.8.0
rpc	1.15.1
rpcbind	1.6.1
rpm	1.16.0
rshd	1.8.1
rssh	2.3.0
rsync	1.13.0
rtas	1.0.0
rtkit	1.2.0
rwho	1.7.0
samba	1.16.3
sambagui	1.2.0
sandboxX	1.0.0
sanlock	1.1.0
sasl	1.15.1
sbd	1.0.0
sblim	1.1.0
screen	2.6.0
secadm	2.4.0
sectoolm	1.1.0
selinuxutil	1.17.2
sendmail	1.12.1
sensord	1.0.0
setrans	1.8.0
setroubleshoot	1.12.1
seunshare	1.1.0
sge	1.0.0
shorewall	1.4.0
slocate	1.12.2
slpd	1.1.0
smartmon	1.12.0
smokeping	1.2.0
smoltclient	1.2.0
smsd	1.0.0
snapper	1.0.0
snmp	1.14.0
snort	1.11.0
sosreport	1.3.1
soundserver	1.9.0
spamassassin	2.6.1
speech-dispatcher	1.0.0
squid	1.12.1
ssh	2.4.2
sssd	1.2.0
staff	2.4.0
stapserver	1.1.0
stunnel	1.11.0
su	1.12.0
sudo	1.10.0
svnserve	1.1.0
swift	1.0.0
sysadm	2.6.1
sysadm_secadm	1.0.0
sysnetwork	1.15.4
sysstat	1.8.0
systemd	1.0.0
tangd	1.0.0
targetd	1.0.0
tcpd	1.5.0
tcsd	1.1.1
telepathy	1.4.2
telnet	1.11.3
tftp	1.13.0
tgtd	1.3.1
thin	1.0
thumb	1.0.0
tlp	1.0.0
tmpreaper	1.7.1
tomcat	1.0.0
tor	1.9.0
tuned	1.2.0
tvtime	2.3.0
udev	1.16.2
ulogd	1.3.0
uml	2.3.0
unconfined	3.5.0
unconfineduser	1.0.0
unlabelednet	1.0.0
unprivuser	2.4.0
updfstab	1.6.0
usbmodules	1.3.0
usbmuxd	1.2.0
userdomain	4.9.1
userhelper	1.8.1
usermanage	1.19.0
usernetctl	1.7.0
uucp	1.13.0
uuidd	1.1.0
varnishd	1.2.0
vdagent	1.1.1
vhostmd	1.1.0
virt	1.5.0
vlock	1.2.0
vmtools	1.0.0
vmware	2.7.0
vnstatd	1.1.0
vpn	1.16.0
w3c	1.1.0
watchdog	1.8.0
wdmd	1.1.0
webadm	1.2.0
webalizer	1.13.0
wine	1.11.0
wireshark	2.4.0
xen	1.13.0
xguest	1.2.0
xserver	3.9.4
zabbix	1.6.0
zarafa	1.2.0
zebra	1.13.0
zoneminder	1.0.0
zosremote	1.2.0
[root@selinux ~]# 
[root@selinux ~]# 
[root@selinux ~]# semodule -l | grep nginx
nginx	1.0
[root@selinux ~]#  semodule -r nginx
libsemanage.semanage_direct_remove_key: Removing last nginx module (no other nginx module exists at another priority).
[root@selinux ~]# 
[root@selinux ~]# 
