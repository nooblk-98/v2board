# Base image
FROM ghcr.io/nooblk-98/php-nooblk:7.4-apache

# Set working directory
WORKDIR /var/www/html

# Copy application files
COPY . .

# Install system tools (e.g., dos2unix)
RUN apt-get update && apt-get install -y dos2unix curl git unzip nano

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install PHP project dependencies
RUN composer install --optimize-autoloader --no-dev --no-scripts

# Set permissions for Laravel
RUN chown -R www-data:www-data storage bootstrap/cache

# Copy and fix entrypoint script
RUN cp ./docker/bin/entrypoint.sh /entrypoint.sh && \
    dos2unix /entrypoint.sh && chmod +x /entrypoint.sh

# Copy .htaccess to public directory
RUN cp ./docker/configurations/.htaccess public/.htaccess

# Move custom Laravel command and .env
RUN mv -f ./docker/bin/V2boardInstall.php app/Console/Commands/V2boardInstall.php && \
    mv -f ./docker/configurations/.env.example .env.example

# Expose Apache port
EXPOSE 80

# Start the container using the custom entrypoint
ENTRYPOINT ["/entrypoint.sh"]
