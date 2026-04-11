#!/bin/bash

#############################################

# SCRIPT: Log File Analyzer

# PURPOSE:

# - Count total lines in log.txt

# - Count lines containing "error" (case-insensitive)

# - Display last 5 error lines

#############################################

# Input file

FILE="log.txt"

# Check if file exists

if [ ! -f "$FILE" ]; then
echo "Error: $FILE not found!"
exit 1
fi

echo "========== LOG ANALYSIS =========="

# Total lines in file

echo "Total lines in file:"
wc -l < "$FILE"

# Count lines containing "error" (case-insensitive)

echo "Total lines containing 'error':"
grep -i "error" "$FILE" | wc -l

# Show last 5 error lines

echo "Last 5 error lines:"
grep -i "error" "$FILE" | tail -5

echo "=================================="
