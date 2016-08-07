EESchema Schematic File Version 2
LIBS:power
LIBS:device
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:s8000
LIBS:S8000_WDC_Emulator-cache
EELAYER 25 0
EELAYER END
$Descr A2 23386 16535
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L S8000P1 P1
U 1 1 56AAB5C6
P 1950 5700
F 0 "P1" H 1950 10500 70  0000 C CNN
F 1 "S8000P1" H 1950 4600 70  0000 C CNN
F 2 "" H 1950 5700 60  0000 C CNN
F 3 "" H 1950 5700 60  0000 C CNN
	1    1950 5700
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 56AAB74F
P 1000 6800
F 0 "#PWR?" H 1000 6550 50  0001 C CNN
F 1 "GND" H 1000 6650 50  0000 C CNN
F 2 "" H 1000 6800 50  0000 C CNN
F 3 "" H 1000 6800 50  0000 C CNN
	1    1000 6800
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR?
U 1 1 56AAB765
P 2900 5200
F 0 "#PWR?" H 2900 5050 50  0001 C CNN
F 1 "+5V" H 2900 5340 50  0000 C CNN
F 2 "" H 2900 5200 50  0000 C CNN
F 3 "" H 2900 5200 50  0000 C CNN
	1    2900 5200
	1    0    0    -1  
$EndComp
NoConn ~ 2650 6550
NoConn ~ 2650 6450
NoConn ~ 2650 6350
NoConn ~ 2650 6250
NoConn ~ 2650 6150
NoConn ~ 2650 6050
NoConn ~ 2650 5950
NoConn ~ 2650 5850
NoConn ~ 2650 5750
Text Label 3050 1150 2    60   ~ 0
AD0
Text Label 3050 1250 2    60   ~ 0
AD1
Text Label 3050 1350 2    60   ~ 0
AD2
Text Label 3050 1450 2    60   ~ 0
AD3
Text Label 3050 1550 2    60   ~ 0
AD4
Text Label 3050 1650 2    60   ~ 0
AD5
Text Label 3050 1750 2    60   ~ 0
AD6
Text Label 3050 1850 2    60   ~ 0
AD7
Text Label 3050 1950 2    60   ~ 0
AD8
Text Label 3050 2050 2    60   ~ 0
AD9
Text Label 3050 2150 2    60   ~ 0
AD10
Text Label 3050 2250 2    60   ~ 0
AD11
Text Label 3050 2350 2    60   ~ 0
AD12
Text Label 3050 2450 2    60   ~ 0
AD13
Text Label 3050 2550 2    60   ~ 0
AD14
Text Label 3050 2650 2    60   ~ 0
AD15
Entry Wire Line
	3150 2650 3250 2550
Entry Wire Line
	3150 2550 3250 2450
Entry Wire Line
	3150 2450 3250 2350
Entry Wire Line
	3150 2350 3250 2250
Entry Wire Line
	3150 2250 3250 2150
Entry Wire Line
	3150 2150 3250 2050
Entry Wire Line
	3150 2050 3250 1950
Entry Wire Line
	3150 1950 3250 1850
Entry Wire Line
	3150 1850 3250 1750
Entry Wire Line
	3150 1750 3250 1650
Entry Wire Line
	3150 1650 3250 1550
Entry Wire Line
	3150 1550 3250 1450
Entry Wire Line
	3150 1450 3250 1350
Entry Wire Line
	3150 1350 3250 1250
Entry Wire Line
	3150 1250 3250 1150
Entry Wire Line
	3150 1150 3250 1050
$Comp
L 74LS688 U2
U 1 1 56AAB981
P 4750 1950
F 0 "U2" H 4750 2900 50  0000 C CNN
F 1 "74LS688" H 4750 1000 50  0000 C CNN
F 2 "" H 4750 1950 50  0000 C CNN
F 3 "" H 4750 1950 50  0000 C CNN
	1    4750 1950
	1    0    0    -1  
$EndComp
$Comp
L ATMEGA1284-P U1
U 1 1 56AABA0F
P 8800 5150
F 0 "U1" H 7950 7030 50  0000 L BNN
F 1 "ATMEGA1284-P" H 9200 3200 50  0000 L BNN
F 2 "DIL40" H 8800 5150 50  0000 C CIN
F 3 "" H 8800 5150 50  0000 C CNN
	1    8800 5150
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 56AABB39
P 3650 1500
F 0 "#PWR?" H 3650 1250 50  0001 C CNN
F 1 "GND" H 3650 1350 50  0000 C CNN
F 2 "" H 3650 1500 50  0000 C CNN
F 3 "" H 3650 1500 50  0000 C CNN
	1    3650 1500
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR?
U 1 1 56AABE52
P 3400 950
F 0 "#PWR?" H 3400 800 50  0001 C CNN
F 1 "+5V" H 3400 1090 50  0000 C CNN
F 2 "" H 3400 950 50  0000 C CNN
F 3 "" H 3400 950 50  0000 C CNN
	1    3400 950 
	1    0    0    -1  
$EndComp
Text Label 3450 2650 0    60   ~ 0
AD8
Text Label 3450 2550 0    60   ~ 0
AD9
Text Label 3450 2450 0    60   ~ 0
AD10
Text Label 3450 2350 0    60   ~ 0
AD11
Text Label 3450 2250 0    60   ~ 0
AD12
Text Label 3450 2150 0    60   ~ 0
AD13
Text Label 3450 2050 0    60   ~ 0
AD14
Text Label 3450 1950 0    60   ~ 0
AD15
Entry Wire Line
	3250 1850 3350 1950
Entry Wire Line
	3250 1950 3350 2050
Entry Wire Line
	3250 2050 3350 2150
Entry Wire Line
	3250 2150 3350 2250
Entry Wire Line
	3250 2250 3350 2350
Entry Wire Line
	3250 2350 3350 2450
Entry Wire Line
	3250 2450 3350 2550
Entry Wire Line
	3250 2550 3350 2650
Text Notes 5200 2850 0    60   ~ 0
80XX\nAddress Strobe
Text Label 850  5150 0    60   ~ 0
ST0
Text Label 850  5250 0    60   ~ 0
ST1
Text Label 850  5350 0    60   ~ 0
ST2
Text Label 850  5450 0    60   ~ 0
ST3
Text Label 850  5550 0    60   ~ 0
ST4
Entry Wire Line
	750  5550 650  5450
Entry Wire Line
	750  5450 650  5350
Entry Wire Line
	750  5350 650  5250
Entry Wire Line
	750  5250 650  5150
Entry Wire Line
	750  5150 650  5050
Text Label 850  1950 0    60   ~ 0
/B/W
Entry Wire Line
	750  1950 650  1850
Text Label 850  1850 0    60   ~ 0
/R/W
Entry Wire Line
	750  1850 650  1750
Text Label 850  2250 0    60   ~ 0
/AS
Entry Wire Line
	750  2250 650  2150
Entry Wire Line
	750  2350 650  2250
Text Label 850  2350 0    60   ~ 0
/DS
Text Label 850  1150 0    60   ~ 0
/RESET
Entry Wire Line
	750  1150 650  1050
Text Label 7400 3450 0    60   ~ 0
/RESET
Entry Wire Line
	7300 3450 7200 3350
Text Label 3450 2800 0    60   ~ 0
/AS
Entry Wire Line
	3250 2700 3350 2800
$Comp
L 74LS688 U3
U 1 1 56AAC833
P 4750 4200
F 0 "U3" H 4750 5150 50  0000 C CNN
F 1 "74LS688" H 4750 3250 50  0000 C CNN
F 2 "" H 4750 4200 50  0000 C CNN
F 3 "" H 4750 4200 50  0000 C CNN
	1    4750 4200
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 56AAC83A
P 3650 3750
F 0 "#PWR?" H 3650 3500 50  0001 C CNN
F 1 "GND" H 3650 3600 50  0000 C CNN
F 2 "" H 3650 3750 50  0000 C CNN
F 3 "" H 3650 3750 50  0000 C CNN
	1    3650 3750
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR?
U 1 1 56AAC856
P 3400 3100
F 0 "#PWR?" H 3400 2950 50  0001 C CNN
F 1 "+5V" H 3400 3240 50  0000 C CNN
F 2 "" H 3400 3100 50  0000 C CNN
F 3 "" H 3400 3100 50  0000 C CNN
	1    3400 3100
	1    0    0    -1  
$EndComp
Text Label 3450 5050 0    60   ~ 0
ST4
Text Label 3450 4900 0    60   ~ 0
ST3
Text Label 3450 4800 0    60   ~ 0
ST2
Text Label 3450 4700 0    60   ~ 0
ST1
Text Label 3450 4600 0    60   ~ 0
ST0
Text Label 3450 4400 0    60   ~ 0
AD5
Text Label 3450 4300 0    60   ~ 0
AD6
Text Label 3450 4200 0    60   ~ 0
AD7
Entry Wire Line
	3250 4100 3350 4200
Entry Wire Line
	3250 4200 3350 4300
Entry Wire Line
	3250 4300 3350 4400
Entry Wire Line
	3250 4400 3350 4500
Entry Wire Line
	3250 4500 3350 4600
Entry Wire Line
	3250 4600 3350 4700
Entry Wire Line
	3250 4700 3350 4800
Entry Wire Line
	3250 4800 3350 4900
Text Notes 5200 5100 0    60   ~ 0
XX00 - XX1F\nStatus 0x02\nByte Access
Entry Wire Line
	3250 4950 3350 5050
Text Label 3450 4500 0    60   ~ 0
/B/W
$Comp
L 74LS32 U4
U 1 1 56AAD5BF
P 6600 2100
F 0 "U4" H 6600 2150 50  0000 C CNN
F 1 "74LS32" H 6600 2050 50  0000 C CNN
F 2 "" H 6600 2100 50  0000 C CNN
F 3 "" H 6600 2100 50  0000 C CNN
	1    6600 2100
	1    0    0    -1  
