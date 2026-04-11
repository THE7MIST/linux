#!/bin/bash

# ============================================
# FILE: 02_user_group_permissions.sh
# PURPOSE: User + group + file permissions setup
# ============================================

# Create group
groupadd devgrp

# Create user with home + shell + group
useradd -m -d /home/alpha -s /bin/bash -g devgrp alpha

# Create file
mkdir -p /home/alpha
touch /home/alpha/project.txt

# Set permission (640 = rw- r-- ---)
chmod 640 /home/alpha/project.txt

# Set ownership
chown alpha:devgrp /home/alpha/project.txt

# Verify
stat -c "%a" /home/alpha/project.txt
stat -c "%A" /home/alpha/project.txt
ls -l /home/alpha/project.txt