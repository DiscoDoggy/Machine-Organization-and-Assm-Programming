

; test harness
					.orig x3000
	
	LD R4, BASE_OF_STACK_PTR
	LD R5, MAX_OF_STACK_PTR
	LD R6, CURR_TOP_OF_STACK
	
	LD R1, testNum1
	LD R2, testARRAY_PTR
	LD R3, testNum5
	
	WHILE_INPUT_TO_TEST_ARRAY
		STR R1, R2, #0
		
		ADD R2,R2, #1
		ADD R1,R1, #1
		
		ADD R3, R3, #-1
		BRp WHILE_INPUT_TO_TEST_ARRAY
	
	END_WHILE_INPUT_TO_TEST_ARRAY
				 
	LD R2, testARRAY_PTR
	LD R1, SUB_STACK_PUSH_PTR
	LD R3, PUSH_LOOP_CONTROL
	
	WHILE_PUSH
		LDR R0, R2, #0	 
		ADD R2, R2, #1
		
		JSrr R1
		ADD R3, R3, #-1
		BRp WHILE_PUSH
	END_WHILE_PUSH_VAL
	
	;LD R1, SUB_STACK_PUSH_PTR
	;JSrr R1
	;JSrr R1
	;JSrr R1
	;JSrr R1
	;JSrr R1
	
	;LD R1, SUB_STACK_POP_PTR
	;JSrr R1
	;JSrr R1
	;JSrr R1
	;JSrr R1
	;JSrr R1
	;JSrr R1
	
	LD R1, SUB_STACK_POP_PTR
	LD R3, POP_LOOP_CONTROL
	LD R2, ascii_offset
	
	WHILE_POP
		JSrr R1	 
		ADD R0, R0, R2
		OUT
		
		ADD R3, R3, #-1
		BRp WHILE_POP
	END_WHILE_POP_VAL
				 
					halt
;-----------------------------------------------------------------------------------------------
; test harness local data:
	testARRAY_PTR .FILL x4000

	SUB_STACK_PUSH_PTR .FILL x3200
	SUB_STACK_POP_PTR .FILL x3400
	
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

.end
