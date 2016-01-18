!******************************************************************************
*******************************************************************************

  S8000-Firmware
  Z8000-Softwaremonitor (CPU)        Modul: p_init

  Bearbeiter:	O. Lehmann
  Datum:	14.01.2016
  Version:	1.2

*******************************************************************************
******************************************************************************!

p_init module

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

SIO1	:= %FF89
SIO1D_A	:= SIO1 + 0
SIO1D_B	:= SIO1 + 2
SIO1C_A	:= SIO1 + 4
SIO1C_B	:= SIO1 + 6

SIO2	:= %FF91
SIO2D_A	:= SIO2 + 0
SIO2D_B	:= SIO2 + 2
SIO2C_A	:= SIO2 + 4
SIO2C_B	:= SIO2 + 6

SIO3	:= %FF99
SIO3D_A	:= SIO3 + 0
SIO3D_B	:= SIO3 + 2
SIO3C_A	:= SIO3 + 4
SIO3C_B	:= SIO3 + 6

CTC0	:= %FFA1
CTC0_0	:= CTC0 + 0	! Baud 0 - SIO0, Kanal 0!
CTC0_1	:= CTC0 + 2	! Baud 1 - SIO0, Kanal 1!
CTC0_2	:= CTC0 + 4 	! Baud 2 - SIO1, Kanal 2!
CTC0_3	:= CTC0 + 6	! Next !

CTC1	:= %FFA9
CTC1_0	:= CTC1 + 0	! Baud 3 - SIO1, Kanal 3!
CTC1_1	:= CTC1 + 2	! Baud 4 - SIO2, Kanal 4!
CTC1_2	:= CTC1 + 4 	! Baud 5 - SIO2, Kanal 5!
CTC1_3	:= CTC1 + 6	! Next !

CTC2	:= %FFB1
CTC2_0	:= CTC2 + 0	! Baud 6 - SIO3, Kanal 6!
CTC2_1	:= CTC2 + 2	! Baud 7 - SIO3, Kanal 7!
CTC2_2	:= CTC2 + 4
CTC2_3	:= CTC2 + 6

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

ALL_MMU	  := %F0

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
SIO-Kommandos
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!

!Command Identifiers and Values
Includes all control bytes for asynchronous and synchronous I/O !

  CONSTANT
!WR0 Commands!
!SIO_R0	:=	%00!	!SIO register pointers!
SIO_R1	:=	%01
SIO_R2	:=	%02
SIO_R3	:=	%03
SIO_R4	:=	%04
SIO_R5	:=	%05
!SIO_R6	:=	%06!
!SIO_R7	:=	%07!

!COMM0	:=	%00!	!Null Code!
!COMM1	:=	%08!	!Send Abort (SDLC)!
COMM2	:=	%10	!Reset Ext/Stat Int!
COMM3	:=	%18	!Channel Reset!
!COMM4	:=	%20!	!Enable Int On Next Rx Char!
!COMM5	:=	%28!	!Reset Tx Int Pending!
!COMM6	:=	%30!	!Error Reset!

!RFI	:=	%38!	!Return from Int!
!RRCC	:=	%40!	!Reset Rx CRC Checker!
!RTCG	:=	%80!	!Reset Tx CRC Generator!
!RTUEL	:=	%C0!	!Reset Tx Under/EOM Latch!

!WR1 Commands!
!WAIT	:=	%00!	!Wait function!
!DRCVRI	:=	%00!	!Disable Receive Interrupts!
!EXTIE	:=	%01!	!External interrupt enable!
!XMTRIE	:=	%02!	!Transmit Int Enable!
SAVECT	:=	%04	!Status affects vector!
!FIRSTC	:=	%08!	!Rx interrupt on first character!
!PAVECT	:=	%10!	!Rx interrupt on all characters!
			!(parity affects vector)!
