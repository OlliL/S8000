EESchema Schematic File Version 2
LIBS:FINCH_Harddisk
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
LIBS:FINCH_Harddisk-cache
EELAYER 25 0
EELAYER END
$Descr A3 16535 11693
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
L CONN_01X06 J3
U 1 1 57A38F83
P 800 2650
F 0 "J3" H 800 3000 50  0000 C CNN
F 1 "Mainboard" V 900 2650 50  0000 C CNN
F 2 "" H 800 2650 50  0000 C CNN
F 3 "" H 800 2650 50  0000 C CNN
	1    800  2650
	-1   0    0    -1  
$EndComp
Wire Wire Line
	1000 2700 1250 2700
Wire Wire Line
	1250 2700 1250 3050
$Comp
L GND #PWR?
U 1 1 57A3906B
P 1250 3050
F 0 "#PWR?" H 1250 2800 50  0001 C CNN
F 1 "GND" H 1250 2900 50  0000 C CNN
F 2 "" H 1250 3050 50  0000 C CNN
F 3 "" H 1250 3050 50  0000 C CNN
	1    1250 3050
	1    0    0    -1  
$EndComp
Wire Wire Line
	1000 2400 1250 2400
Wire Wire Line
	1250 2400 1250 2200
$Comp
L +24V #PWR?
U 1 1 57A39087
P 1250 2200
F 0 "#PWR?" H 1250 2050 50  0001 C CNN
F 1 "+24V" H 1250 2340 50  0000 C CNN
F 2 "" H 1250 2200 50  0000 C CNN
F 3 "" H 1250 2200 50  0000 C CNN
	1    1250 2200
	1    0    0    -1  
$EndComp
Wire Wire Line
	1000 2800 1450 2800
Wire Wire Line
	1450 2800 1450 2200
$Comp
L +5V #PWR?
U 1 1 57A390A5
P 1450 2200
F 0 "#PWR?" H 1450 2050 50  0001 C CNN
F 1 "+5V" H 1450 2340 50  0000 C CNN
F 2 "" H 1450 2200 50  0000 C CNN
F 3 "" H 1450 2200 50  0000 C CNN
	1    1450 2200
	1    0    0    -1  
$EndComp
$Comp
L CONN_01X02 J2
U 1 1 57A390C3
P 800 3900
F 0 "J2" H 800 4050 50  0000 C CNN
F 1 "Motor-Brake" V 900 3900 50  0000 C CNN
F 2 "" H 800 3900 50  0000 C CNN
F 3 "" H 800 3900 50  0000 C CNN
	1    800  3900
	-1   0    0    -1  
$EndComp
Wire Wire Line
	1250 3850 1250 3650
$Comp
L +24V #PWR?
U 1 1 57A3912B
P 1250 3650
F 0 "#PWR?" H 1250 3500 50  0001 C CNN
F 1 "+24V" H 1250 3790 50  0000 C CNN
F 2 "" H 1250 3650 50  0000 C CNN
F 3 "" H 1250 3650 50  0000 C CNN
	1    1250 3650
	1    0    0    -1  
$EndComp
Wire Wire Line
	1250 3950 1250 4150
$Comp
L GND #PWR?
U 1 1 57A39134
P 1250 4150
F 0 "#PWR?" H 1250 3900 50  0001 C CNN
F 1 "GND" H 1250 4000 50  0000 C CNN
F 2 "" H 1250 4150 50  0000 C CNN
F 3 "" H 1250 4150 50  0000 C CNN
	1    1250 4150
	1    0    0    -1  
$EndComp
Wire Wire Line
	1000 3950 1250 3950
Wire Wire Line
	1000 3850 1250 3850
$Comp
L CONN_01X03 J1
U 1 1 57A391AC
P 800 4800
F 0 "J1" H 800 5000 50  0000 C CNN
F 1 "Motor" V 900 4800 50  0000 C CNN
F 2 "" H 800 4800 50  0000 C CNN
F 3 "" H 800 4800 50  0000 C CNN
	1    800  4800
	-1   0    0    -1  
$EndComp
$Comp
L 74LS74 U12
U 2 1 57A3924D
P 6750 2950
F 0 "U12" H 6900 3250 50  0000 C CNN
F 1 "74LS74" H 7050 2655 50  0000 C CNN
F 2 "" H 6750 2950 50  0000 C CNN
F 3 "" H 6750 2950 50  0000 C CNN
	2    6750 2950
	1    0    0    -1  
$EndComp
Wire Wire Line
	1000 2500 3000 2500
Wire Wire Line
	3000 2500 3000 2950
Wire Wire Line
	3000 2950 3000 4950
Wire Wire Line
	3000 4950 3000 6250
Wire Wire Line
	3000 6250 3000 7550
Wire Wire Line
	3000 2950 6150 2950
