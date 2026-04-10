#!/bin/bash

# --------------------------------------------------
# Question:
# 1. Create a group named 'devgrp'
# 2. Create a user 'alpha' with:
#       - Home directory: /home/alpha
#       - Shell: /bin/bash
#       - Primary group: devgrp
# 3. Create a file /home/alpha/project.txt
# 4. Set file permission to 640
# 5. Display permissions in:
#       - Numeric format
#       - Symbolic format
# --------------------------------------------------

# -------------------------------
# Step 1: Create group
# -------------------------------
groupadd devgrp

# -------------------------------
# Step 2: Create user
# -m : create home directory
# -d : specify home directory path
# -s : assign shell
# -g : set primary group
# -------------------------------
useradd -m -d /home/alpha -s /bin/bash -g devgrp alpha

# -------------------------------
# Step 3: Create file
# Ensure directory exists
# -------------------------------
mkdir -p /home/alpha
touch /home/alpha/project.txt

# -------------------------------
# Step 4: Set permissions
# 640 = rw- r-- ---
# -------------------------------
chmod 640 /home/alpha/project.txt

# Optional (better practice): set ownership explicitly
chown alpha:devgrp /home/alpha/project.txt

# -------------------------------
# Step 5: Verify permissions
# -------------------------------

# Numeric permissions (e.g., 640)
stat -c "%a" /home/alpha/project.txt

# Symbolic permissions (e.g., -rw-r-----)
stat -c "%A" /home/alpha/project.txt

# Also show full listing
ls -l /home/alpha/project.txt
