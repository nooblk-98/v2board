# Use PHP 8.2 with Apache as the base image
FROM ghcr.io/nooblk-98/php-nooblk:7.4-apache

# Copy application files into the container
COPY . /var/www/html
WORKDIR /var/www/html

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install PHP project dependencies with Composer
RUN composer install --optimize-autoloader --no-dev --no-scripts

# Set proper permissions for Laravel storage and cache directories
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Copy environment file and set Laravel application key


RUN  cp ./docker/entrypoint.sh /entrypoint.sh && \
    chmod +x /entrypoint.sh

# RUN mv -f ./docker/V2boardInstall.php app/Console/Commands/V2boardInstall.php



# Expose port 80 for Apache server
EXPOSE 80
CMD ["apache2-foreground"]
#ENTRYPOINT ["/entrypoint.sh"]