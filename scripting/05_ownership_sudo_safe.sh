#!/bin/bash

# ============================================
# FILE: 05_ownership_sudo_safe.sh
# PURPOSE: Ownership + sudo (automated safe)
# ============================================

# Create group
groupadd devgrp

# Create user
useradd beta

# Create file
mkdir -p /opt
touch /opt/data.txt

# Set ownership
chown beta:devgrp /opt/data.txt

# Grant sudo safely
echo "beta ALL=(ALL) ALL" > /etc/sudoers.d/beta
chmod 440 /etc/sudoers.d/beta

# Verify
ls -l /opt/data.txt
sudo -l -U beta