

; test harness
					.orig x3000
				 LD R6, SUB_PRINT_OPCODE_TABLE_PTR
				 JSrr R6
				 
				 LD R6, SUB_FIND_OP_CODE_PTR
				 JSrr R6
				 
				 
					halt
;-----------------------------------------------------------------------------------------------
; test harness local data:
	TEST_OP_CODE_ARRAY_PTR .FILL x4000
	TEST_INSTRUCTION_ARRAY_PTR .FILL x4100
	SUB_PRINT_OPCODE_TABLE_PTR .FILL x3200
	SUB_FIND_OP_CODE_PTR .FILL x3600



;===============================================================================================


; subroutines:
;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_PRINT_OPCODE_TABLE
; Parameters: None
; Postcondition: The subroutine has printed out a list of every LC3 instruction
;				 and corresponding opcode in the following format:
;					ADD = 0001
;					AND = 0101
;					BR = 0000
;					…
; Return Value: None
;-----------------------------------------------------------------------------------------------
					.orig x3200
	ST R0, BACKUP_R0_3200
	ST R1, BACKUP_R1_3200
	ST R2, BACKUP_R2_3200
	ST R3, BACKUP_R3_3200
	ST R4, BACKUP_R4_3200
	ST R5, BACKUP_R5_3200
	ST R6, BACKUP_R6_3200
	ST R7, BACKUP_R7_3200 
	
	LD R1, instructions_po_ptr ;pointer to string instructions "array"
	LD R2, opcodes_po_ptr ;pointer to .FILL instructions "array"
	LD R3, LOOP_COUNTER
	LD R6, SUB_PRINT_OP_CODE_PTR
					
	WHILE_PRINT
		WHILE_OUT_INSTRUCTION
			LDR R0, R1, #0
			OUT
			
			ADD R1, R1, #1
			LDR R0, R1, #0
			
			BRz END_WHILE_OUT_INSTRUCTION
			
			;implicit else
			BR WHILE_OUT_INSTRUCTION
		END_WHILE_OUT_INSTRUCTION
	
	;out an equals sign
		LD R0, ASCII_EQUALS
		OUT
		;out opcode by calling OP code subroutine with parameter R2
		JSrr R6
		
		LD R0, NEWLINE_CHAR
		OUT
	;increment "arrays"
		ADD R1, R1, #1
		ADD R2, R2, #1
	;decrement counter and repeat
		ADD R3, R3, #-1
		BRp WHILE_PRINT
	
	END_WHLIE_PRINT
					
				 
				 
				 
	LD R0, BACKUP_R0_3200
	LD R1, BACKUP_R1_3200
	LD R2, BACKUP_R2_3200
	LD R3, BACKUP_R3_3200
	LD R4, BACKUP_R4_3200
	LD R5, BACKUP_R5_3200
	LD R6, BACKUP_R6_3200
	LD R7, BACKUP_R7_3200 			 
				 
					ret
;-----------------------------------------------------------------------------------------------
; SUB_PRINT_OPCODE_TABLE local data
opcodes_po_ptr		.fill x4000				; local pointer to remote table of opcodes
instructions_po_ptr	.fill x4100				; local pointer to remote table of instructions
SUB_PRINT_OP_CODE_PTR	.fill x3400

ASCII_EQUALS .FILL #61
ASCII_TERMINATE_CHAR .FILL #0
LOOP_COUNTER .FILL #17
NEWLINE_CHAR .FILL '\n'

;BACKUPS
BACKUP_R0_3200 .BLKW #1
BACKUP_R1_3200 .BLKW #1 
BACKUP_R2_3200 .BLKW #1
BACKUP_R3_3200 .BLKW #1
BACKUP_R4_3200 .BLKW #1
BACKUP_R5_3200 .BLKW #1
BACKUP_R6_3200 .BLKW #1
BACKUP_R7_3200 .BLKW #1

