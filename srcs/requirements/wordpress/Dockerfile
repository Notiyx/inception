FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
	--no-install-recommends apt-utils \
	wget \
	php7.4 \
	php7.4-fpm \
	php7.4-mysql \
    ca-certificates \
	mariadb-client \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

RUN wget https://fr.wordpress.org/wordpress-6.8.1-fr_FR.tar.gz -P /var/www \
	&& cd /var/www \
	&& tar -xzf wordpress-6.8.1-fr_FR.tar.gz \
	&& rm wordpress-6.8.1-fr_FR.tar.gz

COPY ./conf/php.conf /etc/php/7.4/fpm/pool.d/www.conf

RUN chown -R root:root /var/www/wordpress

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

COPY tools/setup.sh setup.sh

ENTRYPOINT [ "bash", "setup.sh" ]