$EndComp
Text Notes 6250 2800 0    60   ~ 0
8000 - 801F\nI/O Operation\nAdress Strobe\nStatus 0x02\nByte Access
$Comp
L 74LS574 U5
U 1 1 56AADA53
P 8500 1700
F 0 "U5" H 8500 1700 50  0000 C CNN
F 1 "74LS574" H 8550 1350 50  0000 C CNN
F 2 "" H 8500 1700 50  0000 C CNN
F 3 "" H 8500 1700 50  0000 C CNN
	1    8500 1700
	1    0    0    -1  
$EndComp
Text Label 7400 1200 0    60   ~ 0
AD0
Text Label 7400 1300 0    60   ~ 0
AD1
Text Label 7400 1400 0    60   ~ 0
AD2
Text Label 7400 1500 0    60   ~ 0
AD3
Text Label 7400 1600 0    60   ~ 0
AD4
Text Label 7400 1700 0    60   ~ 0
AD5
Text Label 7400 1800 0    60   ~ 0
AD6
Text Label 7400 1900 0    60   ~ 0
AD7
Entry Wire Line
	7300 1900 7200 1800
Entry Wire Line
	7300 1800 7200 1700
Entry Wire Line
	7300 1700 7200 1600
Entry Wire Line
	7300 1600 7200 1500
Entry Wire Line
	7300 1500 7200 1400
Entry Wire Line
	7300 1400 7200 1300
Entry Wire Line
	7300 1300 7200 1200
Entry Wire Line
	7300 1200 7200 1100
$Comp
L GND #PWR?
U 1 1 56AADEFD
P 7550 2300
F 0 "#PWR?" H 7550 2050 50  0001 C CNN
F 1 "GND" H 7550 2150 50  0000 C CNN
F 2 "" H 7550 2300 50  0000 C CNN
F 3 "" H 7550 2300 50  0000 C CNN
	1    7550 2300
	1    0    0    -1  
$EndComp
Text Label 9600 1200 2    60   ~ 0
ACMD0
Text Label 9600 1300 2    60   ~ 0
ACMD1
Text Label 9600 1400 2    60   ~ 0
ACMD2
Text Label 9600 1500 2    60   ~ 0
ACMD3
Text Label 9600 1600 2    60   ~ 0
ACMD4
Text Label 9600 1700 2    60   ~ 0
ACMD5
Text Label 9600 1800 2    60   ~ 0
ACMD6
Text Label 9600 1900 2    60   ~ 0
ACMD7
Entry Wire Line
	9700 1900 9800 1800
Entry Wire Line
	9700 1800 9800 1700
Entry Wire Line
	9700 1700 9800 1600
Entry Wire Line
	9700 1600 9800 1500
Entry Wire Line
	9700 1500 9800 1400
Entry Wire Line
	9700 1400 9800 1300
Entry Wire Line
	9700 1300 9800 1200
Entry Wire Line
	9700 1200 9800 1100
$Comp
L +5V #PWR?
U 1 1 56AAF2F0
P 8600 3150
F 0 "#PWR?" H 8600 3000 50  0001 C CNN
F 1 "+5V" H 8600 3290 50  0000 C CNN
F 2 "" H 8600 3150 50  0000 C CNN
F 3 "" H 8600 3150 50  0000 C CNN
	1    8600 3150
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR?
U 1 1 56AAF3FA
P 8800 3150
F 0 "#PWR?" H 8800 3000 50  0001 C CNN
F 1 "+5V" H 8800 3290 50  0000 C CNN
F 2 "" H 8800 3150 50  0000 C CNN
F 3 "" H 8800 3150 50  0000 C CNN
	1    8800 3150
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 56AAF4FD
P 8600 7150
F 0 "#PWR?" H 8600 6900 50  0001 C CNN
F 1 "GND" H 8600 7000 50  0000 C CNN
F 2 "" H 8600 7150 50  0000 C CNN
F 3 "" H 8600 7150 50  0000 C CNN
	1    8600 7150
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 56AAF640
P 8800 7150
F 0 "#PWR?" H 8800 6900 50  0001 C CNN
F 1 "GND" H 8800 7000 50  0000 C CNN
F 2 "" H 8800 7150 50  0000 C CNN
F 3 "" H 8800 7150 50  0000 C CNN
	1    8800 7150
	1    0    0    -1  
$EndComp
Text Label 10200 3450 2    60   ~ 0
ACMD0
Text Label 10200 3550 2    60   ~ 0
ACMD1
Text Label 10200 3650 2    60   ~ 0
ACMD2
Text Label 10200 3750 2    60   ~ 0
ACMD3
Text Label 10200 3850 2    60   ~ 0
ACMD4
Text Label 10200 3950 2    60   ~ 0
ACMD5
Text Label 10200 4050 2    60   ~ 0
ACMD6
Text Label 10200 4150 2    60   ~ 0
ACMD7
Entry Wire Line
	10300 4150 10400 4050
Entry Wire Line
	10300 4050 10400 3950
Entry Wire Line
	10300 3950 10400 3850
Entry Wire Line
	10300 3850 10400 3750
Entry Wire Line
	10300 3750 10400 3650
Entry Wire Line
	10300 3650 10400 3550
Entry Wire Line
	10300 3550 10400 3450
Entry Wire Line
	10300 3450 10400 3350
Text Label 10300 5250 2    60   ~ 0
AD0
Text Label 10300 5350 2    60   ~ 0
AD1
Text Label 10300 5450 2    60   ~ 0
AD2
Text Label 10300 5550 2    60   ~ 0
AD3
Text Label 10300 5650 2    60   ~ 0
AD4
Text Label 10300 5750 2    60   ~ 0
AD5
Text Label 10300 5850 2    60   ~ 0
AD6
Text Label 10300 5950 2    60   ~ 0
AD7
Entry Wire Line
	10600 5950 10700 5850
Entry Wire Line
	10600 5850 10700 5750
Entry Wire Line
	10600 5750 10700 5650
Entry Wire Line
	10600 5650 10700 5550
Entry Wire Line
	10600 5550 10700 5450
Entry Wire Line
	10600 5450 10700 5350
Entry Wire Line
	10600 5350 10700 5250
Entry Wire Line
	10600 5250 10700 5150
Text Notes 8300 2700 0    60   ~ 0
/Command Adress Interrupt
Text Label 10300 6650 2    60   ~ 0
/AS
Entry Wire Line
	10600 6650 10700 6550
Text Label 10800 5600 0    60   ~ 0
/R/W
Entry Wire Line
	10800 5600 10700 5500
$Comp
L Crystal Q1
U 1 1 56AB0C3D
P 6850 4400
F 0 "Q1" V 6700 4500 50  0000 C CNN
F 1 "18432k" V 7000 4450 50  0000 L CNN
F 2 "" H 6850 4400 50  0000 C CNN
F 3 "" H 6850 4400 50  0000 C CNN
	1    6850 4400
	0    1    1    0   
$EndComp
$Comp
L C C1
U 1 1 56AB0DE5
P 6300 4100
F 0 "C1" H 6325 4200 50  0000 L CNN
F 1 "22p" H 6325 4000 50  0000 L CNN
F 2 "" H 6338 3950 50  0000 C CNN
F 3 "" H 6300 4100 50  0000 C CNN
	1    6300 4100
	1    0    0    -1  
$EndComp
$Comp
L C C2
U 1 1 56AB0E64
P 6300 4700
F 0 "C2" H 6325 4800 50  0000 L CNN
F 1 "22p" H 6325 4600 50  0000 L CNN
F 2 "" H 6338 4550 50  0000 C CNN
F 3 "" H 6300 4700 50  0000 C CNN
	1    6300 4700
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 56AB1544
P 6000 4500
F 0 "#PWR?" H 6000 4250 50  0001 C CNN
F 1 "GND" H 6000 4350 50  0000 C CNN
F 2 "" H 6000 4500 50  0000 C CNN
F 3 "" H 6000 4500 50  0000 C CNN
	1    6000 4500
	1    0    0    -1  
$EndComp
NoConn ~ 7800 4650
$Comp
L 7402 U6
U 2 1 57A2BA1C
P 12000 7100
F 0 "U6" H 12000 7150 50  0000 C CNN
F 1 "7402" H 12050 7050 50  0000 C CNN
F 2 "" H 12000 7100 50  0000 C CNN
F 3 "" H 12000 7100 50  0000 C CNN
	2    12000 7100
	-1   0    0    -1  
$EndComp
$Comp
L 7402 U6
U 1 1 57A2BFA6
P 12000 6500
F 0 "U6" H 12000 6550 50  0000 C CNN
F 1 "7402" H 12050 6450 50  0000 C CNN
F 2 "" H 12000 6500 50  0000 C CNN
F 3 "" H 12000 6500 50  0000 C CNN
	1    12000 6500
	-1   0    0    -1  
$EndComp
$Comp
L 74LS04 U7
U 1 1 57A2CBB9
P 11900 5900
F 0 "U7" H 12095 6015 50  0000 C CNN
F 1 "74LS04" H 12090 5775 50  0000 C CNN
F 2 "" H 11900 5900 50  0000 C CNN
F 3 "" H 11900 5900 50  0000 C CNN
	1    11900 5900
	1    0    0    -1  
$EndComp
Text Label 10300 6550 2    60   ~ 0
/DS
Entry Wire Line
	10600 6550 10700 6450
