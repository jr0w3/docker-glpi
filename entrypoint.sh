#!/bin/bash
if [[ -d "/var/www/html/glpi" ]]
then
	echo "GLPI is already installed"
else
	wget -P /tmp/ https://github.com/glpi-project/glpi/releases/download/10.0.5/glpi-10.0.5.tgz
	tar -xzf /tmp/glpi-10.0.5.tgz -C /var/www/html/
	chown -R www-data:www-data /var/www/html/glpi
	chmod -R 775 /var/www/html/glpi
	rm -f /tmp/glpi-10.0.5.tgz
fi

#Setup vhost
cat > /etc/apache2/sites-available/000-default.conf << EOF
<VirtualHost *:80>
        DocumentRoot /var/www/html/glpi

        <Directory /var/www/html/glpi>
                AllowOverride All
                Order Allow,Deny
                Allow from all
        </Directory>

        ErrorLog /var/log/apache2/error-glpi.log
        LogLevel warn
        CustomLog /var/log/apache2/access-glpi.log combined
</VirtualHost>
EOF

# Setup Cron task
echo "*/2 * * * * www-data /usr/bin/php /var/www/html/glpi/front/cron.php &>/dev/null" >> /etc/cron.d/glpi

#Start cron service
service cron start

#################"
echo "$VAR1" >> /var/www/html/glpi/var.txt


#Run apache in foreground mode.
/usr/sbin/apache2ctl -D FOREGROUND

#Activation du module rewrite d'apache
a2enmod rewrite && service apache2 restart
