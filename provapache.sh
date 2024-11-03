#!/bin/bash


sudo apt-get update
sudo apt-get install -y apache2 php libapache2-mod-php php-mysql git
sudo apt-get install net-tools


git clone https://github.com/josejuansanchez/iaw-practica-lamp.git /var/www/lamp_app/

sudo mv /var/www/lamp_app/src/* /var/www/lamp_app/
sudo chown -R www-data.www-data /var/www/lamp_app/
sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/practica.conf

sudo sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/lamp_app|' /etc/apache2/sites-available/practica.conf

cd /etc/apache2/sites-available/
sudo a2ensite practica.conf
cd /etc/apache2/sites-enabled/
sudo a2dissite 000-default.conf

sudo systemctl reload apache2

cat <<EOL > /var/www/lamp_app/config.php
<?php
define('DB_HOST', '192.168.55.2');
define('DB_NAME', 'lamp_db');
define('DB_USER', 'antonio01');
define('DB_PASSWORD', '12345');

\$mysqli = mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);

?>
EOL