Text Label 9800 6750 0    60   ~ 0
READ_CMD_BUFFER_IRQ
Text Label 9800 6850 0    60   ~ 0
WRITE_CMD_BUFFER_IRQ
Text Label 10800 4900 0    60   ~ 0
AD4
Entry Wire Line
	10800 4900 10700 4800
Text Notes 10925 4525 0    60   ~ 0
only trigger an interrupt for 0x8000 - 0x800F
$Comp
L 74LS138 U8
U 1 1 57A5D2A5
P 12150 1550
F 0 "U8" H 12250 2050 50  0000 C CNN
F 1 "74LS138" H 12300 1001 50  0000 C CNN
F 2 "" H 12150 1550 50  0000 C CNN
F 3 "" H 12150 1550 50  0000 C CNN
	1    12150 1550
	1    0    0    -1  
$EndComp
$Comp
L 74LS32 U4
U 2 1 57A5D6CC
P 12200 4800
F 0 "U4" H 12200 4850 50  0000 C CNN
F 1 "74LS32" H 12200 4750 50  0000 C CNN
F 2 "" H 12200 4800 50  0000 C CNN
F 3 "" H 12200 4800 50  0000 C CNN
	2    12200 4800
	1    0    0    -1  
$EndComp
Text Label 10000 1200 0    60   ~ 0
ACMD0
Entry Wire Line
	9900 1200 9800 1100
Text Label 10000 1300 0    60   ~ 0
ACMD1
Entry Wire Line
	9900 1300 9800 1200
Text Label 10000 1400 0    60   ~ 0
ACMD2
Entry Wire Line
	9900 1400 9800 1300
Text Label 10000 1800 0    60   ~ 0
ACMD3
Entry Wire Line
	9900 1800 9800 1700
$Comp
L 74LS08 U9
U 1 1 57A5F1D8
P 11650 2550
F 0 "U9" H 11650 2600 50  0000 C CNN
F 1 "74LS08" H 11650 2500 50  0000 C CNN
F 2 "" H 11650 2550 50  0000 C CNN
F 3 "" H 11650 2550 50  0000 C CNN
	1    11650 2550
	1    0    0    -1  
$EndComp
Text Label 10850 2650 0    60   ~ 0
/R/W
Entry Wire Line
	10800 2650 10700 2550
Text Label 10850 1800 0    60   ~ 0
/DS
Entry Wire Line
	10800 1800 10700 1700
$Comp
L 74LS573 U10
U 1 1 57A5FF3D
P 14600 1700
F 0 "U10" H 14750 2300 50  0000 C CNN
F 1 "74LS573" H 14850 1100 50  0000 C CNN
F 2 "" H 14600 1700 50  0000 C CNN
F 3 "" H 14600 1700 50  0000 C CNN
	1    14600 1700
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR?
U 1 1 57A6076B
P 13100 1800
F 0 "#PWR?" H 13100 1650 50  0001 C CNN
F 1 "+5V" H 13100 1940 50  0000 C CNN
F 2 "" H 13100 1800 50  0000 C CNN
F 3 "" H 13100 1800 50  0000 C CNN
	1    13100 1800
	1    0    0    -1  
$EndComp
Text Label 10200 4350 2    60   ~ 0
STAT0
Text Label 10200 4450 2    60   ~ 0
STAT1
Text Label 10200 4550 2    60   ~ 0
STAT2
Text Label 10200 4650 2    60   ~ 0
STAT3
Text Label 10200 4750 2    60   ~ 0
STAT4
Text Label 10200 4850 2    60   ~ 0
STAT5
Text Label 10200 4950 2    60   ~ 0
STAT6
Text Label 10200 5050 2    60   ~ 0
STAT7
Entry Wire Line
	10450 5050 10550 4950
Entry Wire Line
	10450 4950 10550 4850
Entry Wire Line
	10450 4850 10550 4750
Entry Wire Line
	10450 4750 10550 4650
Entry Wire Line
	10450 4650 10550 4550
Entry Wire Line
	10450 4550 10550 4450
Entry Wire Line
	10450 4450 10550 4350
Entry Wire Line
	10450 4350 10550 4250
Text Label 13500 1200 0    60   ~ 0
STAT0
Text Label 13500 1300 0    60   ~ 0
STAT1
Text Label 13500 1400 0    60   ~ 0
STAT2
Text Label 13500 1500 0    60   ~ 0
STAT3
Text Label 13500 1600 0    60   ~ 0
STAT4
Text Label 13500 1700 0    60   ~ 0
STAT5
Text Label 13500 1800 0    60   ~ 0
STAT6
Text Label 13500 1900 0    60   ~ 0
STAT7
Entry Wire Line
	13300 1200 13200 1300
Entry Wire Line
	13300 1300 13200 1400
Entry Wire Line
	13300 1400 13200 1500
Entry Wire Line
	13300 1500 13200 1600
Entry Wire Line
	13300 1600 13200 1700
Entry Wire Line
	13300 1700 13200 1800
Entry Wire Line
	13300 1800 13200 1900
Entry Wire Line
	13300 1900 13200 2000
Text Label 15700 1200 2    60   ~ 0
AD0
Text Label 15700 1300 2    60   ~ 0
AD1
Text Label 15700 1400 2    60   ~ 0
AD2
Text Label 15700 1500 2    60   ~ 0
AD3
Text Label 15700 1600 2    60   ~ 0
AD4
Text Label 15700 1700 2    60   ~ 0
AD5
Text Label 15700 1800 2    60   ~ 0
AD6
Text Label 15700 1900 2    60   ~ 0
AD7
Entry Wire Line
	15800 1900 15900 1800
Entry Wire Line
	15800 1800 15900 1700
Entry Wire Line
	15800 1700 15900 1600
Entry Wire Line
	15800 1600 15900 1500
Entry Wire Line
	15800 1500 15900 1400
Entry Wire Line
	15800 1400 15900 1300
Entry Wire Line
	15800 1300 15900 1200
Entry Wire Line
	15800 1200 15900 1100
Entry Bus Bus
	10600 650  10700 750 
Entry Bus Bus
	10700 750  10800 650 
Entry Bus Bus
	7100 650  7200 750 
Entry Bus Bus
	7200 750  7300 650 
Entry Bus Bus
	3150 650  3250 750 
Entry Bus Bus
	3250 750  3350 650 
Text Label 10000 1900 0    60   ~ 0
ACMD4
Entry Wire Line
	9900 1900 9800 1800
NoConn ~ 12750 1300
NoConn ~ 12750 1400
NoConn ~ 12750 1500
NoConn ~ 12750 1600
NoConn ~ 12750 1700
NoConn ~ 12750 1800
NoConn ~ 12750 1900
Entry Bus Bus
	15800 650  15900 750 
Entry Bus Bus
	9800 1000 9900 900 
Entry Bus Bus
	10300 900  10400 1000
Entry Bus Bus
	650  750  750  650 
Entry Bus Bus
	10550 1000 10650 900 
Entry Bus Bus
	13100 900  13200 1000
$Comp
L 74LS74 U9
U 1 1 57A65011
P 15800 13100
F 0 "U9" H 15950 13400 50  0000 C CNN
F 1 "74LS74" H 16100 12805 50  0000 C CNN
F 2 "" H 15800 13100 50  0000 C CNN
F 3 "" H 15800 13100 50  0000 C CNN
	1    15800 13100
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR?
U 1 1 57A6563A
P 14950 12050
F 0 "#PWR?" H 14950 11900 50  0001 C CNN
F 1 "+5V" H 14950 12190 50  0000 C CNN
F 2 "" H 14950 12050 50  0000 C CNN
F 3 "" H 14950 12050 50  0000 C CNN
	1    14950 12050
	1    0    0    -1  
$EndComp
Text Notes 11250 14150 0    60   ~ 0
Adresse ungleich 0x8010 -> HIGH\nAdresse gleich 0x8010 und /DS HIGH -> HIGH\nAdresse gleich 0x8010 und /DS LOW -> LOW
Text Notes 16550 12750 0    60   ~ 0
Mit dem Wechsel LOW -> HIGH\nan Cp liegt hier nun High an
Text Notes 16000 14250 0    60   ~ 0
Der AVR zieht zum Resetten Cd kurz auf LOW\ndadurch steht der FlipFlop dann wieder auf\nLOW
NoConn ~ 16400 13300
$Comp
L S8000P1 P?
U 1 1 57A67460
P 2200 14050
F 0 "P?" H 2200 18850 70  0000 C CNN
F 1 "S8000P1" H 2200 12950 70  0000 C CNN
F 2 "" H 2200 14050 60  0000 C CNN
F 3 "" H 2200 14050 60  0000 C CNN
	1    2200 14050
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 57A6747E
P 1250 15150
F 0 "#PWR?" H 1250 14900 50  0001 C CNN
F 1 "GND" H 1250 15000 50  0000 C CNN
F 2 "" H 1250 15150 50  0000 C CNN
F 3 "" H 1250 15150 50  0000 C CNN
	1    1250 15150
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR?
U 1 1 57A67484
P 3150 13550
F 0 "#PWR?" H 3150 13400 50  0001 C CNN
F 1 "+5V" H 3150 13690 50  0000 C CNN
F 2 "" H 3150 13550 50  0000 C CNN
F 3 "" H 3150 13550 50  0000 C CNN
	1    3150 13550
	1    0    0    -1  
