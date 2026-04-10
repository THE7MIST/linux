#!/bin/bash

# --------------------------------------------------
# Question:
# Create a file /tmp/secure.txt.
# Assign ACL permissions:
#   - User 'alpha' should have rwx access
#   - Group 'devgrp' should have read-only (r--) access
# Verify that ACL is applied.
# --------------------------------------------------

# Step 1: Create file
touch /tmp/secure.txt

# Step 2: Assign ACL to user alpha
setfacl -m u:alpha:rwx /tmp/secure.txt

# Step 3: Assign ACL to group devgrp
setfacl -m g:devgrp:r-- /tmp/secure.txt

# Step 4: Verify ACL
getfacl /tmp/secure.txt
ls -l /tmp/secure.txt
