## Como começar

Rode o comando abaixo para configurar todas as dependências necessárias para o servidor funcionar:

```
bash instal.sh;
```

Configure o Laravel normalmente:

```
composer install
cp .env.example .env # EDIT THE VARS!
php artisan key:generate
php artisan storage:link
php artisan migrate --force
```

Rode os comandos abaixo para iniciar o Nginx e o Supervisor para inicar o processamento de filas:

```
make start-nginx
make start-supervisor
```

```
make deploy
```

## Banco de dados

O script `install.sh` instala automaticamente o MySQL e o Redis no ambiente.

Para utilizar no Laravel, crie um banco de dados e um usuário mysql:

```
mysql -u root -p;

CREATE DATABASE `laravel-app`;

CREATE USER 'laravel-user'@'localhost' IDENTIFIED BY 'STRONG_PASSWORD';

GRANT
  SELECT, INSERT, UPDATE, DELETE,
  CREATE, ALTER, DROP, INDEX, REFERENCES
ON `laravel-app`.*
TO 'laravel-user'@'localhost';

FLUSH PRIVILEGES;
```

Configure o arquivo `.env` do laravel:

```
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=laravel-app
DB_USERNAME=laravel-user
DB_PASSWORD=STRONG_PASSWORD
```
