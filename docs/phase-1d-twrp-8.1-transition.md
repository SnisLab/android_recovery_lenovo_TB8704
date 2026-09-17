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

At the Phase 1D.0 baseline, no Phase 1D.1 source implementation or recovery
build had been performed.

## Phase 1D.1A: isolated host toolchain

The host environment is isolated at `/root/toolchains/twrp-8.1/env.sh`.
It selects Python 2.7.18 and Temurin JDK 8u504 without changing the host
defaults or using global alternatives. The required JDK `lib/tools.jar` is
present.

The Python build does not provide the optional `_hashlib` extension because
Python 2.7 cannot build that extension against the host OpenSSL 3 ABI. The
requested `hashlib` smoke check nevertheless passed for all required
algorithms:

```text
md5    098f6bcd4621d373cade4e832627b4f6
sha1   a94a8fe5ccb19ba61c4c0873d391e987982fbbd3
sha256 9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08
sha512 ee26b0dd4af7e749aa1a8ee3c10ae9923f618980772e473f8819a5d4940e0db27ac185f8a0e1d5f84f88bc887fd67b143732c304cc5fa9ad8e6f57f50028a8ff
```

## Phase 1D.1B: minimal 8.1 device tree

The device tree is now at:

```text
device/lenovo/tb_8704f
```

It uses the verified product names and lunch targets:

```text
PRODUCT_DEVICE := tb_8704f
PRODUCT_NAME := omni_tb_8704f
omni_tb_8704f-eng
omni_tb_8704f-userdebug
```

The prebuilt kernel is unchanged and has SHA-256:

```text
9ed23e2eae57b61350110faaccd2a4a6fa6a3651535788275dd7aa0db55dff0c
```

The verified legacy boot layout, physical partition values, diagnostic
command line and security-trimmed recovery fstab were retained. The fstab
syntax flags used by this 8.1 tree (`display`, `backup`, `encryptable`,
`wipeingui`, `storage` and `removable`) are present in its partition parser.

The supported TWRP settings retained are:

```text
TW_THEME
TW_DEFAULT_BRIGHTNESS
TW_BRIGHTNESS_PATH
RECOVERY_GRAPHICS_USE_LINELENGTH
TARGET_RECOVERY_QCOM_RTC_FIX
RECOVERY_SDCARD_ON_DATA
TW_DEFAULT_EXTERNAL_STORAGE
TW_INCLUDE_NTFS_3G
```

Crypto remains explicitly disabled with `TW_INCLUDE_CRYPTO := false` and
`TARGET_HW_DISK_ENCRYPTION := false`. No QSEE, keymaster, vold-decrypt or
other hardware FDE integration was added. No legacy recovery RC files and no
raw firmware/security partitions were added. The 8.1 tree supplies its own
recovery linker configuration; the 12.1-only `linker.recovery` and
`ld.config.recovery.txt` packages were not carried over.

The device tree was integrated into `/root/build/twrp-8.1-recovery`.
`envsetup.sh` and both requested lunch targets were checked without invoking a
build. Both targets resolve to platform version `16.1.0` and SDK `27`:

```text
TARGET_PRODUCT=omni_tb_8704f
TARGET_DEVICE=tb_8704f
TARGET_BUILD_VARIANT=eng|userdebug
PLATFORM_VERSION=16.1.0
PLATFORM_SDK_VERSION=27
```

Lunch emits a warning that the optional
`device/lenovo/tb_8704f/omni.dependencies` file is absent; this does not
prevent product recognition and no dependency file was added.

No TWRP build, device access, fastboot operation or flash operation was
performed.

## Phase 1D.1Z-B: permanent 1Q Recovery boot validated

After Phase 1D.1Z had permanently written
`TB8704F-twrp-phase1d1q-rpmb.img` to the Recovery partition and Phase 1D.1Z-A
had confirmed that the 1Q prefix survived the Android boot attempt, the
regular installed Recovery boot path was tested. The known 1Q Recovery was
temporarily booted first, then the following command was issued:

```text
adb reboot recovery
```

`fastboot reboot recovery` was not used for this A/B test, and no flash was
performed. The kernel Boot-ID differed before and after the command, proving a
new boot rather than continued execution of the temporary Recovery instance.

The device returned ADB in the `recovery` state and TWRP 3.7.0_9-0 started
successfully. No rescue fallback was required. The successful installed boot
included:

```text
androidboot.tflash=recovery
```

This establishes the path:

```text
adb reboot recovery
  -> bootloader Recovery request
  -> androidboot.tflash=recovery
  -> permanently installed Recovery partition
  -> TWRP 3.7.0_9-0
```

The Recovery prefix remained the expected 23582720-byte Phase 1D.1Q image with
SHA-256
`14b2d8014ec49f3e48007048b532ab1fa4a0f8eb7933d305d2c423d81deb3475`. The Boot
partition also remained unchanged at SHA-256
`c8452ea44988f7cab79b759a574170a34be185e2acd84e82e19eff7b9267926f`.

The earlier `fastboot reboot recovery` behavior must not be interpreted as a
failed flash, an Android rewrite of the Recovery partition, an incorrect
image or proof that 1Q cannot boot permanently. On this device,
`adb reboot recovery` is the validated installed Recovery boot mechanism;
`fastboot reboot recovery` is not a reliable validated Recovery boot path.

