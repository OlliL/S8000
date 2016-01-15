!******************************************************************************
*******************************************************************************

  S8000-Firmware
  Z8000-Softwaremonitor (CPU)        Modul: p_serial

  Bearbeiter:	O. Lehmann
  Datum:	11.01.2016
  Version:	2.2

*******************************************************************************
******************************************************************************!

p_serial module

$SECTION PROM

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
System Calls
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!

  CONSTANT
SC_SEGV			:= %01

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
spezielle ASCII-Zeichen
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!

  CONSTANT
BS	:= %08
LF	:= %0A
CR	:= %0D
ESC	:= %1B

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Hardwareadressen
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!

  CONSTANT

SIO0	:= %FF81
SIO0D_A	:= SIO0 + 0
SIO0D_B	:= SIO0 + 2
SIO0C_A	:= SIO0 + 4
SIO0C_B	:= SIO0 + 6

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE RD_DATA
Dateneingabe (PROMT-Zeichen ('?') ausgeben, eingegebene Zeile aus PTYBFF 
             in INBFF speichern, auf Terminal ausgeben und 1. Datenwert der 
             Zeile auswerten)
Output:	rr2  enthaelt Datenwert
	Z=1, wenn keine Dateneingabe erfolgte bzw. 'Q' oder '-' eingegeben
	C=1, wenn 'Q' oder '-' eingegeben (rl0 enthaelt dann 'Q' oder '-')
	Z=0, wenn Dateneingabe erfolgte (rr2 enthaelt dann Datenwert) mit:
	     P/V=1, wenn CR nach Datenwert,
	     C=0,   wenn Space nach Datenwert
	INPTR zeigt auf 2 Zeichen nach der letzten Ziffer des Datenwertes
Fehler, wenn ungueltige Hexazahl eingegeben wurde
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    RD_DATA procedure
      entry
	ldb	rl0, #'?'
	calr	TYWR		!Ausgabe ':' auf Terminal!
	calr	RD_LINE_INBFF	!Zeile aus PTYBFF in INBFF speichern und
				 auf Terminal ausgeben!
    end RD_DATA			!Weiterlauf in GET_DATA!

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE GET_DATA
Dateneingabe (Einlesen des naechsten Datenwertes aus Eingabepuffer INBFF)
Input:	INPTR zeigt auf das erste auszuwertende Zeichen des Datenwertes
	bzw. auf Space davor
Output:	rr2  enthaelt Datenwert
	Z=1, wenn keine Dateneingabe erfolgte bzw. 'Q' oder '-' eingegeben
	C=1, wenn 'Q' oder '-' eingegeben (rl0 enthaelt dann 'Q' oder '-')
	Z=0, wenn Dateneingabe erfolgte (rr2 enthaelt dann Datenwert) mit:
	     P/V=1, wenn CR nach Datenwert,
	     C=0,   wenn Space nach Datenwert
	INPTR zeigt auf 2 Zeichen nach der letzten Ziffer des Datenwertes
Fehler, wenn ungueltige Hexazahl eingegeben wurde
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    GET_DATA procedure
      entry
	clr	r2
	clr	r3
	call	GET_SIGNW	!rl0:=1. Zeichen des Datenwertes!
	ret	z		!Z=1, kein Datenwert (CR)!

	cpb	rl0, #'Q'	!QUIT ? !
	jr	z, K_Q
	cpb	rl0, #'-'
	jr	nz, K_LOOP
K_Q:
	setflg	c
	ret			!Z=1, C=1: 'Q' oder '-' eingegeben!

K_LOOP:
	call	HTOB		!Konv. rl0 (Hexa-ASCII) --> rl0 (binaer)!
	jp	c, ERROR	!keine Hexaziffer!

	rldb	rl0, rl3
	rldb	rl0, rh3
	rldb	rl0, rl2
	rldb	rl0, rh2	!Hexaziffer (binaer) in rr2 schieben!
	call	GET_CHR		!rl0:=naechstes Zeichen aus INBFF!
	jr	nz, K_1		!kein CR!

	setflg	p, v
	jr	K_END		!Z=0, P/V=1, wenn CR nach Datenwert!
