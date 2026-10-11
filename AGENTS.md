# S8000 WDC Controller Notes

This file is the working knowledge base for understanding the S8000 Z8001
firmware's interaction with the WDC Winchester Disk Controller. Add evidence
and unresolved questions here as further sources are examined.

## Scope and evidence policy

- These notes initially cover `firmware/CPU/1.2/`.
- The WDC is the controller selected by device code `3` in this firmware. Per
  project context it controls SA1000 drives; this CPU source alone does not
  establish the complete drive geometry or command protocol.
- The WDC controller contains a Z80 processor (confirmed project information).
- Drive geometry supplied for this project: nominal capacity 24 MB, 3 data
  surfaces (about 8 MB per surface), 605 tracks per surface, track density
  554 tracks/inch, and 13,440 bytes per track.
- Treat executable instructions and their control flow as primary evidence.
  Source comments are hypotheses, not authoritative protocol documentation;
  this is especially important for comments added by the firmware author.
- Distinguish observed CPU bus instructions from their documented semantics.
  The Zilog WDC manual sections examined so far describe the CPU/ZBI-facing
  register interface and command requirements; controller firmware and bus
  traces have not yet been examined.
- References below point to the current source tree and line ranges, so update
  them if those files change.

## Controller separation

`p.disk.s:450-469` dispatches disk reads using `DEVICE_CODE`:

| Device code | Path | Notes |
|---|---|---|
| `1` | SMC | Separate controller interface; uses ports such as `0x7f00`. |
| `2` | MDC | Separate mini-disk controller path; includes accesses at `0x80f0` and memory-mapped workspace around `0xfeb4`. |
| `3` | WDC | The controller interface at `0x8000`-`0x8010` described below. |

Do not interpret every `DISK` reference or every use of `0x80f0` as WDC
traffic. In particular, `0x80f0` accesses in `p.testothr.s` are inside
`MDC_TEST` (`p.testothr.s:211-303`), and the `0x80f0` accesses in `p.disk.s`
are in MDC routines (`p.disk.s:650-750`). Comments on those instructions that
call `0x80f0` a WDC register conflict with their routine and dispatch context;
they are not evidence that the WDC occupies that address.

## WDC register address names

The firmware defines the same address names in `p.disk.s:141-153` and
`p.testothr.s:33-46`.

| Address | Firmware symbol | Source-level name |
|---|---|---|
| `0x8000` | `WDC_REG_CMD` | Command |
| `0x8001` | `WDC_REG_DRV` | Drive |
| `0x8002` | `WDC_REG_HEAD` | Head |
| `0x8003` | `WDC_REG_CYL_LO` | Cylinder low |
| `0x8004` | `WDC_REG_CYL_HI` | Cylinder high |
| `0x8005` | `WDC_REG_SECTOR` | Sector |
| `0x8008` | `WDC_REG_TRANSWRD_CNT_LO` | Transfer word-count low |
| `0x8009` | `WDC_REG_TRANSWRD_CNT_HI` | Transfer word-count high |
| `0x800a` | `WDC_REG_TRANSADDR_B0` | Transfer address bits 7-0 |
| `0x800b` | `WDC_REG_TRANSADDR_B1` | Transfer address bits 15-8 |
| `0x800c` | `WDC_REG_TRANSADDR_B2` | Transfer address bits 23-16 |
| `0x800d` | `WDC_REG_TRANSADDR_B3` | Reserved; not part of the documented 24-bit DMA address |
| `0x8010` | `WDC_REG_STAT` | Status in reads; also written by the firmware |

The manual describes sixteen 8-bit command registers at relative addresses
`xx00`-`xx0f` and an 8-bit command/status register at `xx10`. The block is
located on a 256-word boundary in CPU I/O space, with upper address bits set
by controller jumpers. The source's base `0x8000` therefore represents this
controller's configured I/O block; the manual describes the upper address as
jumper-selectable rather than a universal WDC address.

The manual identifies `xx06` and `xx07` as reserved, `xx0d`-`xx0f` as
reserved, and `xx10` as the C/S register. `xx0d` is reserved for transfer
address bits 32-24; supported DMA addresses are 24-bit and use `xx0a`-`xx0c`.
The firmware's `WDC_REG_TRANSADDR_B3` name at `0x800d` does not make it an
active fourth address byte. Keep the distinction between register width and
CPU instruction width: the manual specifies byte registers, while the
firmware often issues 16-bit `in`/`out` instructions. Preserve exact bus
accesses in an emulator and apply the documented byte-register semantics.
Appendix B describes command codes as occupying bits 0-4 of the command byte.
The unit register accepts drive numbers 0-3.

