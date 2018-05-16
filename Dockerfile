FROM codecasts/alpine-3.7:php-7.2

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
        php \
        php-apache2 \
        php-curl \
        php-dom \
        php-gd \
        php-gettext \
        php-iconv \
        php-json \
        php-openssl \
        php-pdo \
        php-pdo_mysql \
        php-phar \
        php-session \
        php-simplexml \
        php-sockets \
        php-xml \
        php-xmlreader \
        php-zlib \
        pwgen \
        supervisor \
        tzdata \
        wget

WORKDIR /

ADD root \
    https://github.com/ampache/ampache/archive/${AMPACHE_VER}.tar.gz \
    # ampache-${AMPACHE_VER}.tar.gz \
    /

RUN /scripts/configure.sh

#    80: http
#   443: https (for future setup)
#  9001: supervisord web
# 32400: plex
EXPOSE 80 443 9001 32400

ENTRYPOINT [ "/scripts/entrypoint.sh" ]