K_1:
	cpb	rl0, #' '
	jr	nz, K_LOOP	!naechste Ziffer des Datenwertes!

	resflg	c		!Z=0, C=1, wenn Space nach Datenwert!
K_END:
	resflg	z
	ret	
    end GET_DATA

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE RD_LINE_BFF
Zeile aus Interrupt-Eingabepuffer PTYBFF lesen, in Zwischenpuffer abspeichern
und auf Terminal ausgeben
Input:	r1 - max. Zeilenlaenge
	r2 - Anfangsadresse Zwischenpuffer
Output: r1 - Anzahl der uebertragenen Zeichen
	r2 - zeigt auf Zeilenende
	Z=1, wenn max. Zeilenlaenge erreicht wurde
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    RD_LINE_BFF procedure
      entry
	ld	MAXLEN, r1
RDL_NEU:
	clr	r1
RDL_LOOP:
	calr	TYRDWR		!ZEICHEN  LESEN UND AUSGEBEN!
	bitb	FLAG1, #%03	!NUR GROSSBUCHSTABEN ERLAUBT ?!
	jr	nz, RDL_TST	!nein!
	cpb	rl0, #'a'
	jr	c, RDL_TST
	cpb	rl0, #'{'
	jr	nc, RDL_TST
	resb	rl0, #%05	!KLEINBUCHST. IN GROSSBUCHST. WANDELN !

RDL_TST:
	ldb	r2(r1), rl0	!Zeichen in Zwischenpuffer abspeichern!
	cpb	rl0, CHRDEL
	jr	z, _CL
	cpb	rl0, LINDEL
	jr	z, _CR
	cpb	rl0, #CR
	jr	z, RDL_END
	inc	r1, #%01
	cp	r1, MAXLEN	!MAXIMALE ZEILENLAENGE ERREICHT ?!
	JR	C,RDL_LOOP	!SPRUNG WENN NICHT!
	setflg	z
	ret	
_CL:
	calr	CLRCHR
	jr	pl, RDL_LOOP
	ldb	rl0, #%5b	!PROMT-Zeichen '['!
	calr	TYWR
	jr	RDL_NEU		!ZEILE NEU EINGEBEN!
_CR:
	test	r1		!EINGEGEBEN ZEICHENKETTE LOESCHEN!
	jr	z, RDL_LOOP
	ldb	rl0, #BS
	calr	TYWR
	calr	CLRCHR
	jr	_CR
RDL_END:
	ldb	rl0, #LF
	calr	TYWR
	lda	r2, r2(r1)	!R2 AUF Zeilenende STELLEN!
	resflg	z
	ret	
    end RD_LINE_BFF

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE CLRCHR
Loeschen eines Zeichens
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    CLRCHR procedure
      entry
	ldb	rl0, #' '
	calr	TYWR
	ldb	rl0, #BS
	calr	TYWR
	dec	r1, #%01
	ret	
    end CLRCHR

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE TYRDWR
Einlesen eines Zeichens aus Interrupt-Eingabepuffer (PTYBFF) und
Ausgabe auf Terminal
Output:	rl0 - eingelesenes Zeichen
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  INTERNAL
    TYRDWR procedure
      entry
	calr	TYRD
	calr	TYWR
	ret
    end TYRDWR

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE TYRD
Einlesen eines Zeichens aus Interrupt-Eingabepuffer PTYBFF
Output:	rl0 - eingelesenes Zeichen
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!

  GLOBAL
    TYRD procedure
      entry
