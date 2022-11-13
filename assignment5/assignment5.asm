

.ORIG x3000			; Program begins here
;-------------
;Instructions
;-------------
;-------------------------------
;INSERT CODE STARTING FROM HERE
;--------------------------------
	PROGRAM_START

	LD R6, SUB_MENU_PTR
	JSrr R6
	
	LD R0, NEWLINE_MAIN
	OUT
	
;In R1, the instruction number that 
;the user input should now be present

	ADD R4, R1, #0
	
	LD R3, NEG_7_MAIN
	ADD R5, R3, R4
	BRz USER_7
	
	LD R3, NEG_6_MAIN
	ADD R5, R3, R4
	BRz USER_6
	
	LD R3, NEG_5_MAIN
	ADD R5, R3, R4
	BRz USER_5
	
	LD R3, NEG_4_MAIN
	ADD R5, R3, R4
	BRz USER_4
	
	LD R3, NEG_3_MAIN
	ADD R5, R3, R4
	BRz USER_3
	
	LD R3, NEG_2_MAIN
	ADD R5, R3, R4
	BRz USER_2
	
	LD R3, NEG_1_MAIN
	ADD R5, R3, R4
	BRz USER_1
	
	USER_7
		LEA R0, goodbye
		PUTS
		HALT	
	END_USER_7
	
	;------------
	
	USER_6
		LD R6, SUB_FIRST_FREE_PTR
		JSrr R6
		
		LD R2, MAIN_BUSYNESS_ADDRESS
		LDR R3, R2, #0
		
		NOT R3, R3
		BRzp firstfree1output
		
		ADD R1, R1, #0
		BRz NO_MACHINES_FREE_CASE_FIRST_FREE
		
		firstfree1output
		
		LD R2, firstfree1_ptr
		
		While_first_free1_output
			LDR R0, R2, #0
			BRz END_While_first_free1_output
			
			OUT
			ADD R2, R2, #1
			BR While_first_free1_output
		END_While_first_free1_output
		
		LD R6, SUB_PRINT_NUM_PTR
		JSrr R6
		
		LD R0, NEWLINE_MAIN
		OUT
		
		BR END_While_first_free2_output
		
		NO_MACHINES_FREE_CASE_FIRST_FREE
		LD R2, firstfree2_ptr
		
		While_first_free2_output
			LDR R0, R2, #0
			BRz END_While_first_free2_output
			
			OUT
			ADD R2, R2, #1
			BR While_first_free2_output
		END_While_first_free2_output
		
			
		
		;LEA R0, firstfree2
		;PUTS
		
		BR PROGRAM_START
	END_USER_6
	
	;------------
	
	USER_5
		LD R6, SUB_GET_MACHINE_NUM_PTR
		JSrr R6 ;returns R1 which is the register holding which server to query
		
		ADD R3, R1, #0
	
		LD R6, SUB_MACHINE_STATUS_PTR
		JSrr R6
		
		;At this point in R2 should be 1 or 0
		;If one the status of R2 is free
		;If 0 the status is busy
		
		ADD R2, R2, #0
		
		BRz BUSY_MACHINE_STATUS
		
		FREE_MACHINE_STATUS
			LEA R0, status1
			PUTS
			
			ADD R1, R3, #0
			
			LD R6, SUB_PRINT_NUM_PTR
			JSrr R6
			
			LEA R0, status3
			PUTS
			BR END_BUSY_MACHINE_STATUS
		END_FREE_MACHINE_STATUS
		
		BUSY_MACHINE_STATUS
			LEA R0, status1
			PUTS
			
			ADD R1, R3, #0
			LD R6, SUB_PRINT_NUM_PTR
			JSrr R6
			
			LEA R0, status2
			PUTS
		END_BUSY_MACHINE_STATUS
		
		BR PROGRAM_START
	END_USER_5
	
	;------------

	USER_4
		LD R6, SUB_NUM_FREE_MACHINES_PTR
		JSrr R6
		
		LEA R0, freemachine1
		PUTS
		
		LD R6, SUB_PRINT_NUM_PTR
		JSrr R6
		
		LEA R0, freemachine2
		PUTS
		
		BR PROGRAM_START
	END_USER_4
	
	;------------
	
	USER_3
		LD R6, SUB_NUM_BUSY_MACHINES_PTR
		JSrr R6
		
		;in R1, the number of Busy bits should be inputted
		
		LEA R0, busymachine1
		PUTS
		
		LD R6, SUB_PRINT_NUM_PTR
		JSrr R6
		
		LEA R0, busymachine2
		PUTS
		
		BR PROGRAM_START
	
	END_USER_3
	
	;------------
	
	USER_2
		LD R6, SUB_ALL_MACHINES_FREE_PTR
		JSrr R6
		
		;R2 should be populated with 1 if all nodes are free
		;R2 should have 0 if at least one node is busy
		
		ADD R2, R2, #0
		BRz MAIN_NOT_ALL_FREE
		
		;implicit else
		MAIN_ALL_FREE
			LEA R0, allfree
			PUTS
			
			BR END_MAIN_NOT_ALL_FREE
		END_MAIN_ALL_FREE
		
		MAIN_NOT_ALL_FREE
			LEA R0, allnotfree
			PUTS
			
		END_MAIN_NOT_ALL_FREE
		
		BR PROGRAM_START
	END_USER_2
	
	;------------
	
	USER_1
		LD R6, SUB_ALL_MACHINES_BUSY_PTR
		JSrr R6
		
		;in r2, 1 should be inputted if all busy
		;0 should be inputted if at least 1 is free
		
		ADD R2, R2, #0 ;make r2 the last used register
		BRz END_MAIN_ALL_BUSY
		
		MAIN_ALL_BUSY
			LEA R0, allbusy
			PUTS
			
			BR END_MAIN_ALL_NOT_BUSY
		END_MAIN_ALL_BUSY
			
		MAIN_ALL_NOT_BUSY
			LEA R0, allnotbusy
			PUTS
		
		END_MAIN_ALL_NOT_BUSY
			
		BR PROGRAM_START
	END_USER_1
	
	;------------
