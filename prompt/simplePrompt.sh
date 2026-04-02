#!/bin/bash

# ==============================
# Simple Prompt Installer
# ==============================

GREEN="\[\e[1;32m\]"
RESET="\[\e[0m\]"
PROMPT='export PS1="\[\e[1;32m\]\u \w\[\e[0m\]\n🐧 "'

# Get script directory (robust path handling)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

clear

# ==============================
# SHOW BANNER (FIRST)
# ==============================
if [ -f "$SCRIPT_DIR/../bin/pic/banner.txt" ]; then
    cat "$SCRIPT_DIR/../bin/pic/banner.txt"
else
    echo "⚠ Banner not found"
fi

echo ""
echo "=============================="
echo "  SIMPLE PROMPT INSTALLER"
echo "=============================="
echo "1) Permanent (All users)"
echo "2) Temporary (Current session)"
echo "3) User-only (~/.bashrc)"
echo "4) Exit"
echo "=============================="

read -p "Choose option [1-4]: " choice

case $choice in

1)
    echo "[*] Setting system-wide prompt..."

    if [[ $EUID -ne 0 ]]; then
        echo "❌ Run as root. Don't be lazy."
        exit 1
    fi

    echo "$PROMPT" > /etc/profile.d/simplePrompt.sh
    chmod 644 /etc/profile.d/simplePrompt.sh

    # Ensure applied for all shells
    if ! grep -q "simplePrompt" /etc/bashrc; then
        echo "$PROMPT" >> /etc/bashrc
    fi

    source /etc/bashrc

    echo "✅ Permanent prompt applied (all users)"
    ;;

2)
    echo "[*] Applying temporary prompt..."

    eval "$PROMPT"

    echo "✅ Temporary prompt applied"
    ;;

3)
    echo "[*] Applying user-only prompt..."

    # Avoid duplicate entries
    if ! grep -q "🐧" ~/.bashrc; then
        echo "$PROMPT" >> ~/.bashrc
    fi

    source ~/.bashrc

    echo "✅ Applied for current user"
    ;;

4)
    echo "Bye. Stay efficient."
    exit 0
    ;;

*)
    echo "💀 Invalid input. Even bash expects better from you."
    echo "👉 Run again and choose 1–4 properly."
    exit 1
    ;;

esac
