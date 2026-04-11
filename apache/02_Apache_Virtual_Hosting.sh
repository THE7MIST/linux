#!/bin/bash

# Script Name: 02_Apache_Virtual_Hosting

echo "-------- Apache Installation --------"
dnf install -y httpd

echo "-------- Starting Apache Service --------"
systemctl start httpd
systemctl enable httpd

echo "-------- Disabling SELinux (temporary) --------"
setenforce 0

echo "-------- Setting up Virtual Host Structure --------"
mkdir -p /etc/httpd/sites-available
mkdir -p /etc/httpd/sites-enabled

if ! grep -q "sites-enabled" /etc/httpd/conf/httpd.conf; then
echo "IncludeOptional sites-enabled/*.conf" >> /etc/httpd/conf/httpd.conf
fi

echo "-------- User Input Section --------"
read -p "Enter number of sites: " COUNT
read -p "Enter which site number is dedicated (1 to $COUNT): " DED

for ((i=1; i<=COUNT; i++))
do
echo "---- Site $i ----"
read -p "Enter username: " USER
read -p "Enter domain (example.com): " DOMAIN

```
echo "Creating user $USER"
useradd $USER

echo "Creating directory structure for $USER"
mkdir -p /home/$USER/public_html

echo "Setting permissions"
chmod 711 /home/$USER
chmod 755 /home/$USER/public_html

echo "Creating empty index file"
touch /home/$USER/public_html/index.html

chmod 644 /home/$USER/public_html/index.html
chown -R $USER:$USER /home/$USER

echo "Creating VirtualHost config"
CONF_FILE="/etc/httpd/sites-available/$USER.conf"

echo "<VirtualHost *:80>" > $CONF_FILE
echo "    ServerName $DOMAIN" >> $CONF_FILE
echo "    ServerAlias www.$DOMAIN" >> $CONF_FILE
echo "    DocumentRoot /home/$USER/public_html" >> $CONF_FILE
echo "</VirtualHost>" >> $CONF_FILE

ln -s $CONF_FILE /etc/httpd/sites-enabled/

echo "------------------------------------"
echo "Site $i configured"
echo "User: $USER"
echo "Domain: $DOMAIN"
echo "Index file location: /home/$USER/public_html/index.html"

if [ "$i" -eq "$DED" ]; then
    echo "This is marked as DEDICATED site"
else
    echo "This is a SHARED (virtual) site"
fi
echo "------------------------------------"
```

done

echo "-------- Enabling UserDir --------"
sed -i 's/^UserDir.*/UserDir public_html/' /etc/httpd/conf.d/userdir.conf

echo "-------- Restarting Apache --------"
systemctl restart httpd

echo "-------- Verification --------"
echo "Use curl or browser:"
echo "curl http://<your-domain>"
echo "Example:"
echo "curl http://example.com"

echo "-------- Completed --------"
