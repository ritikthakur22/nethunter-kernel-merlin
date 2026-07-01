# NetHunter Custom Kernel & Wi-Fi Arsenal (Redmi Note 9 - Merlin)

![Banner](images/banner.png)

Welcome to the definitive Kali NetHunter kernel compilation project for the **Redmi Note 9 (merlin / merlinx)** running Android 13 (LineageOS 20).

This repository is designed to be the ultimate starting point for anyone who wants to compile a NetHunter kernel from scratch and securely inject fully weaponized Wi-Fi drivers for packet injection and monitor mode via Magisk.

## 🚀 Features Enabled
- **Kali NetHunter Core:** Fully compatible with the NetHunter app and chroot.
- **HID Attacks:** Rubber Ducky (`CONFIG_USB_CONFIGFS_F_HID=y`) and `CONFIG_HIDRAW=y`.
- **Mass Storage:** DriveDroid support (`CONFIG_USB_CONFIGFS_MASS_STORAGE=y`).
- **Bluetooth Attacks:** HCI UART and USB (`CONFIG_BT_HCIUSB=m`).
- **External Wi-Fi Injection:** Three custom-compiled out-of-tree Realtek drivers injected systemlessly on boot.

## 📡 Supported Wi-Fi Adapters
| Adapter | Chipset | Interface | Driver Used | Status |
|---|---|---|---|---|
| TP-Link TL-WN722N (v2/v3) | RTL8188EUS | wlan2 | aircrack-ng/rtl8188eus | Working (Injection/Monitor) |
| TP-Link Archer T2U Plus | RTL8821AU | wlan2 | aircrack-ng/rtl8812au | Working (Injection/Monitor) |
| Generic Micro Wi-Fi | RTL8188FTV | wlan2 | kelebek333/rtl8188fu | Working (Injection/Monitor) |

## 🏗️ Workflow Overview
Instead of fighting broken internal driver patches, this project completely detaches the Wi-Fi compilation from the main kernel. 
1. We cross-compile the custom Android 13 kernel with `Proton Clang`.
2. We use the generated kernel headers to cross-compile the standalone Wi-Fi drivers out-of-tree.
3. We package the kernel via `AnyKernel3` and inject the `.ko` drivers systemlessly via `Magisk`.

```mermaid
graph LR
    A[Compile Kernel] --> B[Cross-Compile Wi-Fi Drivers]
    B --> C[Magisk Injection]
```

## 📥 Downloads & Releases
Download the pre-compiled packages directly from the Releases page:
- **[Download Complete Pre-Configured Workspace (3GB)](https://github.com/ritikthakur22/nethunter-kernel-merlin/releases/tag/v1.0)** - Contains the compiled `.o` objects and full environment.
- **Magisk Compatibility:** The included `NetHunter_WiFi_Drivers_Magisk.zip` requires **Magisk v26.0+**.

## 🔗 References & Upstream Repositories
This project relies on the incredible work of the open-source community. Below are all the upstream repositories utilized:
- **Compiler:** [Proton-Clang (kdrag0n)](https://github.com/kdrag0n/proton-clang)
- **Kernel Source:** [LineageOS MT6768 / Merlin (lineage-20 branch)](https://github.com/lineageos/android_kernel_xiaomi_mt6768)
- **Packaging:** [AnyKernel3 (osm0sis)](https://github.com/osm0sis/AnyKernel3)
- **Wi-Fi Driver (RTL8188FU):** [kelebek333/rtl8188fu](https://github.com/kelebek333/rtl8188fu)
- **Wi-Fi Driver (RTL8821AU):** [aircrack-ng/rtl8812au](https://github.com/aircrack-ng/rtl8812au)
- **Wi-Fi Driver (RTL8188EUS):** [aircrack-ng/rtl8188eus](https://github.com/aircrack-ng/rtl8188eus)

## 📖 Documentation
Head over to the `docs/` directory for full step-by-step guides on recreating this exact build:
- [Kernel Build Guide](docs/Kernel_Build_Guide.md) - Learn how to compile the kernel and fix Clang compiler errors.
- [Driver Build Guide](docs/Driver_Build_Guide.md) - Learn how to patch driver source code to compile flawlessly on Android.
- [Magisk Module Generation](docs/Magisk_Module.md) - Learn how the systemless auto-boot module was made.
- [Troubleshooting & Tricks](docs/Troubleshooting.md) - The secret to putting Realtek drivers in Monitor Mode without crashing.

## 🛠️ Usage
All build scripts are available in the `tools/` directory. If you have your dependencies (`libelf`, `bison`, `python3`) setup, you can simply run:
```bash
bash tools/build_kernel.sh
bash tools/build_modules.sh
bash tools/package_kernel.sh
bash tools/package_magisk.sh
```

## 📦 Restoring the Full Workspace Archive
If you downloaded the massive `project_file.zip` chunks from the **GitHub Releases** page instead of cloning, you must fuse them together before unzipping.

Once you have downloaded `project_file.zip.part_aa`, `part_ab`, and `part_ac` into the same folder, open your terminal and run:
```bash
# Combine the split chunks into a single zip file
cat project_file.zip.part_* > complete_project_file.zip

# Unzip the fused file
unzip complete_project_file.zip
```
