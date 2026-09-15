# Lenovo TB-8704 Recovery

Development repository for a modern recovery environment for the Lenovo Tab 4 8 Plus TB-8704 family, with the TB-8704F as the primary development target.

## Project goals

1. Establish a reliable recovery and rescue path before low-level kernel work begins.
2. Reconstruct and verify the TB-8704F partition layout and recovery configuration from primary sources and the device itself.
3. Port a current TWRP-compatible recovery tree while initially retaining the known-working legacy Android kernel.
4. Validate booting with `fastboot boot` before permanently flashing recovery images.

## Safety rules

- Never modify bootloader, trust-zone, RPM, modem, keymaster, or other firmware partitions unless a task explicitly requires it and the change has been reviewed.
- Prefer temporary booting over flashing during bring-up.
- Back up original partitions before destructive tests.
- Do not copy configuration from TB-8504, TB-8703, or other MSM8953 devices without verifying it against TB-8704F sources or hardware.
- Keep changes small and reviewable.

## Status

Phase 0 is complete. Phase 1A device-tree construction is in progress for
TWRP 12.1 using the temporary, provenance-documented TB-8704F prebuilt
kernel. No recovery image has been built, booted, or flashed.

## Related repositories

- `SnisLab/android_device_lenovo_TB8704`
- `SnisLab/android_kernel_lenovo_msm8953`
- `SnisLab/linux_lenovo_TB8704`
