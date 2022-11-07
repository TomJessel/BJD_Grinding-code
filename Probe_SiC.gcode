(DATE=DD-MM-YY 20-09-2019 TIME=HH-MM-SS 09:40:56)
(Program to update workpiece coord system for the SiC G54.1000 P7)
%
O19                                 ; Program Number
G0 G17 G40 G49 G54 G90 G98          ; Sets movement to rapid (G0), Selects XY plane (G17), Cancels tool radius & length compensation (G40, G49),
                                    ; Sets workpiece coord sysem (G54), Set to Absolute Programming (G90), Reset canned cycle (G98)
M104P2                              ; Turn off probe
#1=-5                               ; Set measure depth to -5 mm
G28 G91 Z0                          ; Change to incremental movement and return to home position in Z axis  
G90                                 ; Change to absolute movement method

T1M6                                ; Tool change to tool 1 - probe
G54.1000 P7                         ; Set workpiece coords to SiC 
G43 H#2233 G1 Z180 F5000            ; Apply positive tool offset and linear move in the Z direction
M104P1                              ; Turn of probe
G4 X2                               ; Dwell 2 seconds

G54.1000 P7                         ; Set workpiece coords to SiC      
G65 P7810 X5 Y5                     ; Call PROBE macro - Protected move in XY direction above center SiC
G65 P7810 Z10                       ; Call PROBE macro - Protected move in Z direction to 10 mm above SiC
G65 P7811 Z0 S107                   ; Call PROBE macro - Single Z measurement and change G54.10000 P7 to measurement
G65 P7810 X-6 Y-6                   ; Call PROBE macro - Protected move in XY direction to offset corner of SiC
G65 P7810 Z-3                       ; Call PROBE macro - Protected move in Z direction to above SiC shelf
G65 P7816 X0 Y0 D6 E6 S107          ; Call PROBE macro - Finding an external corner to update XY coords of SiC cutting face
G65 P7810 Z20                       ; Call PROBE macro - Protected move in Z direction

M104P2                              ; Turn off probe
G91 G28 Z0                          ; Change to incremental movement and return to home position in Z axis  
G90                                 ; Change to absolute movement method
M30                                 ; End of program
%