;===============================================================================================


;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_PRINT_OPCODE
; Parameters: R2 containing a 4-bit op-code in the 4 LSBs of the register
; Postcondition: The subroutine has printed out just the 4 bits as 4 ascii 1s and 0s
;				 The output is NOT newline terminated.
; Return Value: None
;-----------------------------------------------------------------------------------------------
					.orig x3400
	ST R0, BACKUP_R0_3400
	ST R1, BACKUP_R1_3400  
	ST R3, BACKUP_R3_3400 
	ST R4, BACKUP_R4_3400 
	ST R5, BACKUP_R5_3400 
	ST R6, BACKUP_R6_3400 
	ST R7, BACKUP_R7_3400 
	
	LDR R1, R2, #0 ;gets value that R2 is pointing too currently
;start to ascii conversion pasted coded
	LD R3, LEFT_SHIFT_COUNTER
	
	LEFT_SHIFT
		ADD R1,R1,R1
		ADD R3, R3, #-1
		
		BRp LEFT_SHIFT
	END_LEFT_SHIFT

	LD R3, LOOP_DEC_VAR ; controls the loop 
	

	OUTPUT_LOOP
		
		ADD R1,R1, #0 ;so conditoins look at R1

		BRn IF_MSB_1
		BRp IF_MSB_0
		BRz IF_ALL_0
		
		IF_MSB_1
			LD R0, DEC_VAL_1
			OUT
			BR END_IF_MSB_0
		END_IF_MSB_1
		
		IF_ALL_0
			LD R0, DECIMAL_VAL_0
			OUT
			BR END_IF_MSB_0
		END_IF_ALL_0
		
		IF_MSB_0
			LD R0, DECIMAL_VAL_0
			OUT
		END_IF_MSB_0
		
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
	 
;end to ascii conversion				 
	LD R0, BACKUP_R0_3400
	LD R1, BACKUP_R1_3400  
	LD R3, BACKUP_R3_3400 
	LD R4, BACKUP_R4_3400 
	LD R5, BACKUP_R5_3400 
	LD R6, BACKUP_R6_3400 
	LD R7, BACKUP_R7_3400
					ret
;-----------------------------------------------------------------------------------------------
; SUB_PRINT_OPCODE local data

LOOP_DEC_VAR .FILL #3
LEFT_SHIFT_COUNTER .FILL #12
DECIMAL_VAL_0 .FILL #48 ;ascii 0
DEC_VAL_1 .FILL #49 ;ascii 1

BACKUP_R0_3400 .BLKW #1
BACKUP_R1_3400 .BLKW #1 
BACKUP_R3_3400 .BLKW #1
BACKUP_R4_3400 .BLKW #1
BACKUP_R5_3400 .BLKW #1
BACKUP_R6_3400 .BLKW #1
BACKUP_R7_3400 .BLKW #1

;===============================================================================================


;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_FIND_OPCODE
; Parameters: None
; Postcondition: The subroutine has invoked the SUB_GET_STRING subroutine and stored a string
; 				as local data; it has searched the AL instruction list for that string, and reported
;				either the instruction/opcode pair, OR "Invalid instruction"
; Return Value: None
;-----------------------------------------------------------------------------------------------
					.orig x3600
	ST R0, BACKUP_R0_3600 
	ST R1, BACKUP_R1_3600  
	ST R3, BACKUP_R3_3600 
	ST R4, BACKUP_R4_3600 
	ST R5, BACKUP_R5_3600 
	ST R6, BACKUP_R6_3600 
	ST R7, BACKUP_R7_3600 
	
	RESTART_SEARCH ;wont ever end because there is no end to this 
	
	LD R3, USER_INPUT_MAX_SIZE
	LD R2, USER_INPUT_ARRAY_PTR
	AND R6,R6, x0

