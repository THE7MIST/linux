#!/bin/bash

clear
echo "========================================================"
echo " DYNAMIC MAIL SERVER SETUP (POSTFIX + DOVECOT + WEBMAIL)"
echo "========================================================"
sleep 2

# -------------------------------
# INPUT SECTION
# -------------------------------
read -p "Enter Server IP: " SERVER_IP
read -p "Enter domain name (example.com): " DOMAIN

read -p "Enter username to create: " USERNAME
read -s -p "Enter password: " PASSWORD
echo ""

echo "Select Protocol:"
echo "1) POP3"
echo "2) IMAP"
echo "3) BOTH"
read -p "Enter choice: " PROTOCOL

# -------------------------------
# INSTALLATION
# -------------------------------
echo "[INFO] Installing packages..."
sleep 2

dnf install postfix dovecot httpd squirrelmail mailx -y

echo "[OK] Installation complete"
sleep 3

# -------------------------------
# USER CREATION
# -------------------------------
echo "[INFO] Creating user..."
sleep 2

id "$USERNAME" &>/dev/null || useradd "$USERNAME"
echo "$PASSWORD" | passwd --stdin "$USERNAME"

echo "[OK] User created"
sleep 3

# -------------------------------
# POSTFIX CONFIG
# -------------------------------
echo "[INFO] Configuring Postfix..."
sleep 2

postconf -e "myhostname = mail.$DOMAIN"
postconf -e "mydomain = $DOMAIN"
postconf -e "myorigin = \$mydomain"
postconf -e "inet_interfaces = all"
postconf -e "mydestination = \$myhostname, localhost.\$mydomain, localhost, \$mydomain"

systemctl enable postfix
systemctl restart postfix

echo "[OK] Postfix configured"
sleep 3

# -------------------------------
# DOVECOT CONFIG
# -------------------------------
echo "[INFO] Configuring Dovecot..."
sleep 2

# protocol selection
if [ "$PROTOCOL" == "1" ]; then
    PROTO="pop3"
elif [ "$PROTOCOL" == "2" ]; then
    PROTO="imap"
else
    PROTO="imap pop3 lmtp"
fi

sed -i "s/^#protocols.*/protocols = $PROTO/" /etc/dovecot/dovecot.conf
sed -i "s/^#listen.*/listen = */" /etc/dovecot/dovecot.conf

# auth
sed -i "s/^#disable_plaintext_auth.*/disable_plaintext_auth = no/" /etc/dovecot/conf.d/10-auth.conf
echo "auth_mechanisms = plain login" >> /etc/dovecot/conf.d/10-auth.conf

# SSL disable
sed -i "s/^ssl = .*/ssl = no/" /etc/dovecot/conf.d/10-ssl.conf

# mail location
sed -i "s|^#mail_location.*|mail_location = mbox:~/mail:INBOX=/var/spool/mail/%u|" /etc/dovecot/conf.d/10-mail.conf

