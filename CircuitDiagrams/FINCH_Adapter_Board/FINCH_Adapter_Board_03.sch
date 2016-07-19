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
LIBS:FINCH_Adapter_Board
LIBS:FINCH_Adapter_Board-cache
EELAYER 25 0
EELAYER END
$Descr A3 16535 11693
encoding utf-8
Sheet 3 3
Title "S8000 FINCH Adapter Board"
Date "2016-07-17"
Rev "1.1"
Comp "Oliver Lehmann"
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L 74LS08 U15
U 3 1 577C059A
P 7400 8600
F 0 "U15" H 7400 8650 50  0000 C CNN
F 1 "74LS08" H 7400 8550 50  0000 C CNN
F 2 "Housings_DIP:DIP-14_W7.62mm_LongPads" H 7400 8600 50  0001 C CNN
F 3 "" H 7400 8600 50  0000 C CNN
	3    7400 8600
	1    0    0    -1  
$EndComp
$Comp
L 74LS00 U6
U 3 1 577C07F4
P 9750 8700
F 0 "U6" H 9750 8750 50  0000 C CNN
F 1 "74LS00" H 9750 8600 50  0000 C CNN
F 2 "Housings_DIP:DIP-14_W7.62mm_LongPads" H 9750 8700 50  0001 C CNN
F 3 "" H 9750 8700 50  0000 C CNN
	3    9750 8700
	1    0    0    1   
$EndComp
$Comp
L 7417 U2
U 4 1 577C80B6
P 11350 8700
F 0 "U2" H 11500 8800 50  0000 C CNN
F 1 "7417" H 11550 8600 50  0000 C CNN
F 2 "Housings_DIP:DIP-14_W7.62mm_LongPads" H 11350 8700 50  0001 C CNN
F 3 "" H 11350 8700 50  0000 C CNN
	4    11350 8700
	1    0    0    -1  
$EndComp
Text GLabel 14550 8700 2    60   Output ~ 0
DRV_CMD_WRITE_ENABLE
$Comp
L 74LS163 U10
U 1 1 5789B96A
P 3450 1700
F 0 "U10" H 3500 1800 50  0000 C CNN
F 1 "74LS163" H 3550 1500 50  0000 C CNN
F 2 "Housings_DIP:DIP-16_W7.62mm_LongPads" H 3450 1700 50  0001 C CNN
F 3 "" H 3450 1700 50  0000 C CNN
	1    3450 1700
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR017
U 1 1 5789B976
P 2750 1200
F 0 "#PWR017" H 2750 950 50  0001 C CNN
F 1 "GND" H 2750 1050 50  0000 C CNN
F 2 "" H 2750 1200 50  0000 C CNN
F 3 "" H 2750 1200 50  0000 C CNN
	1    2750 1200
	0    1    1    0   
$EndComp
$Comp
L GND #PWR018
U 1 1 5789B97C
P 2750 1300
F 0 "#PWR018" H 2750 1050 50  0001 C CNN
F 1 "GND" H 2750 1150 50  0000 C CNN
F 2 "" H 2750 1300 50  0000 C CNN
F 3 "" H 2750 1300 50  0000 C CNN
	1    2750 1300
	0    1    1    0   
$EndComp
$Comp
L GND #PWR019
U 1 1 5789B982
P 2750 1200
F 0 "#PWR019" H 2750 950 50  0001 C CNN
F 1 "GND" H 2750 1050 50  0000 C CNN
F 2 "" H 2750 1200 50  0000 C CNN
F 3 "" H 2750 1200 50  0000 C CNN
	1    2750 1200
	0    1    1    0   
$EndComp
$Comp
L GND #PWR020
U 1 1 5789B988
P 2750 1300
F 0 "#PWR020" H 2750 1050 50  0001 C CNN
F 1 "GND" H 2750 1150 50  0000 C CNN
F 2 "" H 2750 1300 50  0000 C CNN
F 3 "" H 2750 1300 50  0000 C CNN
	1    2750 1300
	0    1    1    0   
