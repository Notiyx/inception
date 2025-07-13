FROM debian:bullseye

RUN apt-get update -y && apt-get upgrade -y && apt-get install -y \
	--no-install-recommends apt-utils \
	mariadb-server \
	mariadb-client \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/mysqld \
	&& chown mysql:mysql /run/mysqld

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

COPY tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

EXPOSE 3306

ENTRYPOINT [ "bash", "setup.sh" ]
