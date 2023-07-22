#!/bin/bash
if [[ -d "/app/glpi" ]]
then
	echo "GLPI is already installed"
else
	mkdir -p /app/log
	mkdir -p /app/data
	mkdir -p /app/config
	wget -P /tmp/ https://github.com/glpi-project/glpi/releases/download/10.0.9/glpi-10.0.9.tgz
	tar -xzf /tmp/glpi-10.0.9.tgz -C /app/
	mv /app/glpi/files /app/data/files
cat > /app/glpi/inc/downstream.php << EOF
<?php
define('GLPI_CONFIG_DIR', '/app/config');

if (file_exists(GLPI_CONFIG_DIR . '/local_define.php')) {
   require_once GLPI_CONFIG_DIR . '/local_define.php';
}
EOF

cat > /app/config/local_define.php << EOF
<?php
define('GLPI_VAR_DIR', '/app/data/files');
define('GLPI_LOG_DIR', '/app/log');
EOF

	chown -R www-data:www-data /app
	chmod -R 775 /app
	rm -f /tmp/glpi-10.0.9.tgz
	cd /app/glpi
	php bin/console db:install --db-host=$MYSQL_HOST --db-name=$MYSQL_DATABASE --db-user=$MYSQL_USER --db-password=$MYSQL_PASSWORD --no-interaction
	rm -rf /app/glpi/install
fi

echo "ServerName localhost" >> /etc/apache2/apache2.conf
#Setup vhost
cat > /etc/apache2/sites-available/000-default.conf << EOF
<VirtualHost *:80>
        DocumentRoot /app/glpi

        <Directory /app/glpi>
                AllowOverride All
                Require all granted
        </Directory>

        ErrorLog /app/log/error.log
        LogLevel warn
        CustomLog /app/log/access.log combined
</VirtualHost>
EOF


# Setup Cron task
echo "*/2 * * * * www-data /usr/bin/php /app/glpi/front/cron.php &>/dev/null" >> /etc/cron.d/glpi

#Start cron service
service cron start

#################"

#Run apache in foreground mode.
/usr/sbin/apache2ctl -D FOREGROUND

#Activation du module rewrite d'apache
a2enmod rewrite && service apache2 restart