The installed TWRP 3.4.0-0 Recovery is no longer the installed Recovery. Its
rollback image remains only as an emergency artifact. The separate temporary
1Q FDE post-decrypt continuation issue was not tested in this phase.

No PIN, decrypt, flash, restore, backup, wipe, format, rollback or source/build
operation was performed during Phase 1D.1Z-B. Hardware artifacts remain local
at:

```text
C:\adb\TB8704F-Lab\reports\phase1d1z-b-adb-reboot-recovery.md
C:\adb\TB8704F-Lab\logs\phase1d1z-b-installed-1q-boot.log
```

## Phase 1D.1Z-A: permanent 1Q flash survived Android boot

Phase 1D.1Z successfully executed the permanent flash of
`TB8704F-twrp-phase1d1q-rpmb.img` to the Recovery partition. Fastboot reported
`Writing 'recovery' OKAY` and exited with code 0. However,
`fastboot reboot recovery` and a subsequent manual recovery boot did not start
the permanently installed 1Q Recovery; the device ultimately returned to
Android. Phase 1D.1Z-A therefore used the 1Q image only as a temporary
diagnostic Recovery via `fastboot boot`.

The temporary diagnostic Recovery was TWRP 3.7.0_9-0 with ADB in the
`recovery` state. No PIN was entered and `/data` was not decrypted.

The first exactly 23582720 bytes of the physical Recovery partition were
hashed directly on the device. The result matched the Phase 1D.1Q image:

```text
14b2d8014ec49f3e48007048b532ab1fa4a0f8eb7933d305d2c423d81deb3475
```

Thus the written image prefix remained present after the Android boot attempt:

```text
Recovery partition prefix == Phase 1D.1Q image
FLASH SURVIVED ANDROID BOOT
```

The full 67108864-byte Recovery partition SHA-256 was:

```text
CA88238D2667911EF2810CC46F2866A4902DADDFC5092AB5BDB343AD2B331C2A
```

This does not match the historical TWRP 3.4.0 Recovery hash
`5f45d4deb20c67894d5ed97861ed6f6192e241630fccd12500ee48aad8903ce5`, as
expected because the new image is 23582720 bytes and the partition is
67108864 bytes. The exact image-prefix hash is authoritative for verifying
the written 1Q image. The attempted Windows binary prefix dump had the wrong
size and is invalid; it was not used for verification.

The readback disproves the hypothesis that Android boot restored the old TWRP
3.4.0 image. No `install-recovery.sh`, `recovery-from-boot.p` or automatic
old-Recovery rewrite should be treated as the cause without new evidence.
The Boot partition remained unchanged at SHA-256
`c8452ea44988f7cab79b759a574170a34be185e2acd84e82e19eff7b9267926f`.

The three states remain separate: temporary 1Q boot works, the persistent
Recovery partition contains the 1Q prefix correctly, and the permanent
Recovery boot path has not yet been shown to start 1Q. The separate issue in
which temporary 1Q can decrypt FDE but TWRP does not continue correctly after
decryption is outside this phase and remains open for later investigation.

No flash, restore, backup, wipe, format, reboot, PIN, decrypt or device write
was performed during Phase 1D.1Z-A itself. The hardware report remains local
at `C:\adb\TB8704F-Lab\reports\phase1d1z-a-recovery-readback.md` and was not
imported into the repository.

## Phase 1D.1Y: permanent install and rollback preflight

The currently installed Recovery on the Lenovo TB-8704F remained TWRP 3.4.0-0
with raw SHA-256
`5f45d4deb20c67894d5ed97861ed6f6192e241630fccd12500ee48aad8903ce5`.

A dedicated bit-identical rollback image was prepared from the validated
Recovery backup on the Windows test host:

```text
C:\adb\TB8704F-Lab\images\rollback\TB8704F-twrp-3.4.0-0-installed-backup.img
size: 67108864 bytes
sha256: 5f45d4deb20c67894d5ed97861ed6f6192e241630fccd12500ee48aad8903ce5
```

The planned target is the temporarily validated Phase 1D.1Q image:

```text
C:\adb\TB8704F-Lab\images\TB8704F-twrp-phase1d1q-rpmb.img
size: 23582720 bytes
sha256: 14b2d8014ec49f3e48007048b532ab1fa4a0f8eb7933d305d2c423d81deb3475
TWRP: 3.7.0_9-0
```

Both images fit within the known 67108864-byte Recovery partition. The
rollback image is exactly partition-sized and the 1Q target is smaller than
the partition. `fastboot.exe` was present on the Windows test host. The
following commands were prepared for a later, explicitly authorized test but
were not executed:

```powershell
C:\adb\fastboot.exe flash recovery `
  C:\adb\TB8704F-Lab\images\TB8704F-twrp-phase1d1q-rpmb.img

C:\adb\fastboot.exe flash recovery `
  C:\adb\TB8704F-Lab\images\rollback\TB8704F-twrp-3.4.0-0-installed-backup.img
```

Before any future install attempt, the independent rollback image, original
Windows backup set, currently boot-valid installed Recovery and temporary 1Q
fastboot-boot artifact are all available. This provides a defined fallback
path. Phase 1D.1Y did not validate permanent 1Q flashing, post-flash readback,
booting a permanently installed 1Q image, rollback flashing or boot after
rollback.

