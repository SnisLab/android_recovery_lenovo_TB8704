# Project status

## Current phase

**Phase 0 — Recovery inventory**

Implementation status: **not started**

Phase 0 inventory documented in:

- `docs/sources.md`
- `docs/legacy-recovery.md`
- `docs/partitions.md`
- `docs/recovery-hardware.md`
- `docs/kernel-baseline.md`
- `docs/dependency-request-kernel.md`
- `docs/open-questions.md`

Research status: **documented, pending review and physical-device verification**.
No recovery tree was imported, no build was started, and no device operation
was performed. The best current references are the HighwayStar TB8704
device/kernel repositories, with TB-8704F-specific assumptions still gated by
the open questions.

The current task is research and documentation only. See `docs/phase-0-inventory.md`.

## Gate to Phase 1

Do not begin recovery source import or build work until Phase 0 has been reviewed and the following are verified:

- TB-8704F partition layout
- dedicated recovery/boot arrangement
- legacy recovery baseline
- legacy kernel baseline used for first recovery
- safe temporary boot strategy

Phase 0 completion is blocked until the physical partition map, boot/recovery
arrangement, exact kernel commit/toolchain, and non-destructive recovery test
plan are reviewed.

## Cross-repository state

- `android_recovery_lenovo_TB8704`: active
- `android_kernel_lenovo_msm8953`: support/research only until requested
- `linux_lenovo_TB8704`: research only; implementation blocked on recovery rescue path
- `android_device_lenovo_TB8704`: research only; Android implementation deferred
