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

!%4000!
RAM_ANF

		ARRAY [%10 WORD]
!%4020!
NSP_OFF		WORD
	
		ARRAY [%3F WORD]	!Stackbereich!
!%40a0!
STACK		WORD

		ARRAY [13 BYTE]

!%40af!
KONV		BYTE			!Hilfsbyte zur Konvertierung!
!%40b0!
INBFF		ARRAY [%80 BYTE]	!Eingabepuffer!
!%4130!
OUTBFF		ARRAY [%80 BYTE]	!Ausgabepuffer!
!%41b0!
PTYBFF		ARRAY [%100 BYTE]	!Eingabepuffer fuer interrupt-
					 gesteuerte Eingabe vom Terminal-
					 kanal!
!%42b0!
MCZBFF		ARRAY [%0EA BYTE]	!Ein-/Ausgabepuffer fuer LOAD/SEND!
!%439a!
MAXLEN		WORD			!maximale Zeilenlaenge!
!%439c!
INPTR		WORD			!Zeiger fuer Eingabepuffer INBFF!
!%439e!
OUTPTR		WORD			!Zeiger fuer Ausgabepuffer OUTBFF 
		                         (Pufferlaenge)!
!%43a0!
COUNT_PTY	WORD			!aktuelle Anzahl der Zeichen in PTYBFF!
!%43a2!
INPTR_PTY	WORD			!Eingabezeiger fuer PTYBFF
					 (naechster freier Platz)!
!%43a4!
OUTPTR_PTY	WORD			!Ausgabezeiger fuer PTYBFF
					 (naechstes auszulesende Zeichen)!
!%43a6!
INPTR_MCZ	WORD			!Eingabezeiger fuer MCZBFF!
!%43a8!
OUTPTR_MCZ	WORD			!Ausgabezeiger fuer MCZBFF!
!%43aa!
B_WORD		WORD			!Speicherinhalt auf der BREAK-Adresse!
!%43ac!
B_ADR_S		WORD			!Segmentnummer der BREAK-Adresse!
!%43ae!
B_ADR_O		WORD			!Offset der BREAK-Adresse!
!%43b0!
RR14_V		LONG			!VARIABLER STACK, FUER NEXT UND BREAK!
!%43b4!
W23B4		WORD
!%43b6!
FCW_V		WORD			!VARIABLES FCW FUER NEXT UND BREAK!
!%43b8!
PORT_BF		WORD			!Puffer fuer gelesenen bzw. zu
					 schreibenden PORT-Datenwert!	
!%43ba!
PORT_I		WORD			!Adresse des PORT-I-Programms!
!%43bc!
PORT_O		WORD			!Adresse des PORT-O-Programms!
!%43be!
SV_R		ARRAY [14 WORD]		!Registerrettungsbereich!
!%43da!
SVSTK		LONG
!%43de!
PC_SEG		WORD			!Programmcounter (Segmentnummer)!
!%43e0!
PC_OFF		WORD			!Programmcounter (Offsetadresse)!
!%43e2!
FCW_		WORD			!FCW im Registerrettungsbereich!
!%43e4!
RF_CTR		WORD			!Merker: Refresh Control Register!
!%43e6!
N4_		WORD			!Normalstack R14!
!%43e8!
N5_		WORD			!Normalstack R15!
!%43ea!
PS_		WORD			!Program-Status-Area Segment!
!%43ec!
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

!%4428!
PSA_NMI	
	ARRAY [4 WORD]
	ARRAY [4 WORD]
	ARRAY [4 WORD]
	ARRAY [4 WORD]
!%4448!
VI_CTC0_3
	ARRAY [%15C WORD]

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Arbeitsspeicher fuer Kommando "T" (Hardwareeigentest)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!

!%4700!
RG_FELD		ARRAY [%1A WORD]	!Feld zur Registerrettung!
!%4734!
REM_MMU_BCSR	BYTE	!Merker: Inhalt BUS CYCLE STATUS REGISTER!
		BYTE	!Merker: Inhalt VIOLATION TYPE REGISTER!
!%4736!
REM_MMU_ID	WORD	!Merker: MMU-Identifikation!
!%4738!
ECC_MEM_3	WORD	!Merker: Stand Fehlerzaehler!
!%473a!
REM_ERR_CNT	WORD	!Merker: Stand Fehlerzaehler!
!%473e!
REM_MMU_SINOUT	WORD	!Merker: MMU-Ein-/Ausgabewerte!
!%4740!
ERR_CNT		WORD	!Fehlerzaehler!
!%4742!
MAX_SEGNR	WORD	!Merker: hoechste vorhandene Segmentnummer!

!%4744!
POW_UP_TXT	WORD
!%4746!
PRT_POW_UP_TXT	WORD
!%4748!
ERRPAR_ID	WORD
!%474a!
ABOOT_DEV	WORD
!%474c!
REM_MMU1	WORD	!TODO: not relevant in 1.2!
!%474e!
REM_MMU2	WORD	!TODO: not relevant in 1.2!
!%4750!
ECC_MEM_1	LONG
!%4754!
REM_MMU_TEST	WORD
!%4756!
ECC_MEM_2	WORD
!%4758!
UKNOW_MEM_1	WORD
!%475a!
UKNOW_MEM_2	WORD
!%475c!
UKNOW_MEM_3	WORD
!%475e!
UKNOW_MEM_4	WORD
!%4760!
MMU_MEM_1	LONG
!%4764!
MMU_MEM_2	LONG
!%4768!
MMU_MEM_3	LONG
!%476c!
MMU_MEM_4	LONG
!%4770!
MMU_MEM_5	WORD
!%4772!
MMU_MEM_6	WORD

end p_ram
