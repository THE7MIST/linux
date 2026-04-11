#!/bin/bash

# Script Name: 03_OS_Hardening_Menu

# Purpose: Apply selected OS hardening controls and show verification

echo "-------- OS Hardening Menu --------"
echo "1) Disable SELinux (temporary)"
echo "2) Enable SELinux (enforcing)"
echo "3) Set password policy (min length + complexity)"
echo "4) Disable root SSH login"
echo "5) Disable password SSH login (key-based only)"
echo "6) Configure firewall (allow SSH + HTTP only)"
echo "7) Disable unused services"
echo "8) Set file permission security (home dirs)"
echo "9) Enable logging check"
echo "10) Exit"

while true
do
read -p "Select option: " opt

```
case $opt in

1)
    echo "Disabling SELinux temporarily"
    setenforce 0
    echo "Verify:"
    getenforce
    ;;

2)
    echo "Enabling SELinux enforcing mode"
    setenforce 1
    echo "Verify:"
    getenforce
    ;;

3)
    echo "Setting password policy"
    read -p "Enter minimum password length: " LEN
    sed -i "s/^PASS_MIN_LEN.*/PASS_MIN_LEN $LEN/" /etc/login.defs
    echo "Verify:"
    grep PASS_MIN_LEN /etc/login.defs
    ;;

4)
    echo "Disabling root SSH login"
    sed -i 's/^#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
    systemctl restart sshd
    echo "Verify:"
    grep PermitRootLogin /etc/ssh/sshd_config
    ;;

5)
    echo "Disabling password authentication for SSH"
    sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config
    systemctl restart sshd
    echo "Verify:"
    grep PasswordAuthentication /etc/ssh/sshd_config
    ;;

6)
    echo "Configuring firewall (SSH + HTTP only)"
    firewall-cmd --set-default-zone=public
    firewall-cmd --add-service=ssh --permanent
    firewall-cmd --add-service=http --permanent
    firewall-cmd --remove-service=ftp --permanent
    firewall-cmd --reload
    echo "Verify:"
    firewall-cmd --list-all
    ;;

7)
    echo "Disabling unused services"
    read -p "Enter service name to disable: " SVC
    systemctl stop $SVC
    systemctl disable $SVC
    echo "Verify:"
    systemctl status $SVC
    ;;

8)
    echo "Securing home directory permissions"
    read -p "Enter username: " USER
    chmod 700 /home/$USER
    echo "Verify:"
    ls -ld /home/$USER
    ;;

9)
    echo "Checking system logs"
    read -p "Enter log file path (example /var/log/messages): " LOG
    tail -10 $LOG
    ;;

10)
    echo "Exiting hardening menu"
    break
    ;;

*)
    echo "Invalid option"
    ;;

esac

echo "------------------------------------"
```

done

