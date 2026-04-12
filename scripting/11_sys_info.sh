#!/bin/bash

# ==================================================
# FILE: system_info.sh
# PURPOSE:
#   Display selected system information inline
# ==================================================

# -------------------------------
# Current logged-in user
# -------------------------------
echo -n "Current User: "
whoami

echo "--------------------------------"

# -------------------------------
# Hostname
# -------------------------------
echo -n "Hostname: "
hostname

echo "--------------------------------"

# -------------------------------
# Operating System (only NAME)
# -------------------------------
# awk extracts NAME value from /etc/os-release
echo -n "Operating System: "
awk -F= '/^NAME=/{gsub(/"/,"",$2); print $2}' /etc/os-release

echo "--------------------------------"

# -------------------------------
# Kernel version
# -------------------------------
echo -n "Kernel Version: "
uname -r

echo "--------------------------------"

# -------------------------------
# System uptime (only time)
# -------------------------------
# awk prints uptime time fields
echo -n "System Uptime: "
uptime | awk '{print $3, $4}'

echo "--------------------------------"

# -------------------------------
# Memory (only total and free)
# -------------------------------
# NR==2 selects memory row
echo -n "Memory (Total/Free): "
free -h | awk 'NR==2 {print $2, "/", $4}'

echo "--------------------------------"