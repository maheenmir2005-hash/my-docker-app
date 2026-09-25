FROM php:8.2-cli

# Install system dependencies and PHP extensions required by Laravel
RUN apt-get update && apt-get install -y \
    unzip \
    libpq-dev \
    libcurl4-openssl-dev \
    && docker-php-ext-install pdo pdo_mysql

# Install Composer globally
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory inside container
WORKDIR /var/www

# Copy all project files into the container
COPY . .

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Set permissions for storage & cache
RUN chown -R www-data:www-data storage bootstrap/cache

EXPOSE 8000

# Start Laravel built-in development server
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]