O100
G0 G17 G40 G49 G54 G90 G98
M9

; Move to the start position above OWL
G90 G0 X592.3450 Y 83.2375
M01

; Move down to OWL in Z
G0 Z180
M01

G01 Z154.4716 F5000
M01

; Open solenoid for OWL 
M104P1
G4 X2
M01

; Start spindle
M3 S3000

; Continue spindle until #30 is changed from 1
WHILE [#30EQ1]DO1
G4 X2
END1

; Stop spindle 
M5
M104P2
M01

; Return Home
G01 Z180
M01
G28 G91 Z0

M30