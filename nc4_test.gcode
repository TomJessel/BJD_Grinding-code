(DATE=DD-MM-YY 21-11-22 TIME=HH-MM-SS 15:35:00)
(Test NC4 program changes)
%
O19                                 
G0 G17 G40 G49 G54 G90 G98      
                                    
M104P2                              
G28 G91 Z0                            
G90 

#3 = 6      ; Tool number
#4 = 1.3    ; DCB diameter
#11 = 5.    ; Z cut depth
#8 = 24000  ; Spindle speed

N3
;-------------MEASURE TOOL--------------
;MEASURE
T#3M6
G53
G4X1
G65 P7862 B3 R#4 Z[#11/2] S#8 H1
#604=#[6300+#3]

M30
%