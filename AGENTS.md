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
- Distinguish observed CPU bus instructions from the electrical/semantic
  interpretation of those instructions. The WDC firmware, controller manuals,
  schematics, and hardware traces have not yet been examined.
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
| `0x800a` | `WDC_REG_TRANSADDR_B0` | Transfer-address byte 0 |
| `0x800b` | `WDC_REG_TRANSADDR_B1` | Transfer-address byte 1 |
| `0x800c` | `WDC_REG_TRANSADDR_B2` | Transfer-address byte 2 |
| `0x800d` | `WDC_REG_TRANSADDR_B3` | Transfer-address byte 3 |
| `0x8010` | `WDC_REG_STAT` | Status in reads; also written by the firmware |

These are source-level names and addresses. The firmware does not establish
what unlisted addresses do, how the controller decodes byte lanes, or how
16-bit `in`/`out` instructions interact electrically with adjacent addresses.
Preserve the exact CPU access width, address, and value when characterizing
the host interface; do not assume each `out` is equivalent to an `outb`.

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
   sequence at `WDCBOOT_CMD`.

Semantically, the controller is given a sector offset at `0x8005`, a head
number at `0x8002`, and a cylinder number at `0x8003`: the head and cylinder
select the track, and the sector offset selects a position within that track.
The firmware computes these fields as `sector = LBA % 24`, `track_index =
LBA / 24`, `head = track_index % 3`, and `cylinder = track_index / 3`.
`WDC_BOOT` initializes the 24-sector conversion divisor at `0xfeb7` and the
three-head divisor at `0xfeb6` (`p.disk.s:473-488`). Thus the code represents
24 sector positions per addressed track and three heads per cylinder. It
writes the sector offset directly (no visible `+1`); confirm the controller's
register convention against its documentation or behavior.

The supplied track size is 13,440 bytes. If that is the addressable data
payload of each track and it is divided into 24 equal sectors, the implied
sector payload is 560 bytes. The resulting geometry is 43,560 sectors and
24,393,600 bytes (about 24.4 MB decimal or 23.3 MiB). This is close to the
stated nominal 24 MB capacity, but firmware and hardware evidence is still
needed to confirm the sector payload, formatting/overhead, and whether the
reported capacity is decimal or rounded.

`DISK_BUFFER` is the memory address passed to the WDC as the DMA buffer: for a
disk read the controller writes the data there; for a disk write it would
read the data from there. The CPU 1.2 path shown here exercises reads. The boot
path separately passes `0xfeb4` as a DMA address (`p.disk.s:473-488`).

In the normal read setup, `LD r0,#DISK_BUFFER` gives `r0 = 0xfa00` and
`EXB rl0,rh0` changes it to `r0 = 0x00fa` before the word `OUT` at `0x800b`.
This byte swap is real and intentional in the executable sequence. A likely
explanation is that each word `OUT` to a byte-wide transfer-address register
places the low byte of `r0` on the byte lane the controller latches. Then the
swap moves `0xfa` into that lane for register B1, producing address bytes
B0=`0x00`, B1=`0xfa`, B2=`0x00` (B0 and B2 are explicitly cleared).

The boot setup independently supports this interpretation: it loads
`0xfeb4`, outputs it at B0, swaps the word, outputs at B1, then clears B2.
If each output supplies its low byte to the addressed register, the resulting
bytes are B0=`0xb4`, B1=`0xfe`, B2=`0x00`, i.e. DMA address `0x00feb4`.
Together, the two code paths strongly suggest a byte-lane/byte-order
adaptation between the Z8000 word register and the controller's byte
registers. Given that the host is a Z8000 and the WDC contains a Z80, a
big-endian-host versus little-endian-controller mismatch is a strong
explanation for the swap. The processor types alone do not establish the
electrical behavior of a word `OUT` at these register addresses, however.
Confirm the byte-lane mapping with bus documentation, controller firmware,
or a bus trace before implementing it.

The firmware writes transfer-count and transfer-address fields using 16-bit
`out` instructions; preserve those instruction widths and verify their byte
effects. Do not infer from the symbol names alone that the programmed
transfer count is one sector.

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

The source proves these values, ordering, and bit tests, but not the semantic
names of the command codes or status bits. Comments describing a code as a
particular command or bit as “busy”, “ready”, or “error” must be checked
against WDC documentation/firmware or observed hardware. Writes to `0x8010`
are real writes in the host sequence; do not model it as a read-only status
register without further evidence.

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
  would read data from it. Boot setup passes `0xfeb4`. Confirm the word-I/O
  byte-lane mapping and how the controller accesses CPU memory before
  implementing the memory-side contract.
- Determine from the WDC firmware/manual or bus traces: command `0x16` and
  `0x01` meanings; status-bit meanings and acknowledgement/clear behavior;
  byte-lane and word-I/O decoding (including the byte swap before the DMA
  address write); transfer-count interpretation; address
  width; sector numbering and whether it spans 0-23 or 1-24; how 13,440
  bytes/track maps to sectors and formatting overhead; geometry bounds; drive
  selection; error behavior; and whether commands can complete asynchronously.
- The CPU boot polling loop has no timeout, so an emulator that never reaches
  the expected status condition can hang the host. Exact error and completion
  states need to be established before choosing emulator behavior.
- No WDC firmware source, kernel direct-I/O driver, controller manual, or
  hardware trace has been analyzed yet. Treat protocol conclusions here as
  CPU-firmware observations until corroborated.