$EndComp
$Comp
L GND #PWR021
U 1 1 5789B98E
P 2750 1400
F 0 "#PWR021" H 2750 1150 50  0001 C CNN
F 1 "GND" H 2750 1250 50  0000 C CNN
F 2 "" H 2750 1400 50  0000 C CNN
F 3 "" H 2750 1400 50  0000 C CNN
	1    2750 1400
	0    1    1    0   
$EndComp
$Comp
L GND #PWR022
U 1 1 5789B994
P 2750 1500
F 0 "#PWR022" H 2750 1250 50  0001 C CNN
F 1 "GND" H 2750 1350 50  0000 C CNN
F 2 "" H 2750 1500 50  0000 C CNN
F 3 "" H 2750 1500 50  0000 C CNN
	1    2750 1500
	0    1    1    0   
$EndComp
$Comp
L GND #PWR023
U 1 1 5789B99A
P 2750 1400
F 0 "#PWR023" H 2750 1150 50  0001 C CNN
F 1 "GND" H 2750 1250 50  0000 C CNN
F 2 "" H 2750 1400 50  0000 C CNN
F 3 "" H 2750 1400 50  0000 C CNN
	1    2750 1400
	0    1    1    0   
$EndComp
$Comp
L GND #PWR024
U 1 1 5789B9A0
P 2750 1500
F 0 "#PWR024" H 2750 1250 50  0001 C CNN
F 1 "GND" H 2750 1350 50  0000 C CNN
F 2 "" H 2750 1500 50  0000 C CNN
F 3 "" H 2750 1500 50  0000 C CNN
	1    2750 1500
	0    1    1    0   
$EndComp
NoConn ~ 4150 1500
NoConn ~ 4150 1400
NoConn ~ 4150 1300
NoConn ~ 4150 1200
Text GLabel 1850 7650 0    60   Input ~ 0
HIGH_3
Text GLabel 1850 850  0    60   Input ~ 0
HIGH_2
$Comp
L 74LS163 U11
U 1 1 5789E209
P 5450 1700
F 0 "U11" H 5500 1800 50  0000 C CNN
F 1 "74LS163" H 5550 1500 50  0000 C CNN
F 2 "Housings_DIP:DIP-16_W7.62mm_LongPads" H 5450 1700 50  0001 C CNN
F 3 "" H 5450 1700 50  0000 C CNN
	1    5450 1700
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR025
U 1 1 5789E20F
P 4750 1400
F 0 "#PWR025" H 4750 1150 50  0001 C CNN
F 1 "GND" H 4750 1250 50  0000 C CNN
F 2 "" H 4750 1400 50  0000 C CNN
F 3 "" H 4750 1400 50  0000 C CNN
	1    4750 1400
	0    1    1    0   
$EndComp
NoConn ~ 6150 1500
NoConn ~ 6150 1400
NoConn ~ 6150 1300
NoConn ~ 6150 1200
$Comp
L 74LS163 U12
U 1 1 578A083D
P 7450 1700
F 0 "U12" H 7500 1800 50  0000 C CNN
F 1 "74LS163" H 7550 1500 50  0000 C CNN
F 2 "Housings_DIP:DIP-16_W7.62mm_LongPads" H 7450 1700 50  0001 C CNN
F 3 "" H 7450 1700 50  0000 C CNN
	1    7450 1700
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR026
U 1 1 578A0843
P 6750 1400
F 0 "#PWR026" H 6750 1150 50  0001 C CNN
F 1 "GND" H 6750 1250 50  0000 C CNN
F 2 "" H 6750 1400 50  0000 C CNN
F 3 "" H 6750 1400 50  0000 C CNN
	1    6750 1400
	0    1    1    0   
