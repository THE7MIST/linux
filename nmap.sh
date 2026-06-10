```bash
#!/bin/bash

mkdir -p reports

TARGETS=(
    "groww.in"
    "drop.com"
    "103.115.197.122"
    "81.71.19.30"
)

for TARGET in "${TARGETS[@]}"
do
    SAFE_NAME=$(echo "$TARGET" | sed 's/[^a-zA-Z0-9._-]/_/g')

    XML_FILE="reports/${SAFE_NAME}.xml"
    HTML_FILE="reports/${SAFE_NAME}.html"

    echo "[+] Scanning $TARGET"

    nmap -sS -sV -T4 --min-rate 1000 -p 1-49152 "$TARGET" -oX "$XML_FILE"

    if [ $? -eq 0 ]; then
        xsltproc /usr/share/nmap/nmap.xsl "$XML_FILE" -o "$HTML_FILE"

        echo "[+] Generated:"
        echo "    $XML_FILE"
        echo "    $HTML_FILE"
    else
        echo "[!] Scan failed for $TARGET"
    fi

    echo "----------------------------------------"
done

echo "[+] All scans completed."
```
