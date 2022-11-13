

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

	HALT
;====
;MAIN LOCAL DATA
;====
SUB_GET_STRING_PTR .FILL x3200
INPUT_CHAR_ARRAY_PTR .FILL x4000

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

.end
