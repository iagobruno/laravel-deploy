deploy:
	git pull origin main
	composer install --optimize-autoloader --no-progress --no-interaction
# 	npm install
# 	npm run build
	php artisan migrate --force
	php artisan optimize
	php artisan reload
	supervisorctl restart queue_worker scheduler
	make start-nginx

start-supervisor:
	cp supervisord.conf /etc/supervisor/conf.d/supervisord.conf
	supervisorctl reread
	supervisorctl start all

start-nginx:
	cp ./nginx.conf /etc/nginx/sites-available/laravel-server.conf
	ln -s /etc/nginx/sites-available/laravel-server.conf /etc/nginx/sites-enabled/
	nginx -t
	systemctl reload nginx
	systemctl reload php8.4-fpm
