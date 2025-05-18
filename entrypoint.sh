#!/bin/sh

# Wait for MySQL to be ready
until nc -z -v -w30 mysql 3306
do
  echo "Waiting for MySQL..."
  sleep 3
done

cd /var/www/html

# Run Composer
composer install --ignore-platform-reqs

# Run Laravel migrations
php artisan migrate --force

php artisan db:seed --force

# Start Apache
exec apache2-foreground
