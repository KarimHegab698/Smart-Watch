	AREA MY_CALCULATOR_DATA, DATA, READONLY
	
BLACK	EQU   	0x0000
BLUE 	EQU  	0x001F
RED  	EQU  	0xF800
RED2   	EQU 	0x4000
GREEN 	EQU  	0x07E0  
CYAN  	EQU  	0x07FF
MAGENTA EQU 	0xF81F
YELLOW	EQU  	0xFFE0
WHITE 	EQU  	0xFFFF 
GREEN2 	EQU 	0x2FA4
	
	IMPORT CharA
	IMPORT CharB
	IMPORT CharC
	IMPORT CharD
	IMPORT CharE
	IMPORT CharF
	IMPORT CharH
	IMPORT CharI
	IMPORT CharG
	IMPORT CharL
	IMPORT CharM
	IMPORT CharD
	IMPORT CharF	
	IMPORT CharN
	IMPORT CharO
	IMPORT CharP
	IMPORT CharR
	IMPORT CharS
	IMPORT CharT
	IMPORT CharU
	IMPORT CharX
	IMPORT Char0
	IMPORT Char1
	IMPORT Char2
	IMPORT Char3
	IMPORT Char4
	IMPORT Char5
	IMPORT Char6
	IMPORT Char7
	IMPORT Char8
	IMPORT Char9
	IMPORT LeftArrow
	IMPORT RightArrow	

	
	AREA SNAKE_CODE, CODE, READONLY
	EXPORT Calculator
	IMPORT DRAW_RECTANGLE_FILLED
	IMPORT DRAW_NUMBERS
	IMPORT READ_BUTTONS
	IMPORT delay_1_second
	IMPORT delay_half_second

	IMPORT DRAW_ICON_OPS
	IMPORT DRAW_CHAR
	IMPORT DRAW_CHAR_I
	IMPORT DRAW_CHAR_M
	IMPORT HANDLE_RESULT
		
Calculator FUNCTION
	PUSH{R0-R12, LR}
	;	R5 = STATE
	; 	TOTAL TFT = (320,240)
	;	FOR DRAW_NUMBERS
	;	R0 = X
	;	R1 = Y
	; 	R7 = NUMBER TO BE DRAWN
START_CALCULATOR
	MOV R5, #0	; SET FIRST STATE REGISTER TO BE 0
	MOV R7, #0	; USED TO DRAW
	MOV R8, #0	; FIRST NUMBER
	MOV R9, #0	; SECOND NUMBER
	MOV R11, #0	; OPERATION
	
	BL DRAW_CHOOSE_NUMBER_INTERFACE
	BL DRAW_FIRST_TAG
;First Screen (Choose First Number)
CHOOSE_FIRST_NUMBER
	BL READ_BUTTONS
	
	
	CMP R5, #2				; MOVED RIGHT
	BNE SKIP_RIGHT_LOGIC_R8
	MOV R5, #0
	ADD R8, R8 ,#1
	CMP R8, #9
	BLE SKIP_CORRECT_R8_GREATER_THAN_9
	MOV R8, #0
SKIP_CORRECT_R8_GREATER_THAN_9
	BL DRAW_EDITED_NUMBER_1
SKIP_RIGHT_LOGIC_R8


	CMP R5, #1				; MOVED LEFT
	BNE SKIP_LEFT_LOGIC_R8
	MOV R5, #0
	SUB R8, R8 ,#1
	CMP R8, #0
	BGE SKIP_CORRECT_R8_LESS_THAN_0
	MOV R8, #9
SKIP_CORRECT_R8_LESS_THAN_0
	BL DRAW_EDITED_NUMBER_1
SKIP_LEFT_LOGIC_R8


	CMP R5, #8				; PRESSING DOWN = EXIT
	BEQ HELP_LINE_FOR_1
	
	
	CMP R5, #16    ;Check if OK was pressed confirming choice
	BEQ SWITCH_FROM_FIRST_TO_SECOND
	B CHOOSE_FIRST_NUMBER


SWITCH_FROM_FIRST_TO_SECOND
	BL DRAW_CHOOSE_NUMBER_INTERFACE
	BL DRAW_EDITED_NUMBER_2
	BL DRAW_SECOND_TAG
	MOV R5, #0
	
	
;Second Screen (Choose Second Number)
CHOOSE_SECOND_NUMBER
	BL READ_BUTTONS
	
	CMP R5, #2				; MOVED RIGHT
	BNE SKIP_RIGHT_LOGIC_R9
	MOV R5, #0
	ADD R9, R9 ,#1
	CMP R9, #9
	BLE SKIP_CORRECT_R9_GREATER_THAN_9
	MOV R9, #0