$Comp
L 74LS161 U2
U 1 1 57A39556
P 4000 4650
F 0 "U2" H 4050 4750 50  0000 C CNN
F 1 "74161" H 4100 4450 50  0000 C CNN
F 2 "" H 4000 4650 50  0000 C CNN
F 3 "" H 4000 4650 50  0000 C CNN
	1    4000 4650
	1    0    0    -1  
$EndComp
$Comp
L 74LS161 U3
U 1 1 57A39618
P 4000 5950
F 0 "U3" H 4050 6050 50  0000 C CNN
F 1 "74161" H 4100 5750 50  0000 C CNN
F 2 "" H 4000 5950 50  0000 C CNN
F 3 "" H 4000 5950 50  0000 C CNN
	1    4000 5950
	1    0    0    -1  
$EndComp
$Comp
L 74LS161 U4
U 1 1 57A3965C
P 4000 7250
F 0 "U4" H 4050 7350 50  0000 C CNN
F 1 "74LS161" H 4100 7050 50  0000 C CNN
F 2 "" H 4000 7250 50  0000 C CNN
F 3 "" H 4000 7250 50  0000 C CNN
	1    4000 7250
	1    0    0    -1  
$EndComp
Wire Wire Line
	3000 4950 3300 4950
Connection ~ 3000 2950
Wire Wire Line
	3000 6250 3300 6250
Connection ~ 3000 4950
Wire Wire Line
	3000 7550 3300 7550
Connection ~ 3000 6250
$Comp
L 74LS14 U6
U 6 1 57A39799
P 3150 2100
F 0 "U6" H 3300 2200 50  0000 C CNN
F 1 "74LS14" H 3350 2000 50  0000 C CNN
F 2 "" H 3150 2100 50  0000 C CNN
F 3 "" H 3150 2100 50  0000 C CNN
	6    3150 2100
	1    0    0    -1  
$EndComp
Wire Wire Line
	1000 2600 2500 2600
Wire Wire Line
	2500 2600 5900 2600
Wire Wire Line
	2500 2100 2700 2100
Wire Wire Line
	6750 3500 6750 3750
Connection ~ 2500 2100
$Comp
L 74LS74 U12
U 1 1 57A39D11
P 6750 1300
F 0 "U12" H 6900 1600 50  0000 C CNN
F 1 "74LS74" H 7050 1005 50  0000 C CNN
F 2 "" H 6750 1300 50  0000 C CNN
F 3 "" H 6750 1300 50  0000 C CNN
	1    6750 1300
	1    0    0    -1  
$EndComp
Connection ~ 2500 2600
Wire Wire Line
	6750 1850 6750 2400
Wire Wire Line
	6750 750  6750 550 
Wire Wire Line
	6750 550  2500 550 
Wire Wire Line
	6150 2750 5550 2750
Wire Wire Line
	5550 2750 5550 7250
Wire Wire Line
	5550 7250 4700 7250
Wire Wire Line
	4700 5950 4950 5950
Wire Wire Line
	4950 5950 4950 6600
Wire Wire Line
	4950 6600 3100 6600
Wire Wire Line
	3100 6600 3100 7450
Wire Wire Line
	3100 7450 3300 7450
Wire Wire Line
	4700 4650 4950 4650
Wire Wire Line
	4950 4650 4950 5300
Wire Wire Line
	4950 5300 3100 5300
Wire Wire Line
	3100 5300 3100 6150
Wire Wire Line
	3100 6150 3300 6150
$Comp
L 74LS08 U8
U 3 1 57A3A74A
P 4850 2000
F 0 "U8" H 4850 2050 50  0000 C CNN
F 1 "74LS08" H 4850 1950 50  0000 C CNN
F 2 "" H 4850 2000 50  0000 C CNN
F 3 "" H 4850 2000 50  0000 C CNN
	3    4850 2000
	1    0    0    -1  
$EndComp
Wire Wire Line
	3600 2100 4250 2100
$Comp
L 74LS42 U7
U 1 1 57A3AA9F
P 3700 8900
F 0 "U7" H 3700 8900 50  0000 C CNN
F 1 "74LS42" H 3800 8600 50  0000 C CNN
F 2 "" H 3700 8900 50  0000 C CNN
F 3 "" H 3700 8900 50  0000 C CNN
	1    3700 8900
	1    0    0    -1  
$EndComp
Wire Wire Line
	1000 2900 2150 2900
Wire Wire Line
	2150 2900 2150 8750
Wire Wire Line
	2150 8750 2150 9800
Wire Wire Line
	2150 8750 3050 8750
$Comp
L 74LS14 U6
U 1 1 57A3ACB0
P 3500 9800
F 0 "U6" H 3650 9900 50  0000 C CNN
F 1 "74LS14" H 3700 9700 50  0000 C CNN
F 2 "" H 3500 9800 50  0000 C CNN
F 3 "" H 3500 9800 50  0000 C CNN
	1    3500 9800
	-1   0    0    -1  
