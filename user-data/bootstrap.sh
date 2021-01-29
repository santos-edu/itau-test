#!/bin/sh

sudo yum install -y nginx
sudo service nginx start
sudo chkconfig nginx on

echo '''<h2 style="color: #2e6c80;"><img style="display: block; margin-left: auto; margin-right: auto;" src="https://raw.githubusercontent.com/santos-edu/itau-test/main/img/tweet-hunt.jpeg" alt="" width="300" height="169" /></h2>
<h2 style="color: #2e6c80; text-align: center;">Itau-test V1</h2>
<p>&nbsp;</p>''' > /usr/share/nginx/html/index.html