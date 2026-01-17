deploy:
	git pull origin main
	composer install --optimize-autoloader --no-progress --no-interaction
	npm install
	npm run build
	php artisan migrate --force
	php artisan queue:restart
	sudo supervisorctl restart scheduler
	php artisan octane:reload

start-supervisor:
	sudo cp supervisord.conf /etc/supervisor/conf.d/supervisord.conf
	sudo supervisorctl reread
	sudo supervisorctl start all