SKIP_CORRECT_R9_GREATER_THAN_9
	BL DRAW_EDITED_NUMBER_2
SKIP_RIGHT_LOGIC_R9


	CMP R5, #1				; MOVED LEFT
	BNE SKIP_LEFT_LOGIC_R9
	MOV R5, #0
	SUB R9, R9 ,#1
	CMP R9, #0
	BGE SKIP_CORRECT_R9_LESS_THAN_0
	MOV R9, #9
SKIP_CORRECT_R9_LESS_THAN_0
	BL DRAW_EDITED_NUMBER_2
SKIP_LEFT_LOGIC_R9


	CMP R5, #4     ;Check if user pressed up (go to previous screen)
	BEQ SWITCH_FROM_SECOND_TO_FIRST

	CMP R5, #8				; PRESSING DOWN = EXIT
HELP_LINE_FOR_1
	BEQ HELPER_LINE_23
	
	CMP R5, #16    ;Check if OK was pressed confirming choice
	BEQ SWITCH_FROM_SECOND_TO_OPERATION
	B CHOOSE_SECOND_NUMBER


SWITCH_FROM_SECOND_TO_FIRST
	BL DRAW_CHOOSE_NUMBER_INTERFACE
	BL DRAW_EDITED_NUMBER_1
	BL DRAW_FIRST_TAG
	MOV R5, #0
	B CHOOSE_FIRST_NUMBER

	
SWITCH_FROM_SECOND_TO_OPERATION
	BL CLEAR_NUMBER_OPERATION_AREA
	BL DRAW_CHOOSE_OPERATION_INTERFACE
	BL DRAW_OP_TAG
	BL DRAW_EDITED_OPERATION
	MOV R5, #0


;Third Screen (Choose Operation)
CHOOSE_OPERATION	
	BL READ_BUTTONS
	; + --> 0
	; - --> 1
	; * --> 2
	; / --> 3

	CMP R5, #2				; MOVED RIGHT
	BNE SKIP_RIGHT_LOGIC_R10
	MOV R5, #0
	ADD R11, R11 ,#1
	CMP R11, #3
	BLE SKIP_CORRECT_R10_GREATER_THAN_4
	MOV R11, #0
SKIP_CORRECT_R10_GREATER_THAN_4
	BL DRAW_EDITED_OPERATION
SKIP_RIGHT_LOGIC_R10


	CMP R5, #1				; MOVED LEFT
	BNE SKIP_LEFT_LOGIC_R10
	MOV R5, #0
	SUB R11, R11 ,#1
	CMP R11, #0
	BGE SKIP_CORRECT_R10_LESS_THAN_0
	MOV R11, #3
SKIP_CORRECT_R10_LESS_THAN_0
	BL DRAW_EDITED_OPERATION
SKIP_LEFT_LOGIC_R10


	CMP R5, #4           ;Check if user pressed up (go to previous screen)
	BEQ	SWITCH_FROM_OPERATION_TO_SECOND
	
	CMP R5, #8		     ;PRESSING DOWN = EXIT
	BEQ EXIT_CALCULATOR
	
	CMP R5, #16          ;Check if OK was pressed confirming choice
	BEQ FINAL_CALCULATIONS
	B CHOOSE_OPERATION
	
	
SWITCH_FROM_OPERATION_TO_SECOND
	BL DRAW_CHOOSE_NUMBER_INTERFACE
	BL DRAW_EDITED_NUMBER_2
	BL DRAW_SECOND_TAG
	MOV R5, #0
	B CHOOSE_SECOND_NUMBER
HELPER_LINE_23
	B EXIT_CALCULATOR
FINAL_CALCULATIONS
	MOV R0, #0
	MOV R1, #0
	MOV R3, #320
	MOV R4, #240
	LDR R10, =GREEN
	BL DRAW_RECTANGLE_FILLED
	
	CMP R11, #0
	BNE SKIP_ADDITION
	ADD R6, R8, R9
	B PRINT_OUTPUT
SKIP_ADDITION
 
 
	CMP R11, #1
	BNE SKIP_SUBTRACTION
	SUB R6, R8, R9
	CMP R6, #0
	BLT START_CALCULATOR
	B PRINT_OUTPUT
SKIP_SUBTRACTION


	CMP R11, #2
	BNE SKIP_MULTIPLICATION
	MUL R6, R8, R9
	B PRINT_OUTPUT
SKIP_MULTIPLICATION


	;division
	UDIV R6, R8, R9	;general output
	MLS R4, R6, R9, R8
	B PRINT_OUTPUT_DIVISION
	
