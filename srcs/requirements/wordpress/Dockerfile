FROM alpine:3.19

# Install necessary packages
RUN apk update && \
	apk add --no-cache \
	php82 \
	php82-fpm \
	php82-mysqli \
	php82-json \
	php82-curl \
	php82-xml \
	php82-ctype \
	php82-mbstring \
	php82-phar \
	php82-opcache \
	php82-gd \
	php82-dom \
	php82-session \
	php82-zip \
	php82-tokenizer \
	php82-fileinfo \
	php82-simplexml \
	mariadb-client \
	wget \
	bash

# Create nginx user and group
RUN addgroup -S nginx && adduser -S nginx -G nginx

# Set working directory
WORKDIR /var/www/html

# Download and extract WordPress version 6.6
RUN wget https://wordpress.org/wordpress-6.6.tar.gz && \
	tar -xzf wordpress-6.6.tar.gz && \
	rm wordpress-6.6.tar.gz

# Download WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /usr/local/bin/wp && \
	chmod +x /usr/local/bin/wp

# Copy configuration files
COPY ./conf/www.conf /etc/php82/php-fpm.d/

# Copy initialization script
COPY ./tools/configure-wordpress.sh /usr/local/bin/

# Make the script executable
RUN chmod +x /usr/local/bin/configure-wordpress.sh

# Expose port
EXPOSE 9000

# Start the initialization script
CMD ["/usr/local/bin/configure-wordpress.sh"]
