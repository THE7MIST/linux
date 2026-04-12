#!/bin/bash

# ==================================================
# FILE: system_monitor.sh
# PURPOSE:
#   Display disk usage, CPU usage, and top processes
#   in clean inline format using basic commands + awk
# ==================================================

# -------------------------------
# Disk usage (mounted partitions)
# -------------------------------
# df -h → human-readable disk usage
# NR==1 → header, NR>1 → data lines
echo "Disk Usage:"
df -h | awk 'NR==1 || NR>1 {print $1, $5, $6}'
# $1 → filesystem
# $5 → usage %
# $6 → mount point

echo "--------------------------------"

# -------------------------------
# CPU usage percentage
# -------------------------------
# top -bn1 → one-time snapshot
# awk extracts CPU idle and calculates usage
echo -n "CPU Usage: "
top -bn1 | awk '/Cpu/ {print 100 - $8 "%"}'
# $8 → idle CPU, so usage = 100 - idle

echo "--------------------------------"

# -------------------------------
# Top 5 CPU consuming processes
# -------------------------------
# ps aux → process list
# --sort=-%cpu → sort descending by CPU usage
# head -6 → header + top 5
echo "Top 5 CPU Processes:"
ps aux --sort=-%cpu | awk 'NR==1 || NR<=6 {print $1, $2, $3, $11}'
# $1 → user
# $2 → PID
# $3 → CPU %
# $11 → command

echo "--------------------------------"