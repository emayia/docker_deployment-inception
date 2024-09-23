# Inception: A Docker Deployment

## Introduction

The **Inception** project is focused on deploying a complete web infrastructure using **Docker** containers. Our goal is to build and configure three distinct services — **MariaDB**, **WordPress**, and **NGINX** — running in separate containers, which work together to provide a functional WordPress website. This project is an exercise in infrastructure orchestration, containerization, and understanding web service architecture.

## Key Components

1. **MariaDB** (`/srcs/requirements/mariadb/`)
	- **Database Server:** MariaDB is used to store and manage the WordPress site’s database.
	- **Configuration:** A custom `my.cnf` file is used to configure the MariaDB server, and the Dockerfile builds the environment needed to run MariaDB inside a container.
	- **Secrets Management:** The database credentials are stored securely in a separate directory (`/secrets`), and the MariaDB container reads these secrets at runtime.
	- **Setup Script:** The container uses a `configure-mariadb.sh` script to initialize the database, create the necessary users, and set up the initial database.

2. **WordPress** (`/srcs/requirements/wordpress/`)
	- **CMS:** WordPress is the content management system we use to host the website.
	- **Configuration:** The Dockerfile for the WordPress container installs PHP and all necessary extensions, configures PHP-FPM, and installs WordPress.
	- **CLI Management:** WordPress is managed using the `wp-cli` tool, allowing for automated configuration and user setup.
	- **Secrets:** Like the MariaDB container, WordPress also securely reads its database credentials and other configurations from the secrets directory.

3. **NGINX** (`/srcs/requirements/nginx/`)
	- **Web Server:** NGINX serves the WordPress website and handles SSL termination using self-signed certificates.
	- **Configuration:** A custom `nginx.conf` file is used to set up the server, with SSL configured using OpenSSL.
	- **SSL:** Self-signed certificates are generated for HTTPS connections, ensuring secure communication between the client and server.

4. **Docker Compose** (`/srcs/docker-compose.yml`)
	- **Service Orchestration:** All three services (MariaDB, WordPress, and NGINX) are orchestrated using Docker Compose. Each service runs in its own container, and they are networked together using a Docker network.
	- **Volumes:** Data persistence is handled using Docker volumes to ensure that the data from MariaDB and WordPress is not lost between container restarts.
	- **Networks:** The containers communicate over a custom Docker network (`inception`).

## Project Structure
```css
.
├── Makefile
├── secrets/
│   ├── credentials.txt
│   ├── db_password.txt
│   └── db_root_password.txt
└── srcs/
    ├── docker-compose.yml
    ├── .env
    └── requirements/
        ├── mariadb/
        ├── nginx/
        └── wordpress/
```

- **secrets/:** Stores sensitive information such as database credentials.
- **srcs/docker-compose.yml:** Defines the Docker Compose setup, including services, volumes, and networks.
- **srcs/requirements/:** Contains subdirectories for each service—MariaDB, NGINX, and WordPress—with their respective Dockerfiles and configuration files.

## How to Use

1. **Build and Start the Containers**

To build and start the Docker containers, run the following command:
```bash
make all
```

Followed by:

```bash
make start
```

These commands use Docker Compose to build the MariaDB, WordPress, and NGINX containers, and start those services in the background.

2. **Stop the Containers**

To stop the running containers without removing them, simply run:
```bash
make stop
```

Otherwise (if you want to remove the containers), run the following command:
```bash
make down
```

3. **Clean Up the Environment Thoroughly**

To fully cleanup the system (i.e. deleting the containers, volumes, images, etc.),
run this command:
```bash
make fclean
```

4. **View Logs**
To view the logs of the running services, use:
```bash
make logs
```

## Security Considerations
- **Secrets Management:** Database credentials and other sensitive information are stored in the `/secrets` directory and are mounted securely into the containers at runtime.
- **SSL Encryption:** NGINX is configured to use SSL with self-signed certificates to secure communication between the client and the server.

**⚠** `The /secrets folder is present in this repo for demonstration purposes only`. ***Never include this type of sensitive information within a shared repo.***

## Conclusion

The Inception project allows us to orchestrate multiple services using Docker and Docker Compose. We configure web servers, databases, and a content management system, all while emphasizing the importance of security and containerization best practices.

## Author

Project developed by [Emin A.](https://github.com/emayia) as part of the École 42 curriculum.