## ZBI host interface

The WDC manual describes the controller as performing fully buffered data
transfers between the CPU/host and a selected drive. Host transactions pass
through controller connector P1/J13 over the ZBI; disk-drive transactions use
the separate P2/J23 drive bus. The emulator's relevant contract is therefore
the ZBI-facing command/status register interface plus controller access to
host memory at the programmed DMA address. Drive-bus signaling is outside
this CPU firmware analysis.

At the host interface, software loads the operation parameters into the
byte-wide command registers, including unit, head, cylinder, sector, word
count, and buffer address, then writes the command byte last. The low five
command-byte bits form the command field (Appendix B, B.1). The command
register write clears the status byte, enables handshaking, and starts the
operation (manual section 4.5.2.1, Table 4-14).

## Disk-read path

`READ_DISK` chooses exactly one controller from `DEVICE_CODE`
(`p.disk.s:450-469`). For WDC it calls `WDC_READ_DISK`, which receives the
block address in register pair `rr4` from its callers:

- `READ_INODE` forms an address in `rr4` and calls `READ_DISK`
  (`p.disk.s:282-324`).
- `READ_DSK_BLOCK` loads the next address from the block-pointer array into
  `rr4` and calls `READ_DISK` (`p.disk.s:328-342`).

The WDC setup sequence is in `p.disk.s:505-534`:

1. Interpret the logical block address in `rr4` as a sector offset, with 24
   sector positions for each addressed track. The controller's sector
   register `0x8005` receives the sector offset within that track.
2. Use the quotient from the division by 24 to select the head and cylinder:
   divide that track index by the head count in `0xfeb6` (initialized to `3`
   by `WDC_BOOT`); the division remainder is the head number and the quotient
   is the cylinder number.
3. Write zero to `0x8010`, `0x8001`, `0x8008`, `0x800a`, and `0x800c`.
4. Write the cylinder number to `0x8003` and zero to `0x8004`.
5. Load `DISK_BUFFER` (`0xfa00`) into `r0`, byte-swap its two bytes, and issue
   a 16-bit `out` instruction at `0x800b`. The resulting transfer address
   programmed is the DMA address of the buffer, not a value fetched from the
   buffer.
6. Set `r0` to `1`, write it to `0x8009`, and jump to the shared command/status
   sequence at `WDCBOOT_CMD`, which writes the command register last.

Semantically, the controller is given a sector offset at `0x8005`, a head
number at `0x8002`, and a cylinder number at `0x8003`: the head and cylinder
select the track, and the sector offset selects a position within that track.
The firmware computes these fields as `sector = LBA % 24`, `track_index =
LBA / 24`, `head = track_index % 3`, and `cylinder = track_index / 3`.
`WDC_BOOT` initializes the 24-sector conversion divisor at `0xfeb7` and the
three-head divisor at `0xfeb6` (`p.disk.s:473-488`). Thus the code represents
24 sector positions per addressed track and three heads per cylinder. It
writes the sector offset directly (no visible `+1`). The manual says sector
00 immediately follows the index pulse, consistent with zero-based sector
positions 0-23; verify any drive-format-specific exceptions separately.

The supplied track extent is 13,440 bytes and the drive geometry has 24 sector
positions per track. The WDC manual says a sector data transfer is 512 bytes,
so the 13,440-byte track extent must not be interpreted as 24 x 560 bytes of
host-visible sector payload. If the track extent includes the recorded
headers, gaps, or other formatting overhead, its 560-byte-per-sector-position
average is compatible with 512-byte data fields. This distinction needs
confirmation from drive-format documentation; host transfers are 512 bytes
per sector according to the WDC command manual.

`DISK_BUFFER` is the memory address passed to the WDC as the DMA buffer: for a
disk read the controller writes the data there; for a disk write it would
read the data from there. The CPU 1.2 path shown here exercises reads. The boot
path separately passes `0xfeb4` as a DMA address (`p.disk.s:473-488`).

