!******************************************************************************
*******************************************************************************

  S8000-Firmware
  Z8000-Softwaremonitor (CPU)        Modul: p_disk

  Bearbeiter:	O. Lehmann
  Datum:	14.01.2016
  Version:	1.2

*******************************************************************************
******************************************************************************!

p_disk module

$SECTION PROM

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Hardwareadressen
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!

  CONSTANT
SIO0	:= %FF81
SIO0D_A	:= SIO0 + 0
SIO0D_B	:= SIO0 + 2
SIO0C_A	:= SIO0 + 4
SIO0C_B	:= SIO0 + 6

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


DISK_BUFFER := %FA00	!array [%200 byte]!
BLOCK_POINTER := %FC00	!array [%228 byte]!
PATH_NAME := %FE28	!n * 14 byte fuer pathname!
DEVICE_CODE := %FFF0
 
LOAD_ADR := %0000

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE DSK_BOOT
Laden und Starten "boot0" von DISK (Block 0)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    DSK_BOOT procedure
      entry
	ld	r2, #%4000
	ldctl	fcw, r2
	ld	r2, #%f000
	ld	r15, r2
	lda	r1, RELOC_DSK_BOOT
	ld	r14, #%0453
	ldirb  @r2, @r1, r14	!relocate code!
	jp	@r15		!jump to relocated code!
!relocated code to f000!
RELOC_DSK_BOOT:
	pushl	@r15, rr6
	ldb	DEVICE_CODE, rl6	!device code!
	cpb	rl6, #%03	!WDC BootDev?!
	jr	nz, DSKBOOT_01
	calr	WDC_BOOT
DSKBOOT_01:
	cpb	rl6, #%01	!SMC BootDev?!
	jr	nz, DSKBOOT_02
	calr	SMC_BOOT
DSKBOOT_02:
	cpb	rl6, #%02	!MDC BootDev?!
	jr	nz, DSKBOOT_03
	calr	MDC_BOOT
DSKBOOT_03:
	pushl	@r15, rr4
	test	r4
	jr	nz, DSKBOOT_04
	ldar	r14, MSG_BOOT
DSKBOOT_04:
	calr	BOOT_UNKNOWN_01
	ldb	rl0, #%01
	outb	S_BNK, rl0	!MONITOR PROM & RAM AUSSCHALTEN!
DSKBOOT_RESTART:
	ldar	r8, T_BOOTPROMPT	!> !
	calr	PRINT_MSG
	ld	r10, #PATH_NAME
	ld	r11, r10	!r11 Anf adr Puffer!
DSKBOOT3:
	ld	r12, r11	!r12 aktueller Puffer Pointer!
DSKBOOT4:
	calr	GETA
	cpb	rl0, #%0A	!lf = Ende der Eingabe!
	jr	z, DSKBOOT6
	cpb	rl0, #'/'	!Name fuer directory file!
	jr	z, DSKBOOT5
 
	ldb	@r12, rl0	!Zeichen in Puffer!
	inc	r12, #%01	!Pointer inc!
	jr	DSKBOOT4	!naechstes Zeichen!
 
DSKBOOT5:
	cp	r12, r11	!1. eingegebenes Zeichen ?!
	jr	z, DSKBOOT4	!name eingeben!
	calr	CLEAR		!Namensfeld bis Ende mit 00 beschreiben!
	jr	DSKBOOT3	!naechsten Namen eingeben!
 
DSKBOOT6:			!Ende der Eingabe!
	calr	CLEAR		!Rest vom Namensfeld mit 00 fuellen!
	clrb	@r11		!erstes Zeichen vom naechsten Namensfeld = 0!


!directories nach file durchsuchen!
 
	ldk	r11, #%02	!inumber der root directory!
DSKBOOT7:
	calr	READ_INODE	!inode lesen!
	testb	@r10		!<> 0 directory einlesen!
				!0 = gewuenschten file einlesen!
	jr	z, DSKBOOT11	!Sprung Procedure file einlesen!
DSKBOOT8:
	calr	READ_DSK_BLOCK	!naechsten Block der directory einlesen!
	jr	z, DSKBOOT16	!Disk Error!
