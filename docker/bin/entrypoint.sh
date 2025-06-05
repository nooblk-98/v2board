#!/bin/sh
set -e  # Exit on any error

# php storage link create
php artisan storage:link || true

# Starting PM2 queue worker...
pm2 start /var/www/html/docker/schedulers/scheduler.config.js
pm2 save
pm2 startup


echo " "
echo "============================================================================="
echo " "

# Run Laravel install command (fail loudly if it breaks)
php artisan v2board:install

echo " "
echo " "
echo " "
echo "============================================================================="
echo " "

# Fix permissions (only Laravel's writable dirs, not everything)
chown -R www-data:www-data *

# Start Apache in the foreground
exec apache2-foreground
