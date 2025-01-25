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
	IMPORT CharL
	IMPORT CharE
	IMPORT CharH
	IMPORT CharP
	IMPORT CharI
	IMPORT CharM
	IMPORT CharT
	IMPORT CharR
	IMPORT CharO
	IMPORT CharS
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
		
	IMPORT HomeIcon
	IMPORT SunIcon
	IMPORT JoyStiick
	IMPORT SettingIcon
	;IMPORT Controller
	IMPORT DropIcon
	IMPORT Stopwatch
	
	
	AREA SCREENDRAWS, CODE, READONLY
		
	IMPORT DRAW_CHAR
	IMPORT DRAW_RECTANGLE_FILLED	
	IMPORT DRAW_NUMBERS	
	IMPORT DRAW_ICON_OP
	IMPORT DRAW_LINE_HORIZONTAL
	IMPORT DRAW_DIGIT_PAIR
	IMPORT delay_1_second
	IMPORT DRAW_CHAR_I
	IMPORT DRAW_CHAR_M
		
	EXPORT DRAW_THEMES_SCREEN

;==================================================================


THEMES_TEXT FUNCTION
	
	PUSH{R0-R12, LR}

	MOV R0, #151
	MOV R1, #70         ; Y Position
	LDR R6, =CharT  	; Bitmap Address
	;LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #171
	MOV R1, #70         ; Y Position
	LDR R6, =CharH   	; Bitmap Address
	;LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #191
	MOV R1, #70          ; Y Position
	LDR R6, =CharE   ; Bitmap Address
	;LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #212
	MOV R1, #70          ; Y Position
	LDR R6, =CharM   ; Bitmap Address
	;LDR R10, =GREEN
	BL DRAW_CHAR_M
	
	MOV R0, #238
	MOV R1, #70          ; Y Position
	LDR R6, =CharE   ; Bitmap Address
	;LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #258
	MOV R1, #70          ; Y Position
	LDR R6, =CharS   ; Bitmap Address
	;LDR R10, =GREEN
	BL DRAW_CHAR
	
    POP {R0-R12, PC}
    ENDFUNC


;==================================================================

DRAW_THEMES_SCREEN FUNCTION
	
	PUSH{R0-R12, LR}
	
	BL THEMES_TEXT
	
	
	mov r0, #151
	mov r1, #138
	mov r3, #191
	mov r4, #178
	ldr r10,=GREEN
	bl DRAW_RECTANGLE_FILLED
	
	MOV R9, R10
	
	mov r0, #211
	mov r1, #138
	mov r3, #251
	mov r4, #178
	ldr r10,=RED
	bl DRAW_RECTANGLE_FILLED
	
	mov r0, #271
	mov r1, #138
	mov r3, #311
	mov r4, #178
	ldr r10,=MAGENTA
	bl DRAW_RECTANGLE_FILLED
	
	MOV R10, R9
	
	
    POP {R0-R12, PC}
    ENDFUNC


;================================		
	END