No `fastboot flash`, `fastboot boot`, `adb reboot bootloader`, TWRP Restore,
`dd`, wipe, format or device write occurred during this preflight.

## Phase 1D.1X: successful boot of restored installed Recovery

On the real Lenovo TB-8704F, the Recovery partition restored in Phase 1D.1W
was booted through the installed path using:

```text
adb reboot recovery
```

This was not a `fastboot boot` rescue boot. The Recovery raw SHA-256 before
boot was `5f45d4deb20c67894d5ed97861ed6f6192e241630fccd12500ee48aad8903ce5`;
the Boot raw SHA-256 was
`c8452ea44988f7cab79b759a574170a34be185e2acd84e82e19eff7b9267926f`. Both
hashes remained unchanged after the test.

The recovery interface started successfully, ADB reported the `recovery`
state, and no rescue fallback was required. The important version distinction
is:

```text
temporarily tested Phase 1D.1Q recovery: TWRP 3.7.0_9-0
persistently installed Recovery: TWRP 3.4.0-0
```

Phase 1D.1X validates the boot of the installed TWRP 3.4.0-0 Recovery after
the backup, restore and `adb reboot recovery` sequence. It does not validate a
permanent boot of the Phase 1D.1Q TWRP 3.7.0_9-0 image, which has only been
executed with `fastboot boot` so far.

The installed historical TWRP 3.4.0 recovery uses an older, broader fstab that
exposes additional EFS-, firmware- and security-adjacent subpartitions as
backup-capable. None of those additional targets were backed up, restored,
written or changed during this test. The current Phase 1D.1Q TWRP 3.7.0_9-0
fstab is intentionally more restrictive and does not expose critical
partitions as normal backup or restore targets.

The installed TWRP 3.4.0 recovery remains a bootable historical fallback, and
its backup/restore path has been validated. Its older broad partition
exposure is nevertheless a reason not to treat it as the final target state
for the new recovery work. No additional exposed partition is to be used in
future tests without separate explicit approval.

No further restore or backup, flash, wipe, format, decrypt, PIN test,
fastboot-rescue boot, source change or build was performed. No reboot other
than the tested `adb reboot recovery` operation was performed.

## Phase 1D.1W: successful hardware Recovery restore

On the real Lenovo TB-8704F, while running TWRP 3.7.0_9-0, the backup set
`2026-09-17--20-15-07_lineage_TB8704-userdebug_11_RQ3A211001001_e` from Phase
1D.1U was used for the first real restore test. Only the `Recovery` partition
was selected in the TWRP Restore screen. `Boot`, `Persist`, `Data`, `System`,
`System Image`, `Cache` and `Lenovo Custom` were not selected.

TWRP reported:

```text
Restore success
```

The raw Recovery partition was hashed after the operation and matched the
Recovery backup exactly. This validates the bit-identical path:

```text
Recovery backup -> TWRP restore -> Recovery block device
```

The Boot partition was checked before and after the operation and remained
unchanged. No additional unexpected partition was written, and neither Boot
nor Persist was restored. The recovery log and report remain local at:

```text
C:\adb\TB8704F-Lab\logs\phase1d1w-recovery-restore.log
C:\adb\TB8704F-Lab\reports\phase1d1w-recovery-restore.md
```

After the restore, `/cache/recovery/command` contained no `--wipe_data`.
Neither wipe, format, reboot, second restore, Boot restore, Persist restore
nor flash outside the TWRP Restore operation was performed. No Restore write
occurred for any other partition.

This validates on real hardware the Recovery backup read path, backup image,
restore metadata handling, Recovery raw restore write path, post-write raw
hash verification and isolation from Boot. Actual Boot, Persist, Data,
System, System Image and post-write restore verification remain unvalidated.

## Phase 1D.1V: successful hardware restore preflight

On the real Lenovo TB-8704F, with TWRP 3.7.0_9-0 and the Phase 1D.1Q image
`TB8704F-twrp-phase1d1q-rpmb.img` (SHA-256
`14b2d8014ec49f3e48007048b532ab1fa4a0f8eb7933d305d2c423d81deb3475`), a
read-only restore preflight was completed. The backup set was detected:

```text
2026-09-17--20-15-07_lineage_TB8704-userdebug_11_RQ3A211001001_e
```

Before opening the Restore menu, the backup set was confirmed to be present,
the Boot and Recovery backup hashes matched their current raw partitions, the
complete Windows copy was available, `/cache/recovery/command` contained no
`--wipe_data`, and no unexpected partition-backup files were present.

TWRP read the backup metadata successfully and offered exactly these restore
targets:

```text
Persist
Boot
Recovery
```

`Data`, `System`, `System Image`, `Cache`, `Lenovo Custom`, `Firmware` and
`Misc` were not offered. No critical firmware, security or EFS partition was
offered, including `aboot`, `abootbak`, `tz`, `tzbak`, `rpm`, `rpmbak`,
`devcfg`, `devcfgbak`, `modemst1`, `modemst2`, `fsg`, `fsc`, `keymaster` or
`keymasterbak`. This matches the intentionally restricted recovery fstab.

No Restore action or Swipe to Restore was performed. No Boot, Recovery or
Persist write occurred; Boot and Recovery remained unchanged. The complete
external Windows backup copy remained available, preserving an independent
copy before any possible future restore test.

