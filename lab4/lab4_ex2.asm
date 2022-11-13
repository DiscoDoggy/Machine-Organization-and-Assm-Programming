
;==============
;INSTRUCTIONS
;==============

.ORIG x3000

AND R1,R1, x0
LD R2, ARRAY_PTR
LD R3, DEC_DECREMENT_10

DO_WHILE_INPUT
	STR R1, R2, #0
	ADD R1,R1, #1 ;add to input number
	ADD R2,R2, #1 ; increment address
	ADD R3,R3, #-1
	
	BRp DO_WHILE_INPUT
END_DO_WHILE_INPUT

;getting seventh value so 6th index .begin + 6

LD R2, ARRAY_PTR
LD R3, DEC_DECREMENT_10
LD R4, ASCIIOFFSET
AND R0,R0, x0

DO_WHILE_OUTPUT
	LDR R0, R2, #0
	ADD R0, R0, R4
	
	OUT
	AND R0,R0, x0
	
	ADD R2, R2, #1 ;increments array
	ADD R3, R3, #-1
	
	BRp DO_WHILE_OUTPUT

END_DO_WHILE_OUTPUT


;ADD R2,R2, #6
;LDR R1, R2, #0

HALT


;================
;LOCAL DATA
;================
DEC_DECREMENT_10 .FILL #10
ARRAY_PTR .FILL x4000
ASCIIOFFSET .FILL x30

.ORIG x4000

ARRAY_1 .BLKW #10


.end