PDAVCT	:=	%18	!Rx interrupt on all characters!
			!(parity doesn't affect vector)!
!WRONRT	:=	%20!	!Wait/ready on receive!
!RDY	:=	%40!	!Ready function!
!WRDYEN	:=	%80!	!Wait/Ready enable!

!WR2 Commands!
!IV	:=	%00!

!WR3 Commands!
!B5	:=	%00!	!Receive 5 bits/character!
RENABLE	:=	%01	!Receiver enable!
!SCLINH	:=	%02!	!Sync character load inhibit!
!ADSRCH	:=	%04!	!Address search mode!
!RCRCEN	:=	%08!	!Receive CRC enable!
!HUNT	:=	%10!	!Enter hunt mode!
!AUTOEN	:=	%20!	!Auto enable!
!B7	:=	%40!	!Receive 7 bits/character!
!B6	:=	%80!	!Receive 6 bits/character!
B8	:=	%C0	!Receive 8 bits/character!

!WR4 Commands!
!SYNC	:=	%00!	!Sync modes enable!
!NOPRTY	:=	%00!	!Disable partity!
!ODD	:=	%00!	!Odd parity!
!MONO	:=	%00!	!8 bit sync character!
!C1	:=	%00!	!x1 clock mode!
!PARITY	:=	%01!	!Enable Parity!
!EVEN	:=	%02!	!Even parity!
!S1	:=	%04!	!1 stop bit/character!
!S1HALF	:=	%08!	!1+1/2 stop bit/character!
S2	:=	%0C	!2 stop bits/character!
!BISYNC	:=	%10!	!16 bit sync character!
!SDLC	:=	%20!	!SDLC mode!
!ESYNC	:=	%30!	!External sync mode!
!C16	:=	%40!	!x16 clock mode!
!C32	:=	%80!	!x32 clock mode!
C64	:=	%C0	!x64 clock mode!

!WR5 Commands!
!T5	:=	%00!	!Transmit 5 bits/character!
!XCRCEN	:=	%01!	!Transmit CRC enable!
RTS	:=	%02	!Request to send!
!SELCRC	:=	%04!	!Select CRC-16 polynomial!
XENABLE	:=	%08	!Transmitter enable!
!XBREAK	:=	%10!	!Send break!
!T7	:=	%20!	!Transmit 7 bits/character!
!T6	:=	%40!	!Transmit 6 bits/character!
T8	:=	%60	!Transmit 8 bits/character!
DTR	:=	%80	!Data terminal ready!

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!

  INTERNAL
	WORD := 0000
	WORD := %C000	! FCW !
	WORD := %8000	! PC Segment-Nr. !
	WORD := ENTRY_	! PC Offset !

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Copyright
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!

  INTERNAL
COPYRIGHT
	ARRAY	[* BYTE]	:= 'COPYRIGHT, ZILOG, INC. 1980 '

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Systemmeldung
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!

  INTERNAL
SYSMSG	WORD := 47
	ARRAY [* BYTE] := 'S8000 Monitor 1.2 - '
	ARRAY [* BYTE] := 'Press START to Load System%0D'

!------------------------------------------------------------------------------
Tabelle der Monitorroutinen, die ueber System Calls aufrufbar sind
------------------------------------------------------------------------------!

  GLOBAL
SC_ADR	ARRAY [* WORD] := [TYRD TYWR RD_LINE_BFF WR_CRLF WR_MSG BTOH16
                           WR_OUTBFF_CR BTOH8 PUT_SEGNR PUT_CHR
			   WOCF_MCZ TYWR_MCZ CMDLOP]

!******************************************************************************
Prozeduren
******************************************************************************!
!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE ENTRY_
Startprozedur
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    ENTRY_ procedure
      entry
!PSAPSEG laden (Segment 00)!
	clr	r14
	ldctl	PSAPSEG, r14	!Program Status Area Pointer Segment Register!
!Umschaltung auf nichtsegmentierten Mode!
	ld	r1, #%4000
	ldctl	FCW, r1		!Flag and Control Word Register!
!MMU's ausschalten!
	clr	R3
	sout	ALL_MMU, r3	!MMU in Tristate bringen!
!Baudraten-Konfiguration der SIOs auslesen und setzen!
	inb	rl3,S_BNK
	srlb	rl3,#4
	andb    rl3,#3
	ldb	rl0,BAUD(r3)
	ldb	rl1,#%47
	outb	CTC0_1,rl1
	outb	CTC0_1,rl0
	outb	CTC0_0,rl1
	outb	CTC0_0,rl0
!Initialisierung SIO0!
	ld	r2, #ITAB_SIO0_B
	ld	r0, #11
	ld	r1, #SIO0C_B
	otirb	@r1, @r2, r0

	ld	r2, #ITAB_SIO0_A
	ld	r0, #9
	ld	r1, #SIO0C_A
	otirb	@r1, @r2, r0
!Refresh-Register laden!
	ld	r1, #%0000	!REFRESH-Anpassung!
	ldctl	REFRESH, r1	!Refresh Control Register!
	ld	RF_CTR, r1
!RAM loeschen!
	ld	r4, #RAM_ANF
	ld	r2, #RAM_ANF+2
	ld	@r4, #0
	ld	r1, #%0200
	ldir	@r2, @r4, r1
	ld	r4, #RAM_ANF
	ld	r2, #RAM_ANF+2
	ld	@r4, #0
	ld	r1, #%0020
	ldir	@r2, @r4, r1
!Eingabepuffer (INBFF) und Ausgabepuffer (OUTBFF) mit Space initialisieren!
	ld	INBFF, #%2020
	ld	r4, #INBFF
	ld	r2, #INBFF+2
	ld	r1, #%80
	ldir	@r2, @r4, r1
!Variablen-Transfer in den RAM!
	ld	r4, #VAR_LISTE_PROM
	ld	r2, #CHRDEL
	ldk	r1, #7
	ldir	@r2, @r4, r1
!Program Status Area im RAM initialisieren!
	ld	r4, #PSAREA_PROM
ENTRY_EXT_01:
	ld	r2, #PSAREA
	ld	r1, #%48
	ldir	@r2, @r4, r1
!Stack-Bereich initialisieren!
	ld	r14, #%8000	!Normal-Stackpointer (Segment)!
	ld	r15, #NSP_OFF	!Normal-Stackpointer (Offset)!
	ldl	SVSTK, rr14
	ld	r15, #STACK
!PSAPOFF laden!
	ld	r1, #PSAREA
	ldctl	PSAP, r1	!Program Status Area Pointer Offset Register!
!Registerbereich laden!
	ld	PS_, r14
	ld	PC_SEG, r14
	ld	PO_, r1
	ld	PC_OFF, #%5000	!PC im Registerbereich initialisieren!
	ld	FCW_, #%C000	!FCW im Registerbereich initialisieren!
!Flags setzen!
	setb	FLAG1, #3	!Flag=1 --> Klein-/Grossbuchstaben erlaubt!
	resb	FLAG1, #4	!Flag=0 --> Ausgabe bei CR abbrechen!
	call	WR_CRLF		!Ausgabe CRLF!
	ld	r2, #SYSMSG
	call	WR_MSG		!Ausgabe der Systemmeldung!
	ei	vi		!zusaetzlich!
    end ENTRY_			!Weiterlauf bei CMDLOP!

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE CMDLOP
Kommandoeingabeschleife
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    CMDLOP procedure
      entry
	ld	r15, #STACK
	push	@r15, #CMDLOP	!Rueckkehradresse fuer die Monitorroutinen!
	ldb	rl1, FLAG0
	and	r1, #%0006
	ldb	FLAG0, rl1	!set Bit1,2!
	ldb	rl0, PROMT
	call	TYWR		!PROMT ausgeben!
	call	RD_LINE_INBFF	!Einlesen der eingegebenen Zeile in INBFF;
				 rl0:=1. Zeichen der Eingabezeile ungl. Space;
				 INPTR zeigt auf dieses Zeichen!
	jr	nz, CMDL1	!rl0 ungleich CR!

	bitb	FLAG1, #%02	!Bit 2 = NEXT-Flag!
	jr	z, CMDL1	!kein NEXT-Betrieb!

!NEXT-Flag gesetzt und nur CR als Kommando eingegeben!
	ldb	rl0, #'N'	!nach Abarbeitung des NEXT-Kommandos kann
				 durch Eingabe von CR in der Kommandoeingabe-
				 schleife das NEXT-Kommando wiederholt werden!
!Berechnen der Zeichenzahl des eingeg. Kommandonamens!
CMDL1:
	resb	FLAG1, #%02	!Flag: NEXT-Betrieb ruecksetzen!
	ld	r1, #16		!Groesse der CMD_LISTE!
	lda	r2, CMD_LISTE-1(r1)
	cpdrb	rl0, @r2, r1, z
	jr	nz, ERROR	!Ende Kommandoliste, Kommando nicht gefunden!
	sll	r1, #1
	ld      r2, CMD_ADR(r1)
	jp	@r2		!Absprung in die Monitorroutine!
    end CMDLOP

  INTERNAL
CMD_LISTE:
	ARRAY [* BYTE] := 'BCDFGIJLMNTQRZP'

! Adressen fuer die Commandos davor !
CMD_ADR:
	ARRAY [15 WORD] := [BREAK
                            COMPARE
                            DISPLAY
                            FILL
                            GO_PC
                            PORT_RW
                            GO
                            LOAD
                            MOVE
                            NEXT
                            TEST_
                            QUIT
                            REGISTER
                            OS_BOOT
                            PORT_RW_SPECIAL]

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE ERROR
allgemeine Fehlerprozedur
Ausgabe von '?' und Sprung in Kommandoeingabeschleife
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    ERROR procedure
      entry
	ldb	rl0, #'?'
	call	TYWR
	ld	OUTPTR, #0
	ld	r15, #STACK
	jp	CMDLOP
    end ERROR

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Variablenliste zur RAM-Initialisierung fuer CHRDEL-PROMT
(siehe Modul p_ram)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!

  INTERNAL
!VARIABLENLISTE: CHRDEL,LINDEL/^Q,^S/N_CNT/B_CODE/STACK_CT/N_/PROMT!
VAR_LISTE_PROM
	ARRAY [7 WORD] := [%087f %1113 %0000 %7f00 %0004 %0001 %2000]

ITAB_SIO0_B ARRAY [* BYTE] := [COMM3
                               SIO_R2
                               %10			!VI_SIO0_B in PSAREA!
                               SIO_R4 + COMM2
                               C64 + S2
                               SIO_R3
                               RENABLE + B8
                               SIO_R5
                               XENABLE + T8 + DTR + RTS
                               SIO_R1 + COMM2
                               PDAVCT + SAVECT]
ITAB_SIO0_A ARRAY [* BYTE] := [COMM3
                               SIO_R4 + COMM2
                               C64 + S2
                               SIO_R3
                               RENABLE + B8
                               SIO_R5
                               XENABLE + T8 + DTR + RTS
                               SIO_R1 + COMM2
                               PDAVCT]

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE VI_ERR
Interrupt-Routine fuer uninitialisierten vektorisierten Interrupt (VI)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    VI_ERR procedure
      entry
	ld	r5, @r15
	ld	r2, #NVI_TXT
	call	WR_MSG
	call	BTOH16
	call	WR_OUTBFF_CR
	jp	CMDLOP
    end VI_ERR

NVI_TXT:
	WORD := NVI_END - NVI_TXT - 2
	ARRAY [* BYTE] := 'UNINITIALIZED VECTOR ENTRY  ID= '
NVI_END:

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Initialisierungsfeld zur RAM-Initialisierung
fuer Program Status Area
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!

  INTERNAL
PSAREA_PROM:
!			   ID    FCW   PCSEG PCOFF!
	ARRAY [4 WORD] := [%0000 %0000 %0000 %0000] !RESERVED!
	ARRAY [4 WORD] := [%0000 %4000 %8000 VI_ERR]
						    !UNIMLEMENTED INSTRUCTIONS!
	ARRAY [4 WORD] := [%0000 %4000 %8000 VI_ERR]
						    !PRIVILEGED INSTRUCTIONS!
	ARRAY [4 WORD] := [%0000 %C000 %8000 SC_ENTRY]
						    !SYSTEM CALL INSTRUCT.!
	ARRAY [4 WORD] := [%0000 %4000 %8000 VI_ERR] !SEGMENT TRAP!
	ARRAY [4 WORD] := [%0000 %4000 %8000 AUTOBOOT] !NONMASKABLE INTERRUPT!
	ARRAY [4 WORD] := [%0000 %4000 %8000 VI_ERR]  !NONVECTORED INTERRUPT!
	ARRAY [2 WORD] := [%0000 %4000]             !VECTORED INTERRUPT!

!VECTORED INTERRUPT JUMP TABLE!
!                          SEG   OFFSET!
	ARRAY [2 WORD] := [%8000 VI_ERR]
	ARRAY [2 WORD] := [%8000 VI_ERR]
	ARRAY [2 WORD] := [%8000 VI_ERR]
	ARRAY [2 WORD] := [%8000 VI_ERR]
	ARRAY [2 WORD] := [%8000 VI_ERR]
	ARRAY [2 WORD] := [%8000 VI_ERR]
	ARRAY [2 WORD] := [%8000 VI_ERR]
	ARRAY [2 WORD] := [%8000 VI_ERR]
	ARRAY [2 WORD] := [%8000 VI_ERR]
	ARRAY [2 WORD] := [%8000 VI_ERR]

	ARRAY [2 WORD] := [%8000 PTY_INT]
	ARRAY [2 WORD] := [%8000 PTY_ERR]
	ARRAY [2 WORD] := [%8000 VI_ERR]
	ARRAY [2 WORD] := [%8000 VI_ERR]
	ARRAY [2 WORD] := [%8000 MCZ_INT]
	ARRAY [2 WORD] := [%8000 MCZ_ERR]

	ARRAY [2 WORD] := [%8000 VI_ERR]
	ARRAY [2 WORD] := [%8000 VI_ERR]
	ARRAY [2 WORD] := [%8000 VI_ERR]
	ARRAY [2 WORD] := [%8000 VI_ERR]
	ARRAY [2 WORD] := [%8000 VI_ERR]
	ARRAY [2 WORD] := [%8000 VI_ERR]
	ARRAY [2 WORD] := [%8000 VI_ERR]
	ARRAY [2 WORD] := [%8000 VI_ERR]
	ARRAY [2 WORD] := [%8000 VI_ERR]

BAUD:
	ARRAY [4 BYTE] := [%40 %10 %02 %01]

end p_init