This validates on real hardware that TWRP recognizes the backup set, reads its
restore metadata, offers only `Persist`, `Boot` and `Recovery`, and excludes
unexpected or critical firmware/security targets. Actual Restore of any
partition and post-write restore verification remain unvalidated.

## Phase 1D.1G - Qualcomm hardware FDE userspace

The Qualcomm common crypto integration is managed by a local repo manifest,
not by `omni.dependencies`. The pinned project is:

- Repository: `TeamWin/android_device_qcom_common`
- Branch provenance: `android-8.0`
- Commit: `c783b51fff4350e3d65c1519ea338e07f82ffb36`
- Manifest: `manifests/twrp-8.1-qcom-common.xml`

The Android 8.0 provenance is used because this commit contains the
Android-8-compatible `device/qcom/common/cryptfs_hw` build definitions. The
older Android 7.1 dependency was not used. The previous `omni.dependencies`
file was removed because Omni roomservice attempted to manage an already
manually checked-out project and failed to preserve the pinned checkout.

The TB-8704F FDE configuration now sets:

```text
TW_INCLUDE_CRYPTO := true
TARGET_HW_DISK_ENCRYPTION := true
```

`TARGET_KEYMASTER_WAIT_FOR_QSEE` is deliberately not set because this TWRP
8.1 branch has no implementation for that variable.

### Firmware verification

Physical TB-8704F verification established:

- Block device: `/dev/block/platform/soc/7824900.sdhci/by-name/modem`
- Kernel device: `/dev/block/mmcblk0p1`
- Filesystem: VFAT
- Size: 84.0 MiB
- Used: 33.4 MiB
- Read-only mount: successful
- Root entries: `/image`, `/verinfo`
- Firmware contents include Qualcomm `cmnlib`, `cmnlib64` and `securemm`

The recovery fstab exposes this partition only as:

```text
/firmware vfat /dev/block/platform/soc/7824900.sdhci/by-name/modem flags=mounttodecrypt;fsflags=ro
```

The local TWRP parser maps `mounttodecrypt` to `Mount_To_Decrypt=true` and
maps `fsflags=ro` through `Process_FS_Flags` to `Mount_Read_Only=true`. No
backup, wipe, storage, removable or flash flag is present. No additional
firmware, modem-state, bootloader or security partition is exposed, and no
`/firmware` fstab entry was added for any other partition.

### QSEE prebuilt provenance and closure

Only the verified direct/transitive closure was imported from
`brianreboot/twrp_device_lenovo_tb_8704f` at commit
`508409d8dcdf2084a5a165e07babe013d1854494`. The historical source paths,
Git blob IDs, local paths, hashes and direct `DT_NEEDED` entries are:

| File | Historical source path | Git blob SHA | Local target | SHA-256 | ELF | NEEDED relevant to closure |
| --- | --- | --- | --- | --- | --- | --- |
| `qseecomd` | `recovery/root/sbin/qseecomd` | `ca0e47689ff3757da2dfeda824514f1325635740` | `recovery/root/sbin/qseecomd` | `528ff279c4d26782082f8b70e628cd94f65db235989afa5c1bfc97fd7226af14` | ELF64 AArch64 | `libc.so`, `libcutils.so`, `libutils.so`, `liblog.so`, `libdl.so`, `libQSEEComAPI.so`, `libdrmfs.so`, `libc++.so`, `libm.so` |
| `libQSEEComAPI.so` | `recovery/root/vendor/lib64/libQSEEComAPI.so` | `5d6f128cd0165771334f4c7ffe50a842a148429e` | `recovery/root/vendor/lib64/libQSEEComAPI.so` | `9d37dcd350da334af5323ce982ab91a48dbb2d611314369af3f2bcf372177b3b` | ELF64 AArch64 | `libc.so`, `libcutils.so`, `libutils.so`, `libc++.so`, `libdl.so`, `libm.so` |
| `libdrmfs.so` | `recovery/root/sbin/libdrmfs.so` | `e133266c77b1da99d3bacfd39dbecaa3ddde90f0` | `recovery/root/vendor/lib64/libdrmfs.so` | `8a53e926ce7f6537176feec9c9f20d6d6e1af34ac88ee65a9af7daafbe625ec1` | ELF64 AArch64 | `libutils.so`, `libcutils.so`, `libdiag.so`, `liblog.so`, `libQSEEComAPI.so`, `libc++.so`, `libdl.so`, `libc.so`, `libm.so` |
| `libdiag.so` | `recovery/root/sbin/libdiag.so` | `dfa9891c60a3be5c7c3cddc931f910608511fb80` | `recovery/root/vendor/lib64/libdiag.so` | `5c5177670088565b55e39da4bd37d6d7e95954c368cdc7e5ba3a018ef6b495ec` | ELF64 AArch64 | `libc.so`, `libc++.so`, `libdl.so`, `libm.so`, `liblog.so` |
| `keystore.msm8953.so` | `recovery/root/vendor/lib64/hw/keystore.msm8953.so` | `fb600161d5405b94be9846cca74af041e0db042e` | `recovery/root/vendor/lib64/hw/keystore.msm8953.so` | `6e106b5780818a638aaaec8c354fc2fab60c628522c24e2dd40e588bab112f71` | ELF64 AArch64 | `liblog.so`, `libc.so`, `libdl.so`, `libcrypto.so`, `libcutils.so`, `libhardware.so`, `libc++.so`, `libm.so` |