$EndComp
NoConn ~ 2900 14900
NoConn ~ 2900 14800
NoConn ~ 2900 14700
NoConn ~ 2900 14600
NoConn ~ 2900 14500
NoConn ~ 2900 14400
NoConn ~ 2900 14300
NoConn ~ 2900 14200
NoConn ~ 2900 14100
Text Label 3300 9500 2    60   ~ 0
AD0
Text Label 3300 9600 2    60   ~ 0
AD1
Text Label 3300 9700 2    60   ~ 0
AD2
Text Label 3300 9800 2    60   ~ 0
AD3
Text Label 3300 9900 2    60   ~ 0
AD4
Text Label 3300 10000 2    60   ~ 0
AD5
Text Label 3300 10100 2    60   ~ 0
AD6
Text Label 3300 10200 2    60   ~ 0
AD7
Text Label 3300 10300 2    60   ~ 0
AD8
Text Label 3300 10400 2    60   ~ 0
AD9
Text Label 3300 10500 2    60   ~ 0
AD10
Text Label 3300 10600 2    60   ~ 0
AD11
Text Label 3300 10700 2    60   ~ 0
AD12
Text Label 3300 10800 2    60   ~ 0
AD13
Text Label 3300 10900 2    60   ~ 0
AD14
Text Label 3300 11000 2    60   ~ 0
AD15
Entry Wire Line
	3400 11000 3500 10900
Entry Wire Line
	3400 10900 3500 10800
Entry Wire Line
	3400 10800 3500 10700
Entry Wire Line
	3400 10700 3500 10600
Entry Wire Line
	3400 10600 3500 10500
Entry Wire Line
	3400 10500 3500 10400
Entry Wire Line
	3400 10400 3500 10300
Entry Wire Line
	3400 10300 3500 10200
Entry Wire Line
	3400 10200 3500 10100
Entry Wire Line
	3400 10100 3500 10000
Entry Wire Line
	3400 10000 3500 9900
Entry Wire Line
	3400 9900 3500 9800
Entry Wire Line
	3400 9800 3500 9700
Entry Wire Line
	3400 9700 3500 9600
Entry Wire Line
	3400 9600 3500 9500
Entry Wire Line
	3400 9500 3500 9400
Text Label 1100 13500 0    60   ~ 0
ST0
Text Label 1100 13600 0    60   ~ 0
ST1
Text Label 1100 13700 0    60   ~ 0
ST2
Text Label 1100 13800 0    60   ~ 0
ST3
Text Label 1100 13900 0    60   ~ 0
ST4
Entry Wire Line
	1000 13900 900  13800
Entry Wire Line
	1000 13800 900  13700
Entry Wire Line
	1000 13700 900  13600
Entry Wire Line
	1000 13600 900  13500
Entry Wire Line
	1000 13500 900  13400
Text Label 1100 10300 0    60   ~ 0
B/W/
Entry Wire Line
	1000 10300 900  10200
Text Label 1100 10200 0    60   ~ 0
R/W/
Entry Wire Line
	1000 10200 900  10100
Text Label 1100 10600 0    60   ~ 0
/AS
Entry Wire Line
	1000 10600 900  10500
Entry Wire Line
	1000 10700 900  10600
Text Label 1100 10700 0    60   ~ 0
/DS
Text Label 1100 9500 0    60   ~ 0
/RESET
Entry Wire Line
	1000 9500 900  9400
Entry Bus Bus
	3400 9000 3500 9100
Entry Bus Bus
	900  9100 1000 9000
$Comp
L 74LS574 U2
U 1 1 57A691EE
P 4800 11350
F 0 "U2" H 4800 11350 50  0000 C CNN
F 1 "74LS574" H 4850 11000 50  0000 C CNN
F 2 "" H 4800 11350 50  0000 C CNN
F 3 "" H 4800 11350 50  0000 C CNN
	1    4800 11350
	1    0    0    -1  
$EndComp
Text Label 3700 9500 0    60   ~ 0
AD0
Text Label 3700 9600 0    60   ~ 0
AD1
Text Label 3700 9700 0    60   ~ 0
AD2
Text Label 3700 9800 0    60   ~ 0
AD3
Text Label 3700 9900 0    60   ~ 0
AD4
Text Label 3700 10000 0    60   ~ 0
AD5
Text Label 3700 10100 0    60   ~ 0
AD6
Text Label 3700 10200 0    60   ~ 0
AD7
Text Label 3700 10850 0    60   ~ 0
AD8
Text Label 3700 10950 0    60   ~ 0
AD9
Text Label 3700 11050 0    60   ~ 0
AD10
Text Label 3700 11150 0    60   ~ 0
AD11
Text Label 3700 11250 0    60   ~ 0
AD12
Text Label 3700 11350 0    60   ~ 0
AD13
Text Label 3700 11450 0    60   ~ 0
AD14
Text Label 3700 11550 0    60   ~ 0
AD15
Entry Wire Line
	3600 11550 3500 11450
Entry Wire Line
	3600 11450 3500 11350
Entry Wire Line
	3600 11350 3500 11250
Entry Wire Line
	3600 11250 3500 11150
Entry Wire Line
	3600 11150 3500 11050
Entry Wire Line
	3600 11050 3500 10950
Entry Wire Line
	3600 10950 3500 10850
Entry Wire Line
	3600 10850 3500 10750
Entry Wire Line
	3600 10200 3500 10100
Entry Wire Line
	3600 10100 3500 10000
Entry Wire Line
	3600 10000 3500 9900
Entry Wire Line
	3600 9900 3500 9800
Entry Wire Line
	3600 9800 3500 9700
Entry Wire Line
	3600 9700 3500 9600
Entry Wire Line
	3600 9600 3500 9500
Entry Wire Line
	3600 9500 3500 9400
$Comp
L 74LS574 U1
U 1 1 57A6960A
P 4800 10000
F 0 "U1" H 4800 10000 50  0000 C CNN
F 1 "74LS574" H 4850 9650 50  0000 C CNN
F 2 "" H 4800 10000 50  0000 C CNN
F 3 "" H 4800 10000 50  0000 C CNN
	1    4800 10000
	1    0    0    -1  
$EndComp
Entry Wire Line
	3600 11750 3500 11650
Text Label 3850 11750 2    60   ~ 0
/AS
$Comp
L GND #PWR?
U 1 1 57A6BD90
P 4050 10600
F 0 "#PWR?" H 4050 10350 50  0001 C CNN
F 1 "GND" H 4050 10450 50  0000 C CNN
F 2 "" H 4050 10600 50  0000 C CNN
F 3 "" H 4050 10600 50  0000 C CNN
	1    4050 10600
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 57A6CD0C
P 4050 11950
F 0 "#PWR?" H 4050 11700 50  0001 C CNN
F 1 "GND" H 4050 11800 50  0000 C CNN
F 2 "" H 4050 11950 50  0000 C CNN
F 3 "" H 4050 11950 50  0000 C CNN
	1    4050 11950
	1    0    0    -1  
$EndComp
$Comp
L 2130 U10
U 1 1 57A6DD1C
P 13700 11250
F 0 "U10" H 13700 11950 50  0000 C CNN
F 1 "7130" H 13700 11450 50  0000 C CNN
F 2 "" H 13700 11250 50  0000 C CNN
F 3 "" H 13700 11250 50  0000 C CNN
	1    13700 11250
	1    0    0    -1  
$EndComp
Text Label 5900 9500 2    60   ~ 0
LAD0
Text Label 5900 9600 2    60   ~ 0
LAD1
Text Label 5900 9700 2    60   ~ 0
LAD2
Text Label 5900 9800 2    60   ~ 0
LAD3
Text Label 5900 9900 2    60   ~ 0
LAD4
Text Label 5900 10000 2    60   ~ 0
LAD5
Text Label 5900 10100 2    60   ~ 0
LAD6
Text Label 5900 10200 2    60   ~ 0
LAD7
Text Label 5900 10850 2    60   ~ 0
LAD8
Text Label 5900 10950 2    60   ~ 0
LAD9
Text Label 5900 11050 2    60   ~ 0
LAD10
Text Label 5900 11150 2    60   ~ 0
LAD11
Text Label 5900 11250 2    60   ~ 0
LAD12
Text Label 5900 11350 2    60   ~ 0
LAD13
Text Label 5900 11450 2    60   ~ 0
LAD14
Text Label 5900 11550 2    60   ~ 0
LAD15
Entry Wire Line
	6000 11550 6100 11450
Entry Wire Line
	6000 11450 6100 11350
Entry Wire Line
	6000 11350 6100 11250
Entry Wire Line
	6000 11250 6100 11150
Entry Wire Line
	6000 11150 6100 11050
Entry Wire Line
	6000 11050 6100 10950
Entry Wire Line
	6000 10950 6100 10850
Entry Wire Line
	6000 10850 6100 10750
Entry Wire Line
	6000 10200 6100 10100
Entry Wire Line
	6000 10100 6100 10000
Entry Wire Line
	6000 10000 6100 9900
Entry Wire Line
	6000 9900 6100 9800
Entry Wire Line
	6000 9800 6100 9700
Entry Wire Line
	6000 9700 6100 9600
Entry Wire Line
	6000 9600 6100 9500
Entry Wire Line
	6000 9500 6100 9400
$Comp
L 74LS688 U3
U 1 1 57A71800
P 11200 10850
F 0 "U3" H 11200 11800 50  0000 C CNN
F 1 "74LS688" H 11200 9900 50  0000 C CNN
F 2 "" H 11200 10850 50  0000 C CNN
F 3 "" H 11200 10850 50  0000 C CNN
	1    11200 10850
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 57A71807
P 10100 10400
F 0 "#PWR?" H 10100 10150 50  0001 C CNN
F 1 "GND" H 10100 10250 50  0000 C CNN
F 2 "" H 10100 10400 50  0000 C CNN
F 3 "" H 10100 10400 50  0000 C CNN
	1    10100 10400
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR?
U 1 1 57A7181C
P 9850 9850
F 0 "#PWR?" H 9850 9700 50  0001 C CNN
F 1 "+5V" H 9850 9990 50  0000 C CNN
F 2 "" H 9850 9850 50  0000 C CNN
F 3 "" H 9850 9850 50  0000 C CNN
	1    9850 9850
	1    0    0    -1  
