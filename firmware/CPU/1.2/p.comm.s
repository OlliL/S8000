!******************************************************************************
*******************************************************************************

  S8000-Firmware
  Z8000-Softwaremonitor (CPU)        Modul: p_comm

  Bearbeiter:	O. Lehmann
  Datum:	14.01.2016
  Version:	1.2

*******************************************************************************
******************************************************************************!

p_comm module

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
PROCEDURE FILL
FILL-Routine (Monitorkommando)
Fuellen eines Speicherbereiches

Kommandoeingabe: F [<segnr>]offset1 offset2 word
                   (Anfangsadresse, Endadresse, Datenwort)
Fehler, wenn offset1 ungerade oder (offset2 < offset1)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    FILL procedure
      entry
	calr	GET_PAR		!Einlesen und Konvertierung der Eingabezeile!
				!rr6:=1. Adr./rr4:=2. Adr./r3:=Datenwort!
	jr	c, F_ERROR	!falsche Parameterfolge!

	bit	r7, #%0
	jp	nz, ERROR

	sub	r5, r7		!r5 := Adressendifferenz!
F_ERROR:
	jp	c, ERROR	!2.Adr. < 1.Adr.!

	srl	r5, #1
	inc	r5, #1		!r5 := Wortanzahl!
	sc	#SC_SEGV
F2:
	ld	@r6, r3		!Speicherbereich fuellen!
	inc	r7, #%02
	djnz	r5, F2
	sc	#SC_NSEGV
	ret
    end FILL

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE MOVE
MOVE-Routine (Monitorkommando)
Verschieben eines Speicherbereiches

Kommandoeingabe: M [<segnr1>]offset1 [<segnr2>]offset2 count
                   (Adresse Quelle, Adresse Ziel, Bytezahl)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    MOVE procedure
      entry
	calr	GET_PAR		!Einlesen und Konvertierung der Eingabezeile!
				!rr6:=1. Adr./rr4:=2. Adr./r3:=Bytezahl!
	jr	c, F_ERROR	!falsche Parameterfolge!

	cp	r4, r6		!Vergleich der Segmentnummern!
	jr	nz, M1		!ungleich!

	cp	r7, r5		!Vergleich der Offsetadressen, wenn Segment-
                                 nummern gleich sind!
	jr	c, M2		!1.Adr. < 2. Adr.!
M1:
	sc	#SC_SEGV
	ldirb	@r4, @r6, r3	!Speicherbereich verschieben (bei ungleichen
				 Segmentnummern bzw. bei gleichen Segment-
				 nummern und 1.Adr.>=2.Adr.)!
	sc	#SC_NSEGV
	ret
M2:
	add	r7, r3
	dec	r7, #1
	add	r5, r3
	dec	r5, #1
	sc	#SC_SEGV
	lddrb	@r4, @r6, r3	!Speicherbereich verschieben (bei gleichen
				 Segmentnummern und 1.Adr.<2.Adr.)!
	sc	#SC_NSEGV
	ret
    end MOVE

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE COMPARE
COMPARE-Routine (Monitorkommando)
Vergleich zweier Speicherbereiche

Kommandoeingabe: C [<segnr1>]offset1 [<segnr2>]offset2 count
                   (1. Anfangsadresse, 2. Anfangsadresse, Bytezahl)
unterschiedliche Bytes werden ausgegeben:
	<segnr2>offset2= inhalt  <segnr1>offset1= inhalt
Fehler, wenn Bytezahl = 0
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    COMPARE procedure
      entry
	calr	GET_PAR		!Einlesen und Konvertierung der Eingabezeile!
				!rr6:=1. Adr./rr4:=2. Adr./r3:=Bytezahl!
	jr	c, F_ERROR	!falsche Parameterfolge!

	ldl	rr8, rr4	!rr8 := 2. Adresse!
	ld	r10, r3		!r10 := Bytezahl!
	test	r3
	jp	z, ERROR	!Bytezahl = 0!
C1:
	sc	#SC_SEGV
	ldb	rl1, @r6
	cpib	rl1, @r8, r10, z	!inc offset2, dec r10!
	sc	#SC_NSEGV
	jr	z, C2		!Vergleich: identisch!

	ldl	rr4, rr8	!rr4 := 2. Adresse!
	dec	r5, #1
	calr	PUT_ADR_INHALT	!Eintragung 2. Adr. und Inhalt in OUTBFF!
	ldl	rr4, rr6	!rr4 := 1. Adresse!
	calr	PUT_ADR_INHALT	!Eintragung 1. Adr. und Inhalt in OUTBFF!
	calr	WR_OUTBFF_CR	!Ausgabe des Inhaltes von OUTBFF auf Terminal!
C2:
	test	r10
	ret	z		!alle Bytes verglichen!

	inc	r7, #1		!inc offset1!
	jr	C1
