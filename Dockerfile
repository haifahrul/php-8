FROM php:8.0.5-fpm-alpine3.13

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini" && \
	apk update && \
	apk add gcc musl-dev libc-dev && \
	apk add --no-cache git openssl-dev openssh-client make nginx sudo mariadb-dev icu-dev bash postgresql-dev \
	autoconf freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev \
	imap-dev krb5-dev krb5 libzip-dev oniguruma-dev curl-dev composer && \
	docker-php-ext-configure gd --with-freetype --with-jpeg && \
	docker-php-ext-install -j$(nproc) gd && \
	docker-php-ext-configure intl && \
	docker-php-ext-install pdo pdo_mysql imap zip mbstring curl intl pdo pdo_pgsql pgsql && \
	pecl config-set php_ini "${PHP_INI_DIR}/php.ini" && \
	pecl install mongodb && \
	echo "extension=mongodb.so" > $PHP_INI_DIR/conf.d/mongo.ini && \
	docker-php-ext-enable mongodb && \
	mkdir /run/nginx/ && \
	chown nginx:www-data /run/nginx
