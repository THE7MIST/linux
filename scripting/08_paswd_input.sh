#!/bin/bash

# ==================================================
# FILE: password_checker.sh
# PURPOSE:
#   Validate password strength based on:
#   1. Minimum length of 8 characters
#   2. At least one uppercase letter
#   3. At least one lowercase letter
#   4. At least one numeric digit
# ==================================================

# -------------------------------
# Step 1: Take password input (hidden)
# -------------------------------
# -s option hides user input for security (password not visible)
read -s -p "Enter password: " password

# Print a new line after input (since -s does not move cursor)
echo

# -------------------------------
# Step 2: Validate password using conditions
# -------------------------------
# ${#password} → gives length of string
# -ge 8 → checks if length is greater than or equal to 8
# [[ ]] → advanced test command that supports regex
# =~ → used to match regex pattern
# [A-Z] → checks for at least one uppercase letter
# [a-z] → checks for at least one lowercase letter
# [0-9] → checks for at least one digit
# && → logical AND (all conditions must be true)

if [[ ${#password} -ge 8 && "$password" =~ [A-Z] && "$password" =~ [a-z] && "$password" =~ [0-9] ]]; then 
    echo "Password is STRONG"; 
    else echo "Password is INVALID"
fi