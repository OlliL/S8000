!******************************************************************************
*******************************************************************************

  S8000-Firmware
  Z8000-Softwaremonitor (CPU)        Modul: p_testothr

  Bearbeiter:	O. Lehmann
  Datum:	14.01.2016
  Version:	1.2

*******************************************************************************
******************************************************************************!

p_testothr module

$SECTION PROM

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
System Calls
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!

  CONSTANT
SC_SEGV			:= %01
SC_NSEGV		:= %02
SC_WR_MSG		:= %0C
SC_WR_OUTBFF_CR		:= %10
SC_PUT_CHR		:= %16

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE WDC_TEST_1000
See:
 - Page 4-16 in Book 03-3237-04 (Theory of Operation)
 - Appendix B in Book 03-3237-04 (Winchester Disk Controller Commands)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
! ADDR: 2548 !
  GLOBAL
    WDC_TEST_1000 procedure
      entry
	ld	r8, #%1000	!Fehlernummer 1000!
	ld	ERRPAR_ID, #%0000
	xorb	rh1, rh1
	ld	r7, #%8001	!WDC: Unit Register!
	ldb	rl6, #%a5
	outb	@r7, rl6
	inb	rh6, @r7
	cpb	rh6, rl6
	jr	z, WDCT1000_1
	cpb	ABOOT_DEV, #%03
	ret	nz
	jr	WDCT_ERROR
WDCT1000_1:
	pushl	@r15, rr0
	ld	r2, #T_WDC	!Textausgabe 'WDC' !
	sc	#SC_WR_MSG
	sc	#SC_WR_OUTBFF_CR
	popl	rr0, @r15
	cpb	ABOOT_DEV, #%03
	ret	nz
	ld	r8, #%1002	!Fehlernummer	1002!
	outb	%8001, rh1	!WDC: Unit Register -> Drive 0!
	ld	r7, #%8000	!WDC: Command Register!
	ld	r6, #%8010	!WDC: Command-Status (C/S) Register!
	ldb	rl2, #%04
	call	WDC_TEST_1002
	jr	nz, WDCT1000_2
	ret	
WDCT1000_2:
	cpb	ABOOT_DEV, #%03
	jr	z, WDCT1000_3
	setb	rh1, #2
WDCT1000_3:
	ld	ERRPAR_ID, #%0055
	call	WDC_TEST_UNKOWN_02
WDCT_ERROR:
	call	MSG_ERROR
	ret
    end WDC_TEST_1000

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE WDC_TEST_1002
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
! ADDR: 25b4 !
  INTERNAL
    WDC_TEST_1002 procedure
      entry
	inb	rl5, @r6
	ldb	rh5, rl5
	andb	rh5, #%03
	cpb	rh5, #%03
	jr	z, WDC_TEST_1001
	ld	r4, #%0007
	call	WDC_TEST_UNKOWN_01
	jr	z, WDCT1002_OUT
	outb	@r7, rl2
	ld	r4, #%0007
	call	WDC_TEST_UNKOWN_01
	jr	z, WDCT1002_OUT
	ld	r4, #%0003
	call	WDC_TEST_UNKOWN_01
	jr	z, WDCT1002_OUT
	inb	rl5, @r6
	bitb	rl5, #1
	jr	nz, WDCT1002_OUT
	bitb	rl5, #2
	jr	nz, WDCT1002_OUT
	ret	
WDC_TEST_1001:
	ld	r8, #%1001	!Fehlernummer 1001!
WDCT1002_OUT:
	resflg	z
	ret
    end WDC_TEST_1002

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE WDC_TEST_UNKOWN_01
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
! ADDR: 25f6 !
  INTERNAL
    WDC_TEST_UNKOWN_01 procedure
      entry
	pushl	@r15, rr2
	ld	r0, #%0fa0
WDCTU01_01:
	inb	rl2, @r6
	bitb	rl2, r4
	jr	nz, WDCTU01_OUT
	call	TEST_DELAY
	djnz	r0, WDCTU01_01
WDCTU01_OUT:
	popl	rr2, @r15
	ret
    end WDC_TEST_UNKOWN_01

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE WDC_TEST_UNKOWN_02
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
! ADDR: 260e !
  INTERNAL
    WDC_TEST_UNKOWN_02 procedure
      entry
	xorb	rl2, rl2
	outb	%800c, rl2	!WDC: Transfer Address Bit 32 - 24!
	outb	%8001, rl2	!WDC: Unit Register!
	ld	r2, #%8000	!WDC: Command Register!
	outb	%800a, rl2	!WDC: Transfer Address Bit  7 -  0!
	outb	%800b, rh2	!WDC: Transfer Address Bit 15 -  8!
	ldb	rl2, #%03
	call	WDC_TEST_1002
	jr	nz, WDCTU01_02
	ldb	rl6, %8000	!WDC: Command Register!
	ldb	rl7, %8001	!WDC: Unit Register!
	ldb	rl5, %8004	!WDC: Cylinder Address Register Bit 15 -  8!
	ldb	rl4, %8005	!WDC: Sector Register!
	ret	