end COMPARE

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE PUT_ADR_INHALT
Eintragung von '<segnr>offset= inhalt' in Ausgabepuffer (OUTBFF)
Input: rr4 - Adresse
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    PUT_ADR_INHALT procedure
      entry
	calr	PUT_3C		!Zeichen '<' in OUTBFF eintragen!
	ld	r2, r5
	ldb	rl5, rh4
	calr	PUT_SGNR	!'segnr>' in OUTBFF eintragen!
	ld	r5, r2
	calr	BTOH16		!'offset' in OUTBFF eintragen!
	ld	r1, #'= '
	calr	PUT_2CHR	!'= ' in OUTBFF eintragen!
	sc	#SC_SEGV
	ldb	rl5, @r4
	sc	#SC_NSEGV
	calr	BTOH8		!Adresseninhalt in OUTBFF eintragen!
	inc	OUTPTR, #%02	!2 Leerzeichen in OUTBFF!
	ret
    end PUT_ADR_INHALT

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE PUT_3C
Eintragung des Zeichens '<' in Ausgabepuffer (OUTBFF)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    PUT_3C procedure
      entry
	ld	r1, #'< '
    end PUT_3C			!Weiterlauf bei PUT_1CHR!

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE PUT_1CHR
Eintragung eines Zeichens in Ausgabepuffer (OUTBFF)
Input: r1 - Zeichenkette aus 'Zeichen, Space'
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    PUT_1CHR procedure
      entry
	calr	PUT_2CHR	!2 ZEICHEN IN DEN OUTPUT_PUFFER LADEN!
	dec	OUTPTR, #1	!PUFFERLAENGE DEKREMENTIEREN!
	ret
    end PUT_1CHR

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE PUT_SEGNR
Konvertierung der Segmentnummer in HEXA-ASCII-Zahl (xx);
Eintragung von '<xx>' in Ausgabepuffer OUTBFF
Input: rl5 - Segmentnummer (binaer)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    PUT_SEGNR PROCEDURE
      ENTRY
	calr	PUT_3C		!Zeichen '<' in OUTBFF eintragen!
    end PUT_SEGNR		!Weiterlauf bei PUT_SGNR!

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE PUT_SGNR
Konvertierung der Segmentnummer in HEXA-ASCII-Zahl (xx);
Eintragung von 'xx>' in Ausgabepuffer OUTBFF
Input: rl5 - Segmentnummer (binaer)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    PUT_SGNR PROCEDURE
      ENTRY
	resb	rl5, #%07
	calr	BTOH8		!Segmentnummer in OUTBFF eintragen!
	ld	r1, #'> '
	jr	PUT_1CHR	!Zeichen '>' in OUTBFF eintragen!
    end PUT_SGNR

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE PUT_CHR
Eintragung eines Zeichens in Ausgabepuffer (OUTBFF)
Input: rl1 - einzutragendes Zeichen
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    PUT_CHR procedure
      entry
	ld	r2, OUTPTR
	ldb	OUTBFF(r2), rl1
	inc	OUTPTR, #1
	ret
    end PUT_CHR

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE DISPLAY
DISPLAY-Routine (Monitorkommando)
Anzeigen eines Speicherbereiches bzw. Aenderung von Speicherzellen

Kommandoeingabe: D [[<segnr>]offset [count] [W,B,L]]
                   (Anfangsadresse, Datenanzahl, Datentyp)
Fehler, wenn anstelle 'W,B,L' ein anderes Zeichen eingegeben wurde bzw. wenn
Datenanzahl = 0
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    DISPLAY procedure
      entry

!*** Parameterauswertung ***!

	resb	FLAG1, #1	!Flag: noch Parameter einlesen!
	calr	GET_SIGN	!rl0:=1. Zeichen nach Space in INBFF!
	ld	r7, #%0202	!IMPLIZIT WORD AUSGEBEN!
	ld	r10, PC_SEG	!implizite Segmentnummer!
	jr	nz, D_PARA	!Parameter wurden angegeben!

	ld	r11, r3		!IMPLIZITER OFFSET!
	jr	D_WRITE		!keine Parameter angegeben!

D_PARA:
	calr	GET_ADR		!rr2:=eingegebene Anfangsadresse /
				 rl0:=naechstes Zeichen in INBFF!
	JR	NZ, D2		!weitere Parameter vorhanden!

	setb	FLAG1, #1	!MERKER: ALLE PARAMETER EINGELESEN!
