#Based Image
FROM debian:12.2

#Don't ask confirmation
ENV DEBIAN_FRONTEND noninteractive

RUN apt update \
&& apt install --yes --no-install-recommends \
wget \
ca-certificates \
cron \
apache2 \
perl \
curl \
jq \
php8.2 \
&& apt install --yes --no-install-recommends \
php8.2-{ldap,imap,apcu,xmlrpc,mysql,mbstring,curl,gd,xml,intl,zip,bz2} \
&& rm -rf /var/lib/apt/lists/*

VOLUME /app

# Copy entrypoint make it as executable and run it
COPY entrypoint.sh /opt/
RUN chmod +x /opt/entrypoint.sh
#ENTRYPOINT ["/opt/entrypoint.sh"]
ENTRYPOINT [ "/bin/bash", "-c", "source ~/.bashrc && /opt/entrypoint.sh ${@}", "--" ]

#Expose ports
#EXPOSE 80 443