PRINT_OUTPUT
	MOV R12, R6			; general output
	LDR R10, =BLACK
	BL HANDLE_RESULT
	MOV R5,#0
	B OUTPUT_LOOP
	
PRINT_OUTPUT_DIVISION
	MOV R7, R4
	MOV R0, #65
	MOV R1, #125
	LDR R10, =BLACK
	BL DRAW_NUMBERS
	B PRINT_OUTPUT

	
OUTPUT_LOOP
	BL READ_BUTTONS
	CMP R5, #16	; OK
	BEQ START_CALCULATOR
	CMP R5, #8
	BEQ EXIT_CALCULATOR
	
	B OUTPUT_LOOP
	
ENDING_OF_CALCULATOR
	
EXIT_CALCULATOR
	MOV R0, #0
    MOV R1, #0
    MOV R3, #320
    MOV R4, #240
	LDR R10, =BLACK
	BL DRAW_RECTANGLE_FILLED
	MOV R5, #0
	POP{R0-R12, PC}
	
	ENDFUNC
	

;--------------------------------------------------------------
CLEAR_NUMBER_OPERATION_AREA FUNCTION
	PUSH{R0-R12, LR}
	MOV R0, #140
	MOV R1, #105
	MOV R3, #170
	MOV R4, #140
	LDR R10, =BLACK
	BL DRAW_RECTANGLE_FILLED
	LDR R10, =CYAN
	
	POP{R0-R12, PC}
	ENDFUNC
;##############################################################


;--------------------------------------------------------------
DRAW_EDITED_NUMBER_1 FUNCTION
	PUSH{LR}
	BL CLEAR_NUMBER_OPERATION_AREA
	MOV R0, #146
	MOV R1, #110
	MOV R7, R8
	BL DRAW_NUMBERS
	POP{PC}
	ENDFUNC
;##############################################################


;--------------------------------------------------------------
DRAW_EDITED_NUMBER_2 FUNCTION
	PUSH{LR}
	BL CLEAR_NUMBER_OPERATION_AREA
	MOV R0, #146
	MOV R1, #110
	MOV R7, R9
	BL DRAW_NUMBERS
	POP{PC}
	ENDFUNC
;##############################################################
	

;--------------------------------------------------------------
DRAW_CHOOSE_NUMBER_INTERFACE FUNCTION
	PUSH{LR}
	MOV R0, #0
    MOV R1, #0
    MOV R3, #320
    MOV R4, #240
	LDR R10, =BLACK
    BL DRAW_RECTANGLE_FILLED
	
	MOV R0, #146
	MOV R1, #110
	LDR R10, =CYAN
	BL DRAW_NUMBERS
	
	; TO DO ADD THE ARROWS FROM 60->30, 180->210
	MOV R0, #90           ; X Position
	MOV R1, #110          ; Y Position
	LDR R6, =LeftArrow   ; Bitmap Address
	BL DRAW_ICON_OPS
	
	MOV R0, #200           ; X Position
	LDR R6, =RightArrow   ; Bitmap Address
	BL DRAW_ICON_OPS
	
	POP{PC}
	
	ENDFUNC
;##############################################################


;--------------------------------------------------------------
DRAW_CHOOSE_OPERATION_INTERFACE FUNCTION
	PUSH{LR}
	MOV R0, #0
    MOV R1, #0
    MOV R3, #320
    MOV R4, #240
	LDR R10, =BLACK
    BL DRAW_RECTANGLE_FILLED
	
	MOV R0, #146
	MOV R1, #110
	LDR R10, =CYAN
	BL DRAW_OPERATIONS
	
	; TO DO ADD THE ARROWS FROM 60->30, 180->210
	MOV R0, #90           ; X Position
	MOV R1, #110          ; Y Position
	LDR R6, =LeftArrow   ; Bitmap Address
	BL DRAW_ICON_OPS
	
	MOV R0, #200           ; X Position
	LDR R6, =RightArrow   ; Bitmap Address
	BL DRAW_ICON_OPS
	
	POP{PC}
	ENDFUNC
;##############################################################


;--------------------------------------------------------------
DRAW_EDITED_OPERATION FUNCTION
	PUSH{LR}
	BL CLEAR_NUMBER_OPERATION_AREA
	MOV R0, #146
	MOV R1, #105
	MOV R7, R11
	BL DRAW_OPERATIONS
	POP{PC}
	ENDFUNC
;##############################################################
	

