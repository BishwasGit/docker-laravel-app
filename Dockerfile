FROM php:8.3-apache

# Install system dependencies
RUN apt-get update && apt-get install -y \
    unzip git curl zip libzip-dev libpng-dev libonig-dev libxml2-dev \
    libcurl4-openssl-dev libicu-dev libssl-dev netcat-traditional \
    && docker-php-ext-install pdo_mysql zip intl mbstring curl xml gd bcmath exif

# Enable Apache mod_rewrite for Laravel
RUN a2enmod rewrite

# Install Composer (latest version from official source)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set working directory
WORKDIR /var/www/html

# Copy Laravel project into container
COPY ./app/mylaravelapp /var/www/html

# Set permissions for Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Set Apache DocumentRoot to /public
RUN sed -ri -e 's!DocumentRoot /var/www/html!DocumentRoot /var/www/html/public!' /etc/apache2/sites-available/*.conf

EXPOSE 80

CMD ["apache2-foreground"]

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
