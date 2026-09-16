# Phase 1C device test

## First temporary boot result

The first temporary boot used the Phase 1B image with SHA-256
`d2ac133eb532bfbb560a0e53a4d784c19f753370253bb935f19454c38d00d280` and the
command:

```text
fastboot boot recovery.img
```

The bootloader accepted the operation:

```text
Sending 'boot.img' ... OKAY
Booting ... OKAY
```

The tablet did not reach the TWRP interface and subsequently booted Android.
No partition was written and no recovery image was flashed.

Post-mortem evidence was limited:

- `/sys/fs/pstore` was empty.
- `/proc/last_kmsg` was not present.
- Android `dmesg` contained only messages from the subsequently booted kernel
  `3.18.140-lineageos-g217079fec494`.
- No usable crash log from the recovery kernel was available.

The working hypothesis is that the first image lacked the TB-8704F legacy
kernel commandline required during temporary boot. This is a hypothesis only;
the failed recovery-kernel execution produced no direct crash evidence.

## Second temporary boot candidate

The commandline was taken from the TB-8704F-specific reference
`brianreboot/twrp_device_lenovo_tb_8704f`, commit
`508409d8dcdf2084a5a165e07babe013d1854494`. The following parameters were
added without the reference's permissive security overrides:

```text
console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=qcom msm_rtb.filter=0x237 ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 earlycon=msm_hsl_uart,0x78af000
```

`androidboot.selinux=permissive` and `enforcing=0` were deliberately not
copied.

Device-tree commit: `81008b9` (`recovery: add TB-8704F legacy boot parameters`).

Build details:

- TWRP branch: `twrp-12.1`
- Lunch target: `twrp_tb8704f-eng`
- Build: incremental `mka recoveryimage`
- Build result: successful
- Image path: `out/target/product/tb8704f/recovery.img`
- Manual-test copy: `/root/build/twrp-12.1-recovery/TB8704F-twrp-phase1c1.img`
- Image size: 24,428,544 bytes
- Image SHA-256: `4bb00c3d4109f621ead8d8e6e936101b86192e64d3b137b5f0fccfdc90ad972c`

Static image values:

- Header version: 0
- Page size: 2048
- Kernel address: `0x80008000`
- Ramdisk address: `0x81000000`
- Tags address: `0x80000100`
- Kernel size: 10,060,180 bytes
- Kernel SHA-256: `9ed23e2eae57b61350110faaccd2a4a6fa6a3651535788275dd7aa0db55dff0c`
- Full commandline: `console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=qcom msm_rtb.filter=0x237 ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 earlycon=msm_hsl_uart,0x78af000 buildvariant=eng`
- No permissive SELinux override is present.
- The approved `recovery.fstab` is present in the ramdisk, including the
  footer-based `/data` entry.

## Known-good control

The device-specific control image `TWRP-3.4.0-0_TB-8704F.img` was manually
tested and temporarily booted successfully. It showed the TWRP UI, `adb
devices` reported the device as `recovery`, and partitions were detected.

- TWRP version: `3.4.0-0`
- Kernel: `3.18.71-perf-gdbc2759-dirty`
- ADB: working
- Display/framebuffer UI: working
- `/data`: recognized as encrypted, but the historical TWRP could not decrypt
  `/data` from the current system
- Known-good `/proc/cmdline` includes `androidboot.selinux=permissive` and
  `enforcing=0`

The known-good image is used only as a diagnostic reference. Its permissive
security configuration is not a release configuration and is not treated as
a permanent solution.

## Phase 1C.2 diagnostic candidate

The remaining one-variable test between Phase 1C.1 and Phase 1C.2 is the
permissive SELinux boot configuration. The two permissive parameters were
added only to isolate SELinux as a possible cause of the missing TWRP UI.

This candidate is diagnostic-only, not release configuration.

- Device-tree commit: `9847f21` (`recovery: add temporary permissive boot diagnostics`)
- Build: incremental `mka recoveryimage`
- Build result: successful
- Image path: `out/target/product/tb8704f/recovery.img`
- Manual-test copy: `/root/build/twrp-12.1-recovery/TB8704F-twrp-phase1c2-permissive.img`
- Image size: 24,428,544 bytes
- Image SHA-256: `c83e7c5b5e6b8748ec8d9c99ee56a2d10664fd3bdb45d2d25b0c55514136a235`
- Header version: 0
- Page size: 2048
- Kernel address: `0x80008000`
- Ramdisk address: `0x81000000`
- Tags address: `0x80000100`
- Kernel size: 10,060,180 bytes
- Kernel SHA-256: `9ed23e2eae57b61350110faaccd2a4a6fa6a3651535788275dd7aa0db55dff0c`
- Full commandline: `console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=qcom msm_rtb.filter=0x237 ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 earlycon=msm_hsl_uart,0x78af000 androidboot.selinux=permissive enforcing=0 buildvariant=eng`
- `recovery.fstab`: present and unchanged

The final commandline contains both `androidboot.selinux=permissive` and
`enforcing=0` for this diagnostic candidate only. No further boot attempt was
made in this work step.

## Phase 1C.3 linker diagnostic candidate

The Phase 1C.3 A/B build adds only `linker.recovery` to the device package
list. No kernel, commandline, fstab, init, ueventd or SELinux changes were
made. This remains a diagnostic-only candidate and was not booted on-device.

- Device-tree commit: `f50235c` (`recovery: include recovery dynamic linker`)
- Build: incremental `mka recoveryimage`
- Build result: successful
- Image path: `out/target/product/tb8704f/recovery.img`
- Manual-test copy: `/root/build/twrp-12.1-recovery/TB8704F-twrp-phase1c3-linker.img`
- Image size: 25,049,088 bytes
- Image SHA-256: `4f6bc3754335879d858119d33814a1d37767438e8a5de9c13087fb4c7bcf396a`
- Header version: 0
- Page size: 2048
- Kernel address: `0x80008000`
- Ramdisk address: `0x81000000`
- Tags address: `0x80000100`
- Kernel size: 10,060,180 bytes
- Ramdisk size: 14,984,204 bytes
- Kernel SHA-256: `9ed23e2eae57b61350110faaccd2a4a6fa6a3651535788275dd7aa0db55dff0c`
- Full commandline: `console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=qcom msm_rtb.filter=0x237 ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 earlycon=msm_hsl_uart,0x78af000 androidboot.selinux=permissive enforcing=0 buildvariant=eng`
- Recovery ramdisk: gzip-compressed CPIO, statically inspected after extraction
- `/system/bin/linker64`: present, AArch64 ELF shared object/static PIE
- `/system/bin/linker64` SHA-256: `56e54d7db46f1971c2f363c3040d5f5e4b11c2e262e5242cdfd596665ff551cd`
- `/system/bin/linker`: absent; no 32-bit linker was added
- `/system/bin/linker_asan64`: symlink to `linker64`

This result confirms that the missing 64-bit dynamic linker from Phase 1C.2
can be supplied by the recovery build. It does not establish that the tablet
will boot the image; any device test must still use temporary boot first.
