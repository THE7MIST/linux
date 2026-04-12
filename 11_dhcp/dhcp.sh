#!/bin/bash

echo "========================================================"
echo " DHCP SERVER COMPLETE SETUP (CENTOS)"
echo "========================================================"
sleep 3

# ---------------- USER INPUT ----------------

echo "[INPUT] Enter Network details"
read -p "Enter Network (e.g., 192.168.1.0): " NETWORK
read -p "Enter Subnet Mask (e.g., 255.255.255.0): " NETMASK
read -p "Enter Range Start IP: " RANGE_START
read -p "Enter Range End IP: " RANGE_END
read -p "Enter Gateway IP: " GATEWAY
read -p "Enter DNS Server: " DNS

echo "--------------------------------------------------------"
echo "[INFO] You entered:"
echo "Network: $NETWORK"
echo "Range: $RANGE_START - $RANGE_END"
echo "Gateway: $GATEWAY"
echo "DNS: $DNS"
echo "--------------------------------------------------------"
sleep 3

# ---------------- INSTALL DHCP ----------------

echo "[STEP 1] Installing DHCP Server package"
echo "COMMAND: dnf install dhcp-server -y"
sleep 3
dnf install dhcp-server -y

echo "[INFO] Screenshot: show installation success"
sleep 3

# ---------------- CONFIG FILE ----------------

echo "[STEP 2] Configuring DHCP"
echo "[INFO] File: /etc/dhcp/dhcpd.conf"
echo "[INFO] This is the MAIN configuration file"
sleep 3

cat > /etc/dhcp/dhcpd.conf <<EOF
subnet $NETWORK netmask $NETMASK {
range $RANGE_START $RANGE_END;
option routers $GATEWAY;
option domain-name-servers $DNS;
default-lease-time 600;
max-lease-time 7200;
}
EOF

echo "[INFO] Configuration written successfully"
echo "[INFO] Screenshot: cat /etc/dhcp/dhcpd.conf"
sleep 3

# ---------------- INTERFACE FIX ----------------

echo "[STEP 3] Setting correct network interface"
echo "[INFO] File: /etc/sysconfig/dhcpd"
sleep 3

INTERFACE=$(ip route | grep default | awk '{print $5}')

echo "DHCPDARGS=$INTERFACE" > /etc/sysconfig/dhcpd

echo "[INFO] Interface detected: $INTERFACE"
echo "[INFO] Screenshot: cat /etc/sysconfig/dhcpd"
sleep 3

# ---------------- START SERVICE ----------------

echo "[STEP 4] Starting DHCP Service"
echo "COMMAND: systemctl start dhcpd"
sleep 3
systemctl start dhcpd

echo "[STEP 5] Enabling DHCP Service"
echo "COMMAND: systemctl enable dhcpd"
sleep 3
systemctl enable dhcpd

echo "[INFO] Screenshot: systemctl status dhcpd"
sleep 3

# ---------------- FIREWALL ----------------

echo "[STEP 6] Allowing DHCP in Firewall"
echo "COMMAND: firewall-cmd --add-service=dhcp --permanent"
sleep 3
firewall-cmd --add-service=dhcp --permanent

echo "COMMAND: firewall-cmd --reload"
sleep 3
firewall-cmd --reload

echo "[INFO] Screenshot: firewall-cmd --list-all"
sleep 3

# ---------------- VERIFICATION ----------------

echo "[STEP 7] Verifying DHCP Server"
echo "COMMAND: systemctl status dhcpd"
sleep 3
systemctl status dhcpd

echo "COMMAND: ss -tulnp | grep 67"
sleep 3
ss -tulnp | grep 67

echo "[INFO] Screenshot: DHCP running on port 67"
sleep 3

# ---------------- COMMON ERRORS ----------------

echo "========================================================"
echo "[COMMON ERRORS]"
echo "1. Wrong interface in /etc/sysconfig/dhcpd"
echo "2. Firewall not allowed"
echo "3. Syntax error in dhcpd.conf"
echo "4. Service not restarted"
echo "5. Server not having static IP"
echo "========================================================"
sleep 3

# ---------------- CLIENT STEPS ----------------

echo "========================================================"
echo "[CLIENT SIDE STEPS]"
echo "1. Set client to DHCP mode"
echo "   nmtui -> Automatic (DHCP)"
echo ""
echo "2. Restart network"
echo "   systemctl restart NetworkManager"
echo ""
echo "3. Check IP"
echo "   ip a"
echo ""
echo "4. Release & Renew (if needed)"
echo "   dhclient -v"
echo ""
echo "[EXPECTED RESULT]"
echo "Client should get IP from range:"
echo "$RANGE_START - $RANGE_END"
echo ""
echo "[SCREENSHOT]"
echo "Client IP using 'ip a'"
echo "========================================================"

echo "[DONE] DHCP Server Setup Completed Successfully"
