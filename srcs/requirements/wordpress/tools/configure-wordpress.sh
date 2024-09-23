#!/bin/bash

# Exit if any command fails
set -e

# Load credentials from secrets
source /run/secrets/credentials

# Read database password from secret
DB_PASS=$(cat /run/secrets/db_password)

# Wait for MariaDB to be ready
echo "Waiting for MariaDB to be ready..."
while ! mysqladmin ping -h"${DB_HOST}" --silent; do
	sleep 1
done

# Check if WordPress is already installed
if wp core is-installed --path="${WP_PATH}/wordpress" --allow-root; then
	echo "WordPress is already installed."
else
	# Configure WordPress
	wp config create \
		--dbname="${DB_NAME}" \
		--dbuser="${DB_USER}" \
		--dbpass="${DB_PASS}" \
		--dbhost="${DB_HOST}" \
		--path="${WP_PATH}/wordpress" \
		--allow-root

	# Install WordPress
	wp core install \
		--url="${DOMAIN_NAME}" \
		--title="${WP_TITLE}" \
		--admin_user="${WP_ADMIN}" \
		--admin_password="${WP_ADMIN_PASS}" \
		--admin_email="${WP_ADMIN_EMAIL}" \
		--skip-email \
		--path="${WP_PATH}/wordpress" \
		--allow-root

	# Create a new WordPress user
	wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
		--user_pass="${WP_USER_PASS}" \
		--role=subscriber \
		--path="${WP_PATH}/wordpress" \
		--allow-root
fi

# Detect if accessing from localhost or the domain, and set URLs accordingly
if [[ "$DOMAIN_NAME" == "localhost" || "$DOMAIN_NAME" == "127.0.0.1" ]]; then
	# Set URLs for localhost
	wp option update siteurl 'https://localhost' --allow-root --path="${WP_PATH}/wordpress"
	wp option update home 'https://localhost' --allow-root --path="${WP_PATH}/wordpress"
else
	# Set URLs for domain
	wp option update siteurl "https://${DOMAIN_NAME}" --allow-root --path="${WP_PATH}/wordpress"
	wp option update home "https://${DOMAIN_NAME}" --allow-root --path="${WP_PATH}/wordpress"
fi

# Start PHP-FPM in the foreground
php-fpm82 --nodaemonize --fpm-config /etc/php82/php-fpm.conf
