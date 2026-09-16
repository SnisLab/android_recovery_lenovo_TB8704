# Phase 1D: TWRP 8.1 recovery baseline

## Decision

The TWRP 12.1 bring-up is frozen after Phase 1C.4. Phase 1C.2 without the
recovery linker did not boot. Phase 1C.3 added `linker.recovery`; the tablet
showed a brief black display and returned to Fastboot. Phase 1C.4 also added
the recovery linker configuration, but the device behavior was identical.
There was no TWRP userspace, no ADB, no pstore data and no `last_kmsg`.
Static analysis did not identify another single fatal missing-package blocker.

The complete 12.1 source and build tree remain preserved. No further 12.1
recovery build change is part of Phase 1D.

Phase 1D investigates the Omni-based TWRP 8.1 recovery branch as a potentially
more device-appropriate baseline for the TB-8704F legacy recovery environment.
The first Phase 1D target is analysis only; no recovery image has been built.

## Manifest and sync

The separate build tree is:

```text
/root/build/twrp-8.1-recovery
```

Manifest:

```text
https://github.com/minimal-manifest-twrp/platform_manifest_twrp_omni.git
```

Requested branch: `twrp-8.1`

Sync completed successfully with `repo sync -j$(nproc) --force-sync`.
The manifest repository revision is:

```text
8a1ad61ddbe7c86ab666548e83937ad9116e4359
```

The manifest default platform revision is `refs/tags/android-8.1.0_r51`.
The synced TWRP recovery project revision is
`90e5d9559065cfa8b2b9a5dbb1c5cb7a88f034fa`.
The synced build tree is clean according to `repo status`.

No device-specific project is included by this manifest. The top-level
`device/` directory does not exist yet; `vendor/omni/AndroidProducts.mk`
currently registers only `omni_emulator`.

## Host requirements

Observed host tools:

| Tool | Result |
|---|---|
| `python` | Missing |
| `python2` | Missing |
| `python3` | Python 3.12.3 at `/usr/bin/python3` |
| `java` | Missing |
| `javac` | Missing |
| `make` | Present |
| `gcc`, `g++` | Present |
| system `clang` | Missing; the tree contains prebuilts |
| `zip`, `unzip`, `bc`, `bison`, `flex`, `rsync`, `git` | Present |
| global `repo` | Missing; an isolated launcher was used only for sync |

The source uses many `#!/usr/bin/env python` scripts. Most are Python 2-era
build tools; `build/make/tools/releasetools/sign_target_files_apks.py` still
contains Python 2 print syntax, while other tools explicitly accept Python
2.7 or newer. Python 3.12 cannot be treated as a drop-in replacement for the
whole tree. A future build needs an isolated Python 2.7-compatible solution,
not a global `/usr/bin/python` symlink.

The Java build selects `java`, `javac`, `jar` and `javadoc` directly. The
tree uses Java source level 1.8 and its JDK helper searches for `lib/tools.jar`,
which indicates that JDK 8 is the expected compatible host. Java/JDK 8 is not
installed. A future build needs an isolated JDK 8 environment; no global Java
replacement was made.

## Omni 8.1 product structure

The actual Omni environment defines `breakfast <device>` as
`omni_<device>-userdebug` by default. The historical TB-8704F tree provides
both:

```text
omni_tb_8704f-userdebug
omni_tb_8704f-eng
```

The historical product makefile is `omni_tb_8704f.mk`, and its
`PRODUCT_DEVICE` is `tb_8704f`. The historical `Android.mk` filters on
`tb_8704f`. Therefore the recommended Phase 1D naming strategy is:

```text
device/lenovo/tb_8704f
PRODUCT_NAME := omni_tb_8704f
PRODUCT_DEVICE := tb_8704f
```

This follows the proven TB-8704F-specific reference instead of inventing a
new `omni_tb8704f` product namespace. No rename or source import was made in
Phase 1D.0.

The 8.1 recovery image uses the standard Android recovery image path: the
build's `recoveryimage` target invokes the host `mkbootimg` with
`BOARD_MKBOOTIMG_ARGS`, then enforces `BOARD_RECOVERYIMAGE_PARTITION_SIZE`.
The known legacy offsets and 64-MiB recovery limit are compatible with this
mechanism.

The branch reports platform SDK 27. Its TWRP makefiles select the SDK-27/28
compatibility branches, including recovery linker configuration handling and
Oreo FDE/keymaster code paths.

## Historical TB-8704F reference

Primary reference:

```text
Repository: brianreboot/twrp_device_lenovo_tb_8704f
Branch: android-7.1
Commit: 508409d8dcdf2084a5a165e07babe013d1854494
```

The reference confirms the TB-8704F-specific msm8953, arm64, Adreno 506 and
legacy A-only recovery assumptions. Its prebuilt kernel has the same SHA-256
as the current repository kernel:

