O0099 (OWL - RUN)
; OWL subprogram to run a single OWL measurement manually
M9

M12
M103P2
M105P2
M107P2

; #30 = 1

M6T6

G54.1000 P15

; Move to the start position above OWL
G90 G0 X0 Y0

; Move down to OWL in Z
G1 G43 H#2233 Z100 F5000

G01 Z0 F2000
M01

; Open solenoid for OWL 
M104P1
G4 X2
M01

; Start spindle
M3 S3000

; Wait 30s to record with OWL
M01
G4 X30
; ; Continue spindle until #30 is changed from 1
; WHILE [#30EQ1]DO1
; G4 X2
; END1

; Stop spindle 
M5
M104P2
M01

; Return Home
G01 Z180
M01
G28 G91 Z0

M99
%