HALT
;---------------	
;Data
;---------------
;Subroutine pointers
SUB_MENU_PTR .FILL x3200
SUB_ALL_MACHINES_BUSY_PTR .FILL x3400
SUB_ALL_MACHINES_FREE_PTR .FILL x3600
SUB_NUM_BUSY_MACHINES_PTR .FILL x3800
SUB_NUM_FREE_MACHINES_PTR .FILL x4000
SUB_MACHINE_STATUS_PTR .FILL x4200
SUB_FIRST_FREE_PTR .FILL x4400
SUB_GET_MACHINE_NUM_PTR .FILL x4600
SUB_PRINT_NUM_PTR .FILL x4800
MAIN_BUSYNESS_ADDRESS			.FILL			xB400

firstfree1_ptr .FILL x5400
firstfree2_ptr .FILL x5600

NEWLINE_MAIN .FILL '\n'
ASCII_OFFSET_MAIN .FILL #48

NEG_7_MAIN .FILL #-7
NEG_6_MAIN .FILL #-6
NEG_5_MAIN .FILL #-5
NEG_4_MAIN .FILL #-4
NEG_3_MAIN .FILL #-3
NEG_2_MAIN .FILL #-2
NEG_1_MAIN .FILL #-1


;Other data 
newline 		.fill '\n'

; Strings for reports from menu subroutines:
goodbye         .stringz "Goodbye!\n"
allbusy         .stringz "All machines are busy\n"
allnotbusy      .stringz "Not all machines are busy\n"
allfree         .stringz "All machines are free\n"
allnotfree		.stringz "Not all machines are free\n"
busymachine1    .stringz "There are "
busymachine2    .stringz " busy machines\n"
freemachine1    .stringz "There are "
freemachine2    .stringz " free machines\n"
status1         .stringz "Machine "
status2		    .stringz " is busy\n"
status3		    .stringz " is free\n"

.orig x5400
firstfree1      .stringz "The first available machine is number "
.orig x5600
firstfree2      .stringz "No machines are free\n"


;-----------------------------------------------------------------------------------------------------------------
; Subroutine: MENU
; Inputs: None
; Postcondition: The subroutine has printed out a menu with numerical options, invited the
;                user to select an option, and returned the selected option.
; Return Value (R1): The option selected:  #1, #2, #3, #4, #5, #6 or #7 (as a number, not a character)
;                    no other return value is possible
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine MENU
;--------------------------------
.orig x3200

