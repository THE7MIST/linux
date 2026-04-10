#!/bin/bash

# --------------------------------------------------
# Question:
# 1. Create a group named 'devgrp'
# 2. Create a user 'beta'
# 3. Create a file /opt/data.txt
# 4. Set ownership:
#       - User: beta
#       - Group: devgrp
# 5. Provide full sudo access to user 'beta' using visudo
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
# -------------------------------
chown beta:devgrp /opt/data.txt

# -------------------------------
# Step 5: Grant sudo access (visudo method)
# -------------------------------

# NOTE:
# visudo opens an editor safely.
# Add the following line manually inside visudo:

# beta ALL=(ALL) ALL

visudo

# -------------------------------
# Step 6: Verification
# -------------------------------

# Check ownership
ls -l /opt/data.txt

# Check sudo privileges for beta
sudo -l -U beta