DSKBOOT9:
	pop	r11, @r9	!inumber in directory!
	test	r11		!0=keine Datei auf diesem Platz eingetragen!
	jr	z, DSKBOOT10	!naechster Platz in directory!
				!Abstand 10 Hex Bytes 2 byte inumber 14 byte Name!
	ldk	r0, #14		!Laenge filename!
	ld	r1, r9
	ld	r2, r10		!filename in directory Block suchen!
	cpsirb	@r10, @r1, r0, nz
	jr	nz, DSKBOOT7	!Name gefunden!
				!in r11 ist inumber fuer gesuchte file!
 
	ld	r10, r2
DSKBOOT10:
	inc	r9, #14
	cp	r9, #DISK_BUFFER+%200 !Ende Disk Puffer!
	jr	ge, DSKBOOT8	!Name nicht gefunden, naechsten Block lesen!
	jr	DSKBOOT9		!nicht gefunden, weiter im gleichen Block suchen!
 
!Procedure file einlesen!
 
DSKBOOT11:
	calr	READ_DSK_BLOCK	!1. Block der file lesen!
	cp	@r9, #%E707	!Magic Nr!
				!=nonsegmented, executable!
	jr	nz, DSKBOOT16	!Fehler falsche Magic!
	ld	r11, %10(r9)	!Entry Point des Programms!
	ld	r0, #%18	!size header!
	add	r0, %0A(r9)	!size segment table!
	add	r9, r0		!Anfangsadr Programmcode!
	ldk	r10, #LOAD_ADR	!Ladeadr im Segment 0!
	neg	r0
	add	r0, #%200	!%200-header-segtable!
DSKBOOT12:
	ldirb	@r10, @r9, r0	!Move Puffer auf echte Adr!
	calr	READ_DSK_BLOCK	!alle weiteren Bloecke lesen!
	ld	r0, #%0200	!RL!
	jr	nz, DSKBOOT12
	popl	rr4, @r15	!Rueckladen der Monitor Parameter!
	popl	rr6, @r15
	jp	@r11		!Sprung zum geladenen Programm!
DSKBOOT16:
	ldar	r8, T_FILENOTFOUND
	calr	PRINT_MSG
	jr	DSKBOOT_RESTART
    end DSK_BOOT

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE READ_INODE
Liest die inode aus r11
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    READ_INODE procedure
      entry

	inc	r11, #%0F	!aus inumber inode Block berechnen!
	ld	r5, r11
	srl	r5, #%03	!/8 ;8 inodes je Block!
	xor	r4, r4
	calr	READ_DISK	!inode Block in DISK_BUFFER lesen!
	and	r11, #%07
	sll	r11, #%06
	add	r11, #DISK_BUFFER+8
	popl	rr12, @r11	!Laenge file aus inode!
	addl	rr12, #%01FF
	srll	rr12, #9	!in r13 nun Anzahl Bloecke der file!
	ld	r12, #BLOCK_POINTER
	ld	r9, r12		!array der Blockpointer!
	ldk	r1, #10		!10 direkte Pointer!
READ_INODE1:
	clrb	@r9		!direkte Pointer einlesen!
	inc	r9, #%01
	ldk	r0, #%03
	ldirb	@r9, @r11, r0	!move in Pointer array!
	dec	r1, #%01
	jr	nz, READ_INODE1
 
	cp	r13, #%0A	!file < 10 Bloecke ?!
	ret	le		!ja=fertig!
 
	xorb	rh4, rh4	!Pointer zu einfach indirekt laden!
	ldb	rl4, @r11
	inc	r11, #%01
	ldb	rh5, @r11
	inc	r11, #%01
	ldb	rl5, @r11
	calr	READ_DISK	!einfach indirekt Pointer Block lesen!
	ld	r1, #DISK_BUFFER
	ld	r0, #%0200	!RL!
	ldirb	@r9, @r1, r0	!in Pointerarray an die 10 direkten Pointer moven!
	ret
    end READ_INODE

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE READ_DSK_BLOCK
R12: ptr to disk block addresses
R13: remaining addresses
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    READ_DSK_BLOCK procedure
      entry
	test	r13
	ret	z
	popl	rr4, @r12
	calr	READ_DISK
	ld	r9, #DISK_BUFFER
	dec	r13, #1
	resflg	z
	ret
    end READ_DSK_BLOCK

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE CLEAR
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    CLEAR procedure
      entry
	inc	r11, #%0E	!Pointer auf nachstes Namensfeld im PATH_NAME Puffer!