$EndComp
Wire Wire Line
	2150 9800 3050 9800
Connection ~ 2150 8750
Wire Wire Line
	5900 2600 5900 3750
Wire Wire Line
	5900 3750 6750 3750
Wire Wire Line
	6750 3750 7425 3750
Wire Wire Line
	2500 550  2500 2100
Wire Wire Line
	2500 2100 2500 2600
$Comp
L TEST_1P TP6
U 1 1 57A3BB9B
P 4250 10075
F 0 "TP6" H 4250 10300 50  0000 C CNN
F 1 "TEST_1P" H 4250 10275 50  0001 C CNN
F 2 "" H 4450 10075 50  0000 C CNN
F 3 "" H 4450 10075 50  0000 C CNN
	1    4250 10075
	-1   0    0    1   
$EndComp
Wire Wire Line
	3950 9800 4250 9800
Wire Wire Line
	4250 9800 4650 9800
Wire Wire Line
	4250 9800 4250 10075
Wire Wire Line
	7425 3750 7425 4025
Connection ~ 6750 3750
$Comp
L TEST_1P TP2
U 1 1 57A3A300
P 7425 4025
F 0 "TP2" H 7425 4250 50  0000 C CNN
F 1 "TEST_1P" H 7425 4225 50  0001 C CNN
F 2 "" H 7625 4025 50  0000 C CNN
F 3 "" H 7625 4025 50  0000 C CNN
	1    7425 4025
	-1   0    0    1   
$EndComp
Wire Wire Line
	7350 3150 7675 3150
Wire Wire Line
	7675 3150 7675 4025
$Comp
L TEST_1P TP7
U 1 1 57A3A6C1
P 7675 4025
F 0 "TP7" H 7675 4250 50  0000 C CNN
F 1 "TEST_1P" H 7675 4225 50  0001 C CNN
F 2 "" H 7875 4025 50  0000 C CNN
F 3 "" H 7875 4025 50  0000 C CNN
	1    7675 4025
	-1   0    0    1   
$EndComp
$Comp
L LM3900 U5
U 3 1 57A39FD9
P 5100 9800
F 0 "U5" H 5295 9915 50  0000 C CNN
F 1 "LM3900" H 5290 9675 50  0000 C CNN
F 2 "" H 5100 9800 50  0000 C CNN
F 3 "" H 5100 9800 50  0000 C CNN
	3    5100 9800
	-1   0    0    -1  
$EndComp
Connection ~ 4250 9800
Wire Wire Line
	6500 9900 6500 9450
$Comp
L +5V #PWR?
U 1 1 57A3B0B4
P 6500 9450
F 0 "#PWR?" H 6500 9300 50  0001 C CNN
F 1 "+5V" H 6500 9590 50  0000 C CNN
F 2 "" H 6500 9450 50  0000 C CNN
F 3 "" H 6500 9450 50  0000 C CNN
	1    6500 9450
	1    0    0    -1  
$EndComp
Wire Wire Line
	5550 9900 5850 9900
Wire Wire Line
	6900 10300 6900 10725
$Comp
L GND #PWR?
U 1 1 57A3BAFB
P 6900 10725
F 0 "#PWR?" H 6900 10475 50  0001 C CNN
F 1 "GND" H 6900 10575 50  0000 C CNN
F 2 "" H 6900 10725 50  0000 C CNN
F 3 "" H 6900 10725 50  0000 C CNN
	1    6900 10725
	1    0    0    -1  
$EndComp
$Comp
L R R1
U 1 1 57A3BB8B
P 6900 9675
F 0 "R1" V 6980 9675 50  0000 C CNN
F 1 "150" V 6900 9675 50  0000 C CNN
F 2 "" V 6830 9675 50  0000 C CNN
F 3 "" H 6900 9675 50  0000 C CNN
	1    6900 9675
	1    0    0    -1  
$EndComp
Wire Wire Line
	6900 9825 6900 9900
Wire Wire Line
	6900 9525 6900 9450
$Comp
L +5V #PWR?
U 1 1 57A3BE3C
P 6900 9450
F 0 "#PWR?" H 6900 9300 50  0001 C CNN
F 1 "+5V" H 6900 9590 50  0000 C CNN
F 2 "" H 6900 9450 50  0000 C CNN
F 3 "" H 6900 9450 50  0000 C CNN
	1    6900 9450
	1    0    0    -1  
$EndComp
Wire Wire Line
	5850 9900 5850 10600
Wire Wire Line
	5850 10600 6500 10600
Wire Wire Line
	6500 10600 6500 10300
Wire Wire Line
	5550 9700 5850 9700
$Comp
L R R4
U 1 1 57A3C71A
P 5850 9250
F 0 "R4" V 5930 9250 50  0000 C CNN
F 1 "22k" V 5850 9250 50  0000 C CNN
F 2 "" V 5780 9250 50  0000 C CNN
F 3 "" H 5850 9250 50  0000 C CNN
	1    5850 9250
	1    0    0    -1  
