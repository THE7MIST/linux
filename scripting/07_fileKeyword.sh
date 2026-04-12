#!/bin/bash

# ==================================================
# FILE: log_analyzer.sh
# PURPOSE:
#   Search keyword in file and show matching lines
#   with line numbers
# ==================================================

echo "--------- Keyword Finder ---------"

# Step 1: Take input
read -p "Enter file path (e.g. /path/file.txt): " filename
read -p "Enter keyword to search: " keyword

# Step 2: Check file exists
if [ ! -f "$filename" ]; then
    echo "Error: File does not exist!"
    exit 1
fi

# Step 3: Search and display results
echo "Matching lines with line numbers:"
echo "-------------------------------------"

grep -iEn "$keyword" "$filename"
# -i → case-insensitive
# -E → extended regex (optional but good)
# -n → show line numbers

# Step 4: End
echo "Search complete."