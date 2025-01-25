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
	IMPORT Controller
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
		
	EXPORT DRAW_GAME_SCREEN

;==================================================================


GAME_TEXT FUNCTION
	
	PUSH{R0-R12, LR}

	MOV R0, #151
	MOV R1, #70          ; Y Position
	LDR R6, =CharG  ; Bitmap Address
	;LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #171
	MOV R1, #70          ; Y Position
	LDR R6, =CharA   ; Bitmap Address
	;LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #186
	MOV R1, #70          ; Y Position
	LDR R6, =CharM   ; Bitmap Address
	;LDR R10, =GREEN
	BL DRAW_CHAR_M
	
	MOV R0, #212
	MOV R1, #70          ; Y Position
	LDR R6, =CharE   ; Bitmap Address
	;LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #232
	MOV R1, #70          ; Y Position
	LDR R6, =CharS   ; Bitmap Address
	;LDR R10,=GREEN
	BL DRAW_CHAR
	
    POP {R0-R12, PC}
    ENDFUNC

;================================

DRAW_GAME_ONE_BUTTON FUNCTION
	
	PUSH{R0-R12, LR}

	MOV R0, #164
	MOV R1, #142        ; Y Position
	LDR R6, =CharG   	; Bitmap Address
	LDR R10, =WHITE
	BL DRAW_CHAR
	
	MOV R0, #184
	MOV R1, #142        ; Y Position
	LDR R6, =CharA   	; Bitmap Address
	LDR R10, =WHITE
	BL DRAW_CHAR
	
	MOV R0, #204
	MOV R1, #142        ; Y Position
	LDR R6, =CharM   	; Bitmap Address
	LDR R10, =WHITE
	BL DRAW_CHAR_M
	
	MOV R0, #230
	MOV R1, #142        ; Y Position
	LDR R6, =CharE   	; Bitmap Address
	LDR R10, =WHITE
	BL DRAW_CHAR
	
	MOV R0, #255
	MOV R1, #142        ; Y Position
	LDR R6, =Char1   	; Bitmap Address
	LDR R10, =WHITE
	BL DRAW_CHAR

    POP {R0-R12, PC}
    ENDFUNC

;=======================================

DRAW_GAME_TWO_BUTTON FUNCTION
	
	PUSH{R0-R12, LR}
	
;	 mov r0, #220
;    mov r1, #170
;    mov r3, #301
;    mov r4, #200
;    ldr r10,=GREEN
;    bl DRAW_RECTANGLE_FILLED

	
	MOV R0, #164
	MOV R1, #182        ; Y Position
	LDR R6, =CharG   	; Bitmap Address
	LDR R10, =WHITE
	BL DRAW_CHAR
	
	MOV R0, #184
	MOV R1, #182        ; Y Position
	LDR R6, =CharA   	; Bitmap Address
	LDR R10, =WHITE
	BL DRAW_CHAR
	
	MOV R0, #204
	MOV R1, #182        ; Y Position
	LDR R6, =CharM   	; Bitmap Address
	LDR R10, =WHITE
	BL DRAW_CHAR_M
	
	MOV R0, #230
	MOV R1, #182        ; Y Position
	LDR R6, =CharE   	; Bitmap Address
	LDR R10, =WHITE
	BL DRAW_CHAR
	
	MOV R0, #255
	MOV R1, #182        ; Y Position
	LDR R6, =Char2   	; Bitmap Address
	LDR R10, =WHITE
	BL DRAW_CHAR

    POP {R0-R12, PC}
    ENDFUNC

;=======================================

DRAW_GAME_BUTTONS FUNCTION
	
	PUSH{R0-R12, LR}

	mov r0, #151
    mov r1, #138
    mov r3, #281
    mov r4, #172
    ;ldr r10,=GREEN
    bl DRAW_RECTANGLE_FILLED
	
	BL DRAW_GAME_ONE_BUTTON
	
	mov r0, #151
    mov r1, #178
    mov r3, #281
    mov r4, #212
    ;ldr r10,=GREEN
    bl DRAW_RECTANGLE_FILLED
	
	BL DRAW_GAME_TWO_BUTTON

    POP {R0-R12, PC}
    ENDFUNC
	
;===============================

DRAW_GAME_SCREEN FUNCTION
	
	PUSH{R0-R12, LR}

	BL GAME_TEXT
	BL DRAW_GAME_BUTTONS

    POP {R0-R12, PC}
    ENDFUNC

;================================		
	END