The ordinary Android runtime libraries in that closure are provided by the
TWRP build and are present in the recovery `/sbin` search path. The final
linker configuration searches `/sbin` and `/vendor/${LIB}`. Therefore the
single canonical QSEE library path is `/vendor/lib64/libQSEEComAPI.so`, which
also satisfies the explicit `cryptfs_hw` LP64 `dlopen` path. `qseecomd` and
`libdrmfs.so` resolve their QSEE libraries through the same vendor search
path; no duplicate `/sbin` copies are used.

The historical QSEE binaries reference `/firmware/image`; the verified
read-only `/firmware` mount closes that path statically. The Qualcomm
`cryptfs_hw` implementation also requires
`/dev/block/bootdevice/by-name/keymaster`; `change_blockdev` creates only the
legacy alias to the verified physical SDHCI directory. The recovery fstab
continues to use direct physical paths.

### Build and static result

`libcryptfs_hw` was recognized and built successfully from the pinned
QCOM-common tree. The complete recovery build also succeeded:

- Image: `TB8704F-twrp-phase1d1g-qcom-fde.img`
- Size: 23,502,848 bytes
- SHA-256: `d4eeba1a02b5a4364845180b6365273c8970683a445667559f559c53193dad1d`
- Required ramdisk files: present, including `qseecomd`, `change_blockdev`,
  `init.recovery.qcom.rc`, `libcryptfs_hw.so` and
  `/vendor/lib64/libQSEEComAPI.so`
- `ueventd -> ../init`: unchanged and valid

The Qualcomm `cryptfs_hw` implementation contains an
`ERR_MAX_PASSWORD_ATTEMPTS` path that can write
`/cache/recovery/command` with `--wipe_data` and reboot recovery. The
QCOM-common source was not modified. No decrypt test is authorized until
this behavior is separately reviewed and safeguarded.

No device access, ADB, fastboot, flash or decrypt test was performed.

## Phase 1D.1H - safeguarded Qualcomm FDE dependency

The Qualcomm common dependency now uses the SnisLab fork:

- Upstream: `TeamWin/android_device_qcom_common`
- Upstream basis: `c783b51fff4350e3d65c1519ea338e07f82ffb36`
- Fork: `SnisLab/android_device_qcom_common`
- Safe commit: `8d57af0d3ba83215987b444a5996532aad2e6b1b`
- Recovery manifest: `manifests/twrp-8.1-qcom-common.xml`

The fork is based exactly on the Android-8.0 upstream pin. Its only
functional change is to neutralize the destructive `wipe_userdata()` body in
`cryptfs_hw/cryptfs_hw.c`. The function now logs refusal of an automatic
userdata wipe and performs no file write or recovery reboot. The
`ERR_MAX_PASSWORD_ATTEMPTS` error remains unchanged and continues to be
returned to the caller; all QSEE, Keymaster, ICE and cryptfs logic is
otherwise unchanged.

The repo-managed checkout required one scoped
`repo sync --force-sync --no-clone-bundle device/qcom/common` because the
project path changed from TeamWin to SnisLab object metadata. No
`--force-checkout` or dirty-tree removal was used. The resulting checkout is
clean and pinned to the safe commit.

The safe rebuild completed successfully:

- `libcryptfs_hw`: built successfully from the SnisLab safe commit
- Recovery image: `TB8704F-twrp-phase1d1h-safe-fde.img`
- Image size: 23,502,848 bytes
- Image SHA-256: `85e6867e1db9ce07598283c3c5345fad16aed2b6ef4f134aa23bb4621601a91e`

The intermediate 64-bit `libcryptfs_hw.so` and the copy extracted from the
final `ramdisk-recovery.cpio` contain the refusal log:

```text
ERR_MAX_PASSWORD_ATTEMPTS received; refusing automatic userdata wipe in recovery
```

Neither contains `--wipe_data` or `/cache/recovery/command`. The final
ramdisk retains the complete QSEE/FDE closure, `/vendor/lib64` runtime path,
read-only `mounttodecrypt` firmware entry and direct physical fstab paths.
No device boot or decrypt test was performed.

## Phase 1D.1D: Android base product inheritance

The first formal 8.1 build completed, but its recovery ramdisk did not contain
`/init` or `/sbin/recovery`. The cause was that `omni_tb_8704f.mk` inherited
`device.mk` directly and skipped the normal Android base product layer.

The minimal fix was committed as:

```text
6a320a6 recovery: restore Android base product inheritance
```

The product now inherits `full_tb_8704f.mk`, which inherits
`full_base_telephony.mk` and then `device.mk`. No manual `init` or `recovery`
packages were added. The transitive base chain reaches `embedded.mk`, where
the standard `init` and `recovery` product packages are selected.

The incremental build used:

```text
mka recoveryimage 2>&1 | tee /tmp/tb8704f-phase1d1d-base-product-build.log
```

It completed successfully. The resulting image is:

```text
out/target/product/tb_8704f/recovery.img
size: 22503424 bytes
sha256: 3b1e081476e0e6bbe167bbd204eb05bf41d0a53f5d8291b801d5f31d6f8e226b
```