;WHILE ZERO OUT solves a bug where after a 4 letter instruction is entered
; when the program reruns for new input 3 letter inputs are wrong because
;the fourth letter is not erased from memory. This is solved by zeroing
;out the user input array each run
	
		WHILE_ZERO_OUT
			STR R6, R2, #0
			
			ADD R2,R2, #1
			
			ADD R3, R3, #-1
			BRp WHILE_ZERO_OUT
		END_WHILE_ZERO_OUT
;get user input
	LD R2, USER_INPUT_ARRAY_PTR
	
	LD R6, SUB_GET_STRING_PTR
		JSrr R6
	
	LD R1, instructions_fo_ptr
	LD R2, opcodes_fo_ptr
	LD R3, USER_INPUT_ARRAY_PTR	;resets R3 back to beginning of array
	AND R7,R7, x0 ;termination char counter
	
	
	SEARCH_FOR_USER_INPUT
	
		WHILE_CHECK_ARRAY_INSTRUCTION
		
		
			WHILE_CHECK_WORD
				;loading in values to registers from arrays
				LDR R4, R1, #0
				LDR R5, R3, #0
;check char	
	;convert to twos compliment then add the instruction char
	;and a corresponding char from the input char. If they are equal(BRz)
	; jump to DOES_MATCH if not equal jump to DOES_NOT_MATCH
	;If does match we check for both bits being terminating if they are
	;we know we are at the end of the instruction and user input and we
	;have found out user input. If does not match, we jump to the next
	;instruction by finding the closest terminating null character
				
				CHECK_CHAR
	
					NOT R5,R5
					ADD R5,R5, #1
					
					ADD R6, R5, R4
					
					BRz CHAR_DOES_MATCH
					BRnp DOES_NOT_MATCH
					
					
					CHAR_DOES_MATCH
						NOT R5,R5
						ADD R5,R5, #1
						
					
						ADD R6, R5, R4
						BRz VALID_INPUT ;imply both are terminatoin chars
						;implicit else
					
						;increments arrays to prepare comparison of next 
						;corresponding characters in each array
						ADD R1,R1, #1
						ADD R3, R3, #1
						
						BR WHILE_CHECK_WORD
					END_CHAR_DOES_MATCH
					
					DOES_NOT_MATCH
						LD R3, USER_INPUT_ARRAY_PTR 
						
						WHILE_CHECK_TERMINATING_CHAR
							LDR R4, R1, #0
							
							BRz AT_TERM_CHAR
							BRnp NOT_AT_TERM_CHAR
							
							AT_TERM_CHAR
								ADD R1,R1, #1 ;increasing array position
								LDR R4, R1, #0
								ADD R7, R7, #1 ;increase termination char countner
								
								ADD R4,R4, #0 ;used for setting last used register
								
								BRn INVALID_INPUT ;indicates hit -1 and there are no more valid numbers
								BRp WHILE_CHECK_ARRAY_INSTRUCTION ;if there is no -1 after we incremented this should be start of new word
								
							END_TERM_CHAR
							
						NOT_AT_TERM_CHAR
							ADD R1,R1, #1 ;increase R1 until we hit a termination char
							BR WHILE_CHECK_TERMINATING_CHAR
						
						END_WHILE_CHECK_TERMINATING_CHAR
					
					END_DOES_NOT_MATCH
					
	END_FOR_SEARCH_FOR_USER_INPUT
	
