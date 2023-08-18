FROM php:5.6-apache

LABEL version="1.0"
LABEL description="Imagem base para aplicações PHP 5.6 + Apache"
LABEL org.opencontainers.image.authors="joseandro@hotmail.com"

ENV TZ=America/Campo_Grande
ENV ACCEPT_EULA=Y

RUN echo 'date.timezone = America/Campo_Grande' > /usr/local/etc/php/conf.d/tzone.ini
RUN echo 'error_reporting = E_ALL & ~E_DEPRECATED & ~E_NOTICE & ~E_WARNING' > /usr/local/etc/php/conf.d/php-errors.ini
RUN sed -i 's/%h/%h %{X-Forwarded-For}i/g' /etc/apache2/apache2.conf

RUN sed -i -e 's/deb.debian.org/archive.debian.org/g' \
           -e 's|security.debian.org|archive.debian.org/|g' \
           -e '/stretch-updates/d' /etc/apt/sources.list

RUN apt-get update && \
    apt-get install -y unzip curl nano iputils-ping gnupg2 apt-transport-https libpng-dev zlib1g-dev libmagickwand-dev && \
    rm -rf /var/lib/apt/lists/*

RUN pecl install imagick
RUN docker-php-ext-configure gd --with-freetype-dir=/usr --with-jpeg-dir=/usr
RUN docker-php-ext-install pdo_mysql mysqli gd mbstring zip calendar exif gettext
RUN docker-php-ext-enable imagick

WORKDIR /var/www/html
RUN chown www-data:www-data /var/www/html

EXPOSE 80