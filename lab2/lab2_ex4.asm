
;===========
;INSTRUCTIONS
;===========

.orig x3000

LD R0, HEX_61
LD R1, HEX_1A

DO_WHILE_LOOP
	
	OUT
	
	ADD R0, R0, #1
	ADD R1, R1, #-1 ;make negative hx
	
	BRp DO_WHILE_LOOP
END_DO_WHLIE_LOOP


HALT

;===========
;LOCAL DATA
;===========

HEX_61 .FILL x61
HEX_1A .FILL x1A

.end