
;===========
;instructions
;===========
.orig x3000

LD R3, DEC_65
LD R4, HEX_41

HALT

;===========
;Local Data
;===========

DEC_65 .FILL #65
HEX_41 .FILL x41
	
.end
