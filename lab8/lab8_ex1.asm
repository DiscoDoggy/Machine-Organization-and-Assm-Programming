

;test harness / (main)

;==========
;Instructions
;==========
	.orig x3000
	
	LD R6, SUB_HARD_CODE_DEC_VAL_PTR
	JSrr R6
	
	ADD R2, R2, #1
	
	LD R6, SUB_PRINT_DEC_VALUE_PTR
	JSrr R6





	HALT

;============
;Local Data for Main
;============

	SUB_HARD_CODE_DEC_VAL_PTR .FILL x3200
	SUB_PRINT_DEC_VALUE_PTR .FILL x3400

;===============================================================================================

;end main

;-----------------------------------------------------------------------------------------------
;Subroutine: SUB_HARD_CODE_DEC_VAL
; Parameters: None
; Postcondition: A certain register, R2, is allocated with a hardcoded
;decimal value
; Return Value: R2
;-----------------------------------------------------------------------------------------------
	.orig x3200

;===========
;Subroutine instructions
;===========
	LD R2, HARD_CODED_VALUE
	



		ret
;============
;Subroutine local data
;============

;===============================================================================================
	HARD_CODED_VALUE .FILL #-257




;===============================================================================================
;End SUB_HARD_CODE_DEC_VALUE

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
	
	
	NEWLINE_CHAR .FILL #10
	PLUSSIGN_ASCII .FILL #-43
	MINUSSIGN_ASCII .FILL #-45
	DEC_78 .FILL #78
	DEC_21 .FILL #21 ; number of characters in error message
	DEC_NEGATIVE_10 .FILL #-10 ;For checking if more than 10
	ASCII_OFFSET .FILL #-48 ;offset between ascii and binary
	DEC_6 .FILL #6 ;max amount of characters
	DEC_5 .FILL #5 ;max amount of digits allowed to be entered
	DEC_NEGATIVE_5 .FILL #-5 ;used for checking if there are 5 digits
	DEC_9 .FILL #9
	DEC_NEGATIVE_1 .FILL #-1
	
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
