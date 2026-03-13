#!/bin/bash

yum update -y
yum install httpd -y

systemctl start httpd
systemctl enable httpd

echo "<h1>Apache Webserver running on Amazon Linux - $(hostname)</h1>" > /var/www/html/index.html