#!/bin/bash

while ! mysqladmin ping -h"mariadb" --silent; do
	echo "MariaDB not ready yet, waiting..."
	sleep 2
done
echo "MariaDB is ready!"

if [ -f /run/secrets/db_password ]; then
	DB_PASSWORD=$(cat /run/secrets/db_password)
else
	echo "Error: db_password secret not found"
	exit 1
fi

if [ -f /run/secrets/admin_pass ]; then
	ADMIN_PASS=$(cat /run/secrets/admin_pass)
else
	echo "Error: admin_pass secret not found"
	exit 1
fi

if [ -f /run/secrets/user_pass ]; then
	USER_PASS=$(cat /run/secrets/user_pass)
else
	echo "Error: user_pass secret not found"
	exit 1
fi


if [ ! -e /var/www/wordpress/wp-config.php ]; then

	wp config create \
		--allow-root \
		--dbname="$DB_DATABASE" \
		--dbuser="$DB_USER" \
		--dbpass="$DB_PASSWORD" \
		--dbhost="mariadb:3306" \
		--path='/var/www/wordpress'
	
	sleep 1

	wp core install \
		--url="$DOMAIN_NAME" \
		--title="$SITE_TITLE" \
		--admin_user="$ADMIN_LOGIN" \
		--admin_password="$ADMIN_PASS" \
		--admin_email="$ADMIN_EMAIL" \
		--allow-root \
		--path='/var/www/wordpress'

	wp theme install https://downloads.wordpress.org/theme/astra.4.11.5.zip --activate --allow-root --path='/var/www/wordpress'
	
	wp theme delete twentytwentyfour twentytwentythree --allow-root --path='/var/www/wordpress'

	wp user create \
		--allow-root \
		--role=author "$USER_LOGIN" "$USER_EMAIL" \
		--user_pass="$USER_PASS" \
		--path='/var/www/wordpress'
fi

sed -i '/WP_HOME/d' /var/www/wordpress/wp-config.php
sed -i '/WP_SITEURL/d' /var/www/wordpress/wp-config.php
cat >> /var/www/wordpress/wp-config.php << 'EOF'
if (isset($_SERVER['HTTP_HOST'])) {
	$protocol = isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? 'https' : 'http';
	define('WP_HOME', $protocol . '://' . $_SERVER['HTTP_HOST']);
	define('WP_SITEURL', $protocol . '://' . $_SERVER['HTTP_HOST']);
}
EOF

if [ ! -d /run/php ]; then
	mkdir -p /run/php
fi
/usr/sbin/php-fpm7.4 -F