$EndComp
Wire Wire Line
	5850 9700 5850 9400
Wire Wire Line
	5850 9100 5850 8950
$Comp
L +5V #PWR?
U 1 1 57A3C934
P 5850 8950
F 0 "#PWR?" H 5850 8800 50  0001 C CNN
F 1 "+5V" H 5850 9090 50  0000 C CNN
F 2 "" H 5850 8950 50  0000 C CNN
F 3 "" H 5850 8950 50  0000 C CNN
	1    5850 8950
	1    0    0    -1  
$EndComp
Text Notes 7275 11075 0    60   ~ 0
Motor Board
Text Notes 2225 9750 0    60   ~ 0
RPM-Signal
Text Notes 2225 10125 0    60   ~ 0
4 times high\n4 times low\nper one revolution
$Comp
L OP3561 OP?
U 1 1 57A4D9D6
P 6700 10100
F 0 "OP?" H 6700 10250 50  0000 C CNN
F 1 "OP3561" H 6700 10000 50  0000 C CNN
F 2 "" H 6650 10100 50  0000 C CNN
F 3 "" H 6650 10100 50  0000 C CNN
	1    6700 10100
	-1   0    0    -1  
$EndComp
Wire Notes Line
	8075 500  8075 11200
Text Label 1525 2900 0    60   ~ 0
MOTOR_RPM
$Comp
L C C?
U 1 1 57A4F151
P 11400 2400
F 0 "C?" V 11450 2475 50  0000 L CNN
F 1 "22n" V 11350 2200 50  0000 L CNN
F 2 "" H 11438 2250 50  0000 C CNN
F 3 "" H 11400 2400 50  0000 C CNN
	1    11400 2400
	0    1    1    0   
$EndComp
Wire Wire Line
	11550 2400 11675 2400
Wire Wire Line
	11675 2400 12050 2400
$Comp
L R R?
U 1 1 57A4FAB7
P 12200 2400
F 0 "R?" V 12280 2400 50  0000 C CNN
F 1 "22k" V 12200 2400 50  0000 C CNN
F 2 "" V 12130 2400 50  0000 C CNN
F 3 "" H 12200 2400 50  0000 C CNN
	1    12200 2400
	0    1    1    0   
$EndComp
Wire Wire Line
	12350 2400 12550 2400
Wire Wire Line
	12550 2400 12550 2600
$Comp
L GND #PWR?
U 1 1 57A4FBA8
P 12550 2600
F 0 "#PWR?" H 12550 2350 50  0001 C CNN
F 1 "GND" H 12550 2450 50  0000 C CNN
F 2 "" H 12550 2600 50  0000 C CNN
F 3 "" H 12550 2600 50  0000 C CNN
	1    12550 2600
	1    0    0    -1  
$EndComp
$Comp
L PN2222A Q?
U 1 1 57A4FBEA
P 13300 4750
F 0 "Q?" H 13500 4825 50  0000 L CNN
F 1 "2N2222A" H 13500 4750 50  0000 L CNN
F 2 "" H 13500 4675 50  0000 L CIN
F 3 "" H 13300 4750 50  0000 L CNN
	1    13300 4750
	1    0    0    -1  
$EndComp
Wire Wire Line
	11850 1800 11675 1800
Wire Wire Line
	11675 1800 11675 2400
Connection ~ 11675 2400
$Comp
L R R?
U 1 1 57A4FDD3
P 12000 3250
F 0 "R?" V 12080 3250 50  0000 C CNN
F 1 "410" V 12000 3250 50  0000 C CNN
F 2 "" V 11930 3250 50  0000 C CNN
F 3 "" H 12000 3250 50  0000 C CNN
	1    12000 3250
	0    1    1    0   
$EndComp
$Comp
L R R?
U 1 1 57A50128
P 11450 3250
F 0 "R?" V 11530 3250 50  0000 C CNN
F 1 "3k3" V 11450 3250 50  0000 C CNN
F 2 "" V 11380 3250 50  0000 C CNN
F 3 "" H 11450 3250 50  0000 C CNN
	1    11450 3250
	0    1    1    0   
$EndComp
$Comp
L 8749 U?
U 1 1 57A5062C
P 9750 2200
F 0 "U?" H 9200 3600 50  0000 L CNN
F 1 "8749" H 10100 3600 50  0000 L CNN
F 2 "" H 9750 2400 50  0000 C CNN
F 3 "" H 9750 2400 50  0000 C CNN
	1    9750 2200
	-1   0    0    -1  
$EndComp
Wire Wire Line
	9050 1700 8300 1700
Text Label 8425 1700 0    60   ~ 0
MOTOR_RPM
Wire Wire Line
	10450 2400 10900 2400