Static inspection of the final image found a legacy Android boot header
version 0 with 2048-byte pages. The kernel address is `0x80008000`, the
ramdisk address is `0x81000000`, the tags address is `0x80000100`, and the
second address is `0x80f00000`. The gzip ramdisk is 12438769 bytes. The
complete command line is:

```text
console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=qcom msm_rtb.filter=0x237 ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 earlycon=msm_hsl_uart,0x78af000 androidboot.selinux=permissive enforcing=0 buildvariant=eng
```

The extracted kernel remains SHA-256
`9ed23e2eae57b61350110faaccd2a4a6fa6a3651535788275dd7aa0db55dff0c`.
The embedded TWRP version is `3.7.0_9-0`, obtained from the recovery binary.

The final ramdisk contains regular ELF files `/init`, `/sbin/recovery`,
`/sbin/twrp` and `/sbin/adbd`. `/sbin/ueventd` is the Android-conventional
symlink `../init`. `sbin/ld.config.txt` is present, and direct ELF
dependencies checked for recovery, TWRP and the keymaster service are present
in the ramdisk.

The final recovery fstab contains only `system`, `system_image`, `data`,
`cache`, `persist`, `lenovocust`, `boot`, `recovery`, `misc`, `sdcard1` and
`usb-otg`. No critical raw firmware partitions are present. The keymaster
service library is present for documentation only; crypto, QSEE and
keymaster-backed decryption remain disabled.

This is a static build result only. No device test, ADB, fastboot or flash
operation has been performed.

## Phase 1D.1E: physical block-device path verification

A temporary boot of TWRP 3.7.0_9-0 on a real TB-8704F was successful and ADB
was confirmed working. The recovery did not expose the alias
`/dev/block/bootdevice/by-name`; consequently the internal partitions were not
recognized or mounted by the previous image.

The physically verified kernel block-device path is:

```text
/dev/block/platform/soc/7824900.sdhci/by-name
```

All internal entries in `device/lenovo/tb_8704f/recovery.fstab` now use this
direct path. The MicroSD and USB OTG paths were not changed. No Qualcomm
`change_blockdev` binary, legacy helper, additional partition or crypto
configuration was added.

The source change is:

```text
570485c recovery: use verified TB-8704F block paths
```

The new image was built with the existing output tree:

```text
size: 22503424 bytes
sha256: 43d5751fd841ca18794004433768b883c4dc30652f085b69de0f57bc68db27c0
```

The embedded recovery fstab was inspected directly from the new gzip ramdisk.
Its internal entries for `system`, `userdata`, `cache`, `persist`,
`lenovocust`, `boot`, `recovery` and `misc` all use the verified path, and no
`bootdevice/by-name` alias remains. The earlier userspace gates remain valid:
`/init`, `/sbin/recovery`, `/sbin/twrp` and `/sbin/adbd` are present, while
`/sbin/ueventd` is the symlink `../init`. Direct ELF dependencies remain
available in the ramdisk and the kernel SHA-256 remains
`9ed23e2eae57b61350110faaccd2a4a6fa6a3651535788275dd7aa0db55dff0c`.

No write, wipe or backup test has been performed. The image has not been
flashed.

## Phase 1D.1O: QSEE loader closure and separate strace artifact

The recovery device makefile now copies the three proprietary QSEE runtime
libraries needed directly by `/sbin/qseecomd` into `/sbin`:

```text
/sbin/libQSEEComAPI.so
/sbin/libdrmfs.so
/sbin/libdiag.so
```

The existing `/vendor/lib64` copies remain unchanged. This avoids relying on a
manual `LD_LIBRARY_PATH` when launching `qseecomd`, while preserving the
existing vendor runtime layout. `strace` is not a recovery package and is not
copied into the recovery ramdisk.

The loader-only recovery build completed successfully. Static inspection of
the final ramdisk confirmed `qseecomd`, all three `/sbin` libraries, the three
`/vendor/lib64` libraries and `vendor/lib64/hw/keystore.msm8953.so`. The
`/sbin` and `/vendor/lib64` copies have identical SHA-256 values:

```text
libQSEEComAPI.so  9d37dcd350da334af5323ce982ab91a48dbb2d611314369af3f2bcf372177b3b
libdrmfs.so       8a53e926ce7f6537176feec9c9f20d6d6e1af34ac88ee65a9af7daafbe625ec1
libdiag.so        5c5177670088565b55e39da4bd37d6d7e95954c368cdc7e5ba3a018ef6b495ec
```

The resulting image is:

```text
TB8704F-twrp-phase1d1o-qsee-loader.img
size: 23568384 bytes
sha256: 9955d0fd1ec45deeb036c6e14fe7fd2ba41252937066d40da4e34cc4ee4fdb86
```

`strace` was built separately with the same product environment as an
ELF64/AArch64 binary using `/system/bin/linker64`. It is kept outside the
device tree at `out/diagnostics/strace-arm64` and is not part of the image.
Its SHA-256 is:

```text
a137e7613e740fbd8a3e195d7c325e2e1169e36d4c71e8d4688f8037e8148a29
```

No device boot, ADB, fastboot, flash or decrypt test was performed.

## Phase 1D.1Q: qseecomd RPMB/SSD runtime closure

The patched recovery-compatible `strace` from Phase 1D.1P was used for one
diagnostic `qseecomd` invocation. The existing loader libraries loaded
successfully. The first fatal runtime failure was:

