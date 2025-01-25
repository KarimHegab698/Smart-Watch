	AREA MYDATA, DATA, READONLY
		
	
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
CYAN2 	EQU  	0x07FF
BEN     EQU		0xaff7
GRAY	EQU		0xdefb
	
	
	; IMPORTING CHARACTERS AND NUMBERS
	; ITS HERO TIME
	IMPORT CharA
	IMPORT CharC
	IMPORT CharG
	IMPORT CharE
	IMPORT CharH
	IMPORT CharP
	IMPORT CharI
	IMPORT CharM
	IMPORT CharT
	IMPORT CharR
	IMPORT CharO
	IMPORT CharS
	IMPORT CharL
	IMPORT CharU
		
	IMPORT HomeIcon
	IMPORT SunIcon
	IMPORT JoyStiick
	IMPORT SettingIcon
	IMPORT Controller
	IMPORT DropIcon
	IMPORT Stopwatch
	
	
	AREA SCREENDRAWS, CODE, READONLY
		
	IMPORT DRAW_CHAR
	IMPORT DRAW_RECTANGLE_FILLED	
	IMPORT DRAW_NUMBERS	
	;IMPORT DRAW_ICON
	IMPORT DRAW_LINE_HORIZONTAL
	IMPORT DRAW_DIGIT_PAIR
	IMPORT delay_1_second
	IMPORT DRAW_CHAR_I
	IMPORT DRAW_CHAR_M
		
	EXPORT DRAW_CALC_SCREEN

;==================================================================


CALCULATOR_TEXT FUNCTION
	
	PUSH{R0-R12, LR}

	MOV R0, #131
	MOV R1, #70          ; Y Position
	LDR R6, =CharC  ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #151
	MOV R1, #70          ; Y Position
	LDR R6, =CharA   ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #171
	MOV R1, #70          ; Y Position
	LDR R6, =CharL   ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #191
	MOV R1, #70          ; Y Position
	LDR R6, =CharC   ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #211
	MOV R1, #70          ; Y Position
	LDR R6, =CharU   ; Bitmap Address
	LDR R10,=GREEN
	BL DRAW_CHAR
	
	MOV R0, #231
	MOV R1, #70          ; Y Position
	LDR R6, =CharL   ; Bitmap Address
	LDR R10,=GREEN
	BL DRAW_CHAR
		
	MOV R0, #251
	MOV R1, #70          ; Y Position
	LDR R6, =CharA   ; Bitmap Address
	LDR R10,=GREEN
	BL DRAW_CHAR
	
	
	MOV R0, #271
	MOV R1, #70          ; Y Position
	LDR R6, =CharT   ; Bitmap Address
	LDR R10,=GREEN
	BL DRAW_CHAR
	
	MOV R0, #291
	MOV R1, #70          ; Y Position
	LDR R6, =CharO   ; Bitmap Address
	LDR R10,=GREEN
	BL DRAW_CHAR
	
	
	MOV R0, #311
	MOV R1, #70          ; Y Position
	LDR R6, =CharR   ; Bitmap Address
	LDR R10,=GREEN
	BL DRAW_CHAR
	
	
    POP {R0-R12, PC}
    ENDFUNC

;================================

DRAW_CALC_BUTTON_TXT FUNCTION
	
	PUSH{R0-R12, LR}

	MOV R0, #165
	MOV R1, #142        ; Y Position
	LDR R6, =CharS   	; Bitmap Address
	LDR R10, =WHITE
	BL DRAW_CHAR
	
	MOV R0, #185
	MOV R1, #142        ; Y Position
	LDR R6, =CharT   	; Bitmap Address
	LDR R10, =WHITE
	BL DRAW_CHAR
	
	MOV R0, #205
	MOV R1, #142        ; Y Position
	LDR R6, =CharA   	; Bitmap Address
	LDR R10, =WHITE
	BL DRAW_CHAR
	
	MOV R0, #225
	MOV R1, #142        ; Y Position
	LDR R6, =CharR   	; Bitmap Address
	LDR R10, =WHITE
	BL DRAW_CHAR
	
	MOV R0, #245
	MOV R1, #142        ; Y Position
	LDR R6, =CharT   	; Bitmap Address
	LDR R10, =WHITE
	BL DRAW_CHAR

    POP {R0-R12, PC}
    ENDFUNC

;===========================================

DRAW_CALC_BUTTONS FUNCTION
	
	PUSH{R0-R12, LR}

	mov r0, #151
    mov r1, #138
    mov r3, #281
    mov r4, #172
    ldr r10,=GREEN
    bl DRAW_RECTANGLE_FILLED
	bl DRAW_CALC_BUTTON_TXT

    POP {R0-R12, PC}
    ENDFUNC
	
;==========================================

DRAW_CALC_SCREEN FUNCTION
	
	PUSH{R0-R12, LR}

	BL CALCULATOR_TEXT
	BL DRAW_CALC_BUTTONS

    POP {R0-R12, PC}
    ENDFUNC

;================================		
	END