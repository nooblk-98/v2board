#!/bin/sh

# # Fixing storage permissions...
chown -R www-data:www-data *

php artisan v2board:install
# Starting Apache...
exec apache2-foreground