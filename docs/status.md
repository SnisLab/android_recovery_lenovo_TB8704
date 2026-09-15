# Project status

## Current phase

**Phase 0 complete — Phase 1 recovery bring-up approved**

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

Research status: **physically verified and reviewed**.
No recovery tree was imported and no build was started. Only the reviewed
read-only device verification was performed. The brianreboot F-only tree is the primary TB-8704F-specific
recovery reference. HighwayStar and LineageOS remain important family,
kernel, and Android references. TB-8704F-specific assumptions remain gated by
the remaining open questions.

The current task is research and documentation only. The F-only brianreboot
tree is included as a source reference; no source tree was imported. See
`docs/phase-0-inventory.md` and `docs/device-verification.md`.

## Phase 1 gate

Phase 0 review and physical read-only verification are complete. Phase 1
recovery bring-up is approved, with no recovery implementation started by this
documentation change.

- Physically verified TB-8704F partition layout
- Physically verified dedicated recovery/boot arrangement
- Reviewed legacy recovery baseline
- Non-destructive temporary-boot strategy remains to be executed and evaluated

The prebuilt kernel from the brianreboot F-only tree may support an initial
smoke build, but only as a provenance-documented compatibility/bring-up
artifact. The reproducible legacy kernel basis may be prepared in parallel by
the kernel agent and remains required for a reproducible release and long-term
maintenance.

## Cross-repository state

- `android_recovery_lenovo_TB8704`: active
- `android_kernel_lenovo_msm8953`: support/research only until requested
- `linux_lenovo_TB8704`: research only; implementation blocked on recovery rescue path
- `android_device_lenovo_TB8704`: research only; Android implementation deferred
