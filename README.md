# GLPI Docker

This repository provides a Docker Compose configuration to run GLPI (IT and Asset Management software) along with a MariaDB database.

## Prerequisites

Before you begin, ensure you have the following installed on your machine:

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)

## Getting Started

1. Clone this repository:

   ```bash
   git clone https://github.com/votre-utilisateur/repo-glpi-docker.git
   cd repo-glpi-docker
   ```
2. Edit the .env file:
   ```bash
   nano .env
   ```

Update the file with your preferred settings, especially the following variables:

* 'MYSQL_ROOT_PASSWORD'
* 'MYSQL_PASSWORD'
* 'MYSQL_DATABASE'
* 'MYSQL_USER'

3. Start the services:
   ```bash
   docker-compose up -d
   ```
4. Access GLPI in your browser at http://localhost:80. The default login credentials are:
    Username: glpi
    Password: glpi

## Configuration
### MariaDB Container
The MariaDB container is pre-configured with the following environment variables:

* 'MYSQL_ROOT_PASSWORD': Root password for MariaDB.
* 'MYSQL_PASSWORD': Password for the GLPI database user.
* 'MYSQL_DATABASE': Name of the GLPI database.
* 'MYSQL_USER': GLPI database user.

### GLPI Container
The GLPI container is configured using the following environment variables:

* 'MYSQL_PASSWORD': Password for the GLPI database user.
* 'MYSQL_DATABASE': Name of the GLPI database.
* 'MYSQL_USER': GLPI database user.
* 'MYSQL_HOST': Hostname of the MariaDB container.

### Health Checks
Both MariaDB and GLPI containers have health checks configured to ensure their proper functioning.

### Issues
If you encounter any issues or have questions, please check the issues section of the original repository.

### Notes
It is recommended to change the default credentials in the .env file for security reasons.  
