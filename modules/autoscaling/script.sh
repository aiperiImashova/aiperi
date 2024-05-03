#!/bin/bash
yum -y update 
yum -y install httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>Hello from $(hostname -f) </h1>" >/var/www/html/index.html