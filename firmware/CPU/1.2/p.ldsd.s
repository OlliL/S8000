!******************************************************************************
*******************************************************************************

  S8000-Firmware
  Z8000-Softwaremonitor (CPU)        Modul: p_ldsd

  Bearbeiter:	O. Lehmann
  Datum:	14.01.2016
  Version:	1.2

*******************************************************************************
******************************************************************************!

p_ldsd module

$SECTION PROM

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
System Calls
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!

  CONSTANT
SC_SEGV			:= %01
SC_NSEGV		:= %02

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
spezielle ASCII-Zeichen
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!

  CONSTANT
LF	:= %0A
CR	:= %0D

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Hardwareadressen
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!

  CONSTANT
SIO0	:= %FF81
SIO0D_A	:= SIO0 + 0
SIO0D_B	:= SIO0 + 2
SIO0C_A	:= SIO0 + 4
SIO0C_B	:= SIO0 + 6

CTC0	:= %FFA1
CTC0_0	:= CTC0 + 0	! Baud 0 - SIO0, Kanal 0!
CTC0_1	:= CTC0 + 2	! Baud 1 - SIO0, Kanal 1!
CTC0_2	:= CTC0 + 4 	! Baud 2 - SIO1, Kanal 2!
CTC0_3	:= CTC0 + 6	! Next !

RETI_P	:= %FFE1	!RETI-Port fuer Schaltkreise des Z80-Systems!


  INTERNAL

BAD_DATA
	WORD := %0009
	ARRAY [9 BYTE] := 'BAD DATA%0D'

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE GO
GO-Routine (Monitorkommando)
Programmabarbeitung bei eingegebener Ansprungadresse bzw. beim
aktuellen PC-Stand starten

Kommandoeingabe: GO [<segnr>offset]
                   (Ansprungadresse)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    GO procedure
      entry
	call	GET_SIGN	!rl0:=1.Zeichen ungleich Space nach naechstem
				 Space im Eingabepuffer INBFF!
	jp	z, ERROR	!keine Ansprungadresse vorhanden!

	call	GET_ADR		!rr2:=Ansprungadresse!
	res	r3, #%00	!Adresse muss gerade sein!
	ldl	PC_SEG, rr2	!PC_SEG/PC_OFF := Ansprungadresse!
    end GO			!Weiterlauf in GO_PC!

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE GO_PC
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    GO_PC procedure
      entry
	ldl	rr2, PC_SEG	!rr2:=Startadresse!
	cpl	rr2, B_ADR_S	!=BREAK-Adresse?!
	jr	z, GO_NXT	!ja!

	call	GETREG		!Register laden!
	ldl	rr14, SVSTK
	dec	r15, #8
	sc	#SC_SEGV
	iret			!Programm starten!
    end GO_PC

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE GO_NXT
Abarbeitung des naechsten Befehls, wenn auf diesem Befehl Unterbrechungspunkt
steht
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    GO_NXT procedure
      entry
	ldl	rr2, B_ADR_S	!rr2:=BREAK-Adresse!
	ld	r1, B_WORD	!r1:=urspruenglicher Inhalt der BREAK-Adresse!
	sc	#SC_SEGV
	ld	@r2, r1		!BREAK-Inhalt wird zurueckgeladen, um den
				 Befehl abarbeiten zu koennen!
	sc	#SC_NSEGV
	ld	r2, #GO_INT	!Adresse der VI-Routine:
				 Interrup erfolgt nach Abarbeitung des Befehls;
				 in der GO_INT - Routine wird dann der Unter-
				 brechungspunkt wieder gesetzt!