CLEAR1:
	cp	r12, r11
	ret	ge
	clrb	@r12		!Rest vom alten Namensfeld mit 00 beschreiben!
	inc	r12, #%01
	jr	CLEAR1
    end CLEAR

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE PRINT_MSG
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    PRINT_MSG procedure
      entry
	ldb	rl0, @r8
	testb	rl0		!Ausgabe bis 00!
	ret	z
	calr	PRINT_CHAR
	inc	r8, #%01
	jr	PRINT_MSG
    end PRINT_MSG

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE BOOT_UNKNOWN_01
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    BOOT_UNKNOWN_01 procedure
      entry
	ld	r2, #SIO0C_B
	ldar	r1, T_UNKNOWN+1
	ldk	r0, #9
	otirb	@r2, @r1, r0
	ret	
    end BOOT_UNKNOWN_01

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE SET_BOOT
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    SET_BOOT procedure
      entry
	ldar	r14, MSG_BOOT
    end SET_BOOT	!laeuft in GETA weiter!

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE GETA
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    GETA procedure
      entry
	test	r14
	jr	z, GETA1
	ldb	rl0, @r14
	inc	r14, #1
	jr	GETA2
GETA1:
	inb	rl0, SIO0C_B
	bitb	rl0, #0
	jr	z, GETA1
	inb	rl0, SIO0D_B
GETA2:
	resb	rl0, #7
	cpb	rl0, #%0d
	jr	nz, PRINT_CHAR
	ldk	r0, #10
    end GETA

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE PRINT_CHAR
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    PRINT_CHAR procedure
      entry
	cpb	rl0, #%0a
	jr	nz, PUTA
	cp	r12, r10
	jr	z, SET_BOOT
	ldk	r14, #0
	ldk	r0, #%0D	!cr lf ausgeben!
	calr	PUTA
	ldk	r0, #10
    end PRINT_CHAR
    
!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE PUTA
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    PUTA procedure
      entry
	inb	rh0, SIO0C_B
	bitb	rh0, #2
	jr	z, PUTA
	outb	SIO0D_B, rl0
	ret	
    end PUTA

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE READ_DISK
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    READ_DISK procedure
      entry
	ldb	rl0, DEVICE_CODE
	cpb	rl0, #3		!nur bei WDC!
	jr	nz, NOT_WDC
	calr	WDC_READ_DISK
	ret	
NOT_WDC:
	cpb	rl0, #%01	!nur bei SMC!
	jr	nz, NOT_SMC
	calr	SMC_READ_DISK
	ret	
NOT_SMC:
	cpb	rl0, #%02	!nur bei MDC!
	ret	nz
	calr	MDC_READ_DISK
	ret	
    end READ_DISK

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE WDC_BOOT
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    WDC_BOOT procedure
      entry
	ldb	%feb6, #%03
	ldb	%feb7, #%18
	ld	r0, #%feb4	!Transfer Address?!
	out	%800a, r0
	exb	rh0, rl0
	out	%800b, r0
	xor	r0, r0
	out	%800c, r0
	out	%8010, r0
	ld	r0, #%0016	! CMD Code 16 !
	jr	WDCBOOT_CMD
WDCBOOT_CMD:
	out	%8000, r0
WDCBOOT_STAT1:
	in	r0, %8010
	bit	r0, #7
	jr	z, WDCBOOT_STAT1
