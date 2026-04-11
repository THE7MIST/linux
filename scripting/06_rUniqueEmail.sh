#!/bin/bash

# ==========================================================
# FILE: email_extractor.sh
# PURPOSE:
#   Extract valid email addresses from a user-provided file
#   and display only unique results.
# ==========================================================

# -------------------------------
# Step 1: Take filename input
# -------------------------------
read -p "Enter filename: " filename
# -p → displays prompt message on same line

# -------------------------------
# Step 2: Validate file existence
# -------------------------------
if [ ! -f "$filename" ]; then
    echo "Error: File does not exist!"
    exit 1
fi

# -------------------------------
# Step 3: Extract emails
# -------------------------------
echo "Valid unique email addresses found:"

grep -iEo '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' "$filename" | sort -u
# -i → case-insensitive 
# -E → extended regex
# -o → print only matched part (emails)
# sort -u → remove duplicates

# -------------------------------
# Step 4: Completion message
# -------------------------------
echo "✅ Extraction complete."