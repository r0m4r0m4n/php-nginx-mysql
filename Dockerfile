FROM php:7.3-fpm
COPY ./web/composer.json /var/app/

# Set working directory
WORKDIR /var/app

# Install dependencies
RUN apt-get update && apt-get install -y git 
RUN pecl install apcu 
#RUN echo "extension=apcu.so" > /usr/local/etc/php/conf.d/apcu.ini
RUN docker-php-ext-install pdo pdo_mysql 
RUN docker-php-ext-enable pdo pdo_mysql apcu
# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN curl -sS http://getcomposer.org/installer | php -- --filename=composer && chmod a+x composer  && mv composer /usr/local/bin/composer
RUN echo 'export PATH=~/.composer/vendor/bin:$PATH' >> ~/.bashrc
RUN composer install
COPY . /var/app
# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]
