#!/bin/bash
# Standalone Wi-Fi Module Build Script
# Compiles RTL8188FU, RTL8812AU, and RTL8188EUS against the custom kernel

set -e

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$DIR")"

CLANG_DIR="$BASE_DIR/clang"
KSRC_DIR="$BASE_DIR/kernel_source/out"
MODULES_DIR="$BASE_DIR/drivers"

export CC="$CLANG_DIR/bin/clang"
export CROSS_COMPILE="$CLANG_DIR/bin/aarch64-linux-gnu-"
export CROSS_COMPILE_ARM32="$CLANG_DIR/bin/arm-linux-gnueabi-"
export LD="$CLANG_DIR/bin/ld.lld"
export AR="$CLANG_DIR/bin/llvm-ar"
export NM="$CLANG_DIR/bin/llvm-nm"
export OBJCOPY="$CLANG_DIR/bin/llvm-objcopy"
export OBJDUMP="$CLANG_DIR/bin/llvm-objdump"
export STRIP="$CLANG_DIR/bin/llvm-strip"
export ARCH=arm64

build_module() {
    local mod_path=$1
    echo "[*] Building module in $mod_path..."
    cd "$mod_path"
    make clean
    make -j$(nproc --all) KSRC="$KSRC_DIR"
    echo "[+] Done compiling $mod_path"
}

build_module "$MODULES_DIR/rtl8188fu"
build_module "$MODULES_DIR/rtl8812au"
build_module "$MODULES_DIR/rtl8188eus"

echo "[+] All modules compiled successfully."