Wire Wire Line
	10900 2400 11250 2400
Wire Wire Line
	11300 3250 10900 3250
Wire Wire Line
	10900 3250 10900 2400
Connection ~ 10900 2400
$Comp
L R R?
U 1 1 57A51AD1
P 12000 3050
F 0 "R?" V 12080 3050 50  0000 C CNN
F 1 "27k" V 12000 3050 50  0000 C CNN
F 2 "" V 11930 3050 50  0000 C CNN
F 3 "" H 12000 3050 50  0000 C CNN
	1    12000 3050
	0    1    1    0   
$EndComp
Wire Wire Line
	11850 3050 11750 3050
Wire Wire Line
	11750 2850 11750 3050
Wire Wire Line
	11750 3050 11750 3250
Wire Wire Line
	11750 3250 11750 3750
Wire Wire Line
	11750 3750 11750 4100
Wire Wire Line
	11600 3250 11750 3250
Wire Wire Line
	11750 3250 11850 3250
Connection ~ 11750 3250
$Comp
L D D?
U 1 1 57A51CAD
P 12000 2850
F 0 "D?" H 12000 2950 50  0000 C CNN
F 1 "D" H 12000 2750 50  0000 C CNN
F 2 "" H 12000 2850 50  0000 C CNN
F 3 "" H 12000 2850 50  0000 C CNN
	1    12000 2850
	1    0    0    -1  
$EndComp
Wire Wire Line
	11850 2850 11750 2850
Connection ~ 11750 3050
$Comp
L R R?
U 1 1 57A51E23
P 12000 4100
F 0 "R?" V 12080 4100 50  0000 C CNN
F 1 "37k3" V 12000 4100 50  0000 C CNN
F 2 "" V 11930 4100 50  0000 C CNN
F 3 "" H 12000 4100 50  0000 C CNN
	1    12000 4100
	0    1    1    0   
$EndComp
$Comp
L R R?
U 1 1 57A51E29
P 12000 3750
F 0 "R?" V 12080 3750 50  0000 C CNN
F 1 "4k7" V 12000 3750 50  0000 C CNN
F 2 "" V 11930 3750 50  0000 C CNN
F 3 "" H 12000 3750 50  0000 C CNN
	1    12000 3750
	0    1    1    0   
$EndComp
Wire Wire Line
	11750 3750 11850 3750
Wire Wire Line
	11750 4100 11850 4100
Connection ~ 11750 3750
Wire Wire Line
	12150 2850 12400 2850
Wire Wire Line
	12400 2850 13400 2850
Wire Wire Line
	13400 2850 13750 2850
Wire Wire Line
	12400 2850 12400 3050
Wire Wire Line
	12400 3050 12150 3050
$Comp
L LM3046 Q?
U 4 1 57A53494
P 13400 3200
F 0 "Q?" H 13400 2950 50  0000 C CNN
F 1 "LM3046" H 13400 3025 50  0000 C CNN
F 2 "" H 13400 3200 60  0000 C CNN
F 3 "" H 13400 3200 60  0000 C CNN
	4    13400 3200
	-1   0    0    -1  
$EndComp
Wire Wire Line
	13400 2850 13400 3050
Connection ~ 12400 2850
$Comp
L CP C?
U 1 1 57A536B4
P 13900 2850
F 0 "C?" V 13800 2700 50  0000 L CNN
F 1 "CP" V 13950 2950 50  0000 L CNN
F 2 "" H 13938 2700 50  0000 C CNN
F 3 "" H 13900 2850 50  0000 C CNN
	1    13900 2850
	0    -1   -1   0   
$EndComp
Wire Wire Line
	14050 2850 14300 2850
Wire Wire Line
	14300 2850 14300 2950
$Comp
L GND #PWR?
U 1 1 57A53C63
P 14300 2950
F 0 "#PWR?" H 14300 2700 50  0001 C CNN
F 1 "GND" H 14300 2800 50  0000 C CNN
F 2 "" H 14300 2950 50  0000 C CNN
F 3 "" H 14300 2950 50  0000 C CNN
	1    14300 2950
	1    0    0    -1  
$EndComp
Connection ~ 13400 2850
Wire Wire Line
	12150 3250 13200 3250
$Comp
L LM3046 Q?
U 5 1 57A54366
P 13400 3700
F 0 "Q?" H 13400 3450 50  0000 C CNN
F 1 "LM3046" H 13400 3525 50  0000 C CNN
F 2 "" H 13400 3700 60  0000 C CNN
F 3 "" H 13400 3700 60  0000 C CNN
	5    13400 3700
	-1   0    0    -1  
$EndComp
Wire Wire Line
	12150 3750 13200 3750
