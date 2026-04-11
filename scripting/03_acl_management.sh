#!/bin/bash

# ============================================
# FILE: 03_acl_management.sh
# PURPOSE: Apply ACL permissions
# ============================================

# Create file
touch /tmp/secure.txt

# Assign ACL
setfacl -m u:alpha:rwx /tmp/secure.txt
setfacl -m g:devgrp:r-- /tmp/secure.txt

# Verify ACL
getfacl /tmp/secure.txt
ls -l /tmp/secure.txt