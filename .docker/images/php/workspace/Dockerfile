ARG PHP_VERSION
ARG PHP_VERSION_TAG
FROM php:${PHP_VERSION}-${PHP_VERSION_TAG}

LABEL maintainer="Michel Vieira <michelvieira@outlook.com>"
ARG DEBIAN_FRONTEND=noninteractive

###########################################################################
# APT GET INIT
###########################################################################
RUN apt-get update \
    && apt-get install -y --no-install-recommends php-dev php-pear

RUN apt-get update && apt-get install -y --no-install-recommends \
    autoconf build-essential apt-utils zlib1g-dev libzip-dev unzip zip libpq-dev

###########################################################################
# ZIP:
###########################################################################
RUN docker-php-ext-configure zip \
    && docker-php-ext-install zip \
    && php -m | grep -q 'zip'

###########################################################################
# OCI8:
###########################################################################
ARG PHP_EXTENSION_OCI8=false

ENV LD_LIBRARY_PATH="/opt/oracle/instantclient_12_1"
ENV OCI_HOME="/opt/oracle/instantclient_12_1"
ENV OCI_LIB_DIR="/opt/oracle/instantclient_12_1"
ENV OCI_INCLUDE_DIR="/opt/oracle/instantclient_12_1/sdk/include"
ENV OCI_VERSION=12