$EndComp
NoConn ~ 8150 1500
NoConn ~ 8150 1400
NoConn ~ 8150 1300
NoConn ~ 8150 1200
$Comp
L 74LS04 U8
U 6 1 578A4437
P 2500 3600
F 0 "U8" H 2695 3715 50  0000 C CNN
F 1 "74LS04" H 2690 3475 50  0000 C CNN
F 2 "Housings_DIP:DIP-14_W7.62mm_LongPads" H 2500 3600 50  0001 C CNN
F 3 "" H 2500 3600 50  0000 C CNN
	6    2500 3600
	1    0    0    -1  
$EndComp
Text GLabel 1850 5250 0    60   Input ~ 0
DRV_DATA_BYTE_CLOCK
$Comp
L 74LS04 U8
U 3 1 578AAB83
P 3950 3900
F 0 "U8" H 4145 4015 50  0000 C CNN
F 1 "74LS04" H 4140 3775 50  0000 C CNN
F 2 "Housings_DIP:DIP-14_W7.62mm_LongPads" H 3950 3900 50  0001 C CNN
F 3 "" H 3950 3900 50  0000 C CNN
	3    3950 3900
	1    0    0    -1  
$EndComp
$Comp
L 74LS08 U15
U 1 1 578AC7C8
P 5550 4700
F 0 "U15" H 5550 4750 50  0000 C CNN
F 1 "74LS08" H 5550 4650 50  0000 C CNN
F 2 "Housings_DIP:DIP-14_W7.62mm_LongPads" H 5550 4700 50  0001 C CNN
F 3 "" H 5550 4700 50  0000 C CNN
	1    5550 4700
	1    0    0    1   
$EndComp
$Comp
L 74LS163 U20
U 1 1 578AE4B0
P 9450 1700
F 0 "U20" H 9500 1800 50  0000 C CNN
F 1 "74LS163" H 9550 1500 50  0000 C CNN
F 2 "Housings_DIP:DIP-16_W7.62mm_LongPads" H 9450 1700 50  0001 C CNN
F 3 "" H 9450 1700 50  0000 C CNN
	1    9450 1700
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR027
U 1 1 578AE4B6
P 8750 1400
F 0 "#PWR027" H 8750 1150 50  0001 C CNN
F 1 "GND" H 8750 1250 50  0000 C CNN
F 2 "" H 8750 1400 50  0000 C CNN
F 3 "" H 8750 1400 50  0000 C CNN
	1    8750 1400
	0    1    1    0   
$EndComp
$Comp
L GND #PWR028
U 1 1 578AE4BC
P 8750 1300
F 0 "#PWR028" H 8750 1050 50  0001 C CNN
F 1 "GND" H 8750 1150 50  0000 C CNN
F 2 "" H 8750 1300 50  0000 C CNN
F 3 "" H 8750 1300 50  0000 C CNN
	1    8750 1300
	0    1    1    0   
$EndComp
NoConn ~ 10150 1500
NoConn ~ 10150 1400
NoConn ~ 10150 1300
NoConn ~ 10150 1200
$Comp
L 74LS163 U19
U 1 1 578B03F5
P 11450 1700
F 0 "U19" H 11500 1800 50  0000 C CNN
F 1 "74LS163" H 11550 1500 50  0000 C CNN
F 2 "Housings_DIP:DIP-16_W7.62mm_LongPads" H 11450 1700 50  0001 C CNN
F 3 "" H 11450 1700 50  0000 C CNN
	1    11450 1700
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR029
U 1 1 578B03FB
P 10750 1500
F 0 "#PWR029" H 10750 1250 50  0001 C CNN
F 1 "GND" H 10750 1350 50  0000 C CNN
F 2 "" H 10750 1500 50  0000 C CNN
F 3 "" H 10750 1500 50  0000 C CNN
	1    10750 1500
	0    1    1    0   
$EndComp
NoConn ~ 12150 1500
NoConn ~ 12150 1400
NoConn ~ 12150 1300
NoConn ~ 12150 1200
$Comp
L 74LS08 U15
U 2 1 578B5AB2
P 7500 3800
F 0 "U15" H 7500 3850 50  0000 C CNN
F 1 "74LS08" H 7500 3750 50  0000 C CNN
F 2 "Housings_DIP:DIP-14_W7.62mm_LongPads" H 7500 3800 50  0001 C CNN
F 3 "" H 7500 3800 50  0000 C CNN
	2    7500 3800
	1    0    0    -1  