```text
openat("/sbin/librpmb.so", O_RDONLY|O_CLOEXEC) = -1 ENOENT
qseecomd then exit_group(-1)
+++ exited with 255 +++
```

No `/dev/qseecom` or `/dev/ion` access occurred before exit, and
`/firmware/image` was not accessed. `sys.keymaster.loaded` remained empty.
The failure therefore occurred before QSEE/Keymaster initialization.

The qseecomd string audit found these dynamic library references:

```text
librpmb.so
libssd.so
```

Both files were imported exclusively from the TB-8704F-specific historical
tree `brianreboot/twrp_device_lenovo_tb_8704f` at commit
`508409d8dcdf2084a5a165e07babe013d1854494`:

```text
recovery/root/sbin/librpmb.so
  Git blob: ac6dea09b70f7d47e4146989f006404da453a549
  Size: 27952 bytes
  SHA-256: 837c62c8c2f72d17e56d919662e2bc68056245e7f690810ed58263bfcdff1f16
  ELF: ELF64/AArch64
  SONAME: librpmb.so
  DT_NEEDED: libutils.so, libQSEEComAPI.so, liblog.so, libc++.so, libdl.so,
    libc.so, libm.so

recovery/root/sbin/libssd.so
  Git blob: eab409dbee8664ab17bbaa553ad586a4069eca1d
  Size: 10280 bytes
  SHA-256: ce3b7a009c9b9b8f479f453f2f5922b4c733d6466ab82a4a3e8cbfdbc4019914
  ELF: ELF64/AArch64
  SONAME: libssd.so
  DT_NEEDED: libutils.so, libcutils.so, libdiag.so, liblog.so,
    libQSEEComAPI.so, libc++.so, libdl.so, libc.so, libm.so
```

The complete direct dependency closure was already present in the recovery
`/sbin` output, so no additional proprietary libraries were imported. The
device makefile adds only `librpmb.so` and `libssd.so` to `/sbin`; no historical
directory-wide import was made. `strace` remains absent from the recovery
image.

The recovery build completed successfully. The resulting image is:

```text
TB8704F-twrp-phase1d1q-rpmb.img
size: 23582720 bytes
sha256: 14b2d8014ec49f3e48007048b532ab1fa4a0f8eb7933d305d2c423d81deb3475
TWRP: 3.7.0_9-0
kernel sha256: 9ed23e2eae57b61350110faaccd2a4a6fa6a3651535788275dd7aa0db55dff0c
```

The Crypto/FDE settings remain enabled, the QCOM common checkout remains at
the safeguarded SnisLab commit `8d57af0d3ba83215987b444a5996532aad2e6b1b`,
and the recovery `libcryptfs_hw` contains the refusal safety log without
`--wipe_data` or `/cache/recovery/command`. The fstab is unchanged.

No device boot, hardware, ADB, fastboot, flash or decrypt test was performed.

## Phase 1D.1R: successful hardware QSEE/RPMB initialization

The Phase 1D.1Q image was temporarily booted on a real Lenovo TB-8704F. The
boot succeeded and the TWRP 3.7.0_9-0 interface was visible. The user selected
`Keep Read Only`; no persistent recovery installation or flash was performed.

The tested image was:

```text
TB8704F-twrp-phase1d1q-rpmb.img
size: 23582720 bytes
sha256: 14b2d8014ec49f3e48007048b532ab1fa4a0f8eb7933d305d2c423d81deb3475
```

After ADB became available, the runtime reported:

```text
sys.keymaster.loaded=true
init.svc.qseecomd=running
```

Two `qseecomd` processes were present. This is recorded as observed runtime
state and is not treated as an error or changed. `/sbin/librpmb.so` and
`/sbin/libssd.so` were present, and the kernel reported a detected RPMB
partition. Therefore the earlier Phase 1D.1P startup failure
`openat("/sbin/librpmb.so", ...) = -1 ENOENT` followed by `exit_group(-1)` is
no longer the startup blocker in this recovery.

Together, `sys.keymaster.loaded=true` and `init.svc.qseecomd=running` show that
qseecomd passed the previously missing RPMB/SSD initialization stage and that
Keymaster initialization reached the point where the runtime property was
set. This does not establish that `/data` decryption or FDE fully works, and
no PIN was tested.

The following actions were deliberately not performed: manual qseecomd run,
strace run, decrypt, PIN test, read-write mount, wipe, format, flash or
persistent recovery installation. The manual trace was skipped because Gate A
was satisfied by `sys.keymaster.loaded=true`.

## Phase 1D.1S: successful hardware FDE decryption

The Phase 1D.1Q image was temporarily booted with fastboot on a real Lenovo
TB-8704F. The tested image was `TB8704F-twrp-phase1d1q-rpmb.img`, size
23582720 bytes, with SHA-256
`14b2d8014ec49f3e48007048b532ab1fa4a0f8eb7933d305d2c423d81deb3475`. TWRP
3.7.0_9-0 was used. No recovery flash was performed.

Before decryption, the device reported:

```text
ro.crypto.state=encrypted
ro.crypto.type=block
/data: not mounted
sys.keymaster.loaded=true
init.svc.qseecomd=running
```

