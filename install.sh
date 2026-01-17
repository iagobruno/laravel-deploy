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
    supervisor \
    libheif-dev \
    libaom-dev \
    libdav1d-dev \
    imagemagick;

apt install -y software-properties-common ca-certificates lsb-release apt-transport-https;
add-apt-repository -y ppa:ondrej/php;
apt update;

# Install PHP extensions
apt install -y php8.4 \
    php8.4-{cli,intl,bcmath,ctype,fileinfo,mbstring,opcache,sqlite3,imagick,pdo,pgsql,redis,tokenizer,curl,xml,zip};

# Install FrankenPHP
curl https://frankenphp.dev/install.sh | sh

# Install Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');";
php composer-setup.php;
php -r "unlink('composer-setup.php');";
mv composer.phar /usr/local/bin/composer;

# Install NodeJS
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -;
apt-get install -y nodejs;
npm install -g --force yarn pnpm@latest-10 bun chokidar;

systemctl enable supervisor && systemctl start supervisor;
systemctl enable mysql && systemctl start mysql;
systemctl enable redis-server && systemctl start redis-server;

# mysql --version;
# redis-server --version;
# php -m | grep imagick;
# sqlite3 --version;
# composer --version;
