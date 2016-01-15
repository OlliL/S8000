!******************************************************************************
*******************************************************************************

  S8000-Firmware
  Z8000-Softwaremonitor (CPU)        Modul: p_testram

  Bearbeiter:	O. Lehmann
  Datum:	11.01.2016
  Version:	2.2

*******************************************************************************
******************************************************************************!

p_testram module

$SECTION PROM


!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
System Calls
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!

  CONSTANT
SC_SEGV			:= %01
SC_NSEGV		:= %02
SC_TYWR			:= %06
SC_WR_CRLF		:= %0A
SC_WR_MSG		:= %0C
SC_BTOH16		:= %0E
SC_WR_OUTBFF_CR		:= %10
SC_BTOH8		:= %12
SC_PUT_SEGNR		:= %14
SC_PUT_CHR		:= %16


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

SBREAK	:= %FFC9	!System Break Register!
NBREAK	:= %FFD1	!Normal Break Register!

ALL_MMU	  := %F0
STACK_MMU := %F6
DATA_MMU  := %FA
CODE_MMU  := %FC

  GLOBAL

T_POUPDIAG
	ARRAY [20 BYTE] := 'POWER UP DIAGNOSTICS'

T_ACTPERIP
	WORD := %0013
	ARRAY [20 BYTE] := 'ACTIVE PERIPHERALS:%00'

T_COMPLETE
	WORD := %0008
	ARRAY [8 BYTE] := 'COMPLETE'

T_INVSWITC
	WORD := %0019
	ARRAY [26 BYTE] := '** INVALID SWITCH CODE **%00'

T_ECC	WORD := %0003
	ARRAY [* BYTE] := 'ECC%00'
T_WDC	WORD := %0003
	ARRAY [* BYTE] := 'WDC%00'
T_MDC	WORD := %0003
	ARRAY [* BYTE] := 'MDC%00'
T_SMC	WORD := %0003
	ARRAY [* BYTE] := 'SMC%00'
T_MTC	WORD := %0003
	ARRAY [* BYTE] := 'MTC%00'
T_TCC	WORD := %0003
	ARRAY [* BYTE] := 'TCC%00'
T_SSB	WORD := %0004
	ARRAY [* BYTE] := 'SSB%00'
T_ICP	WORD := %0004
	ARRAY [* BYTE] := 'ICP%00'
T_FPP	WORD := %0003
	ARRAY [* BYTE] := 'FPP%00'
T_ERR	WORD := %000b
	ARRAY [12 BYTE] := '*** ERROR #%00'
T_FERR	
	WORD := %0010
	ARRAY [16 BYTE] := '%07*** FATAL ERROR'
T_SEGM	WORD := %0009
	ARRAY [10 BYTE] := 'SEGMENTED%00'
T_NONSEGM
	WORD := %000d
	ARRAY [14 BYTE] := 'NON-SEGMENTED%00'

T_JUMPERS
	WORD := %0008
	ARRAY [8 BYTE] := ' JUMPERS'
T_MAXS	WORD := %0007
	ARRAY [8 BYTE] := 'MAXSEG=%00'

SSB_ADDRS
	WORD := %ff47
	WORD := %ff07

ICP_ADDRS
	WORD := %ef01
	WORD := %ef03
	WORD := %ef05
	WORD := %ef07
	WORD := %ef09
	WORD := %ef0b
	WORD := %ef0d
	WORD := %ef0f
  INTERNAL
MMU_LISTE1:			!MMU-Adressen!
	WORD	:= CODE_MMU
	WORD	:= DATA_MMU
	WORD	:= STACK_MMU
	WORD	:= CODE_MMU
	WORD	:= DATA_MMU
MMU_LISTE2:			!Adressen der SDR-Tabellen!
	WORD	:= %A000
	WORD	:= %A100
	WORD	:= %A100
MMU_LISTE3:			!1. Byte: Ausgabewert fuer SAR;
				 2. Byte: Ausgabewert fuer DSCR;
 				 3. Byte: Datenwert, der rueckgelesen werden
					  muesste !
	ARRAY [3 BYTE] := [%00 %00 %00]
	ARRAY [3 BYTE] := [%00 %01 %01]
	ARRAY [3 BYTE] := [%00 %02 %02]
	ARRAY [3 BYTE] := [%00 %03 %03]
	ARRAY [3 BYTE] := [%01 %00 %04]
	ARRAY [3 BYTE] := [%02 %00 %08]
	ARRAY [3 BYTE] := [%04 %00 %10]
	ARRAY [3 BYTE] := [%08 %00 %20]
	ARRAY [3 BYTE] := [%10 %00 %40]
	ARRAY [3 BYTE] := [%20 %00 %80]
MMU_LISTE4:			!SDR-Feld!
	WORD	:= %0000
	WORD	:= %FF00
MMU_LISTE5:
	WORD	:= %0000
	WORD	:= %0000
MMU_LISTE6:			!SDR-Feld!
	WORD	:= %0000
	WORD	:= %FF20
MMU_LISTE7:
	WORD	:= %0000
	WORD	:= %FF01
MMU_LISTE8:
	WORD	:= %0100
	WORD	:= %0000
MMU_LISTE9:
	WORD	:= %0101
	WORD	:= %0000
MMU_LISTE10:
	WORD	:= %0000
	WORD	:= %0020

LISTE_3:
	WORD	:= %0000
	WORD	:= %0000
	WORD	:= %0109
	WORD	:= %0000

LISTE_4:
	WORD	:= %4345
	WORD	:= %4607
	WORD	:= %6162
	WORD	:= %6426
	WORD	:= %2949
	WORD	:= %4a0b
	WORD	:= %4c0d
	WORD	:= %0e4f
	WORD	:= %3451
	WORD	:= %5213
	WORD	:= %5415
	WORD	:= %1657
	WORD	:= %5819
	WORD	:= %1a5b
	WORD	:= %1c79
	WORD	:= %3e1f

LISTE_DISK_TESTS:
	WORD	:= SMC_TEST		! SMD Controller Tests !
	WORD	:= MDC_TEST_ENTRY	! m-WDC Controller Tests !
	WORD	:= WDC_TEST_1000	! WDC Controller Tests !

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE TEST_
TEST-Routine (Monitorkommando)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    TEST_ procedure
      entry
	xorb	rl0, rl0
	outb	S_BNK, rl0	!MONITOR PROM & RAM EINSCHALTEN!

	incb	rl0, #1
	outb	0, rl0

	inb	rl0, S_BNK	!gejumpertes Bootdevice ermitteln...!
	srlb	rl0, #6
	andb	rl0, #3
	ldb	ABOOT_DEV, rl0	!...und merken!

	ld	r4, #T_POUPDIAG	!Umladen des POWERUP DIAGNOSTICS Text!
	ld	POW_UP_TXT, r4
	sc	#SC_WR_CRLF

!---------------------------------------------
Testschritt (0000 'P')
Test auf externen Speicher (hoechstes Segment)
---------------------------------------------!
!Beginnend bei Segment 0 wird jeweils bei den Offsetadressen %8000 und %FFFE
getestet, ob RAM vorhanden ist (auf der Adresse wird die Segmentnummer des
betrachteten Segments eingetragen und rueckgelesen). Wenn auf beiden Adressen
kein RAM vorhanden ist, ist die vorherige Segmentadresse die hoechste.!
	call	PR_POWER_UP	!P!
	xor	r8, r8
	xorb	rh1, rh1
	ld	ERR_CNT, r8

	xor	r6, r6		!r6 (rh6) := Segmentnummer (=0)!
	ld	ERRPAR_ID, #%0000 !Fehlerparameter fuer Fehler 0:
				 			keine Parameter!
	ld	MAX_SEGNR, r6	!hoechste Segmentnummer initialisieren (:=0)!
        ldb	rl5, #%A5	
C_SEG:
	ldb	rl0, #%02	!Schleifenzaehler (2 Adressen testen)!
	ldb	rh5, rh6	!rh5:=Segmentnummer des zu testenden Segments!
	ld	r7, #%8000	!1. betrachtete Offsetadresse des Segments!
C_SEGL:
	sc	#SC_SEGV
	ld	@r6, r5		!r5 (rh5=akt.Segnr./rl5=%A5) in RAM eintragen!
	ld	r4, @r6		!ruecklesen!
	sc	#SC_NSEGV
	cp	r5, r4		!ruecklesbar!
	jr	z, INC_SEG	!Sprung wenn Segment vorhanden!
	ld	r7, #%FFFE	!2. betrachtete Offsetadresse des Segments!	
	dbjnz	rl0, C_SEGL
	decb	rh6, #%01	!betrachtetes Segment nicht vorhanden;
				 rh6:=hoechstes vorhandenes Segment!
	cpb	rh6, #0
	jr	ge, _SEG_IO	!mindestens Segment 0 vorhanden!
	jp	FAT_ERR		!Fehler: kein Segment vorhanden!
INC_SEG:
	ld	MAX_SEGNR, r6	!hoechste Segmentnummer retten!
	incb	rh6, #1		!Segmentadresse erhoehen!
	jr 	C_SEG		!naechstes Segment testen!

!------------------------
Testschritt (0001 'O')
Test Segmentadressen
------------------------!
!Beginnend beim hoechsten Segment wird bis zum Segment 0 auf den Offset-
adressen %8000 und %FFFE die im vorherigen Testschritt auf diesen Adressen
eingetragenen Segmentnummern rueckgelesen und mit der Segmentnummer des
betrachteten Segments verglichen.!

_SEG_IO:
	call	PR_POWER_UP	!PO!
	ld	ERRPAR_ID, #%00E1 !Fehlerparameter fuer Fehler 1:
				   <rh6>, r7, rl4 !
	inc	r8, #1
T_SEGR:
	ldb	rl0, #%02	!Schleifenzaehler (2 Adressen testen)!
	ld	r7, #%8000	!1. betrachtete Offsetadresse des Segments!
SEGR_LOOP:
	sc	#SC_SEGV
	ldb	rl4, @r6	!ruecklesen der im vorherigen Testschritt in
				 RAM eingetragene Segmentnummer!
	sc	#SC_NSEGV
	cpb	rh6, rl4	!ruecklesbar ? !
	jr	z, DEC_SEG	!Segment i.O.!
	ld	r7, #%FFFE	!2. betrachtete Offsetadresse des Segments!
	dbjnz	rl0, SEGR_LOOP
	jp	FAT_ERR		!Fehler: falsche Segmentadresse!
DEC_SEG:
	decb	rh6, #%01	!Segmentnummer decrementieren!
	cpb	rh6, #%00
	jr	ge, T_SEGR	!naechstes Segment testen!

!------------------------------------------------------------------
Testschritte (0100, 0101, 0102, 0103, 0104 'W')
RAM-Test (ausser Segment 0)
------------------------------------------------------------------!
	call	PR_POWER_UP	!POW!
	ld	REM_ERR_CNT, #0	!Merker: Stand Fehlerzaehler loeschen!
	xorb	rh1, rh1	!Flagbyte rh1 loeschen!
	ld	r6, MAX_SEGNR	!r6:=hoechste Segmentnummer!
	ldctl	r9, FCW		!r9:=Stand FCW!
RAM_CHK:
	ld	r8, #%0100	!Fehlernummer 100!
	call	RAM_TEST_SEG	!RAM-Test im Segment r6!
	inc	r8, #1		!Fehlernummer 101!
	ld	ERRPAR_ID, #%0000
	ld	r2, ERR_CNT	!r2:=Stand Fehlerzaehler nach Aufruf von
				     RAM_TEST_SEG!
	cp	r2, REM_ERR_CNT	!Vergleich mit Stand Fehlerzaehler vor
				 Aufruf von RAM_TEST_SEG!
	jr	z, T_LOOP	!kein Fehler aufgetreten --> Segment r6 i.O.!
				!Segment r6 nicht i.O.!
	ld	REM_ERR_CNT, r2	!neuen Stand Fehlerzaehler merken!
	cp	r6, MAX_SEGNR	!war fehlerhaftes Segment das hoechste?!
	jr	nz, T_LOOP	!nein --> naechstes Segment testen!
				!ja!
	decb	rh6, #%01	!hoechste SEGMENTNR. DEKREMENTIEREN!
	testb	rh6
	jp	z, FAT_ERR	!hoechste Segmentnummer war 1 und Segment 1 ist
				 fehlerhaft --> Fehler 79!
	ld	MAX_SEGNR, r6	!hoechste Segmentnummer neu laden, da
				 bisheriges hoechstes Segment fehlerhaft ist!
	incb	rh6, #%01
T_LOOP:				!naechtes Segment testen!
	decb	rh6, #%01	!SEGMENTNR. DEKREMENTIEREN!
	cpb	rh6, #%00
	jr	gt, RAM_CHK	!alle Segmente > 0 testen!