$EndComp
Text Label 9900 11550 0    60   ~ 0
LAD8
Text Label 9900 11450 0    60   ~ 0
LAD9
Text Label 9900 11350 0    60   ~ 0
LAD10
Text Label 9900 11250 0    60   ~ 0
LAD11
Text Label 9900 11150 0    60   ~ 0
LAD12
Text Label 9900 11050 0    60   ~ 0
LAD13
Text Label 9900 10950 0    60   ~ 0
LAD14
Text Label 9900 10850 0    60   ~ 0
LAD15
Entry Wire Line
	9700 10750 9800 10850
Entry Wire Line
	9700 10850 9800 10950
Entry Wire Line
	9700 10950 9800 11050
Entry Wire Line
	9700 11050 9800 11150
Entry Wire Line
	9700 11150 9800 11250
Entry Wire Line
	9700 11250 9800 11350
Entry Wire Line
	9700 11350 9800 11450
Entry Wire Line
	9700 11450 9800 11550
Text Label 7300 10850 0    60   ~ 0
LAD7
Entry Wire Line
	7100 10750 7200 10850
$Comp
L 74LS688 U4
U 1 1 57A73B2F
P 8600 10850
F 0 "U4" H 8600 11800 50  0000 C CNN
F 1 "74LS688" H 8600 9900 50  0000 C CNN
F 2 "" H 8600 10850 50  0000 C CNN
F 3 "" H 8600 10850 50  0000 C CNN
	1    8600 10850
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR?
U 1 1 57A73B36
P 7500 10400
F 0 "#PWR?" H 7500 10150 50  0001 C CNN
F 1 "GND" H 7500 10250 50  0000 C CNN
F 2 "" H 7500 10400 50  0000 C CNN
F 3 "" H 7500 10400 50  0000 C CNN
	1    7500 10400
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR?
U 1 1 57A73B49
P 7250 9750
F 0 "#PWR?" H 7250 9600 50  0001 C CNN
F 1 "+5V" H 7250 9890 50  0000 C CNN
F 2 "" H 7250 9750 50  0000 C CNN
F 3 "" H 7250 9750 50  0000 C CNN
	1    7250 9750
	1    0    0    -1  
$EndComp
Text Label 7100 11700 0    60   ~ 0
ST4
Text Label 7100 11550 0    60   ~ 0
ST3
Text Label 7100 11450 0    60   ~ 0
ST2
Text Label 7100 11350 0    60   ~ 0
ST1
Text Label 7100 11250 0    60   ~ 0
ST0
Text Label 7300 11050 0    60   ~ 0
LAD5
Text Label 7300 10950 0    60   ~ 0
LAD6
Entry Wire Line
	7100 10850 7200 10950
Entry Wire Line
	7100 10950 7200 11050
Entry Wire Line
	6900 11050 7000 11150
Entry Wire Line
	6900 11150 7000 11250
Entry Wire Line
	6900 11250 7000 11350
Entry Wire Line
	6900 11350 7000 11450
Entry Wire Line
	6900 11450 7000 11550
Entry Wire Line
	6900 11600 7000 11700
Text Label 7100 11150 0    60   ~ 0
/B/W
Entry Bus Bus
	6100 9300 6200 9200
Entry Wire Line
	3600 10400 3500 10300
Text Label 3850 10400 2    60   ~ 0
/AS
Entry Bus Bus
	7000 9200 7100 9300
Entry Bus Bus
	3500 9100 3600 9000
Entry Bus Bus
	6800 9000 6900 9100
Text Notes 8350 11700 0    60   ~ 0
XX00 - XX1F\nStatus 0x02\nByte Access
Text Notes 10950 11700 0    60   ~ 0
80XX
$Comp
L 74LS32 U5
U 1 1 57A7FDBF
P 8050 12700
F 0 "U5" H 8050 12750 50  0000 C CNN
F 1 "74LS32" H 8050 12650 50  0000 C CNN
F 2 "" H 8050 12700 50  0000 C CNN
F 3 "" H 8050 12700 50  0000 C CNN
	1    8050 12700
	1    0    0    -1  
$EndComp
Entry Wire Line
	7000 12800 6900 12700
Text Label 7100 12800 0    60   ~ 0
/DS
Entry Wire Line
	6800 13250 6900 13150
Text Label 6700 13250 2    60   ~ 0
R/W/
NoConn ~ 12900 12350
NoConn ~ 12900 12450
NoConn ~ 14500 12350
NoConn ~ 14500 12450
$Comp
L 74LS32 U5
U 2 1 57A836B9
P 9650 13150
F 0 "U5" H 9650 13200 50  0000 C CNN
F 1 "74LS32" H 9650 13100 50  0000 C CNN
F 2 "" H 9650 13150 50  0000 C CNN
F 3 "" H 9650 13150 50  0000 C CNN
	2    9650 13150
	1    0    0    -1  
$EndComp
$Comp
L 74LS04 U6
U 1 1 57A83B85
P 7900 13250
F 0 "U6" H 8095 13365 50  0000 C CNN
F 1 "74LS04" H 8090 13125 50  0000 C CNN
F 2 "" H 7900 13250 50  0000 C CNN
F 3 "" H 7900 13250 50  0000 C CNN
	1    7900 13250
	1    0    0    -1  
$EndComp
Entry Bus Bus
	7100 9300 7200 9200
Text Label 12500 10050 0    60   ~ 0
LAD0
Text Label 12500 10150 0    60   ~ 0
LAD1
Text Label 12500 10250 0    60   ~ 0
LAD2
Text Label 12500 10350 0    60   ~ 0
LAD3
Text Label 12500 10450 0    60   ~ 0
LAD4
Text Label 12500 10550 0    60   ~ 0
LAD5
Text Label 12500 10650 0    60   ~ 0
LAD6
Text Label 12500 10750 0    60   ~ 0
LAD7
Entry Wire Line
	12400 10750 12300 10650
Entry Wire Line
	12400 10650 12300 10550
Entry Wire Line
	12400 10550 12300 10450
Entry Wire Line
	12400 10450 12300 10350
Entry Wire Line
	12400 10350 12300 10250
Entry Wire Line
	12400 10250 12300 10150
Entry Wire Line
	12400 10150 12300 10050
Entry Wire Line
	12400 10050 12300 9950
$Comp
L GND #PWR?
U 1 1 57A88E15
P 12900 10950
F 0 "#PWR?" H 12900 10700 50  0001 C CNN
F 1 "GND" H 12900 10800 50  0000 C CNN
F 2 "" H 12900 10950 50  0000 C CNN
F 3 "" H 12900 10950 50  0000 C CNN
	1    12900 10950
	0    1    1    0   
$EndComp
$Comp
L GND #PWR?
U 1 1 57A88EB4
P 12900 10850
F 0 "#PWR?" H 12900 10600 50  0001 C CNN
F 1 "GND" H 12900 10700 50  0000 C CNN
F 2 "" H 12900 10850 50  0000 C CNN
F 3 "" H 12900 10850 50  0000 C CNN
	1    12900 10850
	0    1    1    0   
$EndComp
$Comp
L GND #PWR?
U 1 1 57A8908C
P 14500 10950
F 0 "#PWR?" H 14500 10700 50  0001 C CNN
F 1 "GND" H 14500 10800 50  0000 C CNN
F 2 "" H 14500 10950 50  0000 C CNN
F 3 "" H 14500 10950 50  0000 C CNN
	1    14500 10950
	0    -1   1    0   
$EndComp
$Comp
L GND #PWR?
U 1 1 57A89092
P 14500 10850
F 0 "#PWR?" H 14500 10600 50  0001 C CNN
F 1 "GND" H 14500 10700 50  0000 C CNN
F 2 "" H 14500 10850 50  0000 C CNN
F 3 "" H 14500 10850 50  0000 C CNN
	1    14500 10850
	0    -1   1    0   
$EndComp
Wire Wire Line
	12900 10750 12400 10750
Wire Wire Line
	12900 10650 12400 10650
Wire Wire Line
	12900 10550 12400 10550
Wire Wire Line
	12900 10450 12400 10450
Wire Wire Line
	12900 10350 12400 10350
Wire Wire Line
	12900 10250 12400 10250
Wire Wire Line
	12900 10150 12400 10150
Wire Wire Line
	12900 10050 12400 10050
Wire Bus Line
	6900 9100 6900 13150
Wire Bus Line
	3600 9000 6800 9000
Wire Bus Line
	6200 9200 7000 9200
Wire Bus Line
	6100 9300 6100 12950
Wire Wire Line
	4100 10400 3600 10400
Wire Wire Line
	7700 10000 7700 10700
Wire Wire Line
	7900 10300 7800 10300
Wire Wire Line
	7800 9900 7800 10400
Wire Wire Line
	7800 10400 7900 10400
Connection ~ 7700 10100
Wire Wire Line
	7900 11700 7000 11700
Wire Wire Line
	7900 10950 7200 10950
Wire Wire Line
	7900 11050 7200 11050
Wire Wire Line
	7900 11150 7000 11150
Wire Wire Line
	7900 11250 7000 11250
Wire Wire Line
	7900 11350 7000 11350
Wire Wire Line
	7900 11450 7000 11450
Wire Wire Line
	7900 11550 7000 11550
Wire Wire Line
	7250 9900 7250 9750
Wire Wire Line
	7250 9900 7800 9900
Wire Wire Line
	7500 10200 7500 10400
Connection ~ 7700 10600
Wire Wire Line
	7700 10600 7900 10600
Connection ~ 7700 10500
Wire Wire Line
	7700 10500 7900 10500
Wire Wire Line
	7900 10000 7700 10000
