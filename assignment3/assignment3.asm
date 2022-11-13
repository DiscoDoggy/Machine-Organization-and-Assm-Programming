
.ORIG x3000			; Program begins here
;-------------
;Instructions
;-------------
LD R6, Value_ptr		; R6 <-- pointer to value to be displayed as binary
LDR R1, R6, #0			; R1 <-- value to be displayed as binary 
;-------------------------------
;INSERT CODE STARTING FROM HERE
;--------------------------------

AND R2,R2, x0; use this as a counter for spaces
LD R3, LOOP_DEC_VAR ; controls the loop 
AND R4,R4,x0 ;used for checking if right number for counter is needed for a space

OUTPUT_LOOP
	
	ADD R1,R1, #0

	BRn IF_MSB_1
	BRp IF_MSB_0
	BRz IF_ALL_0
	
	IF_MSB_1
		LD R0, DEC_VAL_1
		OUT
		ADD R2,R2, #1 ; for space control
		BR END_IF_MSB_0
	END_IF_MSB_1
	
	IF_ALL_0
		LD R0, DECIMAL_VAL_0
		OUT
		ADD R2,R2, #1
		BR END_IF_MSB_0
	END_IF_ALL_0
	
	IF_MSB_0
		LD R0, DECIMAL_VAL_0
		OUT
		ADD R2,R2, #1 ;for space control
	END_IF_MSB_0
	
	ADD R4, R2, #-4
	BRz ADD_SPACE
	BRn END_ADD_SPACE
	
	ADD_SPACE
		LD R0, SPACE_CHAR
		OUT
		AND R2,R2, x0
	END_ADD_SPACE
	
	AND R4,R4, x0
	
	ADD R1,R1, R1
	
	ADD R3,R3, #-1
	BRp OUTPUT_LOOP
	
END_OUTPUT_LOOP

ADD R1,R1, #0
BRn LAST_DIGIT_1
BRp LAST_DIGIT_0
BRz NUM_IS_ZERO

LAST_DIGIT_1
	LD R0,DEC_VAL_1
	OUT
	BR END_LAST_DIGIT_0
END_LAST_DIGIT_1

NUM_IS_ZERO
	LD R0, DECIMAL_VAL_0
	OUT
	BR END_LAST_DIGIT_0
END_IS_ZERO

LAST_DIGIT_0
	LD R0,DECIMAL_VAL_0
	OUT
END_LAST_DIGIT_0

LD R0, ENDLINE_CHAR
OUT

HALT
;---------------	
;Data
;---------------
Value_ptr	.FILL xCA00	; The address where value to be displayed is stored
LOOP_DEC_VAR .FILL #15
DECIMAL_VAL_0 .FILL #48 ;ascii 0
DEC_VAL_1 .FILL #49 ;ascii 1
SPACE_CHAR .FILL ' '
ENDLINE_CHAR .FILL '\n'

.ORIG xCA00					; Remote data
Value .FILL x8000			; <----!!!NUMBER TO BE DISPLAYED AS BINARY!!! Note: label is redundant.
;---------------	
;END of PROGRAM
;---------------	
.END
