(DATE=20-09-2019 TIME=09:40:56 - Set Work Coords)
%
O19
G0 G17 G40 G49 G54 G90 G98
M104P2
G28 G91 Z0
G90

T1M6
G54.1000 P7
G43 H#2233 G1 Z180 F5000
M104P1
G4 X2

G54.1000 P7   
G65 P7810 X5 Y5
G65 P7810 Z10
G65 P7811 Z0 S107
G65 P7810 X-6 Y-6
G65 P7810 Z-2
G65 P7816 X0 Y0 D6 E6 S107
G65 P7810 Z20

M104P2
G91 G28 Z0
G90
M30
%