# Base image
FROM ghcr.io/nooblk-98/php-docker-production-stack:latest

# Set working directory
WORKDIR /var/www/html

# Copy application files
COPY . .

# Install system tools (e.g., dos2unix)
RUN apk add dos2unix curl git unzip nano nodejs npm

# PHP extension installer
ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

# Install required PHP extensions
RUN install-php-extensions pcntl
 
RUN git config --global --add safe.directory /var/www/html
# Install PM2 globally
RUN npm install -g pm2
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


# Replace root path directly
RUN sed -i 's|root /var/www/html;|root /var/www/html/public;|' /etc/nginx/nginx.conf


# Copy cron file to container
COPY ./docker/bin/laravel-cron /etc/cron.d/laravel-cron

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/laravel-cron

# Apply cron job
RUN crontab /etc/cron.d/laravel-cron


# Expose Apache port
EXPOSE 80

# Start the container using the custom entrypoint
ENTRYPOINT ["/entrypoint.sh"]