$Comp
L R R?
U 1 1 57A54C1F
P 12850 4100
F 0 "R?" V 12930 4100 50  0000 C CNN
F 1 "51k5" V 12850 4100 50  0000 C CNN
F 2 "" V 12780 4100 50  0000 C CNN
F 3 "" H 12850 4100 50  0000 C CNN
	1    12850 4100
	0    1    1    0   
$EndComp
Wire Wire Line
	12150 4100 12400 4100
Wire Wire Line
	12400 4100 12700 4100
Wire Wire Line
	13000 4100 14300 4100
Wire Wire Line
	14300 4100 14300 4450
$Comp
L GND #PWR?
U 1 1 57A55386
P 14300 4450
F 0 "#PWR?" H 14300 4200 50  0001 C CNN
F 1 "GND" H 14300 4300 50  0000 C CNN
F 2 "" H 14300 4450 50  0000 C CNN
F 3 "" H 14300 4450 50  0000 C CNN
	1    14300 4450
	1    0    0    -1  
$EndComp
$Comp
L D D?
U 1 1 57A55D9D
P 12850 4450
F 0 "D?" H 12850 4550 50  0000 C CNN
F 1 "D" H 12850 4350 50  0000 C CNN
F 2 "" H 12850 4450 50  0000 C CNN
F 3 "" H 12850 4450 50  0000 C CNN
	1    12850 4450
	-1   0    0    -1  
$EndComp
Wire Wire Line
	12700 4450 12400 4450
Wire Wire Line
	12400 4450 12400 4100
Connection ~ 12400 4100
Wire Wire Line
	13000 4450 13400 4450
Wire Wire Line
	13400 4450 13400 4550
$Comp
L PN2222A Q?
U 1 1 57A56CC1
P 12050 1800
F 0 "Q?" H 12250 1875 50  0000 L CNN
F 1 "2N2222A" H 12250 1800 50  0000 L CNN
F 2 "" H 12250 1725 50  0000 L CIN
F 3 "" H 12050 1800 50  0000 L CNN
	1    12050 1800
	1    0    0    -1  
$EndComp
Wire Wire Line
	12150 2000 12150 2150
Wire Wire Line
	12150 2150 12650 2150
$Comp
L R R?
U 1 1 57A57563
P 12800 2150
F 0 "R?" V 12880 2150 50  0000 C CNN
F 1 "2k2" V 12800 2150 50  0000 C CNN
F 2 "" V 12730 2150 50  0000 C CNN
F 3 "" H 12800 2150 50  0000 C CNN
	1    12800 2150
	0    1    1    0   
$EndComp
Wire Wire Line
	12950 2150 13150 2150
Wire Wire Line
	13150 2150 13550 2150
Wire Wire Line
	13150 2150 13150 2350
$Comp
L GND #PWR?
U 1 1 57A5756B
P 13150 2350
F 0 "#PWR?" H 13150 2100 50  0001 C CNN
F 1 "GND" H 13150 2200 50  0000 C CNN
F 2 "" H 13150 2350 50  0000 C CNN
F 3 "" H 13150 2350 50  0000 C CNN
	1    13150 2350
	1    0    0    -1  
$EndComp
$Comp
L PN2222A Q?
U 1 1 57A5773B
P 13750 2150
F 0 "Q?" H 13950 2225 50  0000 L CNN
F 1 "2N2222A" H 13950 2150 50  0000 L CNN
F 2 "" H 13950 2075 50  0000 L CIN
F 3 "" H 13750 2150 50  0000 L CNN
	1    13750 2150
	1    0    0    -1  
$EndComp
Connection ~ 13150 2150
$Comp
L C C?
U 1 1 57A578EE
P 14300 1600
F 0 "C?" V 14350 1675 50  0000 L CNN
F 1 "1u5" V 14250 1400 50  0000 L CNN
F 2 "" H 14338 1450 50  0000 C CNN
F 3 "" H 14300 1600 50  0000 C CNN
	1    14300 1600
	0    1    1    0   
$EndComp
Wire Wire Line
	14450 1600 14650 1600
Wire Wire Line
	14650 1600 14650 1800
$Comp
L GND #PWR?
U 1 1 57A57A12
P 14650 1800
F 0 "#PWR?" H 14650 1550 50  0001 C CNN
F 1 "GND" H 14650 1650 50  0000 C CNN
F 2 "" H 14650 1800 50  0000 C CNN
F 3 "" H 14650 1800 50  0000 C CNN
	1    14650 1800
	1    0    0    -1  
$EndComp
Wire Wire Line
	14150 1600 13850 1600
Wire Wire Line
	13850 1150 13850 1600
Wire Wire Line
	13850 1600 13850 1950
$Comp
L LM339 U?
U 3 1 57A57B2C
P 14400 1050
F 0 "U?" H 14450 1250 50  0000 C CNN
F 1 "LM339" H 14500 850 50  0000 C CNN
F 2 "" H 14350 1150 50  0000 C CNN
F 3 "" H 14450 1250 50  0000 C CNN
	3    14400 1050
	1    0    0    -1  
