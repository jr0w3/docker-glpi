![Docker Pulls](https://img.shields.io/docker/pulls/jr0w3/glpi) ![Docker Stars](https://img.shields.io/docker/stars/jr0w3/glpi) ![Image Size](https://img.shields.io/docker/image-size/jr0w3/glpi?sort=date)

# Quick reference

-   **Maintained by**:  
    [jr0w3](https://github.com/jr0w3)

-   **Where to file issues**:  
    [https://github.com/jr0w3/docker-glpi/issues](https://github.com/jr0w3/docker-glpi/issues)
    
-   **Supported architectures**: 
    `amd64`
-   **Current GLPI Version**: 
    `10.0.5`



### Default accounts
| Login | Password | Role |
|--|--|--|
glpi|glpi|admin account
tech|tech|technical account
normal|normal|"normal" account
post-only|postonly|post-only account

### Read the documentation
Know that I have no connection with the team that develops GLPI and/or TecLib.
If you encounter a problem with this image , you can create an issue, i will help you with pleasure.
If you encounter a problem with GLPI and/or need more information on how it works, I recommend that you read the documentations:

[GLPI Administrators Docs](https://glpi-install.readthedocs.io/)

[GLPI Users Docs](https://glpi-user-documentation.readthedocs.io/)

### About SSL
The installation of GLPI is done without SSL. If you need to open access to GLPI from the outside and/or an SSL certificate, I recommend that you use a reverse proxy.

# Deploy with CLI
## Deploy GLPI
First MariaDB image using:

    docker run --name db -e MYSQL_ROOT_PASSWORD=rtpsw -e MYSQL_DATABASE=glpi -e MYSQL_USER=user -e MYSQL_PASSWORD=psw -d mariadb:10.11-rc 

Next run GLPI image:

    docker run --name glpi --link db:db -p 80:80 -e MYSQL_HOST=db -e MYSQL_DATABASE=glpi -e MYSQL_USER=user -e MYSQL_PASSWORD=psw -d jr0w3/glpi

⚠️ If you change the password on the database deployment command, don't forget to do it also for the GLPI deployment command.

## Deploy GLPI with database and persistence data
First MariaDB image using:

    docker run --name db -e MYSQL_ROOT_PASSWORD=rtpsw -e MYSQL_DATABASE=glpi -e MYSQL_USER=user -e MYSQL_PASSWORD=psw --volume /var/lib/mysql:/var/lib/mysql -d mariadb:10.11-rc 

Next run GLPI image:

    docker run --name glpi --link db:db -p 80:80 -e MYSQL_HOST=db -e MYSQL_DATABASE=glpi -e MYSQL_USER=user -e MYSQL_PASSWORD=psw --volume /var/www/html/:/data -d jr0w3/glpi

⚠️ If you change the password on the database deployment command, don't forget to do it also for the GLPI deployment command.

## Deploy GLPI with docker-compose:

    version: '2'
    
    volumes:
      data:
      db:
    
    services:
    # mariaDB Container
      db:
        image: mariadb:10.11-rc
        restart: always
        command: --transaction-isolation=READ-COMMITTED --binlog-format=ROW
        environment:
    # It is strongly recommended to change these identifiers by other more secure ones.
    # Don't forget to report them in the app service below.
          - MYSQL_ROOT_PASSWORD=rtpsw
          - MYSQL_PASSWORD=psw
          - MYSQL_DATABASE=glpi
          - MYSQL_USER=user
    
    #GLPI Container
      app:
        image: jr0w3/glpi
        restart: always
        ports:
          - 80:80
        links:
          - db
        environment:
          - MYSQL_PASSWORD=psw
          - MYSQL_DATABASE=glpi
          - MYSQL_USER=user
          - MYSQL_HOST=db

⚠️ If you change the password on the database deployment command, don't forget to do it also for the GLPI deployment command.

## Deploy GLPI with docker-compose, database and persistence data:

    version: '2'
    
    volumes:
      data:
      db:
    
    services:
    # mariaDB Container
      db:
        image: mariadb:10.11-rc
        restart: always
        command: --transaction-isolation=READ-COMMITTED --binlog-format=ROW
        volumes:
          - db:/var/lib/mysql
        environment:
    # It is strongly recommended to change these identifiers by other more secure ones.
    # Don't forget to report them in the app service below.
          - MYSQL_ROOT_PASSWORD=rtpsw
          - MYSQL_PASSWORD=psw
          - MYSQL_DATABASE=glpi
          - MYSQL_USER=user
    
    #GLPI Container
      app:
        image: jr0w3/glpi
        restart: always
        ports:
          - 80:80
        links:
          - db
        volumes:
          - data:/data
        environment:
          - MYSQL_PASSWORD=psw
          - MYSQL_DATABASE=glpi
          - MYSQL_USER=user
          - MYSQL_HOST=db

⚠️ If you change the password on the database deployment command, don't forget to do it also for the GLPI deployment command.
