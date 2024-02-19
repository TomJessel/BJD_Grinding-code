(DATE=13-02-2024 TIME=11:29:56 - Spindle Warm Up Test)
%
O25
G0 G17 G40 G49 G54 G90 G98
G100 P221 L10 F1 T1 (E:\FTP\TOM\RESULTS\240213_SpindleWarmTest.csv)
G100 P221 L20 F1 (No., T-Length, T-Radius<ELN:1>)

#1 = 12       ; Z POS (NEG up tool height)
#3 = 6        ; TOOL NUMBER
#4 = 5        ; BURR TOOL DIAMETER
#8 = 24000    ; SPINDLE SPEED
#9 = 60       ; SPINDLE SPEED(OTHER)
;#19=MEASURE TOOL Z HEIGHT
;#20=MEASURE TOOL BEAM SIDE
;#21=MEASURE TOOL INCREMENT
;#22=MEASURE TOOL Y POSITION

; 12 iterations at 900s (15min) = 3 hours
#12 = 12      ; ITERATIONS
#13 = 0       ; COUNTER
#14 = 900     ; WAIT TIME


;Change tool
M6T#3
M1
G53
G4X5
M1


N4
IF[#13EQ0]GOTO5
G4 X2
M3 S#8
G4 X#14
M5

N5
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

; NC4 L&D Measurement save to T99
G65 P7862 B3 R5 S3000 T99 D99 Z2.5

; Log data
G100 P221 L20 F1 (<FMT:.1F,#13>,<FMT:.4F,#6199>, <FMT:.4F,#6399><ELN:1>)

#13=#13+1
IF[#13LE#12]GOTO4

G91 G28 Z0
G90
M30
%
