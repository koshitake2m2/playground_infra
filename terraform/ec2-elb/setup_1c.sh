#!/bin/bash
apt update
apt install nodejs npm -y
npm i -g http-server

mkdir -p /var/www
echo "<h1>1c</h1>" > /var/www/index.html
cd /var/www
http-server -p 80