Connection ~ 7800 10300
Connection ~ 7700 10200
Wire Wire Line
	7500 10200 7900 10200
Wire Wire Line
	7700 10700 7900 10700
Wire Wire Line
	7900 10100 7700 10100
Wire Wire Line
	7900 10850 7200 10850
Wire Wire Line
	10500 10850 9800 10850
Wire Wire Line
	10500 10950 9800 10950
Wire Wire Line
	10500 11050 9800 11050
Wire Wire Line
	10500 11150 9800 11150
Wire Wire Line
	10500 11250 9800 11250
Wire Wire Line
	10500 11350 9800 11350
Wire Wire Line
	10500 11450 9800 11450
Wire Wire Line
	10500 11550 9800 11550
Wire Wire Line
	9850 10000 9850 9850
Wire Wire Line
	9850 10000 10500 10000
Wire Wire Line
	10100 10200 10100 10400
Connection ~ 10300 10600
Wire Wire Line
	10300 10600 10500 10600
Connection ~ 10300 10500
Wire Wire Line
	10300 10500 10500 10500
Connection ~ 10300 10400
Wire Wire Line
	10300 10400 10500 10400
Connection ~ 10300 10300
Wire Wire Line
	10300 10300 10500 10300
Connection ~ 10300 10200
Wire Wire Line
	10100 10200 10500 10200
Wire Wire Line
	10300 10100 10300 10700
Wire Wire Line
	10300 10700 10500 10700
Wire Wire Line
	10500 10100 10300 10100
Wire Wire Line
	5500 11550 6000 11550
Wire Wire Line
	5500 11450 6000 11450
Wire Wire Line
	5500 11350 6000 11350
Wire Wire Line
	5500 11250 6000 11250
Wire Wire Line
	5500 11150 6000 11150
Wire Wire Line
	5500 11050 6000 11050
Wire Wire Line
	5500 10950 6000 10950
Wire Wire Line
	5500 10850 6000 10850
Wire Wire Line
	5500 10200 6000 10200
Wire Wire Line
	5500 10100 6000 10100
Wire Wire Line
	5500 10000 6000 10000
Wire Wire Line
	5500 9900 6000 9900
Wire Wire Line
	5500 9800 6000 9800
Wire Wire Line
	5500 9700 6000 9700
Wire Wire Line
	5500 9600 6000 9600
Wire Wire Line
	5500 9500 6000 9500
Wire Wire Line
	4050 11850 4050 11950
Wire Wire Line
	4100 11850 4050 11850
Wire Wire Line
	4050 10500 4050 10600
Wire Wire Line
	4100 10500 4050 10500
Wire Wire Line
	4100 11750 3600 11750
Wire Wire Line
	4100 11550 3600 11550
Wire Wire Line
	4100 11450 3600 11450
Wire Wire Line
	4100 11350 3600 11350
Wire Wire Line
	4100 11250 3600 11250
Wire Wire Line
	4100 11150 3600 11150
Wire Wire Line
	4100 11050 3600 11050
Wire Wire Line
	4100 10950 3600 10950
Wire Wire Line
	4100 10850 3600 10850
Wire Wire Line
	4100 10200 3600 10200
Wire Wire Line
	4100 10100 3600 10100
Wire Wire Line
	4100 10000 3600 10000
Wire Wire Line
	4100 9900 3600 9900
Wire Wire Line
	4100 9800 3600 9800
Wire Wire Line
	4100 9700 3600 9700
Wire Wire Line
	4100 9600 3600 9600
Wire Wire Line
	4100 9500 3600 9500
Wire Bus Line
	900  9100 900  13800
Wire Bus Line
	1000 9000 3400 9000
Wire Wire Line
	1300 11200 1500 11200
Wire Wire Line
	1300 11100 1300 11200
Wire Wire Line
	1500 11100 1300 11100
Wire Wire Line
	1300 12100 1500 12100
Wire Wire Line
	1300 12000 1300 12100
Wire Wire Line
	1500 12000 1300 12000
Wire Wire Line
	1300 11700 1500 11700
Wire Wire Line
	1300 11600 1300 11700
Wire Wire Line
	1500 11600 1300 11600
Wire Wire Line
	1500 9500 1000 9500
Wire Wire Line
	1500 10700 1000 10700
Wire Wire Line
	1500 10600 1000 10600
Wire Wire Line
	1500 10200 1000 10200
Wire Wire Line
	1500 10300 1000 10300
Wire Wire Line
	1500 13900 1000 13900
Wire Wire Line
	1500 13800 1000 13800
Wire Wire Line
	1500 13700 1000 13700
Wire Wire Line
	1500 13600 1000 13600
Wire Wire Line
	1500 13500 1000 13500
Wire Wire Line
	2900 11000 3400 11000
Wire Wire Line
	2900 10900 3400 10900
Wire Wire Line
	2900 10800 3400 10800
Wire Wire Line
	2900 10700 3400 10700
Wire Wire Line
	2900 10600 3400 10600
Wire Wire Line
	2900 10500 3400 10500
Wire Wire Line
	2900 10400 3400 10400
Wire Wire Line
	2900 10300 3400 10300
Wire Wire Line
	2900 10200 3400 10200
Wire Wire Line
	2900 10100 3400 10100
Wire Wire Line
	2900 10000 3400 10000
Wire Wire Line
	2900 9900 3400 9900
Wire Wire Line
	2900 9800 3400 9800
Wire Wire Line
	2900 9700 3400 9700
Wire Wire Line
	2900 9600 3400 9600
Wire Wire Line
	2900 9500 3400 9500
Connection ~ 1250 14200
Wire Wire Line
	1500 14200 1250 14200
Connection ~ 1250 14300
Wire Wire Line
	1250 14300 1500 14300
Connection ~ 1250 14400
Wire Wire Line
	1250 14400 1500 14400
Connection ~ 1250 14500
Wire Wire Line
	1250 14500 1500 14500
Connection ~ 1250 14600
Wire Wire Line
	1250 14600 1500 14600
Connection ~ 1250 14700
Wire Wire Line
	1500 14100 1250 14100
Connection ~ 1250 14900
Wire Wire Line
	1250 14900 1500 14900
Connection ~ 1250 14800
Wire Wire Line
	1250 14800 1500 14800
Wire Wire Line
	1250 14100 1250 15150
Wire Wire Line
	1250 14700 1500 14700
Connection ~ 3150 13800
Wire Wire Line
	2900 13800 3150 13800
Connection ~ 3150 13900
Wire Wire Line
	3150 13900 2900 13900
Wire Wire Line
	3150 13550 3150 14000
Wire Wire Line
	3150 14000 2900 14000
Wire Wire Line
	15800 14350 17550 14350
Wire Wire Line
	15800 13650 15800 14350
Connection ~ 14950 12350
Wire Wire Line
	15800 12350 14950 12350
Wire Wire Line
	15800 12550 15800 12350
Wire Wire Line
	16400 12900 17500 12900
Wire Wire Line
	14100 13100 15200 13100
Wire Wire Line
	14950 12050 14950 12900
Wire Wire Line
	14950 12900 15200 12900
Wire Bus Line
	13200 1000 13200 2000
Wire Bus Line
	10650 900  13100 900 
Wire Bus Line
	10550 1000 10550 4950
Wire Wire Line
	10800 4700 11600 4700
Wire Wire Line
	10800 2750 10800 4700
Wire Wire Line
	7400 2750 10800 2750
Wire Wire Line
	12800 4800 13350 4800
Wire Bus Line
	650  750  650  5450
Wire Bus Line
	750  650  3150 650 
Wire Bus Line
	9900 900  10300 900 
Wire Bus Line
	10400 1000 10400 4050
Wire Bus Line
	9800 1000 9800 1800
Wire Bus Line
	15800 650  10800 650 
Wire Wire Line
	13000 1200 13000 2200
Wire Wire Line
	12750 1200 13000 1200
Wire Wire Line
	10200 2450 11050 2450
Wire Wire Line
	10200 1900 10200 2450
Wire Wire Line
	9900 1900 10200 1900
Wire Wire Line
	10300 1900 11550 1900
Wire Wire Line
	10300 1800 10300 1900
Wire Wire Line
	9900 1800 10300 1800
Wire Wire Line
	10800 1800 11550 1800
Wire Bus Line
	7300 650  10600 650 
Wire Bus Line
	7200 750  7200 3350
Wire Bus Line
	3350 650  7100 650 
Wire Bus Line
	3250 750  3250 4950
Wire Bus Line
	15900 750  15900 1800
Wire Wire Line
	15300 1900 15800 1900
Wire Wire Line
	15300 1800 15800 1800
Wire Wire Line
	15300 1700 15800 1700
Wire Wire Line
	15300 1600 15800 1600
Wire Wire Line
	15300 1500 15800 1500
Wire Wire Line
	15300 1400 15800 1400
Wire Wire Line
	15300 1300 15800 1300
Wire Wire Line
	15300 1200 15800 1200
Wire Wire Line
	13900 1900 13300 1900
Wire Wire Line
	13900 1800 13300 1800
Wire Wire Line
	13900 1700 13300 1700
Wire Wire Line
	13900 1600 13300 1600
Wire Wire Line
	13900 1500 13300 1500
Wire Wire Line
	13900 1400 13300 1400
Wire Wire Line
	13900 1300 13300 1300
Wire Wire Line
	13900 1200 13300 1200
Wire Wire Line
	9800 5050 10450 5050
Wire Wire Line
	9800 4950 10450 4950
Wire Wire Line
	9800 4850 10450 4850
Wire Wire Line
	9800 4750 10450 4750
Wire Wire Line
	9800 4650 10450 4650
Wire Wire Line
	9800 4550 10450 4550
