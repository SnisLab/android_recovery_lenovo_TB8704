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
| misc | `/dev/block/bootdevice/by-name/misc` | raw eMMC | unknown | Read only if needed for boot metadata | Maintainer fstab |
| config / frp | `/dev/block/bootdevice/by-name/config` mounted at `/frp` | raw eMMC | unknown | Do not modify | Source-derived; physical presence/size not established |
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

Still unknown: numeric mappings and sizes for `misc`, `config`/`frp`, `dsp`,
modem/EFS, bootloader subpartitions, microSD, and USB OTG; exact temporary-boot
acceptance; and feature-level recovery behavior.

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
