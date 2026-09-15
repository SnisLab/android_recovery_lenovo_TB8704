# Agent instructions

This repository is part of the Lenovo TB-8704F modernization project.

## Working model

- Work in small, reviewable commits.
- Do not make broad speculative changes.
- Separate research/documentation changes from implementation changes.
- When information is uncertain, document the uncertainty instead of guessing.
- Prefer upstream or device-specific primary sources over forum claims.
- Treat TB-8704F as the primary target unless a task explicitly includes another TB-8704 variant.

## Safety

- Do not generate or recommend commands that write firmware/bootloader partitions unless explicitly requested and reviewed.
- During recovery bring-up, prefer `fastboot boot <image>` over `fastboot flash recovery <image>` until boot, display, touch, storage and ADB have been verified.
- Never assume a partition layout from TB-8504, TB-8703, or another MSM8953 device.

## Commit discipline

Good examples:

- `docs: document verified TB-8704F partition layout`
- `recovery: import verified legacy fstab`
- `recovery: enable adb in recovery`

Avoid monolithic commits such as `make recovery work`.

## Initial milestone

Before implementation, collect and document the verified hardware, partition, legacy recovery, kernel and mainline information needed for the first recovery build.
