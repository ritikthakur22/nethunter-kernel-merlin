#!/bin/bash
# Cleans the kernel tree and module directories

set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$DIR")"

echo "[*] Cleaning Kernel Source..."
cd "$BASE_DIR/kernel_source"
make O=out clean
make O=out mrproper

echo "[*] Cleaning Modules..."
for driver in rtl8188fu rtl8812au rtl8188eus; do
    cd "$BASE_DIR/drivers/$driver"
    make clean
done

echo "[+] Workspace cleaned successfully."
