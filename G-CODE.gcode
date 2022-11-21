(DATE=DD-MM-YY 02-02-2021 TIME=HH-MM-SS 11:29:56)
%
O21                                                                 ; Program number
G0 G17 G40 G49 G54 G90 G98                                          ; Sets movement to rapid (G0), Selects XY plane (G17), Cancels tool radius & length compensation (G40, G49),
                                                                    ; Sets workpiece coord sysem (G54), Set to Absolute Programming (G90), Reset canned cycle (G98)

G100 P221L10 F1 T1 (E:FTP\TOM\RESULTS\03AUG22.TXT)                  ; ??? Creates text file for logging data
G100 P221 L20 F1 (TOOL NUMBER,CUT DEPTH,LOOP,PROBE X,NC4 RADIUS<ELN:1>)
G100 P221 L11 F1
M12                                                                 ; Pause pre-reading
M103P2                                                              ; Turn off NC4 for analogue trace
M105P2                                                              ; Turn off NC4 for analogue trace
M107P2                                                              ; Turn off AE recording

#1=0; LOOP COUNTER
#2=400; LOOP TARGET
#3=6; BURR TOOL NUMBER
#4=1.3; BURR TOOL DIAMETER
#5=1; PROBE TOOL NUMBER
#6=20; WORKPIECE Y LENGTH
;#7
#8=24000; SPINDLE SPEED(CUT)
#9=3000; SPINDLE SPEED(OTHER)
#10=60; FEED RATE(CUT)
#11=5.; Z CUT DEPTH
#12=0.03; X CUT DEPTH
#13 = #12; GLASS*CUT*TOTAL
;#14
#15=0; TOTAL CUTS
#16=0; CUT REPEAT COUNTER
#17=400; SIC CUTS PER PROBE
#18=1; NO. OF CUTS BEFORE MEASURE
;#19=MEASURE TOOL Z HEIGHT
;#20=MEASURE TOOL BEAM SIDE
;#21=MEASURE TOOL INCREMENT
;#22=MEASURE TOOL Y POSITION
;#23=PROBE Y START POS
;#24=PROBE Y STEP DISTANCE
;#25=PROBE Y STEPS
;#26=FIRST STEP

GOTO3                                                               ; GO TO PROBE AND MEASURE
N1
#16=0.                                                              ; Reset cut repeat counter

