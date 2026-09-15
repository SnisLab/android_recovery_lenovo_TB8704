# Legacy kernel baseline

## Recommended source

The most relevant public legacy source is
[HighwayStar/android_kernel_lenovo_tb8704](https://github.com/HighwayStar/android_kernel_lenovo_tb8704),
branch `cm-14.1`. Its latest branch commits include:

- `b9e4174976786b27d82d374b1e1bdf4fb4f0154c`: TB-8704V DT overlay (2020-03-16)
- `06a43cf41d2d57a35a322ba559f8010f45268fd1`: Lineage TB-8704V config
- `d460fbdd244002580fda20713b575bf0ce402b38`: OTG DT typo fix
- `ab2a3bb0ea7a8faa5a609b0ac53c8b77ae9de86e`: exFAT, NTFS, pstore and
  sdcardfs enabled
- `fa836e364f3779ccdee8dd68675dfbe2da390165`: Lineage TB-8704 config

The kernel Makefile identifies the Linux 3.18 kernel family. The
TB-8704F-oriented configuration is
`arch/arm64/configs/lineageos_tb8704_defconfig` (blob
`5e27a2a00c9e5eedb598aae699ff4f3c614febda`). The LineageOS device
configuration selects the same defconfig and source path
`kernel/lenovo/tb8704`.

The defconfig contains the recovery-relevant legacy drivers for MSM8953,
MDSS framebuffer, Goodix GT9XX, MMC/SDHCI, ext4/VFAT/exFAT/NTFS, dm-crypt,
USB gadget/DWC3, USB storage, and Android binder/ashmem. It is a broad Android
configuration, not a claim that all options are needed by recovery.

## Toolchain and reproducibility

The public source does not state a complete toolchain version in the examined
files. Treat the original Android/Lineage build toolchain as an unresolved
dependency; do not select a modern compiler by guesswork. Capture the exact
toolchain and commit once the dependency repository is populated or a known
build manifest is supplied.

## F-only prebuilt comparison

The F-only brianreboot tree contains a 10,060,180-byte prebuilt `kernel`
with SHA-256 `9ed23e2eae57b61350110faaccd2a4a6fa6a3651535788275dd7aa0db55dff0c`.
Its source commit, compiler, embedded DTB, and reproducible build inputs are
not identified. Treat it as a compatibility artifact for comparison only, not
as a verified replacement for the documented source baseline.

## Scope boundary

`SnisLab/android_kernel_lenovo_msm8953` is currently an empty project setup
according to its README. This repository does not import or modify kernel
source. The HighwayStar kernel is evidence for the proposed baseline, not a
cross-repository implementation.
