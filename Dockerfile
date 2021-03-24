FROM php:7.3-fpm
COPY composer.json /var/app/

# Set working directory
WORKDIR /var/app

# Install dependencies
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        git \

    && docker-php-ext-install pdo pdo_mysql apc
RUN pecl install apcu
# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*


# Install and run composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
RUN composer install


# Copy existing application directory contents
COPY ../test-master /var/app


# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]