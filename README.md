## Como começar

```bash
git clone
bash instal.sh;
composer install
cp .env.example .env # EDIT THE VARS!
php artisan key:generate
php artisan migrate --force
```

```bash
make start-supervisor
make start-nginx
```

```bash
make deploy
```