WDCTU01_02:
	inb	rl5, @r6
	ld	ERRPAR_ID, #4
	ret	
	ld	r0, #4
	calr	MDC_TEST
	ret
    end WDC_TEST_UNKOWN_02

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE MDC_TEST_ENTRY
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
! ADDR: 2650 !
  GLOBAL
    MDC_TEST_ENTRY procedure
      entry
	ld	r0, #0
	calr	MDC_TEST
	ret     
    end MDC_TEST_ENTRY

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE MDC_TEST
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
! ADDR: 2658 !
  INTERNAL
    MDC_TEST procedure
      entry
	xorb	rh1, rh1
	ld	ERRPAR_ID, #0
	ld	r10, #%f000
	ldb	@r10, #%ff
	ld	r11, r10
	inc	r11, #1
	ld	r12, #%004a
	ldirb	@r11, @r10, r12
	ld	r13, #%f1f1
	out	%80f0, r13	!WDC: undocumented Register!
	calr	WDC_TEST_SLEEP
	xor	r13, r13
	out	%80f0, r13	!WDC: undocumented Register!
	calr	WDC_TEST_SLEEP
	ld	r11, #%f000
	out	%80f0, r11	!WDC: undocumented Register!
	ld	r10, #%00b4
WDCT3000_02:
	calr	WDC_TEST_SLEEP
	cp	@r11, #%5555
	jr	nz, WDCT3000_01
	djnz	r10, WDCT3000_02
WDCT3000_01:
	ld	r8, #%3000	!Fehlernummer 3000!
	cp	@r11, #%ffff
	jr	nz, WDCT3000_01a
	cpb	ABOOT_DEV, #%02	!mWDC? ueberhaupt aktiv!
	ret	nz
	jr	WDCT3000_ERR
WDCT3000_01a:
	push	@r15, r0
	ld	r2, #T_MDC	!Textausgabe 'MDC' !
	sc	#SC_WR_MSG
	sc	#SC_WR_OUTBFF_CR
	pop	r0, @r15
	ld	r8, #%3001	!Fehlernummer 3001!
	cp	@r11, #%5555
	jr	z, WDCT3000_03
	cp	@r11, #%aaaa
	jr	nz, WDCT3000_04
	ld	r8, #%3003	!Fehlernummer 3003!
	jr	WDCT3000_03
WDCT3000_04:
	cp	@r11, #%0000
	jr	z, WDCT3000_05
	ld	r8, #%3002	!Fehlernummer 3002!
	ld	r6, @r11
	ld	ERRPAR_ID, #%0080
	jr	WDCT3000_03
WDCT3000_05:
	ld	r10, %f00c
	cp	r0, #%0004
	jr	lt, WDCT3000_06
	ld	%f032, #%0012
	ld	%f000, #%0100
	ld	r0, #%0000
	out	%80f0, r0	!WDC: undocumented Register!
	ld	r0, #%003c
WDCT3000_08:
	cp	%f000, #%0000
	jr	z, WDCT3000_07
	calr	WDC_TEST_SLEEP
	djnz	r0, WDCT3000_08
WDCT3000_07:
	ld	r10, %f03c
WDCT3000_06:
	srl	r10, #8
	bit	r10, #4
	ret	nz
	and	r10, #%001f
	ret	z
	cpb	ABOOT_DEV, #%02
	ret	nz
	ld	r8, r10
	cp	r8, #%0007
	jr	ge, WDCT3000_09
	add	r8, #%3003
	jr	WDCT3000_03
WDCT3000_09:
	add	r8, #%3009
	jr	WDCT3000_03
WDCT3000_03:
	cpb	ABOOT_DEV, #%02
	jr	z, WDCT3000_ERR
	setb	rh1, #2
WDCT3000_ERR:
	call	MSG_ERROR
	ret	
    end MDC_TEST

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE WDC_TEST_SLEEP
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
! ADDR: 2752 !
  INTERNAL
    WDC_TEST_SLEEP procedure
      entry
	ld	r13, #%0004
WDCTU03_02:
	ld	r12, #%ffff
