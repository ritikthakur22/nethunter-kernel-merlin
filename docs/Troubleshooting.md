# Troubleshooting & Hidden Mechanics

## 1. The Realtek Monitor Mode Secret
If you plug in your Realtek adapter and use `iwconfig wlan2 mode monitor` but receive:
**`Error for wireless request "Set Mode" (8B06) : SET failed on device wlan2 ; Operation not permitted.`**

This happens because Realtek monolithic drivers (`rtl8188fu`, `88XXau`, `8188eu`) behave fundamentally differently than standard `mac80211` native drivers (like Atheros chips).
Realtek drivers put the firmware entirely to sleep if the interface is brought `down`. If the firmware is asleep, it rejects the monitor mode command.

**The Fix:**
You MUST ensure the interface is `UP` before setting monitor mode!
```bash
# Correct Way:
ifconfig wlan2 up
iwconfig wlan2 mode monitor

# DO NOT DO THIS (It will fail):
ifconfig wlan2 down
iwconfig wlan2 mode monitor
```
Also, do not use `airmon-ng` to start monitor mode (it tries to spawn a `mon` interface and downs the parent interface, which Realtek drivers do not support natively without custom wrappers). Just run `wifite -i wlan2 --no-airmon`.

## 2. Fixing USB "Charging Only" Boot Default
For penetration testers, having your Android phone default to "Charging Only" when plugged into a PC is incredibly annoying for ADB usage. 

To forcefully and persistently make your phone default to MTP (File Transfer) and ADB:
1. Open a terminal on your phone (Termux / NetHunter)
2. Run `su` to get root
3. Run: `setprop persist.sys.usb.config mtp,adb`

## 3. Host Compiling (.relr.dyn Error)
If you get `ld: unknown type [0x13] section '.relr.dyn'` while compiling, your Clang cross-compiler linker (`ld.lld`) is trying to link host tools with your Arch Linux modern `glibc`.
Fix this by ensuring you explicitly pass the `CC`, `LD`, and `CROSS_COMPILE` strings in the `make` command, rather than exporting Clang to your global `$PATH`. This ensures `HOSTCC` (which compiles the tools on your PC) uses your Arch Linux native GCC, while the kernel uses Proton Clang.
