
;=================================================================================
;THE BINARY REPRESENTATION OF THE USER-ENTERED DECIMAL NUMBER MUST BE STORED IN R5
;=================================================================================

					.ORIG x3000		
;-------------
;Instructions
;-------------

; output intro prompt
	CHECK_FIRST_CHARACTER
		
		LD R1, introPromptPtr ;for intro prompt text
		LD R2, DEC_78 ;#of characters in the prompt
		LD R3, digitArrayPtr ;where i will store digits
		
		WHILE_OUTPUT_INTRO
			LDR R0, R1, #0
			OUT
			
			ADD R1, R1, #1
			
			ADD R2, R2, #-1
			BRp WHILE_OUTPUT_INTRO
		END_WHILE_OUTPUT_INTRO		
			
			
			
; Set up flags, counters, accumulators as needed
		LD R4, DEC_5 ;will count how many chars have been input
		AND R5,R5, x0 ;this is our accumulator
		AND R6,R6,x0 ;this is our negative flag
; Get first character, test for '\n', '+', '-', digit/non-digit 	
		GETC
		OUT
		
		
	;conditions
		IF_ENTER_CONDITION
			LD R1, NEWLINE_ASCII
			ADD R2, R1, R0
			
			BRz IF_ENTER_OUTCOME
		END_IF_ENTER_CONDITION
		
		;implicit else if
		IF_MINUS_CONDITION
			LD R1, MINUSSIGN_ASCII
			ADD R2, R1, R0
			
			BRz IF_MINUS_OUTCOME
		END_IF_MINUS_CONDITION
		;implicit else if
		
		IF_PLUS_CONDITION
			LD R1, PLUSSIGN_ASCII
			ADD R2, R1, R0
			
			
			BRz IF_PLUS_OUTCOME
		END_IF_PLUS_CONDITION
		;implicit else if
		
		IF_INVALID_NUMBER_CONDITION
			;convert ascii into binary
			LD R1, ASCII_OFFSET
			ADD R0, R0, R1
			
			;Testing if Less than 0
			BRn IF_INVALID_NUMBER_OUTCOME
			;implicit else if
			
			;Testing if less than 10
			LD R1, DEC_NEGATIVE_10
			ADD R2, R0, #0 ;copying non ascii value into R2 to save value before subtracting 10
			ADD R0, R0, R1 ;subtracting 10 to test if less than 10
			
			BRzp IF_INVALID_NUMBER_OUTCOME
			
			;implicit else meaning valid number
			ADD R0, R2, #0 ;restore non ascii into R0
			
			BR IF_VALID_NUMBER_OUTCOME
			
		
		END_IF_INVALID_NUMBER_CONDITION
		
		
		
	;outcomes
		
		
		
		IF_MINUS_OUTCOME
			STR R0, R3, #0
			ADD R3, R3, #1 ;increments address in preperation for digits
			ADD R6,R6, #1 ;indicates that input number is negative
			ST R6, BACKUP_R6 ;stores sign bit 
			
			BR END_IF_ENTER_OUTCOME
	END_IF_MINUS_OUTCOME
		
			
		
		IF_PLUS_OUTCOME
			STR R0, R3, #0
			ADD R3, R3, #1
			
			BR END_IF_ENTER_OUTCOME
	END_IF_PLUS_OUTCOME
		
			
		IF_INVALID_NUMBER_OUTCOME
			LD R0, NEWLINE_CHAR
			OUT
			
			LD R1, errorMessagePtr
			LD R2, DEC_21
		;prints error message
			WHILE_ERROR_MESSAGE_OUTPUT
				LDR R0, R1, #0
				OUT
				
				ADD R1, R1, #1
				ADD R2, R2, #-1
				
				BRp WHILE_ERROR_MESSAGE_OUTPUT
			END_WHILE_ERROR_MESSAGE_OUTPUT
			
			BR CHECK_FIRST_CHARACTER ;resets program as instructed
	END_IF_INVALID_NUMBER_OUTCOME
		
		
		IF_VALID_NUMBER_OUTCOME
			STR R0, R3, #0
			ADD R4,R4, #-1
			ADD R3, R3, #1
			ADD R5, R0, #0
			BR END_IF_ENTER_OUTCOME
	END_IF_VALID_NUMBER_OUTCOME
		
		
		IF_ENTER_OUTCOME
			STR R0, R3, #0
			HALT
	END_IF_ENTER_OUTCOME


	END_CHECK_FIRST_CHARACTER
	
	
