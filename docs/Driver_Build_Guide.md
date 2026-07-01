# External Wi-Fi Driver Build Guide

Building Realtek external Wi-Fi drivers natively inside an Android kernel tree is historically a nightmare due to missing `.h` files and outdated C paradigms. We bypass this by building them **Out-Of-Tree**.

## 1. Cloning the Standalone Drivers
```bash
mkdir -p ~/kernel_build/drivers && cd ~/kernel_build/drivers
git clone https://github.com/kelebek333/rtl8188fu.git      # Adapter 1
git clone https://github.com/aircrack-ng/rtl8812au.git      # Adapter 2
git clone https://github.com/aircrack-ng/rtl8188eus.git     # Adapter 3
```

## 2. Fixing Android Compilation Bugs
Mobile kernels are stripped down. You must manually patch the standalone driver code before attempting to compile them against your kernel headers.

### Bug 1: `console_suspend_enabled` Mismatch
Open `os_dep/linux/usb_intf.c` in all three driver folders. Search for `console_suspend_enabled`.
The driver uses an `int`, but Android 13 kernels use a `bool`. Change it to match:
```c
extern bool console_suspend_enabled;
```

### Bug 2: Missing `wlan_plat.h` and GCC Flags
Specifically for `aircrack-ng/rtl8812au`, open the `Makefile`:
1. Delete `EXTRA_CFLAGS += -Wno-stringop-overread` (Clang doesn't support this GCC flag).
2. Delete `-DRTW_ENABLE_WIFI_CONTROL_FUNC` (Android 13 lacks `wlan_plat.h` for external devices).

### Bug 3: Enable Monitor Mode
Ensure `CONFIG_WIFI_MONITOR = y` is set to `y` in all three driver Makefiles.

## 3. Cross-Compiling the `.ko` files
Run the exact same compile command you used for the kernel, but inside the driver folder, and point `KSRC` to the kernel's `out` directory.

```bash
cd ~/kernel_build/drivers/rtl8188fu
make clean
make -j$(nproc --all) \
    KSRC="$HOME/kernel_build/kernel_source/out" \
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

Once finished, grab your `.ko` files (`rtl8188fu.ko`, `88XXau.ko`, `8188eu.ko`) and proceed to the Magisk packaging guide.
