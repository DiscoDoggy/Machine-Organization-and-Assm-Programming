

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

LD R6, ARRAY_BINARY_NUMBER_PTR
LD R0, SUB_CONVERT_FROM_BINARY_PTR

JSrr R0

HALT


;================
;LOCAL DATA
;================
DEC_DECREMENT_10 .FILL #10
ARRAY_PTR .FILL x4000
ARRAY_BINARY_NUMBER_PTR .FILL x4200
SUB_OUTPUT_BINARY_PTR .FILL x3200
SUB_CONVERT_FROM_BINARY_PTR .FILL x3400
DEC_1 .FILL #1

.ORIG x4000

ARRAY_1 .BLKW #10

.ORIG x4200
BINARY_NUMBER_ARRAY .BLKW #17
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

;=======
;END SUBROUTINE
;=======

;=======
;CONVERT FROM BINARY SUBROUTINE
;=======

;------------------------------------------------------------------------
;Subroutine: SUB_CONVERT_FROM_BINARY
;
;Parameter R6 (Address of the array in which we intend to store ascii 
;binary 1s and 0s
;
;PostCondition: In R2, the decimal value of the inputted binary is stored
;
;Return Value: R2
;------------------------------------------------------------------------
.orig x3400

;Backing up values
	ST R0, BACKUP_R0_3400 
	ST R1, BACKUP_R1_3400
	ST R3, BACKUP_R3_3400 
	ST R4, BACKUP_R4_3400 
	ST R5, BACKUP_R5_3400 
	ST R7, BACKUP_R7_3400

;Prompt user to enter a string of 16 bit binary  numbers with b 
;at the beginning 
	LD R0, CHARACTER_NEWLINE
	OUT 
	OUT

	LEA R0, INPUT_BINARY_STRING_INSTRUCTIONS
	PUTS

	LD R0, CHARACTER_NEWLINE
	OUT
;Take in the binary string
	ADD R4, R6, #0
	LD R5, DEC_16
	DO_WHILE_CHECK_FOR_b
		
		GETC
		
		LD R1, DEC_98
		ADD R1, R1, R0
		
		BRz PRINT_b
		;implicit else
		
		LEA R0, START_WITH_b
		PUTS
		LD R0, CHARACTER_NEWLINE
		OUT
		BR END_PRINT_b
		
		PRINT_b
			OUT
			STR R0, R4, #0
			BR END_DO_WHILE_CHECK_FOR_b
		END_PRINT_b 
		
		BR DO_WHILE_CHECK_FOR_b
	END_DO_WHILE_CHECK_FOR_b
	
	ADD R4, R4, #1
	AND R3,R3, x0
	ADD R3, R3, #1; start counter at 1 because we have b already
	
	DO_WHILE_STORE_BINARY
		;JMP_HERE_IF_SPACE
		
		;LD R1, DEC_32 ; used for checking if space
		;GETC
		;OUT
		
		;ADD R1, R1, R0
		;BRz JMP_HERE_IF_SPACE
		
		
		CHECK_VALID_CHARACTER
			GETC
			
			LD R1, DEC_32
			ADD R1, R1, R0
			BRz OUTPUT_SPACE
			
			LD R1, DEC_49
			ADD R1, R0, R1
			BRz END_CHECK_VALID_CHARACTER
			;implicit else
			
			LD R1, DEC_48
			ADD R1, R0, R1
			BRz END_CHECK_VALID_CHARACTER
			
			;implicit else
			LEA R0, ENTER_VALID_CHAR
			PUTS
			LD R0, CHARACTER_NEWLINE
			OUT
			
			BR DO_WHILE_STORE_BINARY
		END_CHECK_VALID_CHARACTER
		
		OUT
		BR END_OUTPUT_SPACE
		
		OUTPUT_SPACE
			OUT
			BR CHECK_VALID_CHARACTER
		END_OUTPUT_SPACE
		
		;implicit else (if no space and if valid character)
		STR R0, R4, #0
		
		
		
		ADD R4, R4, #1
		ADD R3,R3, #1;counts how many chars inputted
		ADD R5, R5, #-1
		
		BRp DO_WHILE_STORE_BINARY
	
	END_DO_WHILE_STORE_BINARY
	
;Converting to decimal
	ADD R4, R6, #0
	AND R2, R2, x0
	ADD R4,R4, #1 ;should be the sign bit
	
	LD R3, DEC_49
	LDR R5, R4, #0
	ADD R3, R3, R5
	
	BRz START_SIGN_BIT_1
	;Implicit else
	
	;Start Sign Bit = 0
		ADD R4, R6, #0
		LD R3, DEC_16
		
		ADD R4, R4, R3 ; should jump to last digit of bstring
		LD R3, DEC_15 ; loop runs 15 times only because dont want to count sign bit
		LD R1, DECIMAL_1 ;r1 will keep track of the powers of 2
		
		DO_WHILE_SIGN_BIT_0
			LDR R5, R4, #0 ;reads value at array pos n into R5
			LD R0, DEC_49
			ADD R7, R0, R5
			
			BRz ADD_POWER_OF_2_FOR_1
			;implicit else
			BR END_POWER_OF_2_FOR_1
			
			ADD_POWER_OF_2_FOR_1
				ADD R2, R2, R1
			END_POWER_OF_2_FOR_1
			
			ADD R1, R1, R1
			ADD R4, R4, #-1
			
			ADD R3, R3, #-1
			BRp DO_WHILE_SIGN_BIT_0
			
		END_DO_WHILE_SIGN_BIT_0
		
		BR END_SIGN_BIT_1
	;End sign bit = 0
	
	START_SIGN_BIT_1
	
		ADD R4, R6, #0
		LD R3, DEC_16
		
		ADD R4, R4, R3 ; should jump to last digit of bstring
		LD R3, DEC_15 ; loop runs 15 times only because dont want to count sign bit
		LD R1, DECIMAL_1 ;r1 will keep track of the powers of 2
		
		DO_WHILE_CONVERT_DECIMAL
			
			LDR R5, R4, #0 ;reads value at array pos n into R5
			LD R0, DEC_48
			ADD R7, R5, R0
			
			BRz ADD_POWER_OF_2_FOR_0
			
			;implict else
			BR END_ADD_POWER_OF_2_FOR_0
		
		
		
			ADD_POWER_OF_2_FOR_0
				ADD R2, R2, R1
			END_ADD_POWER_OF_2_FOR_0
			
			ADD R1, R1, R1
			ADD R4, R4, #-1
			
			ADD R3, R3, #-1
			BRp DO_WHILE_CONVERT_DECIMAL
		
		END_DO_WHLIE_CONVERT_DECIMAL
			;make negative
			ADD R2, R2, #1
			ADD R7 , R2, #0
			NOT R7, R7
			ADD R7, R7, #1
			ADD R2, R7, #0
			ADD R2, R7, #0
	
	END_SIGN_BIT_1


;
	LD R0, BACKUP_R0_3400
	LD R1, BACKUP_R1_3400
	LD R3, BACKUP_R3_3400
	LD R4, BACKUP_R4_3400
	LD R5, BACKUP_R5_3400
	LD R7, BACKUP_R7_3400
	
	ret
;=======
;Subroutine Local Data
;=======

CHARACTER_NEWLINE .FILL '\n'
INPUT_BINARY_STRING_INSTRUCTIONS .STRINGZ "Input b and a 16 bit binary number"
DEC_17 .FILL #17
DEC_49 .FILL #-49 ;For testing if ascii 1 
DEC_48 .FILL #-48 ;For testing if ascii 0
DEC_16 .FILL #16
DEC_15 .FILL #15
DECIMAL_1 .FILL #1
DEC_98 .FILL #-98 ;ascii b
DEC_32 .FILL #-32 ;ascii space
START_WITH_b .STRINGZ "Incorrect. Start with b"
DEC_NEGATIVE_1 .FILL #-1 ;for checking valid character
ENTER_VALID_CHAR .STRINGZ "Please enter a valid character"


BACKUP_R0_3400 .BLKW #1
BACKUP_R1_3400 .BLKW #1
BACKUP_R3_3400 .BLKW #1
BACKUP_R4_3400 .BLKW #1
BACKUP_R5_3400 .BLKW #1
BACKUP_R7_3400 .BLKW #1


.end
