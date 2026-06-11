sudo apt update

sudo apt install -y \
nmap \
whois \
dnsutils \
curl \
whatweb \
xsltproc \
libxml2-utils \
net-tools \
traceroute


#!/bin/bash

mkdir -p reports

TARGETS=(
    "drop.com"
    "tidepool.org"
    "coindcx.com"
    "coinsbit.io"
    "sfox.com"
    "winni.in"
    "droom.in"
    "groww.in"
    "103.115.197.122"
    "81.71.19.30"
    "8.138.254.206"
    "113.89.35.193"
    "58.65.193.82"
    "124.109.40.98"
    "202.59.80.87"
    "124.109.47.58"
    "38.54.79.217"
)

for TARGET in "${TARGETS[@]}"; do

    SAFE_NAME=$(echo "$TARGET" | sed 's/[^a-zA-Z0-9.-]//g')

    XML_FILE="reports/${SAFE_NAME}.xml"
    HTML_FILE="reports/${SAFE_NAME}.html"
    TXT_FILE="reports/${SAFE_NAME}.txt"
    GNMAP_FILE="reports/${SAFE_NAME}.gnmap"

    echo "======================================================"
    echo "[+] Target        : $TARGET"
    echo "[+] Started       : $(date)"
    echo "======================================================"

    nmap \
        -sS \
        -sV \
        -O \
        -Pn \
        --reason \
        --traceroute \
        --version-all \
        --script "default,banner,http-title,http-headers,http-server-header,ssl-cert,ssl-enum-ciphers" \
        -T4 \
        --min-rate 1000 \
        -p 1-49152 \
        "$TARGET" \
        -oX "$XML_FILE" \
        -oN "$TXT_FILE" \
        -oG "$GNMAP_FILE"

    if [ $? -eq 0 ]; then

        xsltproc /usr/share/nmap/nmap.xsl "$XML_FILE" -o "$HTML_FILE"

        echo "[+] Nmap completed successfully"

        echo ""
        echo "[+] DNS Information"
        host "$TARGET" 2>/dev/null

        echo ""
        echo "[+] WHOIS Information"
        whois "$TARGET" 2>/dev/null | head -50

        echo ""
        echo "[+] HTTP Headers"
        curl -I -L --max-time 10 http://"$TARGET" 2>/dev/null

        echo ""
        echo "[+] HTTPS Headers"
        curl -I -L --max-time 10 https://"$TARGET" 2>/dev/null

        echo ""
        echo "[+] Technology Fingerprinting"
        whatweb "$TARGET" 2>/dev/null

        echo ""
        echo "[+] Generated Reports"
        echo "    XML   : $XML_FILE"
        echo "    HTML  : $HTML_FILE"
        echo "    TXT   : $TXT_FILE"
        echo "    GNMAP : $GNMAP_FILE"

    else
        echo "[!] Scan failed for $TARGET"
    fi

    echo ""
    echo "[+] Finished: $(date)"
    echo "======================================================"
    echo ""

done