;HINT back up 
	ST R0, BACKUP_R0_3200
	ST R2, BACKUP_R2_3200
	ST R3, BACKUP_R3_3200
	ST R4, BACKUP_R4_3200
	ST R5, BACKUP_R5_3200
	ST R7, BACKUP_R7_3200
;Menu Body
	PRINT_MENU
		LD R2, Menu_string_addr
		
		OUTPUT_MENU_MESSAGE
			LDR R0, R2, #0
			Brz END_OUTPUT_MENU_MESSAGE
			
			OUT
			ADD R2, R2, #1
			BR OUTPUT_MENU_MESSAGE
		
		END_OUTPUT_MENU_MESSAGE
		
		GET_USER_COMMAND
			GETC
			OUT
			
			
			LD R2, ASCII_TO_DECIMAL_OFFSET
			LD R4, NEG_7
			ADD R0, R0, R2
			ADD R3, R0, #0 ;makes a copy of R0, the user input
			
			BRnz INVALID_INPUT
			
			ADD R3, R3, R4
			BRnz END_INVALID_INPUT ;if positive enters invalid input
			
			INVALID_INPUT
				LD R0, NEWLINE_MENU
				OUT
				
				LEA R0, Error_msg_1
				PUTS
				
				BR PRINT_MENU
			END_INVALID_INPUT
			;implicit else
			
			ADD R1, R0, #0
	
	
;HINT Restore
	LD R0, BACKUP_R0_3200
	LD R2, BACKUP_R2_3200
	LD R3, BACKUP_R3_3200
	LD R4, BACKUP_R4_3200
	LD R5, BACKUP_R5_3200
	LD R7, BACKUP_R7_3200
	
	ret
;--------------------------------
;Data for subroutine MENU
;--------------------------------
Error_msg_1	      .STRINGZ "INVALID INPUT\n"
TEST_MESSAGE_3200 .STRINGZ "THIS is the menu\n"
ASCII_TO_DECIMAL_OFFSET .FILL #-48
NEG_7 .FILL #-7
NEWLINE_MENU .FILL '\n'

BACKUP_R0_3200 .BLKW #1
BACKUP_R2_3200 .BLKW #1
BACKUP_R3_3200 .BLKW #1
BACKUP_R4_3200 .BLKW #1
BACKUP_R5_3200 .BLKW #1
BACKUP_R7_3200 .BLKW #1

Menu_string_addr  .FILL x5000


;END MENU SUBROUTINE


