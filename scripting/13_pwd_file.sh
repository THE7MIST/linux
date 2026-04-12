#!/bin/bash

# ==================================================
# FILE: password_policy.sh
# PURPOSE:
#   Classify passwords from passwords.txt as:
#   Weak / Normal / Strong based on given rules
# ==================================================

# -------------------------------
# Step 1: Input file
# -------------------------------
read -p "Enter password file (e.g., passwords.txt): " file

# -------------------------------
# Step 2: Check file exists
# -------------------------------
if [ ! -f "$file" ]; then echo "Error: File does not exist!"; exit 1; fi

# -------------------------------
# Step 3: Process each password
# -------------------------------
echo "Password Classification:"
echo "--------------------------------"

# Read file line by line
while read password
do
    # Get length of password
    length=${#password}

    # -------------------------------
    # Strong Password
    # -------------------------------
    # Contains at least one allowed special character
    if [[ "$password" =~ [!@#\$%\^&*\(\)_+\-=] ]]; then
        echo "$password → STRONG"

    # -------------------------------
    # Weak Password
    # -------------------------------
    # Length 1–7 AND only letters/digits
    elif [[ $length -ge 1 && $length -le 7 && "$password" =~ ^[A-Za-z0-9]+$ ]]; then
        echo "$password → WEAK"

    # -------------------------------
    # Normal Password
    # -------------------------------
    # Length 8–12 AND only letters/digits
    elif [[ $length -ge 8 && $length -le 12 && "$password" =~ ^[A-Za-z0-9]+$ ]]; then
        echo "$password → NORMAL"

    # -------------------------------
    # Invalid (optional)
    # -------------------------------
    else
        echo "$password → INVALID"
    fi

done < "$file"

echo "--------------------------------"
echo "Processing complete."