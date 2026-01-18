deploy:
	git pull origin main
	composer install --optimize-autoloader --no-progress --no-interaction
# 	npm install
# 	npm run build
	php artisan migrate --force
	php artisan optimize
	php artisan queue:restart
	systemctl reload nginx php8.4-fpm

start-supervisor:
	cp supervisord.conf /etc/supervisor/conf.d/supervisord.conf
	sed -i "s|/var/www/html|$$(pwd)|g" /etc/supervisor/conf.d/supervisord.conf
	supervisorctl reread
	supervisorctl update

start-nginx:
	cp ./nginx.conf /etc/nginx/sites-available/default
	sed -i "s|/var/www/html/public|$$(pwd)/public|g" /etc/nginx/sites-available/default
	ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
	phpenmod opcache
	nginx -t
	systemctl restart nginx
	systemctl restart php8.4-fpm
