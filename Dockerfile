FROM php:7.3-fpm
COPY ./web/composer.json /var/app/

# Set working directory
WORKDIR /var/app

# Install dependencies
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        git 
RUN pecl install apcu 
RUN echo "extension=apcu.so" > /usr/local/etc/php/conf.d/apcu.ini
RUN docker-php-ext-install pdo pdo_mysql 
# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN echo "memory_limit = -1" > /usr/local/etc/php/conf.d/memory_limit.ini
RUN curl -sS http://getcomposer.org/installer | php -- --filename=composer && chmod a+x composer  && mv composer /usr/local/bin/composer
RUN echo 'export PATH=~/.composer/vendor/bin:$PATH' >> ~/.bashrc
RUN composer install
COPY . /var/app
# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
