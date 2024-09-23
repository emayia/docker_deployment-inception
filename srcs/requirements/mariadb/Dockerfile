FROM alpine:3.19

# Install MariaDB and necessary tools
RUN apk update && apk add --no-cache mariadb mariadb-client bash

# Create necessary directories and set permissions
RUN mkdir -p /run/mysqld && \
	chown -R mysql:mysql /run/mysqld && \
	mkdir -p /var/lib/mysql && \
	chown -R mysql:mysql /var/lib/mysql

# Copy configuration files
COPY ./conf/my.cnf /etc/my.cnf.d/

# Copy initialization script
COPY ./tools/configure-mariadb.sh /usr/local/bin/

# Make the script executable
RUN chmod +x /usr/local/bin/configure-mariadb.sh

# Expose port
EXPOSE 3306

# Start MariaDB using the initialization script
ENTRYPOINT ["configure-mariadb.sh"]
