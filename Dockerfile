FROM php:7.3
COPY /composer.json /var/app/

# Set working directory
WORKDIR /var/app

# Install dependencies
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        git 
RUN pecl install apcu 
#&& sudo bash -c "echo extension=apcu.so > /etc/php7.3-sp/conf.d/apcu.ini" \
#RUN echo "extension=apcu.so" > /usr/local/etc/php/conf.d/apcu.ini
RUN docker-php-ext-install pdo pdo_mysql 
#RUN docker-php-ext-install pdo pdo_mysql apcu
# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*


# Install and run composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
RUN composer install

# Copy existing application directory contents
COPY . /var/app

RUN php migrations/01_init.php
# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