G2:
	di	vi
	
	ld	VI_CTC0_3+2, r2	!Adresse der VI-Routine eintragen!
	call	GETREG		!REGISTER ZURUECKLADEN!
	ldl	rr14, SVSTK
	dec	r15, #8
	sc	#SC_SEGV
	push	@r14, r1
	ld	r1, r14(#%0004)	!FCW_V AUS DEM STACK LADEN!
	sc	#SC_NSEGV
	ld	FCW_V, r1
	or	r1, #%1000	!VIE BIT IM FCW SETZEN!
	sc	#SC_SEGV
	ld	r14(#%0004), r1
	sc	#SC_NSEGV

!CTC als Zaehler programmieren - Interrupt nach Abarbeitung des kommenden
Befehls im zu testenden Programm!
	CLRB	RL1
	OUTB	CTC0_0, RL1	!Interruptvektor in den CTC laden!
	LDB	RL1, #%C7	!Zaehlermode!
	OUTB	CTC0_3, RL1
	LD	R1, STKCTR	!4 Stackoperationen!
	OUTB	CTC0_3,RL1	!Zeitkonstante!

	ldctl	r1, FCW
	set	r1, #%0F	!SEG BIT IM FCW SETZEN!
	ldctl	FCW, r1
	
	pop	r1, @r14
	iret			!Programmstart!
    end GO_NXT

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE NEXT
NEXT-Routine (Monitorkommando)
Abarbeitung einer bestimmten Anzahl von Befehlen

Kommandoeingabe: N [count]
                   (Anzahl der Befehle (implizit %1))
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    NEXT procedure
      entry
	setb	FLAG1, #%02	!Next-Betrieb!
				!dient in Kommandoeingabeschleife zur Kenn-
				 zeichnung, ob letztes Kommando NEXT-Kommando
				 war; wenn ja, kann Next-Kommando durch
				 Eingabe von nur CR wiederholt werden!

	call	GET_SIGN	!rl0:=1. Zeichen ungleich Space nach dem
				 naechsten Space im Eingabepuffer INBFF!
	jr	z, N1		!keine Anzahl eingegeben!
	
	call	GET_HEXZ	!r3:=Anzahl der Befehle!	
	test	r3
	jr	nz, N2		!ungleich 0!

N1:
	LDK	R3, #1		!implizit Einzelschrittbetrieb, wenn keine
				 Anzahl bzw. Anzahl=0 eingegeben wurde!
N2:
	ld	NXTCTR, r3	!Befehlszaehler!
N3:
	ld	r2, #NXT_INT	!Adresse der VI-Routine!
				!Interrupt erfolgt nach Abarbeitung des
				 naechsten Befehls des zu testenden Programms!
	ldl	rr4, B_ADR_S	!rr4:=BREAK-Adresse!
	cpl	rr4, PC_SEG	!=Adresse des naechsten Befehls?!	
	jr	nz, G2		!nein!

	ld	r1, B_WORD
	sc	#SC_SEGV
	ld	@r4, r1		!ehemaligen Inhalt der BREAK-Adresse zurueck-
				 laden, um Befehl abarbeiten zu koennen
				 (Unterbrechungspunkt wird nach Abarbeitung des
				 Befehls in VI-Routine NXT_INT wieder gesetzt)!
	sc	#SC_NSEGV
	jr	G2
    end NEXT

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE QUIT
QUIT-Routine "MCZ" (Monitorkommando)
Uebergang vom Monitor-Mode in Transparent-Mode, d.h. in das Betriebssystem des
MCZ (P8000-Terminal arbeitet dann als Terminal fuer dss MCZ)

Kommandoeingabe: QUIT
- im Eingabepuffer PTYBFF (Terminal) eingehende Zeichen werden an das MCZ
  gesendet
- vom MCZ eingehende Zeichen werden auf dem Terminal ausgegeben
Verlassen der Routine ueber NMI-Taste
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    QUIT procedure
      entry
	clr	INPTR_MCZ	!Loeschen Eingabezeiger MCZBFF!
	clr	OUTPTR_MCZ	!Loeschen Ausgabezeiger MCZBFF!
	setb	FLAG0, #%00	!kein Ruecksetzen Bit 7 bei den vom Terminal
				 bzw. vom MCZ eingehenden Zeichen (PTYINT bzw.
				 MCZINT) - (keine ASCII-Zeichen)!
Q1:
	testb	COUNT_PTY	!Zeichen vom Terminal eingegangen?!
	jr	z, Q2		!nein!

	ld	r0, OUTPTR_PTY
	call	INCPTR
	ld	OUTPTR_PTY, r0
	ldb	rl0, PTYBFF(r2)
	decb	COUNT_PTY, #%01
	calr	TYWR_MCZ	!Ausgabe Zeichen an MCZ!
	jr	nz, Q1		!kein CR ausgegeben!
	
Q2:
	ld	r0, OUTPTR_MCZ
	cp	r0, INPTR_MCZ	!Zeichen vom MCZ eingegangen?!
	JR	Z, Q1		!nein!

	call	INCPTR_MCZ
	ld	OUTPTR_MCZ, r0	!Ausgabezeiger incr., d.h. Zeichen abgeholt!
	ldb	rl0, MCZBFF(r2)
	call	TYWR		!Ausgabe Zeichen an Terminal!
	jr	Q2
    end QUIT

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE BREAK
BREAKPOINT-Routine (Monitorkommando)
Setzen bzw. Loeschen eines Unterbrechungspunktes

Kommandoeingabe: B [<segnr>offset [count]]
                   (BREAK-Adresse Schleifenanzahl)
(wird kein Parameter angegeben, wird Unterbrechungspunkt geloescht)
Fehler, wenn Unterbrechungspunkt nicht im RAM liegt
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    BREAK procedure
      entry
	ldl	rr2, B_ADR_S	!rr2:=BREAK-Adresse!
	ld	r1, B_WORD	!r1:=urspruenglicher Inhalt auf BREAK-Adresse!
	sc	#SC_SEGV
	ld	@r2, r1		!BREAK_WORD ZURUECKLADEN!
	sc	#SC_NSEGV

	clr	B_ADR_S		!BREAK-Adresse loeschen!
	clr	B_ADR_O
	clr	B_WORD

	ld	NXTCTR, #1	!IMPLIZIT 1 ALS Schleifenzaehler FESTLEGEN!
	call	GET_SIGN	!rl0:=1. Zeichen ungleich Space nach 
				 naechstem Space im Eingabepuffer INBFF!
	RET	Z		!RUECKSPRUNG WENN kein Parameter angegeben!

	call	GET_ADR		!rr2 := BREAK_ADRESSE !
	ldl	rr4, rr2
	jr	z, BR1		!Schleifenzaehler NICHT ANGEGEBEN!

	call	GET_HEXZ	!r3:=Schleifenanzahl!
	test	r3
	jr	z, BR1		!angegebene Schleifenanzahl=0!

	ld	NXTCTR, r3	!eingegebene Schleifenanzahl in Schleifen-
				 zaehler NXTCTR laden!

BR1:
	ldl	rr2, rr4
	res	r3, #%00	!rr2:=gerade BREAK-Adresse!
	ldl	B_ADR_S, rr2	!BREAK_ADRESSE RETTEN!
	ld	r1, B_CODE	!Unterbrechungscode!
	sc	#SC_SEGV
	ex	r1, @r2		!r1:=Inhalt auf der BREAK-Adresse;
				 BREAK-Adresse mit Unterbrechungscode laden!
	ld	r4, r1
	ld	r1, @r2
	sc	#SC_NSEGV
	ld	B_WORD, r4	!urspruenglichen Inhalt auf BREAK-Adr. retten!
	cp	r1, B_CODE	!wurde Unterbrechungscode auf BREAK-Adresse
				 eingetragen, d.h. liegt BREAK-Adr. im RAM?!
	ret	z		!ja!
	
	ld	NXTCTR, #1
	clr	B_ADR_S		!BREAK-Adresse loeschen!
	clr	B_ADR_O
	clr	B_WORD
	jp	ERROR		!BREAK-Adresse liegt nicht im RAM!
    end BREAK

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE TYWR_MCZ
Ausgabe eines Zeichens an das MCZ
Input:	rl0 - auszugebendes Zeichen
Output:	Z=1, wenn Zeichen = CR
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    TYWR_MCZ procedure
      entry
	INB	RH0, SIO0C_A
	bitb	rh0, #%02	!TRANSMIT BUFFER EMPTY ? !
	jr	z, TYWR_MCZ	!NO, WAIT!
	OUTB	SIO0D_A, RL0	!AUSGABE DES ZEICHENS!
	cpb	rl0, #CR
	ret	
    end TYWR_MCZ

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE IN_POI_IB
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    IN_POI_IB procedure
      entry
	clr	INPTR_MCZ
	clr	OUTPTR_MCZ
	call	GET_SIGN
    end IN_POI_IB		!Weiterlauf bei EKBL!

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE EKBL
Eingabekonvertierung eines LOAD-Blockes
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    EKBL procedure
      entry
	clr	r2
	ldb	rh3, #%03
	calr	EKTB_PST
	ret	c
	ldb	KONV, rl3
	testb	rh3
	ret	z
	push	@r15, r3
	calr	EKTB_PST
	pop	r3, @r15
	ret	
    end EKBL

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE EKTB_PST
Eingabekonvertierung eines LOAD-Teilblockes mit Pruefsummentest
Input:	r2 - Zeiger auf aktuelles Zeichen in INBFF
	rh3 - Anzahl der einzulesenden Bytes aus INBFF (jedes Byte ist in INBFF
	      durch 2 ASCII-Zeichen kodiert (z.B. 'A','F' fuer %AF)
	(nach der angegebenen Bytezahl muss die Pruefsumme (1 Byte = 2 ASCII-
	Zeichen) in INBFF stehen
Output: rl3 - Pruefsumme 
	rh3 - letztes Byte der angeg. Anzahl (Byte vor Pruefsumme)
	C=1, wenn keine Hexaziffer in INBFF bzw. falsche Pruefsumme
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    EKTB_PST procedure
      entry
	clrb	rl3		!Pruefsumme loeschen!
EKTB1:
	calr	EKBY_PSB	!rl0:=eingelesenes Byte aus INBFF!
				!rl3:=aktuelle Pruefsumme!
	ret	c		!Fehler: keine Hexaziffer!
	dbjnz	rh3, EKTB1	!naechstes Byte einlesen!

	ldb	rh3, rl0	!rh3:=letztes Byte der angeg. Anzahl!
	push	@r15, r3
	calr	EKBY_PSB	!rl0:=aus INBFF eingelesene Pruefsumme!
	pop	r3, @r15	!r3:=berechnete Pruefsumme!
	ret	c		!Fehler: keine Hexaziffer!

	cpb	rl0, rl3	!Pruefsummenvergleich!
	ret	z		!i.O.!

	setflg	c		!C=1, da Pruefsummenfehler!
	ret	
    end EKTB_PST

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE EKBY_PSB
Eingabekonvertierung eines Bytes aus INBFF mit Pruefsummenberechnung
(in INBFF stehen die Datenbytes ASCII-kodiert, d.h. 1 Byte beansprucht
2 ASCII-Zeichen (z.B. 'A','F' fuer 'AF'))
Input:	r2 - Zeiger auf aktuelles Zeichen in INBFF
	rl3 - aktueller Stand der Pruefsumme
Output:	rl0 - eingelesenes Byte (binaer, =2 ASCII-Zeichen aus INBFF)
        rl3 - neue Pruefsumme
	r2  - neuer Stand des Zeigers auf aktuelles Zeichen in INBFF
	C=1, wenn keine Hexaziffer
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    EKBY_PSB procedure
      entry
	ldb	rl0, INBFF(r2)	!rl0:=1. Hexaziffer (ASCII)!
	inc	r2, #%01
	call	HTOB		!Konv. rl0 (ASCII) --> rl0 (binaer)!
	ret	c		!keine Hexaziffer (Fehler)!

	addb	rl3, rl0	!rl3:=neue Pruefsumme!
	sla	r0, #%0C
	ldb	rl0, INBFF(r2)	!rl0:=2. Hexaziffer (ASCII)!
	inc	r2, #%01
	call	HTOB		!Konv. rl0 (ASCII) --> rl0 (binaer)!
	ret	c		!keine Hexaziffer (Fehler)!

	addb	rl3, rl0	!rl3:=neuer Pruefsumme!
	orb	rl0, rh0	!rl0 := eingelesenes Byte!
	resflg	c
	ret	
    end EKBY_PSB

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE LDB_MEM
Laden des LOAD-Datenblockes in den Speicher
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    LDB_MEM procedure
      entry
	ldb	rl1, rh3
	calr	EKLA
	ld	r2, #%0008
LDB_M_NB:
	calr	EKBY_PSB
	LDB	@R4, RL0
	inc	r4, #%01
	dbjnz	rl1, LDB_M_NB	!LADE NAECHSTES BYTE!
	ret	
    end LDB_MEM

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE EKLA
Eingabekonvertierung der Ladeadresse fuer den LOAD-Datenblock
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    EKLA procedure
      entry
	clr	r2
	calr	EKBY_PSB
	ldb	rh4, rl0
	calr	EKBY_PSB
	ldb	rl4, rl0
	ret	
    end EKLA

  INTERNAL
T_ILA:	WORD := %0019
	ARRAY [* BYTE] := '/INCORRECT LOAD ADDRESS %0D%00'

T_CKE:	WORD := %000D
	ARRAY [* BYTE] := '/CKSUM ERROR%0D%00'

T_FWE:	WORD := %0013
	ARRAY [* BYTE] := '/FILE WRITE ERROR %0D%00'

T_OFE:	WORD := %0011
	ARRAY [* BYTE] := '/OPEN FILE ERROR%0D%00'

T_ABO:	WORD := %0007
	ARRAY [* BYTE] := '/ABORT%0D%00'

T_EPNT:	ARRAY [* BYTE] := 'ENTRY POINT '

T_BRK:	WORD := %0009
	ARRAY [* BYTE] := 'BREAK AT  '

T_NMI:	WORD := %0005
	ARRAY [* BYTE] := 'NMI %0D%00'

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE LOAD
LOAD-Routine "MCZ" (Monitorkommando)
Laden eines U8000-Maschinenprogramms vom MCZ in RAM

Kommandoeingabe: LOAD filename [<segnr>]
	              (Dateiname Segmentnummer)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    LOAD procedure
      entry
	call	IN_POI_IB	!filename uebergehen!
	push	@r15, PC_SEG
	call	GET_SIGN	!rl0:=1.Zeichen ungleich Space nach naechstem
				 Space im Eingaepuffer INBFF
				 (1. Zeichen der segnr)!
	call	GET_SGNR	!r2:=angegebene Segmentnummer!
	ld	PC_SEG, r2
	setb	FLAG0, #%04	!ESC wirkt als Abbruchtaste fuer LOAD!
	call	SAW_MCZ		!eingegebene Kommandozeile an MCZ senden und
				 Antwort abwarten!
	jr	z, LD5		!Abbruch; Fehlerausschrift vom MCZ wurde auf
				 Terminal ausgegeben!

!empfangen eines Datenblockes vom MCZ (in INBFF)!
LD1:
	call	F_IB_MCZ	!INBFF ab empfangenen Zeichen '/' (aus-
                                 schliesslich) von MCZ fuellen!
	ld	r2, #INBFF
	ldb	rl0, @r2
	cpb	rl0, #'/'
	jr	nz, LD2		!erstes Zeichen in INBFF ungleich '/',
				 d.h. keine Fehlermeldung!

!Fehlernachricht von MCZ empfangen ('// error_massage CR')!
	ld	r4, #OUTBFF
	ld	r1, #%007F
	ldir	@r4, @r2, r1	!OUTBFF mit Inhalt von INBFF (Fehlernachricht)
				 fuellen!
	ld	OUTPTR, #%007F
	call	WR_OUTBFF	!Ausgabe OUTBFF auf Terminal / Loeschen OUTBFF!
	jr	LD5		!Abbruch!

LD2:
	bitb	FLAG0, #%05
	jr	nz, LD4		!Abbruchtaste gedrueckt (ESC)!

	call	EKBL
	jr	nc, LD2A
	call	S_RPB
	jr	LD1

LD2A:
	ldb	rl0, #'.'
	call	TYWR
	testb	rh3
	jr	nz, LD3
	call	S_SNB
	call	WR_CRLF
	ldl	rr0, INBFF
	ldl	OUTBFF + 12, rr0
	ld	r4, #T_EPNT
	ld	r2, #OUTBFF
	ld	r1, #%0006
	ldir	@r2, @r4, r1
	ld	OUTPTR, #%0010
	call	WR_OUTBFF_CR
	jr	LD5

LD3:
	call	EKLA
	cp	r4, #%8000	!kleinste LOAD-Adresse in Segment 0
				 (in Vs. 1.7: %4000)!
	jr	nc,  LD3A
	ld	r2, #T_ILA
	jr	LD4A

LD3A:
	call	S_SNB
	call	LDB_MEM
	jr	LD1

LD4:
	ld	r2, #T_ABO
LD4A:
	call	WR_MSG		!AUSGABE : '/ABORT'!
	call	S_LAB
LD5:	POP	PC_SEG, @R15
	ret	
    end LOAD

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE NXT_INT
VI-Routine fuer NEXT
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    NXT_INT procedure
      entry
	ldl	SVSTK, rr14
	ld	r15, #STACK
	ld	SV_R, r0
	calr	SAVREG		!Register retten!
	inc	SVSTK + 2, #8
	calr	RETI_CTC0_3	!Interrupt-Quelle loeschen!
	ldl	rr2, B_ADR_S
	ld	r1, B_CODE
	sc	#SC_SEGV
	ld	@r2, r1		!Unterbrechungspunkt wieder setzen!
	sc	#SC_NSEGV
	bit	FCW_V, #%0C
	jr	nz, N_I
	res	FCW_, #%0C
N_I:				!AUSGABE DER REGISTERBEZEICHNUNGEN UND WERTE!
	call	WR_REGBEZ1
	call	WR_WERTE1
	call	WR_REGBEZ2
	call	WR_WERTE2
	dec	NXTCTR, #1	!DURCHLAUFZAEHLER DEKREMENTIEREN!
	jp	nz, N3		!NAECHSTEN BEFEHL ABARBEITEN!

	ld	NXTCTR, #1	!Einzelschrittbetrieb bei Eingabe von nur CR
				 in Kommandoeingabeschleife!
	ei	vi
	jp	CMDLOP
    end NXT_INT

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE GO_INT
VI-Routine fuer GO
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    GO_INT procedure
      entry
	push	@r15, r2
	push	@r15, r1
	calr	RETI_CTC0_3	!Interruptquelle ausschalten!
	ldl	rr2, B_ADR_S
	ld	r1, B_CODE
	sc	#SC_SEGV
	ld	@r2, r1		!Unterbrechungspunkt wieder setzen!
	sc	#SC_NSEGV
	bit	FCW_V, #%0C
	jr	nz, G_VIE	!VIE BIT GESETZT ? !
	ld	r2, r15(#%6)
	res	r2, #%0C
	ld	r15(#%0006), r2
G_VIE:
	pop	r1, @r15
	pop	r2, @r15
	sc	#SC_SEGV
	iret	
	
    end GO_INT

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE NMI_INT
NMI-Routine
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    NMI_INT procedure		!Routine wird nach dem ersten Tastendruck
				 in PSAREA aktiviert!
      entry
	bitb	FLAG0, #%00
	jr	nz, NMI1	!Bit0/Flag0 gesetzt:--> ruecksetzen
				 (empf. Zeichen ist ASCII-Zeichen)!
	ldl	SVSTK, rr14
	ld	r15, #STACK
	ld	SV_R, r0
	calr	SAVREG		!Register im Rettungsbereich eintragen!
	inc	SVSTK + 2, #8
	jr	NMI2

NMI1:
	resb	FLAG0, #%00	!ruecksetzen!
	ld	r15, #STACK
NMI2:
	ei	vi
	
	call	WR_CRLF		!Ausgabe CR LF an Terminal!
	ld	r2, #T_NMI	!Ausgabe: 'NMI'!
	call	WR_MSG
	jp	CMDLOP
    end NMI_INT

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE SC_ENTRY
SYSTEM-CALL-ENTRY

Bei Aufruf eines Unterprogramms ueber System Call:
Input:	r3 darf keine Eingabewerte fuer das Unterprogramm enthalten
Output: r3 enthaelt Wert von r0 nach Ausfuehrung des Unterprogramms
	   (d.h. evtl. in r0 vom Unterprogramm zurueckgegebene Werte werden
	   bei Aufruf ueber System Call in r3 zurueckgegeben)
zerstoerte Register : r3
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    SC_ENTRY procedure
      entry
	cpb	1(r15), #1	!SC_01 = segmentierte Arbeitsweise!
	jr	nz, SC_02
 
	set	2(r15), #15	!Segment-Bit im FCW setzen!
	iret
	
SC_02:
	cpb	1(r15), #2	!SC_02 = nichtsegmentierte Arbeitsweise!
	jr	nz, SC_X3
	res	2(r15), #15	!Segment-Bit im FCW ruecksetzen!
	iret
	
SC_X3:
	push	@r14, r0
	ldctl	r0, FCW
	res	r0, #%0F
	ldctl	FCW, r0
	pop	r0, @r15
	testb	1(r15)		!SC_00 = BREAK ?!
	jr	nz, NO_BRK
	ld	SV_R, r0
	ldl	SVSTK, rr14
	ld	r15, #STACK
	calr	SAVREG
	inc	SVSTK + 2, #8
	dec	PC_OFF, #%02
	dec	NXTCTR, #%01
	jp	nz, GO_NXT
	ld	NXTCTR, #1
	calr	RETI_CTC0_3
	ei	vi
	
	ld	r2, #T_BRK	!Text: BREAK AT ....!
	call	WR_MSG
	ld	r5, PC_OFF
	call	BTOH16
	call	WR_OUTBFF_CR
	jp	CMDLOP

NO_BRK:
	push	@r15, r0
	ldb	rh0, 3(r15)	!Nummer des SC laden!
	ldb	rl3, rh0
	clrb	rh3
	sub	r3, #4		!SC_04 = 1. Adresse in SC_ADR-Liste!
	ld	r3, SC_ADR(r3)	!Adresse des UP zur Ausfuehrung des SC laden!
	ei	vi
	
	call	@r3		!Aufruf des UP!
	ld	r3, r0
SC_END:
	ldctl	r0, FCW
	
	set	r0, #%0F	!segmentierter Mode einstellen!
	ldctl	FCW, r0
	
	pop	r0, @r14
	iret	
    end SC_ENTRY

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE RETI_CTC0_3
Interruptquelle (CTC0_3) loeschen
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    RETI_CTC0_3 procedure
      entry
	LDB	RL1, #%ED	!U880-RETI (ED4D) ausgeben!
	OUTB	RETI_P, RL1
	LDB	RL1, #%4D
	OUTB	RETI_P, RL1
	LDB	RL1, #%03
	OUTB	CTC0_3, RL1	!CTC-Kanal ruecksetzen!
	ret	
    end RETI_CTC0_3

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE SAVREG
Registerrettung
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    SAVREG procedure
      entry
	ldl	RR14_V, rr14	!ORIGINAL STACKWERTE IN SAV BEREICH UMLADEN!
	ldl	rr14, SVSTK
	ld	r0, r15(#0)	!IDENTIFIER LADEN!
	ld	W23B4, r0
	ld	r0, r15(#%2)	!FCW LADEN!
	ld	FCW_, r0
	ld	r0, r15(#%4)	!SEGMENTADRESSE LADEN!
	ld	PC_SEG, r0
	ld	r0, r15(#%6)	!OFFSET LADEN!
	ld	PC_OFF, r0
	sc	#SC_SEGV
	ldctl	r0, NSPSEG 
	
	sc	#SC_NSEGV
	ld	RF_CTR + 2, r0
	ldctl	r0, NSPOFF
	
	ld	RF_CTR + 4, r0
	sc	#SC_SEGV
	ldctl	r0, PSAPSEG 
	
	sc	#SC_NSEGV
	ld	PS_, r0
	ldctl	r15, PSAP
	
	ld	PO_, r15
	ldctl	r15, REFRESH
	
	ld	RF_CTR, r15
	ld	r15, #SV_R + 2
	ldm	@r15, r1, #%0D	!REGISTERWERTE RETTEN!
	ldl	rr14, RR14_V
	ret	
    end SAVREG

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE GETREG
Register-Lade-Routine
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    GETREG procedure
      entry
	ldl	RR14_V, rr14
	ldl	rr14, SVSTK
	dec	r15, #%08
	ld	r1, W23B4
	ld	r15(#%0000), r1
	ld	r1, FCW_
	ld	r15(#%0002), r1
	ld	r1, PC_SEG
	ld	r15(#%0004), r1
	ld	r1, PC_OFF
	ld	r15(#%0006), r1
	ld	r1, N4_
	sc	#SC_SEGV
	ldctl	NSPSEG, r1
	sc	#SC_NSEGV
	ld	r1, N5_
	ldctl	NSP, r1
	ld	r1, PS_
	sc	#SC_SEGV
	ldctl	PSAPSEG, r1
	sc	#SC_NSEGV
	ld	r1, PO_
	ldctl	PSAPOFF, r1
	ld	r15, #SV_R
	ldm	r0, @r15, #%0E
	ldl	rr14, RR14_V
	ret	
    end GETREG
  
!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE INCPTR_MCZ
Zeichenkettenzeiger inkrementieren und auf Ueberlauf testen
Input:	r0 - Zeichenkettenzeiger
Output:	r2 := alter Stand Zeichenkettenzeiger (Input-Wert)
	r0 := r0+1, wenn C=1 (d.h. r0+1 < %E8)
	r0 := 0,    wenn C=0 (d.h. r0+1 >= %E8)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    INCPTR_MCZ procedure
      entry
	ld	r2, r0
	inc	r0, #%01
	cp	r0, #%00E8
	ret	c
	clr	r0
	ret	
    end INCPTR_MCZ

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE MCZ_INT
VI-Routine fuer MCZ-Eingabe
Abspeicherung des Zeichens im MCZ-Eingabepuffer MCZBFF;
Inkrementieren des Eingabezeigers INPTR_MCZ zur Kennzeichnung, dass ein Zeichen
eingegengen ist
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!

  GLOBAL
    MCZ_INT procedure
      entry
	push	@r15, r0
	push	@r15, r1
	push	@r15, r2
	INB	RL1, SIO0D_A	!rl1:=eingelesenes Zeichen!
	bitb	FLAG0, #%00
	jr	nz, MCZ1	!keine ASCII-Zeichen einlesen!

	resb	rl1, #%07	!Bit 7 des ASCII-Zeichens zuruecksetzen!

MCZ1:
	ld	r0, INPTR_MCZ
	calr	INCPTR_MCZ
	ld	INPTR_MCZ, r0	!MCZ-Eingabezeiger incr.!
	ldb	MCZBFF(r2), rl1	!Zeichen im MCZBFF abspeichern!

	ldb	rl1, #%38	!RETI AN SIO SENDEN!
	OUTB	SIO0C_A, RL1

	pop	r2, @r15
	pop	r1, @r15
	pop	r0, @r15
	sc	#SC_SEGV
	iret	
    end MCZ_INT

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE PTY_ERR
VI-Routine fuer Empfangsfehler von Terminalkanal SIO0_B des 16-Bit-Teils
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    PTY_ERR procedure
      entry
	push	@r15, r1
	ldb	rl1, #%30
	outb	SIO0C_B, rl1	!SIO-Error-Reset!
	jr	SEND_RETI
    end PTY_ERR

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE MCZ_ERR
VI-Routine fuer MCZ-Empfangsfehler
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    MCZ_ERR procedure
      entry
	push	@r15, r1
	ldb	rl1, #%30
	OUTB	SIO0C_A, RL1	!SIO_ERROR_RESET!
SEND_RETI:
	ldb	rl1, #%38	!RETI AN SIO SENDEN!
	OUTB	SIO0C_A, RL1	!SIO_RETI_SENDEN!
	pop	r1, @r15
	sc	#SC_SEGV
	iret	
    end MCZ_ERR

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE F_IB_MCZ
Fuellen von INBFF von MCZ nach empfangenen Zeichen '/' bis CR 
(max. %50 Zeichen)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    F_IB_MCZ procedure
      entry
	calr	WOCF_MCZ	!rl0:=Zeichen von MCZ!
	cpb	rl0, #'/'
	jr	nz, F_IB_MCZ	!Warten bis Zeichen = '/' eingegangen!
    end F_IB_MCZ		!Weiterlauf bei O_FIB_MCZ!

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE O_FIB_MCZ
Fuellen von INBFF von MCZ bis CR (max. %50 Zeichen)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    O_FIB_MCZ procedure
      entry
	CLR	R4		!Loeschen Zeiger Eingabepuffer!
	ldb	rl3, #%50	!max. %50 Zeichen einlesen!
FIB1:
	calr	WOCF_MCZ	!rl0:=Zeichen vom MCZ!
	ldb	INBFF(r4), rl0	!Zeichen in INBFF abspeichern!
	cpb	rl0, #CR
	jr	nz, FIB2	!Zeichen ungleich CR!

	calr	WOEOS_MCZ	!Zeichen war CR --> warten auf Sendeende!
	ret	

FIB2:
	cpb	rl0, #%20
	jr	c, FIB1		!Zeichen < Space ignorieren!
	
	inc	r4, #%01
	dbjnz	rl3, FIB1	!naechstes Zeichen von MCZ einlesen!

!%50 Zeichen vom MCZ eingelesen / restliche Zeichen bis CR ignorieren!
FIB3:
	calr	WOCF_MCZ	!rl0:=Zeichen von MCZ!
	cpb	rl0, #CR
	jr	nz, FIB3	!Warten bis CR gelesen!

	ldb	INBFF + %50, rl0	!CR als %51-stes Zeichen in INBFF
					abspeichern!
	ret	
    end O_FIB_MCZ

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE S_RPB
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    S_RPB procedure
      entry
	ldb	rl0, #'7'	!SEND TO MCZ: PLEASE REPEAT SENDET INFORMATION!
	jr	SAN_MCZ
    end S_RPB

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE S_LAB
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    S_LAB procedure
      entry
	ldb	rl0, #'9'	!SEND TO MCZ: ABORT THE LOAD-ROUTINE!
	jr	SAN_MCZ
    end S_LAB

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE S_SNB
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    S_SNB procedure
      entry
	ldb	rl0, #'0'	!SEND TO MCZ: RECIVED INF. IS OK (SEND NEXT)!
SAN_MCZ:
	ldb	OUTBFF, rl0
	ld	OUTPTR, #1
	calr	WR_OUTBFF_CR_MCZ
	calr    WOEOI_MCZ
	ret
    end S_SNB

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE SAW_MCZ
Senden einer Zeichenkette (Inhalt von INBFF) zum MCZ und warten auf Antwort
Output:	Z=0, wenn Zeichen '9' oder '0' oder '7' vom MCZ empfangen wurde
	Z=1, wenn Fehler MCZ bzw. Abbruchtaste (ESC) gedrueckt
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    SAW_MCZ procedure
      entry
	bitb	FLAG0, #%05
	jr	z, SAW0		!Abbruchtaste (ESC) nicht gedrueckt!

	setflg	z		!Z=1, Abbruchtaste gedrueckt!
	ret	

SAW0:
	ld	r4, #OUTBFF
	ld	r2, #INBFF
	ld	r1, #%0040
	ldir	@r4, @r2, r1	!Umspeicherung INBFF-->OUTBFF!

	ld	OUTPTR, #%0080	!Zeilenlaenge OUTBFF = %80!
	calr	WR_OUTBFF_MCZ	!Inhalt OUTBFF an MCZ senden!

	calr	WOEOI_MCZ	!Warten auf Antwort vom MCZ (bis CR) in MCZBFF!
	calr	WOCF_MCZ_OI	!rl1:=naechstes Zeichen vom MCZ
 				(kein incr. des MCZ-Ausgabezeigers OUTPTR_MCZ)!
	cpb	rl1, #'L'
	jr	z, SAW1		!ECHO VOM MCZ: 'LOAD ...' EMPFANGEN!
	jr	SAW2

SAW1:
	calr	WOEOI_MCZ	!ganze Zeile bis CR von MCZ einlesen!
	calr	WOCF_MCZ_OI	!rl1:=naechstes Zeichen!
SAW2:
	cpb	rl1, #'9'
	jr	z, SAW4
	cpb	rl1, #'0'
	jr	z, SAW4
	cpb	rl1, #'7'
	jr	z, SAW4

SAW3:
	calr	WOCF_MCZ	!rl0:=Zeichen vom MCZ!
	call	TYWR		!Zeichen auf Terminal ausgeben!
	cpb	rl0, #LF
	ret	z		!Zeichen=LF --> Ende (Z=1)!
	jr	SAW3

SAW4:
	resflg	z
	ret	
    end SAW_MCZ

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE WOEOI_MCZ
Warten auf das Ende der Information vom MCZ (CR empfangen);
weiter siehe WEOS_MCZ
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    WOEOI_MCZ procedure
      entry
	calr	WOCF_MCZ	!rl0:=Zeichen vom MCZ!
	cpb	rl0, #CR
	jr	nz, WOEOI_MCZ	!Warten auf CR!
    end WOEOI_MCZ		!Weiterlauf bei WOEOS_MCZ!

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE WOEOS_MCZ
Warten auf das Ende des Sendens vom MCZ
(Warten auf ein Zeichen >='Space' oder bis Wartezeit abgelaufen)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    WOEOS_MCZ procedure
      entry
	ld	r1, #%0200	!Festlegung der Wartezeit bis zur Bereit-
				stellung eines Zeichens in MCZBFF!
WOEOS1:
	ld	r0, OUTPTR_MCZ	!bestimmte Zeit auf ein Zeichen vom MCZ warten!
	cp	r0, INPTR_MCZ
	jr	nz, WOEOS2	!Zeichen steht in MCZBFF bereit!

	dec	r1, #%01	!Zeitzaehler decr.!
	jr	nz, WOEOS1
	ret	z 		!Wartezeit abgelaufen!

WOEOS2:
	calr	WOCF_MCZ_OI	!rl1:=Zeichen (OUTPTR_MCZ nicht incr.)!
	cpb	rl1, #' '
	ret	pl		!Zeichen >='Space'!

	calr	WOCF_MCZ	!Zeichen uebergehen!
	jr	WOEOS_MCZ	!Warten auf naechstes Zeichen!
    end WOEOS_MCZ

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE WOCF_MCZ
Warten, bis ein Zeichen im MCZ-Puffer MCZBFF bereitsteht
(MCZBFF wird durch empfangene Zeichen vom MCZ in MCZ_INT gefuellt)
Output:	rl0 - Zeichen 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    WOCF_MCZ procedure
      entry
	ld	r0, OUTPTR_MCZ
	cp	r0, INPTR_MCZ
	jr	z, WOCF_MCZ	!kein Zeichen in MCZBFF eingegangen!

!Zeichen empfangen!
	call	INCPTR_MCZ
	ld	OUTPTR_MCZ, r0	!Ausgabezeiger aktualisieren (Zeichen wurde
				abgeholt!
	ldb	rl0, MCZBFF(r2)	!rl0:=Zeichen!
	ret	
    end WOCF_MCZ
   
!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE WR_OUTBFF_CR_MCZ
Anhaengen eines CR an Zeichenkette im Ausgabepuffer OUTBFF;
Ausgabe des Inhaltes des Ausgabepuffers OUTBFF an das MCZ
(bis CR, maximal bis OUTPTR);
Loeschen des Ausgabepuffers OUTBFF
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    WR_OUTBFF_CR_MCZ procedure
      entry
	ld	r2, OUTPTR
	ldb	OUTBFF(r2), #CR
	inc	OUTPTR, #%01
    end WR_OUTBFF_CR_MCZ	!Weiterlauf bei WR_OUTBFF_MCZ!

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE WR_OUTBFF_MCZ
Ausgabe des Inhaltes des Ausgabepuffers OUTBFF an das MCZ
(bis CR, maximal bis OUTPTR);
Loeschen des Ausgabepuffers OUTBFF
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    WR_OUTBFF_MCZ procedure
      entry
	clr	r1
STRO1:
	ldb	rl0, OUTBFF(r1)
	inc	r1, #%01
	call	TYWR_MCZ	!Ausgabe rl0 an MCZ!
	jr	z, STRO2	!CR ausgegeben --> Ende!

	cp	r1, OUTPTR
	jr	c, STRO1	!noch nicht alle Zeichen ausgegeben!

STRO2:
	clr	OUTPTR		!Ausgabepuffer loeschen!
	ld	r1, #%003F
	ld	OUTBFF, #'  '
	ld	r4, #OUTBFF
	ld	r2, #OUTBFF + 2
	ldir	@r2, @r4, r1
	ret	
    end WR_OUTBFF_MCZ

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE WOCF_MCZ_OI
Warten, bis ein Zeichen im MCZ-Puffer MCZBFF bereitsteht
(ohne Aktualisierung von OUTPTR_MCZ, d.h. Zeichen gilt nach Aufruf von
WOCF_MCZ_OI als noch nicht abgeholt);
(MCZBFF wird durch empfangene Zeichen vom MCZ in MCZ_INT gefuellt)
Output:	rl1 - Zeichen 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    WOCF_MCZ_OI procedure
      entry
	ld	r0, OUTPTR_MCZ
	cp	r0, INPTR_MCZ
	jr	z, WOCF_MCZ_OI	!kein Zeichen in MCZBFF eingegangen!

	call	INCPTR_MCZ	!r2:=OUTPTR_MCZ!
	ldb	rl1, MCZBFF(r2)	!rl1:=Zeichen!
	ret	
    end WOCF_MCZ_OI

end p_ldsd
