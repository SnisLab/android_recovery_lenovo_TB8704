# Phase 0 sources

Research snapshot: 2026-09-15. This inventory records the Phase 0 sources;
the Phase 1A tree is documented separately.

## Recovery sources

| Source | Revision | Finding | Assessment |
| --- | --- | --- | --- |
| [HighwayStar/android_device_lenovo_TB8704](https://github.com/HighwayStar/android_device_lenovo_TB8704/tree/cm-14.1) | `cm-14.1`, latest commit at snapshot `dbd9892cf21a77b6adadccdddcfc3c193a0b74bb` (2019-07-14) | Contains `BoardConfig.mk`, `rootdir/fstab.qcom`, `twrp.mk`, and `twrp/recovery/root/etc/twrp.fstab`. | Best existing recovery-oriented starting point, but its assertions cover X/F/N/V and must be narrowed and checked for an F device. |
| [LineageOS/android_device_lenovo_TB8704](https://github.com/LineageOS/android_device_lenovo_TB8704/tree/lineage-17.1) | `lineage-17.1`, `9254b8bd48361dedf226568a9c8d95e86728e4a9` (2020-05-30) | Maintained Android device configuration; uses common TB fstab and `lineageos_tb8704_defconfig`. | Best later reference for device-specific integration, not an independently verified recovery image. |
| [Matshias/twrp_android_device_tb_8704x](https://github.com/Matshias/twrp_android_device_tb_8704x) | `master`, `9218571a6261762b192f664ce9129f7e426cc3b7` (2017-08-30) | Repository currently contains only `LICENSE`; no `BoardConfig.mk`, fstab, or build files. | Not usable as a source. It is explicitly X-labelled, not F-specific. |

The HighwayStar tree is a combined-family tree, not proof that every feature
works on TB-8704F. No public source found during this phase proves a current,
F-only TWRP tree or a reproducible released image.

## Source reading notes

The HighwayStar `BoardConfig.mk` defines Qualcomm MSM8953, arm64, a gzip'd
arm64 kernel image with DTB, 2048-byte pages, 64 MiB boot and recovery images,
and `TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/fstab.qcom`. Its `twrp.mk`
enables crypto support, excludes `hbtp_vm` input, and selects the portrait
HDPI theme. These are source observations, not yet an implementation target.

The LineageOS tree's `BoardConfig.mk` uses the same 64 MiB image sizes and
`lineageos_tb8704_defconfig`, and inherits the common TB configuration. It
also accepts all four 8704 variants in its OTA assertion. This broad assertion
is a reason to require physical F-device verification before reuse.

## F-only source

The F-only brianreboot source is commit `508409d8dcdf2084a5a165e07babe013d1854494`
on `android-7.1` (2020-07-17). It contains a prebuilt kernel, TWRP fstab,
recovery ramdisk files, and sepolicy. Its BoardConfig selects MSM8953, arm64,
2048-byte pages, 64 MiB boot/recovery limits, and permissive SELinux kernel
arguments. These are source observations only; no image or device behavior is
independently verified.

## Model separation

`TB-8704X/N/V` references above are retained only as provenance for the family
tree. `TB-8703` and `TB-8504` were not used to infer any TB-8704F fact.