$EndComp
Text GLabel 1850 2850 0    60   Input ~ 0
/MASTER_RESET
$Comp
L 74LS109 U5
U 2 1 578BB101
P 4500 8750
F 0 "U5" H 4500 8850 50  0000 C CNN
F 1 "74LS109" H 4500 8650 50  0000 C CNN
F 2 "Housings_DIP:DIP-16_W7.62mm_LongPads" H 4500 8750 50  0001 C CNN
F 3 "" H 4500 8750 50  0000 C CNN
	2    4500 8750
	1    0    0    -1  
$EndComp
Text GLabel 1850 7850 0    60   Input ~ 0
HIGH_2
NoConn ~ 5250 9000
Text GLabel 1850 9950 0    60   Input ~ 0
DRIVE_SELECT
Text GLabel 1850 10100 0    60   Input ~ 0
WRITE_ENABLE
$Comp
L 74LS04 U8
U 2 1 578C95DF
P 3950 4600
F 0 "U8" H 4145 4715 50  0000 C CNN
F 1 "74LS04" H 4140 4475 50  0000 C CNN
F 2 "Housings_DIP:DIP-14_W7.62mm_LongPads" H 3950 4600 50  0001 C CNN
F 3 "" H 3950 4600 50  0000 C CNN
	2    3950 4600
	1    0    0    -1  
$EndComp
$Comp
L 74LS00 U6
U 1 1 578CB3EA
P 7600 5850
F 0 "U6" H 7600 5900 50  0000 C CNN
F 1 "74LS00" H 7600 5750 50  0000 C CNN
F 2 "Housings_DIP:DIP-14_W7.62mm_LongPads" H 7600 5850 50  0001 C CNN
F 3 "" H 7600 5850 50  0000 C CNN
	1    7600 5850
	1    0    0    1   
$EndComp
$Comp
L 74LS00 U6
U 2 1 578CB3F0
P 7600 5350
F 0 "U6" H 7600 5400 50  0000 C CNN
F 1 "74LS00" H 7600 5250 50  0000 C CNN
F 2 "Housings_DIP:DIP-14_W7.62mm_LongPads" H 7600 5350 50  0001 C CNN
F 3 "" H 7600 5350 50  0000 C CNN
	2    7600 5350
	1    0    0    -1  
$EndComp
Text GLabel 14550 5850 2    60   Output ~ 0
/INDEX
Text GLabel 14550 5350 2    60   Output ~ 0
/SECTOR
$Comp
L 74LS109 U5
U 1 1 578D1EEA
P 4500 6950
F 0 "U5" H 4500 7050 50  0000 C CNN
F 1 "74LS109" H 4500 6850 50  0000 C CNN
F 2 "Housings_DIP:DIP-16_W7.62mm_LongPads" H 4500 6950 50  0001 C CNN
F 3 "" H 4500 6950 50  0000 C CNN
	1    4500 6950
	1    0    0    -1  
$EndComp
Text GLabel 1850 6700 0    60   Input ~ 0
DRV_DATA_INDEX
Text GLabel 1850 9800 0    60   Input ~ 0
/MASTER_RESET
Wire Wire Line
	3450 5250 3450 5750
Connection ~ 3050 7650
Wire Wire Line
	3050 6050 4500 6050
Connection ~ 3250 3900
Wire Wire Line
	3500 3900 3250 3900
Connection ~ 8600 2650
Wire Wire Line
	8600 2000 8600 2650
Wire Wire Line
	8750 2000 8600 2000
Connection ~ 6600 2650
Wire Wire Line
	10600 2000 10600 2650
Wire Wire Line
	10750 2000 10600 2000