WDCBOOT_STAT2:
	in	r0, %8010
	bit	r0, #1
	ret	nz
	bit	r0, #3
	jr	z, WDCBOOT_STAT2
	ret
    end WDC_BOOT

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE WDC_READ_DISK
See Page 4-22/4-22 in Book 03-3237-04
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    WDC_READ_DISK procedure
      entry
	ldl	rr2, rr4	!block number!
	subl	rr0, rr0
	divl	rq0, #%00000018	!divide by number of sectors (24)!
	out	%8005, r1
	ldb	rl0, %feb6
	xorb	rh0, rh0
	div	rr2, r0
	out	%8002, r2
	xor	r0, r0
	out	%8010, r0
	out	%8001, r0
	out	%8008, r0
	out	%800a, r0
	out	%800c, r0
	exb	rl0, rh3
	out	%8003, r3
	out	%8004, r0
	ld	r0, #DISK_BUFFER
	exb	rl0, rh0
	out	%800b, r0
	ldk	r0, #1
	out	%8009, r0
	jr	WDCBOOT_CMD
    end WDC_READ_DISK

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE SMC_BOOT
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    SMC_BOOT procedure
      entry
	ld	r1, #%feba
	ld	r0, #%feec
SMCBOOT_01:
	clr	@r1
	inc	r1, #2
	cp	r0, r1
	jr	nz, SMCBOOT_01
	ld	r1, #%01fe
	ld	r2, r1
	ld	r0, #%0080
	out	%7f00, r0
	ld	%fec4, #%fed2
	clr	%fec2
SMCBOOT_03:
	in	r0, %7f00	!read status!
	andb	rl0, #%01
	jr	z, SMCBOOT_02
	dec	r1, #1
	jr	nz, SMCBOOT_03
	dec	r2, #1
	jr	nz, SMCBOOT_03
	ld	r2, #T_INIT_ERR
	call	WR_MSG
	jp	CMDLOP
SMCBOOT_02:
	ld	r0, #%feba
	exb	rl0, rh0
	ldb	rl0, #%04	!dispatch table address byte 0!
	calr	SMC_SEND_WAIT_RDY
	ld	r0, #%feba
	ldb	rl0, #%05	!dispatch table address byte 1!
	calr	SMC_SEND_WAIT_RDY
	clr	r0
	ldb	rl0, #%06	!dispatch table address byte 2!
	calr	SMC_SEND_WAIT_RDY
	ld	r0, #%c207	!interrupt vector!
	calr	SMC_SEND_WAIT_RDY
	ld	r0, #%0001	!read packet addresses from DT!
	calr	SMC_SEND_WAIT_RDY
	in	r0, %7f00
	andb	rl0, #%80
	jr	z, SMCBOOT_04
	ld	r2, #T_DT_NOT_SEND	!SMC error (no DT/int. vector)!
	call	WR_MSG
	jp	CMDLOP
SMCBOOT_04:
	clr	%fee0
	ld	%fed2, #%000f
	calr	SMC_CMD_EXECUTE
	ld	r0, %fee8
	ld	r1, %fee4
	ldl	%feb6, rr0
	ret
    end SMC_BOOT

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE SMC_SEND_WAIT_RDY
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    SMC_SEND_WAIT_RDY procedure
      entry
	out	%7f00, r0
SMC_WAIT_RDY:
	in	r2, %7f00
	andb	rl2, #%01
	jr	nz, SMC_WAIT_RDY
	ret
    end SMC_SEND_WAIT_RDY

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE SMC_READ_DISK
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    SMC_READ_DISK procedure
      entry
	ldl	rr2, rr4	!block number!
	subl	rr0, rr0
	clr	%feb4
	divl	rq0, %feb4	!divide by no. of sectors!
	ld	%fee8, r1	!sector number!
	div	rr2, %feb8	!divide by no. of heads!
	ex	r2, r3
	ldl	%fee2, rr2	!cylinder number!
	clr	%fee0		!unit number!
	clr	%fedc			!DMA address high!
	ld	%feda, #%0200	!sector count? (512)!
	ld	%fede, #DISK_BUFFER	!DMA address low!
	ld	%fed2, #%000e	!command READ!
    end SMC_READ_DISK

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE SMC_CMD_EXECUTE
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    SMC_CMD_EXECUTE procedure
      entry
	ld	%feba, #%0001	!GO!
	ld	r0, #%0008
	out	%7f00, r0	!wakeup!