; Now get remaining digits from user in a loop (max 5), testing each to see if it is a digit, and build up number in accumulator
	WHILE_CHECK_REMAINING_CHARS
		GETC
	;	OUT
		
		LD R1, NEWLINE_ASCII
		ADD R2, R1, R0
		BRnp CHARACTER_VALIDATION
		BRz IF_ENTER_PRESSED
		
		IF_ENTER_PRESSED ;should either end program or restart program
			LD R1, DEC_NEGATIVE_5
			ADD R2, R1, R4
			BRz IF_DIGIT_COUNTER_5
			
			IF_DIGIT_COUNTER_NOT_5 ;user presses enter and theres at least one digit
				BR END_WHILE_CHECK_REMAINING_CHARS 
			END_IF_DIGIT_COUNTER_NOT_5
			
			
			IF_DIGIT_COUNTER_5
				BR WHILE_ERROR_MESSAGE_OUTPUT
			END_IF_DIGIT_COUNTER_5
		
		
		END_IF_ENTER_PRESSED
		
		
	CHARACTER_VALIDATION
		OUT
		LD R1, ASCII_OFFSET
		ADD R0, R0, R1
		
		BRn IF_INVALID_NUMBER_OUTCOME ;if char is below ascii 0 error
		;implicit if else
		
		LD R1, DEC_NEGATIVE_10
		ADD R2, R1, R0
		BRzp IF_INVALID_NUMBER_OUTCOME ;if char is greater than ascii 10
		;implicit else
		
		
	END_CHARACTER_VALIDATION
	
	LD R1, DEC_9
	ADD R2, R5, #0
	WHILE_MULTIPLY_BY_10
		ADD R5, R5, R2
		
		ADD R1, R1, #-1
		
		BRp WHILE_MULTIPLY_BY_10 
		ADD R5, R0, R5
	END_WHILE_MULTIPLY_BY_10
	
	
	
	
		STR R0, R3, #0
		ADD R3, R3, #1
	
		ADD R4,R4, #-1
		BRp WHILE_CHECK_REMAINING_CHARS
	END_WHILE_CHECK_REMAINING_CHARS				
	
	CHECK_2s_COMPLEMENT
		LD R1, DEC_NEGATIVE_1
		ADD R2,R6, R1
		BRnp END_CHECK_2s_COMPLEMENT
		;implicit else
		
		NOT R5,R5
		ADD R5, R5, #1
	
	END_CHECK_2s_COMPLEMENT				
					
					
				LD R0, NEWLINE_CHAR
				OUT	
					
					; remember to end with a newline!
					
					HALT

;---------------	
; Program Data
;---------------
NEWLINE_ASCII .FILL #-10
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
introPromptPtr		.FILL xB000
errorMessagePtr		.FILL xB200
digitArrayPtr		.FILL x4000
BACKUP_R6 .BLKW #1


;------------
; Remote data
;------------

					.ORIG x4000
					.BLKW		#6

					.ORIG xB000			; intro prompt
					.STRINGZ	"Input a positive or negative decimal number (max 5 digits), followed by ENTER\n"
					
					
					.ORIG xB200			; error message
					.STRINGZ	"ERROR: invalid input\n"

;---------------
; END of PROGRAM
;---------------
					.END

;-------------------
; PURPOSE of PROGRAM
;-------------------
; Convert a sequence of up to 5 user-entered ascii numeric digits into a 16-bit two's complement binary representation of the number.
; if the input sequence is less than 5 digits, it will be user-terminated with a newline (ENTER).
; Otherwise, the program will emit its own newline after 5 input digits.
; The program must end with a *single* newline, entered either by the user (< 5 digits), or by the program (5 digits)
; Input validation is performed on the individual characters as they are input, but not on the magnitude of the number.