WDCTU03_01:
	djnz	r12, WDCTU03_01
	djnz	r13, WDCTU03_02
	ret
    end WDC_TEST_SLEEP

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE SMC_TEST
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
! ADDR: 2760 !
  GLOBAL
    SMC_TEST procedure
      entry
	ld      r1,#%feba
	ld	r0, #%feec
SMCT_01:
	clr	@r1
	inc	r1, #2
	cp	r0, r1
	jr	nz, SMCT_01
	ld	r4, #%01fe
	ld	r0, #%0080
	out	%7f00, r0
	ld	%fec4, #%fed2
	clr	%fec2
	ld	r8, #%4000	!Fehlernummer 4000!
	xorb	rh1, rh1
	clr	ERRPAR_ID
	in	r0, %7f00
	cp	r0, #%ffff	!nicht ffff ist OK!
	jr	nz, SMCT_02
	cpb	ABOOT_DEV, #1	!wenn bootdev, dann Fehler sonst leiser return!
	ret	nz
	jp	SMCT_ERR
SMCT_02:
	ld	r2, #T_SMC	!Textausgabe 'SMC' !
	sc	#SC_WR_MSG
	sc	#SC_WR_OUTBFF_CR
SMCT_05:
	ld	r8, #RAM_ANF+3
	ld	ERRPAR_ID, #%0080
	in	r0, %7f00
	andb	rl0, #%01
	jr	z, SMCT_04
	dec	r4, #1
	jr	nz, SMCT_05
	in	r6, %7f00
	jr	SMCT_06
SMCT_04:
	ld	r0, #%feba
	exb	rl0, rh0
	ldb	rl0, #%04	!dispatch table address byte 0!
	calr	SMC_SEND_CMD_WAIT
	ld	r0, #%feba
	ldb	rl0, #%05	!dispatch table address byte 1!
	calr	SMC_SEND_CMD_WAIT
	clr	r0
	ldb	rl0, #%06	!dispatch table address byte 2!
	calr	SMC_SEND_CMD_WAIT
	ld	r0, #%c207	!interrupt vector!
	calr	SMC_SEND_CMD_WAIT
	ld	r0, #%0001	!read packet addresses from DT!
	calr	SMC_SEND_CMD_WAIT


	ld	r8, #%4001	!Fehlernummer 4001!
	ld	ERRPAR_ID, #%0000
	in	r0, %7f00
	andb	rl0, #%80	!ND bit still set?!
	jr	nz, SMCT_06	!error!
	cpb	ABOOT_DEV, #%01	!Bootdevice?!
	ret	nz		!return wenn nicht!


	ld	r8, #%4004	!Fehlernummer 4004!
	clr	%fee0
	ld	%fee2, #%ffff
	ld	%fed2, #%0007
	calr	SMC_SEND_PACKET
	ld	r0, %fed4
	cpb	rl0, #%00
	jr	nz, SMCT_06
	ld	r0, %fed8
	ldb	rl4, rl0
	and	r0, #%0100
	jr	z, SMCT_06
	ldb	rl0, rl4
	and	r0, #%0e00
	jr	nz, SMCT_06
	inc	r8, #1		!Fehlernummer 4005!
	ldb	rl0, rl4
	andb	rl0, #%01	!drive ready?!
	jr	z, SMCT_06
	inc	r8, #1		!Fehlernummer 4006!
	ldb	rl0, rl4
	andb	rl0, #%02	!drive on cylinder?!
	jr	z, SMCT_06
	inc	r8, #1		!Fehlernummer 4007!
	ldb	rl0, rl4
	andb	rl0, #%10	!drive read only?!
	jr	nz, SMCT_06
	inc	r8, #1		!Fehlernummer 4008!
	ldb	rl0, rl4
	andb	rl0, #%08	!drive fault?!
	jr	nz, SMCT_06
	inc	r8, #1		!Fehlernummer 4009!
	andb	rl4, #%04	!seek error?!
	jr	nz, SMCT_06
	ld	r8, #%4010	!Fehlernummer 4010!
	ld	ERRPAR_ID, #%0080
	ld	r4, #%0002	!Anzahl Versuche!
SMCT_07:
	clr	%fee0
	ld	%fed2, #%000f	!size disk!
	calr	SMC_SEND_PACKET
	ld	r6, %fed4
	cpb	rl6, #%00
	ret	z
	clr	%fee0		!unit 0!
	ld	%fee2, #%ffff	!recalibrate!
	ld	%fed2, #%0007	!seek!
	calr	SMC_SEND_PACKET
	dec	r4, #1
	jr	nz, SMCT_07
SMCT_06:
	cpb	ABOOT_DEV, #1
	jr	z, SMCT_ERR
	setb	rh1, #2
