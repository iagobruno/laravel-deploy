Um projeto de exemplo de como usar queues e o scheduler do Laravel dentro do Docker e de quebra como usar o mesmo Dockerfile em desenvolvimento e em produção.

## How it works

1. O scheduler do Laravel adiciona um novo `ProcessJob` na fila a cada minuto. ([See](/routes/console.php))
2. O comando queue:listen processa a fila de jobs.
3. O `ProcessJob` cria um Log no banco de dados. ([See](/app/Jobs/ProcessJob.php#L36))
4. Quando um Log é criado o Eloquent dispara o evento `LogCreated` via websocket. ([See](/app/Models/Log.php#L33))
5. A página inicial recebe o evento `LogCreated` via websocket e atualiza a página. ([See](/resources/js/app.js#L6))

## Como começar

Rode o comando abaixo para configurar todas as dependências necessárias para o servidor funcionar:

```
bash instal.sh;
```

Configure o Laravel normalmente:

```
composer install
npm install
cp .env.example .env # EDIT THE VARS!
php artisan key:generate
php artisan storage:link
php artisan migrate --force
```

## Rodar localmente

Localmente em ambiente de desenvolvimento, você pode executar o comando abaixo que inicia o `artisan serve`, `artisan queue:listen` e o `vite` simultaneamente:

```
composer run dev
```

## Como fazer deploy

Configure o Laravel em produção com os mesmos comandos usado acima.

Execute os comandos makefile abaixo para iniciar o Nginx e o Supervisor para processamento de filas:

```
make start-nginx
make start-supervisor
```

O comando abaixo executará os comandos necessários para atualizar o servidor sem tempo de inatividade:

```
make deploy
```

> Configure um script que executa esse comando no servidor sempre que vocẽ fizer push de novos commits.

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

> Teste usando `php artisan migrate --force`