TYRD1:	testb	COUNT_PTY	!Zeichen in PTYBFF vorhanden?!
	jr	z, TYRD1	!nein --> warten bis Zeichen empfangen wird!
	push	@r15, r2	
	ld	r0, OUTPTR_PTY
	calr	INCPTR		!Ausgabezeiger fuer PTYBFF incr.!
	ld	OUTPTR_PTY, r0
	ldb	rl0, PTYBFF(r2)	!rl0 := Zeichen aus PTYBFF!
	decb	COUNT_PTY, #%01 !Zeichenzaehler decr.!
	pop	r2, @r15
	ret	
    end TYRD

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE TYWR
Ausgabe eines Zeichens auf Terminalkanal 
(im Pollingbetrieb - Interruptbetrieb moeglich)
Input:	rl0 - Zeichen
Output:	Z=1, wenn Zeichen = CR
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    TYWR procedure
      entry
	bitb	FLAG0, #%02	!Terminal gesperrt?!
	jr	nz, TYWR	!ja!

	inb	rh0, SIO0C_B
	bitb	rh0, #%02	!Sendepuffer leer?!
	jr	z, TYWR		!nein!

	outb	SIO0D_B, rl0	!Datenbyte ausgeben!

	cpb	rl0, #CR	!Z=1, wenn Zeichen CR war!
	ret	
    end TYWR

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE WR_CRLF
Ausgabe CR LF auf Terminal
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    WR_CRLF procedure
      entry
	ldb	rl0, #CR
	calr	TYWR
	ldb	rl0, #LF
	calr	TYWR
	jp	WR_NULL
    end WR_CRLF

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE RD_LINE_INBFF
Einlesen einer Kommandozeile bis CR aus Interrupt-Eingabepuffer (PTYBFF) in
Eingabepuffer (INBFF) und Ausgabe auf Terminal
Output: rl0 - 1. Zeichen der Eingabezeile ungleich Space
	INPTR zeigt auf dieses Zeichen
	Z=1, wenn dieses Zeichen = CR
Fehler, wenn Zeile laenger als 128 Zeichen
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    RD_LINE_INBFF procedure
      entry
	ld	r2, #INBFF
	ld	r1, #%80	!MAXLEN LADEN!
	ld	INPTR, #0	!EINGABEZEIGER LOESCHEN!
	calr	RD_LINE_BFF	!Zeile aus PTYBFF in INBFF speichern und
				 auf Terminal ausgeben!
	jp	z, ERROR	!Pufferende erreicht!

	call	GET_SIGNW	!rl0:=1.Zeichen aus INBFF ungleich Space!
	dec	INPTR, #%01	!INPTR zeigt auf dieses Zeichen!
	cpb	rl0, #CR	!Z=1, wenn Zeichen = CR!
	ret	
    end RD_LINE_INBFF

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE INCPTR
Pufferzeiger (der Puffer PTYBFF bzw. UDOSBFF) inkrementieren 
und auf Ueberlauf testen
Input:	r0 - Pufferzeiger 
Output: r2 := r0 (alter Stand des Pufferzeigers)
	r0 := r0 + 1, wenn C=1, d.h. r0+1 < 256
	r0 := 0, wenn C=0, d.h. r0+1 >= 256
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
  GLOBAL
    INCPTR procedure
      entry
	ld	r2, r0
	inc	r0, #%01
	cp	r0, #%0100
	ret	c
	clr	r0
	ret	
    end INCPTR

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE PTY_INT
VI-Routine fuer Dateneingabe vom Terminalkanal SIO0_B des 16-Bit-Teils;
Abspeicherung des Zeichens im Interrupt-Eingabepuffer PTYBFF;
Aktualisierung von INPTR_PTY und COUNT_PTY;
Test auf Sonderzeichen (^S, ^Q, ESC) bei Terminaleingaben
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!

  GLOBAL
    PTY_INT procedure
      entry
	push	@r15, r0
	push	@r15, r1
	push	@r15, r2