$EndComp
Wire Wire Line
	13700 1150 13850 1150
Wire Wire Line
	13850 1150 14100 1150
Connection ~ 13850 1600
$Comp
L R R?
U 1 1 57A57E61
P 13550 1150
F 0 "R?" V 13630 1150 50  0000 C CNN
F 1 "?" V 13550 1150 50  0000 C CNN
F 2 "" V 13480 1150 50  0000 C CNN
F 3 "" H 13550 1150 50  0000 C CNN
	1    13550 1150
	0    1    1    0   
$EndComp
Connection ~ 13850 1150
$Comp
L R R?
U 1 1 57A589CE
P 12950 650
F 0 "R?" V 13030 650 50  0000 C CNN
F 1 "27k" V 12950 650 50  0000 C CNN
F 2 "" V 12880 650 50  0000 C CNN
F 3 "" H 12950 650 50  0000 C CNN
	1    12950 650 
	0    1    1    0   
$EndComp
Wire Wire Line
	13100 1150 13250 1150
Wire Wire Line
	13250 1150 13400 1150
$Comp
L R R?
U 1 1 57A59A10
P 12950 1150
F 0 "R?" V 13030 1150 50  0000 C CNN
F 1 "100k" V 12950 1150 50  0000 C CNN
F 2 "" V 12880 1150 50  0000 C CNN
F 3 "" H 12950 1150 50  0000 C CNN
	1    12950 1150
	0    1    1    0   
$EndComp
Wire Wire Line
	13100 650  13250 650 
Wire Wire Line
	13250 650  13250 1150
Connection ~ 13250 1150
$Comp
L R R?
U 1 1 57A5A10B
P 12300 1150
F 0 "R?" V 12380 1150 50  0000 C CNN
F 1 "4k7" V 12300 1150 50  0000 C CNN
F 2 "" V 12230 1150 50  0000 C CNN
F 3 "" H 12300 1150 50  0000 C CNN
	1    12300 1150
	0    1    1    0   
$EndComp
Wire Wire Line
	12800 1150 12450 1150
Wire Wire Line
	12150 1150 11950 1150
Wire Wire Line
	11950 1150 11950 1350
$Comp
L GND #PWR?
U 1 1 57A5A6C6
P 11950 1350
F 0 "#PWR?" H 11950 1100 50  0001 C CNN
F 1 "GND" H 11950 1200 50  0000 C CNN
F 2 "" H 11950 1350 50  0000 C CNN
F 3 "" H 11950 1350 50  0000 C CNN
	1    11950 1350
	-1   0    0    -1  
$EndComp
$Comp
L LM3046 Q?
U 3 1 57A5AF41
P 11850 600
F 0 "Q?" H 11850 350 50  0000 C CNN
F 1 "LM3046" H 11850 425 50  0000 C CNN
F 2 "" H 11850 600 60  0000 C CNN
F 3 "" H 11850 600 60  0000 C CNN
	3    11850 600 
	1    0    0    -1  
$EndComp
Wire Wire Line
	12800 650  12050 650 
$Comp
L 74LS38 U?
U 4 1 57A5C9B3
P 14550 6500
F 0 "U?" H 14550 6550 50  0000 C CNN
F 1 "74LS38" H 14550 6450 50  0000 C CNN
F 2 "" H 14550 6500 50  0000 C CNN
F 3 "" H 14550 6500 50  0000 C CNN
	4    14550 6500
	1    0    0    -1  
$EndComp
Wire Notes Line
	16050 5200 8050 5200
Wire Wire Line
	15150 6500 15950 6500
Text Label 15250 6500 0    60   ~ 0
DRV_DATA_INDEX
Wire Wire Line
	13950 6600 13800 6600
Wire Wire Line
	13800 6400 13800 6600
Wire Wire Line
	13800 6600 13800 6950
Wire Wire Line
	12900 6400 13800 6400
Wire Wire Line
	13800 6400 13950 6400
Connection ~ 13800 6400
$Comp
L 74LS38 U?
U 1 1 57A5E72A
P 14550 7050
F 0 "U?" H 14550 7100 50  0000 C CNN
F 1 "74LS38" H 14550 7000 50  0000 C CNN
F 2 "" H 14550 7050 50  0000 C CNN
F 3 "" H 14550 7050 50  0000 C CNN
	1    14550 7050
	1    0    0    1   
$EndComp
Wire Wire Line
	15150 7050 15950 7050
Text Label 15250 7050 0    60   ~ 0
DRV_CMD_INDEX
Wire Wire Line
	13800 6950 13950 6950
Connection ~ 13800 6600
$Comp
L CONN_02X05 P?
U 1 1 57A5ED31
P 12600 8550
F 0 "P?" V 12550 8200 50  0000 C CNN
F 1 "DRIVE_SELECT" V 12650 8000 50  0000 C CNN
F 2 "" H 12600 7350 50  0000 C CNN
F 3 "" H 12600 7350 50  0000 C CNN
	1    12600 8550
	0    -1   -1   0   
