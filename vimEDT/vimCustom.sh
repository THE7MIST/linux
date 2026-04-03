#!/bin/bash

# ==========================================================
# vimCustom.sh → Professional Vim Setup Installer
# ==========================================================
#
# WHAT THIS FILE DOES
# - Configures Vim into a professional editor
# - Adds indentation, line numbers, colors, etc.
# - Supports:
#     1) User-only install (~/.vimrc)
#     2) System-wide install (/etc/vimrc)
#     3) Temporary (current session)
#
# ----------------------------------------------------------
# HOW TO RUN
# ----------------------------------------------------------
# git clone https://github.com/THE7MIST/linux.git

# cd linux/prompt
# chmod +x vimCustom.sh
# ./vimCustom.sh
#
# ----------------------------------------------------------
#  MANUAL METHOD (IF NOT USING SCRIPT)
# ----------------------------------------------------------
# vim ~/.vimrc
#
# Add:
#   set number
#   set relativenumber
#   set autoindent
#   set smartindent
#   set tabstop=4
#   set shiftwidth=4
#   set expandtab
#   syntax on
#   set background=dark
#   colorscheme desert
#
# Save and apply:
#   :wq
#
# ----------------------------------------------------------
# NOTES
# - ~/.vimrc → per user
# - /etc/vimrc → system-wide (root needed)
# - Vim reads config automatically on startup
# ==========================================================


# ==============================
# GET SCRIPT PATH
# ==============================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

clear

# ==============================
# SHOW BANNER
# ==============================
if [ -f "$SCRIPT_DIR/../bin/pic/banner.txt" ]; then
    cat "$SCRIPT_DIR/../bin/pic/banner.txt"
else
    echo "⚠ Banner not found"
fi

echo ""
echo "=============================="
echo "   VIM PRO INSTALLER"
echo "=============================="
echo "1) User-only (~/.vimrc)"
echo "2) System-wide (/etc/vimrc)"
echo "3) Temporary (this session)"
echo "4) Exit"
echo "=============================="

# ==============================
# INPUT LOOP (RETRY ON INVALID)
# ==============================
while true; do
    read -p "Choose option [1-4]: " choice

    case $choice in

    1)
        echo "[*] Configuring Vim for current user..."

        if ! grep -q "vimCustom" ~/.vimrc 2>/dev/null; then
            cat << 'EOF' >> ~/.vimrc

" ===== vimCustom config =====
set number
set relativenumber
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set cursorline
syntax on
set background=dark
colorscheme desert
" ============================
EOF
        fi

        echo "Vim configured for user"
        break
        ;;

    2)
        echo "[*] Configuring Vim system-wide..."

        if [[ $EUID -ne 0 ]]; then
            echo "Run as root. This isn't optional."
            exit 1
        fi

        cat << 'EOF' >> /etc/vimrc

" ===== vimCustom config =====
set number
set relativenumber
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set cursorline
syntax on
set background=dark
colorscheme desert
" ============================
EOF

        echo "System-wide Vim configured"
        break
        ;;

    3)
        echo "[*] Applying temporary Vim settings..."

        # Open vim with commands applied
        vim -c "set number" \
            -c "set relativenumber" \
            -c "set autoindent" \
            -c "set smartindent" \
            -c "set tabstop=4" \
            -c "set shiftwidth=4" \
            -c "set expandtab" \
            -c "set cursorline" \
            -c "syntax on" \
            -c "colorscheme desert"

        echo "Temporary session applied"
        break
        ;;

    4)
        echo "Exit. Go be productive."
        exit 0
        ;;

    *)
        echo "💀 That input was garbage. Try again properly (1-4)."
        ;;
    esac
done