Wire Wire Line
	9800 4450 10450 4450
Wire Wire Line
	9800 4350 10450 4350
Wire Wire Line
	13100 2100 13100 1800
Wire Wire Line
	13900 2100 13100 2100
Wire Wire Line
	13000 2200 13900 2200
Wire Wire Line
	11400 1700 11550 1700
Wire Wire Line
	11400 2250 11400 1700
Wire Wire Line
	12350 2250 11400 2250
Wire Wire Line
	12350 2550 12350 2250
Wire Wire Line
	12250 2550 12350 2550
Wire Wire Line
	10800 2650 11050 2650
Wire Wire Line
	9900 1400 11550 1400
Wire Wire Line
	9900 1300 11550 1300
Wire Wire Line
	9900 1200 11550 1200
Wire Wire Line
	10800 4900 11600 4900
Wire Wire Line
	13350 4800 13350 7000
Wire Wire Line
	11100 6500 11400 6500
Wire Wire Line
	11100 6750 11100 6500
Wire Wire Line
	9800 6750 11100 6750
Wire Wire Line
	11100 6850 9800 6850
Wire Wire Line
	11100 7100 11100 6850
Wire Wire Line
	11400 7100 11100 7100
Wire Wire Line
	9800 6550 10600 6550
Wire Wire Line
	12950 6600 12600 6600
Wire Wire Line
	13050 7200 12600 7200
Wire Wire Line
	12950 5900 12950 6600
Wire Wire Line
	12350 5900 12950 5900
Connection ~ 11250 5600
Wire Wire Line
	11250 5900 11250 5600
Wire Wire Line
	11450 5900 11250 5900
Wire Wire Line
	13050 5600 13050 7200
Connection ~ 13350 6400
Wire Wire Line
	13350 7000 12600 7000
Wire Wire Line
	13350 6400 12600 6400
Wire Wire Line
	1050 2850 1250 2850
Wire Wire Line
	1050 2750 1050 2850
Wire Wire Line
	1250 2750 1050 2750
Wire Wire Line
	1050 3750 1250 3750
Wire Wire Line
	1050 3650 1050 3750
Wire Wire Line
	1250 3650 1050 3650
Wire Wire Line
	1050 3350 1250 3350
Wire Wire Line
	1050 3250 1050 3350
Wire Wire Line
	1250 3250 1050 3250
Connection ~ 6300 4400
Wire Wire Line
	6000 4400 6000 4500
Wire Wire Line
	6300 4400 6000 4400
Wire Wire Line
	6300 4250 6300 4550
Connection ~ 6850 4950
Wire Wire Line
	6850 4550 6850 4950
Connection ~ 6850 3850
Wire Wire Line
	6850 4250 6850 3850
Wire Wire Line
	7550 4250 7800 4250
Wire Wire Line
	7550 4950 7550 4250
Wire Wire Line
	6300 4950 7550 4950
Wire Wire Line
	6300 4850 6300 4950
Wire Wire Line
	6300 3850 7800 3850
Wire Wire Line
	6300 3950 6300 3850
Wire Wire Line
	10800 5600 13050 5600
Wire Wire Line
	9800 6650 10600 6650
Connection ~ 7400 2100
Wire Wire Line
	7400 2100 7400 2750
Wire Wire Line
	9800 5950 10600 5950
Wire Wire Line
	9800 5850 10600 5850
Wire Wire Line
	9800 5750 10600 5750
Wire Wire Line
	9800 5650 10600 5650
Wire Wire Line
	9800 5550 10600 5550
Wire Wire Line
	9800 5450 10600 5450
Wire Wire Line
	9800 5350 10600 5350
Wire Wire Line
	9800 5250 10600 5250
Wire Wire Line
	9800 4150 10300 4150
Wire Wire Line
	9800 4050 10300 4050
Wire Wire Line
	9800 3950 10300 3950
Wire Wire Line
	9800 3850 10300 3850
Wire Wire Line
	9800 3750 10300 3750
Wire Wire Line
	9800 3650 10300 3650
Wire Wire Line
	9800 3550 10300 3550
Wire Wire Line
	9800 3450 10300 3450
Wire Bus Line
	10700 750  10700 6550
Wire Wire Line
	9200 1900 9700 1900
Wire Wire Line
	9200 1800 9700 1800
Wire Wire Line
	9200 1700 9700 1700
Wire Wire Line
	9200 1600 9700 1600
Wire Wire Line
	9200 1500 9700 1500
Wire Wire Line
	9200 1400 9700 1400
Wire Wire Line
	9200 1300 9700 1300
Wire Wire Line
	9200 1200 9700 1200
Wire Wire Line
	5800 2000 6000 2000
Wire Wire Line
	5800 1100 5800 2000
Wire Wire Line
	5450 1100 5800 1100
Wire Wire Line
	5800 2200 5800 3350
Wire Wire Line
	6000 2200 5800 2200
Wire Wire Line
	7550 2200 7550 2300
Wire Wire Line
	7800 2200 7550 2200
Wire Wire Line
	7200 2100 7800 2100
Wire Wire Line
	7800 1900 7300 1900
Wire Wire Line
	7800 1800 7300 1800
Wire Wire Line
	7800 1700 7300 1700
Wire Wire Line
	7800 1600 7300 1600
Wire Wire Line
	7800 1500 7300 1500
Wire Wire Line
	7800 1400 7300 1400
Wire Wire Line
	7800 1300 7300 1300
Wire Wire Line
	7800 1200 7300 1200
Wire Wire Line
	5800 3350 5450 3350
Wire Wire Line
	4050 3650 3950 3650
Wire Wire Line
	3950 3250 3950 3750
Wire Wire Line
	3950 3750 4050 3750
Connection ~ 3850 3450
Wire Wire Line
	4050 5050 3350 5050
Wire Wire Line
	4050 4200 3350 4200
Wire Wire Line
	4050 4300 3350 4300
Wire Wire Line
	4050 4400 3350 4400
Wire Wire Line
	4050 4500 3350 4500
Wire Wire Line
	4050 4600 3350 4600
Wire Wire Line
	4050 4700 3350 4700
Wire Wire Line
	4050 4800 3350 4800
Wire Wire Line
	4050 4900 3350 4900
Wire Wire Line
	3400 3250 3400 3100
Wire Wire Line
	3400 3250 3950 3250
Wire Wire Line
	3650 3550 3650 3750
Connection ~ 3850 3950
Wire Wire Line
	3850 3950 4050 3950
Connection ~ 3850 3850
Wire Wire Line
	3850 3850 4050 3850
Wire Wire Line
	4050 3350 3850 3350
Connection ~ 3950 3650
Connection ~ 3850 3550
Wire Wire Line
	3650 3550 4050 3550
Wire Wire Line
	3850 3350 3850 4050
Wire Wire Line
	3850 4050 4050 4050
Wire Wire Line
	4050 3450 3850 3450
Wire Wire Line
	4050 2800 3350 2800
Wire Wire Line
	7800 3450 7300 3450
Wire Wire Line
	1250 1150 750  1150
Wire Wire Line
	1250 2350 750  2350
Wire Wire Line
	1250 2250 750  2250
Wire Wire Line
	1250 1850 750  1850
Wire Wire Line
	1250 1950 750  1950
Wire Wire Line
	1250 5550 750  5550
Wire Wire Line
	1250 5450 750  5450
Wire Wire Line
	1250 5350 750  5350
Wire Wire Line
	1250 5250 750  5250
Wire Wire Line
	1250 5150 750  5150
Wire Wire Line
	4050 1950 3350 1950
Wire Wire Line
	4050 2050 3350 2050
Wire Wire Line
	4050 2150 3350 2150
Wire Wire Line
	4050 2250 3350 2250
Wire Wire Line
	4050 2350 3350 2350
Wire Wire Line
	4050 2450 3350 2450
Wire Wire Line
	4050 2550 3350 2550
Wire Wire Line
	4050 2650 3350 2650
Wire Wire Line
	3400 1100 3400 950 
Wire Wire Line
	3400 1100 4050 1100
Wire Wire Line
	3650 1300 3650 1500
Connection ~ 3850 1700
Wire Wire Line
	3850 1700 4050 1700
Connection ~ 3850 1600
Wire Wire Line
	3850 1600 4050 1600
Connection ~ 3850 1500
Wire Wire Line
	3850 1500 4050 1500
Connection ~ 3850 1400
Wire Wire Line
	3850 1400 4050 1400
Connection ~ 3850 1300
Wire Wire Line
	3650 1300 4050 1300
Wire Wire Line
	3850 1200 3850 1800
Wire Wire Line
	3850 1800 4050 1800
Wire Wire Line
	4050 1200 3850 1200
Wire Wire Line
	2650 2650 3150 2650
Wire Wire Line
	2650 2550 3150 2550
Wire Wire Line
	2650 2450 3150 2450
Wire Wire Line
	2650 2350 3150 2350
Wire Wire Line
	2650 2250 3150 2250
Wire Wire Line
	2650 2150 3150 2150
Wire Wire Line
	2650 2050 3150 2050
Wire Wire Line
	2650 1950 3150 1950
Wire Wire Line
	2650 1850 3150 1850
Wire Wire Line
	2650 1750 3150 1750
Wire Wire Line
	2650 1650 3150 1650
Wire Wire Line
	2650 1550 3150 1550
Wire Wire Line
	2650 1450 3150 1450
Wire Wire Line
	2650 1350 3150 1350
Wire Wire Line
	2650 1250 3150 1250
Wire Wire Line
	2650 1150 3150 1150
Connection ~ 1000 5850
Wire Wire Line
	1250 5850 1000 5850
Connection ~ 1000 5950
Wire Wire Line
	1000 5950 1250 5950