$EndComp
Wire Wire Line
	12400 8800 12400 9950
Text Label 12400 9950 1    60   ~ 0
DRV_CMD_DRIVE_SELECT_1
Wire Wire Line
	12500 8300 12500 8050
Wire Wire Line
	12500 8050 12300 8050
Wire Wire Line
	12300 8050 12300 9950
Wire Wire Line
	12700 8800 12700 9950
Wire Wire Line
	12800 8800 12800 9950
Text Label 12300 9950 1    60   ~ 0
DRV_CMD_DRIVE_SELECT_2
Text Label 12700 9950 1    60   ~ 0
DRV_CMD_DRIVE_SELECT_3
Text Label 12800 9950 1    60   ~ 0
DRV_CMD_DRIVE_SELECT_4
Wire Wire Line
	12400 8300 12400 7750
Wire Wire Line
	12150 7750 12400 7750
Wire Wire Line
	12400 7750 12600 7750
Wire Wire Line
	12600 7750 12800 7750
Wire Wire Line
	12800 7750 12800 8300
NoConn ~ 12500 8800
NoConn ~ 12700 8300
Wire Wire Line
	12600 8800 12600 9000
Wire Wire Line
	12600 9000 12150 9000
Wire Wire Line
	12150 9000 12150 7750
Wire Wire Line
	12150 7750 12150 7450
Wire Wire Line
	12150 7450 12150 7150
Connection ~ 12400 7750
Wire Wire Line
	12600 8300 12600 7750
Connection ~ 12600 7750
$Comp
L 74LS04 U?
U 1 1 57A60192
P 12800 7150
F 0 "U?" H 12995 7265 50  0000 C CNN
F 1 "74LS04" H 12990 7025 50  0000 C CNN
F 2 "" H 12800 7150 50  0000 C CNN
F 3 "" H 12800 7150 50  0000 C CNN
	1    12800 7150
	1    0    0    -1  
$EndComp
$Comp
L 74LS04 U?
U 2 1 57A6022D
P 12800 7450
F 0 "U?" H 12995 7565 50  0000 C CNN
F 1 "74LS04" H 12990 7325 50  0000 C CNN
F 2 "" H 12800 7450 50  0000 C CNN
F 3 "" H 12800 7450 50  0000 C CNN
	2    12800 7450
	1    0    0    -1  
$EndComp
Wire Wire Line
	12150 7150 12350 7150
Connection ~ 12150 7750
Wire Wire Line
	12350 7450 12150 7450
Connection ~ 12150 7450
Wire Wire Line
	13250 7150 13650 7150
Wire Wire Line
	13650 7150 13950 7150
Wire Wire Line
	13250 7450 13650 7450
Wire Wire Line
	13650 7450 13650 7150
Connection ~ 13650 7150
Text Label 13300 7150 0    60   ~ 0
DRIVE_SELECT
$Comp
L MC10125 U?
U 1 1 57A611FE
P 12450 6400
F 0 "U?" H 12600 6500 50  0000 C CNN
F 1 "MC10125" H 12650 6300 50  0000 C CNN
F 2 "" H 12450 6400 50  0000 C CNN
F 3 "" H 12450 6400 50  0000 C CNN
	1    12450 6400
	1    0    0    -1  
$EndComp
Wire Wire Line
	12500 6450 12500 6750
Wire Wire Line
	12500 6750 11700 6750
Wire Wire Line
	11700 6750 11700 6300
$Comp
L R R?
U 1 1 57A62572
P 11450 5900
F 0 "R?" V 11530 5900 50  0000 C CNN
F 1 "460" V 11450 5900 50  0000 C CNN
F 2 "" V 11380 5900 50  0000 C CNN
F 3 "" H 11450 5900 50  0000 C CNN
	1    11450 5900
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR?
U 1 1 57A626D9
P 11450 5750
F 0 "#PWR?" H 11450 5600 50  0001 C CNN
F 1 "+5V" H 11450 5890 50  0000 C CNN
F 2 "" H 11450 5750 50  0000 C CNN
F 3 "" H 11450 5750 50  0000 C CNN
	1    11450 5750
	1    0    0    -1  
$EndComp
Text GLabel 10850 6500 0    60   Input ~ 0
PIN_26_@77666001..1
Wire Wire Line
	11700 6300 12000 6300
Wire Wire Line
	12000 6500 11450 6500
Wire Wire Line
	11450 6500 10850 6500
Wire Wire Line
	11450 6050 11450 6200
Wire Wire Line
	11450 6200 11450 6200
Wire Wire Line
	11450 6200 11450 6500
Connection ~ 11450 6500
$EndSCHEMATC