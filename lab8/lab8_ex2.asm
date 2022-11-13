

;main code
.orig x3000
;-----------------
;Instructions

LEA R0, USER_INPUT_MESSAGE
PUTS

GETC
OUT

ADD R1, R0, #0;copies R0 to R1

LD R6, SUB_NUMBER_OF_1s_PTR
JSrr R6

ADD R2, R6, #0 ;copies R6 into R2

LEA R0, NUM_OF_1s_MSG
PUTS

LD R5, SUB_PRINT_DECIMAL_VALUE_PTR
JSrr R5










HALT

;------------------
;Local Data Main
;------------------

USER_INPUT_MESSAGE .STRINGZ "Input an ASCII Character, please. Thank you. \n"
SUB_NUMBER_OF_1s_PTR .FILL x3200
SUB_PRINT_DECIMAL_VALUE_PTR .FILL x3400
NUM_OF_1s_MSG .STRINGZ "\n the number of 1s in the inputted character is: "
;-------------------

;-----------------------------------------------------------------------------------------------
;Subroutine: SUB_NUMBER_OF_1s
; Parameters: R1
; Postcondition: On the console, there is an output listing the number of 1s
; in the ascii character that was inputted by the uesr. 
; Return Value: In R6,  the number of 1s is stored
;-----------------------------------------------------------------------------------------------

.orig x3200
;--------------------
;Subroutine instructions
;--------------------
	ST R0, BACKUP_R0_3200
	ST R3, BACKUP_R3_3200
	ST R4, BACKUP_R4_3200
	ST R5, BACKUP_R5_3200
	ST R2, BACKUP_R2_3200
	ST R7, BACKUP_R7_3200
	
	AND R6,R6, x0
	AND R2,R2, x0; use this as a counter for spaces
	LD R3, LOOP_DEC_VAR ; controls the loop 
	AND R4,R4,x0 ;used for checking if right number for counter is needed for a space

	OUTPUT_LOOP
		
		ADD R1,R1, #0 ;so conditoins look at R1

		BRn IF_MSB_1
		BRp IF_MSB_0
		BRz IF_ALL_0
		
		IF_MSB_1
			ADD R6, R6, #1
			BR END_IF_MSB_0
		END_IF_MSB_1
		
		IF_ALL_0
			BR END_IF_MSB_0
		END_IF_ALL_0
		
		IF_MSB_0
			BR END_IF_MSB_0
		END_IF_MSB_0
		
		ADD R1,R1, R1
		
		ADD R3,R3, #-1
		BRp OUTPUT_LOOP
		
	END_OUTPUT_LOOP



	LD R0, BACKUP_R0_3200
	LD R3, BACKUP_R3_3200
	LD R4, BACKUP_R4_3200
	LD R5, BACKUP_R5_3200
	LD R2, BACKUP_R2_3200
	LD R7, BACKUP_R7_3200
	
		ret
;---------------------
;Subroutine Local Data
;---------------------
;---------------------
	LOOP_DEC_VAR .FILL #16
	DEC_VAL_1 .FILL #1
	DECIMAL_VAL_0 .FILL #48

	BACKUP_R0_3200 .BLKW #1
	BACKUP_R3_3200 .BLKW #1
	BACKUP_R4_3200 .BLKW #1
	BACKUP_R5_3200 .BLKW #1
	BACKUP_R2_3200 .BLKW #1
	BACKUP_R7_3200 .BLKW #1
;---------------------

;-----------------------------------------------------------------------------------------------
;Subroutine: PRINT_DEC_VALUE
; Parameters: R2
; Postcondition: On the console, the decimal value of R2 is printed to the
;console
; Return Value: None
;-----------------------------------------------------------------------------------------------
	.orig x3400
