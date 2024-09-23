#!/bin/bash

# Exit immediately if any command fails
set -e

# Load credentials from secrets
source /run/secrets/credentials

# Read passwords from secrets
MYSQL_PASSWORD=$(cat /run/secrets/db_password)
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
MYSQL_DATABASE=${MYSQL_DATABASE:-wordpress}
DB_USER=${DB_USER}

# Initialize MariaDB if necessary
if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "Initializing MariaDB database..."
	# Use > /dev/null to discard the output of the cmd
	mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

	# Start MariaDB in the background (&) without networking
	# Safely configure users and databases w/out external interference
	echo "Starting MariaDB temporarily..."
	mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking &
	pid="$!"

	# Wait for MariaDB to be ready
	while ! mysqladmin ping --silent; do
		sleep 1
	done

	# Setup initial database and users
	mysql -uroot <<-EOF
		CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
		CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
		GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${DB_USER}'@'%';
		ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
		FLUSH PRIVILEGES;
EOF

	echo "Shutting down temporary MariaDB instance..."
	mysqladmin -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown

	echo "MariaDB initialized!"
fi

# Start MariaDB in production mode
exec mysqld --user=mysql --datadir=/var/lib/mysql
