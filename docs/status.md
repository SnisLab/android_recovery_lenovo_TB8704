# Project status

## Current phase

**Phase 1C.4 complete; TWRP 12.1 bring-up frozen; Phase 1D evaluates TWRP 8.1**

Implementation status: **TWRP 12.1 Phase 1C.4 reached no TWRP UI; no further 12.1 package iteration is planned**

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

Research status: **physically verified and reviewed**. The first temporary boot
was accepted by fastboot but reached no TWRP UI before Android restarted. The
brianreboot F-only tree remains the primary TB-8704F-specific recovery reference.
HighwayStar and LineageOS remain important family, kernel, and Android
references. TB-8704F-specific feature behavior remains unverified.

The Phase 1B result uses the `tb8704f` codename and a provenance-documented
prebuilt kernel. See `docs/phase-1b-build.md` and `docs/prebuilt-kernel.md`.

The TWRP 12.1 bring-up is frozen after Phase 1C.4. Phase 1C.2 without the
recovery linker, Phase 1C.3 with `linker.recovery`, and Phase 1C.4 with
`ld.config.recovery.txt` all failed to reach modern TWRP userspace; Phase 1C.3
and 1C.4 both returned directly to Fastboot after a brief black display. No
additional single missing-package blocker was identified statically, and no
further 12.1 build changes are planned in this workstream.

Phase 1D investigates the Omni-based TWRP 8.1 branch as a potentially more
device-appropriate baseline for TB-8704F, while preserving the complete 12.1
tree and build outputs.

## Phase 1 gate

Phase 0 review and physical read-only verification are complete. Phase 1A
device-tree preparation and Phase 1B static build review are complete.

- Physically verified TB-8704F partition layout
- Physically verified dedicated recovery/boot arrangement
- Reviewed legacy recovery baseline
- Non-destructive temporary-boot strategy remains to be reviewed and executed

The Phase 1C.2 candidate adds permissive SELinux parameters only as a
diagnostic one-variable test against the known-good control. It has not yet
been booted and is not a release configuration. Crypto/QSEE integration
remains disabled and unverified; the reproducible legacy kernel basis remains
required for a reproducible release and long-term maintenance.

## Cross-repository state

- `android_recovery_lenovo_TB8704`: active
- `android_kernel_lenovo_msm8953`: support/research only until requested
- `linux_lenovo_TB8704`: research only; implementation blocked on recovery rescue path
- `android_device_lenovo_TB8704`: research only; Android implementation deferred