;-----------------------------------------------------------------------------------------------------------------
; Subroutine: ALL_MACHINES_BUSY (#1)
; Inputs: None
; Postcondition: The subroutine has returned a value indicating whether all machines are busy
; Return value (R2): 1 if all machines are busy, 0 otherwise
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine ALL_MACHINES_BUSY
;--------------------------------

.ORIG x3400

;HINT back up 
	ST R0, BACKUP_R0_3400
	ST R1, BACKUP_R1_3400
	ST R3, BACKUP_R3_3400
	ST R4, BACKUP_R4_3400
	ST R5, BACKUP_R5_3400
	ST R6, BACKUP_R6_3400
	ST R7, BACKUP_R7_3400

;Body
	LD R1, BUSYNESS_ADDR_ALL_MACHINES_BUSY
	AND R2, R2, x0
	LDR R3, R1, #0
	LD R4, BIT_MASK_ALL_1s
	AND R5, R3, R4
	
	BRnp END_ALL_BUSY
	;implicit else
	
	ALL_BUSY
		ADD R2, R2, #1
		BR END_NOT_ALL_BUSY
	END_ALL_BUSY
	
	;--------------
	
	NOT_ALL_BUSY
		AND R2, R2, x0
	END_NOT_ALL_BUSY

;HINT Restore
	LD R0, BACKUP_R0_3400
	LD R1, BACKUP_R1_3400
	LD R3, BACKUP_R3_3400
	LD R4, BACKUP_R4_3400
	LD R5, BACKUP_R5_3400
	LD R6, BACKUP_R6_3400
	LD R7, BACKUP_R7_3400
	
	ret
;--------------------------------
;Data for subroutine ALL_MACHINES_BUSY
;--------------------------------
BUSYNESS_ADDR_ALL_MACHINES_BUSY .Fill xB400
TEST_MESSAGE_3400 .STRINGZ "Subroutine ALL MACHINES BUSY \n"
BIT_MASK_ALL_1s .FILL xFFFF

BACKUP_R0_3400 .BLKW #1
BACKUP_R1_3400 .BLKW #1
BACKUP_R3_3400 .BLKW #1
BACKUP_R4_3400 .BLKW #1
BACKUP_R5_3400 .BLKW #1
BACKUP_R6_3400 .BLKW #1
BACKUP_R7_3400 .BLKW #1



;end ALL_MACHINES_BUSY

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: ALL_MACHINES_FREE (#2)
; Inputs: None
; Postcondition: The subroutine has returned a value indicating whether all machines are free
; Return value (R2): 1 if all machines are free, 0 otherwise
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine ALL_MACHINES_FREE
;--------------------------------

.ORIG x3600

;HINT back up 
	ST R0, BACKUP_R0_3600
	ST R1, BACKUP_R1_3600
	ST R3, BACKUP_R3_3600
	ST R4, BACKUP_R4_3600
	ST R5, BACKUP_R5_3600
	ST R6, BACKUP_R6_3600
	ST R7, BACKUP_R7_3600 
	
	AND R2,R2, x0
	LD R1, BUSYNESS_ADDR_ALL_MACHINES_FREE
	LDR R3, R1, #0
	
	NOT R3, R3
	BRnp NOT_ALL_FREE
	
	;implicit else
	ALL_FREE
		ADD R2, R2, #1
		BR END_NOT_ALL_FREE
	END_ALL_FREE
	
	
	NOT_ALL_FREE
		AND R2,R2, x0
	END_NOT_ALL_FREE 
	
	
;HINT Restore
	LD R0, BACKUP_R0_3600
	LD R1, BACKUP_R1_3600
	LD R3, BACKUP_R3_3600
	LD R4, BACKUP_R4_3600
	LD R5, BACKUP_R5_3600
	LD R6, BACKUP_R6_3600
	LD R7, BACKUP_R7_3600 
	ret
;--------------------------------
;Data for subroutine ALL_MACHINES_FREE
;--------------------------------
BUSYNESS_ADDR_ALL_MACHINES_FREE .Fill xB400
TEST_MESSAGE_3600 .STRINGZ "Subroutine ALL MACHINES FREE \n"

BACKUP_R0_3600 .BLKW #1
BACKUP_R1_3600 .BLKW #1
BACKUP_R3_3600 .BLKW #1
BACKUP_R4_3600 .BLKW #1
BACKUP_R5_3600 .BLKW #1
BACKUP_R6_3600 .BLKW #1
BACKUP_R7_3600 .BLKW #1


;END ALL MACHINES FREE SUBROUTINE


;-----------------------------------------------------------------------------------------------------------------
; Subroutine: NUM_BUSY_MACHINES (#3)
; Inputs: None
; Postcondition: The subroutine has returned the number of busy machines.
; Return Value (R1): The number of machines that are busy (0)
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine NUM_BUSY_MACHINES
;--------------------------------

.ORIG x3800

	;HINT back up 
	ST R0, BACKUP_R0_3800 
	ST R2, BACKUP_R2_3800
	ST R3, BACKUP_R3_3800
	ST R4, BACKUP_R4_3800
	ST R5, BACKUP_R5_3800
	ST R6, BACKUP_R6_3800
	ST R7, BACKUP_R7_3800
	
;body
	LD R2, BUSYNESS_ADDR_NUM_BUSY_MACHINES
	LDR R3, R2, #0
	LD R4, LEFT_SHIFT_COUNT
	AND R1, R1, x0
	
	WHILE_LOOP_NUM_BUSY
		ADD R3,R3, #0 ;makes R3 last used register
		
		BRn END_MSB_0
		
		MSB_0
			ADD R1, R1, #1
		END_MSB_0
		
		ADD R3, R3, R3
		
		ADD R4, R4, #-1
	
		BRp WHILE_LOOP_NUM_BUSY
	END_WHILE_LOOP_NUM_BUSY
	
	
	;HINT Restore
	LD R0, BACKUP_R0_3800 
	LD R2, BACKUP_R2_3800
	LD R3, BACKUP_R3_3800
	LD R4, BACKUP_R4_3800
	LD R5, BACKUP_R5_3800
	LD R6, BACKUP_R6_3800
	LD R7, BACKUP_R7_3800
	
	ret
;--------------------------------
;Data for subroutine NUM_BUSY_MACHINES
;--------------------------------
BUSYNESS_ADDR_NUM_BUSY_MACHINES .Fill xB400
LEFT_SHIFT_COUNT .FILL #16
TEST_MESSAGE_3800 .STRINGZ "Subroutine NUM BUSY MACHINES \n"

BACKUP_R0_3800 .BLKW #1
BACKUP_R2_3800 .BLKW #1
BACKUP_R3_3800 .BLKW #1
BACKUP_R4_3800 .BLKW #1
BACKUP_R5_3800 .BLKW #1
BACKUP_R6_3800 .BLKW #1
BACKUP_R7_3800 .BLKW #1

;END NUM_BUSY_MACHINES SUBROUTINE


;-----------------------------------------------------------------------------------------------------------------
; Subroutine: NUM_FREE_MACHINES (#4)
; Inputs: None
; Postcondition: The subroutine has returned the number of free machines
; Return Value (R1): The number of machines that are free (1)
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine NUM_FREE_MACHINES
;--------------------------------

.ORIG x4000

	;HINT back up 
	ST R0, BACKUP_R0_4000 
	ST R2, BACKUP_R2_4000
	ST R3, BACKUP_R3_4000
	ST R4, BACKUP_R4_4000
	ST R5, BACKUP_R5_4000
	ST R6, BACKUP_R6_4000
	ST R7, BACKUP_R7_4000 
	
;body
	LD R2, BUSYNESS_ADDR_NUM_FREE_MACHINES
	LDR R3, R2, #0
	LD R4, LEFT_SHIFT_COUNT_FREE_MACHINES
	AND R1, R1, x0
	
	WHILE_LOOP_NUM_FREE
		ADD R3,R3, #0 ;makes R3 last used register
		
		BRzp END_MSB_1
		
		MSB_1
			ADD R1, R1, #1
		END_MSB_1
		
		ADD R3, R3, R3
		
		ADD R4, R4, #-1
	
		BRp WHILE_LOOP_NUM_FREE
	END_WHILE_LOOP_NUM_FREE
	
	
	
	;HINT Restore
	LD R0, BACKUP_R0_4000 
	LD R2, BACKUP_R2_4000
	LD R3, BACKUP_R3_4000
	LD R4, BACKUP_R4_4000
	LD R5, BACKUP_R5_4000
	LD R6, BACKUP_R6_4000
	LD R7, BACKUP_R7_4000 
	
	ret
;--------------------------------
;Data for subroutine NUM_FREE_MACHINES 
;--------------------------------
BUSYNESS_ADDR_NUM_FREE_MACHINES .Fill xB400
LEFT_SHIFT_COUNT_FREE_MACHINES .FILL #16
TEST_MESSAGE_4000 .STRINGZ "Subroutine NUM FREE MACHINES \n"

BACKUP_R0_4000 .BLKW #1
BACKUP_R2_4000 .BLKW #1
BACKUP_R3_4000 .BLKW #1
BACKUP_R4_4000 .BLKW #1
BACKUP_R5_4000 .BLKW #1
BACKUP_R6_4000 .BLKW #1
BACKUP_R7_4000 .BLKW #1

;END NUM FREE MACHINES SUBROUTINE


;-----------------------------------------------------------------------------------------------------------------
; Subroutine: MACHINE_STATUS (#5)
; Input (R1): Which machine to check, guaranteed in range {0,15}
; Postcondition: The subroutine has returned a value indicating whether
;                the selected machine (R1) is busy or not.
; Return Value (R2): 0 if machine (R1) is busy, 1 if it is free
;              (R1) unchanged
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine MACHINE_STATUS
;--------------------------------

.ORIG  x4200

;HINT back up 

	ST R0, BACKUP_R0_4200
	ST R3, BACKUP_R3_4200
	ST R4, BACKUP_R4_4200
	ST R5, BACKUP_R5_4200
	ST R6, BACKUP_R6_4200
	ST R7, BACKUP_R7_4200

;body
	
	;In R1 should be the user input number of the machine they want
	; to query
	LD R6, STARTING_BIT_MASK
	AND R4, R4, x0
	
	ADD R3, R1, #0
	BRz END_LEFT_SHIFT_MACHINE_NUM_LOOP
	
	CALCULATING_BIT_MASK
	
		LEFT_SHIFT_MACHINE_NUM_LOOP
			
			ADD R6, R6, R6
			
			ADD R3, R3, #-1
			BRp LEFT_SHIFT_MACHINE_NUM_LOOP
		END_LEFT_SHIFT_MACHINE_NUM_LOOP
		
		;R6 should be the bit mask
		LD R3, BUSYNESS_ADDR_MACHINE_STATUS 
		LDR R7, R3, #0
		AND R5, R6, R7
		
		BRz IS_BUSY
		
		;implicit else
		AND R2, R2, x0
		ADD R2, R2, #1
		BR END_IS_BUSY
		
		IS_BUSY
			AND R2, R2, x0
		END_IS_BUSY
		
;HINT Restore
	LD R0, BACKUP_R0_4200
	LD R3, BACKUP_R3_4200
	LD R4, BACKUP_R4_4200
	LD R5, BACKUP_R5_4200
	LD R6, BACKUP_R6_4200
	LD R7, BACKUP_R7_4200
		
		ret
;--------------------------------
;Data for subroutine MACHINE_STATUS
;--------------------------------
BUSYNESS_ADDR_MACHINE_STATUS.Fill xB400
TEST_MESSAGE_4200 .STRINGZ "Subroutine MACHINE STATUS \n"
SUB_GET_MACHINE_PTR .FILL x4600
STARTING_BIT_MASK .FILL #1
MULTIPLIER_BIT_MASK .FILL #2

	 BACKUP_R0_4200 .BLKW #1
	 BACKUP_R3_4200	.BLKW #1
	 BACKUP_R4_4200 .BLKW #1
	 BACKUP_R5_4200 .BLKW #1
	 BACKUP_R6_4200 .BLKW #1
	 BACKUP_R7_4200 .BLKW #1



;END MACHINE STATUS SUBROUTINE


;-----------------------------------------------------------------------------------------------------------------
; Subroutine: FIRST_FREE (#6)
; Inputs: None
; Postcondition: The subroutine has returned a value indicating the lowest numbered free machine
; Return Value (R1): the number of the free machine
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine FIRST_FREE
;--------------------------------

.ORIG x4400

;HINT back up 
	ST R0, BACKUP_R0_4400 
	ST R2, BACKUP_R2_4400 
	ST R3, BACKUP_R3_4400
	ST R4, BACKUP_R4_4400 
	ST R5, BACKUP_R5_4400 
	ST R6, BACKUP_R6_4400 
	ST R7, BACKUP_R7_4400 
	
;body
	LD R2, BUSYNESS_ADDR_FIRST_FREE
	LDR R4, R2, #0
	
	NOT R4,R4
	BRz RETURN_0
	BR END_RETURN_0
	
	RETURN_0
		AND R1,R1,x0
		BR END_ATLEAST_ONE_MACHINE_FREE
	END_RETURN_0
	
	LDR R4,R2, #0
	
	LD R2, NUMBER_OF_BITS ;used as a loop control will count down
	AND R3, R3, x0 ;will be used to count upwards towards 16
	ADD R3, R3, #1
	AND R1, R1, x0 ; will hold how many bits going rightwards the last 1 is located at

	WHILE_LEFT_SHIFT
		ADD R4, R4, #0
		BRn INCREMENT_POS
		
		;implicit else
		BR END_INCREMENT_POS
		
		INCREMENT_POS
			ADD R1, R3, #0
		END_INCREMENT_POS
		
		ADD R4,R4,R4
		ADD R3, R3, #1
		
		ADD R2, R2, #-1
		BRp WHILE_LEFT_SHIFT
	END_WHILE_LEFT_SHIFT
	
	ADD R1, R1, #0
	BRz END_ATLEAST_ONE_MACHINE_FREE
	
	ATLEAST_ONE_MACHINE_FREE
		NOT R1,R1
		ADD R1, R1, #1
		LD R2, NUMBER_OF_BITS
		ADD R1, R2, R1
		;ADD R1, R1, #-1
	END_ATLEAST_ONE_MACHINE_FREE
	
;HINT Restore
	LD R0, BACKUP_R0_4400 
	LD R2, BACKUP_R2_4400 
	LD R3, BACKUP_R3_4400
	LD R4, BACKUP_R4_4400 
	LD R5, BACKUP_R5_4400 
	LD R6, BACKUP_R6_4400 
	LD R7, BACKUP_R7_4400 
	
	ret
;--------------------------------
;Data for subroutine FIRST_FREE
;--------------------------------
BUSYNESS_ADDR_FIRST_FREE .Fill xB400
TEST_MESSAGE_4400 .STRINGZ "Subroutine FIRST FREE \n"
NUMBER_OF_BITS .FILL #16


	BACKUP_R0_4400 .BLKW #1
	BACKUP_R2_4400 .BLKW #1
	BACKUP_R3_4400 .BLKW #1
	BACKUP_R4_4400 .BLKW #1
	BACKUP_R5_4400 .BLKW #1
	BACKUP_R6_4400 .BLKW #1
	BACKUP_R7_4400 .BLKW #1


;END FIRST FREE SUBROUTINE


;-----------------------------------------------------------------------------------------------------------------
; Subroutine: GET_MACHINE_NUM
; Inputs: None
; Postcondition: The number entered by the user at the keyboard has been converted into binary,
;                and stored in R1. The number has been validated to be in the range {0,15}
; Return Value (R1): The binary equivalent of the numeric keyboard entry
; NOTE: You can use your code from assignment 4 for this subroutine, changing the prompt, 
;       and with the addition of validation to restrict acceptable values to the range {0,15}
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine 
;--------------------------------
.ORIG x4600
	
	ST R0, BACKUP_R0_4600 
	ST R2, BACKUP_R2_4600 
	ST R3, BACKUP_R3_4600
	ST R4, BACKUP_R4_4600 
	ST R5, BACKUP_R5_4600 
	ST R6, BACKUP_R6_4600 
	ST R7, BACKUP_R7_4600 
	
	CHECK_FIRST_CHARACTER
		
		LEA R0, prompt  ;for intro prompt text
		PUTS
		
		LD R4, DEC_5 ;will count how many chars have been input
		AND R5,R5, x0 ;this is our accumulator
		
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
			
			BRz IF_INVALID_NUMBER_OUTCOME
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
		
		
		
	;outcomes for first char
		
		
			
		
		IF_PLUS_OUTCOME
			
			BR END_IF_ENTER_OUTCOME
	END_IF_PLUS_OUTCOME
		
			
		IF_INVALID_NUMBER_OUTCOME
			WHILE_ERROR_MESSAGE_OUTPUT
			LD R0, NEWLINE_CHAR
			OUT
				
		;prints error message
			LEA R0, Error_msg_2
			PUTS
			
			BR CHECK_FIRST_CHARACTER ;resets program as instructed
	END_IF_INVALID_NUMBER_OUTCOME
		
		
		IF_VALID_NUMBER_OUTCOME
			ADD R4,R4, #-1
			ADD R5, R0, #0
			BR END_IF_ENTER_OUTCOME
	END_IF_VALID_NUMBER_OUTCOME
		
		
		IF_ENTER_OUTCOME
			BR IF_INVALID_NUMBER_OUTCOME
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
	
	
	
	
	
	
		ADD R4,R4, #-1
		BRp WHILE_CHECK_REMAINING_CHARS
	END_WHILE_CHECK_REMAINING_CHARS				
	
	ADD R1, R5, #0	
	BRn IF_INVALID_NUMBER_OUTCOME
	
	ADD R2, R1, #-15
	BRp IF_INVALID_NUMBER_OUTCOME
							
				LD R0, NEWLINE_CHAR
				OUT	
					
	LD R0, BACKUP_R0_4600 
	LD R2, BACKUP_R2_4600 
	LD R3, BACKUP_R3_4600
	LD R4, BACKUP_R4_4600 
	LD R5, BACKUP_R5_4600 
	LD R6, BACKUP_R6_4600 
	LD R7, BACKUP_R7_4600 


	ret
;--------------------------------
;Data for subroutine Get input
;--------------------------------
prompt .STRINGZ "Enter which machine you want the status of (0 - 15), followed by ENTER: "
Error_msg_2 .STRINGZ "ERROR INVALID INPUT\n"
TEST_MESSAGE_4600 .STRINGZ "Subroutine GET MACHINE NUMBER \n"
USER_TERMINATION_ENTER .FILL #-10

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

BACKUP_R0_4600 .BLkW #1
BACKUP_R2_4600 .BLkW #1
BACKUP_R3_4600 .BLkW #1
BACKUP_R4_4600 .BLkW #1
BACKUP_R5_4600 .BLkW #1
BACKUP_R6_4600 .BLkW #1
BACKUP_R7_4600 .BLKW #1
	
	
	;END GET_MACHINE_NUM
	
	
;-----------------------------------------------------------------------------------------------------------------
; Subroutine: PRINT_NUM
; Inputs: R1, which is guaranteed to be in range {0,16}
; Postcondition: The subroutine has output the number in R1 as a decimal ascii string, 
;                WITHOUT leading 0's, a leading sign, or a trailing newline.
; Return Value: None; the value in R1 is unchanged
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine 
;--------------------------------
.ORIG x4800
	ST R0, BACKUP_R0_4800 
	ST R2, BACKUP_R2_4800
	ST R3, BACKUP_R3_4800
	ST R4, BACKUP_R4_4800
	ST R5, BACKUP_R5_4800
	ST R6, BACKUP_R6_4800
	ST R7, BACKUP_R7_4800
;=============

ST R1, BACKUP_ORIGINAL_INPUT
		SET10
	
	LD R2, NEG_10
	AND R5, R5, x0
	
	ADD R4,R1,R2
	BRn SET1
	
	LOOP_10
		ADD R4,R1,R2
		BRn END_LOOP_10
		
		ADD R1,R1,R2
		ADD R5,R5, #1
		BR LOOP_10
	
	END_LOOP_10

	LD R2, ASCII_OFFSET_PRINT_NUM
	ADD R0, R5, R2
	OUT
	
	SET1
	
	LD R2, NEG_1
	AND R5, R5, x0
	
	LOOP_1
		ADD R4, R1, R2
		BRn END_LOOP_1
		
		ADD R1,R1,R2
		ADD R5,R5, #1
		BR LOOP_1
	
	END_LOOP_1
	
	LD R2, ASCII_OFFSET_PRINT_NUM
	ADD R0, R5, R2
	OUT
	
	LD R1, BACKUP_ORIGINAL_INPUT
	;==========

	LD R0, BACKUP_R0_4800 
	LD R2, BACKUP_R2_4800
	LD R3, BACKUP_R3_4800
	LD R4, BACKUP_R4_4800
	LD R5, BACKUP_R5_4800
	LD R6, BACKUP_R6_4800
	LD R7, BACKUP_R7_4800
	
	ret
;--------------------------------
;Data for subroutine print number
;--------------------------------
	
	NEG_10000 .FILL #-10000
	NEG_1000 .FILL #-1000
	NEG_100 .FILL #-100
	NEG_10 .FILL #-10
	NEG_1 .FILL #-1
	ASCII_OFFSET_PRINT_NUM .FILL #48
	ASCII_MINUS .FILL #45
	
	BACKUP_ORIGINAL_INPUT .BLKW #1
	
	BACKUP_R0_4800 .BLKW #1 
	BACKUP_R2_4800 .BLKW #1
	BACKUP_R3_4800 .BLKW #1
	BACKUP_R4_4800 .BLKW #1
	BACKUP_R5_4800 .BLKW #1
	BACKUP_R6_4800 .BLKW #1
	BACKUP_R7_4800 .BLKW #1
	
	TEST_MESSAGE_4800 .STRINGZ "Subroutine PRINT_NUM \n"

;------------------------------------------
.ORIG x5000
MENUSTRING .STRINGZ "**********************\n* The Busyness Server *\n**********************\n1. Check to see whether all machines are busy\n2. Check to see whether all machines are free\n3. Report the number of busy machines\n4. Report the number of free machines\n5. Report the status of machine n\n6. Report the number of the first available machine\n7. Quit\n"

.ORIG xB400			; Remote data
BUSYNESS .FILL xABCD	; <----!!!BUSYNESS VECTOR!!! Change this value to test your program.


;END PRINT_NUM SUBROUTINE

;---------------	
;END of PROGRAM
;---------------	
.END
