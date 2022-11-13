

; test harness
					.orig x3000
	
	LD R4, BASE_OF_STACK_PTR
	LD R5, MAX_OF_STACK_PTR
	LD R6, CURR_TOP_OF_STACK
	
	LD R1, SUB_RPN_MULTIPLY
	JSrr R1
				 
					halt
;-----------------------------------------------------------------------------------------------
; test harness local data:
	testARRAY_PTR .FILL x4000

	SUB_STACK_PUSH_PTR .FILL x3200
	SUB_STACK_POP_PTR .FILL x3400
	SUB_RPN_MULTIPLY .FILL x3600
	
	BASE_OF_STACK_PTR .FILL xA000
	MAX_OF_STACK_PTR .FILL xA005
	CURR_TOP_OF_STACK .FILL xA000
	
	PUSH_LOOP_CONTROL .FILL #5
	POP_LOOP_CONTROL .FILL #5
	
	
	testNum1 .FILL #1
	testNum2 .FILL #2
	testNum3 .FILL #3
	testNum4 .FILL #4
	testNum5 .FILL #5
	ascii_offset .FILL #48
	
	.ORIG x4000
	testARRAY .BLKW #5
;===============================================================================================


; subroutines:

;------------------------------------------------------------------------------------------
; Subroutine: SUB_STACK_PUSH
; Parameter (R0): The value to push onto the stack
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available
;                       address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has pushed (R0) onto the stack (i.e to address TOS+1). 
;		    If the stack was already full (TOS = MAX), the subroutine has printed an
;		    overflow error message and terminated.
; Return Value: R6 ← updated TOS
;------------------------------------------------------------------------------------------
		.orig x3200
		
		ST R7, BACKUP_R7_3200
		ST R3, BACKUP_R3_3200
		ST R2, BACKUP_R2_3200
		ST R1, BACKUP_R1_3200	 
		
		ADD R1, R5, #0 ;copies MAX to R1
		NOT R1, R1
		ADD R1, R1, #1
		
		ADD R2, R6, R1
		BRz OUTPUT_ERROR
		BRn END_OUTPUT_ERROR
		
		OUTPUT_ERROR
			LEA R0, OVERFLOW_MSG
			PUTS
			
			HALT
		END_OUTPUT_ERROR
		
		ADD R6, R6, #1
		STR R0, R6, #0
		
		
		
		LD R7, BACKUP_R7_3200
		LD R3, BACKUP_R3_3200
		LD R2, BACKUP_R2_3200
		LD R1, BACKUP_R1_3200
				 
					ret
;-----------------------------------------------------------------------------------------------
; SUB_STACK_PUSH local data
	BACKUP_R7_3200 .BLKW #1
	BACKUP_R3_3200 .BLKW #1
	BACKUP_R2_3200 .BLKW #1
	BACKUP_R1_3200 .BLKW #1
	
	OVERFLOW_MSG .STRINGZ "Overflow. Yo stack go bye bye now."


;===============================================================================================


;------------------------------------------------------------------------------------------
; Subroutine: SUB_STACK_POP
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available                      
;                       address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has popped MEM[TOS] off of the stack.
;		    If the stack was already empty (TOS = BASE), the subroutine has printed
;                an underflow error message and terminated.
; Return Value: R0 ← value popped off the stack
;		   R6 ← updated TOS
;------------------------------------------------------------------------------------------
					.orig x3400
ST R7, BACKUP_R7_3400 
	ST R3, BACKUP_R3_3400 
	ST R2, BACKUP_R2_3400 
	ST R1, BACKUP_R1_3400 	 
		
	ADD R1, R4, #0 ;copies BASE to R1
	NOT R1, R1
	ADD R1, R1, #1	 
	
	ADD R2, R6, R1
	BRz OUTPUT_ERROR_POP
	BRp END_OUTPUT_ERROR_POP
	
	OUTPUT_ERROR_POP
		LEA R0, OVERFLOW_MSG_POP 
		PUTS
		
		HALT
	
	END_OUTPUT_ERROR_POP
	
	LDR R0, R6, #0
	AND R1, R1, x0
	STR R1, R6, #0
	ADD R6, R6, #-1			 
				 
	LD R7, BACKUP_R7_3400 
	LD R3, BACKUP_R3_3400 
	LD R2, BACKUP_R2_3400 
	LD R1, BACKUP_R1_3400 			 
					ret
;-----------------------------------------------------------------------------------------------
; SUB_STACK_POP local data
	BACKUP_R7_3400 .BLKW #1
	BACKUP_R3_3400 .BLKW #1
	BACKUP_R2_3400 .BLKW #1
	BACKUP_R1_3400 .BLKW #1
	
	
	
	OVERFLOW_MSG_POP .STRINGZ "POP Overflow. Yo stack go bye bye now."


;===============================================================================================

