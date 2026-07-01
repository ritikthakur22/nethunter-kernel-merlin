#!/bin/bash
# Packages the Image.gz-dtb into an AnyKernel3 flashable zip

set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$DIR")"

AK3_DIR="$BASE_DIR/kernel/AnyKernel3"
KERNEL_IMAGE="$BASE_DIR/kernel_source/out/arch/arm64/boot/Image.gz-dtb"
OUT_ZIP="$BASE_DIR/releases/Kernel/Nethunter-Kernel-Merlin-A13.zip"

echo "[*] Copying Image.gz-dtb to AnyKernel3 directory..."
cp "$KERNEL_IMAGE" "$AK3_DIR/"

echo "[*] Packaging AnyKernel3..."
cd "$AK3_DIR"
# Using python zipfile module as a fallback if 'zip' is not installed
python3 -m zipfile -c "$OUT_ZIP" *

echo "[+] AnyKernel3 package created at $OUT_ZIP"