!------------------------------------------------------
Testschritt (0100, 0101, 0102, 0103 'E')
RAM-Test Segment 0
------------------------------------------------------!
	call	PR_POWER_UP	!POWE!
	xor	r6, r6		!Segmentnummer 0!
	ld	r8, #%0100	!Fehlernummer 100!
	ld	r3, #S_BNK	!Adresse S_BNK fuer Monitor PROM+RAM
				 ein- und ausschalten!
	ld	r10, r6		!Quell-Segment=0!
	ld	r12, MAX_SEGNR	!Ziel-Segment=hoechstes Segment!
	ld	r11, #T_POUPDIAG
	ld	r13, r11	
	ld	r9, #MMU_MEM_2
	sub	r9, #T_POUPDIAG
	sc	#SC_SEGV
	ldir	@r12, @r10, r9 	!Transfer des Monitors in hoechstes Segment!
	ld	r13, #RAM_TEST_SEG0 !Adresse fuer Programmfortsetzung laden
				     (RAM_TEST_SEG0 im hoechsten Segment)!
	ld	r11, #MMU_TEST	!Folgeadresse nach RAM_TEST_SEG0 laden
				 (REM_MMU_TEST im Segment 0)!
	jp	@r12		!Sprung in hoechstes Segment zu RAM_TEST_SEG0!
    end TEST_

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE MMU_TEST
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    MMU_TEST procedure
      entry
	sc	#SC_NSEGV
	add	r3, ERR_CNT	!waehrend RAM_TEST_SEG0 aufgetretene Fehler
				 zu Stand ERR_CNT addieren!
	ld	ERR_CNT, r3	!Fehlerzaehler aktualisieren!
	test	r3		!Fehler bei RAM-Test aufgetreten?!
	jp	nz, FAT_ERR1	!ja --> Ausgabe T_FERR; Abbruch!

	ld	r7, #%0
	ld	r2, #%14
	out	@r7, r2
	in	r3, @r7
	and	r3, #%1e
	cp	r3, r2
	jr	nz, MMU_JP_1
	ld	ERRPAR_ID, #%0000
	push	@r15, r3
	push	@r15, r9
	ldl	rr6, #%00000000
	ldl	MMU_MEM_1, rr6
	ldl	MMU_MEM_4, rr6
	ld	MMU_MEM_5, r6
	ldl	rr6, #1
	ldl	MMU_MEM_2, rr6
	ldl	MMU_MEM_3, rr6
	ld	r6, #%40
	ld	MMU_MEM_6, r6
	call	ECC_TEST_200	!POWER!
	call	ECC_TEST_201_202	!POWER!
	call	PR_POWER_UP	!POWER!
MMU_JP_EXT_1:
	sc	#SC_NSEGV
	pop	r9, @r15
	pop	r3, @r15
	ld	REM_MMU_TEST, #1
	jr	MMU_JP_2
MMU_JP_1:
	clr	REM_MMU_TEST
	call	PR_POWER_UP	!POWER !
	call	PR_POWER_UP	!POWER U!
	call	PR_POWER_UP	!POWER UP!
MMU_JP_2:
	call	PR_POWER_UP	!POWER UP D!

	xorb	rh1, rh1	!Flagbyte rh1 loeschen!
!MMU-ID in Mode-Register eintragen!
	xorb	rl2, rl2
	soutb	CODE_MMU, rl2	!CODE-MMU: ID=0!
	incb	rl2, #%01
	soutb	DATA_MMU, rl2	!DATA-MMU: ID=1!
	incb	rl2, #%01
	soutb	STACK_MMU, rl2	!STACK-MMU: ID=2!

	soutb	ALL_MMU, rl2
	SOUTB	ALL_MMU + %1100, RL2	!Reset Violation-Type-Register!
!Adresse fuer Segment-Trap und Priv.-Instr.-Trap aus PSAREA retten!
	ldctl	r9, PSAP
	ld	r4, %26(r9)	!Offsetadresse fuer Segment-Trap!
	ld	REM_ERR_CNT, r4
	ld	r4, %16(r9)	!Offsetadresse fuer Priv.-Instr.-Trap!
	ld	REM_PRIVINSTR_TRAP, r4
!Adresse fuer Segment-Trap und Priv. Instr. Trap in PSAREA neu setzen!
	ld	%24(r9), #%0000	!Segmentadresse=0!
	ld	%22(r9), #%4000	!FCW=nonsegmented!
	ld	%26(r9), #SEGMENT_TRAP	!Offsetadresse!
	ld	%12(r9), #%4000	!FCW=nonsegmented!
	ld	%14(r9), #%0000	!Segmentadresse=0!
	ld	%16(r9), #PRIVINSTR_TRAP !Offsetadresse!

!SDR-Tabellen fuer Test laden! 
	ld	r10, #%A100	!%A100-%A1FF mit %00 laden!
	ld	r11, #%A101
	xor	r5, r5
	ld	r0, #%00FF
	ldb	@r10, rl5
	ldirb	@r11, @r10, r0

	ld	r10, #%A000	!%A000-%A0FF mit %00 BIS %FF laden!
LD_INC:
	ldb	@r10, rl5
	inc	r10, #%01
	inc	r5, #%01
	bitb	rh5, #%00
	jr	z, LD_INC

	ld	r10, #%A200	!%A200-%A2FF mit %AA laden!
	ld	r11, #%A201
	ld	r5, #%AAAA
	ld	r0, #%00FF
	ldb	@r10, rl5
	ldirb	@r11, @r10, r0

	ld	r10, #%A300	!%A300-%A3FF mit %55 laden!
	ld	r11, #%A301
	ld	r5, #%5555
	ld	r0, #%00FF
	ldb	@r10, rl5
	ldirb	@r11, @r10, r0

!Schleife L14E2 wird 3x durchlaufen mit 
r2=0,2,4 (r2-Zeiger auf 1. MMU-Adresse in MMU_LISTE1 fuer den entsprechenden
Durchlaufes!
	xor	r2, r2		!r2=0 (1. Schleifendurchlauf)
				 Reihenfolge der MMU's:
				 1. CODE-, 2. DATA-, 3. STACK-MMU!
				!r2=2 (2. Schleifendurchlauf)
				 Reihenfolge der MMU's:
				 1. DATA-, 2. STACK-, 3. CODE-MMU!
				!r2=4 (3. Schleifendurchlauf)
				 Reihenfolge der MMU's:
				 1. STACK-, 2. CODE-, 3. DATA-MMU!
L14E2:

!---------------------------------------------------------
Testschritt (0300)
Test auf individuelle Adressierbarkeit der einzelnen MMU's
---------------------------------------------------------! 
	xor	r3, r3	
	ld	r8, #%0300	!Fehlernummer 300!

!64 SDR der 3 MMU's fuellen!
	ld	r6, MMU_LISTE1(r2) !Adresse der 1. MMU des entsprechenden
				    Durchlaufes: CODE-MMU (1. Durchlauf)
			                    bzw. DATA-MMU (2. Durchlauf)
				            bzw. STACK-MMU (3. Durchlauf) !
	ld	r11, #%A000	!Anfangsadresse der SDR-Tabelle im Speicher!
	call	LD_SDR		!64 SDR der 1. MMU  des Durchlaufes fuellen mit
 				 Inhalt des Speicherbereiches %A000-%A0FF!
	incb	rl2, #%02
	ld	r6, MMU_LISTE1(r2) !Adresse der 2. MMU des entsprechenden
				    Durchlaufes: DATA-MMU (1. Durchlauf)
					    bzw. STACK-MMU (2. Durchlauf)
					    bzw. CODE-MMU (3. Durchlauf) !
	ld	r11, #%A100	!Anfangsadresse der SDR-Tabelle im Speicher!
	call	LD_SDR		!64 SDR der 2. MMU des Durchlaufes fuellen mit
				 Inhalt des Speicherbereiches %A100-%A1FF!
	incb	rl2, #%02
	ld	r6, MMU_LISTE1(r2) !Adresse der 3. MMU des entsprechenden
				    Durchlaufes: STACK-MMU (1.Durchlauf)
					    bzw. CODE-MMU (2. Durchlauf)
					    bzw. DATA-MMU (3. Durchlauf)!
	call	LD_SDR		!64 SDR der 3. MMU des Durchlaufes fuellen mit
				 Inhalt des Speicherbereiches %A100-%A1FF!
	decb	rl2, #%04	!Zeiger in MMU_LISTE1 wieder auf 1. MMU des
				 entsprechenden Durchlaufes stellen!
!Vergleich: geschriebener mit rueckgelesener SDR-Tabelle fuer die
3 MMU's des entsprechenden Durchlaufes
(r3=0: 1. MMU / r3=2: 2. MMU / r3=4: 3. MMU des Durchlaufes)!
L150E:
	ld	r9, r3
	add	r9, r2
	ld	r6, MMU_LISTE1(r9) !Adresse der 1. bzw. 2. bzw. 3. MMU
				    entsprechend r3!
	ld	r11, MMU_LISTE2(R3) !Anfangsadresse der zugehoerigen SDR-
				     Tabelle im Speicher!
	call	RD_SDR		!Vergleich: geschriebene und rueckgelesene
				 SDR-Tabelle; ggf. Fehler 80!
	incb	rl3, #%02
	cpb	rl3, #%06
	jr	nz, L150E	!naechste MMU!

!----------------------------------
Testschritt (0301)
Test der SAR- bzw. DSCR-Indizierung
----------------------------------!

	andb	rh1, #%01	!Flagbyte Bit 1-7 loeschen!
	inc	r8, #1		!Fehlernummer 301!

	ld	r0, #%001E	!Anzahl der Bytes der MMU_LISTE3!
				!(10 x 3 Bytes)!
	ld	r6, MMU_LISTE1(R2) !Adresse der 1. MMU des entsprechenden
				    Durchlaufes: CODE-MMU (1. Durchlauf)
					    bzw. DATA-MMU (2. Durchlauf)
					    bzw. STACK-MMU (3. Durchlauf) !
	ld	r3, #MMU_LISTE3
!Schleife L1538 wird 10 mal durchlaufen, wobei bei jedem Durchlauf 3 Bytes
 der MMU_LISTE3 benutzt werden (1.Byte: write SAR; 2.Byte: write DSCR; 
 3.Byte: Datenwert, der rueckgelesen werden muesste)!
L1538:
	ld	r10, r6		!Adresse der 1. MMU des Durchlaufes!
	add	r10, #%0100	!Write Segment-Adress-Register (SAR)!
	ldb	rl7, @r3
	sllb	rl7, #%02
	soutib	@r10, @r3, r0	!Beschreiben SAR mit akt. Byte der MMU_LISTE3!
				!incr r3 / decr r0!

	ld	r10, r6		!Adresse der 1. MMU des Durchlaufes!
	add	r10, #%2000	!Write Descriptor-Selector-Counter-Reg. (DSCR)!
	addb	rl7, @r3	!rl7=Fehlerpar. (SDR FELD#)!
	soutib	@r10, @r3, r0	!Beschreiben DSCR mit akt. Byte der MMU_LISTE3!
				!incr r3 / decr r0!

	ld	r10, r6		!Adresse der 1. MMU des Durchlaufes!
	add	r10, #%0F00	!Read Descriptor and increment SAR!
	ldb	rl5, @r3	!rl5=Fehlerpar. (Testdatenwert (Datenwert, der
				 rueckgelesen werden muesste))!
	ld	r9, #REM_MMU_SINOUT !Speicherplatz fuer rueckgelesenen Wert!
	sinib	@r9, @r10, r0	!Ruecklesen!
				!incr r9 / decr r0!
	dec	r9, #%01
	ldb	rl4, @r9	!rl4=Fehlerpar. (rueckgelesener Datenwert)!
	call	BY_WO_CMP	!Vergleich rl4/rl5; ggf. Fehler 81!
	bitb	rh1, #%07
	jr	nz, L1578	!Fehler aufgetreten, naechster Testschritt!
	inc	r3, #%01	!r3 auf naechstes Byte in MMU_LISTE3 stellen!
	testb	rl0		!MMU_LISTE3 abgearbeitet?!
	jr	nz, L1538	!nein!

!--------------------
Testschritt (0302)
Test der SDR-Daten
--------------------!
	inc	r8, #1		!Fehlernummer 302!

L1578:
	ld	r11, #%A200	!Anfangsadresse der SDR-Tabelle im Speicher!
	call	LD_SDR		!64 SDR der 1. MMU des Durchlaufes fuellen
				 mit 'AA' (Inhalt Speicherbereich %A200-%A2FF)!
	call	RD_SDR		!Vergleich geschriebene mit rueckgelesene
				 SDR-Tabelle; ggf. Fehler 82!
	ld	r11, #%A300	!Anfangsadresse der SDR-Tabelle im Speicher!
	call	LD_SDR		!64 SDR der 1. MMU des Durchlaufes fuellen
				 mit '55' (Inhalt Speicherbereich %A300-%A3FF)!
	call	RD_SDR		!Vergleich geschriebene mit rueckgelesene
				 SDR-Tabelle; ggf. Fehler 82!

!----------------------------------
Testschritt (0303)
Test der MMU-Control-Register-Daten
----------------------------------!

	xorb	rh1, rh1	!Flagbyte rh1 loeschen!
	inc	r8, #1		!Fehlernummer 303!

	ld	ERRPAR_ID, #%00a5 !Fehlerparameter fuer Fehler 303:
							   r7, rl5, rl4!
	ld	r9, #REM_MMU_SINOUT !Speicherplatz fuer Testdaten!
	ld	@r9, #%AAAA	!Test mit Daten 'AA'!
	ldb	rl0, #%02	!2 Durchlaeufe fuer Schleife L15A4
				 (fuer Daten 'AA' bzw. '55')!
L15A4:
!Beschreiben der Control-Register aller MMU's!
	ldb	rl5, @r9	!rl5=Fehlerpar. (Testdatenwert)!
	soutb	ALL_MMU + %0000, rl5	!Write Mode-Register!
	soutb	ALL_MMU + %0100, rl5	!Write Segment-Adress-Register (SAR)!
	soutb	ALL_MMU + %2000, rl5	!Write Descriptor-Selector-Counter-
					 Register (DSCR)!
!Ruecklesen der Control-Register der 1. MMU des Durchlaufes und Vergleich!
	ld	r10, r6		!Adresse der 1. MMU des Durchlaufes!
	add	r10, #%0000	!Read Mode-Register!
	sinib	@r9, @r10, r11	!Ruecklesen Mode-Register!
	dec	r9, #%01
	ldb	rl4, @r9	!rl4=Fehlerpar. (rueckgelesener Datenwert)!
	ld	r7, r6		!r7=Fehlerpar. (MMU CMD#)
				 rl7 - MMU-Adresse
				 rh7 - Kommando %00: R/W Mode-Register!
	call	BY_WO_CMP	!Vergleich rl5/rl4; ggf. Fehler 83!
	ld	r10, r6
	add	r10, #%0100	!Read Segment-Adress-Register (SAR)!
	sinib	@r9, @r10, r11	!Ruecklesen SAR!
	dec	r9, #%01
	ldb	rl4, @r9	!rl4=Fehlerpar. (rueckgelesener Datenwert)!
	andb	rl5, #%3F	!rl5=Fehlerpar. (Testdatenwert (Datenwert, der
				 rueckgelesen werden muesste))!
	incb	rh7, #%01	!r7=Fehlerpar. (MMU CMD#)
				 rl7 - MMU-Adresse
				 rh7 - Kommando %01: R/W SAR!
	call	BY_WO_CMP	!Vergleich rl5/rl4; ggf. Fehler 83!
	ld	r10, r6
	add	r10, #%2000	!Read Descriptor-Selector-Counter-Register!
	sinib	@r9, @r10, r11	!Ruecklesen DSCR!
	dec	r9, #%01
	ldb	rl4, @r9	!rl4=Fehlerpar. (rueckgelesener Datenwert)!
	andb	rl5, #%03	!rl5=Fehlerpar. (Testdatenwert (Datenwert, der
				 rueckgelesen werden muesste))!
	ldb	rh7, #%20	!r7=Fehlerpar. (MMU CMD#)
				 rl7 - MMU-Adresse
				 rh7 - Kommando %20: R/W DSCR!
	call	BY_WO_CMP	!Vergleich rl5/rl4; ggf. Fehler 83!
	ld	@r9, #%5555	!Test mit Daten '55'!
	dbjnz	rl0, L15A4
	incb	rl2, #%02
	cpb	rl2, #%06
	jp	nz, L14E2	!r2=2 (2. Schleifendurchlauf)!
				!bzw.!
				!r2=4 (3. Schleifendurchlauf)!

