#!/bin/bash

#############################################

# SCRIPT: File Finder & Counter

# PURPOSE:

# - Find all .txt files in current directory

# - Display their names

# - Count total number of such files

#############################################

echo "========== TXT FILE SEARCH =========="

# Find .txt files (current directory only)

FILES=$(find . -maxdepth 1 -type f -name "*.txt")

# Display files

echo "List of .txt files:"
echo "$FILES"

echo "------------------------------------"

# Count files

COUNT=$(echo "$FILES" | wc -l)

# Handle case when no files found

if [ -z "$FILES" ]; then
COUNT=0
fi

echo "Total .txt files found: $COUNT"

echo "===================================="
