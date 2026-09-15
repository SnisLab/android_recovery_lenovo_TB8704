# Phase 1A device tree

## Scope

The first implementation target is TWRP 12.1 for the physical TB-8704F. The
tree uses the single lowercase Android codename `tb8704f` consistently in
paths, product names, and `TARGET_DEVICE`. No X/N/V compatibility assertions
are included.

The tree is build-oriented only. It has not been built, booted, flashed, or
tested on the tablet.

## Deliberate limits

- A-only, non-dynamic layout with separate `boot` and `recovery`.
- No `vendor_boot`, `super`, slots, or fastbootd configuration.
- The legacy F-only prebuilt kernel is temporary compatibility/provenance
  material only; see `docs/prebuilt-kernel.md`.
- Legacy QSEE binaries and old recovery init/USB policy were not copied
  blindly. Crypto/decryption remains unverified.
- The reference `omni.dependencies` entry targets an Android-7.1 Qualcomm
  common tree and is intentionally not carried into this TWRP 12.1 tree.
- The reference `system.prop` USB defaults are also not carried; recovery USB
  behavior must come from the TWRP 12.1 common implementation and later tests.
- Critical firmware, bootloader, security, and EFS entries are backup-only in
  the fstab and have no wipe flags.