!-------------------------------------------
Testschritt (0304)
Test der System-/Normal-Break-Register-Daten
-------------------------------------------!

	inc	r8, #1		!Fehlernummer 304!

	ld	r10, #%0100
	xor	r11, r11
	sc	#SC_SEGV
	ld	@r10, #%0001
	ld	r11, r10
	ld	@r10, #%0000
	sc	#SC_NSEGV
	lda	r3, MMU_LISTE4
	ld	r4, r3
	lda	r5, MMU_LISTE10
	xor	r7, r7
	call	CLR_CTL_REG
	ldb	rl0, #%02
	ld	r6, #CODE_MMU+%0F00
	ld	r7, #DATA_MMU+%0F00
	ld	r9, #STACK_MMU+%0F00
LB_1826:
	ld	r2, #%0004
	sotirb	@r6, @r3, r2
	ld	r2, #%0004
	sotirb	@r7, @r4, r2
	ld	r2, #%0004
	sotirb	@r9, @r5, r2
	lda	r3, MMU_LISTE8
	lda	r4, MMU_LISTE9
	ld	r5, r4
	dbjnz	rl0, LB_1826
	ldb	rl0, #%D0
	soutb	ALL_MMU, rl0
	ldb	rl0, #%02
	outb	S_BNK, rl0
	xor	r11, r11
	sc	#SC_SEGV
	ld	r12, @r10
	sc	#SC_NSEGV
	xor	r0, r0
	outb	S_BNK, rl0
	soutb	ALL_MMU, rl0
	ld	REM_MMU2, r0
	ld	REM_MMU1, r12
	test	r12
	jr	z, LB_187C
	set	REM_MMU2, #%00
	jp	LB_18A8
LB_187C:
	ld	ERRPAR_ID, #%0094
	xorb	rh1, rh1

	ldb	rl0, #%02	!2 Durchlauefe der Schleife L1616 fuer
				 System- und Normal-Break-Register!
	ld	r6, #SBREAK	!Test System-Break-Register!
L1616:
	ld	r5, #%AAAA	!rl5=Fehlerpar. (Testdatenwert)!
	outb	@r6, rl5	!Break-Reg. beschreiben!
	inb	rl4, @r6	!rl4=Fehlerpar. (rueckgelesener Datenwert)!
	call	BY_WO_CMP	!Vergleich rl5/rl4; ggf. Fehler 84!
	ld	r5, #%5555	!rl5=Fehlerpar. (Testdatenwert)!
	outb	@r6, rl5	!Break-Reg. beschreiben!
	inb	rl4, @r6	!rl4=Fehlerpar. (rueckgelesener Datenwert)!
	call	BY_WO_CMP	!Vergleich rl5/rl4; ggf. Fehler 84!
	ld	r6, #NBREAK	!Test Normal-Break-Register!
	dbjnz	rl0, L1616

LB_18A8:
	call	PR_POWER_UP	!POWER UP DI!

!----------------------------------------------
Testschritt (0305 'I')
Test, ob STACK-MMU beim Limit-Test Trap erzeugt
----------------------------------------------!
	inc	r8, #1		!Fehlernummer 305!

	ld	r2, #%9000
	outb	SBREAK, rh2	!System-Break-Register mit %90 laden!
	outb	NBREAK, rh2	!Normal-Break-Register mit %90 laden!
	ld	r3, #MMU_LISTE4	!r3 - Zeiger auf SDR-Feld fuer CODE-MMU!
	ld	r4, r3		!r4 - Zeiger auf SDR-Feld fuer DATA-MMU!
	ld	r5, #MMU_LISTE6	!r5 - Zeiger auf SDR-Feld fuer STACK-MMU!
	test	REM_MMU1
	jr	z, LB_18CE
	ld	r5, #MMU_LISTE5
LB_18CE:
	call	LD_3SDR		!SDR der 3 MMU's programmieren!

	ld	r3, #%A000	!Offsetadresse fuer Trap-Test!
	ldb	rh0, #%04	!MMU_ID: Stack-MMU muss Trap ausloesen!
	ldb	rl4, #%D2
	call	SEGMENT_TRAP_TEST !Trap-Test; ggf. Fehler 0305!

	call	PR_POWER_UP	!POWER UP DIA!

!-------------------------
Testschritt (0305 'A')
Test auf unerwarteten Trap
-------------------------!

	ld	r3, #%8000	!Offsetadresse fuer Trap-Test!
	xorb	rh0, rh0	!kein Trap darf ausgeloest werden!
	ldb	rl4, #%D1
	call	SEGMENT_TRAP_TEST !Trap-Test; ggf. Fehler 86!

!-------------------------
Testschritt (0305 'G')
Test auf unerwarteten Trap
-------------------------!

	ld	r3, #MMU_LISTE4	!r3 - Zeiger auf SDR-Feld fuer CODE-MMU!
	ld	r4, #MMU_LISTE6	!r4 - Zeiger auf SDR-Feld fuer DATA-MMU!
	ld	r5, r3		!r5 - Zeiger auf SDR-Feld fuer STACK-MMU!
	test	REM_MMU1
	jr	z, LB_18FE
LB_18FE:
	call	LD_3SDR		!SDR der 3 MMU's programmieren!

	call	PR_POWER_UP	!POWER UP DIAG!

	ld	r3, #%A000	!Offsetadresse fuer Trap-Test!
	xorb	rh0, rh0	!kein Trap darf ausgeloest werden!
	ldb	rl4, #%D2
	call	SEGMENT_TRAP_TEST !Trap-Test; ggf. Fehler 0305!

	call	PR_POWER_UP	!POWER UP DIAGN!

!----------------------------------------------
Testschritt (0305 'N')
Test, ob DATA-MMU beim Limit-Test Trap erzeugt
----------------------------------------------!

	ld	r3, #%8000	!Offsetadresse fuer Trap-Test!
	ldb	rh0, #%02	!MMU_ID: DATA-MMU muss Trap ausloesen!
	ldb	rl4, #%D1
	call	SEGMENT_TRAP_TEST !Trap-Test; ggf. Fehler 88!
!--------------------------------------------------
Testschritt (0305 'O')
Test, ob STACK-MMU beim Read-Only-Test Trap erzeugt
--------------------------------------------------!

	ld	r3, #MMU_LISTE4	!r3 - Zeiger auf SDR-Feld fuer CODE-MMU!
	ld	r4, #MMU_LISTE7	!r4 - Zeiger auf SDR-Feld fuer DATA-MMU!
	ld	r5, r4		!r5 - Zeiger auf SDR-Feld fuer STACK-MMU!
	call	LD_3SDR		!SDR der 3 MMU's programmieren!

	call	PR_POWER_UP	!POWER UP DIAGNO!

	ld	r3, #%A000	!Offsetadresse fuer Trap-Test!
	ldb	rh0, #%04	!MMU_ID: STACK-MMU muss Trap ausloesen!
	ldb	rl4, #%D2
	call	SEGMENT_TRAP_TEST !Trap-Test; ggf. Fehler 89!

	call	PR_POWER_UP	!POWER UP DIAGNOS!

!--------------------------------------------------
Testschritt (0305 'S')
Test, ob DATA-MMU beim Read-Only-Test Trap erzeugt
--------------------------------------------------!

	ld	r3, #%8000	!Offsetadresse fuer Trap-Test!
	ldb	rh0, #%02	!MMU_ID: DATA-MMU muss Trap ausloesen!
	ldb	rl4, #%D1
	call	SEGMENT_TRAP_TEST !Trap-Test; ggf. Fehler 90!

	call	PR_POWER_UP	!POWER UP DIAGNOST!

!------------------------------------------------
Testschritt (0306/0307 'T')
Test, ob Uebersetzung der DATA-MMU fehlerfrei ist
------------------------------------------------!

	inc	r8, #1		!Fehlernummer 306!

	ld	ERRPAR_ID, #%009A !Fehlerparameter fuer Fehler 91:
							r6, rl7, r5, r4 !
	xorb	rh1, rh1	!Flagbyte rh1 loeschen!
	setb	rh1, #%01	!WORD-Vergleich in BY_WO_CMP!

	ld	r2, #%FFFF
	outb	SBREAK, rl2	!System-Break-Register mit %FF laden!
	outb	NBREAK, rl2	!Normal-Break-Register mit %FF laden!

	ld	r3, #MMU_LISTE4	!r3 - Zeiger auf SDR-Feld fuer CODE-MMU!
	ld	r4, r3		!r4 - Zeiger auf SDR-Feld fuer DATA-MMU!
	ld	r5, r3		!r5 - Zeiger auf SDR-Feld fuer STACK-MMU!
	call	LD_3SDR		!SDR der 3 MMU's programmieren!
	xor	r2, r2		!rh2=logische Segmentnummer (0-63)!
	ld	r3, #%9000	!Offsetadresse fuer Test!
	ld	r5, #%AAAA	!r5=Fehlerpar. (Testdatenwert (auf Offset-
				 adresse r3 zu schreiben))!
	ld	r6, #DATA_MMU	!r6=Fehlerpar. (MMU PORT#)!
	ld	r0, #%00D1

!Schleife fuer die Segmente 0-63 (r2)!
TST_DATA_MMU:
	ld	@r3, #%0000	!Speicheradresse %9000 loeschen!
	ld	REM_MMU_ID, #%0000 !Merker: MMU-ID loeschen -
				    wird bei Segment-Trap gesetzt!
	ldb	rl4, #%02
	test	REM_MMU1
	jr	z, LB_199E
	ldb	rl4, #%06
