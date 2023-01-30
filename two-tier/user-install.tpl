#!bin/bash
apt-get update 
apt-apt-get upgrade -y
apt-get install apache2
systemctl start apache2
systemctl enable apache2
echo "<h2> This is web Apache server <h2>" >  /var/www/html/index.html
systemctl restart apache2