;In our CHECK CHAR, we counted the number of terminating null chars in R7 it took
;to get to our desired instruction that the user searched. The first part
;of valid input aims to find the first character of the searched instruction
;by traversing through the instruction array and using the counter of null
;term chars to know when to stop Once we are in the right place we output 
;the instruction. The opcode works the same way.	
	
	VALID_INPUT
		AND R6,R6, x0
		ST R7, COUNTER_HOLDER
		LD R1, instructions_fo_ptr
		
		ADD R7,R7, #0
		BRz WHILE_OUTPUT_VALID_INSTRUCTION
		;implicit else
		
		WHILE_GO_TO_TERM_CHAR
			ADD R1, R1, #1
			LDR R2, R1, #0
			
			BRp WHILE_GO_TO_TERM_CHAR
			BRz TERM_CHAR
			
			TERM_CHAR
				ADD R7,R7, #-1
				BRp WHILE_GO_TO_TERM_CHAR
				BRz END_WHILE_GO_TO_TERM_CHAR
			
		END_WHILE_GO_TO_TERM_CHAR
		
		ADD R1,R1, #1 ;go to term char leaves off on a term char adding one brings us to the next instruction 
		
		WHILE_OUTPUT_VALID_INSTRUCTION ;outputs instruction
			LDR R0, R1, #0
			BRz END_INVALID_INPUT
			OUT
			
			ADD R1, R1, #1
			LDR R2,R1, #0
			
			BRp WHILE_OUTPUT_VALID_INSTRUCTION
			
		END_WHILE_OUTPUT_VALID_INSTRUCTION
		
		LD R0, ASCII_EQUAL_SIGN
		OUT
	
		AND R6,R6, x0
		LD R7, COUNTER_HOLDER
		LD R2, opcodes_fo_ptr
	
		ADD R2, R2, R7 ;jumps to opcode position in opcode array
		
		LD R6, SUB_PRINT_OP_CODE_PTR2
		JSrr R6
	
		BR END_INVALID_INPUT
	END_VALID_INPUT
	
	
	INVALID_INPUT
		LEA R0, OUTPUT_FOR_INVALID
		PUTS
	END_INVALID_INPUT
	
	LD R0, ENTER_CHAR
	OUT
	
	BR RESTART_SEARCH		 
				 
							 
	LD R0, BACKUP_R0_3600 
	LD R1, BACKUP_R1_3600 
	LD R3, BACKUP_R3_3600 
	LD R4, BACKUP_R4_3600 
	LD R5, BACKUP_R5_3600 
	LD R6, BACKUP_R6_3600 
	LD R7, BACKUP_R7_3600
			 
				 ret
;-----------------------------------------------------------------------------------------------
; SUB_FIND_OPCODE local data
opcodes_fo_ptr			.fill x4000
instructions_fo_ptr		.fill x4100
USER_INPUT_ARRAY_PTR	.FILL x4300
SUB_GET_STRING_PTR		.FILL x3800
SUB_PRINT_OP_CODE_PTR2	.FILL x3400
OUTPUT_FOR_VALID .STRINGZ "Valid input"
OUTPUT_FOR_INVALID .STRINGZ "Invalid input"
ENTER_CHAR .FILL '\n'
USER_INPUT_MAX_SIZE .FILL #5
COUNTER_HOLDER .BLKW #1
ASCII_EQUAL_SIGN .FILL #61


BACKUP_R0_3600 .BLKW #1
BACKUP_R1_3600 .BLKW #1 
BACKUP_R3_3600 .BLKW #1
BACKUP_R4_3600 .BLKW #1
BACKUP_R5_3600 .BLKW #1
BACKUP_R6_3600 .BLKW #1
BACKUP_R7_3600 .BLKW #1



;===============================================================================================