;--------------------------------------------------------------	
DRAW_FIRST_TAG FUNCTION
	PUSH{R0-R12, LR}
	;First
	MOV R0, #50
	MOV R1, #40        
	LDR R6, =CharF  ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #70         
	LDR R6, =CharI  ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR_I
	
	MOV R0, #85         
	LDR R6, =CharR  ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #105       
	LDR R6, =CharS  ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #125        
	LDR R6, =CharT  ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	;Number
	MOV R0, #160        
	LDR R6, =CharN  ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #180        
	LDR R6, =CharU  ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #200       
	LDR R6, =CharM  ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR_M
	
	MOV R0, #227       
	LDR R6, =CharB  ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #247    
	LDR R6, =CharE  ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #267     
	LDR R6, =CharR  ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	POP{R0-R12, PC}
	ENDFUNC

;##############################################################


;--------------------------------------------------------------	
DRAW_SECOND_TAG FUNCTION
	PUSH{R0-R12, LR}
	;Second
	MOV R0, #30
	MOV R1, #40        
	LDR R6, =CharS  ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #50       
	LDR R6, =CharE  ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #70       
	LDR R6, =CharC  ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #90      
	LDR R6, =CharO  ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #110      
	LDR R6, =CharN  ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #130     
	LDR R6, =CharD  ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	;Number
	MOV R0, #170       
	LDR R6, =CharN  ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #190       
	LDR R6, =CharU  ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #210       
	LDR R6, =CharM  ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR_M
	
	MOV R0, #237    
	LDR R6, =CharB  ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #257 
	LDR R6, =CharE  ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #277   
	LDR R6, =CharR  ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	POP{R0-R12, PC}
	ENDFUNC

;##############################################################


;--------------------------------------------------------------	
DRAW_OP_TAG FUNCTION
	PUSH{R0-R12, LR}
	;Operation
	MOV R0, #70
	MOV R1, #40        
	LDR R6, =CharO  ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #90       
	LDR R6, =CharP  ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #110       
	LDR R6, =CharE  ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #130      
	LDR R6, =CharR  ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #150      
	LDR R6, =CharA  ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #170     
	LDR R6, =CharT  ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #190       
	LDR R6, =CharI  ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR_I
	
	MOV R0, #205       
	LDR R6, =CharO  ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #225     
	LDR R6, =CharN  ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	POP{R0-R12, PC}
	ENDFUNC

;##############################################################


;--------------------------------------------------------------
DRAW_OPERATIONS FUNCTION
	PUSH {R0-R12, LR}
	;receive the number in R7
	;receive R0  X Postion
	;receive R1 Y Postion
	;receive R10 color 
	cmp r7, #0 ; +
	beq DRAW_0_DRAW_OPERATIONS
	
	cmp r7, #1 ; -
	beq DRAW_1_DRAW_OPERATIONS
	
	cmp r7, #2 ; x
	beq DRAW_2_DRAW_OPERATIONS
	
	cmp r7, #3 ; /
	beq DRAW_3_DRAW_OPERATIONS
		
	b ret_DRAW_OPERATIONS
	

DRAW_0_DRAW_OPERATIONS ; + (-,|)
	MOV R0, #146 ;-
    MOV R1, #117
    MOV R3, #166
    MOV R4, #123
	LDR R10, =CYAN
    BL DRAW_RECTANGLE_FILLED
	MOV R0, #153 ;|
    MOV R1, #110
    MOV R3, #159
    MOV R4, #130
	LDR R10, =CYAN
    BL DRAW_RECTANGLE_FILLED
	b ret_DRAW_OPERATIONS
	
DRAW_1_DRAW_OPERATIONS ; -
	MOV R0, #146
    MOV R1, #117
    MOV R3, #166
    MOV R4, #123
	LDR R10, =CYAN
    BL DRAW_RECTANGLE_FILLED
	b ret_DRAW_OPERATIONS
	
DRAW_2_DRAW_OPERATIONS ; x
	ldr r6,=CharX
	bl DRAW_CHAR
	b ret_DRAW_OPERATIONS
	
DRAW_3_DRAW_OPERATIONS ; /
	MOV R0, #146
    MOV R1, #117
    MOV R3, #166
    MOV R4, #123
	LDR R10, =CYAN
    BL DRAW_RECTANGLE_FILLED
	MOV R0, #153
    MOV R1, #110
    MOV R3, #159
    MOV R4, #114
	LDR R10, =CYAN
    BL DRAW_RECTANGLE_FILLED
	MOV R0, #153
    MOV R1, #126
    MOV R3, #159
    MOV R4, #130
	LDR R10, =CYAN
    BL DRAW_RECTANGLE_FILLED
	b ret_DRAW_OPERATIONS
	
ret_DRAW_OPERATIONS
	
	POP {R0-R12, PC}
	ENDFUNC
;##############################################################	
	END