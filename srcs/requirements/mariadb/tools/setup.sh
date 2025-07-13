#!/bin/bash

if [ -f /run/secrets/db_password ]; then
	DB_PASSWORD=$(cat /run/secrets/db_password)
else
	echo "Error: db_password secret not found"
	exit 1
fi

if [ -f /run/secrets/db_root_password ]; then
	DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
else
	echo "Error: db_root_password secret not found"
	exit 1
fi

mkdir -p /run/mysqld
chown mysql:mysql /run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then
	myDB_install_db --user=mysql --datadir=/var/lib/mysql
fi

mysqld_safe --user=mysql --datadir=/var/lib/mysql &

while ! mysqladmin ping --silent; do
	echo "Waiting for MySQL to start..."
	sleep 2
done

mysql -e "CREATE DATABASE IF NOT EXISTS \`${DB_DATABASE}\`;"


mysql -e "CREATE USER IF NOT EXISTS \`${DB_USER}\`@'%' IDENTIFIED BY '${DB_PASSWORD}';"

mysql -e "GRANT ALL PRIVILEGES ON \`${DB_DATABASE}\`.* TO \`${DB_USER}\`@'%' IDENTIFIED BY '${DB_PASSWORD}';"


mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';"

mysql -e "FLUSH PRIVILEGES;"


mysqladmin -u root -p"$DB_ROOT_PASSWORD" shutdown


exec mysqld_safe --user=mysql --datadir=/var/lib/mysql
