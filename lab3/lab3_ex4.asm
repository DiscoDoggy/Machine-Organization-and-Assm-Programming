

.orig x3000

LD R1, ARRAY_PTR
LD R2, DEC_DECREMENT_75
AND R5, R5, x0

DO_WHILE

	GETC
	
	ADD R4, R0, #-10
	BRz END_DO_WHILE
	
	STR R0, R1, #0
	ADD R1,R1, #1
	ADD R5,R5, #1 ;our array element counter
	ADD R2, R2, #-1 ;if user never presses enter cut them off at 75 chars
	BRp DO_WHILE
	
END_DO_WHILE

LD R1, ARRAY_PTR


DO_WHILE_OUTPUT
	LDR R0, R1, #0
	OUT
	
	
	ADD R1, R1, #1
	ADD R5, R5, #-1
	BRp DO_WHILE_OUTPUT

HALT

;--------------------
;Local Data 
;--------------------

ARRAY_PTR .FILL x4000
;NEWLINE_CHAR .FILL '\n'
DEC_DECREMENT_75 .FILL #75

.orig x4000 
ARRAY_1 .BLK #75


.end
