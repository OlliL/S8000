!******************************************************************************
*******************************************************************************

  S8000-Firmware
  Z8000-Softwaremonitor (CPU)        Modul: p_floppy

  Bearbeiter:	O. Lehmann
  Datum:	14.01.2016
  Version:	1.2

*******************************************************************************
******************************************************************************!

p_floppy module

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

  INTERNAL
T_FLP_F
! ADDR: 2c60 !
	WORD	:= %0002
	ARRAY [2 BYTE] := 'F%0D'
T_FLP_0
! ADDR: 2c64 !
	WORD	:= %0002
	ARRAY [12 BYTE] := '0%0D'

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE FLOPPY_BOOT_LD
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
! ADDR: 2c68 !
  INTERNAL
    FLOPPY_BOOT_LD procedure
      entry
	ld	r2, #%ffff
	calr	FLOPPY_UNKNOWN_02
	ld	r1, #%f1f1
	out	%80f0, r1
	calr	FLOPPY_BOOT_WAIT
	clr	r1
	out	%80f0, r1
	calr	FLOPPY_BOOT_WAIT
	ld	r1, #%fe02
	out	%80f0, r1
	ld	r0, #%00e1
	clr	r1
FLOPBTLD_02:
	test	%fe02
	jr	z, FLOPBTLD_01
	djnz	r1, FLOPBTLD_02
	djnz	r0, FLOPBTLD_02
	jr	PROCEDURE FLOPPY_BOOT_LD
FLOPBTLD_01:
	ldb	rl0, #%01
	outb	S_BNK, rl0	!MONITOR PROM & RAM AUSSCHALTEN!
	ld	r2, #T_FLP_F
	call	%7f0c
	ld	%fe34, #%0012
	calr	FLOPPY_UNKNOWN_04
	ld	r0, %fe3e
	andb	rh0, #%1e
	jr	nz, FLOPBTLD_03
	ld	%fe34, #%0010
	clr	%fe36
	ld	%fe38, #%0001
	clr	%fe3a
	clr	%fe3c
	clr	%fe3e
	calr	FLOPPY_UNKNOWN_04
	jr	nz, FLOPBTLD_03
	ld	r2, #T_FLP_0
	call	%7f0c
	jp	%0000
FLOPBTLD_03:
	clrb	rl0
	outb	S_BNK, rl0	!MONITOR PROM & RAM EINSCHALTEN!
	jr	PROCEDURE FLOPPY_BOOT_LD
     end FLOPPY_BOOT_LD
     
!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE FLOPPY_UNKNOWN_02
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
! ADDR: 2cee !
  INTERNAL
    FLOPPY_UNKNOWN_02 procedure
      entry
	ld	r1, #%fe02
	ld	r0, #%fe4c
FLOPUNK02_01:
	ld	@r1, r2
	inc	r1, #2
	cp	r0, r1
	jr	nz, FLOPUNK02_01
	ret
     end FLOPPY_UNKNOWN_02
     
!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE FLOPPY_BOOT_WAIT
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
! ADDR: 2d00 !
  INTERNAL
    FLOPPY_BOOT_WAIT procedure
      entry
	clr	r1
	ld	r0, #%0005
FLOPPYWAIT:
	dec	r1, #1
	jr	nz, FLOPPYWAIT
	dec	r0, #1
	jr	nz, FLOPPYWAIT
	ret
     end FLOPPY_BOOT_WAIT
     
!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE FLOPPY_UNKNOWN_04
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
! ADDR: 2d10 !
  INTERNAL
    FLOPPY_UNKNOWN_04 procedure
      entry
	ld	%fe02, #%0010
	ld	r1, #%0000
	out	%80f0, r1
FLOPUKN04_01:
	test	%fe02
	jr	nz, FLOPUKN04_01
	ld	r0, %fe3e
	xorb	rh0, #%80
	ret
     end FLOPPY_UNKNOWN_04
     
!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE FLOPPY_BOOT
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
! ADDR: 2d2e !
  INTERNAL
    FLOPPY_BOOT procedure
      entry
	ld	r0, #%4000
	ldctl	fcw, r0
	ld	r2, #MOVE_ADR
	lda	r1, FLOPPY_BOOT_LD
	ld	r0, #%00c6
	ldirb	@r2, @r1, r0
	jp	MOVE_ADR
     end FLOPPY_BOOT

end p_floppy
