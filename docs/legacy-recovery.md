# Legacy recovery baseline

## Recovery image construction

The strongest public recovery evidence is the `cm-14.1` branch of
[HighwayStar/android_device_lenovo_TB8704](https://github.com/HighwayStar/android_device_lenovo_TB8704/tree/cm-14.1):

- `BoardConfig.mk` selects `Image.gz-dtb`, base `0x80000000`, kernel offset
  `0x8000`, tags offset `0x100`, ramdisk offset `0x01000000`, and 2048-byte
  pages.
- `BOARD_BOOTIMAGE_PARTITION_SIZE` and
  `BOARD_RECOVERYIMAGE_PARTITION_SIZE` are both `67108864` bytes.
- `TARGET_RECOVERY_FSTAB` points to `rootdir/fstab.qcom`.
- `twrp.mk` adds the recovery root directory, enables `TW_INCLUDE_CRYPTO`,
  blacklists `hbtp_vm`, and selects `portrait_hdpi`.
- `proprietary-files-twrp.txt` identifies QSEE/DRM files copied into the
  recovery ramdisk. Their use is a later implementation concern and is not
  validated here.

The tree's `twrp.fstab` includes internal partitions, microSD as
`/dev/block/mmcblk1p1` with whole-device fallback, and USB OTG as
`/dev/block/sda1` with whole-device fallback. The exact image produced by this
tree and its test results are not available from the repository history.

## F-only reference

The F-only brianreboot tree at commit `508409d8dcdf2084a5a165e07babe013d1854494`
supplies a prebuilt kernel, recovery init/USB/ueventd files, and a TWRP fstab.
Its BoardConfig uses the same 64 MiB boot/recovery limits and kernel offsets,
enables crypto/QSEE options, and sets `androidboot.selinux=permissive enforcing=0`.
The source does not prove that the image boots or that permissive policy is
acceptable.

## Known source-level capabilities

The kernel configuration and device files expose ext4, VFAT, exFAT, NTFS,
USB storage, Android USB gadget, MMC/SDHCI, framebuffer/MDSS, Goodix GT9XX,
and dm-crypt support. These indicate intended capability only; they are not
claims of successful TWRP operation on this tablet.

## Known risks

- The tree's OTA assertion includes TB-8704X, F, N and V.
- `rootdir/fstab.qcom` contains `encryptable=footer`; decryption requires the
  matching legacy crypto/QSEE environment and a real encrypted data test.
- The public TWRP-named X repository is empty, so it cannot independently
  corroborate the Maintainer tree.
- No public source in this inventory proves the bootloader's exact handling of
  temporary recovery boot versus the dedicated recovery partition.

## Baseline decision

Use the HighwayStar tree as a forensic reference only. After review, a new
recovery tree may be derived from the verified portions, but no file is
imported during Phase 0.
