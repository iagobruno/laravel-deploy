deploy:
	git pull origin main
	composer install --optimize-autoloader --no-progress --no-interaction
	npm install
	npm run build
	php artisan migrate --force
	php artisan queue:restart
	supervisorctl restart scheduler
	php artisan octane:reload

start-supervisor:
	cp supervisord.conf /etc/supervisor/conf.d/supervisord.conf
	supervisorctl reread
	supervisorctl start all