;------------------------------------------------------------------------------------------
; Subroutine: SUB_RPN_MULTIPLY
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available
;                       address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has popped off the top two values of the stack,
;		    multiplied them together, and pushed the resulting value back
;		    onto the stack.
; Return Value: R6 ← updated TOS address
;------------------------------------------------------------------------------------------
					.orig x3600
		ST R0, BACKUP_R0_3600
		ST R1, BACKUP_R1_3600
		ST R2, BACKUP_R2_3600
		ST R3, BACKUP_R3_3600
		ST R7, BACKUP_R7_3600		 
			
			LD R1, SUB_STACK_PUSH_PTR_MULTIPLY_RPN
			LD R2, ASCII_OFFSET_MULTIPLY_RPN
			
			GET_NUM
				LEA R0, MSG_FOR_USR1
				PUTS
				
				GETC
				OUT
				ADD R0, R2, R0
				JSrr R1
				
				
				GETC
				OUT
				ADD R0, R2, R0
				JSrr R1
				
				LD R0, NEWLINE_CHAR
				OUT
				
				LEA R0, MSG_FOR_USR2
				PUTS
				GETC
				OUT
				
				LD R0, NEWLINE_CHAR
				OUT
				
			END_GET_NUM
			
			MULTIPLY_NUMBERS
				LD R1, SUB_STACK_POP_PTR_MULTIPLY_RPN
				JSrr R1
					
				ADD R2, R0, #0
					
				JSrr R1
					
				ADD R3, R0, #0
				
				LD R1, SUB_MULTIPLY_PTR 
				JSrr R1
				
				LD R1, SUB_STACK_PUSH_PTR_MULTIPLY_RPN
				JSrr R1
			END_MULTIPLY_NUMBERS
			
			OUTPUT_RESULT
				LD R1, SUB_STACK_POP_PTR_MULTIPLY_RPN
				JSrr R1
				
				ADD R2, R0, #0 ;R2 is a parameter for print decimal
				
				LD R1, SUB_PRINT_DECIMAL_PTR
				JSrr R1
			
			END_OUTPUT_RESULT
				
			
				
		LD R0, BACKUP_R0_3600		 
		LD R1, BACKUP_R1_3600
		LD R2, BACKUP_R2_3600
		LD R3, BACKUP_R3_3600
		LD R7, BACKUP_R7_3600		 
				 
					ret
;-----------------------------------------------------------------------------------------------
; SUB_RPN_MULTIPLY local data
		BACKUP_R0_3600 .BLKW #1
		BACKUP_R1_3600 .BLKW #1
		BACKUP_R2_3600 .BLKW #1
		BACKUP_R3_3600 .BLKW #1
		BACKUP_R7_3600 .BLKW #1
		
	SUB_MULTIPLY_PTR .FILL x3800
	SUB_STACK_PUSH_PTR_MULTIPLY_RPN .FILL x3200
	SUB_STACK_POP_PTR_MULTIPLY_RPN .FILL x3400
	SUB_PRINT_DECIMAL_PTR .FILL x4200
	
	ASCII_OFFSET_MULTIPLY_RPN .FILL #-48
	
	NEWLINE_CHAR .FILL #10
		
		MSG_FOR_USR1 .STRINGZ "Please enter two single digit numbers \n"
		MSG_FOR_USR2 .STRINGZ "Please enter an astris sign\n"


;===============================================================================================



; SUB_MULTIPLY	
;parameters are R2 and R3 operands
;multiply two numbers return in R0
;--------------
;INSTRUCTIONS
;--------------
.orig x3800
	
	ST R1, BACKUP_R1_3800
	ST R4, BACKUP_R4_3800
	ST R5, BACKUP_R5_3800
	ST R6, BACKUP_R6_3800
	ST R7, BACKUP_R7_3800
		ADD R4, R3, #0
		
		ADD R4, R4, #0
		BRz END_WHILE_MULTIPLY
		ADD R2, R2, #0
		BRz END_WHILE_MULTIPLY
		
		AND R0, R0, x0
		WHILE_MULTIPLY
			ADD R0, R0, R2
	
			ADD R4, R4, #-1
			BRp WHILE_MULTIPLY
		END_WHILE_MULTIPLY
		
		;LD R6, ASCII_OFFSET_MULTIPLY

		;ADD R0, R0, R6
	
	ld R1, BACKUP_R1_3800
	LD R4, BACKUP_R4_3800
	LD R5, BACKUP_R5_3800
	LD R6, BACKUP_R6_3800
	LD R7, BACKUP_R7_3800
ret
;------	
;LOCAL DATA
	
	BACKUP_R1_3800 .BLKW #1
	BACKUP_R4_3800 .BLKW #1
	BACKUP_R5_3800 .BLKW #1
	BACKUP_R6_3800 .BLKW #1
	BACKUP_R7_3800 .BLKW #1
	
	ASCII_OFFSET_MULTIPLY .FILL #48
;------





; SUB_GET_NUM	;no	

; SUB_PRINT_DECIMAL		Only needs to be able to print 1 or 2 digit numbers. 
;						You can use your lab 7 s/r.
;------------
;INSTRUCTIONS
;------------
.ORIG x4200
ST R0, BACKUP_R0_4200
	ST R1, BACKUP_R1_4200
	ST R3, BACKUP_R3_4200
	ST R4, BACKUP_R4_4200
	ST R5, BACKUP_R5_4200
	ST R6, BACKUP_R6_4200
	ST R7, BACKUP_R7_4200

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

	LD R0, BACKUP_R0_4200
	LD R1, BACKUP_R1_4200
	LD R3, BACKUP_R3_4200
	LD R4, BACKUP_R4_4200
	LD R5, BACKUP_R5_4200
	LD R6, BACKUP_R6_4200
	LD R7, BACKUP_R7_4200
	
	ret
;---------------
;LOCAL DATA

	NEG_10000 .FILL #-10000
	NEG_1000 .FILL #-1000
	NEG_100 .FILL #-100
	NEG_10 .FILL #-10
	NEG_1 .FILL #-1
	ASCII_OFFSET .FILL #48
	ASCII_MINUS .FILL #45
	
	BACKUP_ORIGINAL_INPUT .BLKW #1
	
	BACKUP_R0_4200 .BLKW #1
	BACKUP_R1_4200 .BLKW #1
	BACKUP_R3_4200 .BLKW #1
	BACKUP_R4_4200 .BLKW #1
	BACKUP_R5_4200 .BLKW #1
	BACKUP_R6_4200 .BLKW #1
	BACKUP_R7_4200 .BLKW #1



;---------------

.end
