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
- `docs/device-verification.md`

Research status: **documented, pending physical read-only verification**.
No recovery tree was imported, no build was started, and no device operation
was performed. The brianreboot F-only tree is the primary TB-8704F-specific
recovery reference. HighwayStar and LineageOS remain important family,
kernel, and Android references. TB-8704F-specific assumptions remain gated by
the open questions.

The current task is research and documentation only. The F-only brianreboot
tree is included as a source reference; no source tree was imported. See
`docs/phase-0-inventory.md` and `docs/device-verification.md`.

## Gate to Phase 1

Do not begin recovery source import or build work until Phase 0 has been reviewed and the following are verified:

- TB-8704F partition layout
- dedicated recovery/boot arrangement
- legacy recovery baseline
- safe temporary boot strategy

Phase 1 release is primarily blocked until the physical TB-8704F partition
map, boot/recovery arrangement, and non-destructive recovery test plan are
reviewed. The prebuilt kernel from the brianreboot F-only tree may support an
initial smoke build, but only as a provenance-documented compatibility/bring-up
artifact. The reproducible legacy kernel basis may be prepared in parallel by
the kernel agent and is required before a reproducible release and for
long-term maintenance, not necessarily before the first recovery build.

## Cross-repository state

- `android_recovery_lenovo_TB8704`: active
- `android_kernel_lenovo_msm8953`: support/research only until requested
- `linux_lenovo_TB8704`: research only; implementation blocked on recovery rescue path
- `android_device_lenovo_TB8704`: research only; Android implementation deferred