;=============
;Subroutine Instructions
;=============
	
	ST R0, BACKUP_R0_3400
	ST R1, BACKUP_R1_3400
	ST R3, BACKUP_R3_3400
	ST R4, BACKUP_R4_3400
	ST R5, BACKUP_R5_3400
	ST R6, BACKUP_R6_3400
	ST R7, BACKUP_R7_3400

	AND R6, R6, x0 ; used for sign register
	AND R5,R5, x0 ; counter for counting how many n ths place
	ST R2, BACKUP_ORIGINAL_INPUT
	ADD R2, R2, #0; make R2 last used register so i can apply a condition



	BRzp END_CHECK_SIGN

	CHECK_SIGN
	;make sign bit 1 meaning negative
		ADD R6, R6, #1

		;if negative convert to positive
		NOT R2, R2
		ADD R2, R2, #1
		
		LD R0, ASCII_MINUS
		OUT 
	END_CHECK_SIGN

	LD R1, NEG_10000
	
	ADD R4, R2, R1
	BRn SET1000
	
	LOOP_10000
		
		ADD R4, R2, R1
		BRn END_LOOP_10000
		
		;implicit else
		ADD R2, R2, R1
		ADD R5, R5, #1
		
		BR LOOP_10000 
	END_LOOP_10000
	
	LD R1, ASCII_OFFSET
	ADD R0, R5, R1
	OUT
	
	SET1000
	
	LD R1, NEG_1000
	AND R5, R5, x0
	
	ADD R4, R2, R1
	BRn SET100
	
	LOOP_1000
		ADD R4, R2, R1
		BRn END_LOOP_1000
		
		;implicit else
		
		ADD R2, R2, R1
		ADD R5, R5, #1
		
		BR LOOP_1000
	
	END_LOOP_1000
	
	LD R1, ASCII_OFFSET
	ADD R0, R5, R1
	OUT
	
	SET100
	
	LD R1, NEG_100
	AND R5, R5, x0
	
	ADD R4, R2, R1
	BRn SET10
	
	LOOP_100
		ADD R4, R2, R1
		BRn END_LOOP_100
		
		;implicit else
		
		ADD R2, R2, R1
		ADD R5, R5, #1
		BR LOOP_100
	END_LOOP_100
	
	LD R1, ASCII_OFFSET
	ADD R0, R5, R1
	OUT
	
	SET10
	
	LD R1, NEG_10
	AND R5, R5, x0
	
	ADD R4,R2,R1
	BRn SET1
	
	LOOP_10
		ADD R4,R2,R1
		BRn END_LOOP_10
		
		ADD R2,R2,R1
		ADD R5,R5, #1
		BR LOOP_10
	
	END_LOOP_10

	LD R1, ASCII_OFFSET
	ADD R0, R5, R1
	OUT
	
	SET1
	
	LD R1, NEG_1
	AND R5, R5, x0
	
	LOOP_1
		ADD R4, R2, R1
		BRn END_LOOP_1
		
		ADD R2,R2,R1
		ADD R5,R5, #1
		BR LOOP_1
	
	END_LOOP_1
	
	LD R1, ASCII_OFFSET
	ADD R0, R5, R1
	OUT
	
	LD R2, BACKUP_ORIGINAL_INPUT

	LD R0, BACKUP_R0_3400
	LD R1, BACKUP_R1_3400
	LD R3, BACKUP_R3_3400
	LD R4, BACKUP_R4_3400
	LD R5, BACKUP_R5_3400
	LD R6, BACKUP_R6_3400
	LD R7, BACKUP_R7_3400


	ret
	
;=============
;Subroutine local data
;=============

;===============================================================================================
	
	NEG_10000 .FILL #-10000
	NEG_1000 .FILL #-1000
	NEG_100 .FILL #-100
	NEG_10 .FILL #-10
	NEG_1 .FILL #-1
	ASCII_OFFSET .FILL #48
	ASCII_MINUS .FILL #45
	
	BACKUP_ORIGINAL_INPUT .BLKW #1
	
	BACKUP_R0_3400 .BLKW #1
	BACKUP_R1_3400 .BLKW #1
	BACKUP_R3_3400 .BLKW #1
	BACKUP_R4_3400 .BLKW #1
	BACKUP_R5_3400 .BLKW #1
	BACKUP_R6_3400 .BLKW #1
	BACKUP_R7_3400 .BLKW #1



;===============================================================================================
;end subroutine

.end
