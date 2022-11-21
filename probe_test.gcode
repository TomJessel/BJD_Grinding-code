(DATE=DD-MM-YY 20-09-2019 TIME=HH-MM-SS 09:40:56)
(Program to update workpiece coord system for the SiC G54.1000 P7)
%
O22                                                                 ; Program Number
G0 G17 G40 G49 G54 G90 G98                                          ; Sets movement to rapid (G0), Selects XY plane (G17), Cancels tool radius & length compensation (G40, G49),
                                                                    ; Sets workpiece coord sysem (G54), Set to Absolute Programming (G90), Reset canned cycle (G98)
M104P2                                                              ; Turn off probe
G28 G91 Z0                                                          ; Change to incremental movement and return to home position in Z axis  
G90                                                                 ; Change to absolute movement method

T1M6                                                                ; Tool change to tool 1 - probe
G54.1000 P7                                                         ; Set workpiece coords to SiC 
G43 H#2233 G1 Z180 F5000                                            ; Apply positive tool offset and linear move in the Z direction
M104P1                                                              ; Turn on probe
G4 X2                                                               ; Dwell 2 seconds

G91 G28 Z0                                                          ; Change to incremental movement and return to home position in Z axis 
G90                                                                 ; Change to absolute movement method
T#5M6                                                               ; Tool change to probe
G54.1000 P7                                                         ; Set workpiece offset to SiC
G0 X-5 Y0                                                           ; Rapid move in XY to -5 mm in X from origin
G1 G43 H#2233 Z100 F3000                                            ; Rapid move with positive tool correlation from tool (H#2233) to 100 mm above plane

#23=1                                                               ; Probe start Y position
#24=6                                                               ; Probe Y step distance
#25=4                                                               ; No. probe Y steps
#26=0                                                               ; Probe count

M104P1                                                              ; Turn on probe
G4X2                                                                ; Dwell 2 seconds
N71;MEASUREMENTS                                            
G65 P7810 Z-2 Y#23                                                  ; Call PROBE macro - Protected move in YZ direction to start position                                                             
N72                 
G65 P7811 X[#12*#15]                                                ; Call PROBE macro - X single measurement
N73
#[660+#26]=#135                                                     ; Save measured X position
M12                                                                 ; Pause pre-reading
#26=#26+1                                                           ; Increment probe count
#23=#23+#24                                                         ; Update probe start location
IF[#26LT#25]GOTO71                                                  ; If more measurements are to be carried out go back to measure again
G65 P7810 Z100                                                      ; Call PROBE macro - Protected move in the Z direction 100 mm 

;REFERENCE SURFACE
G0 X-15 Y0                                                          ; 5mm away from assumption of step distance
N74
G65 P7810 Z-7 Y#23
G65 P7811 X-10                                                      ; Assumed that step is 10mm away from edge
#[660+#26]=#135
#[660+#26+#25] = #[660+#26-#25] - #135
M12
#26 = #26+1
#23 = #23+#24
IF[#26LT[#26*2]]GOTO74
G65 P7810 Z100

M104P2                                                              ; Turn off probe
G91 G28 Z0                                                          ; Change to incremental movement and return to home position in Z axis                                 
G90                                                                 ; Change to absolute movement method

G100 P221L10 F1 T1 (E:\FTP\TOM\RESULTS\POINT DATA - 03AUG22.TXT)    ; Create/open log .txt file for probe data
G100 P221 L20 F1(SIC,<FMT:.1F,#15>,<FMT:.4F,#660>,<FMT:.4F,#661>,<FMT:.4F,#662>,<FMT:.4F,#663>,<ELN:>)
G100 P221 L20 F1(REF,<FMT:.1F,#15>,<FMT:.4F,#664>,<FMT:.4F,#665>,<FMT:.4F,#666>,<FMT:.4F,#667>,<ELN:>)
G100 P221 L20 F1(DIF,<FMT:.1F,#15>,<FMT:.4F,#668>,<FMT:.4F,#669>,<FMT:.4F,#670>,<FMT:.4F,#671>,<ELN:>)
G100 P221 L11 F1  