Exactly one known-correct device PIN was entered manually through the TWRP
interface. The PIN was not entered through ADB, stored, logged or included in
reports. TWRP accepted the attempt successfully. Afterwards, `/data` was
mounted and readable as ext4 through:

```text
/dev/block/dm-0
```

The paths `/data/media/0` and `/data/system` were present. The recovery log
confirmed:

```text
Data successfully decrypted, new block device: '/dev/block/dm-0'
```

This validates on real hardware the chain from TWRP credential input through
the cryptfs/hardware FDE path, Qualcomm Keymaster/QSEE, RPMB/SSD runtime,
dm-crypt mapping and the ext4 `/data` mount. It establishes that QSEE and
Keymaster initialize, RPMB support initializes, hardware-backed FDE
credential processing succeeds, `/dev/block/dm-0` is created and `/data` can
be mounted and read. It does not validate complete backup/restore, MTP, USB
storage, permanent recovery flashing or all TWRP functions.

After successful decryption, `/cache/recovery/command` was absent and neither
`--wipe_data` nor an automatic userdata wipe occurred. The safeguard remained
effective. No second PIN attempt, wipe, format, flash, persistent recovery
installation, manual qseecomd start or strace run was performed.

## Phase 1D.1T: backup capability and storage survey

On the real Lenovo TB-8704F, using TWRP 3.7.0_9-0 booted from
`TB8704F-twrp-phase1d1q-rpmb.img` (SHA-256
`14b2d8014ec49f3e48007048b532ab1fa4a0f8eb7933d305d2c423d81deb3475`), a
read-only backup and storage survey was performed. No source change, build,
new image, flash or persistent recovery installation was involved.

The runtime fstab exposed the expected backup-capable entries:

```text
/system
/system_image
/data
/cache
/persist
/lenovocust
/boot
/recovery
```

`/firmware` and `/misc` were not exposed as backup targets. The following
critical firmware, security and EFS partitions were also not offered:

```text
keymaster  keymasterbak
rpm        rpmbak
tz         tzbak
modemst1   modemst2
fsg        fsc
```

No other unexpected critical raw partitions were exposed. This confirms that
the deliberately restricted recovery fstab behaves as intended on hardware.

At survey time, `/data` was decrypted through `/dev/block/dm-0`, mounted and
readable as ext4. Usage was 1.6G used and 50.3G free. Internal storage
`/data/media/0` was available. MicroSD and USB-OTG were neither detected nor
mounted, so no external recovery backup target was available.

`/sbin/twrp` was present and only its help was read. No `backup`, `restore`,
`wipe` or `format` command was executed, and no unknown CLI command was tried.

An actual rescue backup using only the same `userdata` partition would not be
a complete safeguard against failure or loss of `userdata`. For a small next
functional test, a limited backup may be written to `/data/media/0` and copied
to the Windows host over ADB. That test must not include `/data`; the planned
initial set is `Boot`, `Recovery` and `Persist`. Restore remains unauthorized.

No real backup, restore, wipe, format, flash or persistent recovery
installation was performed.

## Phase 1D.1U: successful hardware TWRP backup

On the real Lenovo TB-8704F, using TWRP 3.7.0_9-0 from
`TB8704F-twrp-phase1d1q-rpmb.img` (SHA-256
`14b2d8014ec49f3e48007048b532ab1fa4a0f8eb7933d305d2c423d81deb3475`), a
limited hardware backup test completed successfully. The backup set contained
only `Boot`, `Recovery` and `Persist`, stored on Internal Storage under the
backup name `phase1d1u-test`. `Data`, `System`, `System Image`, `Cache` and
`Lenovo Custom` were not backed up.

TWRP reported successful completion. The remote backup size was 128.4M, and
the complete backup directory was copied over ADB to the Windows test host at:

```text
C:\adb\TB8704F-Lab\dumps\phase1d1u-backup\
```

The raw Boot partition had SHA-256
`c8452ea44988f7cab79b759a574170a34be185e2acd84e82e19eff7b9267926f` before
the backup. The Boot backup was a bit-identical raw copy, and the raw Boot
hash was unchanged afterwards. The raw Recovery partition had SHA-256
`5f45d4deb20c67894d5ed97861ed6f6192e241630fccd12500ee48aad8903ce5` before
the backup. The Recovery backup was a bit-identical raw copy, and the raw
Recovery hash was unchanged afterwards. Thus both raw read paths and raw
backup images were validated without modifying either source partition.

`persist.ext4.win` was present, validating the filesystem-based ext4 Persist
backup path. Persist restore and semantic comparison against every original
file were not tested. No `.md5` files were generated. This is recorded as
observed behavior of the current TWRP version, not as a backup failure: Boot
and Recovery were independently matched to their raw partitions, and the
copied files were additionally recorded with SHA-256 on the host. TWRP digest
generation itself was not validated.

The newly created backup directory remained on the tablet below
`/data/media/0/TWRP/BACKUPS/...`. No partition was written by this test.

This validates the TWRP backup UI path, raw Boot and Recovery backups,
filesystem-based Persist backup, internal-storage output and complete ADB
copy to the Windows host. Restore, Data, System, System Image, Cache, Lenovo
Custom, external MicroSD and USB-OTG backups, and TWRP digest generation
remain unvalidated. No restore, flash, wipe, format, Data backup, System
backup, source change, new build or persistent recovery installation was
performed.
