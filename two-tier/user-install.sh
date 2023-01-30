#!bin/bash

sudo apt-get update && apt-apt-get upgrade -y
sudo apt-get install httpd
sudo systemctl start service.httpd
sudo systemctl enable service.httpd
echo "<h2> This is web server: $(hostname)<h2>" >  /var/www/html/index.html