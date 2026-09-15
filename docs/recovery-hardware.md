# Recovery-relevant hardware

Phase-0 physical verification is complete. The table distinguishes source
evidence from device-confirmed facts; feature operation was not tested.

| Area | Evidence | Phase-0 conclusion |
| --- | --- | --- |
| Device identity | Read-only verification reports model `Lenovo TB-8704F` and kernel `3.18.140-lineageos-g217079fec494`. The build fingerprint uses a TB-8704X designation. | TB-8704F hardware identity and kernel are physically verified; the fingerprint label is not a hardware-model proof. |
| Display/framebuffer | Maintainer kernel config enables `CONFIG_FB_MSM`, `CONFIG_FB_MSM_MDSS`; ueventd grants `/sys/devices/virtual/graphics/fb0` access. | Legacy MSM8953 framebuffer/MDSS path is expected. Actual panel and resolution remain unverified. |
| Touch | Kernel config enables `CONFIG_TOUCHSCREEN_GT9XX`; device init names Goodix touch paths and firmware `PR1702898-s3528t_...`. | Goodix is the best device-specific baseline. The source also blacklists `hbtp_vm` in TWRP. |
| Internal storage | Read-only device map reports eMMC nodes and verified mappings for boot, recovery, system, cache, persist, lenovocust, and userdata. | Physically verified eMMC layout; feature operation remains untested. |
| microSD | Runtime fstab identifies `7864900.sdhci/mmc_host*`; TWRP fstab uses `mmcblk1`. | Removable microSD is supported in source; card/filesystem behavior needs testing. |
| USB / ADB | Runtime fstab identifies Qualcomm DWC3/XHCI; kernel config enables DWC3, gadget, Android USB, EHCI and USB storage. | USB gadget and OTG are intended; ADB success is not proven by source alone. |
| Data / encryption | Device reports `encrypted`/`block`; `dm-0` is exactly 16 KiB smaller than physical userdata, matching source `encryptable=footer;length=-16384`. | Block encryption and footer length are physically confirmed; QSEE/keymaster compatibility and recovery decryption remain untested. |

The device source also exposes Goodix fingerprint and HBT P input nodes, but
fingerprint is not required for basic recovery operation.

## Bring-up acceptance criteria

Before considering a later temporary recovery boot successful, verify display,
touch, recovery log access, ADB over the physical USB port, internal storage
enumeration, read-only mounting of system/cache/persist, microSD, USB OTG,
and explicit behavior for encrypted and unencrypted data. None of these tests
was run in Phase 0.
