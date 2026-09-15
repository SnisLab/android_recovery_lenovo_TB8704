# TB-8704F partition inventory

Status: physical TB-8704F partition map verified and reviewed. Source-only
entries and unknowns remain explicitly identified below.

| Name | Source path | Filesystem | Size | Recovery relevance | Evidence |
| --- | --- | --- | --- | --- | --- |
| system | `/dev/block/bootdevice/by-name/system` (`/dev/block/mmcblk0p25`) | ext4 | `4080218112` bytes | Read/mount; image backup later | Physically verified; matches BoardConfig |
| userdata | `/dev/block/bootdevice/by-name/userdata` (`/dev/block/mmcblk0p51`) | ext4 | `56823880704` bytes | Mount, wipe, backup/restore; decrypt test required | Physically verified; matches F-only BoardConfig |
| cache | `/dev/block/bootdevice/by-name/cache` (`/dev/block/mmcblk0p26`) | ext4 | `268435456` bytes | Mount/wipe; backup optional | Physically verified; matches BoardConfig |
| persist | `/dev/block/bootdevice/by-name/persist` (`/dev/block/mmcblk0p27`) | ext4 | `33554432` bytes | Read/mount; preserve and back up before experiments | Physically verified; matches BoardConfig |
| lenovocust | `/dev/block/bootdevice/by-name/lenovocust` (`/dev/block/mmcblk0p50`) | ext4 | `209715200` bytes | Read/mount; preserve | Physically verified; source fstab entry |
| boot | `/dev/block/bootdevice/by-name/boot` (`/dev/block/mmcblk0p22`) | raw eMMC | `67108864` bytes | Read/backup; do not write in bring-up | Physically verified; matches BoardConfig |
| recovery | `/dev/block/bootdevice/by-name/recovery` (`/dev/block/mmcblk0p23`) | raw eMMC | `67108864` bytes | Read/backup; dedicated recovery candidate | Physically verified; matches BoardConfig |
| misc | `/dev/block/bootdevice/by-name/misc` (`/dev/block/mmcblk0p28`) | raw eMMC | `1024 KiB` / `1048576` bytes | Read only if needed for boot metadata | Mapping/size physically verified; purpose source-derived |
| config / frp | `/dev/block/bootdevice/by-name/config` mounted at `/frp` (`/dev/block/mmcblk0p30`) | raw eMMC | `32 KiB` / `32768` bytes | Do not modify | Mapping/size physically verified; mount/purpose source-derived |
| dsp | `/dev/block/bootdevice/by-name/dsp` (`/dev/block/mmcblk0p12`) | ext4 | `16384 KiB` / `16777216` bytes | Do not modify | Mapping/size physically verified; filesystem/purpose source-derived |
| modem | `/dev/block/bootdevice/by-name/modem` (`/dev/block/mmcblk0p1`) | raw eMMC | `86016 KiB` / `88080384` bytes | Never write; firmware/modem data | Mapping/size physically verified; purpose source-derived |
| modemst1 | `/dev/block/bootdevice/by-name/modemst1` (`/dev/block/mmcblk0p13`) | raw eMMC | `1536 KiB` / `1572864` bytes | Never write; EFS data | Mapping/size physically verified; purpose source-derived |
| modemst2 | `/dev/block/bootdevice/by-name/modemst2` (`/dev/block/mmcblk0p14`) | raw eMMC | `1536 KiB` / `1572864` bytes | Never write; EFS data | Mapping/size physically verified; purpose source-derived |
| fsg | `/dev/block/bootdevice/by-name/fsg` (`/dev/block/mmcblk0p17`) | raw eMMC | `1536 KiB` / `1572864` bytes | Never write; EFS data | Mapping/size physically verified; purpose source-derived |
| fsc | `/dev/block/bootdevice/by-name/fsc` (`/dev/block/mmcblk0p2`) | raw eMMC | `1 KiB` / `1024` bytes | Never write; EFS data | Mapping/size physically verified; purpose source-derived |
| aboot | `/dev/block/bootdevice/by-name/aboot` (`/dev/block/mmcblk0p20`) | raw eMMC | `1024 KiB` / `1048576` bytes | Never write; bootloader | Mapping/size physically verified; purpose source-derived |
| cmnlib | `/dev/block/bootdevice/by-name/cmnlib` (`/dev/block/mmcblk0p40`) | raw eMMC | `256 KiB` / `262144` bytes | Never write; security firmware | Mapping/size physically verified; purpose source-derived |
| cmnlib64 | `/dev/block/bootdevice/by-name/cmnlib64` (`/dev/block/mmcblk0p42`) | raw eMMC | `256 KiB` / `262144` bytes | Never write; security firmware | Mapping/size physically verified; purpose source-derived |
| tz | `/dev/block/bootdevice/by-name/tz` (`/dev/block/mmcblk0p8`) | raw eMMC | `2048 KiB` / `2097152` bytes | Never write; trust zone | Mapping/size physically verified; purpose source-derived |
| rpm | `/dev/block/bootdevice/by-name/rpm` (`/dev/block/mmcblk0p6`) | raw eMMC | `512 KiB` / `524288` bytes | Never write; firmware | Mapping/size physically verified; purpose source-derived |
| keymaster | `/dev/block/bootdevice/by-name/keymaster` (`/dev/block/mmcblk0p44`) | raw eMMC | `256 KiB` / `262144` bytes | Never write; security firmware | Mapping/size physically verified; purpose source-derived |
| devcfg | `/dev/block/bootdevice/by-name/devcfg` (`/dev/block/mmcblk0p10`) | raw eMMC | `256 KiB` / `262144` bytes | Never write; firmware | Mapping/size physically verified; purpose source-derived |
| microSD | `/dev/block/mmcblk1p1`, whole device `/dev/block/mmcblk1` | VFAT in TWRP fstab; runtime auto | unknown | Removable storage | Maintainer TWRP fstab |
| USB OTG | `/dev/block/sda1`, whole device `/dev/block/sda` | VFAT in TWRP fstab; runtime auto | unknown | Removable storage | Maintainer TWRP fstab |

