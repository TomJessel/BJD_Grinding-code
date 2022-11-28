(DATE=02-02-2021 TIME=11:29:56 - Wear test with AE)
%
O21
G0 G17 G40 G49 G54 G90 G98
;OUTPUT FILE CREATION
G100 P221 L10 F1 T1 (E:FTP\TOM\RESULTS\221128 DCB Setup.csv)

M12
M103P2
M105P2
M107P2
; GRINDING PARAMETERS
#1 = 0        ; LOOP COUNTER
#2 = 1      ; LOOP TARGET
#3 = 6        ; BURR TOOL NUMBER
#4 = 1.3      ; BURR TOOL DIAMETER
#5 = 1        ; PROBE TOOL NUMBER
#6 = 20       ; WORKPIECE Y LENGTH
;#7
#8 = 24000    ; SPINDLE SPEED(CUT)
#9 = 3000     ; SPINDLE SPEED(OTHER)
#10 = 60      ; FEED RATE(CUT)
#11 = 5.      ; Z CUT DEPTH
#12 = 0.03    ; X CUT DEPTH
;#13
;#14
#15 = 0       ; TOTAL CUTS
#16 = 0       ; CUT REPEAT COUNTER
#17 = 400     ; SIC CUTS PER PROBE
#18 = 1       ; NO. OF CUTS BEFORE MEASURE
;#19=MEASURE TOOL Z HEIGHT
;#20=MEASURE TOOL BEAM SIDE
;#21=MEASURE TOOL INCREMENT
;#22=MEASURE TOOL Y POSITION
;#23 = 4      ; PROBE Y START POS
;#24 = 4      ; PROBE Y STEP DISTANCE
;#25 = 4      ; PROBE Y STEPS
;#26 = 0      ; PROBE INDEX

;Date & Time
#40 = #2400/10000               ; Year
#41 = [#40-FIX[#40]]*100        ; Month
#42 = ROUND[[#41-FIX[#41]]*100] ; Day
#43 = #2401/10000               ; Hour
#44 = [#43-FIX[#43]]*100        ; Minute
#45 = ROUND[[#44-FIX[#44]]*100] ; Second

; Output file headings
G100 P221 L20 F1 (<ELN:1>)
G100 P221 L20 F1 (DATE,<FMT:.2D,#42>-<FMT:.2D,#41>-<FMT:.4D,#40><ELN:1>)
G100 P221 L20 F1 (TIME,<FMT:.2D,#43>:<FMT:.2D,#44>:<FMT:.2D,#45><ELN:1>)
G100 P221 L20 F1 (<ELN:1>)

GOTO3
N1
#16=0.                                                              ; Reset cut repeat counter

N2
;----------------CUT SIC----------------
WHILE[#16LT#18]DO1
T#3M6
G54.1000 P7
G90 G0 X-#4 Y-#4
G0 G43 H#2233 Z50 F5000
M3 S#8
M8
G1 Z-#11
G01 X[[#12*#15]-#[6300+#3]] F#10
;ACOUSTICS SIGNAL
M107P1
;CUTTING PASS
G01 Y#6
M107P2
G40
G1 Z50 F5000
M9
M5
M1   
IF[#1GE#2]GOTO3
#1=#1+1                                                             ; Increment loop counter    
#15=#15+1                                                           ; Increment total cuts    
#16=#16+1                                                           ; Increment cut repeat counter
END1

N3
;-------------MEASURE TOOL--------------
;MEASURE
T#3M6
G53 
G4X10   
G65 P7862 B3 R#4 Z[#11/2] S#8 H1
#604=#[6300+#3]                                                     ; Measured tool radius

N4
;----ANALOGUE TRACE AT Z BOTH SIDES-----
#20=1.                                                              ; Tool beam side
#21=0.04                                                            ; Tool increment
M105P1
G4X1
M103P1  
N41                                                             
#22=[[#522+#523]/2]+#20*[[#4/2]+#21]      
G1 G53 F8000 X#524 Y#22
G49
#19=[[[#520+#521]/2]-[#11/2]]+#[6100+#2233]
G53 Z#19
M3S60
G4X4
G53
#21=#21-0.01
IF[#21GE-0.01]GOTO41
#21=0.04
#20=#20-2.
IF[#20GE-1.]GOTO41
M103P2
M105P2   
M5
G91 G28 Z0
G90

GOTO6

N6
;--------PROBE SIC - PRE CUTTING--------
IF[#16EQ0]GOTO61
GOTO7
N61;PROBE SIC SURFACE - PRE

G100 P221 L20 F1 (Cut No,NC4 Radius,P1,P2,P3,P4)
G100 P221 L20 F1 (<ELN:>)

T#5M6
G54.1000 P7
G0 X-5 Y-5  
G1 G43 H#2233 Z100 F3000

#635 = 4                                       ; Probe Y start position
#636 = 4                                       ; Probe Y step distance
#637 = 16                                      ; Probe Y end Position
#639 = 0                                       ; Running total
#640 = [[#637-#635]/#636]+1                    ; Number of measurements

M104P1
G4X2

N62 ; Set Z height
G0 X5 Y10
G65 P7810 Z10
G65 P7811 Z0 S107
G65 P7810 Z50

G0 X-5 Y-5 
G65 P7810 Z-2 Y#635
G65 P7811 X0
#639=#639+#135

N63                                                                 
#635=#635+#636
G65 P7810 Y#635
G65 P7811 X0           
#639=#639+#135
IF[#635LT#637]GOTO63
#5261=#5261+[#639/#640]
G65 P7810 Z100
M104P2
#601=#5261                                      ; Measured start probe location

N7
;---------------PROBE SIC---------------
IF[[#15/#17]NE[FIX[#15/#17]]]GOTO9
G91 G28 Z0
G90
T#5M6

#23=4                                           ; Probe start Y position
#24=4                                           ; Probe Y step distance
#25=4                                           ; No. probe Y steps
#26=0                                           ; Probe count
#659 = 0                                        ; Avg ref surface

M104P1
G4X2

;REFERENCE SURFACE
G54.1000 P6
G0 X-5 Y0
G1 G43 H#2233 Z100 F3000
N74
G65 P7810 Z-2 Y#23
G65 P7811 X0
#[660+#26] = #135 + #5241
#659 =  #659 + #[660+#26]
M12
#26 = #26+1
#23 = #23+#24
IF[#26LT[#25]]GOTO74
G65 P7810 Z100
#659 = #659/#25

;CUTTING SURFACE
#23 = 1
G54.1000 P7
G0 X-5 Y0
N71;MEASUREMENTS                                            
G65 P7810 Z-2 Y#23                                                          
N72                 
G65 P7811 X[#12*#15]
N73
#[660+#26]=#135 + #5261
#[660+#26+#25] = #[660+#26] - #659
M12
#26=#26+1
#23=#23+#24
IF[#26LT[#25*2]]GOTO71
G65 P7810 Z100

M104P2
G91 G28 Z0                               
G90

N9
;PRINT OUT DATA
G100 P221 L20 F1 (<FMT:.4F,#1>,<FMT:.4F,#604>,<FMT:.4F,#668>,<FMT:.4F,#669>,<FMT:.4F,#670>,<FMT:.4F,#671><ELN:>)
G100 P221 L20 F1 (<ELN:>)

;-------------NO. CUT CHECK-------------
IF[#1GE#2]GOTO10
GOTO1

N10
;---------------PROGRAM END-------------
G100 P221 L11 F1
M30
%