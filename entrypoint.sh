#!/bin/bash
if [[ -d "/data/glpi" ]]
then
	echo "GLPI is already installed"
else
	mkdir -p /data/log
	wget -P /tmp/ https://github.com/glpi-project/glpi/releases/download/10.0.5/glpi-10.0.5.tgz
	tar -xzf /tmp/glpi-10.0.5.tgz -C /data/
	chown -R www-data:www-data /data
	chmod -R 775 /data/glpi
	rm -f /tmp/glpi-10.0.5.tgz
	cd /data/glpi
	php bin/console db:install --db-host=$MYSQL_HOST --db-name=$MYSQL_DATABASE --db-user=$MYSQL_USER --db-password=$MYSQL_PASSWORD --no-interaction
	rm -rf /data/glpi/install
fi

#Setup vhost
cat > /etc/apache2/sites-available/000-default.conf << EOF
<VirtualHost *:80>
        DocumentRoot /data/glpi

        <Directory /data/glpi>
                AllowOverride All
		Require all granted
        </Directory>

        ErrorLog /data/log/error.log
        LogLevel warn
        CustomLog /data/log/access.log combined
</VirtualHost>
EOF

# Setup Cron task
echo "*/2 * * * * www-data /usr/bin/php /data/glpi/front/cron.php &>/dev/null" >> /etc/cron.d/glpi

#Start cron service
service cron start

#################"

#Run apache in foreground mode.
/usr/sbin/apache2ctl -D FOREGROUND

#Activation du module rewrite d'apache
a2enmod rewrite && service apache2 restart
