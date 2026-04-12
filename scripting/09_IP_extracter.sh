#!/bin/bash

# ==================================================
# FILE: ip_extractor.sh
# PURPOSE:
#   Extract IPv4 addresses using simple regex
#   and validate them using basic tools
# ==================================================

# -------------------------------
# Step 1: Take filename input
# -------------------------------
read -p "Enter filename: " filename

# -------------------------------
# Step 2: Check file exists
# -------------------------------
# -f → checks if file exists
if [ ! -f "$filename" ]; then echo "Error: File does not exist!"; exit 1; fi

# -------------------------------
# Step 3: Extract possible IPs
# -------------------------------
# [0-9]\{1,3\} → 1 to 3 digits
# \. → dot
# repeated 3 times for first 3 octets

echo "Possible IP addresses:"

grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' "$filename"

# -------------------------------
# Step 4: Validate IP range (0–255)
# -------------------------------
# awk splits using '.' and checks each part

echo "Valid IP addresses (0–255 range):"

grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' "$filename" | \
awk -F. '{ if ($1<=255 && $2<=255 && $3<=255 && $4<=255) print $0 }'