Wire Wire Line
	4500 9800 4500 9550
Wire Wire Line
	1850 9800 4500 9800
Wire Wire Line
	3450 5750 7000 5750
Connection ~ 3450 5250
Connection ~ 1950 5250
Connection ~ 3700 6700
Wire Wire Line
	3700 6700 3700 7200
Wire Wire Line
	3700 7200 3850 7200
Wire Wire Line
	1850 6700 3850 6700
Wire Wire Line
	3050 7650 3050 6050
Wire Wire Line
	1850 7650 4500 7650
Wire Wire Line
	4500 6050 4500 6250
Wire Wire Line
	5750 5950 7000 5950
Wire Wire Line
	5750 5950 5750 7200
Wire Wire Line
	5750 7200 5150 7200
Connection ~ 4800 4800
Wire Wire Line
	5600 6700 5150 6700
Wire Wire Line
	5600 5100 5600 6700
Wire Wire Line
	4800 5100 5600 5100
Wire Wire Line
	4800 3700 6900 3700
Wire Wire Line
	4800 3700 4800 5100
Wire Wire Line
	4800 4800 4950 4800
Connection ~ 3350 4600
Wire Wire Line
	1950 3600 1950 5250
Wire Wire Line
	3350 5450 7000 5450
Wire Wire Line
	1850 5250 7000 5250
Wire Wire Line
	14550 5350 8200 5350
Wire Wire Line
	14550 5850 8200 5850
Connection ~ 8400 2450
Wire Wire Line
	8400 3050 3350 3050
Wire Wire Line
	3350 3050 3350 5450
Wire Wire Line
	3500 4600 3350 4600
Wire Wire Line
	5600 10100 1850 10100
Wire Wire Line
	5600 9000 5600 10100
Wire Wire Line
	7850 9000 5600 9000
Wire Wire Line
	7850 8800 7850 9000
Wire Wire Line
	8000 8600 9150 8600
Wire Wire Line
	5450 9950 1850 9950
Wire Wire Line
	5450 8700 5450 9950
Wire Wire Line
	6800 8700 5450 8700
Wire Wire Line
	8700 2200 8700 2850
Connection ~ 3400 7850
Wire Wire Line
	3400 7850 3400 9000
Wire Wire Line
	4500 7850 4500 7950
Wire Wire Line
	1850 7850 4500 7850
Wire Wire Line
	3250 8750 3750 8750
Connection ~ 3400 8500
Wire Wire Line
	3400 9000 3750 9000
Wire Wire Line
	3750 8500 3400 8500
Connection ~ 8700 2850
Wire Wire Line
	8750 2200 8700 2200
Wire Wire Line
	10700 2850 1850 2850
Wire Wire Line
	10700 2200 10700 2850
Wire Wire Line
	10750 2200 10700 2200
Connection ~ 8500 2550
Wire Wire Line
	8500 3800 8100 3800
Wire Wire Line
	8500 1700 8750 1700
Wire Wire Line
	10500 1700 10750 1700
Wire Wire Line
	10500 2550 10500 1700
Wire Wire Line
	8500 2550 10500 2550
Wire Wire Line
	8500 1700 8500 3800
Wire Wire Line
	8400 2450 10400 2450
Connection ~ 4700 3900
Wire Wire Line
	3250 2950 3250 8750
Wire Wire Line
	12450 2950 3250 2950
Wire Wire Line
	12450 1700 12450 2950
Wire Wire Line
	12150 1700 12450 1700
Wire Wire Line
	10400 1800 10750 1800
Wire Wire Line
	10400 2450 10400 1800
Connection ~ 8400 1900
Wire Wire Line
	10300 1900 10750 1900
Wire Wire Line
	10300 1700 10300 1900
Wire Wire Line
	10150 1700 10300 1700
Wire Wire Line
	10400 1400 10750 1400
Wire Wire Line
	10400 850  10400 1400
Connection ~ 8400 850 
Connection ~ 10400 1300
Connection ~ 10400 1200
Wire Wire Line
	10400 1200 10750 1200
