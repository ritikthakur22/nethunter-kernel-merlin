#!/system/bin/sh
# Wait until boot completes
until [ "$(getprop sys.boot_completed)" = "1" ]; do
    sleep 1
done

# Load the Wi-Fi modules
insmod /vendor/lib/modules/rtl8188fu.ko
insmod /vendor/lib/modules/88XXau.ko
insmod /vendor/lib/modules/8188eu.ko
