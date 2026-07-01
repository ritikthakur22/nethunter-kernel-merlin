# Magisk Module Persistence Guide

Desktop Linux uses `udev` to automatically detect a USB adapter and run `modprobe` to load the matching driver. Android does not.

If you don't use Magisk, you will be forced to manually type `insmod /path/to/driver.ko` as root every single time you reboot the phone. We fix this by creating a Magisk module that injects the drivers systemlessly and runs a boot script.

## 1. Module Structure
Create the following structure inside your Magisk module folder:

```text
magisk/
├── module.prop
├── service.sh
└── system/
    └── vendor/
        └── lib/
            └── modules/
                ├── 8188eu.ko
                ├── 88XXau.ko
                └── rtl8188fu.ko
```

## 2. module.prop
```text
id=nethunter_wifi_drivers
name=NetHunter External WiFi Drivers
version=v1.0
versionCode=1
author=YourName
description=Systemlessly auto-loads RTL8188FU, RTL8821AU, and RTL8188EUS drivers for packet injection.
```

## 3. service.sh
```bash
#!/system/bin/sh
# Wait until the system has fully booted
until [ "$(getprop sys.boot_completed)" = "1" ]; do
    sleep 1
done

# Load the Wi-Fi modules securely on boot
insmod /vendor/lib/modules/rtl8188fu.ko
insmod /vendor/lib/modules/88XXau.ko
insmod /vendor/lib/modules/8188eu.ko
```

## 4. Packaging and Deployment
```bash
python3 -m zipfile -c NetHunter_WiFi_Drivers_Magisk.zip *
adb push NetHunter_WiFi_Drivers_Magisk.zip /sdcard/Download/
```
Flash the zip using the Magisk App (Install from Storage) and reboot. The drivers will now load natively like a standard desktop Linux system.