;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_GET_STRING
; Parameters: R2 - the address to which the null-terminated string will be stored.
; Postcondition: The subroutine has prompted the user to enter a short string, terminated 
; 				by [ENTER]. That string has been stored as a null-terminated character array 
; 				at the address in R2
; Return Value: None (the address in R2 does not need to be preserved)
;-----------------------------------------------------------------------------------------------
					.orig x3800
	ST R0, BACKUP_R0_3800 
	ST R1, BACKUP_R1_3800
	ST R3, BACKUP_R3_3800 
	ST R4, BACKUP_R4_3800
	ST R7, BACKUP_R7_3800 
	
	LD R1, MAX_USER_INPUT_SIZE
	LD R4, ASCII_NEWLINE_CHAR_CHECK
	
	LEA R0, STARTING_MESSAGE
	PUTS

	
	WHILE_USER_INPUT
		GETC
		ADD R3, R0, R4
		BRz END_WHILE_USER_INPUT 
		OUT
		
		STR R0, R2, #0
		ADD R2, R2, #1
		
		
		ADD R1, R1, #-1
		BRp WHILE_USER_INPUT
		
	END_WHILE_USER_INPUT	 
			
		LD R0, NEWLINE_CHAR1
		OUT		 
					 
	LD R0, BACKUP_R0_3800
	LD R1, BACKUP_R1_3800	
	LD R3, BACKUP_R3_3800	
	LD R4, BACKUP_R4_3800 
	LD R7, BACKUP_R7_3800
	
		ret
;-----------------------------------------------------------------------------------------------
; SUB_GET_STRING local data
MAX_USER_INPUT_SIZE .FILL #5
ASCII_NEWLINE_CHAR_CHECK .FILL #-10
STARTING_MESSAGE .STRINGZ "Input an instruction in all CAPS less than 6 chars \n"
NEWLINE_CHAR1 .FILL '\n'
;USER_INPUT_ARRAY_PTR2	.FILL x4300


BACKUP_R0_3800 .BLKW #1
BACKUP_R1_3800 .BLKW #1
BACKUP_R3_3800 .BLKW #1
BACKUP_R4_3800 .BLKW #1
BACKUP_R7_3800 .BLKW #1





;===============================================================================================


;-----------------------------------------------------------------------------------------------
; REMOTE DATA
					.ORIG x4000			; list opcodes as numbers from #0 through #15, e.g. .fill #12 or .fill xC
					;.BLKW #16
					;like a psudo array
; opcodes
				DEC_0 .FILL #1
				DEC_1 .FILL #5
				DEC_2 .FILL #0
				DEC_3 .FILL #12
				DEC_4 .FILL #4
				DEC_5 .FILL #4
				DEC_6 .FILL #2
				DEC_7 .FILL #10
				DEC_8 .FILL #6
				DEC_9 .FILL #14
				DEC_10 .FILL #9
				DEC_11 .FILL #12
				DEC_12 .FILL #8
				DEC_13 .FILL #3
				DEC_14 .FILL #11
				DEC_15 .FILL #7
				DEC_17 .FILL #15
				TERMINATE_CHAR .FILL #-1
				

					.ORIG x4100			; list AL instructions as null-terminated character strings, e.g. .stringz "JMP"
								 		; - be sure to follow same order in opcode & instruction arrays!
					;.BLKW #16
; instructions		
					INSTRUCT_ADD .STRINGZ "ADD"
					INSTRUCT_AND .STRINGZ "AND"
					INSTRUCT_BR .STRINGZ "BR"
					INSTRUCT_JMP .STRINGZ"JMP"
					INSTRUCT_JSR .STRINGZ "JSR"
					INSTRUCT_JSRR .STRINGZ "JSRR"
					INSTRUCT_LD .STRINGZ "LD"
					INSTRUCT_LDI .STRINGZ "LDI"
					INSTRUCT_LDR .STRINGZ "LDR"
					INSTRUCT_LEA .STRINGZ "LEA"
					INSTRUCT_NOT .STRINGZ "NOT"
					INSTRUCT_RET .STRINGZ "RET"
					INSTRUCT_RTI .STRINGZ "RTI"
					INSTRUCT_ST .STRINGZ "ST"
					INSTRUCT_STI .STRINGZ "STI"
					INSTRUCT_STR .STRINGZ "STR"
					INSTRUCT_TRAP .STRINGZ "TRAP"
					ITERATOR_STOPPER .FILL #-1
					
				
				.ORIG x4300
				USER_INPUT_ARRAY .BLKW #5	
;===============================================================================================
.end
