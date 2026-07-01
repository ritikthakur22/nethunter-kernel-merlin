# Kernel Build Guide

## 1. Prerequisites
You will need a Linux host (Arch Linux, Ubuntu) with basic compilation utilities:
```bash
sudo pacman -S flex bison bc base-devel python python-pip
# OR
sudo apt install flex bison bc build-essential python3 python3-pip
```

## 2. Cloning the Source
Instead of using older, potentially broken GCC versions, this project relies on **Proton-Clang**.

```bash
mkdir -p ~/kernel_build && cd ~/kernel_build

# Clone Clang
git clone --depth=1 https://github.com/kdrag0n/proton-clang clang

# Clone Kernel Source (LineageOS 20)
git clone --depth=1 -b lineage-20 https://github.com/lineageos/android_kernel_xiaomi_mt6768 kernel_source
```

## 3. Configuring the Defconfig
Edit your device's defconfig (e.g. `arch/arm64/configs/merlin_defconfig`):

```text
# Enable NetHunter HID
CONFIG_USB_CONFIGFS_F_HID=y
CONFIG_USB_CONFIGFS_MASS_STORAGE=y
CONFIG_HIDRAW=y

# Enable Wireless Injection Support
CONFIG_MAC80211=y
CONFIG_CFG80211=y
CONFIG_MAC80211_INJECT=y

# Disable Broken Internal Wi-Fi Patches (CRITICAL)
CONFIG_RTL8188FU=n
CONFIG_RTL8188EU=n
CONFIG_88XXAU=n
```

## 4. Compilation
```bash
cd kernel_source
make O=out clean
make O=out mrproper
make O=out ARCH=arm64 merlin_defconfig

make -j$(nproc --all) O=out \
    ARCH=arm64 \
    CC="$HOME/kernel_build/clang/bin/clang" \
    CROSS_COMPILE="$HOME/kernel_build/clang/bin/aarch64-linux-gnu-" \
    CROSS_COMPILE_ARM32="$HOME/kernel_build/clang/bin/arm-linux-gnueabi-" \
    LD="$HOME/kernel_build/clang/bin/ld.lld" \
    AR="$HOME/kernel_build/clang/bin/llvm-ar" \
    NM="$HOME/kernel_build/clang/bin/llvm-nm" \
    OBJCOPY="$HOME/kernel_build/clang/bin/llvm-objcopy" \
    OBJDUMP="$HOME/kernel_build/clang/bin/llvm-objdump" \
    STRIP="$HOME/kernel_build/clang/bin/llvm-strip"
```

## 5. Packaging (AnyKernel3)
Use `AnyKernel3` to create a TWRP flashable zip. Make sure you set `do.systemless=1` in `anykernel.sh` so you do not break Magisk root!
```bash
cp out/arch/arm64/boot/Image.gz-dtb ../AnyKernel3/
cd ../AnyKernel3
python3 -m zipfile -c Nethunter-Kernel-Merlin-A13.zip *
```
Flash `Nethunter-Kernel-Merlin-A13.zip` in TWRP.
