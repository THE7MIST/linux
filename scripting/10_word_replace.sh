#!/bin/bash

# ==================================================
# FILE: replace_word.sh
# PURPOSE:
#   Replace a word in a file using user input
#   and display updated content
# ==================================================

# -------------------------------
# Step 1: Take inputs
# -------------------------------
# read -p → prompt user and store input
read -p "Enter filename: " filename
read -p "Enter word to search: " old
read -p "Enter replacement word: " new

# -------------------------------
# Step 2: Check file exists
# -------------------------------
# -f → checks if file exists
if [ ! -f "$filename" ]; then echo "Error: File does not exist!"; exit 1; fi

# -------------------------------
# Step 3: Replace word in file
# -------------------------------
# sed → stream editor
# s/old/new/g → replace all occurrences (g = global)
# -i → modify file in place

sed -i "s/$old/$new/g" "$filename"

# -------------------------------
# Step 4: Show updated content
# -------------------------------
echo "Updated file content:"
cat "$filename"