```text
9ed23e2eae57b61350110faaccd2a4a6fa6a3651535788275dd7aa0db55dff0c
```

The historical tree also contains legacy QSEE/keymaster runtime files and
RC files. These are evidence of the old recovery runtime, not files to copy
blindly into the new baseline.

## Device-tree delta

### Can remain the baseline

- `device/lenovo/tb8704f/kernel`, after moving to the selected 8.1 device path; the binary is unchanged.
- Physical board values: MSM8953, Adreno 506, arm64, 2048-byte pagesize, base `0x80000000`.
- Kernel, ramdisk, tags and second offsets from the verified legacy image layout.
- 64-MiB boot and recovery partition sizes.
- Verified system, userdata, cache and persist sizes.
- The current security-trimmed `recovery.fstab` as the starting point.
- TWRP display, brightness, SD card, NTFS and RTC settings, subject to 8.1 variable compatibility review.
- Permissive diagnostic commandline for the first A/B smoke test only.

### Must be adapted

- Device path and target filter: `tb8704f` must become the historically
  consistent `tb_8704f` if the recommended naming strategy is adopted.
- Product file: inherit `vendor/omni/config/common.mk`, use
  `omni_tb_8704f.mk`, and set `PRODUCT_NAME := omni_tb_8704f`.
- `AndroidProducts.mk`: register the Omni product and both userdebug/eng
  lunch choices as appropriate for the tree.
- `Android.mk`: filter the selected `TARGET_DEVICE` name.
- BoardConfig path variables: point to the selected device directory while
  preserving the verified physical values.
- Legacy recovery RC integration must be reviewed separately rather than
  assumed from the 12.1 init model.
- QSEE/keymaster runtime files, if later required for crypto, need a separate
  provenance and compatibility review.

### Must not be carried unchanged from 12.1

- The 12.1 `PRODUCT_PACKAGES` additions `ld.config.recovery.txt` and
  `linker.recovery`.
- The 12.1 product name `twrp_tb8704f` and `vendor/twrp/config/common.mk`
  inheritance.
- Any 12.1-specific init/linker assumptions.

The 8.1 TWRP makefiles already require `ld.config.txt` for SDK >= 26 and
derive a recovery `/sbin/ld.config.txt` from the platform configuration. The
8.1 tree also supplies `init.recovery.ldconfig.rc` with
`LD_CONFIG_FILE=/sbin/ld.config.txt`. This is a different mechanism from the
12.1 `ld.config.recovery.txt` package and must be allowed to provide the
configuration naturally.

The current fstab intentionally does not expose `aboot`, `tz`, `rpm`,
keymaster, modem or EFS subpartitions. The historical fstab does expose such
partitions, but they must not be reintroduced without a new TB-8704F-specific
safety review.

## FDE and QSEE status

The Omni/TWRP 8.1 source contains FDE support paths:

- `TW_INCLUDE_CRYPTO` enables the FDE and scrypt modules.
- `TARGET_HW_DISK_ENCRYPTION` adds `libcryptfs_hw` and Qualcomm cryptfs
  hardware integration.
- SDK 27 selects the Oreo keymaster-3 path and `libsoftkeymaster` support.
- `TW_CRYPTO_USE_SYSTEM_VOLD` can add the vold-decrypt service framework.
- `init.recovery.vold_decrypt.qseecomd.rc` supports system and vendor
  `qseecomd` service locations.

The historical TB-8704F tree sets crypto and hardware disk encryption true,
sets `TARGET_KEYMASTER_WAIT_FOR_QSEE := true`, and carries QSEE/keymaster
prebuilt files plus `init.recovery.qcom.rc`. The Omni 8.1 source itself does
not define `TARGET_KEYMASTER_WAIT_FOR_QSEE`; that historical variable cannot
be assumed to have an effect in this branch.

For Phase 1D.1, crypto remains disabled. The first objective is recovery boot,
display, touch, storage and ADB. FDE/QSEE activation is deferred until the
recovery userspace is independently proven to start.

## Phase 1D.1 minimal scope

The first implementation should be limited to:

1. Add an 8.1-compatible TB-8704F device directory using the selected
   historical `tb_8704f` naming.
2. Reuse the verified prebuilt kernel without modification.
3. Port the verified physical BoardConfig values and diagnostic commandline.
4. Use the current security-trimmed fstab as the starting point.
5. Register `omni_tb_8704f-userdebug` and `omni_tb_8704f-eng`.
6. Keep `TW_INCLUDE_CRYPTO` and hardware disk encryption disabled.
7. Build only after an isolated Python/JDK solution is documented and
   reviewed.

No Phase 1D.1 source implementation or recovery build was performed here.
