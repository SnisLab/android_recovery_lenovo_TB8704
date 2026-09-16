# Phase 1B build

## Build environment

- Distribution: Ubuntu 24.04 LTS (from Android build host detection)
- Host kernel: `Linux 7.0.14-16-pve x86_64`
- Architecture: `x86_64`
- CPUs: 14
- RAM: 16 GiB
- Free space at final build: 156 GiB
- Filesystem: ext4
- Build tree: `/root/build/twrp-12.1-recovery`
- No kernel source repository was used or modified.

## TWRP source

- Manifest: `https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git`
- Branch: `twrp-12.1`
- Pinned manifest: `manifest-pinned.xml` in the build tree
- `bootable/recovery`: `5c3d206a5eeb3d446bcda8248a405a4b278bab5c`
- `vendor/twrp`: `664ac3aa7a569d28d902734c741a629a59bab32d`
- `build/soong`: `c6c059ab28c8c67921c0838a994bb70d53594aa7`
- `system/core`: `ac4f36c7eb076ea2c582061a21dfc49eaa71e623`
- `system/tools/mkbootimg`: `b7c1a63df33e6763d2482bc9d33007f67706d131`

## Device tree

The source tree was copied from the project repository at final commit
`42c1185` (`recovery: clean up disabled crypto configuration`). The build
also includes these minimal compatibility fixes:

- `e9693d8`: declare 64-bit app support for the arm64 target.
- `aae2d2f`: select the `recovery` executable package.
- `eeed093`: disable the unavailable TWRP crypto backend.
- `62a1b28`: disable unavailable hardware disk-encryption integration.

The physical device uses legacy footer-based FDE. The TWRP `twrp-12.1`
source from the minimal manifest used here does not support this FDE
decryption. `TW_INCLUDE_CRYPTO` and `TARGET_HW_DISK_ENCRYPTION` therefore
remain explicitly false. `/data` decryption is not supported and was not
tested.

The prebuilt kernel was checked before building: 10,060,180 bytes and
SHA-256 `9ed23e2eae57b61350110faaccd2a4a6fa6a3651535788275dd7aa0db55dff0c`.

## Build

- Lunch target: `twrp_tb8704f-eng`
- Build command: `mka recoveryimage`
- Build environment: `ALLOW_MISSING_DEPENDENCIES=true`, with a temporary
  `python` alias to `python3` for the host tooling.
- Result: successful.
- Cleanup rebuild: successful after removing the stale
  `TARGET_KEYMASTER_WAIT_FOR_QSEE` flag.

The source manifest initially exposed missing VTS fuzzer defaults; the build
continued with `ALLOW_MISSING_DEPENDENCIES=true`. The Android 12.1 recovery
make rules also required empty output directories for the minimal product
root. These were created only under `out/` and are not source changes. The
host `zip` package was installed when the build reported it missing.

Relevant non-fatal warnings include deprecated `BOARD_PLAT_*_SEPOLICY_DIR`
variables, the missing optional dependency-tree notice, and compiler
`android-cloexec-open` warnings from generated vold test code.

## recovery.img

- Path: `out/target/product/tb8704f/recovery.img`
- Size: 24,428,544 bytes (less than 67,108,864)
- SHA-256: `d2ac133eb532bfbb560a0e53a4d784c19f753370253bb935f19454c38d00d280`
- Previous Phase 1B SHA-256: `d2ac133eb532bfbb560a0e53a4d784c19f753370253bb935f19454c38d00d280`
- Image comparison: identical; removing the stale Keymaster flag did not
  change the image.
- `file`: Android bootimg, kernel, ramdisk, page size 2048, cmdline
  `buildvariant=eng`

## Static analysis

The image was unpacked with the synchronized `system/tools/mkbootimg`
`unpack_bootimg.py`.

- Header: Android boot image header version 0
- Kernel size: 10,060,180 bytes
- Kernel load address: `0x80008000`
- Ramdisk size: 14,363,257 bytes compressed
- Ramdisk load address: `0x81000000`
- Second bootloader: 0 bytes
- Kernel tags address: `0x80000100`
- Page size: 2048
- OS version: 12.0.0
- OS patch level: 2022-04
- Commandline: `buildvariant=eng`
- No `androidboot.selinux=permissive` or `enforcing=0` was found.

The extracted kernel is byte-identical to the prebuilt: 10,060,180 bytes and
SHA-256 `9ed23e2eae57b61350110faaccd2a4a6fa6a3651535788275dd7aa0db55dff0c`.

The extracted ramdisk contains `init` (symlink to `/system/bin/init`), the
`system/bin/recovery` executable, and
`system/etc/recovery.fstab`. The fstab contains the approved system,
system-image, data, cache, persist, lenovocust, boot, recovery, misc, MicroSD,
and USB-OTG entries. The data entry contains
`encryptable=footer;length=-16384`. No critical raw firmware/security/EFS
partition entry was found.

## Device status

- Boot test: NOT STARTED
- Flash test: NOT STARTED
- No fastboot command was run.
- No device partition was accessed or modified.
- Phase 1C: not started.
