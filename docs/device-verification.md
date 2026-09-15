# TB-8704F device verification plan

This plan is read-only. Do not substitute any write, wipe, format, erase, or
flash command.

## Identity and boot mode

```sh
getprop ro.product.device
getprop ro.product.model
getprop ro.build.fingerprint
getprop ro.bootloader
getprop ro.boot.slot_suffix
getprop ro.boot.slot
cat /proc/cmdline
```

## Partition map

```sh
cat /proc/partitions
ls -l /dev/block/bootdevice/by-name
for p in /dev/block/bootdevice/by-name/*; do printf '%s ' "$p"; blockdev --getsize64 "$p"; done
```

Compare names and sizes with `docs/partitions.md`, especially `boot`,
`recovery`, `userdata`, `config` versus `frp`, `persist`, `dsp`, and modem/EFS.

## Recovery capabilities

```sh
getprop ro.crypto.state
getprop ro.crypto.type
getprop sys.usb.config
cat /proc/mounts
cat /proc/filesystems
dmesg | grep -iE 'mmc|sdhci|dwc3|usb|mdss|framebuffer|touch|goodix|qsee|keymaster|crypt'
```

Record display, touch, storage, USB/ADB, and crypto/QSEE observations without
changing properties or mounting critical partitions read-write.

## Safety gate

Do not proceed to image boot or partition operations until identity, map,
boot/recovery arrangement, and a reviewed read-only capture are complete.
