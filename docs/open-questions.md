# Open questions after Phase 0

Phase 0 is complete. Resolved items are retained below for traceability; only
the remaining recovery feature and provenance questions are open.

- Resolved: physical model is TB-8704F; the TB-8704X build-fingerprint label is
  not treated as a hardware-model proof. `/proc/cmdline` was permission denied.
- Resolved: reviewed physical partition map and sizes are recorded in
  `docs/partitions.md`; unlisted partition sizes remain unknown.
- Resolved: empty slot properties and absent A/B/dynamic partition names confirm
  the A-only, non-dynamic layout.
- Resolved: boot and recovery are separate physical partitions. Temporary boot
  acceptance remains unverified.
- Preserve hashes and read-only backups of stock boot, recovery, persist,
  misc, system, userdata metadata, and critical firmware before experiments.
- Identify the exact display panel, framebuffer dimensions, Goodix touch model,
  and whether touch firmware needs a vendor payload in recovery.
- Test internal eMMC, microSD, USB OTG, USB gadget/ADB, and recovery logs.
- Test unencrypted data, footer-encrypted data, and the behavior when QSEE or
  keymaster services are unavailable. Decryption failure must not trigger a
  destructive format.
- Find a complete build manifest/toolchain for the 3.18 legacy kernel and
  verify the exact TB-8704F DTB, because the public branch also contains V
  variants.
- Establish evidence for actual working/broken features of the legacy TWRP
  build; source configuration alone is insufficient.
- Compare the F-only prebuilt kernel against the documented 3.18 source
  baseline and capture hash, format, DTB evidence, and provenance.
- Resolved: physical userdata confirms `56823880704` bytes and the 16 KiB
  encrypted-footer reduction documented by the F-only source.
