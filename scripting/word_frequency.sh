#!/bin/bash

#############################################

# SCRIPT: Word Frequency Checker

# PURPOSE:

# - Count occurrences of word "Linux"

# - Show line numbers where it appears

#############################################

FILE="data.txt"
WORD="Linux"

# Check file exists

if [ ! -f "$FILE" ]; then
echo "Error: $FILE not found!"
exit 1
fi

echo "========== WORD ANALYSIS =========="

# Count total occurrences (case-sensitive)

COUNT=$(grep -o "$WORD" "$FILE" | wc -l)

echo "Total occurrences of '$WORD': $COUNT"

echo "-----------------------------------"

# Show line numbers where word appears

echo "Line numbers containing '$WORD':"
grep -n "$WORD" "$FILE"

echo "==================================="