The WDC manual defines this as a 24-bit address of the first word of the host
buffer, held in three 8-bit registers at `xx0a`-`xx0c`. It likewise defines a
16-bit word count at `xx08`/`xx09`; a sector is 512 bytes, or 256 16-bit words.
The firmware clears `xx08` then writes `1` to `xx09`, so the programmed count
is `0x0100` words (256 words = 512 bytes), exactly one sector. A count above
one sector requests a multiple-sector transfer. Read Sector transfers disk to
main memory; Write Sector transfers main memory to disk.

The host must program all request parameters before writing the command byte.
The manual explicitly says the command-register write is last because it
clears the status byte, enables host/controller handshaking, and starts the
operation. This register write is the controller's command launch point on
the ZBI-facing interface.

### DMA address programming, step by step

The manual defines three separate 8-bit registers for the 24-bit DMA address:

- `0x800a` stores address bits 7-0.
- `0x800b` stores address bits 15-8.
- `0x800c` stores address bits 23-16.

For the boot transfer, the source uses the literal DMA address `0xfeb4`:

1. `ld r0,#%feb4` makes the 16-bit register `r0 = 0xfeb4`.
2. `out %800a,r0` is a 16-bit CPU I/O instruction to the 8-bit register at
   `0x800a`. The intended latched value is the low byte, `0xb4`, which is
   address bits 7-0.
3. `exb rh0,rl0` swaps the bytes in `r0`, making `r0 = 0xb4fe`.
4. `out %800b,r0` is another 16-bit I/O instruction. The intended latched
   value is its low byte, `0xfe`, which is address bits 15-8.
5. `xor r0,r0` makes `r0 = 0x0000`; `out %800c,r0` therefore latches `0x00`
   into address bits 23-16.

With those byte-lane semantics, the three registers hold (high to low)
`00:FE:B4`, which is DMA address `0x00feb4`. The CPU does issue word outputs
whose full register values are `0xfeb4` and `0xb4fe`; those are not themselves
the successive 8-bit register values. The controller's 8-bit register is
expected to latch the low byte of each word output.

For a normal WDC read, `DISK_BUFFER` is `0xfa00`:

1. The firmware explicitly writes zero to `0x800a`, so address bits 7-0 are
   `0x00`.
2. `ld r0,#DISK_BUFFER` gives `r0 = 0xfa00`; `exb rl0,rh0` swaps the bytes to
   `r0 = 0x00fa`.
3. `out WDC_REG_TRANSADDR_B1,r0` writes to `0x800b`; the intended latched
   low byte is `0xfa`, so address bits 15-8 are `0xfa`.
4. The firmware explicitly writes zero to `0x800c`, so address bits 23-16 are
   `0x00`.

The resulting DMA address is `00:FA:00`, or `0x00fa00`.

This interpretation explains why the byte swap places the desired byte in
the low half of `r0` for the addressed register. It matches the manual's
8-bit register definitions and is consistent with the Z8000 host/Z80
controller byte-order difference. The manual does not specify which byte lane
of a Z8000 word I/O cycle the hardware latches, so confirm that electrical
detail from a ZBI trace if required for cycle-accurate emulation.

## Boot-time WDC sequence and completion polling

`DSK_BOOT` dispatches to `WDC_BOOT` when the selected device code is `3`
(`p.disk.s:156-180`). `WDC_BOOT` (`p.disk.s:473-502`) does the following:

- Stores `3` at `0xfeb6` and `0x18` (24 decimal) at `0xfeb7`.
- Loads the immediate address `0xfeb4`, outputs it at `0x800a`, swaps the
  bytes, and outputs at `0x800b`.
- Writes zero at `0x800c` and `0x8010`.
- Writes command value `0x16` to `0x8000`.

Both this boot command and normal sector reads share the completion sequence
at `WDCBOOT_CMD` (`p.disk.s:488-502`). The sequence writes `r0` to `0x8000`,
repeatedly reads `0x8010` until bit 7 is set, then reads status until either
bit 1 is set (return immediately) or, with bit 1 clear, bit 3 is set (return).
There is no visible timeout in this polling path. For sector reads, `r0` is
`1` at the jump to the shared sequence; for boot, it is `0x16`.

The manual states that the command register must be written last: this clears
the status byte, enables host/controller handshaking, and starts the command.
This confirms the significance of the shared routine's final `out 0x8000`.
The command descriptions in Appendix B do not give numeric opcode values, so
the meanings of `0x16` and `0x01` still require the command table or firmware.