# permission fix
chmod 666 /var/spool/mail/* 2>/dev/null

systemctl enable dovecot
systemctl restart dovecot

echo "[OK] Dovecot configured"
sleep 3

# -------------------------------
# FIREWALL
# -------------------------------
echo "[INFO] Configuring firewall..."
sleep 2

firewall-cmd --zone=public --add-service={smtp,pop3,imap,http} --permanent
firewall-cmd --reload

echo "[OK] Firewall configured"
sleep 3

# -------------------------------
# APACHE + SQUIRRELMAIL
# -------------------------------
echo "[INFO] Configuring Webmail..."
sleep 2

mkdir -p /etc/httpd/sites-available
mkdir -p /etc/httpd/sites-enabled

cat <<EOF > /etc/httpd/sites-available/squirrel.conf
Alias /webmail /usr/share/squirrelmail

<Directory /usr/share/squirrelmail>
    Options Indexes FollowSymLinks
    AllowOverride All
    Require all granted
</Directory>
EOF

ln -s /etc/httpd/sites-available/squirrel.conf /etc/httpd/sites-enabled/squirrel.conf 2>/dev/null

setenforce 0

systemctl enable httpd
systemctl restart httpd

echo "[OK] Webmail ready"
sleep 3

# -------------------------------
# SERVICE CHECK
# -------------------------------
echo "[INFO] Verifying ports..."
sleep 2

lsof -i:25
lsof -i:110
lsof -i:143

sleep 3

# -------------------------------
# CLIENT INSTRUCTIONS
# -------------------------------
echo "========================================================"
echo "CLIENT SIDE STEPS"
echo "========================================================"

echo "1. Open browser"
echo "2. Go to: http://$SERVER_IP/webmail"
echo "3. Login using:"
echo "   Username: $USERNAME"
echo "   Password: (given)"
echo "4. Send mail to another local user"

sleep 3

# -------------------------------
# TROUBLESHOOTING
# -------------------------------
echo "========================================================"
echo "COMMON ERRORS"
echo "========================================================"

echo "If mail not working:"
echo "- Check service: systemctl status postfix dovecot"
echo "- Check ports: lsof -i:25,110,143"
echo "- Check firewall"
echo "- Check logs: /var/log/maillog"

sleep 3

# -------------------------------
# SCREENSHOTS SECTION
# -------------------------------
echo "========================================================"
echo "SCREENSHOTS FOR EXAM"
echo "========================================================"

echo "[SCREENSHOT] Installation → dnf install postfix dovecot httpd squirrelmail"
echo "[SCREENSHOT] Postfix status → systemctl status postfix"
echo "[SCREENSHOT] Dovecot status → systemctl status dovecot"
echo "[SCREENSHOT] Ports → lsof -i:25,110,143"
echo "[SCREENSHOT] Firewall → firewall-cmd --list-all"
echo "[SCREENSHOT] Config file → cat /etc/dovecot/dovecot.conf | grep protocols"
echo "[SCREENSHOT] Webmail page → http://$SERVER_IP/webmail"
echo "[SCREENSHOT] Mail send test → mail -s test user"
echo "[SCREENSHOT] Logs → tail -f /var/log/maillog"

echo "========================================================"
echo "[DONE] MAIL SERVER READY"
echo "========================================================"



# =========================================================
# MAIL SERVER NOTES (POSTFIX + DOVECOT + SQUIRRELMAIL)
# =========================================================

# Postfix Mail Server -- SMTP -- 25 -- MTA
# Dovecot: IMAP and POP server

# PORT DETAILS
# SMTP  - 25  - postfix
# POP3  - 110 - dovecot
# IMAP  - 143 - dovecot

# INSTALL DOVECOT
# dnf install dovecot -y

# MAIN CONFIG
# vim /etc/dovecot/dovecot.conf
# Line 24 - uncomment
# protocols = imap pop3 lmtp

# Line 30 - uncomment (if not using IPv6)
# listen = *, ::

# vim /etc/dovecot/conf.d/10-master.conf

# POSTFIX SMTP AUTH
# unix_listener auth-userdb {
#     mode = 0666
#     user = postfix
#     group = postfix
# }

# vim /etc/dovecot/conf.d/10-auth.conf
# Line 10
# disable_plaintext_auth = no

# Line 100
# auth_mechanisms = plain login

# vim /etc/dovecot/conf.d/10-ssl.conf
# Line 8
# ssl = no

# vim /etc/dovecot/conf.d/10-mail.conf
# mail_location = maildir:~/Maildir
# mail_location = mbox:~/mail:INBOX=/var/spool/mail/%u

# chmod 666 /var/spool/mail/*

# ENABLE SERVICES
# systemctl enable dovecot
# systemctl start dovecot

# PORT CHECK
# lsof -i:110
# lsof -i:143
# lsof -i:25

# FIREWALL
# firewall-cmd --zone=public --add-service={smtp,imap,pop3} --permanent
# firewall-cmd --reload

# =========================================================
# APACHE CONFIG FOR SQUIRRELMAIL
# =========================================================

# vim /etc/httpd/sites-available/squirrel.conf

# Alias /webmail /usr/share/squirrelmail

# <Directory /usr/share/squirrelmail>
#     Options Indexes FollowSymLinks
#     AllowOverride All
#     Require all granted
#
#     <Files "*.php">
#         Require all granted
#     </Files>
# </Directory>

# ln -s /etc/httpd/sites-available/squirrel.conf /etc/httpd/sites-enabled/squirrel.conf

# setenforce 0
# systemctl restart httpd