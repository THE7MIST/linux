#!/bin/bash

# ============================================
# FILE: 01_reference_uid_gid.sh
# PURPOSE: Quick reference for user/group system
# ============================================

# UID & GID RANGES
# UID:
# 0 → root
# 1–999 → system users
# 1000+ → regular users

# GID:
# 0 → root group
# 1–999 → system groups
# 1000+ → regular groups

# CHECK USER INFO
id username        # Shows UID, GID
groups username    # Shows groups

# IMPORTANT FILES
cat /etc/passwd    # user info
cat /etc/shadow    # password (encrypted)
cat /etc/group     # group info

# USER MANAGEMENT
useradd username
usermod -aG group username
userdel -r username

# PASSWORD MANAGEMENT
passwd username
chage -l username

# PERMISSIONS CHECK
ls -l file
stat -c "%a" file
stat -c "%A" file