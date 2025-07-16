#!/bin/bash

while ! mysqladmin ping -h"mariadb" --silent; do
	sleep 2
done

DB_PASSWORD=$(cat /run/secrets/db_password)
ADMIN_PASS=$(cat /run/secrets/admin_pass)
USER_PASS=$(cat /run/secrets/user_pass)

if [ ! -e /var/www/wordpress/wp-config.php ]; then

    wp config create --allow-root --dbname="$DB_DATABASE" --dbuser="$DB_USER" --dbpass="$DB_PASSWORD" --dbhost="mariadb:3306" --path='/var/www/wordpress'
    
    sleep 1

    wp core install  --url="https://tlonghin.42.fr"  --title="SUPER WORDPRESS"  --admin_user="thetlonghin"  --admin_email="tlonghin@student.42.fr" --admin_password="$ADMIN_PASS" --allow-root --path='/var/www/wordpress'

    wp theme install https://downloads.wordpress.org/theme/astra.4.11.5.zip --activate --allow-root --path='/var/www/wordpress'
    
    wp theme delete twentytwentyfour twentytwentythree --allow-root --path='/var/www/wordpress'

    wp user create --allow-root --role=author "special" "special@student.42.fr" --user_pass="$USER_PASS" --path='/var/www/wordpress'
fi


if [ ! -d /run/php ]; then
    mkdir -p /run/php
fi

exec /usr/sbin/php-fpm7.4 -F
