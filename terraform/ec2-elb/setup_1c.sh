#!/bin/bash
apt update
apt install nodejs npm -y
npm i -g http-server

mkdir -p /var/www
echo "<h1>1c</h1>" > /var/www/index.html
mkdir -p /var/www/deny
echo "<h1>1c deny</h1>" > /var/www/deny/index.html
mkdir -p /var/www/allow
echo "<h1>1c allow</h1>" > /var/www/allow/index.html

cd /var/www
http-server -p 80
