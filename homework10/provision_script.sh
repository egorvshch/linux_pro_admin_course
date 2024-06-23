#!/bin/bash

#
echo "--------------------------------"
echo ">>> Prepare watchlog service config"
echo "--------------------------------"
#
cp /tmp/watchlog_files/watchlog /etc/default/watchlog
cp /tmp/watchlog_files/watchlog.log /var/log/watchlog.log
cp /tmp/watchlog_files/watchlog.sh /opt/watchlog.sh

# copy service files 
cp /tmp/watchlog_files/watchlog.service /etc/systemd/system/watchlog.service
cp /tmp/watchlog_files/watchlog.timer /etc/systemd/system/watchlog.timer

# make script executable
chmod +x /opt/watchlog.sh
#
echo "--------------------------------"
echo ">>> start and check watchlog"
echo "--------------------------------"

#watchlog service
systemctl start watchlog.timer
systemctl start watchlog
systemctl status watchlog.timer

#
echo "--------------------------------"
echo ">>> apt update"
echo "--------------------------------"
#
apt update

echo "--------------------------------"
echo ">>> inastall spawn-fcgi"
echo "--------------------------------"
#
apt install -y spawn-fcgi php php-cgi php-cli apache2 libapache2-mod-fcgid
#Configuration of spawn-fcgi 
mkdir /etc/spawn-fcgi

# copy .conf and .service files 
cp /tmp/spawn-fcgi_files/fcgi.conf /etc/spawn-fcgi/fcgi.conf
cp /tmp/spawn-fcgi_files/spawn-fcgi.service /etc/systemd/system/spawn-fcgi.service
#
echo "--------------------------------"
echo ">>> start and check spawn-fcgi"
echo "--------------------------------"
#
systemctl start spawn-fcgi
systemctl status spawn-fcgi
#
echo "--------------------------------"
echo ">>> inastall nginx"
echo "--------------------------------"
#
apt install -y nginx
#
# copy service files 
cp /tmp/nginx_files/nginx@.service /etc/systemd/system/nginx@.service
cp /tmp/nginx_files/nginx-first.conf /etc/nginx/nginx-first.conf
cp /tmp/nginx_files/nginx-second.conf /etc/nginx/nginx-second.conf
echo "--------------------------------"
echo ">>> start and check nginx"
echo "--------------------------------"
#nginx
systemctl start nginx@first
systemctl start nginx@second
#
systemctl status nginx@first
systemctl status nginx@second
#
ss -tnulp | grep nginx
ps afx | grep nginx

echo "--------------------------------"
echo ">>> Prepare configuration of services  is success "
echo "--------------------------------"
