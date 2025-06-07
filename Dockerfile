# Base image
FROM ghcr.io/nooblk-98/php-docker-nginx:php82

# Set working directory
WORKDIR /var/www/html

# Install system tools (e.g., dos2unix)
RUN apk add --no-cache dos2unix curl git unzip nano

# PHP extension installer
ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

# Git safe directory for Laravel
RUN git config --global --add safe.directory /var/www/html

# Fix nginx root to /public
RUN sed -i 's|root /var/www/html;|root /var/www/html/public;|' /etc/nginx/nginx.conf

# Copy application files
COPY . .

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install PHP dependencies
RUN composer install --optimize-autoloader --no-dev --no-scripts

# Copy and fix entrypoint script
RUN cp ./docker/bin/entrypoint.sh /entrypoint.sh && \
    dos2unix /entrypoint.sh && chmod +x /entrypoint.sh

# Move custom Laravel command and .env
RUN mv -f ./docker/bin/V2boardInstall.php app/Console/Commands/V2boardInstall.php && \
    mv -f ./docker/configurations/.env.example .env.example

# Set proper permissions for Laravel
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html/storage /var/www/html/bootstrap/cache

COPY ./docker/bin/schedule-runner.sh /usr/local/bin/schedule-runner.sh
RUN chmod +x /usr/local/bin/schedule-runner.sh


# Supervisor Tasks for Laravel
COPY ./docker/configurations/supervisor/conf.d/*.conf /etc/supervisor/conf.d/

# Expose HTTP port
EXPOSE 80

# Use custom entrypoint
ENTRYPOINT ["/entrypoint.sh"]
