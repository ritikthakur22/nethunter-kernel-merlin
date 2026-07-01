#!/bin/bash
# Packages the Magisk module for systemless Wi-Fi driver persistence

set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$DIR")"

MAGISK_DIR="$BASE_DIR/magisk"
OUT_ZIP="$BASE_DIR/releases/Magisk/NetHunter_WiFi_Drivers_Magisk.zip"

echo "[*] Packaging Magisk Module..."
cd "$MAGISK_DIR"
# Using python zipfile module as a fallback if 'zip' is not installed
python3 -m zipfile -c "$OUT_ZIP" *

echo "[+] Magisk Module created at $OUT_ZIP"
