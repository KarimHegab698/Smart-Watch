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
		
	EXPORT DRAW_ALARM_SCREEN

;==================================================================


ALARM_TEXT FUNCTION
	
	PUSH{R0-R12, LR}

	MOV R0, #151
	MOV R1, #70          ; Y Position
	LDR R6, =CharA  ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #171
	MOV R1, #70          ; Y Position
	LDR R6, =CharL   ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #191
	MOV R1, #70          ; Y Position
	LDR R6, =CharA   ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #212
	MOV R1, #70          ; Y Position
	LDR R6, =CharR   ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #232
	MOV R1, #70          ; Y Position
	LDR R6, =CharM   ; Bitmap Address
	LDR R10, =GREEN
	BL DRAW_CHAR_M
	
    POP {R0-R12, PC}
    ENDFUNC


;==================================================================
ALARM_TIMER FUNCTION
	
	PUSH{R0-R12, LR}

	MOV R0, #151
	MOV R1, #100        ; Y Position
	LDR R6, =Char0   	; Bitmap Address
	;LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #171
	MOV R1, #100          ; Y Position
	LDR R6, =Char0   ; Bitmap Address
	;LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #197
	MOV R1, #100          ; Y Position
	LDR R6, =Char0   ; Bitmap Address
	;LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #217
	MOV R1, #100          ; Y Position
	LDR R6, =Char0   ; Bitmap Address
	;LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #243
	MOV R1, #100          ; Y Position
	LDR R6, =Char0   ; Bitmap Address
	;LDR R10, =GREEN
	BL DRAW_CHAR
	
	MOV R0, #263
	MOV R1, #100          ; Y Position
	LDR R6, =Char0   ; Bitmap Address
	;LDR R10, =GREEN
	BL DRAW_CHAR
	
	; 1st Dot
    MOV R0, #191
    MOV R1, #110
    MOV R3, #195
    MOV R4, #115
    BL DRAW_RECTANGLE_FILLED

    ADD R1, #6
    ADD R4, #6
    BL DRAW_RECTANGLE_FILLED

	;LDR R10, =GREEN
    ; 3rd Dot
    MOV R0, #237
    MOV R1, #110
    MOV R3, #241
    MOV R4, #115
    BL DRAW_RECTANGLE_FILLED

    ADD R1, #6
    ADD R4, #6
    BL DRAW_RECTANGLE_FILLED

    POP {R0-R12, PC}
    ENDFUNC


;================================

DRAW_SET_BUTTON FUNCTION
	
	PUSH{R0-R12, LR}

	MOV R0, #189
	MOV R1, #142        ; Y Position
	LDR R6, =CharS   	; Bitmap Address
	LDR R10, =WHITE
	BL DRAW_CHAR
	
	MOV R0, #209
	MOV R1, #142        ; Y Position
	LDR R6, =CharE   	; Bitmap Address
	LDR R10, =WHITE
	BL DRAW_CHAR
	
	MOV R0, #229
	MOV R1, #142        ; Y Position
	LDR R6, =CharT   	; Bitmap Address
	LDR R10, =WHITE
	BL DRAW_CHAR

    POP {R0-R12, PC}
    ENDFUNC

;=======================================

DRAW_RESET_BUTTON FUNCTION

	PUSH{R0-R12, LR}

	MOV R0, #171
	MOV R1, #182        ; Y Position
	LDR R6, =CharR  	; Bitmap Address
	LDR R10, =WHITE
	BL DRAW_CHAR
	
	MOV R0, #191
	MOV R1, #182        ; Y Position
	LDR R6, =CharE   	; Bitmap Address
	LDR R10, =WHITE
	BL DRAW_CHAR
	
	MOV R0, #211
	MOV R1, #182        ; Y Position
	LDR R6, =CharS   	; Bitmap Address
	LDR R10, =WHITE
	BL DRAW_CHAR
	
	MOV R0, #231
	MOV R1, #182        ; Y Position
	LDR R6, =CharE   	; Bitmap Address
	LDR R10, =WHITE
	BL DRAW_CHAR

	MOV R0, #251
	MOV R1, #182        ; Y Position
	LDR R6, =CharT   	; Bitmap Address
	LDR R10, =WHITE
	BL DRAW_CHAR

    POP {R0-R12, PC}
    ENDFUNC

;=======================================

DRAW_ALARM_BUTTONS FUNCTION
	
	PUSH{R0-R12, LR}

	mov r0, #151
    mov r1, #138
    mov r3, #281
    mov r4, #172
    ;ldr r10,=GREEN
    bl DRAW_RECTANGLE_FILLED
	
	BL DRAW_SET_BUTTON
	
	mov r0, #151
    mov r1, #178
    mov r3, #281
    mov r4, #212
    ;ldr r10,=GREEN
    bl DRAW_RECTANGLE_FILLED
	
	BL DRAW_RESET_BUTTON

    POP {R0-R12, PC}
    ENDFUNC
	
;===============================

DRAW_ALARM_SCREEN FUNCTION
	
	PUSH{R0-R12, LR}

	BL ALARM_TEXT
	BL ALARM_TIMER
	BL DRAW_ALARM_BUTTONS

    POP {R0-R12, PC}
    ENDFUNC

;================================		
	END