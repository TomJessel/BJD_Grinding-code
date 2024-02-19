(DATE=13-02-2024 TIME=11:29:56 - Spindle Warm Up Test)
%
O27
; Script to measure variation in probe measurements over spindle warm up

G0 G17 G40 G49 G54 G90 G98
G100 P221 L10 F1 T1 (E:\FTP\TOM\RESULTS\240220_RefBoreDrift.csv)
G100 P221 L20 F1 (No.,X-POS,Y-POS<ELN:1>)

#1 = 1        ; PROBE NUMBER
#2 = 6        ; TOOL NUMBER
#3 = 24000    ; SPINDLE SPEED

; 12 iterations at 600s (10min) = 2 hours
#5 = 12       ; ITERATIONS
#6 = 600      ; WAIT TIME
#10 = 0       ; COUNTER

; Tool Change to Probe
M6 T#1
; Probe OFF
M104 P2

; Move to above bore
G54 X100 Y100   ; CHANGE TO MATCH LOC
; Tool Comp
G43 H#2233 Z100
G4 X2

N1 ; Start Spindle
; IF START OF TEST MEASURE FIRST
IF[#10EQ0]GOTO2
; Tool change to DCB
M6 T#2
; Start Spindle and wait
M3 S#3
G4 X#6
M5
; Tool Change to Probe
M6 T#1

N2 ; Probe Bore
; Probe ON
M104 P1
G4 X2
; Protected move into bore
G65 P7810 Z-5
; Measure bore position
G65 P7814 D30
; Protected move out bore
G65 P7810 Z100
; Probe OFF
M104 P2

; Log Data
G100 P221 L20 F1 (<FMT:.1F,#10>,<FMT:.3F,#135>,<FMT:.3F,#136><ELN:>)
#10 = #10 + 1

; IF END OF TEST STOP
IF[#10LE#5]GOTO1

G91 G28 Z0
G90
M30
%
