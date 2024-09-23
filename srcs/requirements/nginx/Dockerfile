FROM alpine:3.19

# Install NGINX and OpenSSL for SSL/TLS support
RUN apk update && apk add --no-cache nginx openssl

# Copy the nginx.conf file to the container
COPY ./conf/nginx.conf /etc/nginx/nginx.conf

RUN chmod +x /etc/nginx/nginx.conf

# Create SSL certificates using OpenSSL and ensure the right permissions
RUN mkdir -p /etc/nginx/ssl && \
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/nginx/ssl/nginx.key \
	-out /etc/nginx/ssl/nginx.crt \
	-subj "/C=FR/ST=PACA/O=42Nice/OU=mayyildi/CN=mayyildi.42.fr"

RUN mkdir -p /var/www/html && \
	chown -R nginx:nginx /var/www/html && \
	chmod -R 755 /var/www/html

# Expose port 443 for HTTPS
EXPOSE 443

# Start NGINX in the foreground
CMD ["nginx", "-g", "daemon off;"]
