#!/bin/sh
set -e  # Exit on any error

# php storage link create
php artisan storage:link || true

echo " Installing Configurations please wait ! "

sleep 10

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

chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html/storage /var/www/html/bootstrap/cache

# Start supervisor services (ginx, php-fpm)
exec supervisord -c /etc/supervisord.conf




