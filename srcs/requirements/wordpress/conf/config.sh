#!/bin/bash
# Attente que MariaDB soit disponible
until mysql -h mariadb -u "$SQL_USER" -p"$SQL_PASSWORD" -e 'show databases;' > /dev/null 2>&1; do
  echo "En attente de MariaDB..."
  sleep 2
done

# Une fois MariaDB disponible, on crée le fichier de configuration de WordPress
wp config create --allow-root \
  --dbname=$SQL_DATABASE \
  --dbuser=$SQL_USER \
  --dbpass=$SQL_PASSWORD \
  --dbhost=mariadb:3306 \
  --path='/var/www/wordpress'

# Installation du site WordPress
wp core install --allow-root \
  --url="http://tlonghin.42.fr" \
  --title="Mon Site WordPress" \
  --admin_user=$WP_ADMIN_USER \
  --admin_password=$WP_ADMIN_PASSWORD \
  --admin_email=$WP_ADMIN_EMAIL \
  --path='/var/www/wordpress'
