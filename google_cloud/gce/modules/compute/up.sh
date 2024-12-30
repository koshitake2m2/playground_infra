#!/bin/bash

sudo mkdir -p /var/www/html/
sudo echo "<h1>1a</h1>" > /var/www/html/index.html
sudo mkdir -p /var/www/html/allow
sudo echo "<h1>1a allow</h1>" > /var/www/html/allow/index.html

sudo apt update
sudo apt install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
