# TB-8704F partition inventory

Status: partially verified from TB-8704 family source; physical TB-8704F
confirmation is still required. Paths below are logical by-name paths from
the device fstab, not guessed numeric `mmcblk0pN` mappings.

| Name | Source path | Filesystem | Size | Recovery relevance | Evidence |
| --- | --- | --- | --- | --- | --- |
| system | `/dev/block/bootdevice/by-name/system` | ext4 | `4080218112` bytes in BoardConfig | Read/mount; image backup later | Maintainer `rootdir/fstab.qcom`, `BoardConfig.mk` |
| userdata | `/dev/block/bootdevice/by-name/userdata` | ext4 | `9921059840` bytes image value; source comment gives `9921076224 - 16384` | Mount, wipe, backup/restore; decrypt test required | Maintainer fstab and BoardConfig |
| cache | `/dev/block/bootdevice/by-name/cache` | ext4 | `268435456` bytes | Mount/wipe; backup optional | Maintainer fstab and BoardConfig |
| persist | `/dev/block/bootdevice/by-name/persist` | ext4 | unknown | Read/mount; preserve and back up before experiments | Maintainer fstab |
| boot | `/dev/block/bootdevice/by-name/boot` | raw eMMC | `67108864` bytes | Read/backup; do not write in bring-up | Maintainer fstab and BoardConfig |
| recovery | `/dev/block/bootdevice/by-name/recovery` | raw eMMC | `67108864` bytes | Read/backup; dedicated recovery candidate | Maintainer fstab and BoardConfig |
| misc | `/dev/block/bootdevice/by-name/misc` | raw eMMC | unknown | Read only if needed for boot metadata | Maintainer fstab |
| config / frp | `/dev/block/bootdevice/by-name/config` mounted at `/frp` | raw eMMC | unknown | Do not modify; exact naming needs device confirmation | Maintainer `rootdir/fstab.qcom` |
| microSD | `/dev/block/mmcblk1p1`, whole device `/dev/block/mmcblk1` | VFAT in TWRP fstab; runtime auto | unknown | Removable storage | Maintainer TWRP fstab |
| USB OTG | `/dev/block/sda1`, whole device `/dev/block/sda` | VFAT in TWRP fstab; runtime auto | unknown | Removable storage | Maintainer TWRP fstab |

The Android fstab additionally names `dsp`, `modem`, and `oem` as mounted
runtime partitions, but supplies no size. They are not recovery write targets.

## Architecture conclusions

The public fstab has one `boot`, one `recovery`, and no slot suffixes or
`super`/dynamic partitions. This is consistent with A-only and a dedicated
recovery partition. It is not a physical-device proof; confirm by reading
`/proc/partitions`, `/dev/block/bootdevice/by-name`, and bootloader metadata on
the TB-8704F.

The source treats `boot` and `recovery` as separate raw images. Do not assume
that one is a ramdisk alias for the other.

## Never-touch and backup policy

Never write `aboot`, `tz`, `rpm`, `devcfg`, `cmnlib`, `cmnlib64`, `keymaster`,
modem/EFS, `dsp`, `persist`, `config`/FRP, or other firmware/security
partitions. Before later experiments, obtain verified read-only backups of
stock `boot`, `recovery`, `system`, `userdata` metadata, `persist`, `misc`,
and all critical firmware partitions using a reviewed, device-specific method.
No backup or flash command is prescribed in Phase 0.
