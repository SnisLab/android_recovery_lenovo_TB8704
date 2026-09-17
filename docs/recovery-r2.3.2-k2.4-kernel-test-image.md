# R2.3.2: K2.4 kernel recovery test image

## Scope

This is a local, controlled repack of the hardware-validated Phase 1D.1Q
Recovery image. The only changed boot-image component is the kernel. No TWRP
build, kernel build, device access, fastboot operation or flash was performed.

The base image is:

```text
TB8704F-twrp-phase1d1q-rpmb.img
size: 23582720 bytes
sha256: 14b2d8014ec49f3e48007048b532ab1fa4a0f8eb7933d305d2c423d81deb3475
```

The R2.3.1 roundtrip of the original image was byte-identical with the same
SHA-256. Its original extracted kernel was verified at 10060180 bytes with
SHA-256 `9ed23e2eae57b61350110faaccd2a4a6fa6a3651535788275dd7aa0db55dff0c`.
The original extracted ramdisk was 13517520 bytes with SHA-256
`de0e126d3140b25322cee30d4342137886cec9db741ab33bc5790a4b7576fcd5`.

## Kernel Replacement

The replacement was downloaded and verified from the Agent-2 handoff:

```text
TB8704F-kernel-3.18.140-k2.4-Image.gz-dtb
size: 10282679 bytes
sha256: c0b2011a09c5aa0e347069bc80730e8648ec4cd2687c4f5ceb8a40b400ad5240
kernel version: 3.18.140-lineageos-g4881b5d9
```

The known original kernel identity is `3.18.71-perf-gdbc2759-dirty`.
The replacement was used only as the `--kernel` input to `mkbootimg`; the
Recovery device-tree prebuilt was not modified.

## Repack Parameters

The existing TWRP 8.1 `mkbootimg` was reused. All non-kernel inputs and header
parameters matched the successful R2.3.1 roundtrip:

```text
base: 0x80000000
pagesize: 2048
kernel_offset: 0x00008000
ramdisk_offset: 0x01000000
tags_offset: 0x00000100
second_offset: 0x00f00000
os_version: 16.1.0
os_patch_level: 2018-11-01
board: empty
second payload: none
device-tree payload: none
```

The original cmdline was retained unchanged:

```text
console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=qcom msm_rtb.filter=0x237 ehci-hcd.park=3 androidboot.bootdevice=7824900.sdhci lpm_levels.sleep_disabled=1 earlycon=msm_hsl_uart,0x78af000 androidboot.selinux=permissive enforcing=0 buildvariant=eng
```

## Test Image

```text
TB8704F-twrp-1q-kernel-3.18.140-k2.4-test.img
path: /root/build/tb8704-r2.3/TB8704F-twrp-1q-kernel-3.18.140-k2.4-test.img
size: 23803904 bytes
sha256: 7ca127f542faa32be14cfb03b0b115e2d75c2fc219d07463bddb6daad5b1837a
recovery partition: 67108864 bytes
fits partition: yes
image size delta from base: 221184 bytes
```

## Static Verification

The test image was parsed with the same Android boot-header/component
extraction logic used for the original roundtrip. The extracted replacement
kernel was 10282679 bytes with SHA-256
`c0b2011a09c5aa0e347069bc80730e8648ec4cd2687c4f5ceb8a40b400ad5240`.
The extracted ramdisk remained byte-identical to the original:

```text
original ramdisk sha256: de0e126d3140b25322cee30d4342137886cec9db741ab33bc5790a4b7576fcd5
test ramdisk sha256:     de0e126d3140b25322cee30d4342137886cec9db741ab33bc5790a4b7576fcd5
ramdisk comparison: byte-identical
```

The following non-kernel header fields were identical between original and
test image: base-derived addresses, ramdisk size and address, second fields,
tags address, page size, DT size, OS version field, board/name and cmdline.
The OS version field remained `0x2004012b`, encoding version `16.1.0` and
patch level `2018-11`. Only kernel-size, the derived payload layout/image
size and the hash-derived image ID changed.

## Status

```text
Recovery source modifications: none
Recovery prebuilt kernel modified: no
Recovery build: no
Device access: none
Boot test: not performed
Flash: none
```