Connection ~ 1000 6050
Wire Wire Line
	1000 6050 1250 6050
Connection ~ 1000 6150
Wire Wire Line
	1000 6150 1250 6150
Connection ~ 1000 6250
Wire Wire Line
	1000 6250 1250 6250
Connection ~ 1000 6350
Wire Wire Line
	1250 5750 1000 5750
Connection ~ 1000 6550
Wire Wire Line
	1000 6550 1250 6550
Connection ~ 1000 6450
Wire Wire Line
	1000 6450 1250 6450
Wire Wire Line
	1000 5750 1000 6800
Wire Wire Line
	1000 6350 1250 6350
Connection ~ 2900 5450
Wire Wire Line
	2650 5450 2900 5450
Connection ~ 2900 5550
Wire Wire Line
	2900 5550 2650 5550
Wire Wire Line
	2900 5200 2900 5650
Wire Wire Line
	2900 5650 2650 5650
Text Label 12500 11150 0    60   ~ 0
D0
Text Label 12500 11250 0    60   ~ 0
D1
Text Label 12500 11350 0    60   ~ 0
D2
Text Label 12500 11450 0    60   ~ 0
D3
Text Label 12500 11550 0    60   ~ 0
D4
Text Label 12500 11650 0    60   ~ 0
D5
Text Label 12500 11750 0    60   ~ 0
D6
Text Label 12500 11850 0    60   ~ 0
D7
Entry Wire Line
	12400 11850 12300 11750
Entry Wire Line
	12400 11750 12300 11650
Entry Wire Line
	12400 11650 12300 11550
Entry Wire Line
	12400 11550 12300 11450
Entry Wire Line
	12400 11450 12300 11350
Entry Wire Line
	12400 11350 12300 11250
Entry Wire Line
	12400 11250 12300 11150
Entry Wire Line
	12400 11150 12300 11050
Wire Wire Line
	12900 11850 12400 11850
Wire Wire Line
	12900 11750 12400 11750
Wire Wire Line
	12900 11650 12400 11650
Wire Wire Line
	12900 11550 12400 11550
Wire Wire Line
	12900 11450 12400 11450
Wire Wire Line
	12900 11350 12400 11350
Wire Wire Line
	12900 11250 12400 11250
Wire Wire Line
	12900 11150 12400 11150
$Comp
L 74LS245 U7
U 1 1 57A90F13
P 4800 12850
F 0 "U7" H 4900 13425 50  0000 L BNN
F 1 "74LS245" H 4850 12275 50  0000 L TNN
F 2 "" H 4800 12850 50  0000 C CNN
F 3 "" H 4800 12850 50  0000 C CNN
	1    4800 12850
	-1   0    0    -1  
$EndComp
Wire Wire Line
	6800 13250 5500 13250
Entry Wire Line
	7000 13250 6900 13150
Text Label 7100 13250 0    60   ~ 0
R/W/
Text Label 5900 12350 2    60   ~ 0
D0
Text Label 5900 12450 2    60   ~ 0
D1
Text Label 5900 12550 2    60   ~ 0
D2
Text Label 5900 12650 2    60   ~ 0
D3
Text Label 5900 12750 2    60   ~ 0
D4
Text Label 5900 12850 2    60   ~ 0
D5
Text Label 5900 12950 2    60   ~ 0
D6
Text Label 5900 13050 2    60   ~ 0
D7
Entry Wire Line
	6000 13050 6100 12950
Entry Wire Line
	6000 12950 6100 12850
Entry Wire Line
	6000 12850 6100 12750
Entry Wire Line
	6000 12750 6100 12650
Entry Wire Line
	6000 12650 6100 12550
Entry Wire Line
	6000 12550 6100 12450
Entry Wire Line
	6000 12450 6100 12350
Entry Wire Line
	6000 12350 6100 12250
Wire Wire Line
	5500 13050 6000 13050
Wire Wire Line
	5500 12950 6000 12950
Wire Wire Line
	5500 12850 6000 12850
Wire Wire Line
	5500 12750 6000 12750
Wire Wire Line
	5500 12650 6000 12650
Wire Wire Line
	5500 12550 6000 12550
Wire Wire Line
	5500 12450 6000 12450
Wire Wire Line
	5500 12350 6000 12350
Text Label 3700 12350 0    60   ~ 0
AD0
Text Label 3700 12450 0    60   ~ 0
AD1
Text Label 3700 12550 0    60   ~ 0
AD2
Text Label 3700 12650 0    60   ~ 0
AD3
Text Label 3700 12750 0    60   ~ 0
AD4
Text Label 3700 12850 0    60   ~ 0
AD5
Text Label 3700 12950 0    60   ~ 0
AD6
Text Label 3700 13050 0    60   ~ 0
AD7
Entry Wire Line
	3600 13050 3500 12950
Entry Wire Line
	3600 12950 3500 12850
Entry Wire Line
	3600 12850 3500 12750
Entry Wire Line
	3600 12750 3500 12650
Entry Wire Line
	3600 12650 3500 12550
Entry Wire Line
	3600 12550 3500 12450
Entry Wire Line
	3600 12450 3500 12350
Entry Wire Line
	3600 12350 3500 12250
Wire Wire Line
	4100 13050 3600 13050
Wire Wire Line
	4100 12950 3600 12950
Wire Wire Line
	4100 12850 3600 12850
Wire Wire Line
	4100 12750 3600 12750
Wire Wire Line
	4100 12650 3600 12650
Wire Wire Line
	4100 12550 3600 12550
Wire Wire Line
	4100 12450 3600 12450
Wire Wire Line
	4100 12350 3600 12350
Wire Wire Line
	11900 10000 12100 10000
$Comp
L 74LS138 U8
U 1 1 57A9A927
P 13500 13450
F 0 "U8" H 13600 13950 50  0000 C CNN
F 1 "74LS138" H 13650 12901 50  0000 C CNN
F 2 "" H 13500 13450 50  0000 C CNN
F 3 "" H 13500 13450 50  0000 C CNN
	1    13500 13450
	1    0    0    -1  
$EndComp
$Comp
L 74LS04 U6
U 2 1 57A9C3E3
P 9450 12700
F 0 "U6" H 9645 12815 50  0000 C CNN
F 1 "74LS04" H 9640 12575 50  0000 C CNN
F 2 "" H 9450 12700 50  0000 C CNN
F 3 "" H 9450 12700 50  0000 C CNN
	2    9450 12700
	1    0    0    -1  
$EndComp
Text Label 12500 13100 0    60   ~ 0
LAD0
Text Label 12500 13200 0    60   ~ 0
LAD1
Text Label 12500 13300 0    60   ~ 0
LAD2
Text Label 12500 13700 0    60   ~ 0
LAD3
Text Label 12500 13800 0    60   ~ 0
LAD4
Entry Wire Line
	12400 13800 12300 13700
Entry Wire Line
	12400 13700 12300 13600
Entry Wire Line
	12400 13300 12300 13200
Entry Wire Line
	12400 13200 12300 13100
Entry Wire Line
	12400 13100 12300 13000
Wire Wire Line
	12400 13800 12900 13800
Wire Wire Line
	12400 13700 12900 13700
Wire Wire Line
	12400 13300 12900 13300
Wire Wire Line
	12400 13100 12900 13100
Wire Wire Line
	8650 12700 9000 12700
Wire Bus Line
	7100 9300 7100 10950
Wire Wire Line
	10500 11700 9400 11700
Wire Wire Line
	9400 11700 9400 10000
Wire Wire Line
	9400 10000 9300 10000
Entry Bus Bus
	9600 9200 9700 9300
Entry Bus Bus
	9700 9300 9800 9200
Wire Bus Line
	9700 9300 9700 11450
Wire Bus Line
	7200 9200 9600 9200
Wire Wire Line
	12100 10000 12100 11950
Wire Wire Line
	12100 11950 7200 11950
Wire Wire Line
	7200 11950 7200 12600
Wire Wire Line
	7200 12600 7450 12600
Wire Wire Line
	7000 12800 7450 12800
Wire Wire Line
	8850 12050 8850 13050
Wire Wire Line
	8850 13050 9050 13050
Wire Wire Line
	8350 13250 9050 13250
Wire Wire Line
	7000 13250 7450 13250
Wire Wire Line
	7350 13250 7350 13500
Wire Wire Line
	7350 13500 10600 13500
Connection ~ 7350 13250
Connection ~ 8850 12700
Wire Wire Line
	10250 13150 10500 13150
Wire Wire Line
	8850 12350 6300 12350
Wire Wire Line
	6300 12350 6300 13350
Wire Wire Line
	6300 13350 5500 13350
Entry Bus Bus
	12200 9200 12300 9300
Wire Bus Line
	9800 9200 12200 9200
Wire Bus Line
	12300 9300 12300 13700
Wire Wire Line
	12900 12050 8850 12050
Connection ~ 8850 12350
Wire Wire Line
	10500 13150 10500 12150
Wire Wire Line
	10500 12150 12900 12150
Wire Wire Line
	10600 13500 10600 12250
Wire Wire Line
	10600 12250 12900 12250
Wire Wire Line
	12400 13200 12900 13200
Wire Wire Line
	9900 12700 11700 12700
Wire Wire Line
	11700 12700 11700 13450
Wire Wire Line
	11700 13450 12850 13450
Wire Wire Line
	12850 13450 12850 13600
Wire Wire Line
	12850 13600 12900 13600
Wire Notes Line
	450  8150 22900 8150
Text Notes 15650 5400 0    1969 ~ 394
ALT
Text Notes 16300 11050 0    1969 ~ 394
NEU
Wire Bus Line
	3500 12950 3500 9100
Text Label 9250 11950 0    60   ~ 0
/WDC_ENABLE
$EndSCHEMATC
