�������� ������� �� NFS
-----------------------------------------
� ������ ����������� ���������� Vagrant ����� �� 2� VM, ���� �� ������� - ������ NFS � ������ - ������ NFS.
�� ������� �������������� ���������� /srv/share/ � ��������� �������������� upload � ������� �� ������ � ���.

�� �������  ������������ � ������ NFS ������������ � �������������� NFSv3 �� ��������� UDP

������, ��������� NFS, firewall � ������� ���������� �� ������� ������� ����������� � �������������� ������� nfss_script.sh

������, ��������� NFS, firewall, ��������������� ������������ ���������������� ���������� �� ������� ������� ����������� � �������������� ������� nfs�_script.sh


**����:**
- VirtualBox 7.0.12, 
- Vagrant 2.4.1, 
- Vagrant Box centos/7 v2004.01
- �������� �������: Ubuntu 22.04

*������ ������:*

   ```
vagrant up
vagrant ssh nfs� #For connection to nfs server VM
vagrant ssh nfs� #For connection to nfs client VM
   ```
   
   
   
   - [����� vagrant � �������� ������ �������� �������](https://github.com/egorvshch/linux_pro_admin_course/blob/main/homework05/command%20execution%20logs/start%20vagrant.txt)