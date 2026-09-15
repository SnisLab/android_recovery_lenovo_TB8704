# Dependency request: legacy kernel baseline

Dependency request:
Repository: SnisLab/android_kernel_lenovo_msm8953
Required change: Import or otherwise make available a provenance-preserving legacy TB-8704F/MSM8953 kernel baseline derived from HighwayStar/android_kernel_lenovo_tb8704 branch cm-14.1, including commit identification, arch/arm64/configs/lineageos_tb8704_defconfig, required DT sources, and a reproducible Android toolchain/build description.
Reason: The F-only brianreboot tree provides a prebuilt TARGET_PREBUILT_KERNEL for an initial recovery smoke build, so a kernel-source import is not an initial smoke-build blocker. The prebuilt must remain a provenance-documented compatibility/bring-up artifact. A reproducible legacy kernel source baseline is still required for a reproducible release and long-term maintained recovery.
Expected interface/result: A reviewable kernel source branch and documented commit that builds the arm64 Image.gz-dtb expected by the TB-8704 recovery BoardConfig, with the TB-8704F defconfig and DTB selection explicitly identified. No firmware/security partition changes.
Evidence: https://github.com/HighwayStar/android_kernel_lenovo_tb8704/tree/cm-14.1; https://github.com/HighwayStar/android_device_lenovo_TB8704/blob/cm-14.1/BoardConfig.mk; https://github.com/LineageOS/android_device_lenovo_TB8704/blob/lineage-17.1/BoardConfig.mk; docs/kernel-baseline.md
Blocking for initial recovery smoke build: no
Blocking for reproducible recovery release: yes
Blocking for long-term maintained recovery: yes
