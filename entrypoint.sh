#!/bin/bash
if [[ -d "/data/frontend" ]]
then
	echo "GLPI is already installed"
else
	mkdir -p /data/log
	mkdir -p /data/frontend
        mkdir -p /data/backend
	mkdir -p /data/backend/config
	wget -P /tmp/ https://github.com/glpi-project/glpi/releases/download/10.0.6/glpi-10.0.6.tgz
	tar -xzf /tmp/glpi-10.0.6.tgz -C /data/frontend
	mv data/frontend/glpi/files /data/backend/files 
cat > /data/frontend/glpi/inc/downstream.php << EOF
<?php
define('GLPI_CONFIG_DIR', '/data/backend/config');

if (file_exists(GLPI_CONFIG_DIR . '/local_define.php')) {
   require_once GLPI_CONFIG_DIR . '/local_define.php';
}
EOF

cat > /data/backend/config/local_define.php << EOF
<?php
define('GLPI_VAR_DIR', '/data/backend/files');
define('GLPI_LOG_DIR', '/data/log');
EOF

	chown -R www-data:www-data /data
	chmod -R 775 /data
	rm -f /tmp/glpi-10.0.6.tgz
	cd /data/frontend/glpi
	php bin/console db:install --db-host=$MYSQL_HOST --db-name=$MYSQL_DATABASE --db-user=$MYSQL_USER --db-password=$MYSQL_PASSWORD --no-interaction
	rm -rf /data/frontend/glpi/install
fi

echo "ServerName localhost" >> /etc/apache2/apache2.conf
#Setup vhost
cat > /etc/apache2/sites-available/000-default.conf << EOF
<VirtualHost *:80>
        DocumentRoot /data/frontend/glpi

        <Directory /data/frontend/glpi>
                AllowOverride All
		Require all granted
        </Directory>

        ErrorLog /data/log/error.log
        LogLevel warn
        CustomLog /data/log/access.log combined
</VirtualHost>
EOF

# Setup Cron task
echo "*/2 * * * * www-data /usr/bin/php /data/frontend/glpi/front/cron.php &>/dev/null" >> /etc/cron.d/glpi

#Start cron service
service cron start

#################"

#Run apache in foreground mode.
/usr/sbin/apache2ctl -D FOREGROUND

#Activation du module rewrite d'apache
a2enmod rewrite && service apache2 restart
