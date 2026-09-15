# Agent instructions

This repository is the **recovery workstream** of the Lenovo Tab 4 8 Plus TB-8704F modernization project.

## Scope

You own:
- TWRP / recovery device configuration
- recovery fstab and partition mapping
- recovery boot image composition
- ADB in recovery
- mount, backup and restore behavior
- recovery-side USB / storage support
- recovery bring-up documentation

You do **not** own:
- Linux mainline porting (`SnisLab/linux_lenovo_TB8704`)
- legacy Android kernel maintenance (`SnisLab/android_kernel_lenovo_msm8953`)
- Android / Lineage device-tree work (`SnisLab/android_device_lenovo_TB8704`)

If work is required in another repository, do not implement it here. Document a dependency request using:

```text
Dependency request:
Repository: <repo>
Required change: <precise change>
Reason: <why recovery needs it>
Expected interface/result: <what this repo expects afterwards>
```

## Working model

- Work in small, reviewable commits.
- Do not make broad speculative changes.
- Separate research/documentation changes from implementation changes.
- When information is uncertain, document the uncertainty instead of guessing.
- Prefer upstream or device-specific primary sources over forum claims.
- Treat TB-8704F as the primary target unless a task explicitly includes another TB-8704 variant.
- Never copy settings from TB-8504, TB-8703, or another MSM8953 device without proving they apply to TB-8704F.

## Safety

- Do not write firmware or bootloader partitions unless explicitly requested and reviewed.
- During recovery bring-up, prefer `fastboot boot <image>` over `fastboot flash recovery <image>` until boot, display, touch, storage and ADB have been verified.
- Do not alter `aboot`, `tz`, `rpm`, `devcfg`, `cmnlib`, `cmnlib64`, `keymaster`, modem/EFS or similarly critical firmware partitions as part of recovery development.
- Do not assume a partition path, size or filesystem without a TB-8704F-specific source or direct device evidence.

## Commit discipline

Good examples:
- `docs: document verified TB-8704F partition layout`
- `recovery: import verified legacy fstab`
- `recovery: enable adb in recovery`

Avoid monolithic commits such as `make recovery work`.

## Initial milestone

Before implementation, collect and document the verified hardware, partition, legacy recovery and kernel information needed for the first modern recovery build.

The first implementation target is a modern TWRP recovery using the known working legacy Android kernel, tested by temporary boot before permanent flashing.
