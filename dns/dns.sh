#!/bin/bash

###############################

#  IMPORTANT BEFORE RUNNING

###############################
echo "=========================================="
echo "  RUN THIS SCRIPT AS ROOT USER ONLY"
echo "  CONFIGURE NETWORK FIRST USING: nmtui"
echo "  ENSURE CORRECT STATIC IP IS SET"
echo "=========================================="
sleep 5

###############################

# DNS AUTO SETUP SCRIPT (BIND)

###############################

echo "===== DNS SETUP START ====="

###############################

# 1. INSTALL PACKAGES

###############################
echo "[+] Installing BIND packages..."
dnf install -y bind bind-utils

###############################

# 2. USER INPUT

###############################
echo "===== ENTER DETAILS ====="

read -p "Enter Domain Name (e.g., ditiss.com): " DOMAIN
read -p "Enter Hostname (e.g., server200): " HOST
read -p "Enter Server IP (e.g., 192.168.220.130): " IP

###############################

# DERIVED VALUES

###############################
REV_ZONE=$(echo $IP | awk -F. '{print $3"."$2"."$1".in-addr.arpa"}')
LAST_OCTET=$(echo $IP | awk -F. '{print $4}')

echo "Reverse Zone: $REV_ZONE"
echo "PTR Record Number: $LAST_OCTET"

###############################

# 3. CONFIGURE named.conf

###############################
echo "[+] Configuring /etc/named.conf..."

cat > /etc/named.conf <<EOF

options {
listen-on port 53 { $IP; };
directory "/var/named";
allow-query { any; };
recursion yes;
};

zone "." IN {
type hint;
file "named.ca";
};

zone "$DOMAIN" IN {
type master;
file "frwd.$DOMAIN";
};

zone "$REV_ZONE" IN {
type master;
file "rvs.$DOMAIN";
};

EOF

###############################

# 4. CREATE ZONE FILES

###############################
cd /var/named

echo "[+] Creating Forward Zone File..."

cat > frwd.$DOMAIN <<EOF
$TTL 1D
@   IN SOA $HOST.$DOMAIN. admin.$DOMAIN. (
1
1D
1H
1W
3H )

@       IN NS   $HOST.$DOMAIN.

$DOMAIN.   IN A    $IP
www        IN A    $IP
$HOST      IN A    $IP
EOF

echo "[+] Creating Reverse Zone File..."

cat > rvs.$DOMAIN <<EOF
$TTL 1D
@   IN SOA $HOST.$DOMAIN. admin.$DOMAIN. (
1
1D
1H
1W
3H )

@   IN NS $HOST.$DOMAIN.

$LAST_OCTET IN PTR $HOST.$DOMAIN.
EOF

###############################

# 5. PERMISSIONS

###############################
echo "[+] Setting permissions..."

chown root:named frwd.$DOMAIN rvs.$DOMAIN
chmod 640 frwd.$DOMAIN rvs.$DOMAIN

###############################

# 6. ENABLE & START SERVICE

###############################
echo "[+] Starting DNS service..."

systemctl enable named
systemctl restart named

###############################

# 7. FIREWALL

###############################
echo "[+] Configuring firewall..."

firewall-cmd --add-service=dns --permanent
firewall-cmd --reload

###############################

# 8. VERIFICATION

###############################
echo "===== TEST RESULTS ====="

echo "[Forward Lookup]"
host $DOMAIN
host $HOST.$DOMAIN

echo "[Reverse Lookup]"
host $IP

###############################

# 9. DEBUG (AUTO CHECK)

###############################
echo "[+] Checking configuration..."

named-checkconf
named-checkzone $DOMAIN /var/named/frwd.$DOMAIN
named-checkzone $REV_ZONE /var/named/rvs.$DOMAIN

echo "===== DNS SETUP COMPLETE ====="
