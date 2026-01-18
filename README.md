## Como começar

Rode o comando abaixo para configurar todas as dependências necessárias para o servidor funcionar:

```bash
bash instal.sh;
```

Configure o Laravel normalmente:

```bash
composer install
cp .env.example .env # EDIT THE VARS!
php artisan key:generate
php artisan storage:link
php artisan migrate --force
```

Rode os comandos abaixo para iniciar o Nginx e o Supervisor para inicar o processamento de filas:

```bash
make start-nginx
make start-supervisor
```

```bash
make deploy
```
