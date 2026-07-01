#!/bin/bash
# Kernel Build Script for Redmi Note 9 (Merlin) - Android 13
# Requires proton-clang in ../clang and kernel source in ../kernel_source

set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$DIR")"

CLANG_DIR="$BASE_DIR/clang"
KERNEL_DIR="$BASE_DIR/kernel_source"
OUT_DIR="$KERNEL_DIR/out"

export CC="$CLANG_DIR/bin/clang"
export CROSS_COMPILE="$CLANG_DIR/bin/aarch64-linux-gnu-"
export CROSS_COMPILE_ARM32="$CLANG_DIR/bin/arm-linux-gnueabi-"
export LD="$CLANG_DIR/bin/ld.lld"
export AR="$CLANG_DIR/bin/llvm-ar"
export NM="$CLANG_DIR/bin/llvm-nm"
export OBJCOPY="$CLANG_DIR/bin/llvm-objcopy"
export OBJDUMP="$CLANG_DIR/bin/llvm-objdump"
export STRIP="$CLANG_DIR/bin/llvm-strip"

cd "$KERNEL_DIR"
echo "[*] Cleaning tree..."
make O=out clean
make O=out mrproper

echo "[*] Generating defconfig..."
make O=out ARCH=arm64 merlin_defconfig

echo "[*] Compiling Kernel..."
make -j$(nproc --all) O=out ARCH=arm64

echo "[+] Build complete. Image is at $OUT_DIR/arch/arm64/boot/Image.gz-dtb"
