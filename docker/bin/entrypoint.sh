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

# # Fix permissions (only Laravel's writable dirs, not everything)
# chown -R www-data:www-data *

# Start PHP-FPM
echo "Starting PHP-FPM..."
php-fpm -D

# Start Nginx in foreground
echo "Starting Nginx..."
exec nginx -g "daemon off;"

