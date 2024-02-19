(DATE=19-02-2024 TIME=11:29:56 - Ref Probe Test)
%
O26
G0 G17 G40 G49 G54 G90 G98
G100 P221 L10 F1 T1 (E:\FTP\TOM\RESULTS\240220_RefProbeBore.csv)
G100 P221 L20 F1 (X-POS,Y-POS<ELN:1>)


; Turn off probe
M104 P2
G28 G91 Z0
G90

; Change to Probe Tool
M6 T1

; Move above the Ref Bore
G54 X100 Y100       ; CHANGE TO CORRECT POSITION
G43 H#2233 Z100

; Turn on probe
M104 P1
G4 X2

; Protected move to Z-5
G65 P7810 Z-5

; Measure the Ref Bore
G65 P7814 D30

; Protected move to Z100
G65 P7810 Z100

; Turn off probe
M104 P2
G91 G28 Z0
G90

; Print Data
G100 P221 L20 F1 (<FMT:.3F,#135>,<FMT:.3F,#136><ELN:>)
; Close File
G100 P221 L11 F1
M30
%