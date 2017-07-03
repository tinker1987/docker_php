################################################################################
# Base image
################################################################################

FROM php:7.1.3-fpm

################################################################################
# Build instructions
################################################################################

RUN apt-get update && apt-get -y install software-properties-common apt-transport-https lsb-release \
    ca-certificates net-tools

# Install packages
RUN apt-get update && apt-get install -my git supervisor curl wget nginx libmcrypt-dev libicu-dev libcurl4-openssl-dev \
  libbz2-dev libgeoip-dev libssl-dev librabbitmq-dev libfreetype6-dev libjpeg62-turbo-dev libmcrypt-dev \
  libpng12-dev

RUN docker-php-ext-install -j$(nproc) mcrypt intl iconv curl bcmath bz2 mysqli pdo pdo_mysql zip
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

RUN apt-get install -y zlib1g zlib1g-dev memcached libmemcached-dev
RUN pecl channel-update pecl.php.net
RUN pecl install redis \
    && pecl install xdebug \
    && pecl install memcached \
    && pecl install geoip-1.1.1 \
    && pecl install mongodb \
    && pecl install amqp \
    && docker-php-ext-enable redis memcached xdebug geoip mongodb amqp

RUN curl -sS https://getcomposer.org/installer | php && mv ./composer.phar /usr/local/bin/composer

# Remove default nginx configs.
RUN rm -f /etc/nginx/conf.d/*
RUN rm -f /etc/nginx/sites-enabled/*
RUN mkdir /root/.ssh/
RUN mkdir /etc/nginx/ssl

# Add configuration files
COPY etc/nginx/nginx.conf /etc/nginx/
COPY etc/supervisord.conf /etc/supervisor/conf.d/
COPY etc/php/php.ini /usr/local/etc/php/conf.d/40-custom.ini

################################################################################
# Volumes
################################################################################

VOLUME ["/var/www", "/etc/nginx/conf.d", "/etc/nginx/sites-enabled"]

################################################################################
# Ports
################################################################################

EXPOSE 80 443 9000 9089

################################################################################
# Entrypoint
################################################################################

ENTRYPOINT ["/usr/bin/supervisord"]
