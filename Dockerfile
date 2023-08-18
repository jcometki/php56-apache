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
    apt-get install -y apt-transport-https gnupg2 libpng-dev libzip-dev unzip && \
    rm -rf /var/lib/apt/lists/*

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/install-php-extensions
RUN chmod uga+x /usr/bin/install-php-extensions && \
    sync && \
    install-php-extensions bcmath exif gd imagick intl pcntl zip pdo_mysql mysqli

WORKDIR /var/www/html
RUN chown www-data:www-data /var/www/html

EXPOSE 80