The physical `userdata` size is `56823880704` bytes. Its decrypted device
mapper device `dm-0` is `55492055` KiB, exactly `16384` bytes smaller. This
confirms the source-derived `encryptable=footer,length=-16384` behavior.

The F-only TWRP fstab additionally exposes `dsp`, `lenovocust`, `persist`,
firmware/modem, bootloader subpartitions, and EFS/modem partitions for
backup. Their presence in a backup fstab does not make them safe write targets.

The Android fstab additionally names `dsp`, `modem`, and `oem` as mounted
runtime partitions, but supplies no size. They are not recovery write targets.

## Verification classification

Physically verified: the model, kernel version, empty slot properties, lack of
A/B and dynamic partitions, separate boot/recovery partitions, and the seven
listed physical partition mappings and sizes.

Source-derived: filesystem types, by-name aliases, recovery flags, and
unverified partitions not present in the reviewed physical map.

Still unknown: numerical mappings and sizes for removable `microSD` and `USB
OTG` devices; exact temporary-boot acceptance; and feature-level recovery
behavior. Filesystem and purpose claims for the internal raw partitions remain
source-derived unless explicitly stated otherwise.

## Architecture conclusions

The public fstab and reviewed device both have one `boot`, one `recovery`, and
no slot suffixes or `super`/dynamic partitions. The device is physically
confirmed as A-only with a dedicated recovery partition.

The source treats `boot` and `recovery` as separate raw images. Do not assume
that one is a ramdisk alias for the other.

## Never-touch and backup policy

Never write `aboot`, `tz`, `rpm`, `devcfg`, `cmnlib`, `cmnlib64`, `keymaster`,
modem/EFS, `dsp`, `persist`, `config`/FRP, or other firmware/security
partitions. Before later experiments, obtain verified read-only backups of
stock `boot`, `recovery`, `system`, `userdata` metadata, `persist`, `misc`,
and all critical firmware partitions using a reviewed, device-specific method.
No backup or flash command is prescribed in Phase 0.