D2:
	ldl	rr10, rr2	!rr10:=Anfangsadresse (r10-segnr/r11-offset)!
	bitb	FLAG1, #1
	jr	nz, D_WRITE0	!Sprung zu "Speicher schreiben" (keine
				 Datenanzahl und kein Datentyp angegeben!
	calr	TST_WBL		!Test: Datentyp (W,B,L)
				 r7 := %0202 bzw. %0101 bzw. %0404!
	jr	z, D_WRITE0	!Sprung zu "Speicher schreiben" (keine
				 Datenanzahl, aber Datentyp (W,B,L) angegeben)!
	calr	GET_HEXZ	!Datenanzahl angegeben!
	ld	r13, r3		!r13 := Datenanzahl!
	jr	z, D_LEN0	!CR gelesen (kein Datentyp angegeben)!

	calr	TST_WBL		!Test: Datentyp (W,B,L)
				 r7 := %0202 bzw. %0101 bzw. %0404!
	jp	nz, ERROR	!falscher Datentyp angegeben (nicht W,B,L)!

D_LEN0:
	test	r13
    end DISPLAY			!Weiterlauf in DISPLAY_RW!

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE DISPLAY_RW
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    DISPLAY_RW procedure
      entry
	jp	z, ERROR	!Datenanzahl = 0!

!*** DISPLAY READ ***!
! Aufbau der Ausgabezeile !

D_READ:
	ld	r6, #%0010	!%10 Bytes je Ausgabezeile anzeigen!
	calr	PUT_3C		!Zeichen '<' in OUTBFF eintragen!
	ld	r5, r10
	ldb	rl5, rh5
	calr	PUT_SGNR	!'segnr>' in OUTBFF eintragen!
	ld	r5, r11
	calr	BTOH16		!'offset' in OUTBFF eintragen!
	inc	OUTPTR, #1	!1 Leerzeichen in OUTBFF!
	ld	r8, #%003A
	ldb	OUTBFF(r8), #'*' !'*' auf Pos. %3A in OUTBFF eintragen!
	inc	r8, #1
D5:
	sc	#SC_SEGV
	ldb	rl5, @r10	!BYTE VOM SPEICHER LESEN!
	sc	#SC_NSEGV
	ldb	OUTBFF(r8), rl5
	cpb	rl5, #' '	!TEST UNTERE GRENZE ASCII-CODE!
	jr	c, D6
	cpb	rl5, #%7F	!TEST OBERE GRENZE ASCII-CODE!
	jr	c, D7
D6:
	ldb	OUTBFF(r8), #'.' !kein ASCII-Code --> Punkt in OUTBFF eintr.!
D7:
	inc	r8, #1
	ldb	OUTBFF(r8), #'*' !'*' am Ende der ASCII-Zeichen in OUTBFF!
	calr	BTOH8		!Datenbyte (im ASCII-Code) in OUTBFF eintragen!
	inc	r11, #1
	dec	r6, #1
	jr	nz, D8		!Zeile noch nicht vollst. aufgebaut (%10 Byte)!

! Ausgabe der vollstaendigen Zeile !

	inc	r8, #1
	ld	OUTPTR, r8	!Laenge der Ausgabezeile!
	calr	WR_OUTBFF_CR	!Ausgabe OUTBFF auf Terminal (mit CR)!
	ldb	rl7, rh7	!WORD-BYTE-LONG MERKER NEULADEN!
	dec	r13, #1		!dec Datenanzahl!
	jr	nz, D_READ	!noch nicht alle Daten angezeigt!
	ret			!fertig!

! Steuerung der Leerzeichen zwischen den Dateneinheiten (W,B,L) !

D8:
	dbjnz	rl7, D5		!naechstes Byte, wenn Dateneinheit (W,L)
 				 noch nicht vollstaendig!
	inc	OUTPTR, #1	!1 Leerzeichen zwischen 2 Dateneinheiten!
	ldb	rl7, rh7	!Anz. der Bytes je Dateneinheit wieder setzen!
	dec	r13, #1		!dec Anzahl der Dateneinheiten!
	jr	nz, D5		!naechste Dateneinheit!

	inc	r8, #1		!Datenanzahl abgearbeitet!
	ld	OUTPTR, r8
	calr	WR_OUTBFF_CR	!Ausgabe der letzten Zeile auf Terminal!
	ret

!*** DISPLAY WRITE ***!
! Aufbau und Ausgabe der Ausgabezeile !

D_WRITE0:
	cpb	rl7, #1		!BYTE AUSGABE ?  !
	jr	z, D_WRITE
	res	r11, #%0	!gerade Offsetadresse bei 'W' und 'L'!
D_WRITE:
	ldl	rr8, rr10	!rr8 := Zeilenadresse!
	calr	PUT_3C		!Zeichen '<' in OUTBFF eintragen!
	ld	r5, r10
	ldb	rl5, rh5
	calr	PUT_SGNR	!'segnr>' in OUTBFF eintragen!
	ld	r5, r11
	calr	BTOH16		!'offset' in OUTBFF eintragen!
	inc	OUTPTR, #1	!1 Leerzeichen nach Zeilenadresse in OUTBFF!
D11:
	sc	#SC_SEGV
	ldb	rl5, @r10	!BYTE VOM SPEICHER LESEN!
	sc	#SC_NSEGV
	calr	BTOH8		!Datenbyte in OUTBFF eintragen (ASCII)!
	inc	r11, #1		!OFFSET INKREMENTIEREN!
	dbjnz	rl7, D11	!alle Bytes der Dateneinheit in OUTBFF eintr.;
				 r11:= Offsetadr. des folg. Datenwertes!
	inc	OUTPTR, #1	!1 Leerzeichen nach Dateneinheit!
	ldb	rl7, rh7	!Bytezaehler je Dateneinheit neu setzen!
	calr	WR_OBF_RDDATA	!Ausgabe OUTBFF auf Terminal; Ausgabe '?';
				 einlesen des zu schreibenden Datenwertes!
	jr	nc, D12		!kein 'Q' oder '-' eingegeben!

	cpb	rl0, #'Q'
	ret	z		!'Q' eingegeben --> Abbruch!

	push	@r15, r7	!'-' eingegeben!
	clrb	rh7
	sub	r11, r7
	sub	r11, r7		!Offsetadresse um 2 Dateneinheiten dec!
	pop	r7, @r15
	jr	D_WRITE		!vorherige Dateneinheit betrachten!

D12:
	jr	z, D_WRITE	!kein Datenwert wurde engegeben!

	decb	rl7, #1
	sc	#SC_SEGV	!Datenwert in Speicher schreiben!
	jr	nz, D13
	ldb	@r8, rl3	! Byte !
	jr	D15
D13:
	decb	rl7, #1
	jr	nz, D14
	ld	@r8, r3		! Word !
	jr	D15
D14:
	ldl	@r8, rr2	! Long !
D15:
	sc	#SC_NSEGV
	ldb	rl7, rh7
	jr	D_WRITE
    end DISPLAY_RW

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE TST_WBL
Test WORD-BYTE-LONG
Input: 	rl0 - Datentyp ('W','B','L')
Output: rh7/rl7 - Anzahl der Byte des Datentyps

	} %0101		wenn rl0='B'
