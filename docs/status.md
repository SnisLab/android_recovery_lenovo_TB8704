# Project status

## Current phase

**Phase 1B build complete — static review complete; device boot not started**

Implementation status: **Phase 1B TWRP 12.1 recovery image built and statically reviewed**

Phase 0 inventory documented in:

- `docs/sources.md`
- `docs/legacy-recovery.md`
- `docs/partitions.md`
- `docs/recovery-hardware.md`
- `docs/kernel-baseline.md`
- `docs/dependency-request-kernel.md`
- `docs/open-questions.md`
- `docs/device-verification.md`
- `docs/prebuilt-kernel.md`
- `docs/phase-1a-device-tree.md`

Research status: **physically verified and reviewed**. Phase 1B produced the
first static TWRP image, but it has not been booted or flashed. The brianreboot
F-only tree remains the primary TB-8704F-specific recovery reference.
HighwayStar and LineageOS remain important family, kernel, and Android
references. TB-8704F-specific feature behavior remains unverified.

The Phase 1B result uses the `tb8704f` codename and a provenance-documented
prebuilt kernel. See `docs/phase-1b-build.md` and `docs/prebuilt-kernel.md`.

## Phase 1 gate

Phase 0 review and physical read-only verification are complete. Phase 1A
device-tree preparation and Phase 1B static build review are complete.

- Physically verified TB-8704F partition layout
- Physically verified dedicated recovery/boot arrangement
- Reviewed legacy recovery baseline
- Non-destructive temporary-boot strategy remains to be reviewed and executed

The first static TWRP 12.1 image was built with the provenance-documented
prebuilt kernel. The image has not been booted or flashed. Crypto/QSEE
integration remains disabled and unverified; the reproducible legacy kernel
basis remains required for a reproducible release and long-term maintenance.

## Cross-repository state

- `android_recovery_lenovo_TB8704`: active
- `android_kernel_lenovo_msm8953`: support/research only until requested
- `linux_lenovo_TB8704`: research only; implementation blocked on recovery rescue path
- `android_device_lenovo_TB8704`: research only; Android implementation deferred
