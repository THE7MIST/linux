#!/bin/bash

# Script Name: 04_Troubleshoot_Fix_Apache

# Purpose: Detect and fix common Apache + VirtualHost issues

echo "-------- Apache Troubleshooting Script --------"

# 🔹 Step 1: Check Apache Status

echo "Checking Apache service"
systemctl status httpd --no-pager || systemctl start httpd

# 🔹 Step 2: Check VirtualHost Load

echo "Checking VirtualHost configuration"
httpd -S

# 🔹 Step 3: Fix Missing IncludeOptional

if ! grep -q "sites-enabled" /etc/httpd/conf/httpd.conf; then
echo "Fixing missing IncludeOptional"
echo "IncludeOptional sites-enabled/*.conf" >> /etc/httpd/conf/httpd.conf
fi

# 🔹 Step 4: Check symlinks

echo "Checking sites-enabled symlinks"
ls -l /etc/httpd/sites-enabled/

read -p "Are symlinks missing? (yes/no): " SYM
if [ "$SYM" = "yes" ]; then
read -p "Enter config file name (example: ditiss.conf): " CONF
ln -s /etc/httpd/sites-available/$CONF /etc/httpd/sites-enabled/
fi

# 🔹 Step 5: Check DNS

read -p "Enter domain to verify DNS: " DOMAIN
echo "Checking DNS resolution"
host $DOMAIN

# 🔹 Step 6: Fix permissions

read -p "Enter username for site: " USER

echo "Fixing permissions for $USER"
chmod 711 /home/$USER
chmod 755 /home/$USER/public_html
chmod 644 /home/$USER/public_html/index.html
chown -R $USER:$USER /home/$USER

# 🔹 Step 7: SELinux fix

echo "Applying SELinux fix"
setenforce 0
chcon -R -t httpd_sys_content_t /home/$USER/public_html

# 🔹 Step 8: Restart Apache

echo "Restarting Apache"
systemctl restart httpd

# 🔹 Step 9: Verify site

echo "Verification"
curl http://$DOMAIN

echo "-------- Troubleshooting Completed --------"
