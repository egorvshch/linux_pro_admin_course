This files create VM with nginx Web Server with http port 8080 and default web page "Welcom to nginx!".

VM configuration do by usign vagrant. Nginx configuration do by using Ansible
Order of server instalation:
  - starting VM with "vagrant up"
  - configuration of server do with "ansible-playbook nginx.yml"
