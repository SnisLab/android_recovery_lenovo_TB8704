# TB-8704F device verification record

The read-only verification was completed and reviewed. Do not substitute any
write, wipe, format, erase, or flash command.

## Verified device facts

- Model: `Lenovo TB-8704F`.
- The current build fingerprint uses a TB-8704X designation. This is not
  evidence that the physical device is an X variant.
- Kernel: `3.18.140-lineageos-g217079fec494`.
- Slot properties are empty; no A/B partition names and no dynamic/super
  partition layout were found.
- `boot` and `recovery` are separate partitions.
- Crypto state: `encrypted`; crypto type: `block`.

The `/proc/cmdline` read was denied by permissions. This is a recorded
verification limitation and is not a Phase-0 blocker.

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

The reviewed physical map is recorded in `docs/partitions.md`.

## Recovery capabilities

```sh
getprop ro.crypto.state
getprop ro.crypto.type
getprop sys.usb.config
cat /proc/mounts
cat /proc/filesystems
dmesg | grep -iE 'mmc|sdhci|dwc3|usb|mdss|framebuffer|touch|goodix|qsee|keymaster|crypt'
```

The commands above were used as a read-only capability check. Display/touch,
USB/ADB, removable-storage behavior, and QSEE/keymaster behavior remain
feature-test items rather than claims of working recovery functionality.

## Safety gate

Phase 0 read-only identity, partition-map, and boot/recovery verification is
complete. No recovery image was built or booted as part of this verification.