The manual defines `0x8010` as the 8-bit C/S register read by the CPU, while
the CPU source also executes `out 0x8010, r0` before commands. Record that
write as observed CPU behavior, but do not assume it writes or clears the C/S
status: the documented clear/start action is the subsequent command-register
write. The exact effect, if any, of the `out 0x8010` needs investigation.
Likewise, the CPU code establishes the status-bit masks it polls, but the
sections examined do not document the meanings of C/S bits 7, 3, 1, or 2.

## Power-up WDC diagnostics

`TEST_` samples the boot-device switches into `ABOOT_DEV` and later walks the
SMC, MDC, and WDC diagnostics (`p.testram.s:171-186`, `p.testram.s:165-168`,
`p.testram.s:2220-2250`). The WDC-specific code is in
`p.testothr.s:49-197`:

- Presence probe: write byte `0xa5` to `0x8001`, read that byte back, and
  compare it. If it does not match, the WDC is considered absent. If WDC is
  the selected boot device (`ABOOT_DEV == 3`), report error `0x1000`;
  otherwise return without that boot-device error.
- If present, display `WDC`. Only when it is the selected boot device does the
  diagnostic continue with drive value zero and command `0x04`.
- `WDC_TEST` first reads status and treats `(status & 3) == 3` as self-test
  error `0x1001`. It then waits for bit 7, issues the requested command, waits
  for bit 7 again and then bit 3, and requires status bits 1 and 2 to be clear.
  `WDC_CHECK_STATUS` retries up to `0x0fa0` (4000) status reads, invoking
  `TEST_DELAY` between unsuccessful reads (`p.testothr.s:98-169`,
  `p.testothr.s:592-608`).
- If the command `0x04` check fails, the diagnostic prepares several
  registers and calls `WDC_TEST` with command `0x03`; on the success path it
  reads command, drive, cylinder-high, and sector values for error reporting
  (`p.testothr.s:83-94`, `p.testothr.s:171-197`). The procedure name
  `WDC_TEST_UNKOWN_02` and its comments do not establish the command's
  function. There is unreachable code after a `ret` in this procedure; do not
  treat it as part of the WDC protocol.

Diagnostics are useful evidence for presence detection and status-handshake
expectations, but they are not the normal disk-read path and should not be
mistaken for a complete controller initialization sequence.

## Emulator implications and open questions

- Reproduce the host-facing sequence first: register addresses, access widths,
  write/read ordering, command values, polling behavior, and status transitions.
  Keep the SD-card/block-device translation behind that interface.
- The normal CPU data path passes `DISK_BUFFER` (`0xfa00`) as the DMA address;
  for reads the controller writes data to that address, and for writes it
  would read data from it. Boot setup passes `0xfeb4`. The manual defines a
  24-bit DMA address and 16-bit word count; the CPU's normal read setup encodes
  a count of 256 words (one 512-byte sector). Model this as host-memory access
  over the ZBI contract, not as an on-controller local buffer.
- The command register is the final write in a command setup: it clears C/S
  status, enables handshaking, and starts execution. The command/status
  register is read at `0x8010`; the manual's register description does not
  clarify the CPU's preceding write to that address.
- Determine from the WDC firmware/manual or bus traces: command `0x16` and
  `0x01` meanings; status-bit meanings and acknowledgement/clear behavior;
  whether `out 0x8010` has any effect; bus-cycle details for byte registers and
  word I/O; how 13,440 bytes/track maps to 512-byte sector data and formatting
  overhead; geometry bounds;
  drive selection; error behavior; and whether commands can complete
  asynchronously.
- The CPU boot polling loop has no timeout, so an emulator that never reaches
  the expected status condition can hang the host. Exact error and completion
  states need to be established before choosing emulator behavior.
- Sources examined: `AI/ocr/03_3237_04__4_5_2_Winchester_Disk_Controller.txt`
  (WDC manual, section 4.5.2) and
  `AI/ocr/03_3237_04__Appendix_B.txt` (host command descriptions). Appendix B
  describes command parameters and transfer behavior, but does not provide
  opcode values; its references to Appendix C mean opcode mapping remains
  outstanding. No WDC firmware source, kernel direct-I/O driver, or ZBI bus
  trace has yet been analyzed.
