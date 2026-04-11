#!/bin/bash

###############################
# VSFTPD AUTO SETUP SCRIPT
# SERVER SIDE ONLY
###############################

echo "---- Installing vsftpd ----"
dnf install vsftpd -y

echo "---- Starting and enabling service ----"
systemctl start vsftpd
systemctl enable vsftpd

echo "---- Verifying service ----"
systemctl status vsftpd

echo "---- Checking port 21 ----"
lsof -i:21

echo "---- Configuring firewall ----"
firewall-cmd --add-service=ftp --permanent
firewall-cmd --reload
firewall-cmd --list-all

echo "---- User Creation ----"
read -p "Enter username to create: " USERNAME
useradd $USERNAME

echo "Set password for $USERNAME"
passwd $USERNAME

echo "---- Creating file in FTP public directory ----"
read -p "Enter filename to create (example: test.txt): " FILENAME

mkdir -p /var/ftp/pub
touch /var/ftp/pub/$FILENAME

echo "File created at: /var/ftp/pub/$FILENAME"

echo "---- Restarting vsftpd ----"
systemctl restart vsftpd

echo "---- FINAL SERVER STATUS ----"
systemctl status vsftpd
lsof -i:21

###############################
# CLIENT INSTRUCTIONS
###############################

echo ""
echo "=========== CLIENT SIDE STEPS ==========="
echo "1. Install ftp client:"
echo "   dnf install ftp -y"
echo ""
echo "2. Connect to server:"
echo "   ftp <server-ip>"
echo ""
echo "3. Login using:"
echo "   Username: $USERNAME"
echo "   Password: (the one you set)"
echo ""
echo "4. Check file:"
echo "   ls"
echo ""
echo "5. Download file:"
echo "   get $FILENAME"
echo ""
echo "6. Upload file:"
echo "   put filename"
echo ""
echo "7. Exit:"
echo "   bye"
echo "========================================"