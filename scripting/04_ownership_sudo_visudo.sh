#!/bin/bash

# ============================================
# FILE: 04_ownership_sudo_visudo.sh
# PURPOSE: Ownership + sudo (visudo method)
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

# Grant sudo using visudo
echo "Run 'visudo' and add:"
echo "beta ALL=(ALL) ALL"

visudo

# Verify
ls -l /opt/data.txt
sudo -l -U beta
