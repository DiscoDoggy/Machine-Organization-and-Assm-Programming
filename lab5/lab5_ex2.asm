

;====
;MAIN CODE
;====

;====
;MAIN INSTRUCTIONS
;====
.orig x3000
;stores address of subroutine in R6 then jumps to the sub routine
;also gets adderess of input array
	
	LD R1, INPUT_CHAR_ARRAY_PTR
	LD R6, SUB_GET_STRING_PTR
	JSrr R6
	
	LD R1, INPUT_CHAR_ARRAY_PTR
	
	LD R6, SUB_IS_PALINDROME_PTR
	JSrr R6
	
	HALT
;====
;MAIN LOCAL DATA
;====
SUB_GET_STRING_PTR .FILL x3200
INPUT_CHAR_ARRAY_PTR .FILL x4000
SUB_IS_PALINDROME_PTR .FILL x3400

	.orig x4000
INPUT_CHAR_ARRAY .BLKW #100


;------------------------------------------------------------------------
; Subroutine: SUB_GET_STRING

; Parameter (R1): The starting address of the character array

; Postcondition: The subroutine has prompted the user to input a string,
;terminated by the [ENTER] key (the "sentinel"), and has stored
;the received characters in an array of characters starting at (R1).
;the array is NULL-terminated; the sentinel character is NOT stored.
; 
;Return Value (R5): The number of ​ non-sentinel​ chars read from the user.
;R1 contains the starting address of the array unchanged.
;-------------------------------------------------------------------------
	.orig x3200
;==== SUBROUTINE INSTRUCTIONS
	
;backing up affected registers
	ST R0, BACKUP_R0_3200
	ST R7, BACKUP_R7_3200
	ST R2, BACKUP_R2_3200
	ST R3, BACKUP_R3_3200
	
;prints user instructions
	LD R2, DEC_VAL_100 
	LEA R0, USR_INSTRUCTIONS
	PUTS	
	
	LD R0, NEWLINE_CHAR
	OUT
	AND R0,R0,x0
	
	DO_WHILE_INPUT
		GETC
		
		ADD R3, R0, #-10 ;checks whether or not enter was pressed
		BRz END_DO_WHILE_INPUT
		
		OUT; echos character
		
		STR R0, R1, #0 ;stores char in array
		ADD R1, R1, #1 ;changes array position
		
		ADD R5, R5, #1 ; loop counter/char counter
		ADD R2, R2, #-1 ;loop decrement control
		
		BRp DO_WHILE_INPUT
	END_DO_WHILE_INPUT
	
;RESTORING PREVIOUS REGISTER VALUES
	LD R7, BACKUP_R7_3200
	LD R0, BACKUP_R0_3200
	LD R2, BACKUP_R2_3200
	LD R3, BACKUP_R3_3200

	ret
;==== SUBROUTINE LOCAL DATA
BACKUP_R7_3200 .BLKW #1
BACKUP_R0_3200 .BLKW #1
BACKUP_R2_3200 .BLKW #1 ;R2 is used here to decrement loop counter
BACKUP_R3_3200 .BLKW #1 ; r3 will be used for checking whether the user pressed enter
DEC_VAL_100 .FILL #100 ;for cutting user input off at 100 chars
USR_INSTRUCTIONS .STRINGZ "Please input at most 100 characters. Press enter to stop."
NEWLINE_CHAR .FILL '\n'

;==== END SUB_GET_STRING


;-------------------------------------------------------------------------
; Subroutine: SUB_IS_PALINDROME
; Parameter (R1): The starting address of a null-terminated string
; Parameter (R5): The number of characters in the array.
; Postcondition: The subroutine has determined whether the string at (R1)
;is a palindrome or not, and returned a flag to that effect.
; Return Value: R4 {1 if the string is a palindrome, 0 otherwise}
	.orig x3400
;==== Subroutine instructions

;backing up affected registers
	ST R7, BACKUP_R7_3400
	ST R0, BACKUP_R0_3400
	ST R2, BACKUP_R2_3400
	ST R3, BACKUP_R3_3400
	;ST R4, BACKUP_R4_3400
	ST R6, BACKUP_R6_3400

;Load first address of array in R1 and last address of array in R2
	ADD R2, R1, R5 ;adds the amount of chars to the adderess to get last char pos
	ADD R2, R2, #-1
	;at this point R1 holds the first address and R2 holds the last address 
	
	LOOP_CHECK_PALINDROME
		LDR R3, R1, #0 ;loads value stored in array at adderess R1 into R3
		LDR R7, R2, #0 ;loads value stored in array at address R2 into R7
		
		CHECK_EQUALITY
			NOT R7,R7
			ADD R7,R7, #1 ;do 2s complement
			
			ADD R6, R3, R7
			
			BRnp NOT_PALINDROME ;if not equal, not palindrome
			;implicit else if
			
			NOT R2, R2
			ADD R2, R2, #1 ;do 2s complement
			
			ADD R6, R1, R2 ;if R1, R2 are the same address aka center 
			BRz IS_PALINDROME
			
			;implicit else
			NOT R2, R2
			ADD R2, R2, #1 ;undo 2s complement
			
			NOT R7,R7
			ADD R7,R7, #1 ;undo 2s complement
			
			ADD R1, R1, #1 ; increment the array address
			ADD R2, R2, #-1 ; decrement the array address
			
			ADD R5, R5, #-1 ; loop counter (theoretically never reaches this)
			BRp LOOP_CHECK_PALINDROME
		END_CHECK_EQUALITY

	END_LOOP_CHECK_PALINDROME

	IS_PALINDROME
		
		LD R4, DEC_1
		BR END_NOT_PALINDROME
		
	END_IS_PALINDROME
	
	NOT_PALINDROME
	
		LD R4, DEC_0
		
	END_NOT_PALINDROME
	
	LD R7, BACKUP_R7_3400
	LD R0, BACKUP_R0_3400
	LD R2, BACKUP_R2_3400
	LD R3, BACKUP_R3_3400
	LD R6, BACKUP_R6_3400
	
	ret
;===== Subroutine local data
DEC_0 .FILL #0
DEC_1 .FILL #1

BACKUP_R7_3400 .BLKW #1
BACKUP_R0_3400 .BLKW #1
BACKUP_R2_3400 .BLKW #1
BACKUP_R3_3400 .BLKW #1
;BACKUP_R4_3400 .BLKW #1 ;return the 1 or 0
BACKUP_R6_3400 .BLKW #1
.end
