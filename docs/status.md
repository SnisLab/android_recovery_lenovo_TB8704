# Project status

## Current phase

**Phase 0 — Recovery inventory**

Implementation status: **not started**

The current task is research and documentation only. See `docs/phase-0-inventory.md`.

## Gate to Phase 1

Do not begin recovery source import or build work until Phase 0 has been reviewed and the following are verified:

- TB-8704F partition layout
- dedicated recovery/boot arrangement
- legacy recovery baseline
- legacy kernel baseline used for first recovery
- safe temporary boot strategy

## Cross-repository state

- `android_recovery_lenovo_TB8704`: active
- `android_kernel_lenovo_msm8953`: support/research only until requested
- `linux_lenovo_TB8704`: research only; implementation blocked on recovery rescue path
- `android_device_lenovo_TB8704`: research only; Android implementation deferred
