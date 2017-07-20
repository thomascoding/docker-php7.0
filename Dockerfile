FROM php:7.0-apache
MAINTAINER thomas.coding@gmail.com v0.1.1

ENV   APACHE_RUN_USER=www-data \
      APACHE_RUN_GROUP=www-data \
      APACHE_LOG_DIR=/var/log/apache2 \
      APACHE_LOCK_DIR=/var/lock/apache2 \
      APACHE_RUN_DIR=/var/run/apache2 \
      APACHE_PID_FILE=/var/run/apache2.pid 

RUN apt-get update && apt-get install -y \
    libpng12-dev \
    libjpeg62-turbo-dev

RUN docker-php-ext-install gd
RUN docker-php-ext-install zip
RUN docker-php-ext-install pdo pdo_mysql 

# xdebug
RUN pecl install xdebug-2.5.5
ENV XDEBUG_INI=/usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.idekey = PHPSTORM" >> ${XDEBUG_INI} && \
echo "xdebug.default_enable = 0" >>   ${XDEBUG_INI} && \
echo "xdebug.remote_enable = 1" >>   ${XDEBUG_INI} && \
echo "xdebug.remote_autostart = 0" >>   ${XDEBUG_INI} && \
echo "xdebug.remote_connect_back = 0" >> ${XDEBUG_INI} && \
echo "xdebug.profiler_enable = 0" >>   ${XDEBUG_INI}
RUN docker-php-ext-enable xdebug

# mod_rewrite
RUN a2enmod rewrite

ADD ./vhosts/000-default.conf /etc/apache2/sites-enabled/000-default.conf
COPY ./boot.sh /scripts/boot.sh
RUN chmod +x /scripts/*
CMD ["/scripts/boot.sh"]
