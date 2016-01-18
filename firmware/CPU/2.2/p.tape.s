!******************************************************************************
*******************************************************************************

  S8000-Firmware
  Z8000-Softwaremonitor (CPU)        Modul: p_tape

  Bearbeiter:	O. Lehmann
  Datum:	11.01.2016
  Version:	2.2

*******************************************************************************
******************************************************************************!

p_tape module

$SECTION PROM

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Hardwareadressen
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!

  CONSTANT
S_BNK	:= %FFC1	!SWITCH-BANK:
			 Bit0-3 Ausgabebits; Bit4-7 Eingabebits (DIL-Schalter):
			 Bit 0: =0 - Monitor PROM+RAM einschalten
				=1 - Monitor PROM+RAM ausschalten
			 Bit 1: =0 - MMU's ausschalten; =1 - MMU's einschalten
			 Bit 2: Seg. Usr.
			 Bit 3: =0 - Paritaetspruefung ausgeschaltet bzw.
                                     Paritaetsfehler loeschen
                                =1 - Paritaetspruefung eingeschaltet
			 Bit 5,4: Baudrate Terminal
			 Bit 7,6: Autoboot Device!

  CONSTANT
MOVE_ADR := %F800

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE READ_TAPE
I/O Space %0040 - %007f
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    READ_TAPE procedure
      entry
	ld	r15, #MOVE_ADR
	ldb	rl0, #%01
	outb	S_BNK, rl0	!MONITOR PROM & RAM AUSSCHALTEN!
READTAPE_01:
	calr	WAIT_UNTIL_TAPE_RDY
	ld	r0, #%0003
	calr	SEND_TAPE_CMD
	ld	r0, #%000a
	calr	SEND_TAPE_CMD
	ld	r0, #%000b
	calr	SEND_TAPE_CMD
	ld	r0, #%000f
	calr	SEND_TAPE_CMD
	ld	r0, #%000e
	calr	SEND_TAPE_CMD
	ldk	r0, #0
	out	%004e, r0
	ld	r0, #%0009
	calr	SEND_TAPE_CMD
	in	r0, %004a
	bit	r0, #0
	jr	nz, READTAPE_01
	ldk	r0, #0
	out	%0044, r0
	out	%0046, r0
	ld	r0, #%4000
	out	%0048, r0
	ld	r0, #%0001
	calr	SEND_TAPE_CMD
	jp      %0000
     end READ_TAPE

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE SEND_TAPE_CMD
I/O Space %0040 - %007f
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    SEND_TAPE_CMD procedure
      entry
	out	%0042, r0
     end SEND_TAPE_CMD	!Weiterlauf!

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE WAIT_UNTIL_TAPE_RDY
I/O Space %0040 - %007f
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    WAIT_UNTIL_TAPE_RDY procedure
      entry
	ld	r0, #300
WAIT_TAP_01:
	djnz	r0, WAIT_TAP_01
WAIT_TAP_02:
	in	r0, %0040
	bit	r0, #9
	jr	nz, WAIT_TAP_02
	ret
     end WAIT_UNTIL_TAPE_RDY

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE TAP_BOOT
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    TAP_BOOT procedure
      entry
	ld	r0, #%4000
	ldctl	fcw, r0
	ld	r2, #MOVE_ADR
	lda	r1, READ_TAPE
	ld	r0, #%006e
	ldirb	@r2, @r1, r0
	jp	MOVE_ADR
     end TAP_BOOT

end p_tape
