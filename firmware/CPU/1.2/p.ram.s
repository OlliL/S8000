!******************************************************************************
*******************************************************************************

  S8000-Firmware
  Z8000-Softwaremonitor (CPU)        Modul: p_ram

  Bearbeiter:	O. Lehmann
  Datum:	14.01.2016
  Version:	1.2

*******************************************************************************
******************************************************************************!

p_ram module

$SECTION RAM

$ABS %4000

!******************************************************************************
Arbeitsspeicher
******************************************************************************!

GLOBAL

!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!

RAM_ANF

		ARRAY [%10 WORD]
NSP_OFF		WORD
	
		ARRAY [%3F WORD]	!Stackbereich!
STACK		WORD

		ARRAY [13 BYTE]

KONV		BYTE			!Hilfsbyte zur Konvertierung!
INBFF		ARRAY [%80 BYTE]	!Eingabepuffer!
OUTBFF		ARRAY [%80 BYTE]	!Ausgabepuffer!
PTYBFF		ARRAY [%100 BYTE]	!Eingabepuffer fuer interrupt-
					 gesteuerte Eingabe vom Terminal-
					 kanal!
MCZBFF		ARRAY [%0EA BYTE]	!Ein-/Ausgabepuffer fuer LOAD/SEND!
MAXLEN		WORD			!maximale Zeilenlaenge!
INPTR		WORD			!Zeiger fuer Eingabepuffer INBFF!
OUTPTR		WORD			!Zeiger fuer Ausgabepuffer OUTBFF 
		                         (Pufferlaenge)!
COUNT_PTY	WORD			!aktuelle Anzahl der Zeichen in PTYBFF!
INPTR_PTY	WORD			!Eingabezeiger fuer PTYBFF
					 (naechster freier Platz)!
OUTPTR_PTY	WORD			!Ausgabezeiger fuer PTYBFF
					 (naechstes auszulesende Zeichen)!
INPTR_MCZ	WORD			!Eingabezeiger fuer MCZBFF!
OUTPTR_MCZ	WORD			!Ausgabezeiger fuer MCZBFF!
B_WORD		WORD			!Speicherinhalt auf der BREAK-Adresse!
B_ADR_S		WORD			!Segmentnummer der BREAK-Adresse!
B_ADR_O		WORD			!Offset der BREAK-Adresse!
RR14_V		LONG			!VARIABLER STACK, FUER NEXT UND BREAK!
W23B4		WORD
FCW_V		WORD			!VARIABLES FCW FUER NEXT UND BREAK!
PORT_BF		WORD			!Puffer fuer gelesenen bzw. zu
					 schreibenden PORT-Datenwert!	
PORT_I		WORD			!Adresse des PORT-I-Programms!
PORT_O		WORD			!Adresse des PORT-O-Programms!
SV_R		ARRAY [14 WORD]		!Registerrettungsbereich!
SVSTK		LONG
PC_SEG		WORD			!Programmcounter (Segmentnummer)!
PC_OFF		WORD			!Programmcounter (Offsetadresse)!
FCW_		WORD			!FCW im Registerrettungsbereich!
RF_CTR		WORD			!Merker: Refresh Control Register!
N4_		WORD			!Normalstack R14!
N5_		WORD			!Normalstack R15!
PS_		WORD			!Program-Status-Area Segment!
PO_	 	WORD			!Program-Status-Area Offset!
		WORD			!unbenutzt!
!43f0!
FLAG0	BYTE

!
7 6 5 4 3 2 1 0
              0-> 0: empf. Zeichen vom Terminalkanal ist ASCII-Zeichen 
		     (Reset Bit 7 des Zeichens, Test auf ^S, ^Q, ESC)
                  1: empf. Zeichen vom Terminalkanal ist beliebiges Datenbyte
		     (keine Sonderbehandlung)
                  P: ENTRY(0), PTY_INT(T), KOPPEL_INT(T), QUIT(1), 
		     NMI_INT(T/0), MCZ_INT(T), RM_BOOT(0)
            1---> 0:
                  1:
                  P: ENTRY(1)
          2-----> 0: Ausgabe an Terminal nicht gesperrt (^Q)
                  1: Ausgabe an Terminal gesperrt (^S)
                  P: ENTRY(1), TYWR(T), PTY_INT(0,1), KOPPEL_INT(0,1)
        3-------> 0: und gleichzeitig Bit4/FLAG0=0: ESC wirkt nicht als
                     Abbruchtaste, sondern ist normales ASCII-Zeichen
                  1: ESC wirkt als Abbruchtaste
                     (Bit5/FLAG0 wird bei Eingabe von ESC gesetzt)
                  P: ENTRY(0), PTY_INT(T)
      4---------> 0: und gleichzeitig Bit3/FLAG0=0: ESC wirkt nicht als
                     Abbruchtaste, sondern ist normales ASCII-Zeichen
                  1: ESC wirkt als Abbruchtaste
                     (Bit5/FLAG0 wird bei Eingabe von ESC gesetzt)
                  P: ENTRY(0), PTY_INT(T), KOPPEL_INT(T), LOAD(1)
    5-----------> 0: Abbruchtaste nicht gedrueckt
                  1: Abbruchtaste gedrueckt (ESC)
                  P: ENTRY(0), PTY_INT(1), KOPPEL_INT(1), LOAD(T), SAW_MCZ(T)
  6-------------> 0:
                  1:
                  P: ENTRY(0)