r7 =	} %0404		wenn rl0='L'
	} %0202, Z=1	wenn rl0=CR oder rl0='W'
	} %0202, Z=0	ansonsten (Fehler)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    TST_WBL procedure
      entry
	ld	r7, #%0202
	cpb	rl0, #CR
	ret	z
	cpb	rl0, #'W'
	ret	z
	ld	r7, #%0101
	cpb	rl0, #'B'
	ret	z
	ld	r7, #%0404
	cpb	rl0, #'L'
	ret	z
	ld	r7, #%0202
	ret
    end TST_WBL

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE WR_R5_RDDATA
Eintragung des ASCII-konvertierten Inhaltes von r5 in Ausgabepuffer (OUTBFF);
Ausgabe des Ausgabepuffers auf Terminal; Ausgabe ':'; Eingabe des Datenwertes
Input:	r5 - Adresse
Output:	siehe Prozedur RD_DATA
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    WR_R5_RDDATA procedure
      entry
	calr	BTOH16		!Eintragung r5 (ASCII) in OUTBFF!
	inc	OUTPTR, #1	!1 Leerzeichen!
    end WR_R5_RDDATA		!Weiterlauf in WR_OBF_RDDATA!

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE WR_OBF_RDDATA
Ausgabe des Ausgabepuffers auf Terminal; Ausgabe ':'; Eingabe des Datenwertes
Output:	siehe Prozedur RD_DATA
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    WR_OBF_RDDATA procedure
      entry
	calr	WR_OUTBFF	!Ausgabe Inhalt OUTBFF!
	call	RD_DATA		!AUSGABE ':' + EINGABE NEUER INHALT!
	ret
    end WR_OBF_RDDATA

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE PUT_2CHR
2 Zeichen in Ausgabepuffer (OUTBFF) eintragen
Input:	rh1 - 1. Zeichen
	rl1 - 2. Zeichen
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    PUT_2CHR procedure
      entry
	push	@r15, r4
	ld	r4, OUTPTR
	ldb	OUTBFF(r4), rh1
	inc	r4, #1
	ldb	OUTBFF(r4), rl1
	inc	OUTPTR, #%02
	pop	r4, @r15
	ret
    end PUT_2CHR

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE WR_MSG
Zeichenketten-Ausgabe auf Terminal
Ausgabe wird bei CR beendet
Input:	r2 - Adresse der Zeichenkette
	     (Zeichenkette beginnt mit Angabe der Laenge (WORD) gefolgt
	     von der Zeichenkette selbst)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    WR_MSG procedure
      entry
	ld	r0, @r2
	cp	r0, #%0		!LAENGE = 0? !
	ret	z
	ld	OUTPTR, r0
	inc	r2, #%02	!ADRESSE DES 1. CHAR.!
	ld	r4, #OUTBFF	!OUTBFF_ADRESSE LADEN!
	ldirb	@r4, @r2, r0	!MESSAGE TRANSFERIEREN!
	jp	WR_OUTBFF
    end WR_MSG

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE GET_PAR
Einlesen (aus Eingabepuffer INBFF) und Konvertierung der Parameterfolge:
'<segnr1>offset1 <segnr2>offset2 word', wobei <segnr> fehlen kann
Output:	c=1 wenn Parameterfolge unvollst. oder fehlerhaft
	rr6 - 1. Adresse (binaer)
	rr4 - 2. Adresse (binaer)
	r3  - word (binaer)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    GET_PAR procedure
      entry
	calr	GET_SIGN	!1. ASCII-ZEICHEN IN RL0!
	calr	GET_ADR		!rr2 := 1. Adresse!
	jr	z, RD_P2	!CR wurde gelesen!
	ldl	rr6, rr2	!rr6 := 1. Adresse!
	jr	RD_P1
	calr	GET_SIGN	!1. ASCII-ZEICHEN IN RL0!
RD_P1:
	calr	GET_ADR		!rr2 := 2. Adresse!
	jr	z, RD_P2	!CR wurde gelesen!
	ldl	rr4, rr2	!rr4 := 2. Adresse!
	calr	GET_HEXZ		!r3 := word!
	ret	nc		!kein Fehler!

RD_P2:
	setflg	c		!C=1, d.h. Fehler!
	ret
    end GET_PAR

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE BTOH16
Konvertierung Binaer in Hexaziffern (ASCII) und Eintragung in
Ausgabepuffer (OUTBFF)
Input:	r5 - 16-Bit-Wert (--> 4 Hexaziffern)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    BTOH16 procedure
      entry
	ldb	rh0, rh5	!HIGH ADRESSE LADEN!
	calr	BTH
    end BTOH16

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE BTOH8
Konvertierung Binaer in Hexaziffern (ASCII) und Eintragung in
Ausgabepuffer (OUTBFF)
Input:	 rl5 - 8-Bit-Wert (--> 2 Hexaziffern)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    BTOH8 procedure
      entry
	ldb	rh0, rl5	!LOW ADRESSE ODER 8-BIT WERT LADEN!
BTH:
	rldb	rl0, rh0
	calr	BTOH4		!BINAER TO HEX KONVERTIERUNG!
	rldb	rl0, rh0
    end BTOH8		!Weiterlauf bei BTOH4!

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE BTOH4
Konvertierung Binaer in Hexaziffer (ASCII) und Eintragung in
Ausgabepuffer (OUTBFF)
Input:	rl0 (Bit0-3) - 4-Bit-Wert (--> 1 Hexaziffer)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    BTOH4 procedure
      entry
	push	@r15, r1
	andb	rl0, #%0F
	ldb	rl1, KONV
	addb	rl1, rl0
	ldb	KONV, rl1
	cpb	rl0, #%0A
	jr	c, BTOH41
	addb	rl0, #%07
BTOH41:
	addb	rl0, #%30
	push	@r15, r6
	ld	r6, OUTPTR
	ldb	OUTBFF(r6), rl0
	inc	OUTPTR, #1
	pop	r6, @r15
	pop	r1, @r15
	ret
    end BTOH4

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE WR_NULL
Ausgabe einer bestimmten Anzahl Nullen auf Terminal (entsprechend NULLCT)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    WR_NULL procedure
      entry
	test	NULLCT
	ret	z
	ld	r1, NULLCT
	clr	r0
WR_NULL1:
	call	TYWR
	dec	r1, #1
	jr	nz, WR_NULL1
	ret
    end WR_NULL

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE WR_OUTBFF_CR
Ausgabe des Inhaltes des Ausgabepuffers (OUTBFF) mit CR auf Terminal;
Loeschen des Ausgabepuffers
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    WR_OUTBFF_CR procedure
      entry
	ld	r3, OUTPTR
	ldb	OUTBFF(r3), #CR
	inc	OUTPTR, #1
    end WR_OUTBFF_CR

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE WR_OUTBFF
Ausgabe des Inhaltes des Ausgabepuffers (OUTBFF) auf Terminal;
Loeschen des Ausgabepuffers
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    WR_OUTBFF procedure
      entry
	clr	r3		!ZEICHENZAEHLER LOESCHEN!
TX_1:
	ldb	rl0, OUTBFF(r3)
	inc	r3, #1
	call	TYWR
	jr	z, TX_2		!SPRUNG WENN CR AUSGEGEBEN WURDE!
	cp	r3, OUTPTR	!ALLE ZEICHEN AUSGEBEN ? !
	jr	c, TX_1		!SPRUNG WENN PUFFER NICHT LEER!
	jr	BF_EMPTY