!bei erster TerminaleingabeNMI-Entry in PSAREA aendern und PROMT setzen!
	cp	PSA_NMI+6, #AUTOBOOT	!NMI_ENTRY in PSAREA:
					- nach RESET steht dort #AUTOBOOT, d.h.
					  bei NMI erfolgt Abarbeitung von
					  #AUTOBOOT
					- nach Eingabe des ersten Zeichens vom
					  Terminal (Abarbeitung von PTY_INT oder
					  KOPPEL_INT) bzw. nach Abarbeitung
					  von #AUTOBOOT wird #AUTOBOOT durch
					  #NMI_INT ersetzt, d.h. bei NMI erfolgt
					  jetzt Abarbeitung von #NMI_INT !
	jr	nz, PTY_RD
	ld	PROMT, #'[ '	!Promt-Zeichen eintragen (d.h. die Zelle PROMT
				 wird erst nach der 1. Zeicheneingabe geladen)!
	ld	PSA_NMI+6, #NMI_INT	!#AUTOBOOT durch #NMI_INT ersetzen in
					 PSAREA!
!Zeichen vom SIO einlesen!
PTY_RD:
	inb	rl1, SIO0D_B	!Zeichen vom SIO einlesen!
!Test, ob eingelesenes Zeichen vom Terminalkanal als ASCII-Zeichen oder
 als beliebiges Datenbyte zu interpretieren ist!	
	bitb	FLAG0, #%00
	jr	nz, PTY_WR	!keine ASCII-Zeichen einzulesen
				--> Zeichen in PTYBFF abspeichern!
	resb	rl1, #%07	!RES BIT7 DES ASCII-ZEICHENS!
!Test auf ^Q!
	cpb	rl1, XONCHR	!Test auf ^Q (Terminalausgabe nicht gesperrt)!
	jr	nz, PTY1	!Zeichen nicht ^Q!
	resb	FLAG0, #%02	!Bit2/FLAG0=0: Terminalausgabe nicht gesperrt!
	jr	PTYEND
!Test auf ^S!
PTY1:
	cpb	rl1, XOFCHR	!Test auf ^S (Terminalausgabe gesperrt)!
	jr	nz, PTY2	!Zeichen nicht ^S!
	setb	FLAG0, #%02	!Bit2/FLAG0=1: Terminalausgabe nicht gesperrt!
	jr	PTYEND
!Test auf ESC!
PTY2:
	cpb	rl1, #ESC	!Test auf ESC (Abbruchtaste)!
	jr	nz, PTY_WR	!Zeichen nicht ESC!
	bitb	FLAG0, #%03	!wenn Bit3/FLAG0 und Bit4/FLAG0 = 0, dann
				 wird ESC als normales ASCII-Zeichen in PTYBFF
				 abgespeichert und nicht als Abbruchtaste
				 behandelt!
	jr	nz, PTY3
	bitb	FLAG0, #%04
	jr	z, PTY_WR	!ESC in PTYBFF eintragen!
!ESC als Abbruchtaste behandeln!
PTY3:	setb	FLAG0, #%05	!Bit5/FLAG0=1: Abbruchtaste gedrueckt!
	jr	PTYEND
!Zeichen in PTYBFF abspeichern!
PTY_WR:
	ld	r0, INPTR_PTY
	calr	INCPTR		!r2:=r0; r0:=ro+1!
	ld	INPTR_PTY, r0	!incr Eingabezeiger (Zeiger zum naechsten
				 freien Platz in PTYBFF)!
	ldb	PTYBFF(r2), rl1	!Zeichen in PTYBFF abspeichern!
	incb	COUNT_PTY, #%01	!Zeichenzaehler incr.!
!SIO ruecksetzen!
PTYEND:
	ldb	rl1, #%38	!RETI an SIO ausgeben!
	outb	SIO0C_A, rl1

	pop	r2, @r15
	pop	r1, @r15
	pop	r0, @r15
	sc	#SC_SEGV
	nop	
	iret	
    end PTY_INT

end p_serial  
