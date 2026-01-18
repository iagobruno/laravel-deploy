#!/bin/bash

set -e;

apt update;

apt install -y \
    mysql-server \
    redis-server \
    sqlite3 \
    unzip \
    curl \
    git \
    make \
    cron \
    nginx \
    supervisor \
    libheif-dev \
    libaom-dev \
    libdav1d-dev \
    imagemagick \
    software-properties-common \
    ca-certificates \
    lsb-release \
    apt-transport-https;

add-apt-repository -y ppa:ondrej/php;
apt update;

# Install PHP extensions
apt install -y php8.4 \
    php8.4-cli \
    php8.4-fpm \
    php8.4-intl \
    php8.4-common \
    php8.4-bcmath \
    php8.4-ctype \
    php8.4-fileinfo \
    php8.4-mbstring \
    php8.4-opcache \
    php8.4-imagick \
    php8.4-sqlite3 \
    php8.4-pdo \
    php8.4-mysql \
    php8.4-pgsql \
    php8.4-redis \
    php8.4-tokenizer \
    php8.4-curl \
    php8.4-xml \
    php8.4-zip;

# Install Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');";
php composer-setup.php;
php -r "unlink('composer-setup.php');";
mv composer.phar /usr/local/bin/composer;

# Install NodeJS
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -;
apt-get install -y nodejs;
npm install -g --force bun yarn pnpm@latest-10 chokidar;

chown -R www-data:www-data storage bootstrap/cache &&\
    chmod -R 775 storage bootstrap/cache;

systemctl enable supervisor && systemctl start supervisor;
systemctl enable php8.4-fpm && systemctl start php8.4-fpm;
systemctl enable nginx && systemctl start nginx;
systemctl enable mysql && systemctl start mysql;
systemctl enable redis-server && systemctl start redis-server;

# mysql --version;
# redis-server --version;
# php -m | grep imagick;
# sqlite3 --version;
# composer --version;
