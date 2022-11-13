

;====
;Main Code
;====

.ORIG x3000


LD R2, ARRAY_PTR
LD R3, DEC_DECREMENT_10

LD R1, DEC_1

;Populates an array at 4000 with powers of 2
DO_WHILE_INPUT
	
	STR R1, R2, #0
	ADD R1, R1, R1
	ADD R2,R2, #1 ; increment address
	ADD R3,R3, #-1
	
	BRp DO_WHILE_INPUT
END_DO_WHILE_INPUT

;getting seventh value so 6th index .begin + 6

;LD R3, ARRAY_PTR
;ADD R3,R3, #6
;LDR R2, R3, #0

LD R6, ARRAY_PTR
LD R3, DEC_DECREMENT_10

;Should call the subroutine on each array spot to print in binary the powers of 2
DO_WHILE_OUTPUT
	;LDR R0,R6,#0
	
	LD R0, SUB_OUTPUT_BINARY_PTR
	JSrr R0
	
	ADD R6,R6, #1
	ADD R3, R3, #-1
	
	BRp DO_WHILE_OUTPUT


END_DO_WHILE_OUTPUT

HALT


;================
;LOCAL DATA
;================
DEC_DECREMENT_10 .FILL #10
ARRAY_PTR .FILL x4000
SUB_OUTPUT_BINARY_PTR .FILL x3200
DEC_1 .FILL #1

.ORIG x4000

ARRAY_1 .BLKW #10

;======
;END MAIN CODE
;======

;====
;OUTPUT BINARY OF POWERS OF 2 SUBROUTINE
;====
;------------------------------------------------------------------------
;Subroutine: SUB_OUTPUT_BINARY
;
;Parameter R2 (Address of the data to convert to binary)
;
;PostCondition: Subroutine has converted and outputted the power of 2
;which is located in memory into binary aka ASCII 1s and 0s
;
;Return Value: No return value
;------------------------------------------------------------------------

.orig x3200
;===========
;SUBROUTINE INSTRUCTIONS
;===========

;Store relevant variables
	ST R0, BACKUP_R0_3200
	ST R1, BACKUP_R1_3200
	ST R2, BACKUP_R2_3200	
	ST R3, BACKUP_R3_3200
	ST R4, BACKUP_R4_3200
	ST R5, BACKUP_R5_3200
	ST R7, BACKUP_R7_3200

	LDR R1, R6, #0			; R1 <-- value to be displayed as binary 
;-------------------------------
;INSERT CODE STARTING FROM HERE
;--------------------------------

	AND R2,R2, x0; use this as a counter for spaces
	LD R3, LOOP_DEC_VAR ; controls the loop 
	AND R4,R4,x0 ;used for checking if right number for counter is needed for a space

	OUTPUT_LOOP
		
		ADD R1,R1, #0 ;so conditoins look at R1

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
	
	LD R0, BACKUP_R0_3200
	LD R1, BACKUP_R2_3200
	LD R3, BACKUP_R3_3200
	LD R4, BACKUP_R4_3200
	LD R5, BACKUP_R5_3200
	LD R7, BACKUP_R7_3200

	ret 

;===========
;SUBROUTINE LOCAL DATA
;===========
LOOP_DEC_VAR .FILL #15
DECIMAL_VAL_0 .FILL #48 ;ascii 0
DEC_VAL_1 .FILL #49 ;ascii 1
SPACE_CHAR .FILL ' '
ENDLINE_CHAR .FILL '\n'

BACKUP_R0_3200 .BLKW #1
BACKUP_R1_3200 .BLKW #1
BACKUP_R2_3200 .BLKW #1
BACKUP_R3_3200 .BLKW #1
BACKUP_R4_3200 .BLKW #1
BACKUP_R5_3200 .BLKW #1
BACKUP_R7_3200 .BLKW #1





.end
