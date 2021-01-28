#!/bin/sh
sudo yum install -y nginx
sudo service nginx start
sudo chkconfig nginx on

echo "Hello world" > /usr/share/nginx/html/index.html