TX_2:
	ldb	rl0, #LF	!LINE FEED NACH MSG SENDEN!
	call	TYWR
	call	WR_NULL		!NULLCT Nullen senden!
	bitb	FLAG1, #%04	!AUSGABE BEI CR ABBRECHEN ? !
	jr	nz, TX_1
BF_EMPTY:
	ld	OUTPTR, #0	! OUTPTR RUECKSETZTEN !
	ld	r0, #%0040
	ld	OUTBFF, #'  '
	ld	r2, #OUTBFF	!OUTBFF LOESCHEN !
	ld	r4, #OUTBFF + 2
	ldir	@r4, @r2, r0
	ret
    end WR_OUTBFF

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE HTOB
Konvertierung Hexaziffer (ASCII) in Binaerwert
Input:	rl0 - Hexaziffer (ASCII)
Output:	rl0 - Binaerwert
	C=1 --> keine Hexaziffer (Fehler)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    HTOB procedure
      entry
	cpb	rl0, #'0'
	ret	c		!FEHLER := KEINE ZAHL!
	cpb	rl0, #'9' + 1
	jr	c, HTOB1	!SPRUNG WENN ZAHL!
	cpb	rl0, #'A'
	ret	c		!FEHLER := KEIN BUCHSTABE!
	cpb	rl0, #'F' + 1
	jr	nc, HTOB2	!FEHLER := KEIN BUCHSTABE A...F!
	subb	rl0, #%07
HTOB1:
	andb	rl0, #%0F	!FEHLERFREI!
	resflg	c
	ret
HTOB2:
	setflg	c		!FEHLER := KEINE HEXADEZIMALZAHL!
	ret
    end HTOB

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE GET_ADR
Einlesen (aus Eingabepuffer INBFF) und Konvertierung einer Adresse
(eingegebene Adresse muss folgenden Aufbau haben: '<segnr>offset', wobei
die Segmentnummer fehlen kann)
Input:	rl0 - 1. Zeichen der Adresse
	INPTR zeigt auf darauffolgendes Zeichen
Output:	rr2 - Adresse (binaer)
	rl0 - naechstes Zeichen ungleich Space aus Eingabepuffer nach
	      ausgewerteter Adresse
	INPTR zeigt auf darauffolgendes Zeichen
	C=1 --> keine Adresse angegeben
	Z=1 --> CR gelesen
Fehler, wenn ungueltige Hexaziffer angegeben
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    GET_ADR procedure
      entry
	calr	GET_SGNR	!r2 := Segmentnummer!
	calr	GET_HEXZ	!r3 := Offset!
	ret
    end GET_ADR

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE GET_SGNR
Einlesen (aus Eingabepuffer INBFF) und Konvertierung der Segmentnummer
Input:	rl0 - 1. Zeichen der eingegebenen Adresse
	INPTR zeigt auf darauffolgendes Zeichen
Output:	r2 - Segmentnummer (Bit0-7=0 / Bit8-14=segnr / Bit15=1)
	     (falls kein Segmentnummer angegeben, dann r2=PC_SEG)
	rl0 - 1. Zeichen der Offsetadresse
	INPTR zeigt auf darauffolgendes Zeichen
Fehler, wenn unzulaessige Segmentnummer angegeben
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    GET_SGNR procedure
      entry
	ld	r2, PC_SEG	!implizite segnr!
	set	r2, #%0F	!Setzen Bit15!
	resb	FLAG1, #%0	!Flag=0 --> keine Segmentnummer angegeben ???!
	cpb	rl0, #CR
	ret	z		!Ende der Eingabezeile!
	cpb	rl0, #'<'	!#SEGMENT IDENTIFIER ANF. !
	ret	nz		!keine Segmentnummer angegeben!
	clr	r3
EKSN_N:
	calr	GET_CHR		!rl0:=naechstes Zeichen aus INBFF!
	jp	z, ERROR	!Zeichen=CR!
	calr	HTOB		!Konvertierung rl0 hexa (ASCII)-->binaer!
	jr	c, EKSN_NHZ	!keine Hexaziffer!
	rldb	rl0, rl3	!Binaerwert in rl3 schieben!
	jr	EKSN_N		!naechstes Zeichen!

EKSN_NHZ:
	cpb	rl0, #'>'	!#SEGMENT IDENTIFIER ENDE!
	jp	nz, ERROR	!segnr enthaelt unzulaessiges Zeichen!
	calr	GET_SIGNW	!rl0:=Zeichen nach segnr ungleich Space!
	ldb	rh2, rl3
	clrb	rl2
	set	r2, #%0F	!r2 := segnr!
	setb	FLAG1, #%0	!Flag=1 --> Segmentnummer angegeben ???!
	ret
    end GET_SGNR


!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE GET_HEXZ
Einlesen (aus Eingabepuffer INBFF) und Konvertierung einer Hexazahl
Input:	rl0 - 1. Ziffer der eingegebenen Hexazahl
	INPTR zeigt auf darauffolgendes Zeichen
Output:	r3  - Hexazahl (binaer) - wurden mehr als 4 Ziffern angegeben, so
                                  werden die letzten 4 Ziffern ausgewertet
	rl0 - naechstes Zeichen aus Eingabepuffer ungleich Space nach
              ausgewerteter Hexazahl
	INPTR zeigt auf darauffolgendes Zeichen
	C=1 --> keine Hexazahl angegeben
 	Z=1 --> CR gelesen
Fehler, wenn unzulaessige Hexazahl angegeben
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    GET_HEXZ procedure
      entry
	clr	r3
	cpb	rl0, #CR
	setflg	c
	ret	z
