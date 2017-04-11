################################################################################
# Base image
################################################################################

FROM php:7.1.3-fpm

################################################################################
# Build instructions
################################################################################

RUN apt-get update && apt-get -y install software-properties-common apt-transport-https lsb-release \
    ca-certificates net-tools
#
#RUN wget -O /etc/apt/trusted.gpg.d/php.gpg \
#    https://packages.sury.org/php/apt.gpg

#RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list

# Install packages
RUN apt-get update && apt-get install -my supervisor curl wget nginx libmcrypt-dev libicu-dev libcurl4-openssl-dev \
  libbz2-dev libgeoip-dev libssl-dev

RUN docker-php-ext-install -j$(nproc) mcrypt intl curl bcmath bz2

RUN apt-get install -y zlib1g zlib1g-dev memcached libmemcached-dev
RUN pecl channel-update pecl.php.net
RUN pecl install redis \
    && pecl install xdebug \
    && pecl install memcached \
    && pecl install geoip-1.1.1 \
    && pecl install mongodb \
    && docker-php-ext-enable redis memcached xdebug geoip mongodb

RUN curl -sS https://getcomposer.org/installer | php && mv ./composer.phar /usr/local/bin/composer

# Remove default nginx configs.
RUN rm -f /etc/nginx/conf.d/*
RUN rm -f /etc/nginx/sites-enabled/*

# Add configuration files
COPY etc/nginx/nginx.conf /etc/nginx/
COPY etc/supervisord.conf /etc/supervisor/conf.d/
COPY etc/php/php.ini /etc/php/7.1/fpm/conf.d/40-custom.ini

################################################################################
# Volumes
################################################################################

VOLUME ["/var/www", "/etc/nginx/conf.d", "/etc/nginx/sites-enabled"]

################################################################################
# Ports
################################################################################

EXPOSE 80 443 9000

################################################################################
# Entrypoint
################################################################################

ENTRYPOINT ["/usr/bin/supervisord"]