N2
;----------------CUT SIC----------------
WHILE[#16LT#18]DO1                                                  ; Check whether to keep cutting or move to measure tool
T#3M6                                                               ; Tool change to grinding tool
G54.1000 P7                                                         ; Change workpiece coords to correspond to SiC block
G90 G0 X-#4 Y-#4                                                    ; Rapid move in XY directions to minus one tool diameter from origin
G0 G43 H#2233 Z50 F5000                                             ; Rapid move with positive tool correlation from tool (H#2233) to 50 mm above plane
M3 S#8                                                              ; Spindle on in CW direction at specified RPM (#8)
M8                                                                  ; Coolant on
G1 Z-#11                                                            ; Linear move in Z to the cut depth
G01 X[[#12*#15]-#[6300+#3]] F#10                                    ; Linear move in X to start position for cutting calc from depth of cut * no cuts - measured radius
;ACOUSTICS SIGNAL
M107P1                                                              ; Trigger for starting AE acquisition
;CUTTING PASS
G01 Y#6                                                             ; Linear move in Y direction across workpiece CUTTING
M107P2                                                              ; Trigger for stopping AE acquistion    
G40                                                                 ; Cancel tool compensation
G1 Z50 F5000                                                        ; Linear move in Z to 50mm above plane
M9                                                                  ; Coolant off
M5                                                                  ; Stop spindle
M1                                                                  ; Optional Stop        
IF[#1GE#2]GOTO3                                                     ; If no of loops GE to loop target go to measure tool 
#1=#1+1                                                             ; Increment loop counter    
#15=#15+1                                                           ; Increment total cuts    
#16=#16+1                                                           ; Increment cut repeat counter
END1

N3
;-------------MEASURE TOOL--------------
;MEASURE
T#3M6                                                               ; Tool change to grinding tool
G53                                                                 ; Set/Move machine coord system    
G4X10                                                               ; Dwell for 10 seconds    
G65 P7862 B3 R#4 Z[#11/2] S#8 H1                                    ; Call NC4 macro - Tool length and radius setting 
#604=#[6300+#3]                                                     ; Save tool radius offset

;PRINT OUT DATA
G100 P221L10 F1 T1 (E:\FTP\TOM\RESULTS\03AUG22.TXT)                 ; Print out data to log file
G100 P221 L20 F1 (<FMT:.4F,#3>,<FMT:.4F,#11>,<FMT:.4F,#1>,<FMT:.4F,#601>,<FMT:.4F,#604><ELN:1>)
G100 P221 L11 F1                                                    ; Close communication with .txt file

N4
;----ANALOGUE TRACE AT Z BOTH SIDES-----
#20=1.                                                              ; Tool beam side
#21=0.04                                                            ; Tool increment
M105P1                                                              ; Turn on compressed air for NC4
G4X1                                                                ; Dwell 1 second
M103P1                                                              ; Trigger NC4    
N41                                                             
#22=[[#522+#523]/2]+#20*[[#4/2]+#21]                                ; ??? Y position for measurement                
G1 G53 F8000 X#524 Y#22                                             ; Linear move in XY to position for NC4 scan
G49                                                                 ; Cancel tool length compensation
#19=[[[#520+#521]/2]-[#11/2]]+#[6100+#2233]                         ; ??? Z position for measurement
G53 Z#19                                                            ; Linear move in Z to position for NC4 scan
M3S60                                                               ; Spindle on in CW direction at 60 RPM
G4X4                                                                ; Dwell 4 seconds
G53                                                                 ; Return to workpiece coords
#21=#21-0.01                                                        ; Reduce tool increment for Y position    
IF[#21GE-0.01]GOTO41                                                ; If tool increment is GE -0.01 go back and measure at new y pos
#21=0.04                                                            ; Reset tool increment        
#20=#20-2.                                                          ; Minus 2 from tool beam side, so at -1 will scan on other side or -3 when end    
IF[#20GE-1.]GOTO41                                                  ; If tool beam side is GE -1 go back and measure again
M103P2                                                              ; Turn off acquisiton for NC4
M105P2                                                              ; Turn off air for NC4       
M5                                                                  ; Stop spindle
G91 G28 Z0                                                          ; Change to incremental movement and return to home position in Z axis  
G90                                                                 ; Change to absolute movement method

GOTO6                                                               ; SKIP GLASS CUTTING

N6
;--------PROBE SIC - PRE CUTTING--------
IF[#16EQ0]GOTO61                                                    ; If at very start point i.e. 16 = 0 probe first
GOTO7                                                               ; Else go to N7
N61;PROBE SIC SURFACE - PRE
T#5M6                                                               ; Tool change to probe
G54.1000 P7                                                         ; Set workpiece offset to SiC
G0 X-5 Y-5                                                          ; Rapid move in XY 5 away from SiC        
G1 G43 H#2233 Z100 F3000                                            ; Rapid move with positive tool correlation from tool (H#2233) to 100 mm above plane

#635=2                                                              ; Probe Y start position
#636=8                                                              ; Probe Y step distance
#637=18                                                             ; Probe Y end Position
#638=642                                                            ; Measure position store start
#639=0                                                              ; Running total
#640=[[#637-#635]/#636]+1                                           ; Number of measurements

M104P1                                                              ; Turn on probe
G4X2                                                                ; Dwell 2 seconds
G65 P7810 Z-2 Y#635                                                 ; Call PROBE macro - Protected move to start position for probing
G65 P7811 X0                                                        ; Call PROBE macro - X single measurement
#[#638]=#135                                                        ; Save measured X position
#639=#639+#[#638]                                                   ; Update running total
#641=#[#638]                                                        ; Save measurement for output    

G100 P221L10 F1 T1 (E:\FTP\TOM\RESULTS\POINT DATA - 03AUG22.TXT)    ; Create/open log .txt file for probe data
G100 P221 L20 F1(SIC,<FMT:.4F,#1>,<FMT:.4F,#641>)                   ; Write measurement to .txt file

N62                                                                 
#635=#635+#636                                                      ; Updating the starting Y position for next probe location
G65 P7810 Y#635                                                     ; Call PROBE macro - Protected move to updated start position
#638=#638+1                                                         ; Increase save index position by one
G65 P7811 X0                                                        ; Call PROBE macro - X single measurement            
#[#638]=#135                                                        ; Save measured X position
#641=#[#638]                                                        ; Save measurement for output
G100 P221 L20 F1(,<FMT:.4F,#641>)                                   ; Write measurement to .txt file
#639=#639+#[#638]                                                   ; Update running total
IF[#635LT#637]GOTO62                                                ; If not at end of probing length carry out another measurement        
G100 P221 L20 F1(<ELN:>)                                            ; Write EOL to .txt file
G100 P221 L11 F1                                                    ; Close communication with open .txt file
#5261=#5261+[#639/#640]                                             ; Update X of work coordinates G54.1 P7 with averaged value of measurements
;G65 P7816 X0 Y0 I40 J40 S107                                       ; Call PROBE macro - Find corner of the SiC and update the work coordinates
G65 P7810 Z100                                                      ; Call PROBE macro - Protected move in Z direction upwards 100 mm
M104P2                                                              ; Turn off probe
#601=#5261                                                          ; Save updated value

N7
;---------------PROBE SIC---------------
IF[[#15/#17]NE[FIX[#15/#17]]]GOTO9                                  ; Check if the SiC should be probed in between after this cut
G91 G28 Z0                                                          ; Change to incremental movement and return to home position in Z axis 
G90                                                                 ; Change to absolute movement method
T#5M6                                                               ; Tool change to probe
G54.1000 P7                                                         ; Set workpiece offset to SiC
G0 X-5 Y0                                                           ; Rapid move in XY to -5 mm in X from origin
G1 G43 H#2233 Z100 F3000                                            ; Rapid move with positive tool correlation from tool (H#2233) to 100 mm above plane
#23=5                                                               ; Probe start Y position
#24=10                                                              ; Probe Y step distance
#25=2                                                               ; No. probe Y steps
#26=0                                                               ; Probe count
M104P1                                                              ; Turn on probe
G4X2                                                                ; Dwell 2 seconds
N71;MEASUREMENTS                                            
G65 P7810 Z-2 Y#23                                                  ; Call PROBE macro - Protected move in YZ direction to start position   
GOTO72                                                              ; Go to measure            
IF[#15NE0]GOTO72                                                    ; If No. cuts per probe is not 0 go to measure
IF[#26NE0]GOTO72                                                    ; If it is not first measurement go to measure
G65 P7811 X0 S106                                                   ; Call PROBE macro - X single measurement and update work offset coordinates
GOTO73                                                              
N72                 
G65 P7811 X[#12*#15]                                                ; Call PROBE macro - X single measurement
N73
#[660+#26]=#135                                                     ; Save measured X position
M12                                                                 ; Pause pre-reading
#26=#26+1                                                           ; Increment probe count
#23=#23+#24                                                         ; Update probe start location
IF[#26LT#25]GOTO71                                                  ; If more measurements are to be carried out go back to measure again
G65 P7810 Z100                                                      ; Call PROBE macro - Protected move in the Z direction 100 mm 
M104P2                                                              ; Turn off probe
G91 G28 Z0                                                          ; Change to incremental movement and return to home position in Z axis                                 
G90                                                                 ; Change to absolute movement method

G100 P221L10 F1 T1 (E:\FTP\TOM\RESULTS\POINT DATA - 03AUG22.TXT)    ; Create/open log .txt file for probe data
G100 P221 L20 F1(SIC,<FMT:.1F,#15>,<FMT:.4F,#660>,<FMT:.4F,#661>,<FMT:.4F,#662>)
G100 P221 L20 F1(<FMT:.4F,#663>,<FMT:.4F,#664>,<FMT:.4F,#665>,<ELN:>)
G100 P221 L11 F1                                                    ; Close communication to open .txt file

N9
;-------------NO. CUT CHECK-------------
IF[#1GE#2]GOTO10                                                    ; If No. loops is greater or equal to loop target end program
GOTO1                                                               ; Go to N1 beginning of cycle

N10
;---------------PROGRAM END-------------
M30                                                                 ; End of program
%