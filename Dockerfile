FROM alpine:3.7

MAINTAINER Sacha Korban https://github.com/sachk
label version="3.0.0" \
      description="Ampache docker image built from Alpine Linux 3.7 with PHP 7"

# Apache
ENV APACHE_WEB_ROOT=/var/www/localhost \
    APACHE_PID_FILE=/run/apache2/httpd.pid \
    APACHE_USER=apache \
    APACHE_GROUP=www-data

# Ampache
ENV AMPACHE_VER=master \
    AMPACHE_WEB_DIR=${APACHE_WEB_ROOT}/ampache

# MySQL
ENV MYSQL_DATA_DIR=/var/lib/mysql \
    MYSQL_SOCKET=/var/run/mysqld/mysqld.sock \
    MYSQL_PID_FILE=/var/run/mysqld/mysqld.pid \
    MYSQL_PORT=3306 \
    MYSQL_USER=mysql
# add new php repo
ADD https://php.codecasts.rocks/php-alpine.rsa.pub /etc/apk/keys/php-alpine.rsa.pub
RUN apk --update add ca-certificates
RUN echo "@php https://php.codecasts.rocks/v3.7/php-7.2" >> /etc/apk/repositories

RUN apk --no-cache update && \
    apk add --no-cache \
        apache2 \
        apache2-utils \
        apache2-webdav \
        ffmpeg \
        file \
        git \
        mysql \
        mysql-client \
        php-common@php \
        php-apache2@php \
        php-curl@php \
        php-dom@php \
        php-gd@php \
        php-gettext@php \
        php-iconv@php \
        php-json@php \
        php-openssl@php \
        php-pdo@php \
        php-pdo_mysql@php \
        php-phar@php \
        php-session@php \
        php-sockets@php \
        php-xml@php \
        php-xmlreader@php \
        php-zlib@php \
        pwgen \
        supervisor \
        tzdata \
        wget && \
        wget -O /${AMPACHE_VER}.zip https://github.com/ampache/ampache/archive/${AMPACHE_VER}.zip && \
        ln /usr/bin/php7 /usr/bin/php

WORKDIR /

ADD root /

RUN /scripts/configure.sh

#    80: http
#   443: https (for future setup)
#  9001: supervisord web
# 32400: plex
EXPOSE 80 443 9001 32400

ENTRYPOINT [ "/scripts/entrypoint.sh" ]
