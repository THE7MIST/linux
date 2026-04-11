#!/bin/bash

#############################################

# SCRIPT: User Info Extractor

# PURPOSE:

# - Read /etc/passwd

# - Show first 5 users

# - Show last 5 users

# - Display only username and shell

#############################################

FILE="/etc/passwd"

echo "========== USER INFO =========="

# First 5 users

echo "First 5 users (username : shell):"
head -5 "$FILE" | awk -F: '{print $1 " : " $7}'

echo "--------------------------------"

# Last 5 users

echo "Last 5 users (username : shell):"
tail -5 "$FILE" | awk -F: '{print $1 " : " $7}'

echo "================================"
