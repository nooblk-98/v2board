# Use PHP 8.2 with Apache as the base image
FROM ghcr.io/nooblk-98/php-nooblk:8.2-apache

# Copy application files into the container
COPY . /var/www/html
WORKDIR /var/www/html

# Configure Git to treat the project directory as safe
RUN git config --global --add safe.directory /var/www/html

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install PHP project dependencies with Composer
RUN composer install --optimize-autoloader --no-dev --no-scripts

# Set proper permissions for Laravel storage and cache directories
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Copy environment file and set Laravel application key
COPY ../../.env.example /var/www/html/.env

# Install Node.js dependencies and build frontend assets (uncomment if necessary)
# RUN npm install && npm run build

# Expose port 80 for Apache server
EXPOSE 80
COPY ../docker/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]