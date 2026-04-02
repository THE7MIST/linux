#!/bin/bash

# ==========================================================
# simplePrompt.sh → Minimal Matrix-style Bash Prompt
# ==========================================================
#
# WHAT THIS FILE IS:
# This is NOT a script you "run" manually.
# It is a shell configuration file that gets LOADED automatically
# when a user logs in (if placed in /etc/profile.d/).
#
# ----------------------------------------------------------
# 1) HOW TO USE / RUN THIS
# ----------------------------------------------------------
# Step 1: Copy this file into system profile directory:
#   sudo cp simplePrompt.sh /etc/profile.d/
#
# Step 2: Set correct permissions:
#   sudo chmod 644 /etc/profile.d/simplePrompt.sh
#
# Step 3: Apply immediately (without logout):
#   source /etc/profile
#
# Step 4: Open new terminal OR login again
#
#  Now prompt will be active for ALL users permanently
#
# ----------------------------------------------------------
# 2) IF NOT USING AS SCRIPT (ALTERNATIVE METHOD)
# ----------------------------------------------------------
# You can directly add this line into user config:
#
#   vim ~/.bashrc
#
# Add:
#   export PS1="\[\e[1;32m\]\u \w\[\e[0m\]\n🐧 "
#
# Then apply:
#   source ~/.bashrc
#
# ✔ This applies ONLY to that user (not system-wide)
#
# ----------------------------------------------------------
#  IMPORTANT TECH NOTE
# ----------------------------------------------------------
# Avoid using $(pwd) in PS1 because:
# - It becomes STATIC (updates only at login)
# - Does NOT change when you cd into directories
#
#  Correct dynamic approach → use \w instead
#
# ----------------------------------------------------------
# WHAT THIS PROMPT SHOWS
# ----------------------------------------------------------
# - Username
# - Absolute working directory
# - Green "Matrix" color
# - New line for command
# - 🐧 emoji before command
#
# ==========================================================


# Apply only for interactive bash shells
case "$-" in
    *i*) ;;
      *) return ;;
esac

# Set Matrix-style green prompt (DYNAMIC)
export PS1="\[\e[1;32m\]\u \w\[\e[0m\]\n🐧 "
