
.orig x3000

LD R1, ARRAY_PTR
LD R2, DEC_DECREMENT_10

DO_WHILE

	GETC
	OUT
	STR R0, R1, #0
	ADD R1,R1, #1
	ADD R2, R2, #-1
	BRp DO_WHILE
	
END_DO_WHILE



HALT

;--------------------
;Local Data 
;--------------------

ARRAY_PTR .FILL x4000
DEC_DECREMENT_10 .FILL #10

.orig x4000 
ARRAY_1 .BLK #10


.end
