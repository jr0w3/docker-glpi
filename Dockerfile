#Based Image
FROM debian:11.6

#Don't ask confirmation
ENV DEBIAN_FRONTEND noninteractive

RUN apt update \
&& apt install --yes --no-install-recommends \
wget \
ca-certificates \
cron \
apache2 \
mariadb-server \
perl \
curl \
jq \
php \
&& apt install --yes --no-install-recommends \
php-ldap \
php-imap \
php-apcu \
php-xmlrpc \
php-cas \
php-mysqli \
php-mbstring \
php-curl \
php-gd \
php-simplexml \
php-xml \
php-intl \
php-zip \
php-bz2 \
&& rm -rf /var/lib/apt/lists/*

VOLUME /data

# Copy entrypoint make it as executable and run it
COPY entrypoint.sh /opt/
RUN chmod +x /opt/entrypoint.sh
#ENTRYPOINT ["/opt/entrypoint.sh"]
ENTRYPOINT [ "/bin/bash", "-c", "source ~/.bashrc && /opt/entrypoint.sh ${@}", "--" ]

#Expose ports
#EXPOSE 80 443
