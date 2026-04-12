#!/bin/bash

echo "======================================================="
echo "SQUID PROXY AUTOMATED LAB SCRIPT (DYNAMIC)"
echo "======================================================="
sleep 3

# -------------------------------
# INSTALL SQUID
# -------------------------------
echo "[STEP 1] Installing Squid Proxy..."
sleep 3

if command -v dnf &>/dev/null; then
    dnf install squid -y
else
    apt update && apt install squid -y
fi

echo "[INFO] Installation completed"
echo "[SCREENSHOT] Installation success output"
sleep 3

# -------------------------------
# SERVICE START
# -------------------------------
echo "[STEP 2] Starting and enabling Squid service..."
sleep 3

systemctl start squid
systemctl enable squid

echo "[INFO] Service started"
echo "[SCREENSHOT] systemctl status squid"
sleep 3

# -------------------------------
# USER INPUT SECTION
# -------------------------------
echo "[STEP 3] Enter configuration inputs"
sleep 2

read -p "Enter allowed IP/network (e.g., 192.168.1.0/24): " IP_RANGE
read -p "Enter Squid Port (default 3128): " PORT
PORT=${PORT:-3128}

echo "Choose Action Type:"
echo "1) Block Domain"
echo "2) Allow Only Domain"
echo "3) Block File Types"
echo "4) Block Keywords"
read -p "Enter choice [1-4]: " ACTION

# -------------------------------
# CONFIG BACKUP
# -------------------------------
echo "[STEP 4] Taking backup of config"
sleep 3
cp /etc/squid/squid.conf /etc/squid/squid.conf.bak

# -------------------------------
# BASIC CONFIG
# -------------------------------
echo "[STEP 5] Applying base configuration"
sleep 3

cat > /etc/squid/squid.conf <<EOF
http_port $PORT

acl allowed_net src $IP_RANGE
http_access allow allowed_net
EOF

# -------------------------------
# ACTION HANDLING
# -------------------------------

if [ "$ACTION" == "1" ]; then
    read -p "Enter domains to BLOCK (space separated): " DOMAINS
    echo "[INFO] Blocking domains..."
    sleep 2

    echo "acl block_sites dstdomain $DOMAINS" >> /etc/squid/squid.conf
    echo "http_access deny block_sites" >> /etc/squid/squid.conf

    echo "[SCREENSHOT] squid.conf with blocked domains"

elif [ "$ACTION" == "2" ]; then
    read -p "Enter domains to ALLOW (space separated): " DOMAINS
    echo "[INFO] Allowing only specific domains..."
    sleep 2

    echo "acl allow_sites dstdomain $DOMAINS" >> /etc/squid/squid.conf
    echo "http_access allow allow_sites" >> /etc/squid/squid.conf
    echo "http_access deny all" >> /etc/squid/squid.conf

    echo "[SCREENSHOT] whitelist config"

elif [ "$ACTION" == "3" ]; then
    read -p "Enter file extensions (e.g., mp3 mp4 torrent): " FILES
    echo "[INFO] Blocking file types..."
    sleep 2

    for f in $FILES; do
        echo "\\.$f$" >> /etc/squid/blockfiles.txt
    done

    echo "acl block_files urlpath_regex \"/etc/squid/blockfiles.txt\"" >> /etc/squid/squid.conf
    echo "http_access deny block_files" >> /etc/squid/squid.conf

    echo "[SCREENSHOT] blockfiles.txt + config"

elif [ "$ACTION" == "4" ]; then
    read -p "Enter keywords (e.g., gambling bad): " WORDS
    echo "[INFO] Blocking keywords..."
    sleep 2

    for w in $WORDS; do
        echo "$w" >> /etc/squid/keywords.txt
    done

    echo "acl bad_words url_regex \"/etc/squid/keywords.txt\"" >> /etc/squid/squid.conf
    echo "http_access deny bad_words" >> /etc/squid/squid.conf

    echo "[SCREENSHOT] keywords.txt + config"
fi

# -------------------------------
# FINAL RULE
# -------------------------------
echo "[STEP 6] Adding final allow rule"
sleep 2

