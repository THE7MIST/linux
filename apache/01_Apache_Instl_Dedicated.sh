#!/bin/bash

# Script Name: 01_Apache_Instl_Dedicated

# Purpose: Install and configure Apache (httpd) for dedicated hosting

echo "-------- Apache Installation --------"
dnf install -y httpd

echo "-------- Starting and Enabling Apache Service --------"
systemctl start httpd
systemctl enable httpd
systemctl status httpd --no-pager

echo "-------- Configuring Firewall --------"
firewall-cmd --add-service=http --permanent
firewall-cmd --add-service=https --permanent
firewall-cmd --reload

echo "-------- Firewall Services --------"
firewall-cmd --list-all

echo "-------- Checking Port 80 Usage --------"
lsof -i :80

echo "-------- Creating Default Web Page --------"
echo "<html><body><h1>Dedicated Apache Server</h1></body></html>" > /var/www/html/index.html

echo "-------- Verifying Web Page --------"
cat /var/www/html/index.html

echo "-------- Apache Configuration Info --------"
echo "Main config file location:"
httpd -V | grep SERVER_CONFIG_FILE

echo "-------- DocumentRoot --------"
grep -i DocumentRoot /etc/httpd/conf/httpd.conf

echo "-------- Important Paths --------"
echo "Config directory: /etc/httpd/"
echo "Main config file: /etc/httpd/conf/httpd.conf"
echo "DocumentRoot: /var/www/html"
echo "Logs directory: /var/log/httpd"

echo "-------- User Verification Input --------"
read -p "Enter Server IP: " IP
read -p "Enter Domain Name: " DOMAIN

echo "-------- Testing via curl --------"
echo "Testing IP access:"
curl -I http://$IP

echo "Testing Domain access:"
curl -I http://$DOMAIN

echo "-------- DNS Resolution Check --------"
host $DOMAIN

echo "-------- Access Instructions --------"
echo "Open browser and visit:"
echo "http://$IP"
echo "http://$DOMAIN"

echo "-------- Completed --------"