RD_HX:
	calr	HTOB		!Konvertierung rl0 in Binaerwert!
	jp	c, ERROR	!unzulaessige Hexaziffer!
	rldb	rl0, rl3
	rldb	rl0, rh3
	calr	GET_CHR		!rl0 := naechste Ziffer!
	ret	z		!CR gelesen (C=0 aus GET_CHR)!
	cpb	rl0, #' '
	jr	nz, RD_HX	!naechste Ziffer!

	calr	GET_SIGNW	!rl0:= naechstes Zeichen ungleich Space!
	resflg	c
	ret			!Z=1, wenn CR gelesen; sonst Z=0
				 (aus GET_SIGNW)!
    end GET_HEXZ

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE GET_SIGN
aus Eingabepuffer INBFF ab Position INPTR (einschl.) Space suchen und naechstes
Zeichen ungleich Space in rl0 bereitstellen
Output: rl0 - Zeichen
	INPTR zeigt auf darauffolgendes Zeichen
	Z=1 --> CR gelesen
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    GET_SIGN procedure
      entry
	calr	GET_CHR
	ret	z		!RUECKSPRUNG WENN ENDEKENNUNG (CR)!
	cpb	rl0, #' '
	jr	nz, GET_SIGN	!1. SPACE NACH DEM KOMMANDO SUCHEN!
    end GET_SIGN		!Weiterlauf bei GET_SIGNW!


!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE GET_SIGNW
aus Eingabepuffer INBFF ab Position INPTR (einschl.) erstes Zeichen ungleich
Space in rl0 bereitstellen
Output: rl0 - Zeichen
	INPTR zeigt auf darauffolgendes Zeichen
	Z=1 --> CR gelesen
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    GET_SIGNW procedure
      entry
	calr	GET_CHR		!1. ZEICHEN DER PARAMETERFOLGE LESEN!
	ret	z		!Zeichen=CR!
	cpb	rl0, #' '
	jr	z, GET_SIGNW
	ret			!Z=0!
    end GET_SIGNW

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE GET_CHR
aus Eingabepuffer INBFF das Zeichen in rl0 bereitstellen, auf das INPTR zeigt
Output:	rl0 - Zeichen
	INPTR zeigt auf darauffolgendes Zeichen
	Z=1 --> Zeichen=CR
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    GET_CHR procedure
      entry
	push	@r15, r2
	ld	r2, INPTR
	ldb	rl0, INBFF(r2)
	inc	INPTR, #1	!INPTR := INPTR + 1!
	cpb	rl0, #CR
	pop	r2, @r15
	ret
    end GET_CHR



  INTERNAL
R_BEZ	 ARRAY [* BYTE] := '0 1 2 3 4 5 6 7 8 9 101112131415SGPCFCRFN4N5PSPO'
R_LH ARRAY [* BYTE] := 'RLRH'


!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE PORT_RW
PORT Schreib-Lese-Routine (Monitorkommando I)

Kommandoeingabe: I portadr [W|B]
                  (Portadresse, Datentyp)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    PORT_RW procedure
      entry
	ld	r5, #P_OUT
	ld	r7, #P_IN
	jr	P_PORT_RW
    end PORT_RW

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE PORT_RW_SPECIAL
SPECIAL-PORT Schreib-Lese-Routine (Monitorkommando P)

Kommandoeingabe: P portadr [W|B]
                  (Portadresse, Datentyp)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    PORT_RW_SPECIAL procedure
      entry
	ld	r5, #PS_OUT
	ld	r7, #PS_IN
P_PORT_RW:
	ld	PORT_O, r5
	ld	PORT_I,	r7
	call	GET_SIGN	!rl0:=1.Zeichen nach naechstem Space in INBFF
				 (= 1. Zeichen der Portadresse)!
	jp	z, ERROR	!Zeichen=CR, d.h. keine Portadr. angegeben!

	call	GET_HEXZ	!r3:=Hexazahl (binaer) aus INBFF (Portadr.);
				 rl0:=1.Zeichen nach Portadr. ungleich Space
				      (Datentyp)!
	ld	r6, r3		!r6:=Portadresse!
	clr	r7		!r7=Datentyp:=0 (Datentyp 'WORD')!
	jr	z, PORWS1
	cpb	rl0, #'W'
	jr	z, PORWS2
	cpb	rl0, #'B'
	jp	nz, ERROR

PORWS1:
	ldk	r7, #1

