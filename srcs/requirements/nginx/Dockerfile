FROM debian:bullseye

RUN apt update && \
    apt install -y nginx openssl && \
    rm -rf /var/lib/apt/lists/*

RUN  mkdir -p /etc/nginx/ssl && openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/CN=tlonghin.42.fr" && \
     mkdir -p /var/run/nginx


COPY ./conf/nginx.conf /etc/nginx/nginx.conf

RUN chown -R www-data:www-data /var/www/html
RUN chmod 755 /var/www/html

EXPOSE 443

CMD [ "nginx", "-g", "daemon off;" ]