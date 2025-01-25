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
GOLD  	EQU		0xF6A0
	
	
	; IMPORTING CHARACTERS AND NUMBERS
	
	IMPORT CharA
	IMPORT CharE
	IMPORT CharH
	IMPORT CharP
	IMPORT CharL
	IMPORT CharU
	IMPORT CharI
	IMPORT CharN
	IMPORT CharM
	IMPORT CharT
	IMPORT CharR
	IMPORT CharO
	IMPORT CharS
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
	IMPORT DRAW_ICON_OP
	IMPORT DRAW_LINE_HORIZONTAL
	IMPORT DRAW_DIGIT_PAIR
	IMPORT delay_1_second
	IMPORT DRAW_CHAR_I
	IMPORT DRAW_CHAR_M
		
	EXPORT DRAW_INTRO_SCREEN



DRAW_INTRO_SCREEN FUNCTION

	PUSH{R0-R12, LR}

	; BLACK BACKGROUND

	mov r0, #0
	mov r1, #0
	mov r3, #320
	mov r4, #240
	ldr r10,=BLACK
	bl DRAW_RECTANGLE_FILLED
	
	BL DRAW_OMNITRIX
	BL DRAW_ULTIMATE
	BL DRAW_TEAM
	
	
	POP{R0-R12, PC}

	
	ENDFUNC


;======================================================

DRAW_TEAM FUNCTION
	
	PUSH{R0-R12, LR}
	
	;TEAM
	
	MOV R0, #120           ; X Position
	MOV R1, #180          ; Y Position
	LDR R6, =CharT   ; Bitmap Address
	LDR R10, =YELLOW
	BL DRAW_CHAR
	
	MOV R0, #140           ; X Position
	MOV R1, #180          ; Y Position
	LDR R6, =CharE   ; Bitmap Address
	LDR R10, =YELLOW
	BL DRAW_CHAR
	
	MOV R0, #160           ; X Position
	MOV R1, #180          ; Y Position
	LDR R6, =CharA   ; Bitmap Address
	LDR R10, =YELLOW
	BL DRAW_CHAR
	
	MOV R0, #180           ; X Position
	MOV R1, #180          ; Y Position
	LDR R6, =CharM   ; Bitmap Address
	LDR R10, =YELLOW
	BL DRAW_CHAR_M
	
	
	POP{R0-R12, PC}
	
	ENDFUNC

;======================================================

DRAW_ULTIMATE FUNCTION
	
	PUSH{R0-R12, LR}
	
	; ULTIMATE
	
	MOV R0, #80           ; X Position
	MOV R1, #140          ; Y Position
	LDR R6, =CharU   ; Bitmap Address
	LDR R10, =YELLOW
	BL DRAW_CHAR
	
	MOV R0, #100           ; X Position
	MOV R1, #140          ; Y Position
	LDR R6, =CharL   ; Bitmap Address
	LDR R10, =YELLOW
	BL DRAW_CHAR
	
	MOV R0, #120           ; X Position
	MOV R1, #140          ; Y Position
	LDR R6, =CharT   ; Bitmap Address
	LDR R10, =YELLOW
	BL DRAW_CHAR
	
	MOV R0, #140           ; X Position
	MOV R1, #140          ; Y Position
	LDR R6, =CharI   ; Bitmap Address
	LDR R10, =YELLOW
	BL DRAW_CHAR_I
	
	MOV R0, #155           ; X Position
	MOV R1, #140          ; Y Position
	LDR R6, =CharM   ; Bitmap Address
	LDR R10, =YELLOW
	BL DRAW_CHAR_M
	
	MOV R0, #181           ; X Position
	MOV R1, #140          ; Y Position
	LDR R6, =CharA   ; Bitmap Address
	LDR R10, =YELLOW
	BL DRAW_CHAR
	
	MOV R0, #201           ; X Position
	MOV R1, #140          ; Y Position
	LDR R6, =CharT   ; Bitmap Address
	LDR R10, =YELLOW
	BL DRAW_CHAR
	
	
	MOV R0, #221           ; X Position
	MOV R1, #140          ; Y Position
	LDR R6, =CharE   ; Bitmap Address
	LDR R10, =YELLOW
	BL DRAW_CHAR
	
	
	POP{R0-R12, PC}
	
	ENDFUNC


;======================================================


DRAW_OMNITRIX FUNCTION
	
	PUSH{R0-R12, LR}
	
	; OMNITRIX

	MOV R0, #80           ; X Position
	MOV R1, #40          ; Y Position
	LDR R6, =CharO   ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #100        ; X Position
	MOV R1, #40          ; Y Position
	LDR R6, =CharM   ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR_M
	
	MOV R0, #126        ; X Position
	MOV R1, #40          ; Y Positio
	LDR R6, =CharN   ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #146        ; X Position
	MOV R1, #40          ; Y Position
	LDR R6, =CharI   ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR_I
	
	MOV R0, #161        ; X Position
	MOV R1, #40          ; Y Position
	LDR R6, =CharT   ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	
	MOV R0, #181        ; X Position
	MOV R1, #40          ; Y Position
	LDR R6, =CharR; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #201        ; X Position
	MOV R1, #40          ; Y Position
	LDR R6, =CharI   ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR_I
	
	MOV R0, #216        ; X Position
	MOV R1, #40          ; Y Position
	LDR R6, =CharX   ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	POP{R0-R12, PC}
	
	ENDFUNC
	
	END