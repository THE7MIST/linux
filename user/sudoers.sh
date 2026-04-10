#!/bin/bash

# --------------------------------------------------
# Question:
# 1. Create a group named 'devgrp'
# 2. Create a user 'beta'
# 3. Create a file /opt/data.txt
# 4. Set ownership:
#       - User: beta
#       - Group: devgrp
# 5. Provide full sudo access to user 'beta'
# 6. Verify ownership and sudo privileges
# --------------------------------------------------

# -------------------------------
# Step 1: Create group
# -------------------------------
groupadd devgrp

# -------------------------------
# Step 2: Create user
# -------------------------------
useradd beta

# -------------------------------
# Step 3: Create file
# Ensure /opt exists
# -------------------------------
mkdir -p /opt
touch /opt/data.txt

# -------------------------------
# Step 4: Change ownership
# Format → user:group
# -------------------------------
chown beta:devgrp /opt/data.txt

# -------------------------------
# Step 5: Grant sudo access
# ⚠ Recommended: use visudo method (safe)
# -------------------------------

# Safer approach using sudoers.d
echo "beta ALL=(ALL) ALL" > /etc/sudoers.d/beta
chmod 440 /etc/sudoers.d/beta

# -------------------------------
# Step 6: Verification
# -------------------------------

# Check ownership
ls -l /opt/data.txt

# Check sudo privileges for beta
sudo -l -U beta
