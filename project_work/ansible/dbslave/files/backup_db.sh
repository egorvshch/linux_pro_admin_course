# Creating new dump of -wpress_db- database with necessary tables
mysqldump --all-databases --add-drop-table --create-options --disable-keys \
                   --extended-insert --single-transaction --quick --events --routines \
                   --set-gtid-purged=OFF --triggers --source-data=0 --skip-lock-tables \
                   --flush-privileges \
                   -u root -ppass123 > /home/vagrant/db_backup/db.sql