Wire Wire Line
	10400 1300 10750 1300
Connection ~ 8400 1800
Wire Wire Line
	8400 1900 8750 1900
Wire Wire Line
	8400 1800 8750 1800
Wire Wire Line
	8400 1700 8400 3050
Wire Wire Line
	8150 1700 8400 1700
Connection ~ 6400 850 
Wire Wire Line
	8400 1500 8750 1500
Connection ~ 8400 1200
Wire Wire Line
	8400 850  8400 1500
Wire Wire Line
	8400 1200 8750 1200
Wire Wire Line
	4400 4600 4950 4600
Connection ~ 6500 2550
Wire Wire Line
	6500 4700 6150 4700
Wire Wire Line
	4400 3900 6900 3900
Wire Wire Line
	4600 3600 2950 3600
Wire Wire Line
	2500 2550 6500 2550
Connection ~ 4700 2750
Wire Wire Line
	2700 2200 2700 2750
Wire Wire Line
	2750 2200 2700 2200
Wire Wire Line
	4700 2200 4750 2200
Wire Wire Line
	4700 2200 4700 3900
Wire Wire Line
	2700 2750 6700 2750
Wire Wire Line
	6700 2750 6700 2200
Wire Wire Line
	6700 2200 6750 2200
Connection ~ 6400 1800
Wire Wire Line
	6400 1900 6750 1900
Wire Wire Line
	6400 1800 6750 1800
Wire Wire Line
	6400 1700 6400 1900
Wire Wire Line
	6150 1700 6400 1700
Connection ~ 4600 2650
Wire Wire Line
	6600 2000 6750 2000
Wire Wire Line
	6600 2650 6600 2000
Wire Wire Line
	4600 2000 4750 2000
Wire Wire Line
	4600 2000 4600 3600
Wire Wire Line
	2600 2000 2750 2000
Wire Wire Line
	2600 2650 2600 2000
Wire Wire Line
	10600 2650 2600 2650
Wire Wire Line
	1950 3600 2050 3600
Connection ~ 4500 2550
Wire Wire Line
	6500 1700 6500 4700
Wire Wire Line
	6750 1700 6500 1700
Wire Wire Line
	4500 1700 4500 2550
Wire Wire Line
	4500 1700 4750 1700
Wire Wire Line
	2500 1700 2500 2550
Wire Wire Line
	2750 1700 2500 1700
Connection ~ 4400 850 
Connection ~ 6400 1300
Wire Wire Line
	6400 1500 6750 1500
Connection ~ 6400 1200
Wire Wire Line
	6400 850  6400 1500
Wire Wire Line
	6400 1200 6750 1200
Wire Wire Line
	6400 1300 6750 1300
Connection ~ 4400 1300
Wire Wire Line
	4400 1500 4750 1500
Connection ~ 4400 1800
Wire Wire Line
	4400 1900 4750 1900
Wire Wire Line
	4400 1800 4750 1800
Wire Wire Line
	4400 1700 4400 1900
Wire Wire Line
	4150 1700 4400 1700
Connection ~ 4400 1200
Connection ~ 2400 850 
Wire Wire Line
	4400 850  4400 1500
Wire Wire Line
	4400 1200 4750 1200
Wire Wire Line
	4400 1300 4750 1300
Connection ~ 2400 1800
Wire Wire Line
	1850 850  10400 850 
Wire Wire Line
	2400 1800 2750 1800
Wire Wire Line
	2400 850  2400 1900
Wire Wire Line
	2400 1900 2750 1900
Wire Wire Line
	11800 8700 14550 8700
Wire Wire Line
	10350 8700 10900 8700
Wire Wire Line
	3850 6950 3150 6950
Wire Wire Line
	3150 6950 3150 3600
Connection ~ 3150 3600
Wire Wire Line
	9150 8800 7850 8800
Wire Wire Line
	5250 8500 6800 8500
$EndSCHEMATC