SMCCE_01:
	in	r0, %7f00
	bit	r0, #2
	jr	z, SMCCE_01	!wait for interrupt!
	ld	%feba, #%0000	!idle!
	and	r0, #%3f00	!maks status!
	sub	r0, #%0300
	jr	nz, SMCCE_02
	ld	%fed4, #%0003
SMCCE_02:
	test	%fed4		!get status froom packet!
	jr	z, SMCCE_03
	xorb	rl2, rl2
	outb	S_BNK, rl2
	ld	r2, #T_D0_NOT_FORM
	call	WR_MSG
	jp	CMDLOP
SMCCE_03:
	ld	r0, #%0040
	out	%7f00, r0
	ret
    end SMC_CMD_EXECUTE

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE MDC_BOOT
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    MDC_BOOT procedure
      entry
	ld	r2, #%ffff
	calr	MDC_BOOT_UNKNOWN
	ld	r1, #%f1f1
	out	%80f0, r1
	calr	MDC_DELAY
	clr	r1
	out	%80f0, r1
	calr	MDC_DELAY
	ld	r1, #%feb4
	out	%80f0, r1
	ld	r0, #%00e1
	clr	r1
MDCBOOT_01:
	test	%feb4
	ret	z
	djnz	r1, MDCBOOT_01
	djnz	r0, MDCBOOT_01
	jr	MDC_BOOT
    end MDC_BOOT

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE MDC_BOOT_UNKNOWN
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    MDC_BOOT_UNKNOWN procedure
      entry
	ld	r1, #%feb4
	ld	r0, #%fefe
MDCBOOT_02:
	ld	@r1, r2
	inc	r1, #2
	cp	r0, r1
	jr	nz, MDCBOOT_02
	ret	
    end MDC_BOOT_UNKNOWN

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE MDC_DELAY
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    MDC_DELAY procedure
      entry
	clr	r1
	ld	r0, #5
MDC_DELAY_1:
	dec	r1, #1
	jr	nz, MDC_DELAY_1
	dec	r0, #1
	jr	nz, MDC_DELAY_1
	ret
     end MDC_DELAY

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE MDC_READ_DISK
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    MDC_READ_DISK procedure
      entry
	ld	r7, #%feb4
	ld	r0, #%0010
	ld	r7(#%0002), r0
	ld	r7(#%0004), r5
	ldk	r0, #1
	ld	r7(#%0006), r0
	ld	r0, #DISK_BUFFER
	ld	r7(#%0008), r0
	xor	r0, r0
	ld	r7(#%000a), r0
	ld	r7(#%000c), r0
	ld	@r7, #%0001
	out	%80f0, r0
MDCRDDSK_01:
	test	@r7
	jr	nz, MDCRDDSK_01
	ld	r0, r7(#%000c)
	test	r0
	jr	nz, MDC_READ_DISK
	ret
MDCRDDSK_02:
	xor	r8, r8
MDCRDDSK_03:
	djnz	r8, MDCRDDSK_03
	djnz	r0, MDCRDDSK_02
	ret
     end MDC_READ_DISK

INTERNAL
T_BOOTPROMPT
	ARRAY [* BYTE] := '> %00'

INTERNAL
MSG_BOOT
	ARRAY [* BYTE] := 'boot%0A'

INTERNAL
T_FILENOTFOUND
	ARRAY [* BYTE] := '?%0A'

INTERNAL
T_UNKNOWN:
	WORD	:= %0018
	WORD	:= %14cc
	WORD	:= %03c1
	WORD	:= %05ea
	WORD	:= %1100

T_INIT_ERR
	WORD	:= %0009
	ARRAY [9 BYTE] := 'INIT ERR%0D'

T_DT_NOT_SEND
	WORD	:= %000c
	ARRAY [12 BYTE] := 'DT NOT SENT%0D'

T_D0_NOT_FORM
	WORD	:= %0011
	ARRAY [17 BYTE] := 'D0 NOT FORMATTED%0D'

end p_disk
