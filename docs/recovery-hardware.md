# Recovery-relevant hardware

| Area | Evidence | Phase-0 conclusion |
| --- | --- | --- |
| Display/framebuffer | Maintainer kernel config enables `CONFIG_FB_MSM`, `CONFIG_FB_MSM_MDSS`; ueventd grants `/sys/devices/virtual/graphics/fb0` access. | Legacy MSM8953 framebuffer/MDSS path is expected. Actual panel and resolution remain unverified. |
| Touch | Kernel config enables `CONFIG_TOUCHSCREEN_GT9XX`; device init names Goodix touch paths and firmware `PR1702898-s3528t_...`. | Goodix is the best device-specific baseline. The source also blacklists `hbtp_vm` in TWRP. |
| Internal storage | Fstab uses `/dev/block/bootdevice/by-name`; kernel config enables MMC/SDHCI and ext4. | eMMC-style by-name storage is expected; controller and numeric partition mapping need a device readout. |
| microSD | Runtime fstab identifies `7864900.sdhci/mmc_host*`; TWRP fstab uses `mmcblk1`. | Removable microSD is supported in source; card/filesystem behavior needs testing. |
| USB / ADB | Runtime fstab identifies Qualcomm DWC3/XHCI; kernel config enables DWC3, gadget, Android USB, EHCI and USB storage. | USB gadget and OTG are intended; ADB success is not proven by source alone. |
| Data / encryption | `userdata` is ext4 with `encryptable=footer;length=-16384`; TWRP enables `TW_INCLUDE_CRYPTO`, and recovery ramdisk includes QSEE/keystore files. | Footer crypto and QSEE compatibility are the main decryption risks. Test with a non-destructive recovery boot and known encryption state later. |

The device source also exposes Goodix fingerprint and HBT P input nodes, but
fingerprint is not required for basic recovery operation.

## Bring-up acceptance criteria

Before considering a later temporary recovery boot successful, verify display,
touch, recovery log access, ADB over the physical USB port, internal storage
enumeration, read-only mounting of system/cache/persist, microSD, USB OTG,
and explicit behavior for encrypted and unencrypted data. None of these tests
was run in Phase 0.
