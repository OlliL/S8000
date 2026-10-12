
# S8000 WDC Interface Reference

This document describes the host-visible behavior of the S8000 Winchester Disk
Controller (WDC), the way the S8000 CPU firmware uses it, and the controller
firmware evidence that helps interpret the host command stream. It is intended
as a structured technical reference distilled from the current project notes and
 source material.

<!-- TOC -->
* [S8000 WDC Interface Reference](#s8000-wdc-interface-reference)
  * [1. Purpose and scope](#1-purpose-and-scope)
  * [2. Evidence model and source classes](#2-evidence-model-and-source-classes)
  * [3. System context](#3-system-context)
  * [4. Host-visible WDC interface](#4-host-visible-wdc-interface)
    * [4.1 Register block and addressing](#41-register-block-and-addressing)
    * [4.2 Unified host / CP / capture mapping](#42-unified-host--cp--capture-mapping)
    * [4.3 Command launch and status register](#43-command-launch-and-status-register)
  * [5. CPU firmware interaction with the WDC](#5-cpu-firmware-interaction-with-the-wdc)
    * [5.1 Controller selection](#51-controller-selection)
    * [5.2 Boot-time WDC command path](#52-boot-time-wdc-command-path)
    * [5.3 Disk-read command path](#53-disk-read-command-path)
    * [5.4 DMA address programming model](#54-dma-address-programming-model)
  * [6. WDC controller firmware behavior](#6-wdc-controller-firmware-behavior)
    * [6.1 Event capture and dispatch model](#61-event-capture-and-dispatch-model)
    * [6.2 Meaning of upper command-byte bits](#62-meaning-of-upper-command-byte-bits)
    * [6.3 Internal status/result handling](#63-internal-statusresult-handling)
  * [7. Command map and confidence](#7-command-map-and-confidence)
  * [8. Diagnostic path and signal-capture evidence](#8-diagnostic-path-and-signal-capture-evidence)
    * [8.1 Power-up diagnostics](#81-power-up-diagnostics)
    * [8.2 Captured CPU-side bus evidence](#82-captured-cpu-side-bus-evidence)
    * [8.3 Why diagnostics are not the normal I/O path](#83-why-diagnostics-are-not-the-normal-io-path)
  * [9. ZEUS driver correlation](#9-zeus-driver-correlation)
  * [10. Geometry, media model, and transfer size](#10-geometry-media-model-and-transfer-size)
    * [10.1 Logical versus physical geometry](#101-logical-versus-physical-geometry)
    * [10.2 Track extent versus host-visible sector payload](#102-track-extent-versus-host-visible-sector-payload)
  * [11. Emulator implications](#11-emulator-implications)
  * [12. Open questions](#12-open-questions)
  * [13. References](#13-references)
<!-- TOC -->

## 1. Purpose and scope

- These notes focus on the S8000 CPU 1.2 firmware sources [S1-S3].
- The WDC is the controller selected by device code `3` in this firmware. It
  controls SA1000 drives [S17], but the CPU-side sources alone do not establish
  the full media geometry or disk-side protocol.
- The WDC controller contains a Z80 processor [S17].
- No hard disk is currently attached to the WDC [S17]. Disk-operation
  diagnostics are therefore expected to report failures; such failures must not
  be interpreted as evidence of successful drive access.

## 2. Evidence model and source classes

- Treat executable instructions and their control flow as primary evidence.
  Source comments are hypotheses, not authoritative protocol documentation.
- Distinguish observed CPU bus instructions from documented semantics. The WDC
  manuals describe the CPU/ZBI-facing register interface and command
  requirements; the available captures record CPU-side WDC diagnostic I/O, not
  disk-side signals [S5-S7, S12-S14].
- The Z8000 CPU manual describes signal `B/W` as Byte/Word, with low = word
  [S16, p. 250]. The available diagnostic captures include `/B/W`, so they can
  contribute direct evidence about whether the observed CPU-side WDC cycles were
  byte or word transactions.
- SADIE [S7] is a separate diagnostic toolset that must be loaded from tape and
  then executed. That tape is not available in this project context [S17], so
  SADIE can only be used here as auxiliary documentation, not as evidence of
  executed local test runs or of the captured failure sequence.
- In-text source IDs refer to the bibliography at the end; file line ranges are
  relative to the listed files.

## 3. System context

- Supplied drive geometry [S17]: nominal capacity 24 MB, 3 data surfaces (about
  8 MB per surface), 605 physical tracks per surface, track density
  554 tracks/inch, and 13,440 bytes per track.
- The ZEUS administration manual's 24 MB CDC Finch `zd` entry identifies 43,200
  logical 512-byte blocks; this is 600 logical cylinders at 3 heads x
  24 sectors, not 605 logical cylinders [S15].
- The applicable ZEUS system models for that `zd` entry are Systems 20 and 30
  [S15].

## 4. Host-visible WDC interface

### 4.1 Register block and addressing

The CPU disk firmware dispatches disk I/O by `DEVICE_CODE` [S1]. Only device
code `3` selects the WDC path; device codes `1` and `2` select the separate
SMC and MDC paths. Do not interpret every `DISK` reference or every use of
`0x80f0` as WDC traffic: the examined `0x80f0` accesses belong to MDC code in
both the disk and test sources [S1-S2].

The WDC manual describes sixteen 8-bit command registers at relative addresses
`xx00`-`xx0f` and an 8-bit command/status register at `xx10` [S5]. The block
resides on a 256-word CPU I/O boundary, with upper address bits set by
controller jumpers [S5]. The CPU firmware uses base address `0x8000` [S1-S2].

| Host addr | Relative | Firmware symbol | Meaning |
|---|---:|---|---|
| `0x8000` | `xx00` | `WDC_REG_CMD` | Command |
| `0x8001` | `xx01` | `WDC_REG_DRV` | Unit / drive |
| `0x8002` | `xx02` | `WDC_REG_HEAD` | Head |
| `0x8003` | `xx03` | `WDC_REG_CYL_LO` | Cylinder low |
| `0x8004` | `xx04` | `WDC_REG_CYL_HI` | Cylinder high |
| `0x8005` | `xx05` | `WDC_REG_SECTOR` | Sector |
| `0x8008` | `xx08` | `WDC_REG_TRANSWRD_CNT_LO` | Transfer word count low |
| `0x8009` | `xx09` | `WDC_REG_TRANSWRD_CNT_HI` | Transfer word count high |
| `0x800a` | `xx0a` | `WDC_REG_TRANSADDR_B0` | Transfer address bits 7-0 |
| `0x800b` | `xx0b` | `WDC_REG_TRANSADDR_B1` | Transfer address bits 15-8 |
| `0x800c` | `xx0c` | `WDC_REG_TRANSADDR_B2` | Transfer address bits 23-16 |
| `0x800d` | `xx0d` |  | Reserved register slot; documented as transfer-address bits 32-24 |
| `0x8010` | `xx10` | `WDC_REG_STAT` | Command/status in reads; also written by the CPU firmware |

The manual identifies `xx06` and `xx07` as reserved, `xx0d`-`xx0f` as
reserved, and `xx10` as the C/S register [S5]. `xx0d` is a documented reserved
register slot associated with possible transfer-address bits 32-24, but the
documented host interface uses a 24-bit transfer address in `xx0a`-`xx0c` /
CP10-CP12 [S5-S6]. No examined host-side source or manual command description
uses `xx0d` as an active fourth DMA-address byte.

Keep the distinction between register width and CPU instruction width: the WDC
manual documents byte-wide registers, while the CPU firmware often issues 16-bit
`in`/`out` instructions [S1-S2, S5]. For emulation, preserve the observed bus
access pattern while applying the documented byte-register semantics.

Appendix B describes command codes as occupying bits 0-4 of the command byte
[S6]. The unit register accepts drive numbers 0-3 [S5].

### 4.2 Unified host / CP / capture mapping

The CPU-visible register block, the Appendix-B CP numbering, and the WDC
firmware's captured-port snapshot align as follows:

| Host addr | Relative | CP | Z80 captured port | Event offset | Meaning | Status |
|---|---:|---:|---:|---:|---|---|
| `0x8000` | `xx00` | CP0 | `0x60` | `IX+1` | Command | documented + observed |
| `0x8001` | `xx01` | CP1 | `0x61` | `IX+2` | Unit | documented + observed |
| `0x8002` | `xx02` | CP2 | `0x62` | `IX+3` | Head | documented + observed |
| `0x8003` | `xx03` | CP3 | `0x63` | `IX+4` | Cylinder low | documented + observed |
| `0x8004` | `xx04` | CP4 | `0x64` | `IX+5` | Cylinder high | documented + observed |
| `0x8005` | `xx05` | CP5 | `0x65` | `IX+6` | Sector | documented + observed |
| `0x8006` | `xx06` | CP6 | `0x66` | `IX+7` | Reserved | documented reserved, positionally captured |
| `0x8007` | `xx07` | CP7 | `0x67` | `IX+8` | Reserved | documented reserved, positionally captured |
| `0x8008` | `xx08` | CP8 | `0x68` | `IX+9` | Transfer word count low | documented + observed |
| `0x8009` | `xx09` | CP9 | `0x69` | `IX+10` | Transfer word count high | documented + observed |
| `0x800a` | `xx0a` | CP10 | `0x6a` | `IX+11` | Transfer address bits 7-0 | documented + observed |
| `0x800b` | `xx0b` | CP11 | `0x6b` | `IX+12` | Transfer address bits 15-8 | documented + observed |
| `0x800c` | `xx0c` | CP12 | `0x6c` | `IX+13` | Transfer address bits 23-16 | documented + observed |
| `0x800d` | `xx0d` | CP13 | `0x6d` | `IX+14` | Reserved / possible address extension | documented reserved, positionally captured |
| `0x800e` | `xx0e` | CP14 | `0x6e` | `IX+15` | Reserved | documented reserved, positionally captured |
| `0x800f` | `xx0f` | CP15 | `0x6f` | — | Reserved | documented reserved, not captured |
| `0x8010` | `xx10` | — | — | — | C/S register | documented, separate from CP snapshot |

This 15-byte snapshot arises because the controller firmware reads ports `0x60`
through `0x6e` and stores them contiguously in the event record [S4]. Under
Appendix-B numbering [S6], that yields CP0 through CP14. The manual's register
table marks `xx0d`-`xx0f`—that is, the positions corresponding to
CP13-CP15—as reserved [S5], so the final captured bytes should be treated as
positional captures rather than documented command parameters. The code does
not read port `0x6f` (CP15 by this numbering) or the separate C/S register [S4].
The exact electrical mapping from these Z80 ports to the host CP register block
is an inference from firmware behavior and matching field use, not a mapping
explicitly named in the examined manuals.

### 4.3 Command launch and status register

At the host interface, software loads the request parameters into byte-wide
command registers, then writes the command byte last [S5-S6]. The command
register write clears the status byte, enables host/controller handshaking, and
starts the operation [S5].

The WDC manual describes host transactions as passing through controller
connector P1/J13 over the ZBI, while disk-drive transactions use the separate
P2/J23 drive bus [S5]. For emulation, the primary contract established here is
therefore the ZBI-facing register/status interface plus controller access to
host memory at the programmed DMA address, not the disk-side signaling details.

The CPU firmware also writes `0x8010` before launching commands [S1], but the
manual only documents the command-register write as the clear/start action [S5].
Record that write as observed CPU behavior, but do not assume that it writes or
clears the host C/S byte. The documented clear/start action is the subsequent
command-register write [S5]. The effect, if any, of `out 0x8010` remains
unresolved, and the examined manual sections do not define the meanings of host
C/S bits 7, 3, 1, or 2.

## 5. CPU firmware interaction with the WDC

### 5.1 Controller selection

The CPU disk source dispatches reads by `DEVICE_CODE` [S1, lines 450-469]:

| Device code | Path | Notes |
|---|---|---|
| `1` | SMC | Separate controller interface; uses ports such as `0x7f00`. |
| `2` | MDC | Separate mini-disk controller path; includes accesses at `0x80f0` and memory-mapped workspace around `0xfeb4`. |
| `3` | WDC | The controller interface at `0x8000`-`0x8010`. |

Do not interpret every `DISK` reference or every use of `0x80f0` as WDC
traffic. In the examined sources, `0x80f0` accesses belong to MDC routines, not
WDC routines [S1-S2].

### 5.2 Boot-time WDC command path

`DSK_BOOT` dispatches to `WDC_BOOT` when the selected device code is `3`
[S1, lines 156-180]. `WDC_BOOT` performs the following setup [S1, lines 473-502]:

- Stores `3` at `0xfeb6` and `0x18` (24 decimal) at `0xfeb7`.
- Loads the immediate address `0xfeb4`, outputs it at `0x800a`, swaps the
  bytes, and outputs it at `0x800b`.
- Writes zero at `0x800c` and `0x8010`.
- Writes command value `0x16` to `0x8000`.

The ZEUS `zd` driver also issues command `0x16` [S9], with the same
DMA-address-first setup and the same status-polling pattern. This strongly
suggests a shared command function and very likely the same numeric WDC host
command, even though its published name is still unknown.

Both this boot command and normal sector reads share the completion sequence at
`WDCBOOT_CMD` [S1, lines 488-502]. The sequence writes the command register,
then repeatedly reads `0x8010` until bit 7 is set, then reads status until
either bit 1 is set or, with bit 1 clear, bit 3 is set. There is no visible
timeout in this polling path.

This polling sequence is the normal host command-completion path used by the
CPU boot/read code. Similar bit tests also appear in the diagnostic code [S2],
but those diagnostics serve a different purpose and should not be read as the
normal disk-I/O setup sequence.

Appendix B does not give numeric opcode values [S6], so command-name
assignments must be inferred from host-side usage, parameter fingerprints, and
controller-firmware behavior rather than read directly from the manual.

### 5.3 Disk-read command path

`READ_DISK` chooses exactly one controller from `DEVICE_CODE` [S1, lines
450-469]. For WDC it calls `WDC_READ_DISK`, which receives the block address in
register pair `rr4` from its callers:

- `READ_INODE` forms an address in `rr4` and calls `READ_DISK`
  [S1, lines 282-324].
- `READ_DSK_BLOCK` loads the next address from the block-pointer array into
  `rr4` and calls `READ_DISK` [S1, lines 328-342].

The WDC setup sequence appears in `WDC_READ_DISK` [S1, lines 505-534]:

1. Interpret the logical block address in `rr4` as a sector offset, with
   24 sector positions per addressed track.
2. Divide the track index by the head count in `0xfeb6` (initialized to `3`)
   so that remainder = head and quotient = cylinder.
3. Write zero to `0x8010`, `0x8001`, `0x8008`, `0x800a`, and `0x800c`.
4. Write the cylinder number to `0x8003` and zero to `0x8004`.
5. Load `DISK_BUFFER` (`0xfa00`) into `r0`, byte-swap its bytes, and write the
   resulting low byte to `0x800b`; see Section 5.4 for the general register-load
   pattern.
6. Set `r0` to `1`, write it to `0x8009`, and jump to `WDCBOOT_CMD`.

Semantically, the controller is given:

- sector offset at `0x8005`
- head number at `0x8002`
- cylinder number at `0x8003`

The CPU firmware computes these fields as:

- `sector = LBA % 24`
- `track_index = LBA / 24`
- `head = track_index % 3`
- `cylinder = track_index / 3`

`WDC_BOOT` initializes the sector and head divisors at `0xfeb7` and `0xfeb6`
[S1, lines 473-488]. The code writes the sector offset directly, with no
visible `+1`. The WDC manual says sector 00 immediately follows the index pulse
[S5], and the SADIE test description independently documents the same
24-sector / 3-head rollover [S7, pp. 201-202]. Since SADIE is a separate
tape-loaded diagnostic environment that is not available here [S17], this
remains supporting manual evidence rather than evidence from locally executed
tests.

### 5.4 DMA address programming model

The WDC manual defines a 24-bit transfer address in three 8-bit registers:

- `0x800a` = bits 7-0
- `0x800b` = bits 15-8
- `0x800c` = bits 23-16

The CPU-side programming pattern used in the examined sources is:

1. Load the 16-bit host address into a register.
2. Write that register to `0x800a`, relying on the controller to latch the low
   byte as address bits 7-0.
3. Swap the two bytes in the CPU register.
4. Write the swapped register to `0x800b`, again relying on the controller to
   latch the low byte, now carrying address bits 15-8.
5. Write zero to `0x800c`, making address bits 23-16 zero in the observed CPU
   paths.

This explains why the code byte-swaps before writing `0x800b`: it places the
desired host-address byte in the low half of the CPU register for the addressed
8-bit WDC register. The available sources do not establish which Z8000 word-I/O
lane the hardware physically latches, so that electrical detail remains open.

For the boot transfer, the source uses the literal DMA address `0xfeb4`
[S1, lines 473-488]:

1. `ld r0,#%feb4` makes `r0 = 0xfeb4`.
2. `out %800a,r0` is expected to latch low byte `0xb4`.
3. `exb rh0,rl0` swaps the bytes to `0xb4fe`.
4. `out %800b,r0` is expected to latch low byte `0xfe`.
5. `xor r0,r0` and `out %800c,r0` latch `0x00`.

The resulting programmed register values are `0x800a = 0xb4`, `0x800b = 0xfe`,
and `0x800c = 0x00`, giving DMA address `00:FE:B4` = `0x00feb4`.

For a normal WDC read, the DMA buffer is `DISK_BUFFER = 0xfa00` [S1]:

1. `0x800a` is written with zero.
2. `ld r0,#DISK_BUFFER` gives `0xfa00`; byte-swap yields `0x00fa`.
3. `out 0x800b,r0` latches `0xfa`.
4. `0x800c` is written with zero.

The resulting programmed register values are `0x800a = 0x00`, `0x800b = 0xfa`,
and `0x800c = 0x00`, giving DMA address `00:FA:00` = `0x00fa00`.

The manual also defines a 16-bit word count at `xx08`/`xx09`; a 512-byte sector
is 256 words [S5]. The CPU firmware clears `xx08` and writes `1` to `xx09`,
programming `0x0100` words = one sector [S1].

## 6. WDC controller firmware behavior

### 6.1 Event capture and dispatch model

The reconciled Z80 listing contains an indexed operation dispatcher [S4]:

1. `service_pending_event` at `0x0160` selects records beginning at `0x75c4`;
   records are `0x2a` bytes apart. The first byte (`IX+0`) is a state selecting
   a five-entry state table at `0x088d`.
2. State `1` enters `dispatch_device_state` at `0x01a4`. It reads `IX+1`,
   masks it with `0x1f`, rejects values `>= 0x18`, and dispatches through the
   24-entry table at `0x0895`.
3. `scan_input_event` reads port `0x60`, masks its low five bits, and for
   ordinary events `record_input_event` stores 15 bytes from `0x60` through
   `0x6e` beginning at `IX+1`.
4. The first captured byte becomes `IX+1`, which is the selector used by the
   dispatcher.

This strongly links the dispatched value to the host command byte, although the
exact electrical mapping from Z80 ports `0x60`-`0x6e` to the host CP register
block remains an inference from the firmware sequence and matching field use.

### 6.2 Meaning of upper command-byte bits

The upper command-byte bits are not merely part of a wider opcode [S4]:

- Bit 5 (`0x20`) is tested in `clear_device_event`; when set, it enables an
  additional handshake through Z80 ports `0x21` and `0x41`.
- Bit 6 (`0x40`) changes completion/error handling by bypassing the normal
  pending-event state in the observed handlers.
- Bit 7 (`0x80`) is tested by `transfer_controller_data` and gates loading the
  request's unit/head/cylinder/sector into controller state.

These are observed control effects. The available manuals do not give final
host-side names for these bits. The SADIE manual identifies command controls
for inhibiting implicit seek, inhibiting retries, and enabling interrupts, but
does not supply their command-byte masks [S7, pp. 200-201]. Since SADIE is an
external tape-loaded diagnostic environment that is not available here [S17],
that source is used only as supporting documentation, not as evidence from a
local test run. Do not model `0x20`, `0x40`, or `0x80` as separate published
opcodes; they are observed control bits whose exact host-level names remain
unresolved.

### 6.3 Internal status/result handling

The CPU's `0x8010` reads [S1-S2] are reads of the WDC host-facing C/S register,
not Z80 CPU flags. The manuals say the controller places command result/status
there for the host CPU to read [S5].

The Z80 listing contains no explicit `OUT` to host address `0x8010` and no
single routine that obviously composes a C/S byte [S4]. That does not mean the
result path is unrelated to C/S; rather, the Z80 I/O space and the host I/O
space are distinct views and may be coupled by board logic.

Relevant internal evidence [S4]:

- `status_error_*` branches load explicit values into `C`: `0x10`, `0x80`,
  `0x40`, `0x08`, and `0x09`. A `0x20` result also appears on the
  sector-transfer completion/progress path.
- `record_device_operation_status` stores the selected value at
  `IX+WDC_EVENT_STATUS` (`IX+0x17`), changes the event state to `3`,
  resets/waits for the controller interface, and raises bit 7 in internal byte
  `0x733d`.
- `clear_device_event` can perform a channel-state transfer through Z80 I/O port
  `0x41`, gated by port `0x21`.
- Command `0x03` separately constructs a three-word status/data record and
  copies it to host memory. That payload is not itself the one-byte C/S
  register.

There is suggestive overlap between internal result values and host-tested bit
positions, but no demonstrated one-to-one mapping. Internal event status values
must not be relabeled as host C/S bytes without identifying the publication
path.

The host polling paths observed in CPU and ZEUS code first wait for bit 7,
then either terminate on bit 1 or, with bit 1 clear, continue waiting for bit 3
[S1, S9]. That host-visible sequence still does not establish a direct one-to-one
mapping from internal Z80 result values to host C/S bit meanings.

The observed controller-firmware result values include `0x10`, `0x80`, `0x40`,
`0x08`, `0x09`, and `0x20` [S4]. These are firmware-internal result/status
values selected on particular controller paths; they must not be assumed to be
identical to the byte later read by the host from the WDC C/S register at
`0x8010`.

In particular, `record_device_operation_status` stores the selected value at
`IX+WDC_EVENT_STATUS` (`IX+0x17`), updates the event state, resets/waits for
the controller interface, and sets bit 7 in internal byte `0x733d` [S4]. These
are concrete steps in the controller's internal completion path, but the
available evidence does not yet show how that path is published onto the
host-visible C/S register.

The publication path still needs to be traced through event-state transitions,
the `0x21`/`0x41` handshake, and any intervening board logic before internal
event-status values can be mapped confidently onto host-visible C/S bits.

## 7. Command map and confidence

Appendix B names the host operations and lists their parameter sets, but does
not assign numeric command-field values [S6]. The following cross-reference uses
host-side usage, parameter fingerprints, and WDC firmware behavior to map
command field values to likely operations.

| Opcode | Appendix B command | Appendix | Confidence | Handler address | Handler label | Observed behavior / interpretation |
|---:|---|---:|---|---:|---|---|
| `0x00` | Null | B.7 | Strong | `0x03e1` | `command_00_null_handler` | Completes or clears the event/operation state, consistent with Null performing no disk operation. |
| `0x01` | Read Sector | B.3 | Very strong | `0x020c` | `command_01_readsector_handler` | Uses unit, head, cylinder, sector, word count, and 24-bit DMA address. The CPU read path issues `0x01`. |
| `0x02` | Write Sector | B.4 | Moderate | `0x02dc` | `command_02_writesector_handler` | Uses the same parameter set as `0x01`, with a distinct transfer path. Write direction still needs confirmation. |
| `0x03` | Read Detailed Status | B.5 | Very strong | `0x0375` | `command_03_readdetailedstatus_handler` | Uses unit and DMA address, builds three words of status, and copies them to host memory. The diagnostic CPU code issues `0x03` for this transfer. |
| `0x04` | Restore | B.6 | Strong | `0x03c5` | `command_04_restore_handler` | Initializes unit operation state, selects the drive, and enters shared device-operation/status handling. |
| `0x05` | Format | B.2 | Tentative | `0x01e4` | `command_05_format_handler` | Selects the unit and branches into longer per-device actions, potentially including the inferred unit-wide format/verify flow. The path is shared, so the format mapping is not proved. |
| `0x06` | Seek | B.8 | Tentative | `0x052a` | `command_06_seek_handler` | Calls shared validation and per-device action routines tied to disk-address state. Those helpers work with disk-address state, but this handler alone does not prove that it performs Seek. |
| `0x07` | Set Strobe/Offset | B.9 | Tentative | `0x05a2` | `command_07_setstrobeoffset_handler` | Copies CP2 into a per-device record. That matches the manual's placement of the SO value in CP2; the indirect unit-specific effect is not fully traced. |
| `0x08` |  |  | High (handler behavior only) | `0x05ab` | `command_08_invalid_handler` | Immediately enters `invalid_state_fallback`, which clears/rejects the event with error code `0x08`. No operation body is present. |
| `0x09` |  |  | High (handler behavior only) | `0x05ae` | `command_09_invalid_handler` | Immediately enters `invalid_state_fallback`, clearing/rejecting the event with error code `0x08`. |
| `0x0a` |  |  | High (handler behavior only) | `0x05b1` | `command_0A_invalid_handler` | Immediately enters `invalid_state_fallback`, clearing/rejecting the event with error code `0x08`. |
| `0x0b` | Format Read | B.11 | Strong | `0x05b4` | `command_0B_formatread_handler` | Uses disk address and DMA address but no ordinary word count; the fixed-size transfer includes a formatted-sector record, consistent with reading header plus data. |
| `0x0c` | Set Interrupt Address | B.12 | Very strong | `0x0692` | `command_0C_setinterruptaddress_handler` | Takes CP5 and writes it to I/O port `0x40`, consistent with programming the interrupt-transfer address. |
| `0x0d` |  |  | High (handler behavior only) | `0x069a` | `command_0D_invalid_handler` | Immediately enters `invalid_state_fallback`, clearing/rejecting the event with error code `0x08`. |
| `0x0e` |  |  | Low | `0x069d` | `command_0E_startup_handler` | Enters shared startup/initialization code: disables interrupts, copies/validates a block in SRAM, and selects a continuation. It is not enough evidence to call it Self Test. |
| `0x0f` |  |  | Moderate (behavior only) | `0x06d5` | `command_0F_updatecylinder_handler` | Clears a mode flag and copies an internal cylinder value from `IX+0x15/0x16` to the captured cylinder bytes. Likely an internal completion/update event rather than a documented disk command. |
| `0x10` |  |  | High (handler behavior only) | `0x0209` | `command_10_invalid_handler` | Immediately enters `invalid_state_fallback`, clearing/rejecting the event with error code `0x08`. |
| `0x11` |  |  | High (handler behavior only) | `0x0206` | `command_11_invalid_handler` | Immediately enters `invalid_state_fallback`, clearing/rejecting the event with error code `0x08`. |
| `0x12` |  |  | Moderate | `0x070e` | `command_12_readcontrollerstate_handler` | Selects a unit, queries shared controller/device state, and clears or reports status. Likely a controller-internal state/event operation rather than a disk command. |
| `0x13` | Unit Format Verify | B.15 | Strong | `0x073e` | `command_13_unitformatverify_handler` | Iterates through cylinders and heads verifying a unit. |
| `0x14` |  |  | Low | `0x06e8` | `command_14_unknown_handler` | Sets an internal mode flag, calls shared initialization/action code, then completes the event. Its operation is not distinctive enough to name. |
| `0x15` |  |  | Low | `0x0801` | `command_15_unknown_handler` | Builds a small parameter block and copies a fixed two-byte result to host memory. The meaning of this data is unknown. |
| `0x16` |  |  | Moderate (behavior only) | `0x0835` | `command_16_readdeviceinfo_handler` | A host-used DMA-returning command. The handler collects six fields from each of four internal device records and copies the 24-byte result to the host DMA address. The same numeric host command is issued by the CPU boot path and the ZEUS `zd` driver, but its official published name remains unknown. |
| `0x17` | Format Verify | B.14 | Tentative | `0x0610` | `command_17_formatverify_handler` | Selects unit/head/cylinder and runs a track-format validation path; it also interprets CP5 as flags/options. |

The dispatch table covers every value from `0x00` through `0x17` [S4]. No
opcode has yet been reliably matched to Set Write Protect (B.10) or Self Test
(B.13).

## 8. Diagnostic path and signal-capture evidence

### 8.1 Power-up diagnostics

`TEST_` samples the boot-device switches into `ABOOT_DEV` and later walks the
SMC, MDC, and WDC diagnostics [S3, lines 165-186, 2220-2250]. The WDC-specific
diagnostic code is in `WDC_TEST_ENTRY` / `WDC_TEST` [S2, lines 49-197]:

- Presence probe: write byte `0xa5` to `0x8001`, read it back, and compare.
  If the byte does not read back, the WDC is considered absent. If WDC is the
  selected boot device, report error `0x1000`.
- If present, display `WDC`. Only when it is the selected boot device does the
  diagnostic continue with drive value zero and command `0x04`.
- `WDC_TEST` first reads status and treats `(status & 3) == 3` as self-test
  error `0x1001`. It then waits for bit 7, issues the requested command, waits
  for bit 7 again and then bit 3, and requires status bits 1 and 2 to be clear.
- `WDC_CHECK_STATUS` retries up to `0x0fa0` (4000) status reads, invoking
  `TEST_DELAY` between unsuccessful reads [S2, lines 98-169, 592-608].
- If the `0x04` check fails, the diagnostic prepares several registers and
  calls `WDC_TEST` with command `0x03`. On success, it reads back command,
  drive, cylinder-high, and sector values for error reporting [S2].
- The helper named `WDC_TEST_UNKOWN_02` and its comments do not by themselves
  establish command semantics. There is unreachable code after a `ret` in that
  procedure; it should not be treated as protocol evidence.

### 8.2 Captured CPU-side bus evidence

The available CPU-side diagnostic captures provide several direct observations:

- In the CSV files, `Status[4:0]` is the Z8000 CPU bus status-line field, not
  the byte read from the WDC C/S register at `0x8010`. The observed diagnostic
  transfers show status value `2`, which matches the Z8000 CPU manual's
  `0010 = I/O Reference` status-line code [S16]. This confirms the cycle class,
  data values, and cycle direction/timing, but it does not independently
  identify a transfer's address [S12-S14].
- The CSV exports contain data-byte lanes and bus-control/status information,
  but no address lines [S12-S14]. They therefore cannot independently prove the
  accessed WDC register address or the board's dual-port-RAM address decode.
- The captures also include `/B/W` [S12-S14]. Per the Z8000 CPU manual, this is
  the Byte/Word output signal, with low = word [S16, p. 250]. In the observed
  active WDC diagnostic cycles (`/DS = 0`), `/B/W` is high throughout the
  captured transactions. That directly supports the conclusion that these
  captured CPU↔WDC diagnostic accesses are byte transactions, consistent with
  the WDC manual's byte-wide register interface [S5]. It does not by itself
  prove that every possible CPU-side WDC access in every firmware path is
  byte-wide.
- Part 01 records the `0xa5` presence-probe write and readback on the low byte
  lane, with `Status[4:0] = 2` [S12]. In that probe sequence, the write appears
  with `/R/W` low; the readback shows `Data LL = 0xa5` while `Data LH = 0xff`.
  Since the capture exports do not include address lines, the register identity
  still follows from matching the observed sequence to the source routine, not
  from the capture alone.
- Part 02 records reads returning `0xf1` [S13].
- Part 03 records reads returning `0xfd`, and later `0xf1` [S14].

These values align with the diagnostic status tests in `WDC_TEST` [S2]:

- `0xf1` has bit 7 set, bit 3 clear, and bits 1-2 clear.
- `0xfd` has bit 7 set, bit 3 set, bit 1 clear, and bit 2 set.

Under the source's zero-based bit numbering, `0xf1` can satisfy the initial
ready wait without satisfying the later bit-3 wait. `0xfd` can satisfy the
bit-3 wait and then fail the subsequent bit-2 check. This matches the observed
diagnostic failure path.

The available captures do not show `0x71`, so that intermediate value is not
confirmed by these exports.

### 8.3 Why diagnostics are not the normal I/O path

Diagnostics are useful evidence for presence detection and expected C/S
handshake behavior, but they are not the normal boot/read command path and
should not be mistaken for a complete controller initialization or data-transfer
sequence.

The current no-disk configuration [S17] further means that command `0x04`
diagnostics are observing the controller's no-drive/error behavior, not a
successful restore against a real disk. The captures show the status
progression and failure path, but they do not by themselves establish the exact
host-visible C/S bit encoding for the no-drive condition.

## 9. ZEUS driver correlation

`zd` is the ZEUS WDC-facing disk driver [S8-S11].

- `zd.nm` lists `_zdioaddr` as an unresolved external [S10].
- `conf2.icp.o` and `conf2.nicp.o` both define `_zdioaddr` as a data symbol at
  segment 1, offset `0x00be`, with stored word `0x8000` [S11].
- `_zdioaddr` is therefore a configuration/pointer slot containing the WDC I/O
  base, not the controller's own address `0x00be`. This explains why `zd.asm`
  uses indirect base-plus-register-offset accesses consistent with a WDC
  register block at base `0x8000` [S9, S11].
- `polled_command` writes the command at base `+0` and reads status at base
  `+16`, polling bit 7, then bit 1, then bit 3 [S9]. This matches the CPU
  firmware's WDC boot polling sequence.
- `zdopen` initializes each six-byte per-drive parameter record with values `3`
  and `24`, which `zdstart` later uses as divisors while converting block
  numbers to drive coordinates [S9].
- `zdopen` also issues command `0x16` with only the DMA address prepared, just
  as the CPU boot path does [S1, S9].
- `zdstart` writes request fields at base offsets `+1` through `+5`, transfer
  count at `+8`/`+9`, and DMA address at `+10` through `+12`, then issues
  command `0x21` or `0x22` [S9].

Because Appendix B defines only bits 0-4 as the command field [S6], and the
controller firmware masks the command byte with `0x1f` before dispatch [S4],
`0x21` and `0x22` select the same handlers as `0x01` and `0x02` respectively.
The extra `0x20` bit enables the additional port-`0x21`/`0x41` handshake path
observed in controller firmware [S4]. Do not model `0x21` and `0x22` as
independent published read/write opcodes distinct from `0x01` and `0x02`.

The combination of drive sizes [S8], register layout [S5], status polling [S1,
S9], `_zdioaddr` initialization [S11], and matching command behavior identifies
`zd` as the WDC driver with very strong confidence.

## 10. Geometry, media model, and transfer size

The CPU code and manuals together support the following host-visible geometry
model:

- 24 sector positions per addressed track [S1, S5, S7]
- 3 heads per cylinder [S1, S17]
- 512-byte sector transfers [S5-S6]

### 10.1 Logical versus physical geometry

The ZEUS administration manual gives 43,200 logical 512-byte blocks for the
24 MB `zd` configuration [S15]. That is 22,118,400 bytes (about 21.1 MiB),
exactly matching 600 cylinders x 3 heads x 24 sectors. This differs from the
supplied 605 physical tracks per surface [S17] by five tracks per surface.

Reserved tracks, defect handling, or differing physical-versus-logical geometry
could explain the difference, but the current evidence does not resolve it. Do
not expose 605 cylinders as the logical block range without further evidence.

The administration manual also lists interleaving factors `m=12`, `n=72`
[S15], but their meaning and any effect on logical block ordering are not
established here. They should not be treated as host-interface rules or as a
proven LBA-to-physical ordering model.

### 10.2 Track extent versus host-visible sector payload

The supplied track extent is 13,440 bytes [S17]. With 24 addressed sector
positions per track, that averages 560 bytes per sector position. The WDC
manuals, however, document ordinary sector data transfers as 512 bytes [S5-S6].
The 13,440-byte track extent must therefore not be interpreted as
24 x 560 bytes of host-visible sector payload.

If the track extent includes recorded headers, gaps, CRC fields, or other
formatting overhead, its 560-byte-per-sector-position average is compatible
with 512-byte host-visible data fields. That is a plausible interpretation, not
yet a complete proof of the exact on-disk byte layout.

The SADIE format-read description distinguishes ordinary sector reads from a
format read that transfers a sector's header and CRC information along with its
data, for exactly one sector (`FRD`) [S7, pp. 199-200]. This supports treating
physical-format information as separate from the normal 512-byte payload, but
it does not by itself define the full raw byte layout of a track or fully
explain the 13,440-byte track extent.

## 11. Emulator implications

- Reproduce the host-facing sequence first: register addresses, access widths,
  write/read ordering, command values, polling behavior, and status transitions.
- Model DMA as host-memory access via the programmed 24-bit address and word
  count, not as a controller-local buffer.
- Preserve the distinction between byte-wide WDC registers and the CPU's
  sometimes 16-bit `in`/`out` instructions.
- Do not infer undocumented meanings for `0x8010` writes or host C/S bits
  without further evidence.
- The CPU boot polling loop has no timeout [S1]; an emulator that never reaches
  the expected status condition can hang the host.

## 12. Open questions

- What is the official published name of command `0x16`?
- What are the exact host-visible meanings of C/S bits 7, 3, 1, and 2, and how
  do they map to documented controller error/completion conditions?
- Which host-side action acknowledges or clears each status/handshake state?
- Does `out 0x8010` have any defined controller effect?
- What are the exact host-level semantics of command bit `0x20`?
- Which byte lane or lanes are physically latched when the Z8000 issues word
  I/O cycles to the WDC's byte-wide registers?
- How do the documented 13,440 bytes/track map to 512-byte payload plus
  formatting overhead?
- What are the precise logical-versus-physical geometry bounds in the shipped
  configuration, including the observed 600-versus-605-cylinder discrepancy?
- Can the controller complete commands asynchronously relative to host polling?

## 13. References

- **[S1] CPU disk firmware:** `firmware/CPU/1.2/p.disk.s`
- **[S2] CPU miscellaneous-controller tests (including WDC):**
  `firmware/CPU/1.2/p.testothr.s`
- **[S3] CPU RAM/boot-device test flow:**
  `firmware/CPU/1.2/p.testram.s`
- **[S4] WDC controller Z80 listing and reference image:**
  `firmware/WDC/firmware.asm`; `firmware/WDC/firmware.bin`
- **[S5] WDC hardware manual, section 4.5.2:**
  `AI/ocr/03_3237_04__4_5_2_Winchester_Disk_Controller.txt`
- **[S6] WDC hardware manual, Appendix B (host commands):**
  `AI/ocr/03_3237_04__Appendix_B.txt`
- **[S7] SADIE WDC test descriptions (separate tape-loaded diagnostics):**
  `AI/ocr/03-3198-01__Appendix_E_SADIE_WDC_TEST_DESCRIPTIONS.txt`
- **[S8] ZEUS `zd` driver manual page:** `ZEUS/usr/sys/dev/zd.4`
- **[S9] ZEUS `zd` driver assembly:** `ZEUS/usr/sys/dev/zd.asm`
- **[S10] ZEUS `zd` symbol listing:** `ZEUS/usr/sys/dev/zd.nm`
- **[S11] ZEUS configuration objects defining `_zdioaddr`:**
  `ZEUS/usr/sys/conf/conf2.icp.o`; `ZEUS/usr/sys/conf/conf2.nicp.o`
- **[S12] CPU WDC diagnostic capture, part 01:**
  `SignalCaptures/CPU_1.2_WDC_TEST_ENTRY_Part01.csv`
- **[S13] CPU WDC diagnostic capture, part 02:**
  `SignalCaptures/CPU_1.2_WDC_TEST_ENTRY_Part02.csv`
- **[S14] CPU WDC diagnostic capture, part 03:**
  `SignalCaptures/CPU_1.2_WDC_TEST_ENTRY_Part03.csv`
- **[S15] ZEUS administration manual, disk characteristics table:**
  `AI/ocr/03_3246_04__page_3_13.txt` (OCR transcription, printed leaf page
  3-13; the PDF source is not in the workspace)
- **[S16] Z8000 CPU technical manual, status-line codes:**
  `https://bitsavers.org/components/zilog/z8000/Z8000_CPU_Technical_Manual_Jan83.pdf`
  (Table 2-1, p. 23)
- **[S17] Supplied project/owner context:**
  User-provided statements outside the repository sources.