PORWS2:
	ld	r5, #PORT_BF
	add	r5, r7		!r5:=Adresse, wo gelesener Portinhalt abge-
				 speichert werden soll (=#PORT_BF bei 'WORD'-
				 bzw. =#PORT_BF+1 bei 'BYTE'-Lesen)!
	ld	r3, PORT_I	!r3:=Adresse der PORT-I-Routine!
	call	@r3		!PORT LESEN!
	ld	r1, PORT_BF
	ld	r5, r6		!r5:=Portadresse!
	call	BTOH16		!Portadresse IN OUTBFF EINTRAGEN!
	inc	OUTPTR, #1	!1 Leerzeichen in OUTBFF eintragen!
	ld	r5, r1		!r5:=gelesener Portinhalt!
	bit	r7, #%0
	jr	nz, PORE2	!Datentyp 'BYTE'!
	call	BTOH16		!gelesenes Datenwort in OUTBFF eintragen!
	jr	PORE3
PORE2:
	call	BTOH8		!gelesenes Datenbyte in OUTBFF eintragen!
PORE3:
	inc	OUTPTR, #1	!1 Leerzeichen in OUTBFF eintragen!
	call	WR_OUTBFF
	call	RD_DATA
	jr	PORWS5
POWR_LOOP:
	call	GET_DATA
PORWS5:
	ret	c
	ret	z
	ldctlb	rl0, FLAGS	!Stand Z-Flag retten!

	ld	r5, #PORT_BF
	ld	@r5, r3		!an Port auszugebenden Datenwert in #PORT_BF
				 abspeichern!
	add	r5, r7		!r5:=Adresse, wo auszugebender Datenwert steht
				 (=#PORT_BF bei 'WORD'/=#PORT_BF+1 bei 'BYTE')!
	ld	r3, PORT_O	!r3:=Adresse der PORT-O-Routine!
	call	@r3		!PORT SCHREIBEN!

	bitb	rl0, #4		!Z-Flag testen!
	ret	nz		!Z-Flag war nach GET_HEXZ gesetzt, d.h. CR
				 wurde gelesen, d.h. keine weiteren Daten-
				 werte vorhanden!
	jr	POWR_LOOP
    end PORT_RW_SPECIAL
!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE P_IN
Normal-Port-Input
Input:	r7 - einzulesender Datentyp (0-'WORD' / 1-'BYTE')
	r5 - Adresse, wo gelesener Portinhalt abgespeichert werden soll
	r6 - Portadresse
Output:	auf urspruenglicher Adresse r5 - gelesener Portinhalt
zerstoerte Register:	r3, r5
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    P_IN procedure
      entry
	bit	r7, #%0
	jr	nz, P_INB
	ini	@r5, @r6, r3	!Normal Input ('WORD')!
	ret
P_INB:
	inib	@r5, @r6, r3	!Normal Input ('BYTE')!
	ret
    end P_IN

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE PS_IN
Special-Port-Input
Input:	r7 - einzulesender Datentyp (0-'WORD' / 1-'BYTE')
	r5 - Adresse, wo gelesener Portinhalt abgespeichert werden soll
	r6 - Portadresse
Output:	auf urspruenglicher Adresse r5 - gelesener Portinhalt
zerstoerte Register:	r3, r5
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    PS_IN procedure
      entry
	bit	r7, #%0
	jr	nz, PS_INB
	sini	@r5, @r6, r3	!Special Input ('WORD')!
	ret
PS_INB:
	sinib	@r5, @r6, r3	!Special Input ('BYTE')!
	ret
    end PS_IN

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE P_OUT
Normal-Port-Input
Input:	r7 - auszugebender Datentyp (0-'WORD' / 1-'BYTE')
	r5 - Adresse, auf der der auszugebende Datenwert abgespeichert ist
	r6 - Portadresse
zerstoerte Register:	r3, r5
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    P_OUT procedure
      entry
	bit	r7, #%0
	jr	nz, P_OUTB
	outi	@r6, @r5, r3	!Normal Output ('WORD')!
	ret
P_OUTB:
	outib	@r6, @r5, r3	!Normal Output ('BYTE')!
	ret
    end P_OUT

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE PS_OUT
Special-Port-Output
Input:	r7 - auszugebender Datentyp (0-'WORD' / 1-'BYTE')
	r5 - Adresse, auf der der auszugebende Datenwert abgespeichert ist
	r6 - Portadresse
zerstoerte Register:	r3, r5
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    PS_OUT procedure
      entry
	bit	r7, #%0
	jr	nz, PS_OUTB
	souti	@r6, @r5, r3	!Special Output ('WORD')!
	ret
PS_OUTB:
	soutib	@r6, @r5, r3	!Special Output ('BYTE')!
	ret
    end PS_OUT

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE REGISTER
REGISTER-Routine (Monitorkommando)
Registerinhalte anzeigen und veraendern

Kommandoeingabe: R [ [R]0,...,[R]15; [R]L0,...,[R]L7; [R]H0,...,[R]H7;
                     RR0, RR2, RR4, RR6, RR8, RR10, RR12, RR14;
                     [R]PC, FC, [R]RF, [R]N4, [R]N5, [R]PS, [R]PO ]
(wenn keine Parameter angegeben, dann Anzeige aller Register)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    REGISTER procedure
      entry
	call	GET_SIGN	!rl0:=1.Zeichen ungleich Space aus INBFF!
	jp	z, ALL_RG	!keine Parameter angegeben -->
				 alle Registerinhalte ausgeben!
	cpb	rl0, #'R'
	jr	nz, RG1		!1. Zeichen beginnt nicht mit 'R'!

	call	GET_CHR		!rl0 := 2. Zeichen!
	jr	z, R_ERROR_Z	!kein weiteres Zeichen angegeben!

	cpb	rl0, #'F'
	jr	z, REG1		!2. Zeichen ungleich 'F'!

RG1:
	clr	r6		!r6=0 bei 'RL'-Register!
	cpb	rl0, #'L'
	jr	z, R_L
	inc	r6, #%02	!r6=2 bei 'RH'-Register!
	cpb	rl0, #'H'
	jr	z, R_L
	inc	r6, #%04	!r6=6 wenn nicht 'RL', 'RH' oder 'RR'-Reg.!
	cpb	rl0, #'R'
	jr	nz, RG5		!kein 'RL', 'RH', 'RR'-Register!
	dec	r6, #%02	!r6=4 bei 'RR'-Register!
	jr	R_L
REG1:
	ldb	rh1,#'R'	!1. Zeichen bei 'RF'!
	jr	RG6
R_L:
	call	GET_CHR		!rl0:=naechstes Zeichen
				 (=Registernummer 0-15, 1.Zeichen)!
R_ERROR_Z:
	jp	z, ERROR	!keine Registernummer angegeben!
RG5:
	ldb	rh1, rl0	!rh1:=Registerbez. (siehe R_BEZ) 1. Zeichen!
	call	GET_CHR		!rl0 := 2. Zeichen der Registerbez.!
	jr	nz, RG6		!2. Zeichen des Registerbezeichnung vorh.!

	ldb	rl0, #' '	!nur einzeichige Registerbezeichnung!
RG6:
	ldb	rl1, rl0	!rl1:=Registerbez. (siehe R_BEZ) 2. Zeichen!
	ld	r7, #%0018
	ld	r8, #R_BEZ + 46
	cpdr	r1, @r8, r7, z	!Registerbez. (in r1) in Tabelle R_BEZ suchen!
R_ERROR_NZ:
	jp	nz, ERROR	!Falsche Registerbezeichnung!

	inc	r8, #%02	!r8 zeigt auf Reg.-bez.!
	add	r7, r7		!r7:= rel. Adr. bzgl. R_BEZ!
	cpb	rl6, #%04
	jr	c, RG17		!'RL' bzw. 'RH'-Reg.!
	jr	z, RG13		!'RR'-Reg.!

!Schleife fuer {kein RL*, RH*, RR* - Register}!

!ab aktuellen Register werden die Register entsprechend der Tabelle R_BEZ
 abgearbeitet (Anzeige Inhalt + Dateneingabe)!

RG8:
	ld	r1, #'R '
	call	PUT_2CHR
	dec	OUTPTR, #1
	ld	r1, @r8
	call	PUT_2CHR
	inc	OUTPTR, #1
	ld	r5, SV_R(r7)
	call	WR_R5_RDDATA
	ret	c		!'Q' eingegeben!
	jr	z, RG12
	ld	r2, @r8
	cp	r2, #'PC'
	jr	nz, RG9
	res	r3, #%0
	jr	RG11

RG9:
	cp	r2, # 'RF'
	jr	nz, RG10
	ldctl	REFRESH, r3
RG10:
	cp	r2, #'SG'
	jr	nz, RG11
	cpb	rh3, #%0
	jr	nz, RG11
	ldb	rh3, rl3
	clrb	rl3
RG11:
	ld	SV_R(r7), r3
RG12:
	inc	r7, #%02
	inc	r8, #%02
	cp	r8, #R_BEZ + 47
	jr	c, RG8
	ret			!alle Register abgearbeitet!


!Schleife fuer RR* - Register!

!ab aktuellen Register werden alle Register in der Reihenfolge
 RR0 ... RR14 abgearbeitet!

RG13:
	cp	r8, #R_BEZ + 30
	jr	nc, R_ERROR_NC

	cpb	rl1, #' '
	jr	z, RG14		!einzeichige Registerbezeichnung!
	bit	r1, #%0
	jr	RG_ERR
RG14:
	bit	r1, #%08
RG_ERR:
	jr	nz, R_ERROR_NZ	!Registerbezeichnung nicht gerade (0-14)!
RG15:
	ld	r1, #'RR'
	call	PUT_2CHR
	ld	r1, @r8
	call	PUT_2CHR
	inc	OUTPTR, #1
	ld	r5, SV_R(r7)
	call	BTOH16
	ld	r5, SV_R + 2(r7)
	call	WR_R5_RDDATA
	ret	c		!'Q' eingegeben!
	jr	z, RG16
	ld	SV_R(r7), r2
	ld	SV_R + 2(r7), r3
RG16:
	inc	r7, #%04
	inc	r8, #%04
	cp	r8, #R_BEZ + 31
	jr	c, RG15
	ret			!alle Register abgearbeitet!

!Schleife fuer RL* bzw. RH* - Register!

!ab aktuellen Register werden alle Register in der Reihenfolge
 RH0, RL0,...,RH7, RL7 abgearbeitet!

RG17:
	cp	r8, #R_BEZ + 16
R_ERROR_NC:
	jp	nc, ERROR

	test	r6
	jr	nz, RG18
	inc	r7, #1
RG18:
	ld	r1, R_LH(r6)	!r1:=Registerbezeichnung (RH bzw. RL)!
	call	PUT_2CHR
	ld	r1, @r8
	call	PUT_2CHR
	ldb	rl5, SV_R(r7)
	call	BTOH8
	inc	OUTPTR, #1
	call	WR_OBF_RDDATA
	ret	c
	jr	z, RG19
	ldb	SV_R(r7), rl3
RG19:
	inc	r7, #1
	dec	r6, #%02
	jr	z, RG18
	inc	r6, #%04
	inc	r8, #%02
	cp	r8, #R_BEZ + 16
	jr	c, RG18
	ret			!alle Register angegeben!

!Alle Registerinhalte anzeigen!

ALL_RG:
	calr	WR_REGBEZ1
	CALR	WR_WERTE1
	CALR	WR_REGBEZ2
	jp	WR_WERTE2
    end REGISTER

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE WR_REGBEZ1
Ausgabe der Registerbezeichnungen 1. Zeile
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    WR_REGBEZ1 procedure
      entry
	ldk	r0, #%0C
	ld	r4, #R_BEZ
	ldk	r6, #%08
	ld	r8, #R_BEZ + 30
L_B1:
	ld	r3, OUTPTR
	ldb	OUTBFF(r3), #'R'
L_B2:
	inc	OUTPTR, #1
	ld	r1, @r4
	call	PUT_2CHR
	dec	r0, #1
	jp	z, WR_OUTBFF_CR
	dec	r6, #1
	jr	nz, L_B3
	ld	r4, r8
L_B3:
	inc	r4, #%02
	cp	r6, #0
	jr	gt, L_B4
	inc	OUTPTR, #%04
	jr	L_B2
L_B4:
	inc	OUTPTR, #%02
	jr	L_B1
    end WR_REGBEZ1

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE WR_REGBEZ2
Ausgabe der Registerbezeichnungen 2. Zeile
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    WR_REGBEZ2 procedure
      entry
	ldk	r0, #%0C
	ld	r4, #R_BEZ + 16
	ld	r8, #R_BEZ + 38
	ldk	r6, #%08
	jr	L_B1
    end WR_REGBEZ2

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE WR_WERTE1
Ausgabe der Registerwerte 1. Zeile
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    WR_WERTE1 procedure
      entry
	ldk	r2, #%0C
	ld	r6, #SV_R
	ldk	r8, #%08
	ld	r10, #SVSTK + 2
L_W1:
	ld	r5, @r6
	call	BTOH16
	dec	r2, #1
	jp	z, WR_OUTBFF_CR
	dec	r8, #1
	jr	nz, L_W2
	ld	r6, r10
L_W2:
	inc	r6, #%02
	cp	r8, #0
	jr	gt, L_W3
	inc	OUTPTR, #%03
	jr	L_W1
L_W3:
	inc	OUTPTR, #1
	jr	L_W1
    end WR_WERTE1

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE WR_WERTE2
Ausgabe der Registerwerte 2. Zeile
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    WR_WERTE2 procedure
      entry
	ldk	r2, #%0C
	ld	r6, #SV_R + %10
	ldk	r8, #%08
	ld	r10, #RF_CTR
	jr	L_W1
    end WR_WERTE2

end p_comm
