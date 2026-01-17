#!/bin/bash

set -e;

sudo apt update;

sudo apt install -y \
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

# Install php extensions
sudo apt install -y php8.4 \
    php8.4-{cli,intl,bcmath,ctype,fileinfo,mbstring,openssl,opcache,pcntl,sqlite3,imagick,pdo,pgsql,redis,tokenizer,curl,json,xml,zip};

# Install FrankenPHP
curl https://frankenphp.dev/install.sh | sh

# Install Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');";
php composer-setup.php;
php -r "unlink('composer-setup.php');";
sudo mv composer.phar /usr/local/bin/composer;

# Install NodeJS
curl -fsSL https://deb.nodesource.com/setup_20.x | bash -;
apt-get install -y nodejs;
npm install -g --force yarn pnpm@latest-10 bun chokidar;


sudo systemctl enable mysql && sudo systemctl start mysql;

sudo systemctl enable redis-server && sudo systemctl start redis-server;

# mysql --version;
# redis-server --version;
# php -m | grep imagick;
# sqlite3 --version;
# composer --version;
