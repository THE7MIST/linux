#!/bin/bash

#############################################

# SCRIPT: File Size Reporter

# PURPOSE:

# - Find files larger than 1MB in /home

# - Display file name and size

#############################################

DIR="/home"

echo "========== FILE SIZE REPORT =========="

# Find files >1MB and print name + size

find "$DIR" -type f -size +1M | while read FILE
do
SIZE=$(du -h "$FILE" | awk '{print $1}')
echo "File: $FILE | Size: $SIZE"
done

echo "======================================"
