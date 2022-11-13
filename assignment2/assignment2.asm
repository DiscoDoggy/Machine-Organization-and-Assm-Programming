
.ORIG x3000			; Program begins here
;-------------
;Instructions
;-------------

;----------------------------------------------
;output prompt
;----------------------------------------------	
LEA R0, intro			; get starting address of prompt string
PUTS		    		; Invokes BIOS routine to output string
;-------------------------------
;INSERT YOUR CODE here
;--------------------------------
;LD R0, newline
;OUT ;prints newline

GETC ;gets character from user
OUT ;echos character
AND R1,R1, x0 ;zeros out number to make usre we arent adding to a garbage number
ADD R1, R1, R0 ;stores character in R1 (first number)

LD R0, newline ;newline
OUT ;prints new line

GETC ; gets second character from user
OUT ;Echos second character from user
AND R2,R2, x0 ;Zeros out register to make sure we arent adding to a garbage number
ADD R2, R2, R0 ;stores second character from user

LD R0, newline ;newline
OUT ;prints newline

;outputs the equation
AND R0,R0, x0
ADD R0, R0, R1
OUT
LD R0, spaceChar
OUT
LD R0, minus
OUT
LD R0, spaceChar
OUT
AND R0, R0, x0
ADD R0, R0, R2
OUT
LD R0, spaceChar
OUT 
LD R0, equals
OUT
LD R0, spaceChar
OUT

;conversion from ASCII to Binary
LD R6, conversionFactor
NOT R5, R6 ;stores the inverted conversion factor
ADD R5, R5, #1 ;inverts the conversion factor completely now with the plus 1
ADD R1, R1, R5 ;subtracts the conversion factor from R1 to create a binary digit
ADD R2, R2, R5; substracts the conversion factor from R2 to create a binary digit 

;invert second charcter/makes it negative
NOT R2, R2
ADD R2, R2, #1

;branching result outputs
ADD R3, R1, R2 ; does the subtraction

BRn IF_NEGATIVE

BRzp IF_POSITIVE_ZERO

IF_NEGATIVE
	LD R0, minus
	OUT
	NOT R3,R3
	ADD R3,R3, #1
	ADD R3,R3, R6
	AND R0,R0, x0
	ADD R0, R0, R3
	OUT
	LD R0, newline
	OUT
	BR END_IF_POSITIVE_ZERO
END_IF_NEGATIVE


IF_POSITIVE_ZERO
	;NOT R3,R3
	;ADD R3,R3, #1
	ADD R3,R3, R6
	AND R0,R0, x0
	ADD R0, R0, R3
	OUT
	LD R0, newline
	OUT
END_IF_POSITIVE_ZERO




HALT				; Stop execution of program
;------	
;Data
;------
; String to prompt user. Note: already includes terminating newline!
intro 	.STRINGZ	"ENTER two numbers (i.e '0'....'9')\n" 		; prompt string - use with LEA, followed by PUTS.
newline .FILL '\n'	; newline character - use with LD followed by OUT
minus .FILL '-'
equals .FILL '='
spaceChar .FILL ' '
conversionFactor .FILL x30

;---------------	
;END of PROGRAM
;---------------	
.END

