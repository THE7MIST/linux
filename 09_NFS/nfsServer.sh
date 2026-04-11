#!/bin/bash

# =========================================================
# NFS SERVER AUTO SETUP SCRIPT
# =========================================================

# Check root
if [ "$EUID" -ne 0 ]; then
  echo "Run as root"
  exit
fi

echo "===== NFS SERVER SETUP START ====="

# Ask user for file name
read -p "Enter file name to create in /data: " FILENAME

# Install NFS
echo "[+] Installing NFS packages..."
dnf install -y nfs-utils

# Create directory
echo "[+] Creating /data directory..."
mkdir -p /data

# Create file
echo "[+] Creating file..."
touch /data/$FILENAME

# Set permissions
echo "[+] Setting permissions..."
chmod -R 755 /data

# Configure exports (ALLOW ALL)
echo "[+] Configuring /etc/exports..."
cat <<EOF > /etc/exports
/data   *(rw,sync,no_root_squash)
EOF

# Apply export
echo "[+] Applying export configuration..."
exportfs -rav

# Start & enable services
echo "[+] Starting and enabling services..."
systemctl enable --now rpcbind
systemctl enable --now nfs-server

# Restart services (as required)
echo "[+] Restarting services..."
systemctl restart rpcbind
systemctl restart nfs-server

# Status check
echo "[+] Service status:"
systemctl status nfs-server --no-pager

# Firewall configuration
echo "[+] Configuring firewall..."
firewall-cmd --add-service=nfs --permanent
firewall-cmd --reload

echo "[+] Firewall status:"
firewall-cmd --list-all

# Show exports
echo "[+] Export verification:"
showmount -e localhost

# Get server IP
SERVER_IP=$(hostname -I | awk '{print $1}')

# =========================================================
# CLIENT INSTRUCTIONS
# =========================================================

echo ""
echo "===== CLIENT SIDE STEPS ====="
echo ""
echo "1) Install NFS:"
echo "   dnf install -y nfs-utils"
echo ""
echo "2) Create mount point:"
echo "   mkdir -p /mnt"
echo ""
echo "3) Temporary mount:"
echo "   mount -t nfs $SERVER_IP:/data /mnt"
echo ""
echo "4) Verify:"
echo "   df -h"
echo "   ls /mnt"
echo ""
echo "5) Permanent mount:"
echo "   echo '$SERVER_IP:/data /mnt nfs defaults 0 0' >> /etc/fstab"
echo "   mount -a"
echo ""
echo "6) Test root access:"
echo "   touch /mnt/root_test"
echo "   ls -l /mnt"
echo ""
echo "===== SETUP COMPLETE ====="