SMCT_ERR:
	call	MSG_ERROR
	ret
    end SMC_TEST

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE SMC_SEND_CMD_WAIT
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
! ADDR: 28c6 !
  INTERNAL
    SMC_SEND_CMD_WAIT procedure
      entry
	out	%7f00, r0
SMCSCW_01:
	in	r0, %7f00
	andb	rl0, #1
	jr	nz, SMCSCW_01
	ret
    end SMC_SEND_CMD_WAIT

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE SMC_SEND_PACKET
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
! ADDR: 28d6 !
  INTERNAL
    SMC_SEND_PACKET procedure
      entry
	ld	%feba, #%0001	!packet GO!
	ld	r0, #%0008
	out	%7f00, r0	!wakeup!
SMCSP_01:
	in	r0, %7f00
	bit	r0, #2
	jr	z, SMCSP_01	!wait until irq pending!
	ld	r0, #%0040	!reset IP+IUS!
	out	%7f00, r0
	ld	%feba, #%0000	!packet IDLE!
	and	r0, #%3f00	!mask ending status!
	cp	r0, #%0300	!DMA error?!
	jr	nz, SMCSP_02	!no, jump!
	ld	%fed4, #%0003	!packet ending status: DMA error!	
SMCSP_02:
	ret	
    end SMC_SEND_PACKET

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE TCC_TEST
I/O Space %0040 - %007f
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
! ADDR: 290c !
  GLOBAL
    TCC_TEST procedure
      entry
	ld	ERRPAR_ID, #%0000
	xorb	rh1, rh1
	ld	r8, #%2000	!Fehlernummer 2000!
	ldb	rl5, #%a5
	ldb	rh5, rl5
	out	%0048, r5
	in	r4, %0048
	cp	r5, r4
	ret	nz
	push	@r15, r1

	ld	r2, #T_TCC	!Textausgabe 'TCC' !
	sc	#SC_WR_MSG
	sc	#SC_WR_OUTBFF_CR

	pop	r1, @r15
	call	TCC_TEST_2001
	bitb	rh1, #6
	ret	nz
	ld	ERRPAR_ID, #%001a
	inc	r8, #1		!Fehlernummer 2002!
	ld	r7, #%0042
	ld	r5, #%0010
	setb	rh1, #1
	ld	r0, #%00c8
	out	@r7, r5
	dec	r7, #2
	ld	r5, #%5555
TCCT_02:
	in	r4, @r7
	cp	r5, r4
	jr	z, TCCT_01
	call	TEST_DELAY
	djnz	r0, TCCT_02
	jr	TCCT_ERR
TCCT_01:
	inc	r7, #2
	in	r4, @r7
	call	BY_WO_CMP
	bitb	rh1, #6
	jr	nz, TCCT_OUT
	cp	r7, #%004e
	jr	nz, TCCT_01
	andb	rh1, #%02
	inc	r8, #1
	ld	r7, #%0040
	ld	r5, #%aaaa
TCCT_03:
	out	@r7, r5
	in	r4, @r7
	call	BY_WO_CMP
	bitb	rh1, #6
	jr	nz, TCCT_OUT
	inc	r7, #2
	cp	r7, #%004e
	jr	ule, TCCT_03
	call	TEST_DELAY
	xorb	rh1, rh1
	ld	ERRPAR_ID, #%00a8
	inc	r8, #1
	ld	r10, #%0040
	in	r6, @r10
	bitb	rh6, #0
	ret	z
	ld	r12, #%004a
	ld	r11, #%004e
	in	r7, @r12
	in	r5, @r11
	bitb	rl7, #2
	jr	z, TCCT_ERR
	inc	r8, #1
TCCT_ERR:
	call	MSG_ERROR
TCCT_OUT:
	dec	ERR_CNT, #1
	ret	
    end TCC_TEST

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE TCC_TEST_2001
I/O Space %0040 - %007f
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
! ADDR: 29d0 !
  INTERNAL
    TCC_TEST_2001 procedure
      entry
	inc	r8, #1
	ld	r0, #%2ee0
TCCT2001_01:
	in	r4, %0040
	bitb	rh4, #1
	ret	z
	call	TEST_DELAY
	djnz	r0, TCCT2001_01
	setb	rh1, #2
	setb	rh1, #6
	call	MSG_ERROR
	ret	
    end TCC_TEST_2001

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE TEST_DELAY
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
! ADDR: 29ee !
  INTERNAL
    TEST_DELAY procedure
      entry
	push	@r15, r0
	
	ld	r0, #%0c0f
TEST_DELAY_01:
	nop
	djnz	r0, TEST_DELAY_01
	
	pop	r0, @r15
	ret	
    end TEST_DELAY

end p_testothr
