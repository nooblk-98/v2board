#!/bin/sh
set -e  # Exit on any error

# php storage link create
php artisan storage:link || true

if [ ! -f /var/www/html/.env ]; then
    echo " Installing Configurations please wait ! "
    sleep 10
    echo " "
    echo "============================================================================="
    echo " "

    php artisan v2board:install

    echo " "
    echo " "
    echo "============================================================================="
    echo " "
else
    echo "✅ .env already exists. Skipping v2board installation."
fi

# Start supervisor services (ginx, php-fpm)
exec supervisord -c /etc/supervisord.conf