RUN if [ ${PHP_EXTENSION_OCI8} = true ]; then \
    # Install wget
    apt-get update && apt-get install --no-install-recommends -y wget \
    # Install Oracle Instantclient
    && mkdir /opt/oracle \
        && cd /opt/oracle \
        && wget https://github.com/diogomascarenha/oracle-instantclient/raw/master/instantclient-basic-linux.x64-12.1.0.2.0.zip \
        && wget https://github.com/diogomascarenha/oracle-instantclient/raw/master/instantclient-sdk-linux.x64-12.1.0.2.0.zip \
        && unzip /opt/oracle/instantclient-basic-linux.x64-12.1.0.2.0.zip -d /opt/oracle \
        && unzip /opt/oracle/instantclient-sdk-linux.x64-12.1.0.2.0.zip -d /opt/oracle \
        && ln -s /opt/oracle/instantclient_12_1/libclntsh.so.12.1 /opt/oracle/instantclient_12_1/libclntsh.so \
        && ln -s /opt/oracle/instantclient_12_1/libclntshcore.so.12.1 /opt/oracle/instantclient_12_1/libclntshcore.so \
        && ln -s /opt/oracle/instantclient_12_1/libocci.so.12.1 /opt/oracle/instantclient_12_1/libocci.so \
        && rm -rf /opt/oracle/*.zip \
    # Install PHP extensions deps
    && apt-get update \
        && apt-get install --no-install-recommends -y \
            libaio-dev \
            freetds-dev && \
    # Install PHP extensions
    if [ $(php -r "echo PHP_MAJOR_VERSION;") = "5" ]; then \
      echo 'instantclient,/opt/oracle/instantclient_12_1/' | pecl install oci8-2.0.10; \
    else \
      echo 'instantclient,/opt/oracle/instantclient_12_1/' | pecl install oci8; \
    fi \
        && docker-php-ext-configure pdo_oci --with-pdo-oci=instantclient,/opt/oracle/instantclient_12_1,12.1 \
        && docker-php-ext-configure pdo_dblib --with-libdir=/lib/x86_64-linux-gnu \
        && docker-php-ext-install \
                pdo_oci \
        && docker-php-ext-enable \
                oci8 \
;fi

###########################################################################
# SQL SERVER:
###########################################################################



###########################################################################
# GETTEXT:
###########################################################################
ARG PHP_EXTENSION_GETTEXT=false

RUN if [ ${PHP_EXTENSION_GETTEXT} = true ]; then \
    apt-get install -y zlib1g-dev libicu-dev g++ libpq-dev libssl-dev gettext \
    && docker-php-ext-install gettext \
;fi

###########################################################################
# GHOSTSCRIPT:
###########################################################################
ARG PHP_EXTENSION_GHOSTSCRIPT=false

RUN if [ ${PHP_EXTENSION_GHOSTSCRIPT} = true ]; then \
    apt-get install -y poppler-utils ghostscript \
;fi

###########################################################################
# IMAGE OPTIMIZERS:
###########################################################################
ARG PHP_EXTENSION_IMAGEOPTIMIZERS=false

RUN if [ ${PHP_EXTENSION_IMAGEOPTIMIZERS} = true ]; then \
    apt-get install -y jpegoptim optipng pngquant gifsicle \
;fi

###########################################################################
# IMAGICK:
###########################################################################
ARG PHP_EXTENSION_IMAGICK=false

RUN if [ ${PHP_EXTENSION_IMAGICK} = true ]; then \
    apt-get install -y libmagickwand-dev libmagick++-dev \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
;fi

###########################################################################
# APCU:
###########################################################################
ARG PHP_EXTENSION_APCU=false

RUN if [ ${PHP_EXTENSION_APCU} = true ]; then \
    pecl install apcu \
    && docker-php-ext-enable apcu \
;fi

###########################################################################
# GRPC:
###########################################################################
ARG PHP_EXTENSION_GRPC=false

RUN if [ ${PHP_EXTENSION_GRPC} = true ]; then \
    pecl install grpc \
    && docker-php-ext-enable grpc \
;fi

###########################################################################
# CACHE TOOL:
###########################################################################
ARG PHP_EXTENSION_CACHETOOL=false

RUN if [ ${PHP_EXTENSION_CACHETOOL} = true ]; then \
    curl -sO http://gordalina.github.io/cachetool/downloads/cachetool.phar \
    && chmod +x cachetool.phar \
    && mv cachetool.phar /usr/local/bin/cachetool \
;fi

###########################################################################
# OPCACHE:
###########################################################################
ARG PHP_EXTENSION_OPCACHE=false

RUN if [ ${PHP_EXTENSION_OPCACHE} = true ]; then \
    docker-php-ext-install opcache \
;fi
COPY opcache.ini /usr/local/etc/php/conf.d/opcache.ini

###########################################################################
# BCMATH:
###########################################################################
ARG PHP_EXTENSION_BCMATH=false

RUN if [ ${PHP_EXTENSION_BCMATH} = true ]; then \
    docker-php-ext-install bcmath \
;fi

###########################################################################
# SWOOLE EXTENSION
###########################################################################
ARG PHP_EXTENSION_SWOOLE=false

RUN if [ ${PHP_EXTENSION_SWOOLE} = true ]; then \
    pecl install swoole \
    && docker-php-ext-enable swoole \
    && php -m | grep -q 'swoole' \
;fi

###########################################################################
# REDIS:
###########################################################################
ARG PHP_EXTENSION_REDIS=false

RUN if [ ${PHP_EXTENSION_REDIS} = true ]; then \
    pecl install -o -f redis \
    && docker-php-ext-enable redis \
    && rm -rf /tmp/pear \
;fi

###########################################################################
# COMPOSER:
###########################################################################
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/bin/composer

###########################################################################
# PYTHON2:
###########################################################################
ARG WORKSPACE_INSTALL_PYTHON=false

RUN if [ ${WORKSPACE_INSTALL_PYTHON} = true ]; then \
  apt-get -y install python python-dev build-essential  \
  && curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py  \
  && python get-pip.py  \
  && rm get-pip.py  \
  && python -m pip install --upgrade pip  \
  && python -m pip install --upgrade virtualenv \
;fi

###########################################################################
# SUPERVISOR:
###########################################################################
ARG PHP_INSTALL_SUPERVISOR=false

RUN if [ ${WORKSPACE_INSTALL_SUPERVISOR} = true ]; then \
    if [ ${WORKSPACE_INSTALL_PYTHON} = true ]; then \
    python -m pip install --upgrade supervisor && \
    echo_supervisord_conf > /etc/supervisord.conf && \
    sed -i 's/\;\[include\]/\[include\]/g' /etc/supervisord.conf && \
    sed -i 's/\;files\s.*/files = supervisord.d\/*.conf/g' /etc/supervisord.conf \
  ;fi \
;fi
COPY supervisord.conf /etc/supervisord.conf

###########################################################################
# DEFAULT PHP EXT:
###########################################################################
RUN docker-php-ext-install pdo_mysql mysqli


###########################################################################
# COPY FILES
###########################################################################
COPY laravel.ini /usr/local/etc/php/conf.d
COPY xlaravel.pool.conf /usr/local/etc/php-fpm.d/

USER root

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm /var/log/lastlog /var/log/faillog

WORKDIR /var/www

CMD ["php-fpm"]

EXPOSE 9000