LB_199E:
	outb	S_BNK, rl4	!MMU's einschalten!

	soutb	DATA_MMU, rl0	!Mode-Register mit %D1 laden (ID=1), d.h.
				 DATA-MMU aktivieren!

	ldctl	r9, FCW
	set	r9, #%0F
	test	REM_MMU2
	jr	z, LB_19B2
	res	r9, #%0E
LB_19B2:
	ldctl	FCW, r9
	ld	@r2, r5		!Speicheradresse rr2 (Segment rh2/Offset %9000)
				 mit Datenwert %AAAA beschreiben!
	sc	#SC_NSEGV

	soutb	DATA_MMU, rh0	!Mode-Register mit %00 laden, d.h.
				 DATA-MMU deaktivieren!
	outb	S_BNK, rh0	!MMU's ausschalten!
	ldb	rl7, rh2	!rl7=Fehlerpar. (SDR#) =log. Segmentnummer!
	test	REM_MMU_ID	!Segment-Trap (Routine SEGMENT_TRAP)
				 aufgetreten?!
	jr	nz, L1738	!ja, d.h. Fehler 92!
	ld	r4, @r3		!r4=Fehlerpar. (rueckgelesener Datenwert!
	call	BY_WO_CMP	!Vergleich r5/r4; ggf. Fehler 91!
	bitb	rh1, #%07	!Fehler aufgetreten?!
	jr	nz, L1748	!ja, d.h. naechster Testschritt!
	incb	rh2, #%01
	cpb	rh2, #%40
	jr	nz, TST_DATA_MMU !naechste logische Segmentnummer!
	jr	L1748		!alle Segmentnummern abgearbeitet, d.h.
				 naechster Testschritt!
L1738:
	inc	r8, #1		!Fehlernummer 307!

	ld	ERRPAR_ID, #%0098 !Fehlerparameter fuer Fehler 92:
							r6, rl7, r5 !
	ld	r5, REM_MMU_BCSR !r5=Fehlerpar. (VDAT) - Werte der Status-
                                  Register BCSR und VTR nach Segment-Trap:
 				  rh5= Bus Cycle Status Register (BCSR) / 
				  rl5= Violation Type Register (VTR) !
	call	MSG_ERROR	!Fehlerausgabe!

!-------------------------------------------------
Testschritt (0308/0309 'I')
Test, ob Uebersetzung der STACK-MMU fehlerfrei ist
-------------------------------------------------!

L1748:
	call	PR_POWER_UP	!POWER UP DIAGNOST!
	ld	r8, #%0308	!Fehlernummer 308!

	ld	ERRPAR_ID, #%009A !Fehlerparameter fuer Fehler 93:
							r6, rl7, r5, r4!
	xorb	rh1, rh1	!Flagbyte rh1 loeschen!
	setb	rh1, #%01	!WORD-Vergleich in BY_WO_CMP!
	ld	r0, #%00D2
	outb	SBREAK, rh0	!System-Break-Register mit %00 laden!
	outb	NBREAK, rh0	!Normal-Break-Register mit %00 laden!
	xor	r2, r2		!rh2=logische Segmentnummer (0-63)!
	test	REM_MMU1
	jr	z, LB_1A16
	ld	r2, #%40	!rl2=logische Segmentnummer (64-127)!
LB_1A16:
	ld	r6, #STACK_MMU	!r6=Fehlerpar. (MMU PORT#)!
!Schleife fuer die Segmente 64-127 (r2)!
TST_STACK_MMU:
	ld	@r3, #%0000	!Speicheradresse %9000 loeschen!
	ld	REM_MMU_ID, #%0000 !Merker: MMU-ID loeschen -
				    wird bei Segment-Trap gesetzt!
	ldb	rl4, #%02
	test	REM_MMU1
	jr	z, LB_1A2E
	ldb	rl4, #%06
LB_1A2E:
	outb	S_BNK, rl4	!MMU's einschalten!

	soutb	STACK_MMU, rl0	!Mode-Register mit %D2 laden (ID=2), d.h.
				 STACK-MMU aktivieren!

	ldctl	r9, FCW
	set	r9, #%0F
	test	REM_MMU2
	jr	z, LB_1A42
	res	r9, #%0E
LB_1A42:
	ldctl	FCW, r9
	ld	@r2, r5		!Speicheradresse rr2 (Segment rh2/Offset %9000)
				 mit Datenwert %AAAA beschreiben!
	sc	#SC_NSEGV

	soutb	STACK_MMU, rh0	!Mode-Register mit %00 laden, d.h.
				 STACK-MMU deaktivieren!
	outb	S_BNK, rh0	!MMU's ausschalten!
	ldb	rl7, rh2	!rl7=Fehlerpar. (SDR#) =log. Segmentnummer!
	test	REM_MMU_ID	!Segment-Trap (Routine SEGMENT_TRAP)
				 aufgetreten?!
	jr	nz, L17AA	!ja, d.h. Fehler 94!
	ld	r4, @r3		!r4=Fehlerpar. (rueckgelesener Datenwert!
	call	BY_WO_CMP	!Vergleich r5/r4; ggf. Fehler 93!
	bitb	rh1, #%07	!Fehler aufgetreten?!
	jr	nz, L17BA	!ja, d.h. naechster Testschritt!
	incb	rh2, #%01
	test	REM_MMU1
	jr	z, LB_1A72
	cpb	rh2, #%80
	jr	nz, TST_STACK_MMU
	jr	L17BA
LB_1A72:
	cpb	rh2, #%40
	jr	nz, TST_STACK_MMU !naechste logische Segmentnummer!
	jr	L17BA		!alle Segmentnummern abgearbeitet, d.h.
				 naechster Testschritt!


L17AA:
	inc	r8, #1		!Fehlernummer 309!
	ld	ERRPAR_ID, #%0098 !Fehlerparameter fuer Fehler 94:
							r6, rl7, r5 !

	ld	r5, REM_MMU_BCSR !r5=Fehlerpar. (VDAT) - Werte der Status-
                                  Register BCSR und VTR nach Segment-Trap:
 				  rh5= Bus Cycle Status Register (BCSR) / 
				  rl5= Violation Type Register (VTR) !
	call	MSG_ERROR	!Fehlerausgabe!

!------------------------------------------------
Testschritt (0310/0311 'C')
Test, ob Uebersetzung der CODE-MMU fehlerfrei ist
------------------------------------------------!

L17BA:
	call	PR_POWER_UP	!POWER UP DIAGNOSTI!
	ld	r8, #%0310	!Fehlernummer 310!

	ld	ERRPAR_ID, #%009A !Fehlerparameter fuer Fehler 95:
							r6, rl7, r5, r4 !
	xorb	rh1, rh1	!Flagbyte rh1 loeschen!
	setb	rh1, #%01	!WORD-Vergleich in BY_WO_CMP!
	clr	REM_MMU2
	ldctl	r9, PSAP
	ld	%26(r9), #CODE_TRAP !neue Trap-Routine fuer Segment-Trap
				     in PSAREA eintragen!
	ld	r4, #CODE_FELD
	ld	r5, #%9000
	ld	r3, #%0004
	ldirb	@r5, @r4, r3	!CODE_FELD NACH %9000 MOVEN!
	ld	r0, #%00D0
	ld	r6, #CODE_MMU	!r6=Fehlerpar. (MMU PORT#)!
	ldb	rl3, #%02	!Kennzeichnung Testschritt 310 (rl3=2)!
	ldb	rh3, #%02
	test	REM_MMU1
	jr	z, LB_1ACC
	ldb	rh3, #%06
LB_1ACC:
	xor	r2, r2		!rh2=logische Segmentnummer (0-63)!
	ld	r5, r2		!r5=Fehlerpar. (Testdatenwert) = %0000
				 (r4 soll durch Abarbeitung von CODE_FELD
				 auf diesen Wert gesetzt werden)!
	ld	r10, r2		!r10/r11 - Ansprungadresse Marke FKT_TST!
	ld	r11, #FKT_TST	!(Segment 0, Offset #FKT_TST)!
	ld	r13, #%9000	!Ansprungadresse (Offset) fuer CODE_FELD!

!Schleife fuer die Segmente 0-63 (r2)!
TST_CODE_MMU:
	ld	r12, r2		!Ansprungadresse (Segment) fuer CODE_FELD
				 (Segment 0-63)!
	ld	REM_MMU_ID, #%0000 !Merker: MMU-ID loeschen -
				    wird bei Segment-Trap gesetzt!
	ld	r4, #%AAAA	!r4=Fehlerpar. (zurueckgegebener Datenwert)
				 setzen (wird bei Abarbeitung von
				 CODE_FELD auf %0000 gesetzt)!
	outb	S_BNK, rh3	!MMU's einschalten!
	soutb	CODE_MMU, rl0	!Mode-Register mit %D0 laden (ID=0), d.h.
				 CODE-MMU aktivieren!
	sc	#SC_SEGV
	jp	@r12		!Sprung zu CODE_FELD auf Offsetadresse %9000
				 im aktuellen Segment (r2) - r4 wird in
				 CODE_FELD auf den Wert %0000 gesetzt;
				 dann Fortsetzung bei FKT_TST!
			!oder!
				!Segment-Trap (Routine CODE_TRAP) -
				 r4 wird nicht veraendert;
				 dann Fortsetzung bei FKT_TST!
FKT_TST:
	sc	#SC_NSEGV

	soutb	CODE_MMU, rh0	!Mode-Register mit %00 laden, d.h.
				 CODE-MMU deaktivieren!
	outb	S_BNK, rh0	!MMU's ausschalten!
	ldb	rl7, rh2	!rl7=Fehlerpar. (SDR#) =log. Segmentnummer!
	bitb	rl3, #%00	!rl3=2 bei Testschritt 310;
				 rl3=1 bei Testschritt 311!
	jr	nz, L1866	!Programmfortsetzung fuer Testschritt 0312!

	test	REM_MMU_ID	!Segment-Trap (Routine CODE_TRAP) aufgetreten?!
	jr	nz, L1874	!ja, d.h. Fehler 96!

	call	BY_WO_CMP	!Vergleich r5/r4, d.h. ob CODE_FELD abge-
				 arbeitet wurde und dabei r4 auf 0 gesetzt
				 wurde; ggf. Fehler 95!
	bitb	rh1, #%07	!Fehler aufgetreten?!
	jr	nz, L183C	!ja, d.h. naechster Testschritt!
				!(korrigiert: im Original L1842)!
L1834:
	incb	rh2, #%01
	cpb	rh2, #%40
	jr	nz, TST_CODE_MMU !naechste logische Segmentnummer!

				!alle Segmentnummern abgearbeitet, d.h.
				 naechster Testschritt!

	decb	rl3, #%01	!rl3=1, d.h. Kennzeichnung Testschritt 311;
				 rl3=0, d.h. Testschritt 311 beendet!
	testb	rl3
	jr	z, REM_MMU_TEST_END	!Ende des Testes!

!---------------------------------------------
Testschritt (0312 'S')
Test, ob CODE-MMU beim Limit-Test Trap erzeugt
---------------------------------------------!

L183C:
	call	PR_POWER_UP	!POWER UP DIAGNOSTIC!
	ld	r8, #%0312	!Fehlernummer 312!

	xorb	rh1, rh1	!Flagbyte rh1 loeschen!
	push	@r15, r3
	ld	r3, #MMU_LISTE5	!r3 - Zeiger auf SDR-Feld fuer CODE-MMU!
	ld	r4, #MMU_LISTE4	!r4 - Zeiger auf SDR-Feld fuer DATA-MMU!
	ld	r5, r4		!r5 - Zeiger auf SDR-Feld fuer STACK-MMU!
	call	LD_3SDR		!SDR der 3 MMU's programmieren!
	pop	r3, @r15

	xor	r2, r2		!rh2=logische Segmentnummer (0-63)!
	ld	r5, #%AAAA	!ueberfluessig ???!
	jr	TST_CODE_MMU

L1866:
	test	REM_MMU_ID	!Segment-Trap (Routine CODE_TRAP) aufgetreten?!
	jr	nz, L1834	!ja, d.h. kein Fehler;
				 naechste Segmentnummer!

	ld	ERRPAR_ID, #%0090 !Fehlerparameter fuer Fehler 97: r6, rl7 !

	jr	L1880		!Fehlerausgabe!

!---------------------------------------------
Testschritt (0312 'S')
Test, ob CODE-MMU beim Limit-Test Trap erzeugt
---------------------------------------------!

L1874:
	inc	r8, #1		!Fehlernummer 313!
	ld	ERRPAR_ID, #%0098 !Fehlerparameter fuer Fehler 313:
							r6, rl7, r5 !
	ld	r5, REM_MMU_BCSR !r5=Fehlerpar. (VDAT) - Werte der Status-
                                  Register BCSR und VTR nach Segment-Trap:
 				  rh5= Bus Cycle Status Register (BCSR) / 
				  rl5= Violation Type Register (VTR) !

L1880:
	call	MSG_ERROR	!Fehlerausgabe!

REM_MMU_TEST_END:
	ldctl	r9, PSAP
	ld	r4, REM_ERR_CNT
	ld	%26(r9), r4	!Adresse der urspruenglichen Segment-Trap-
				 Routine wieder in PSAREA abspeichern!
	ld	r4, REM_PRIVINSTR_TRAP
	ld	%16(r9), r4	!Adresse der urspruenglichen Priv.-Instr.-Trap-
				 Routine wieder in PSAREA abspeichern!
	xorb	rl0, rl0
	outb	S_BNK, rl0
	soutb	ALL_MMU, rl0

	jp	MSG_MAXSEG	!Ausgabe "MAXSEG=<xx>"!


CODE_FELD:
	xor	r4,r4		!r4=Fehlerpar. (zurueckgegebener Datenwert)=
				 %0000 (Kennzeichnung, dass CODE_FELD
				 abgearbeitet wurde)!
	jp	@r10		!Sprung zu FKT_TST!
    end MMU_TEST

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE RAM_TEST_SEG
RAM-Test eines Segmentes
Input:	r6 - Segmentnummer des zu testenden Segments
	rh1 Bit0=0 - Test nicht in Segment 0
	        =1 - Test in Segment 0
	r9 - Stand FCW
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    RAM_TEST_SEG procedure
      entry

!-----------------------------------
Testschritt (0100)
Test auf fehlerhafte Speicheradresse
-----------------------------------!

!Die 15 Adressen (0003,0006,000C,0018,0030,0060,00C0,0180,0300,0600,0C00,1800,
3000,6000,C000) des betrachteten Segments werden beschrieben und wieder
rueckgelesen.!

	andb	rh1, #%01	!Loeschen Bit1-7(rh1);
				 Bit1(rh1):=0, d.h. Bytevergleich in BY_WO_CMP!
	ld	ERRPAR_ID, #%00E5 !Fehlerparameter fuer Fehler 100:
							<r6>, r7, rl5, rl4 !

!15 Adresse des Segments beschreiben!

	ld	r7, #%0003	!Anfangs-Offset-Adresse!
	ldb	rl5, #%0F	!Adressenzaehler: 15 Adresse testen!
RATE1:
	set	r9, #%0F
	ldctl	FCW, r9		!segmentierten Mode einstellen!
	ldb	@r6, rl5	!Speicherzelle beschreiben
				 (mit akt. Stand des Adressenzaehlers rl5)!
	res	r9, #%0F
	ldctl	FCW, r9		!nichtsegmentierten Mode einstellen!
	rl	r7, #%01	!Offsetadresse um 1 Bit nach links verschieben!
	dbjnz	rl5, RATE1	!naechste Adresse!

!Ruecklesen der beschriebenen Adressen!

	rl	r7, #%01	!Anfangs-Offset-Adressse := %0003!
	ldb	rl5, #%0F	!Adressenzaehler!
RATE2:
	set	r9, #%0F
	ldctl	FCW, r9		!segmentierten Mode einstellen!
	ldb	rl4, @r6	!Speicherzelle ruecklesen!
	res	r9, #%0F
	ldctl	FCW, r9		!nichtsegmentierten Mode einstellen!
	call	BY_WO_CMP	!Vergleich eingetragener Wert (rl5) mit
				 rueckgelesenen Wert (rl4); 
				 ggf. Fehler 72: Mem Addr Fault!
	bitb	rh1, #%07	!Fehler aufgetreten?!
	jr	nz, RATE3	!ja --> naechster Testschritt!

	rl	r7, #%01	!Offsetadresse um 1 Bit nach links verschieben!
	dbjnz	rl5, RATE2	!naechste Adresse testen!

!--------------------------------
Testschritt 73 (0101)
Test auf fehlerhafte Datenleitung
--------------------------------!

!Die Adresse %8000 des betrachteten Segments wird nacheinander mit den Werten
0001,0002,0004,0008,0010,0020,0040,0080,0100,0200,0400,0800,1000,2000,4000,
8000,0001 (jeweils ein Bit gesetzt) beschrieben und wieder rueckgelesen.!

RATE3:
	andb	rh1, #%01	!Loeschen Bit1-7(rh1)!
	setb	rh1, #%01	!Bit1(rh1):=1,d.h. WORD-Vergleich in BY_WO_CMP!
	ld	ERRPAR_ID, #%00EA !Fehlerparameter fuer Fehler 101
							<r6>, r7, r5, r4 !
	inc	r8, #1		!Fehlernummer 101!

	ld	r7, #%8000	!r7:=Offsetadresse!
	ld	r5, #1		!r5:=in RAM einzutragender Datenwert 
				 (Anfangswert - Bit0 gesetzt)!
	ldb	rl0, #%11	!rl0:=Anzahl der Schritte!
RATE4:
	set	r9, #%0F
	ldctl	FCW, r9		!segmentierten Mode einstellen!
	ld	@r6, r5		!r5 in RAM eintragen!
	ld	r4, @r6		!r4:=rueckgelesenen Wert!
	res	r9, #%0F
	ldctl	FCW, r9		!nichtsegmentierten Mode einstellen!

	call	BY_WO_CMP	!Vergleich r4/r5; ggf. Fehler 73!
	bitb	rh1, #%07	!Fehler aufgetreten?!
	jr	nz, RATE5	!ja!

	rl	r5, #%01	!nein --> naechstes Bit testen!
	dbjnz	rl0, RATE4

!-----------------------------------------------
Testschritt (0102, 0103)
Test auf fehlerhafte '%AAAA'- bzw. '%5555'-Daten
-----------------------------------------------!

!Das ganze betrachtete Segment wird mit dem Datenwert %AAAA bzw. %5555 
beschrieben und wieder rueckgelesen.!

RATE5:
	ld	r5, #%AAAA	!zuerst %AAAA in RAM eintragen!
RATE6:
	inc	r8, #1		!Fehlernummer 101!
	andb	rh1, #%03	!Loeschen Bit2-7(rh1)!
	ld	r12, r6		!r12=Segnr. Zieladresse:=Segnr. Quelladresse!
	ld	r13, #%0002	!r13=Offset Zieladresse:= %0002!
	xor	r7, r7		!r7=Offset Quelladresse:= %0000!
	ld	r0, #%7FFF	!r0=WORD-Anzahl fuer ldir!
	set	r9, #%0F
	ldctl	FCW, r9		!segmentierten Mode einstellen!
	ld	@r6, r5
	ldir	@r12, @r6, r0	!ganzes Segment mit r5 beschreiben!

	xor	r7, r7		!r7=Anfangs-Offset-Adresse fuer Vergleich:=%0!
	ld	r0, #%8000	!r0=Anzahl der Worte fuer Vergleich!
	cpir	r5, @r6, r0, nz	!Test ab Adr. 0 (max. bis Segmentende), bis
				 zu einer Stelle, wo r5 nicht im RAM steht!
	dec	r7, #2		!r7 zeigt auf fehlerhafte RAM-Adresse!
	ld	r4, @r6		!fehlerhafte Adresse lesen!
	res	r9, #%0F
	ldctl	FCW, r9		!nichtsegmentierten Mode einstellen!
	call	BY_WO_CMP	!Vergleich r4/r5; ggf. Fehler 74!
	cpb	rl5, #%55
	ret	z
	ld	r5, #%5555	!Test mit Datenwort %5555!
	jr	RATE6
    end RAM_TEST_SEG

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE RAM_TEST_SEG0
RAM-Test im Segment 0 ausfuehren
Input:	r6 - Segmentnummer des zu testenden Segments (= %0000)
        r3 - S_BNK
Output:	r3 - Stand Fehlerzaehler (ERR_CNT)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    RAM_TEST_SEG0 procedure
      entry
	ldctl	r9, FCW		!r9:=Stand FCW!
	res	r9, #%0F
	ldctl	FCW, r9		!nichtsegmentierten Mode einstellen!
!Terminalinterrupts sperren!
	ld	r2, #SIO0C_B	
	ld	r4, #1		!SIO_R1!
	outb	@r2, rl4
	outb	@r2, rh4
	inb	rh2, @r3
	setb	rh2, #0		
	outb	@r3, rh2	!Monitor PROM+RAM ausschalten!
	setb	rh1, #0		!Test in Segment 0!
	call	RAM_TEST_SEG	!Ramtest des Segment 0!
	inb	rh2, @r3
	resb	rh2, #0
	outb	@r3, rh2	!Monitor PROM+RAM einschalten!
!Empfaengerinterrupts zulassen!
	ld	r2, #SIO0C_B	
	ld	r4, #%011c	!PDAVCT+SAVECT!
	outb	@r2, rh4
	outb	@r2, rl4
	ld	r3, ERR_CNT	!r3:=Anzahl der Fehler bei RAM_TEST_SEG0
				 (RAM-Zelle ERR_CNT liegt hier im hoechsten
				 Segment)!
	set	r9, #%0F
	ldctl	FCW, r9		!segmentierten Mode einstellen!
	jp	@r10		!RUECKSPRUNG INS SEGMENT 0 ZU REM_MMU_TEST!
    end RAM_TEST_SEG0

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE ECC_TEST_200
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    ECC_TEST_200 procedure
      entry
	call	PR_POWER_UP
	xorb	rh1, rh1
	ld	ECC_MEM_2, #0
	ldl	rr8, #0
ECC200_9:
	ld	r7, #1
	ld	r6, #0
	out	@r7, r6
	ld	REM_MMU_TEST, #%0
	ldl	rr6, MMU_MEM_2
	cpl	rr6, #%80000000
	jr	z, ECC200_1
	slll	rr6, #1
	jp	ECC200_2
ECC200_1:
	ldl	rr6, #1
ECC200_2:
	ldl	MMU_MEM_2, rr6
	ldl	rr12, rr8
	add	r12, #%0100
ECC200_8:
	ldl	rr6, MMU_MEM_1
	call	ECC_TEST_UNKNOWN_01
	ldl	rr6, MMU_MEM_1
	ldl	rr4, MMU_MEM_2
	xor	r4, r6
	xor	r5, r7
	ld	r7, #%8000
	ld	r6, #0
	ld	r3, r2
	call	ECC_TEST_UNKNOWN_05
	ld	r7, #%8000
	ld	r6, #0
	call	ECC_TEST_UNKNOWN_06
	cpl	rr2, MMU_MEM_1
	jr	z, ECC200_3
	inc	ECC_MEM_2, #1
	jp	ECC200_4
ECC200_3:
	inc	REM_MMU_TEST, #1
	ld	r7, #1
	in	r2, @r7
	and	r2, #%00ff
	cp	r2, #%00ff
	jr	nz, ECC200_5
	cp	REM_MMU_TEST, #%0100
	jr	z, ECC200_4
ECC200_5:
	cp	r2, REM_MMU_TEST
	jr	z, ECC200_4
	inc	ECC_MEM_2, #1
	ld	REM_MMU_TEST, #%0000
	ld	r7, #%0001
	ld	r6, #%0000
	out	@r7, r6
ECC200_4:
	ldl	rr10, MMU_MEM_1
	addl	rr10, #%00010001
	ldl	MMU_MEM_1, rr10
	ldl	rr6, MMU_MEM_2
	cpl	rr6, #%80000000
	jr	nz, ECC200_6
	ldl	rr6, #%00000001
	jp	ECC200_7
ECC200_6:
	slll	rr6, #1
ECC200_7:
	ldl	MMU_MEM_2, rr6
	addl	rr8, #%00000001
	cpl	rr12, rr8
	jr	c, ECC200_8
	cpl	rr8, #%00000400
	jr	c, ECC200_9
	cp	ECC_MEM_2, #%0000
	ret	z
	ld	r8, #%0200		!Fehlernummer 200!
	call	MSG_ERROR
	ret	
    end ECC_TEST_200

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE ECC_TEST_201_202
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    ECC_TEST_201_202 procedure
      entry
	call	PR_POWER_UP
	xorb	rh1, rh1
	call	ECC_TEST_UNKNOWN_03
	call	ECC_TEST_UNKNOWN_07
	ldl	rr6, #%00000000
	ldl	MMU_MEM_1, rr6
	ldl	rr6, #%00000000
	ldl	ECC_MEM_1, rr6
ECC202_16:
	ld	REM_MMU_TEST, #%0000
	ld	r7, #%0001
	ld	r6, #%0000
	out	@r7, r6
	ldl	rr12, ECC_MEM_1
	addl	rr12, #%00000100
	ldl	rr10, MMU_MEM_3
	ldl	rr8, MMU_MEM_4
	ld	r3, MMU_MEM_6
ECC202_15:
	cpl	rr10, #%00000000
	jr	z, ECC202_1
	cpl	rr10, rr8
	jr	z, ECC202_1
	srll	rr8, #1
	cpl	rr8, #%00000000
	jr	nz, ECC202_1
	ld	r3, #%0040
ECC202_1:
	cp	MMU_MEM_5, #%0000
	jr	z, ECC202_2
	cp	r3, MMU_MEM_5
	jr	nz, ECC202_2
	srl	r3, #1
	cp	r3, #%0000
	jr	nz, ECC202_2
	cpl	rr10, #%80000000
	jr	z, ECC202_3
	ldl	rr8, #%80000000
	jp	ECC202_2
ECC202_3:
	ldl	rr8, #%40000000
ECC202_2:
	ldl	rr6, MMU_MEM_1
	call	ECC_TEST_UNKNOWN_01
	ld	MMU_MEM_6, r3
	ldl	rr4, MMU_MEM_1
	xor	r4, r10
	xor	r5, r11
	xor	r4, r8
	xor	r5, r9
	xor	r2, MMU_MEM_5
	xor	r3, r2
	ld	r7, #%8000
	ld	r6, #%0000
	call	ECC_TEST_UNKNOWN_05
	ld	r7, #%8000
	ld	r6, #%0000
	call	ECC_TEST_UNKNOWN_06
	call	ECC_TEST_UNKNOWN_08
	call	ECC_TEST_UNKNOWN_07
	ld	r2, ECC_MEM_3
	ld	ECC_MEM_3, #%0000
	cp	r2, #%0004
	jp	nz, ECC202_19
	inc	REM_MMU_TEST, #1
	ld	r7, #%0001
	in	r2, @r7
	and	r2, #%00ff
	cp	r2, #%00ff
	jr	nz, ECC202_4
	cp	REM_MMU_TEST, #%0100
	jr	z, ECC202_5
ECC202_4:
	cp	r2, REM_MMU_TEST
	jp	nz, ECC202_6
ECC202_5:
	ldl	rr6, MMU_MEM_1
	addl	rr6, #%00010001
	ldl	MMU_MEM_1, rr6
	ld	r3, MMU_MEM_5
	ld	r4, MMU_MEM_6
	cpl	rr10, #%00000000
	jr	z, ECC202_7
	cpl	rr10, #%80000000
	jr	z, ECC202_8
	slll	rr10, #1
	jp	ECC202_9
ECC202_8:
	ldl	rr10, #%00000000
	ld	r3, #%0001
	jp	ECC202_9
ECC202_7:
	cp	r3, #%0040
	jr	z, ECC202_10
	sll	r3, #1
	jp	ECC202_9
ECC202_10:
	ld	r3, #%0000
	ldl	rr10, #%00000001
ECC202_9:
	cpl	rr8, #%00000000
	jp	z, ECC202_11
	cpl	rr8, #%00000001
	jr	z, ECC202_12
	srll	rr8, #1
	jp	ECC202_13
ECC202_12:
	ldl	rr8, #%00000000
	ld	r4, #%0040
	jp	ECC202_13
ECC202_11:
	cp	r4, #%0001
	jr	z, ECC202_14
	srl	r4, #1
	jp	ECC202_13
ECC202_14:
	ld	r4, #%0000
	ldl	rr8, #%80000000
ECC202_13:
	ld	MMU_MEM_5, r3
	ld	MMU_MEM_6, r4
	ldl	rr6, ECC_MEM_1
	addl	rr6, #%00000001
	ldl	ECC_MEM_1, rr6
	cpl	rr12, ECC_MEM_1
	jp	c, ECC202_15
	cpl	rr6, #%00000400
	jp	c, ECC202_16
	jp	ECC202_17
ECC202_19:
	ld	r8, #%0201		!Fehlernummer 201!
	jr	ECC202_18
ECC202_6:
	ld	r8, #%0202		!Fehlernummer 202!
ECC202_18:
	call	MSG_ERROR
ECC202_17:
	call	ECC_TEST_UNKNOWN_04
	call	ECC_TEST_UNKNOWN_08
	ret
    end ECC_TEST_201_202

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE POWUP_TEST_UNKNOWN_01
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    POWUP_TEST_UNKNOWN_01 procedure
      entry
	call	PR_POWER_UP
	xorb	rh1, rh1
	ld	ERRPAR_ID, #%00e0
	ld	UKNOW_MEM_1, #%0001
PUTU01_07:
	ld	r7, #%0001
	ld	r6, #%0000
	out	@r7, r6
	ld	r7, UKNOW_MEM_1
	ld	r6, #%0000
	ld	r5, #%8000
	ld	r4, #%0000
	call	POWUP_TEST_UNKNOWN_02
	ld	r12, #%0000
PUTU01_04:
	ld	UKNOW_MEM_2, #%0000
	ld	r8, #RAM_ANF
	ldl	rr4, LISTE_3(r12)
	ld	r7, UKNOW_MEM_2
	ld	r6, UKNOW_MEM_1
	exb	rh6, rl6
PUTU01_03:
	ldctl	r9, fcw
	set	r9, #15
	ldctl	fcw, r9
	ld	@r6, r4
	add	r7, #%0002
	ld	@r6, r5
	res	r9, #15
	ldctl	fcw, r9
	inc	r7, #2
	djnz	r8, PUTU01_03
	ld	r8, #RAM_ANF
	ld	r7, UKNOW_MEM_2
PUTU01_05:
	ld	r6, UKNOW_MEM_1
	call	ECC_TEST_UNKNOWN_06
	cpl	rr2, LISTE_3(r12)
	jr	z, PUTU01_01
	bitb	rh1, #7
	jr	z, PUTU01_08
	test	UKNOW_MEM_1
	jp	nz, MMU_JP_EXT_1
	jr	PUTU01_02
PUTU01_08:
	ldl	rr4, #%00000000
	ld	r6, UKNOW_MEM_1
	exb	rh6, rl6
	ld	r7, UKNOW_MEM_2
	ld	r8, #%0203
	call	MSG_ERROR
	pushl	@r15, rr6
	ld	r6, #%0000
	ld	r7, #%0001
	out	@r7, r6
	popl	rr6, @r15
PUTU01_01:
	inc	r7, #4
	djnz	r8, PUTU01_05
	inc	r12, #1
	cp	r12, #%0002
	jr	c, PUTU01_04
	ld	r5, UKNOW_MEM_1
	cp	r5, #%0000
	jp	z, PUTU01_02
	cp	r5, MAX_SEGNR
	jr	z, PUTU01_06
	inc	UKNOW_MEM_1, #1
	jp	PUTU01_07
PUTU01_06:
	jp	MMU_JP_EXT_1
	xor	r6, r6
	ld	r3, #S_BNK
	ld	r10, r6
	ld	r12, MAX_SEGNR
	ld	r11, #T_POUPDIAG
	ld	r13, r11
	ld	r9, #MMU_MEM_2
	sub	r9, #T_POUPDIAG
	sc	#SC_SEGV
	ldir	@r12, @r10, r9
	ld	r13, #PUTU01_09
	ld	r11, #MMU_JP_EXT_1
	jp	@r12
PUTU01_09:
	ldctl	r9, FCW		!r9:=Stand FCW!
	res	r9, #%0F
	ldctl	FCW, r9		!nichtsegmentierten Mode einstellen!
!Terminalinterrupts sperren!
	ld	r2, #SIO0C_B	
	ld	r4, #1		!SIO_R1!
	outb	@r2, rl4
	outb	@r2, rh4
	inb	rh2, @r3
	setb	rh2, #0		
	outb	@r3, rh2	!Monitor PROM+RAM ausschalten!
	setb	rh1, #0		!Test in Segment 0!
	ld	UKNOW_MEM_1, #%0000
	push	@r15, r2
	push	@r15, r3
	jp	PUTU01_07
PUTU01_02:
	pop	r3, @r15
	pop	r2, @r15
	inb	rh2, @r3
	resb	rh2, #0
	outb	@r3, rh2	!Monitor PROM+RAM einschalten!
!Empfaengerinterrupts zulassen!
	ld	r2, #SIO0C_B	
	ld	r4, #%011c	!PDAVCT+SAVECT!
	outb	@r2, rh4
	outb	@r2, rl4
	set	r9, #%0F
	ldctl	FCW, r9		!segmentierten Mode einstellen!
	jp	@r10		!RUECKSPRUNG!
    end POWUP_TEST_UNKNOWN_01

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE ECC_TEST_UNKNOWN_01
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    ECC_TEST_UNKNOWN_01 procedure
      entry
	clr	r2
	clr	r5
ECTU01_03:
	ld	r10, r7
	and	r10, #1
	jr	z, ECTU01_01
	xorb	rl2, LISTE_4(r5)
ECTU01_01:
	inc	r5, #1
	cp	r5, #%0020
	jr	z, ECTU01_02
	call	ECC_TEST_UNKNOWN_02
	jr	ECTU01_03
ECTU01_02:
	and	r2, #%007f
	ret
    end ECC_TEST_UNKNOWN_01

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE ECC_TEST_UNKNOWN_02
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    ECC_TEST_UNKNOWN_02 procedure
      entry
	srll	rr6, #1
	ret
    end ECC_TEST_UNKNOWN_02

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE ECC_TEST_UNKNOWN_03
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    ECC_TEST_UNKNOWN_03 procedure
      entry
	ld	ECC_MEM_3, #%0000
	ldctl	r7, psap
	add	r7, #%002e
	ld	r6, @r7
	ld	REM_ERR_CNT, r6
	ld	@r7, #ECC_TEST_UNKNOWN_09
	ret
    end ECC_TEST_UNKNOWN_03

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE ECC_TEST_UNKNOWN_04
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    ECC_TEST_UNKNOWN_04 procedure
      entry
	ldctl	r7, psap
	add	r7, #%002e
	ld	r6, REM_ERR_CNT
	ld	@r7, r6
	ret
    end ECC_TEST_UNKNOWN_04

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE ECC_TEST_UNKNOWN_05
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    ECC_TEST_UNKNOWN_05 procedure
      entry
	exb	rh6, rl6
	out	2, r3
	sc	#SC_SEGV
	ld	@r6, r4
	add	r7, #2
	in	r3, 0
	or	r3, #%80
	out	0, r3
	ld	@r6, r5
	in	r3, 0
	and	r3, #%ff7f
	out	0, r3
	sc	#SC_NSEGV
	ret
    end ECC_TEST_UNKNOWN_05

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE ECC_TEST_UNKNOWN_06
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    ECC_TEST_UNKNOWN_06 procedure
      entry
	exb	rh6, rl6
	sc	#SC_SEGV
	in	r2, 0
	or	r2, #%40
	out	%0000, r2
	ldl	rr2, @r6
	in	r7, 0
	and	r7, #%ffbf
	out	0, r7
	sc	#SC_NSEGV
	ret
    end ECC_TEST_UNKNOWN_06

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE ECC_TEST_UNKNOWN_07
Aktiviert die Paritaetspruefung im S_BNK?
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    ECC_TEST_UNKNOWN_07 procedure
      entry
	inb	rl2, S_BNK
	orb	rl2, #8
	outb	S_BNK, rl2
	in	r2, 0
	or	r2, #%20
	out	0, r2
	ret
    end ECC_TEST_UNKNOWN_07

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE ECC_TEST_UNKNOWN_08
Deaktiviert die Paritaetspruefung im S_BNK?
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    ECC_TEST_UNKNOWN_08 procedure
      entry
	inb	rl2, S_BNK
	andb	rl2, #%f7
	outb	S_BNK, rl2
	in	r2, 0
	and	r2, #%ffdf
	out	0, r2
	ret
    end ECC_TEST_UNKNOWN_08

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE ECC_TEST_UNKNOWN_09
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    ECC_TEST_UNKNOWN_09 procedure
      entry
	ld	r2, @r15
	and	r2, #7
	cp	r2, #4
	jr	nz, ECTU08_01
	ld	ECC_MEM_3, r2
ECTU08_01:
	sc	#SC_SEGV
	iret
    end ECC_TEST_UNKNOWN_09

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE UNKNOWN_01
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    UNKNOWN_01 procedure
      entry
	ld	r2, #%2e
	ld	r3, REM_ERR_CNT
	ld	@r2, r3
	jp	@r3
    end UNKNOWN_01

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE POWUP_TEST_UNKNOWN_02
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    POWUP_TEST_UNKNOWN_02 procedure
      entry
	ex	r6, r7
	exb	rh6, rl6
	ldl	rr2, rr6
	inc	r3, #2
	dec	r5, #1
	ldctl	r9, FCW		!r9:=Stand FCW!
	set	r9, #%0F
	ldctl	FCW, r9		!segmentierten Mode einstellen!
	ld	@r6, r4
	ldir	@r2, @r6, r5
	res	r9, #%0F
	ldctl	FCW, r9		!nichtsegmentierten Mode einstellen!
	ret
    end POWUP_TEST_UNKNOWN_02

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE BY_WO_CMP
Vergleich zweier Byte-Register (rl4, rl5) bzw. zweier Word-Register (r4, r5); 
bei Ungleichheit Fehlermeldung (MSG_ERROR)
Input:	rl4/rl5 bzw. r4/r5 - zu vergleichende Register
	rh1 Bit0=0 - Test nicht in Segment 0
	        =1 - Test in Segment 0 
	    Bit1=0 - Byte-Vergleich (rl4,rl5)
	        =1 - Word-Vergleich (r4,r5)
	r8,r7,r6,ERRPAR_ID - siehe Prozedur MSG_ERROR
	r3, S_BNK
OUTPUT: siehe Prozedur MSG_ERROR (nur bei Abarbeitung von MSG_ERROR)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    BY_WO_CMP procedure
      entry
	bitb	rh1, #%01
	jr	z, BYWO_BY	!Byte-Vergleich!
	cp	r5, r4		!Word-Vergleich!
	ret	z		!kein Fehler!
	jr	BYWO_ERR	!Fehler!
BYWO_BY:
	cpb	rl5, rl4	!Byte-Vergleich!
	ret	z		!kein Fehler!

BYWO_ERR:
	bitb	rh1, #%00	!Test in Segment 0?!
	jr	z, BYWO_OUT	!nein!

	inb	rh2, @r3	!ja!
	resb	rh2, #%00
	outb	@r3, rh2	!Monitor PROM+RAM einschalten!
	call	MSG_ERROR	!Fehlerausgabe!
	inb	rh2, @r3
	setb	rh2, #%00
	outb	@r3, rh2	!Monitor PROM+RAM ausschalten!
	ret
BYWO_OUT:
	call	MSG_ERROR
	ret
    end BY_WO_CMP

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE FAT_ERR
Ausgabe von T_ERR, Fehlerzeile und T_FERR auf Terminal
Input:	siehe Prozedur MSG_ERROR
Output: r2 - Stand Fehlerzaehler (ERR_CNT)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    FAT_ERR procedure
      entry
	call	MSG_ERROR	!Ausgabe T_ERR und Fehlerzeile auf Terminal!

FAT_ERR1:
	ld	r2, #T_FERR
	sc	#SC_WR_MSG	!Ausgabe T_FERR auf Terminal!
	sc	#SC_WR_OUTBFF_CR !Ausgabe CR auf Terminal!
	ld	r2, ERR_CNT
	ret
    end FAT_ERR

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE PR_POWER_UP
Vorbereitung der Ausgabe der Meldung "POWER UP DIAGNOSTICS" Zeichen um Zeichen
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    PR_POWER_UP procedure
      entry
	push    @r15, r2
	ld      r2, POW_UP_TXT
	inc     r2, #1
	ldb     rl1, #%01
	cpb     @r2, #%20
	jr      nz, PRPOUP_PRT
	incb    rl1, #1
PRPOUP_PRT:
	call    DO_PR_POWER_UP
	pop     r2, @r15
	ret     
    end PR_POWER_UP

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE DO_PR_POWER_UP
Ausgabe der Meldung "POWER UP DIAGNOSTICS" Zeichen um Zeichen
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    DO_PR_POWER_UP procedure
      entry
	pushl   @r15, rr0
	pushl   @r15, rr2
	ld      r2, POW_UP_TXT
DPPUP_1:
	ldb     rl0, @r2
	sc      #SC_TYWR
	inc     r2, #1
	dbjnz   rl1, DPPUP_1
	ld      POW_UP_TXT, r2
	ld      PRT_POW_UP_TXT, #%0000
	popl    rr2, @r15
	popl    rr0, @r15
	ret     
    end DO_PR_POWER_UP

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE MSG_ERROR
Ausgabe T_ERR und Fehlerzeile (Fehlernummer und max. 4 Parameter) auf Terminal
Input:	r8 - Fehlernummer
	r6 - 1. Parameter der Fehlerzeile
	r7 - 2. Parameter der Fehlerzeile
	r5 - 3. Parameter der Fehlerzeile
	r4 - 4. Parameter der Fehlerzeile
	ERRPAR_ID - Spezifizierung, als was die 4 Fehlerparameter auszugeben
	            sind:
 		    Bit 7,6 (ERRPAR_ID) fuer Parameter 1 (r6)
		    Bit 5,4 (ERRPAR_ID) fuer Parameter 2 (r7)
		    Bit 3,2 (ERRPAR_ID) fuer Parameter 3 (r5)
		    Bit 1,0 (ERRPAR_ID) fuer Parameter 4 (r4)
		    mit
		    Bit x,x = 00 --> Parameter ist nicht auszugeben
		    Bit x,x = 01 --> Ausgabe des rl-Reg. des Parameters
		    Bit x,x = 10 --> Ausgabe des r-Reg. des Parameters
		    Bit x,x = 11 --> Ausgabe des rh-Reg. des Parameters als
				     Segmentnummer ('<yy>')
Output:	ERR_CNT - Fehlerzaehler wurde incr., wenn Bit2(rh1)=0 war
	Bit2(rh1) := 0
	Bit6(rh1) := 1 
	Bit7(rh1) := 1 , wenn Bit6(rh1) vorher =1 war
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    MSG_ERROR procedure
      entry
	ldm	RG_FELD, r0, #%0F	!Registerinhalte r0-r14 retten!

	push	@r15, r4	!4. Parameter!
	push	@r15, r5	!3. Parameter!
	push	@r15, r7	!2. Parameter!
	push	@r15, r6	!1. Parameter!
	push	@r15, r8	!Fehlernummer!

	test	PRT_POW_UP_TXT
	jr	nz, MSERR1
	sc	#SC_WR_CRLF
MSERR1:
	ld	PRT_POW_UP_TXT, #%ffff
	ld	r2, #T_ERR
	sc	#SC_WR_MSG
	pop	r5, @r15
	sc	#SC_BTOH16

	ldb	rl1, #' '
	sc	#SC_PUT_CHR	!Space in OUTBFF eintragen!

	ld	r7, ERRPAR_ID	!rl7 := Parameter-Identifier fuer Fehlerzeile!	
	ld	r6, #%0004	!r6 := Anzahl der Parameter (=4)!
MSER2:
	xorb	rh7, rh7	!rh7 loeschen!
	rl	r7, #%02	!Parameter-Identifier fuer betrachteten
				 Parameter in rh7 schieben (Bit 0,1)!
	pop	r5, @r15	!r5 := betrachteter Parameter!	
	cpb	rh7, #%01	!Parameter-Identifier = 1 ?!
	jr	nz, MSER3	!nein!

	sc	#SC_BTOH8	!ja --> rl-Reg. des Par. in OUTBFF eintr.!
	jr	MSER5		!naechster Parameter!

MSER3:
	cpb	rh7, #%02	!Parameter-Identifier = 2 ?!
	jr	nz, MSER4	!nein!

	sc	#SC_BTOH16	!ja --> r-Reg. des Par. in OUTBFF eintr.!
	jr	MSER5		!naechster Parameter!

MSER4:
	cpb	rh7, #%03	!Parameter-Identifier = 3 ?!
	jr	nz, MSER5	!nein --> Parameter nicht ausgeben!

	ldb	rl5, rh5	!ja --> rh-Reg. des Parameters als!
	sc	#SC_PUT_SEGNR	!Segmentnummer in OUTBFF eintragen!

MSER5:
	ldb	rl1, #' '
	sc	#SC_PUT_CHR	!Space in OUTBFF eintragen!
	djnz	r6, MSER2	!naechster Parameter!

	sc	#SC_WR_OUTBFF_CR !Ausgabe Inhalt OUTBFF mit CR auf Terminal!
	ldm	r0, RG_FELD, #%0F	!gerettete Registerinhalte r0-r14
					 zurueckspeichern!	

	bitb	rh1, #%02
	jr	nz, LB_2286
	inc	ERR_CNT, #%01	!Fehlerzaehler incr!
LB_2286:
	resb	rh1, #%02

	bitb	rh1, #%06
	jr	z, MSER6
	setb	rh1, #%07	!SET Bit7(rh1), wenn Bit6(rh1)=1!
MSER6:
	setb	rh1, #%06	!SET Bit6(rh1)!
	ret	
    end MSG_ERROR

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE MSG_MAXSEG
Ausgabe  T_SEG/NSEG, TJUM, T_MAXS und hoechste Segmentnummer auf Terminal
Output: r2 - Stand Fehlerzaehler (ERR_CNT)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    MSG_MAXSEG procedure
      entry
	sc	#SC_WR_CRLF
	sc	#SC_WR_CRLF
	ld	r2, #T_ACTPERIP	!Textausgabe 'ACTIVE PERIPHERALS' !
	sc	#SC_WR_MSG
	sc	#SC_WR_OUTBFF_CR

	ld	REM_MMU_ID,#1
	xor	r1, r1
	ldb	rl1, ABOOT_DEV
	cpb	rl1, #0
	jr	nz, MSG_BOOTDEV

	ldb	rl1, #1
	ld	r2, #T_INVSWITC	!Textausgabe '** INVALID SWITCH CODE **' !
	sc	#SC_WR_MSG
	sc	#SC_WR_OUTBFF_CR
	jr	MSG_NO_BOOTDEV
MSG_BOOTDEV:
	ld	r2, PSA_NMI+6
	cp	r2, #AUTOBOOT	
	jr	z, MSG_MAXSEG01
MSG_NO_BOOTDEV:
	clr	REM_MMU_ID
MSG_MAXSEG01:
	dec	r1, #1
	ld	r0, #3
MSG_MAXSEG03:
	pushl	@r15, rr0
	sll	r1, #1
	ld	r8, LISTE_DISK_TESTS(r1)
	call	@r8
	popl	rr0, @r15
	inc	r1, #1
	cp	r1, #3
	jr	nz, MSG_MAXSEG02
	xor	r1, r1
MSG_MAXSEG02:
	djnz	r0, MSG_MAXSEG03
	call	TCC_TEST
	test	REM_MMU_TEST
	jr	z, MSG_MAXSEG04

	ld	r2, #T_ECC	!Textausgabe 'ECC' !
	sc	#SC_WR_MSG
	sc	#SC_WR_OUTBFF_CR

MSG_MAXSEG04:
	call	SSB_TEST
	call	ICP_TEST
	call	MTC_TEST
	call	FPP_TEST

	sc	#SC_WR_CRLF
	ld	r2, #T_COMPLETE	!Textausgabe 'COMPLETE' !
	sc	#SC_WR_MSG
	sc	#SC_WR_OUTBFF_CR

	ld	r2, #T_NONSEGM	!Textausgabe 'NON-SEGMENTED' !
	test	REM_MMU1
	jr	z, MSG_NON_SEG
	ld	r2, #T_SEGM	!Textausgabe 'SEGMENTED' !
MSG_NON_SEG:
	sc	#SC_WR_MSG

	ld	r2, #T_JUMPERS	!Textausgabe 'JUMPERS' !
	sc	#SC_WR_MSG
	sc	#SC_WR_OUTBFF_CR

	ld	r2, #T_MAXS
	sc	#SC_WR_MSG	!Ausgabe Text T_MAXS auf Terminal!
	ldb	rl5, MAX_SEGNR
	sc	#SC_PUT_SEGNR	!hoechste Segmentnr. in OUTBFF eintragen!
	sc	#SC_WR_OUTBFF_CR !Ausgabe der hoechsten Segmentnummer auf
				  Terminal (mit CR)!

	ld	r2, ERR_CNT	!r2 := Stand Fehlerzaehler!
	ret	
    end MSG_MAXSEG

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE PRIVINSTR_TRAP
Trap-Routine bei Priv.-Instr.-Trap
Umschaltung auf Systemmode
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    PRIVINSTR_TRAP procedure
      entry
	set	%02(r15), #%0E
	sc	#SC_SEGV
	iret
    end PRIVINSTR_TRAP

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE SEGMENT_TRAP
Trap-Routine bei Segment-Trap
Output:	REM_MMU_BCSR - Inhalt Bus-Cycle-Status-Register (BCSR) der MMU bzw. 
						0 bei Fehler
	REM_MMU_VTR  - Inhalt Violation-Type-Register (VTR) der MMU bzw.
						0 bei Fehler
	REM_MMU_ID   - MMU_ID (1:CODE-MMU; 2:DATA-MMU; 3:STACK-MMU) bzw.
						High-Teil=%FF bei Fehler
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    SEGMENT_TRAP procedure
      entry
	pushl	@r15, rr2
	ld	r2, 4(r15)
	exb	rl2, rh2
	and	r2, #%0007	!rl2=MMU_ID!

	cpb	rl2, #%01
	jr	z, TRAP_CODE	!Trap durch CODE-MMU ausgeloest!
	cpb	rl2, #%02
	jr	z, TRAP_DATA	!Trap durch DATA-MMU ausgeloest!
	cpb	rl2, #%04
	jr	z, TRAP_STACK	!Trap durch STACK-MMU ausgeloest!
!Fehler: falscher MMU_ID!
	ldb	rh2, #%FF	!High-Teil von REM_MMU_ID auf %FF setzen!
	xor	r3, r3		!REM_MMU_BCSR/REM_MMU_VTR auf %00 setzen!
	jr	TRAP_OUT

TRAP_CODE:
	sinb	rl3, CODE_MMU + %0200	!Read VTR!
	sinb	rh3, CODE_MMU + %0500	!Read BCSR!
	jr	TRAP_OUT

TRAP_DATA:
	sinb	rl3, DATA_MMU + %0200	!Read VTR!
	sinb	rh3, DATA_MMU + %0500	!Read BCSR!
	jr	TRAP_OUT

TRAP_STACK:
	sinb	rl3, STACK_MMU + %0200	!Read VTR!
	sinb	rh3, STACK_MMU + %0500	!Read BCSR!

TRAP_OUT:
	ld	REM_MMU_ID, r2	!Trap-Werte abspeichern!
	ld	REM_MMU_BCSR, r3

	soutb	ALL_MMU + %1100, rl2 	!Reset VTR!

	popl	rr2, @r15
	ldctl	r9, FCW
	set	r9, #%0F	!Segment-Bit im FCW setzen!
	ldctl	FCW, r9
	iret	
    end SEGMENT_TRAP

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE CODE_TRAP
Trap-Routine fuer Segment-Trap fuer Test der CODE-MMU
Input:	rh0 - %00
	r11 - Ruecksprungadresse (FKT_TST)
Output:	REM_MMU_BCSR - Inhalt Bus-Cycle-Status-Register (BCSR) der CODE-MMU
	REM_MMU_VTR  - Inhalt Violation-Type-Register (VTR) der CODE-MMU
	REM_MMU_ID   - %FFFF
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    CODE_TRAP procedure
      entry
	soutb	CODE_MMU, rh0	!Mode-Register der CODE-MMU mit %00 laden
				 (CODE-MMU deaktivieren)!
	outb	S_BNK, rh0	!MMU's ausschalten!
	add	r15, #%0009
	push	@r15, r2
	sinb	rl2, CODE_MMU + %0200	!Read VTR!
	sinb	rh2, CODE_MMU + %0500	!Read BSCR!
	ld	REM_MMU_BCSR, r2
	ld	REM_MMU_ID, #%FFFF
	soutb	CODE_MMU + %1100, rl2	!Reset VTR!
	ld	r2, #%5000
	ldctl	FCW, r2		!FCW setzen (nonseg./Systemmode/VI=EI/NVI=DI)!
	pop	r2, @r15
	jp	@r11		!Sprung zu FKT_TST!
    end CODE_TRAP

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE CLR_CTL_REG
Beschreiben der 2 Control-Register SAR (Segment-Adress-Register) und
DSCR (Descriptor-Selector-Counter-Register)
Input:	rl7 - Wert fuer SAR
	rh7 - Wert fuer DSCR
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    CLR_CTL_REG procedure
      entry
	soutb	ALL_MMU + %0100, rl7	!Write SAR!
	soutb	ALL_MMU + %2000, rh7	!Write DSCR!
	ret	
    end CLR_CTL_REG


!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE LD_SDR
Fuellen der 64 SDR einer MMU
Input:	r6  - MMU-Adresse
	r11 - Zeiger auf Anfang des Speicherbereiches (%100 Byte lang) mit
	      dessen Inhalt die 64 SDR gefuellt werden sollen
	      (64 SDR * 4 Byte je SDR = %100 Byte)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    LD_SDR procedure
      entry
	ldm	RG_FELD, r0, #%0F
	xor	r7, r7
	call	CLR_CTL_REG	!Loeschen der Control-Register SAR und DSCR!
	add	r6, #%0F00	!Write Descriptor and increment SAR!
	ld	r0, #%0100
	sotirb	@r6, @r11, r0	!alle 64 SDR (zu je 4 Byte) laden!
	xor	r7, r7
	call	CLR_CTL_REG	!Loeschen der Control-Register SAR und DSCR!
	ldm	r0, RG_FELD, #%0F
	ret	
    end LD_SDR

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE RD_SDR
Ruecklesen der 64 SDR einer MMU und Vergleich mit urspruenglich geladener SDR
ggf. Fehler 80 bzw. 82
Input:	r6  - MMU-Adresse
	r11 - Zeiger auf Anfang des Speicherbereiches, mit dessen Inhalt die
	      64 SDR gefuellt wurden
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    RD_SDR procedure
      entry
	pushl	@r15, rr2
	push	@r15, r11
	ld	ERRPAR_ID, #%0095 !Fehlerparameter fuer Fehler 80,81,82:
							r6, rl7, rl5, rl4!
	xorb	rh1, rh1	!Flagbyte rh1 loeschen!
	add	r6, #%0F00	!Read Descriptor and increment SAR!
	ld	r10, #%A400	!Anfangsadresse Puffer fuer rueckgelesene SDR!
	ld	r0, #%0100
	sinirb	@r10, @r6, r0	!64 SDR der MMU zuruecklesen!

	ld	r10, #%A400
	ld	r0, #%0100
	cpsirb	@r11, @r10, r0, nz !Vergleich!
				   !Befehl cpsirb wird beendet, bei Ungleich-
				    heit von @r11/@10 bzw. wenn Bytezahl r0
				    abgearbeitet ist!
	dec	r10, #%01
	dec	r11, #%01
	ldb	rl4, @r10	!rl4=Fehlerpar. (zurueckgelesener Datenwert)!
	ldb	rl5, @r11	!rl5=Fehlerpar. (Testdatenwert)!
	sub	r10, #%A400
	ld	r7, r10		!rl7=Fehlerpar. (SDR FELD#)!
	sub	r6, #%0F00	!r6=Fehlerpar. (MMU PORT#)!
	call	BY_WO_CMP	!Vergleich rl5/rl4; ggf. Fehler 80 bzw. 82!
	pop	r11, @r15
	popl	rr2, @r15
	ret	
    end RD_SDR

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE LD_3SDR
Fuellen der 64 SDR (zu je 4 Byte) der CODE-, DATA- und STACK-MMU
Input:	r3 - Zeiger auf Anfangsadresse des Speicherbereiches (4 Byte), mit
	     dessen Inhalt die 64 SDR der CODE-MMU gefuellt werden sollen
	r4 - Zeiger auf Anfangsadresse des Speicherbereiches (4 Byte), mit
	     dessen Inhalt die 64 SDR der DATA-MMU gefuellt werden sollen
	r5 - Zeiger auf Anfangsadresse des Speicherbereiches (4 Byte), mit
	     dessen Inhalt die 64 SDR der STACK-MMU gefuellt werden sollen
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    LD_3SDR procedure
      entry
	ldm	RG_FELD, r0, #%0F
	xor	r7, r7
	call	CLR_CTL_REG	!Loeschen der Control-Register SAR und DSCR!
	ldb	rl0, #%40		!Anzahl der SDR (64)!
	ld	r9, #CODE_MMU + %0F00	!Write Descriptor and increment SAR!
	ld	r10, #DATA_MMU + %0F00 	!Write Descriptor and increment SAR!
	ld	r11, #STACK_MMU + %0F00	!Write Descriptor and increment SAR!
LD_3LOOP:
	ld	r2, #4			!Descriptorlaenge (4 Byte je SDR)!
	sotirb	@r9, @r3, r2		!SDR CODE_MMU programmieren!
	dec	r3, #%04		!Zeiger auf Anfangsadr. zurueckstellen!
	ld	r2, #4			!Descriptorlaenge (4 Byte je SDR)!
	sotirb	@r10, @r4, r2		!SDR DATA_MMU programmieren!
	dec	r4, #%04		!Zeiger auf Anfangsadr. zurueckstellen!
	ld	r2, #4			!Descriptorlaenge (4 Byte je SDR)!
	sotirb	@r11, @r5, r2		!SDR STACK_MMU programmieren!
	dec	r5, #%04		!Zeiger auf Anfangsadr. zurueckstellen!
	dbjnz	rl0, LD_3LOOP		!naechstes SDR!
	call	CLR_CTL_REG	!Loeschen der Control-Register SAR und DSCR!
	ldm	r0, RG_FELD, #%0F
	ret	
    end LD_3SDR

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE SEGMENT_TRAP_TEST
Test, ob beim Beschreiben der Offsetadresse (r3) in jedem Segment ein Trap
ausgeloest wird
Input:	r3  - Offsetadresse fuer Trap-Test (Adresse, die in jedem Segment
	      beschrieben werden soll)
	rh0 - MMU_ID fuer MMU, die Trap ausloesen muss (2:DATA-MMU;4:STACK-MMU)
	      bzw. rh0=0, wenn kein Segment-Trap erwartet wird
	rl4 - ???
Fehler 85, wenn
- Segment-Trap nicht von der erwarteten MMU ausgeloest wurde (bei rh0=2,4)
- Segment-Trap ausgeloest wurde, obwohl nicht erwartet (bei rh0=0)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    SEGMENT_TRAP_TEST procedure
      entry
	pushl	@r15, rr2
	push	@r15, r9
	xorb	rh1, rh1	!Flagbyte rh1 loeschen!
	xor	r2, r2		!rh2=logische Segmentnummer (0-63)!
	test	REM_MMU1
	jr	z, L1ABE
	ldb	rh2, #%02
	bitb	rl4, #%01
	jr	z, L1ABE
	ldb	rh2, #%42
L1ABE:

	ld	ERRPAR_ID, #%0050 !Fehlerparameter fuer Fehler 85: rl6, rl7!
	ld	REM_MMU_ID, #%0000 !Merker: MMU-ID loeschen -
				    wird bei Segment-Trap gesetzt!
	ldb	rl0, #%02
	test	REM_MMU1
	jr	z, LB_24F8
	ldb	rl0, #%06
	outb	S_BNK, rl0
	xorb	rh4, rh4
	bitb	rl4, #%01
	jr	z, LB_24D0
	soutb	STACK_MMU, rl4
	ldb	rh4, #%80
	soutb	CODE_MMU, rh4
	ldb	rh4, #%81
	soutb	DATA_MMU, rh4
	jr	LB_250E
LB_24D0:
	bitb	rl4, #%00
	jr	z, LB_24E6
	soutb	DATA_MMU, rl4
	ldb	rh4, #%80
	soutb	CODE_MMU, rh4
	ldb	rh4, #%82
	soutb	STACK_MMU, rh4
	jr	LB_250E
LB_24E6:
	soutb	CODE_MMU, rl4
	ldb	rh4, #%81
	soutb	DATA_MMU, rh4
	ldb	rh4, #%82
	soutb	STACK_MMU, rh4
	jr	LB_250E
LB_24F8:
	outb	S_BNK, rl0	!MMU's einschalten!

	ldb	rl0, #%D0
	soutb	CODE_MMU, rl0	!Mode-Register mit %D0 laden (ID=0), d.h.
				 CODE-MMU aktivieren!
	incb	rl0, #%01
	soutb	DATA_MMU, rl0	!Mode-Register mit %D1 laden (ID=1), d.h.
				 DATA-MMU aktivieren!
	incb	rl0, #%01
	soutb	STACK_MMU, rl0	!Mode-Register mit %D2 laden (ID=2), d.h.
				 STACK-MMU aktivieren!

LB_250E:
	ldctl	r9, FCW
	set	r9, #%0F
	test	REM_MMU2
	jr	z, LB_251A
	res	r9, #%0E
LB_251A:
	ldctl	FCW, r9
	ld	@r2, r5		!Speicherzelle (Segment r2 / Offset r3)
				 beschreiben!
	mbit
	sc	#SC_NSEGV

	xorb	rl0, rl0
	soutb	ALL_MMU, rl0	!MMU's deaktivieren!
	outb	S_BNK, rl0	!MMU's ausschalten!

	ld	r6, REM_MMU_ID	!rl6=Fehlerpar. (MMU ID#)!
	testb	rh6	
	jr	nz, L1B12	!Fehler 85 mit Fehlerpar. rl6, rl7:
				 Segment-Trap mit falschem MMU_ID aufgetreten
				 (nicht 1,2,4 - siehe SEGMENT_TRAP)!
	cpb	rh0, rl6	!Vergleich MMU_ID des Segment-Traps mit dem
				 erwarteten MMU_ID!
	jr	nz, SEGTRT_01	!Fehler 85 mit Fehlerpar. rl6, rl7, r5:
				 Segment-Trap erfolgte nicht mit erwarteten
				 MMU_ID (bei rh0=2,4)
				 bzw.
				 Segment-Trap aufgetreten, obwohl keiner
				 auftreten durfte (bei rh0=0)!
L1AFE:

	incb	rh2, #%01
	test	REM_MMU1
	jr	z, LB_254C
	bitb	rl4, #%01
	jr	z, LB_254C
	cpb	rh2, #%80
	jr	nz, L1ABE
	jr	L1B1C
LB_254C:
	cpb	rh2, #%40
	jr	nz, L1ABE	!naechste logische Segmentnummer!
	jr	L1B1C		!alle Segmentnummern abgearbeitet,d.h. Ende!

!Fehlereinsprung!
SEGTRT_01:
	ld	ERRPAR_ID, #%0058
	ld	r5, REM_MMU_BCSR
L1B12:
	ldb	rl7, rh2	!rl7=Fehlerpar. (SDR#)!
	call	MSG_ERROR	!Fehlerausgabe!
	bitb	rh1, #%07	!MSG_ERROR seit dem letzen Loeschen von rh1
				 (am Anfang dieser Prozedur) bereits zweimal
				 durchlaufen? !
	jr	z, L1AFE	!nein, d.h. naechste logische Segmentnummer!

L1B1C:
	pop	r9, @r15
	popl	rr2, @r15
	ret	
    end SEGMENT_TRAP_TEST

end p_testram
