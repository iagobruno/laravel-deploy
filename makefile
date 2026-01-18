deploy:
	git pull origin main
	composer install --optimize-autoloader --no-progress --no-interaction
# 	npm install
# 	npm run build
	php artisan migrate --force
	php artisan optimize
	php artisan reload
	make start-supervisor
	make start-nginx

start-supervisor:
	cp supervisord.conf /etc/supervisor/conf.d/supervisord.conf
	sed -i "s|/var/www/html|$$(pwd)|g" /etc/supervisor/conf.d/supervisord.conf
	supervisorctl reread
	supervisorctl update

start-nginx:
	cp ./nginx.conf /etc/nginx/sites-available/default.conf
	sed -i "s|/var/www/html/public|$$(pwd)/public|g" /etc/nginx/sites-available/default.conf
	ln -sf /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/
	nginx -t
	systemctl reload nginx
	systemctl reload php8.4-fpm
