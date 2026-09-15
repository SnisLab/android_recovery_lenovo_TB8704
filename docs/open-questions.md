# Open questions after Phase 0

- Read the physical TB-8704F model/build fingerprints and bootloader version.
- Enumerate `/dev/block/bootdevice/by-name`, `/proc/partitions`, and partition
  sizes. Confirm whether `config` or `frp` is present and which names are
  actually exposed.
- Confirm A-only versus A/B from slots, fstab, and bootloader metadata.
- Confirm whether boot and recovery are separate writable partitions and how a
  temporary recovery boot is accepted by this exact device.
- Preserve hashes and read-only backups of stock boot, recovery, persist,
  misc, system, userdata metadata, and critical firmware before experiments.
- Identify the exact display panel, framebuffer dimensions, Goodix touch model,
  and whether touch firmware needs a vendor payload in recovery.
- Test internal eMMC, microSD, USB OTG, USB gadget/ADB, and recovery logs.
- Test unencrypted data, footer-encrypted data, and the behavior when QSEE or
  keymaster services are unavailable. Decryption failure must not trigger a
  destructive format.
- Find a complete build manifest/toolchain for the 3.18 legacy kernel and
  verify the exact TB-8704F DTB, because the public branch also contains V
  variants.
- Establish evidence for actual working/broken features of the legacy TWRP
  build; source configuration alone is insufficient.
