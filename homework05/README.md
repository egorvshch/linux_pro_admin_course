

ДЗ по теме "Файловые системы и LVM-1
-----------------------------------------
**Стек:**
- VirtualBox 7.0.12, 
- Vagrant 2.4.1, 
- Vagrant Box centos/7 v1804.02
- хостовая система: Ubuntu 22.04

**Лог выполнения заданий ниже:**
- [Старт vagrant и исходный статус файловой системы](https://github.com/egorvshch/linux_pro_admin_course/blob/main/homework05/command%20execution%20logs/start%20vagrant.txt)
- [Уменьшить том под / до 8G.](https://github.com/egorvshch/linux_pro_admin_course/blob/main/homework05/command%20execution%20logs/change_size_root_directory.txt)
- [Выделить том под /var - сделать в mirror.](https://github.com/egorvshch/linux_pro_admin_course/blob/main/homework05/command%20execution%20logs/crate_lvm_vl_for_var_from_2_sdc_sdd.txt)
- [Выделить том под /home.](https://github.com/egorvshch/linux_pro_admin_course/blob/main/homework05/command%20execution%20logs/create_lv_for_home_catalog.txt)
- [/home - сделать том для снапшотов и работа со снапшотами](https://github.com/egorvshch/linux_pro_admin_course/blob/main/homework05/command%20execution%20logs/create_snapshot_and_restore_of_data_from_snap.txt)
- [удаление временной VolumeGroup](https://github.com/egorvshch/linux_pro_admin_course/blob/main/homework05/command%20execution%20logs/remove_temp_vg_root.txt)

**Работа со снапшотами включает:**
- сгенерить файлы в /home/;
- снять снапшот;
- удалить часть файлов;
- восстановится со снапшота.
