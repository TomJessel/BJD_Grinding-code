(DATE=10-01/2024 TIME=13:28:10 - Scan Tool with NC4 and oscilloscope)
%
O23
G0 G17 G40 G49 G54 G90 G98

#1 = -2.5     ; Z POS (NEG up tool height)
#3 = 7        ; TOOL NUMBER
#4 = 1.3      ; BURR TOOL DIAMETER
#9 = 60       ; SPINDLE SPEED(OTHER)
#11 = 5.      ; Z CUT DEPTH
;#19=MEASURE TOOL Z HEIGHT
;#20=MEASURE TOOL BEAM SIDE
;#21=MEASURE TOOL INCREMENT
;#22=MEASURE TOOL Y POSITION

;----ANALOGUE TRACE AT Z BOTH SIDES-----

;Change tool
M6T#3
M1
G53
G4X10
;Measure L&D tool NC4
G65 P7862 B3 R#4 Z[#11/2]
M1

N4
#20=1.                                              ; Tool beam side
#21=0.04                                            ; Tool increment

;Start NC4 and Oscilloscope
M105P1
G4X1
M103P1  

N41                                                             
;Move tool to correct start XY pos
#22=[[#522+#523]/2]+#20*[[#4/2]+#21]      
G1 G53 F8000 X#524 Y#22
G49
M1

;Move tool to correct start Z pos
; MAY NEED TO REMOVE TO GET TO CORRECT Z POSITION MANUALLY
#19=[[[#520+#521]/2]-[#1]]+#[6100+#2233]
G53 Z#19
M1

;Start spindle
M3S#9
G4X4
G53

;Iterate through scan points
#21=#21-0.01
IF[#21GE-0.01]GOTO41
#21=0.04
#20=#20-2.
IF[#20GE-1.]GOTO41

;Turn off NC4 and oscilloscope
M103P2
M105P2   
;Stop spindle
M5

; Move to safe position
G91 G28 Z0
G90

;End program
M30
%