7---------------> 0:
                  1:
                  P: ENTRY(0)
!


!43f1!
FLAG1	BYTE

!
7 6 5 4 3 2 1 0
              0-> 0: keine Segmentnummer angegeben (???)
                  1: Segmentnummer angegeben (???)
                  P: ENTRY(0), GET_SGNR(0,1)
            1---> 0: noch Parameter einlesen
                  1: alle Parameter eingelesen
                  P: ENTRY(0), DISPLAY (0,1,T)
          2-----> 0: kein NEXT-Betrieb
                  1: NEXT-Betrieb
                  P: ENTRY(0,T/0), NEXT(1)
        3-------> 0: nur Grossbuchstaben erlaubt
                     (Kleinbuchstaben werden in Grossbuchstaben umgewandelt)
                  1: Klein- und Grossbuchstaben erlaubt
                  P: ENTRY(1), RD_LINE_BFF(T)
      4---------> 0: Ausgabe bei CR abbrechen
                  1: Ausgabe nicht bei CR abbrechen
                  P: ENTRY(0), WR_OUTBFF(T)
    5-----------> 0:
                  1:
                  P: ENTRY(0)
  6-------------> 0:
                  1:
                  P: ENTRY(0)
7---------------> 0:
                  1:
                  P: ENTRY(0)
!

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Variablen (initialisiert bei Systemstart)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!

!43f2!
CHRDEL	BYTE		!Zeichen loeschen (Backspace %08)!
!43f3!
LINDEL	BYTE		!Zeile loeschen (Line delete %7F)!
!43f4!
XONCHR	BYTE		!Terminalausgabe fortsetzen (^Q %11)!
!43f5!
XOFCHR	BYTE		!Terminalausgabe anhalten (^S %13)!
!43f6!
NULLCT	WORD		!Anzahl der Nullen nach CR bei Terminalausgabe (%0000)!
!43f8!
B_CODE	WORD		!Unterbrechungscode Z8000 (7F00)!
!43fa!
STKCTR	WORD		!Zaehler der Stackoperationen fuer NEXT (%0004)!
!43fc!
NXTCTR	WORD		!SCHRITTZAEHLER FUER NEXT (%0001)!
!43fe!
PROMT	WORD		!Promt-Zeichen (%2000)!

!4400!
PSAREA	ARRAY [4 WORD]
	ARRAY [4 WORD]
	ARRAY [4 WORD]
	ARRAY [4 WORD]
	ARRAY [4 WORD]

PSA_NMI	
	ARRAY [4 WORD]
	ARRAY [4 WORD]
	ARRAY [4 WORD]
	ARRAY [4 WORD]
VI_CTC0_3
	ARRAY [%15C WORD]

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Arbeitsspeicher fuer Kommando "T" (Hardwareeigentest)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!

RG_FELD		ARRAY [%1A WORD]	!Feld zur Registerrettung!
REM_MMU_BCSR	BYTE	!Merker: Inhalt BUS CYCLE STATUS REGISTER!
		BYTE	!Merker: Inhalt VIOLATION TYPE REGISTER!
REM_MMU_ID	WORD	!Merker: MMU-Identifikation!
ECC_MEM_3	WORD	!Merker: Stand Fehlerzaehler!
REM_ERR_CNT	WORD	!Merker: Stand Fehlerzaehler!
REM_MMU_SINOUT	WORD	!Merker: MMU-Ein-/Ausgabewerte!
ERR_CNT		WORD	!Fehlerzaehler!
MAX_SEGNR	WORD	!Merker: hoechste vorhandene Segmentnummer!
POW_UP_TXT	WORD
PRT_POW_UP_TXT	WORD
ERRPAR_ID	WORD
ABOOT_DEV	WORD
ECC_MEM_1	LONG
REM_MMU_TEST	WORD
ECC_MEM_2	WORD
UKNOW_MEM_1	WORD
UKNOW_MEM_2	WORD
UKNOW_MEM_3	WORD
UKNOW_MEM_5	WORD
MMU_MEM_1	LONG
MMU_MEM_2	LONG
MMU_MEM_3	LONG
MMU_MEM_4	LONG
MMU_MEM_5	WORD
MMU_MEM_6	WORD

end p_ram
