/etc/init.d/mysql start
mysql -uroot -proot -e "DROP DATABASE IF EXISTS isubata; CREATE DATABASE isubata;"
mysql -uroot -proot isubata < ./db/isubata.sql
mysql -uroot -proot -e "CREATE USER isucon@'%' IDENTIFIED BY 'isucon';GRANT ALL on *.* TO isucon@'%';CREATE USER isucon@'localhost' IDENTIFIED BY 'isucon';GRANT ALL on *.* TO isucon@'localhost';"
zcat ~/isubata/bench/isucon7q-initial-dataset.sql.gz | mysql -uroot -proot isubata
/etc/init.d/nginx start
cd webapp/go
make
export ISUBATA_DB_HOST=127.0.0.1
export ISUBATA_DB_USER=isucon
export ISUBATA_DB_PASSWORD=isucon
./isubata &
cd ../../bench
./bin/bench -remotes=127.0.0.1 -output result.json
bash