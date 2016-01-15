!******************************************************************************
*******************************************************************************

  S8000-Firmware
  Z8000-Softwaremonitor (CPU)        Modul: p_boot

  Bearbeiter:	O. Lehmann
  Datum:	14.01.2016
  Version:	1.2

*******************************************************************************
******************************************************************************!

p_boot module

$SECTION PROM

  INTERNAL
  
! ADDR: 1214 !
T_DSK_BOOT:
	WORD := %0012
	ARRAY [18 BYTE] := 'BOOTING FROM DISK%0D'
	
! ADDR: 1228 !
T_TAP_BOOT:
	WORD := %0012
	ARRAY [18 BYTE] := 'BOOTING FROM TAPE%0D'

! ADDR: 123c !
T_SMD_BOOT:
	WORD := %0011
	ARRAY [18 BYTE] := 'BOOTING FROM SMD%0D%00'

! ADDR: 1250 !
T_MDSK_BOOT:
	WORD := %0017
	ARRAY [24 BYTE] := 'BOOTING FROM MINI-DISK%0D%00'

T_FLOPPY_BOOT:
    WORD := %0019
    ARRAY [26 BYTE] := 'BOOTING FROM MINI-FLOPPY%0D%00'

! ADDR: 126a !
T_BOOT_0000:
	WORD := %0000

! ADDR: 126c !
T_BOOT_0008:
	WORD := %0008

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE OS_BOOT
OS_BOOT-Routine (Monitorkommando)
manuelles BOOT von DISK, TAPE, SMD bzw. MINI-DISK

Kommandoeingabe: O D/T/S/M
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
! ADDR: 126e !
  GLOBAL
    OS_BOOT procedure
      entry
	call	GET_SIGN	!rl0:=naechstes Zeichen ungleich Space nach
				 einem Space im Eingabepuffer INBFF!
	jp	z, ERROR	!CR eingegeben!
	
	cpb	rl0, #'D'	!FROM DISK ? !
	jr	z, OS_BOOT_DSK
	cpb	rl0, #'T'	!FROM TAPE ? !
	jr	z, OS_BOOT_TAPE
	cpb	rl0, #'S'	!FROM SMD ? !
	jr	z, OS_BOOT_SMD
	cpb	rl0, #'M'	!FROM MINI-DISK ? !
	jr	z, OS_BOOT_MDISK
	cpb	rl0, #'F'	!FROM MINI-FLOPPY ? !
	jr	z, OS_BOOT_FLOPPY
	jp	ERROR		!nicht 'D','F','U','R' als Parameter angegeben!

OS_BOOT_DSK:
	ld	r2, #T_DSK_BOOT
	calr	BOOT_WR_MSG
	ldb	rl6,#3
	jp	DSK_BOOT

OS_BOOT_TAPE:
	ld	r2, #T_TAP_BOOT
	calr	BOOT_WR_MSG
	jp	TAP_BOOT

OS_BOOT_SMD:
	ld	r2, #T_SMD_BOOT
	calr	BOOT_WR_MSG
	ldb	rl6,#1
	jp	DSK_BOOT

OS_BOOT_MDISK:
	ld	r2, #T_MDSK_BOOT
	calr	BOOT_WR_MSG
	ldb	rl6,#2
	clr	%fe00
	jp	DSK_BOOT
OS_BOOT_FLOPPY:
	ld	r2, #T_FLOPPY_BOOT
	calr	BOOT_WR_MSG
	jp	FLOPPY_BOOT
    end OS_BOOT


!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE BOOT_WR_MSG
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
! ADDR: 126e !
  INTERNAL
    BOOT_WR_MSG procedure
      entry
	call	WR_MSG
	ld	r7, T_BOOT_0000
	ld	r5, T_BOOT_0008
	ld	r4, #1
	ret
    end BOOT_WR_MSG

!++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
PROCEDURE AUTOBOOT
automatisches Laden und Starten "boot0" von DISK (Block 0)
NMI-Routine (vor erster Terminaleingabe)
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++!
! ADDR: 12d6 !
  GLOBAL
    AUTOBOOT procedure
      entry
	call	TEST_		!Hardwareeigentest!
	ld	r7, T_BOOT_0000
	ldb	rl6, ABOOT_DEV
	cpb	rl6, #0
	jr	z, NO_BOOTDEV
	ld	r5, T_BOOT_0008
	ld	r4, r2		!R4=0 =AUTOMATIC BOOT  /  R4=1  MANUAL BOOT!
	test	r2
	jp	z, DSK_BOOT	!r4=0!

NO_BOOTDEV:
!Hardwareeigentest war fehlerhaft --> kein ZEUS-Start:
 NMI-Entry in PSAREA aendern, PROMT setzen und Rueckkehr in 
 Kommandoeingabeschleife!
	ld	PSA_NMI+6, #NMI_INT	!NMI_ENTRY in PSAREA:
					- nach RESET steht dort #AUTOBOOT, d.h.
					  bei NMI erfolgt Abarbeitung von
					  #AUTOBOOT
					- nach Eingabe des ersten Zeichens vom
					  Terminal (Abarbeitung von PTY_INT oder
					  KOPPEL_INT) bzw. nach Abarbeitung
					  von #AUTOBOOT wird #AUTOBOOT durch
					  #NMI_INT ersetzt, d.h. bei NMI erfolgt
					  jetzt Abarbeitung von #NMI_INT !
	
	ld	PROMT, #'[ '
	ei	vi
	jp	CMDLOP
 end AUTOBOOT

end p_boot
