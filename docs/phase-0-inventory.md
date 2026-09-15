# Phase 0 — Recovery inventory

Status: **research only**

## Goal

Build a verified evidence base for a modern TB-8704F recovery before importing or modifying recovery source code.

## Required outputs

Document the following with source/provenance for every material claim:

### 1. Existing TB-8704F recovery work
- known TWRP repositories and branches
- TWRP / Android base version
- BoardConfig values
- recovery image construction
- recovery kernel source/config
- `recovery.fstab`
- known working / broken features

### 2. Partition layout
For the **TB-8704F specifically**, document:
- partition name
- block-device path / by-name mapping
- filesystem where applicable
- purpose
- whether recovery needs read, mount, backup or flash access
- source of the information

Explicitly determine:
- whether the device is A-only or A/B
- whether it has a dedicated `recovery` partition
- relationship between `boot` and `recovery`

### 3. Recovery-relevant hardware
Document only what matters to recovery bring-up:
- display/framebuffer path
- touch controller
- eMMC/internal storage
- microSD
- USB / ADB
- encryption/data-decryption considerations

### 4. Baseline kernel dependency
Identify the most reliable legacy TB-8704F kernel source/configuration suitable for the first recovery build. Do not modify the kernel in this phase.

If kernel work will be required later, create a dependency request for `SnisLab/android_kernel_lenovo_msm8953`.

## Rules

- No implementation in Phase 0.
- Do not import a legacy tree into this repository yet.
- Do not start a TWRP build yet.
- Do not infer TB-8704F facts from TB-8504/TB-8703 or generic MSM8953 devices.
- Clearly mark contradictions and unknowns.
- Prefer primary/device-specific sources.

## Completion criteria

Phase 0 is complete when a reviewer can answer, from this repository alone:

1. Which exact existing recovery/device/kernel sources are the best baseline?
2. What is the verified TB-8704F partition map?
3. How should a recovery image for this device be assembled?
4. What hardware/functions must work before temporary boot is considered successful?
5. What remains uncertain and requires evidence from the physical tablet?