echo "http_access allow all" >> /etc/squid/squid.conf

# -------------------------------
# FIREWALL
# -------------------------------
echo "[STEP 7] Configuring firewall"
sleep 3

firewall-cmd --add-service=squid --permanent 2>/dev/null
firewall-cmd --reload 2>/dev/null

echo "[SCREENSHOT] firewall-cmd output"

# -------------------------------
# VALIDATION
# -------------------------------
echo "[STEP 8] Validating configuration"
sleep 3

squid -k parse

if [ $? -ne 0 ]; then
    echo "[ERROR] Config syntax error"
    echo "[FIX] Restore backup:"
    echo "cp /etc/squid/squid.conf.bak /etc/squid/squid.conf"
    exit 1
fi

# -------------------------------
# RESTART SERVICE
# -------------------------------
echo "[STEP 9] Restarting Squid"
sleep 3

systemctl restart squid

echo "[SCREENSHOT] systemctl status squid"

# -------------------------------
# LOG CHECK
# -------------------------------
echo "[STEP 10] Checking logs"
sleep 3

ls /var/log/squid

echo "[SCREENSHOT] access.log"

# -------------------------------
# CLIENT INSTRUCTIONS
# -------------------------------
echo "======================================================="
echo "CLIENT SIDE INSTRUCTIONS"
echo "======================================================="
sleep 3

echo "1. Open browser settings"
echo "2. Go to proxy settings"
echo "3. Set manual proxy:"
echo "   IP: <SERVER_IP>"
echo "   PORT: $PORT"
echo "4. Try accessing blocked site"
echo "5. Check if it is denied"

echo "[SCREENSHOT] Browser proxy settings + blocked page"

# -------------------------------
# TROUBLESHOOTING
# -------------------------------
echo "======================================================="
echo "COMMON ERRORS & FIXES"
echo "======================================================="
sleep 3

echo "1. Not working?"
echo "   -> Check service: systemctl status squid"

echo "2. Access still allowed?"
echo "   -> Check rule order (deny must be before allow)"

echo "3. No internet?"
echo "   -> Check firewall or IP range"

echo "4. Config error?"
echo "   -> squid -k parse"

echo "5. Logs not updating?"
echo "   -> tail -f /var/log/squid/access.log"



echo "[SCREENSHOT] Installation success → command: dnf/apt install squid -y → show last success lines"

echo "[SCREENSHOT] Service status → command: systemctl status squid → show Active (running)"

echo "[SCREENSHOT] squid.conf (blocked domains) → file: /etc/squid/squid.conf → command: cat /etc/squid/squid.conf | grep -i block"

echo "[SCREENSHOT] squid.conf (whitelist) → file: /etc/squid/squid.conf → command: cat /etc/squid/squid.conf | grep -i allow"

echo "[SCREENSHOT] blockfiles config → file: /etc/squid/blockfiles.txt → command: cat /etc/squid/blockfiles.txt AND cat /etc/squid/squid.conf | grep block_files"

echo "[SCREENSHOT] keywords config → file: /etc/squid/keywords.txt → command: cat /etc/squid/keywords.txt AND cat /etc/squid/squid.conf | grep bad_words"

echo "[SCREENSHOT] Firewall rule → command: firewall-cmd --list-all | grep squid OR firewall-cmd --list-ports"

echo "[SCREENSHOT] Service verification → command: systemctl status squid → confirm running after restart"

echo "[SCREENSHOT] Logs → file: /var/log/squid/access.log → command: tail -f /var/log/squid/access.log (show live request)"

echo "[SCREENSHOT] Client proxy config → browser settings → manual proxy IP: <SERVER_IP> PORT: 3128"

echo "[SCREENSHOT] Block test → open browser → try youtube.com/facebook.com → show Access Denied page"


#http_port 3128

#http_access deny all
#http_port 3128

#a#cl allowed_net src 192.168.220.0/24
#http_access allow allowed_net

#acl block_sites dstdomain .youtube.com .facebook.com
#acl SSL_ports port 443
#acl CONNECT method CONNECT

#http_access deny CONNECT block_sites
#http_access deny block_sites

#http_access allow all