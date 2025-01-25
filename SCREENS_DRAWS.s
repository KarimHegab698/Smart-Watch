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
	IMPORT Alarm	
	IMPORT CalculatorIcon	
	
	
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
	IMPORT DRAW_ALARM_SCREEN
	IMPORT DRAW_INTRO_SCREEN
	
	IMPORT DRAW_STOPWATCH_SCREEN
	IMPORT DRAW_THEMES_SCREEN
	IMPORT DRAW_GAME_SCREEN	
		
	IMPORT DRAW_CALC_SCREEN	
		
		
	EXPORT DRAW_BEN10_SCREEN
	EXPORT DRAW_HOME_SCREEN
	EXPORT BOX_EXPANSION
	EXPORT HOME_INTERFACE
	EXPORT ALARM_INTERFACE	
	EXPORT STOPWATCH_INTERFACE
	EXPORT THEMES_INTERFACE	
	EXPORT GAMES_INTERFACE	
	EXPORT CALCULATOR_INTERFACE
	EXPORT DRAW_CLOCK_PART
 
;======================================================

BOX_EXPANSION FUNCTION
	PUSH{R0-R12, LR}
	
	BL delay_1_second
	BL delay_1_second
	BL delay_1_second
	BL delay_1_second
	BL delay_1_second
	BL delay_1_second
	MOV R0, #0
    MOV R1, #0
    MOV R3, #320
    MOV R4, #240
	LDR R10, =BLACK
    BL DRAW_RECTANGLE_FILLED
	;keep win screen for 6 seconds
	BL delay_1_second
	BL delay_1_second
	BL delay_1_second
	BL delay_1_second
	BL delay_1_second
	BL delay_1_second

	POP{R0-R12, PC}

	ENDFUNC

;======================================================
		
DRAW_BEN10_SCREEN FUNCTION

	PUSH{R0-R12, LR}
	
	mov r9, r10

	mov r0, #0
	mov r1, #0
	mov r6, #1
	
	mov r3, #320
	mov r4, #240
	ldr r10,=GRAY
	bl DRAW_RECTANGLE_FILLED
	
	mov r10, r9
	
	mov r0, #0
	mov r1, #0
	mov r3, #319
	;ldr r10,=GREEN
	mov r6, #1
	bl DRAW_LINE_HORIZONTAL

	mov r0, #0
	mov r1, #239
	mov r3, #319
	;ldr r10,=GREEN
	mov r6, #1
	bl DRAW_LINE_HORIZONTAL

	mov r0, #0
	mov r1, #0
	mov r6, #1
	mov r3, #1
	;ldr r10,=GREEN 
	
	
upper_Ben_Right
	bl DRAW_LINE_HORIZONTAL
	add r3, #2
	add r1, #1
	cmp r1, #120
	bne upper_Ben_Right
	
	mov r0, #0
	mov r1, #120
	mov r6, #1
	mov r3, #240
	;ldr r10,=GREEN	
Lower_Ben_Right
	bl DRAW_LINE_HORIZONTAL
	sub r3, #2
	add r1, #1
	cmp r1, #240
	bne Lower_Ben_Right

	mov r0, #319
	mov r1, #0
	mov r6, #1
	mov r3, #320
	;ldr r10,=GREEN
upper_Ben_LEFT
	bl DRAW_LINE_HORIZONTAL
	add r1, #1
	sub r0, #2
	cmp r1, #120
	bne upper_Ben_LEFT
	
	mov r0, #80
	mov r1, #120
	mov r6, #1
	mov r3, #320
	;ldr r10,=GREEN	
Lower_Ben_LEFT
	bl DRAW_LINE_HORIZONTAL
	add r1, #1
	add r0, #2
	cmp r1, #240
	bne Lower_Ben_LEFT
	
	POP{R0-R12, PC}

	
	ENDFUNC

;==========================================================

DRAW_RHOMBUS FUNCTION

	PUSH{R0-R12, LR}

	; MAKE BACKGROUND BLACK
	
	MOV R9, R10

	mov r0, #0
	mov r1, #0
	mov r3, #320
	mov r4, #240
	ldr r10,=GRAY 
	bl DRAW_RECTANGLE_FILLED
	
	; SET INITIALS OF RHOMBUS
	MOV R10, R9

	;ldr r10,=GREEN
	mov r0, #5
	mov r1, #120
	mov r6, #1
	mov r3, #115
	
	; DRAW UPPER TRIANGLE

UPPER_TRIANGLE_DRAW_HOME_SCREEN

	bl DRAW_LINE_HORIZONTAL
	add r0, #1
	sub r3, #1
	sub r1, #1
	bl DRAW_LINE_HORIZONTAL
	sub r1, #1
	cmp r1, #12
	bne UPPER_TRIANGLE_DRAW_HOME_SCREEN

	mov r0, #5
	mov r1, #120
	mov r6, #1
	mov r3, #115


	; DRAW LOWER TRIANGLE
	
LOWER_TRIANGLE_DRAW_HOME_SCREEN
	bl DRAW_LINE_HORIZONTAL
	add r0, #1
	sub r3, #1
	add r1, #1
	cmp r1, #229
	beq RETURN_DRAW_HOME_SCREEN
	bl DRAW_LINE_HORIZONTAL
	add r1, #1
	cmp r1, #229
	bne LOWER_TRIANGLE_DRAW_HOME_SCREEN
	
RETURN_DRAW_HOME_SCREEN



	POP{R0-R12, PC}
	ENDFUNC
	
;==========================================================

DRAW_CLOCK_PART FUNCTION
	PUSH{R0-R12, LR}
	
	
	
	MOV R9, R10
;clockLoop
	mov r0, #151
    mov r1, #20
    mov r3, #281
    mov r4, #47
    ldr r10,=GRAY
    bl DRAW_RECTANGLE_FILLED

    ; Constants
    LDR R6, =Char0           ; Bitmap Address for '0'
    ;LDR R10, =GREEN          ; Color
	MOV R10, R9

    ; ============================
    ; Preserve Total Seconds
    ; ============================
    MOV R12, R11             ; Store total seconds in R12 for later use

    ; ============================
    ; Compute Hours
    ; ============================
    MOV R5, #3600            ; Load 3600 (seconds per hour) into R5
    SDIV R2, R12, R5         ; R2 = R12 / 3600 (hours)
    MLS R12, R2, R5, R12     ; R12 = R12 - (R2 * 3600), remainder seconds

    ; ============================
    ; Compute Minutes
    ; ============================
    MOV R5, #60              ; Load 60 (seconds per minute) into R5
    SDIV R3, R12, R5         ; R3 = R12 / 60 (minutes)
    MLS R12, R3, R5, R12     ; R12 = R12 - (R3 * 60), remainder seconds

    ; ============================
    ; Compute Seconds
    ; ============================
    MOV R4, R12              ; Remaining seconds are directly in R12

    ; ========================
    ; Draw All Zeros First
    ; ========================
    MOV R0, #151             ; Reset X Position

    ; DRAW_DIGIT_PAIR FUNCTION
    ; Draw two digits from R2 (Hours, Minutes, or Seconds)
    ; Input:
    ; - R2: Value to draw (0-59 or 0-23)
    ; - R0, R1: Current X, Y Position
	MOV R0, #151
	MOV R1, #20
    BL DRAW_DIGIT_PAIR        ; Draw Hours (R2)
    MOV R2, R3
	MOV R0, #197
	MOV R1,#20 
    BL DRAW_DIGIT_PAIR        ; Draw Minutes (R3)
	MOV R0, #243
	MOV R1, #20
    MOV R2, R4
    BL DRAW_DIGIT_PAIR        ; Draw Seconds (R4)

    ; ========================
    ; Draw Dots
    ; ========================
    ; 1st Dot
    MOV R0, #191
    MOV R1, #30
    MOV R3, #195
    MOV R4, #34
    BL DRAW_RECTANGLE_FILLED

    ADD R1, #5
    ADD R4, #5
    BL DRAW_RECTANGLE_FILLED

	;LDR R10, =GREEN
    ; 3rd Dot
    MOV R0, #237
    MOV R1, #30
    MOV R3, #241
    MOV R4, #34
    BL DRAW_RECTANGLE_FILLED

    ADD R1, #5
    ADD R4, #5
    BL DRAW_RECTANGLE_FILLED

    ; ========================
    ; Update Total Seconds
    ; ========================
    ADD R11, #1              ; Increment total seconds

    ; ========================
    ; Delay and Loop
    ; ========================
    BL delay_1_second
	BL delay_1_second
	BL delay_1_second
;    BL delay_1_second

	
   ; B clockLoop
	POP{R0-R12, PC}
	ENDFUNC
	
;==========================================================

DRAW_HOME_INTERFACE FUNCTION
	PUSH{R0-R12, LR}
	
	MOV R0, #151           ; X Position
	MOV R1, #70          ; Y Position
	LDR R6, =SunIcon   ; Bitmap Address
	LDR R10, =YELLOW
	BL DRAW_ICON_OP


	
	MOV R0, #151           ; X Position
	MOV R1, #120          ; Y Position
	LDR R6, =DropIcon   ; Bitmap Address
	LDR R10, =BLUE
	BL DRAW_ICON_OP

	BL DRAW_HERO_TIME
	
    POP {R0-R12, PC}
    ENDFUNC

;====================================

DRAW_HERO_TIME FUNCTION
	PUSH{R0-R12, LR}
	
	; IT
	;MOV R9, R10
	
	MOV R0, #151           ; X Position
	MOV R1, #170          ; Y Position
	LDR R6, =CharI   ; Bitmap Address
	LDR R10, =YELLOW
	BL DRAW_CHAR_I
	
	MOV R0, #166           ; X Position
	MOV R1, #170          ; Y Position
	LDR R6, =CharT   ; Bitmap Address
	LDR R10, =YELLOW
	BL DRAW_CHAR
	
	; IS
	
	MOV R0, #190           ; X Position
	MOV R1, #170          ; Y Position
	LDR R6, =CharI   ; Bitmap Address
	LDR R10, =YELLOW
	BL DRAW_CHAR_I
	
	
	MOV R0, #205           ; X Position
	MOV R1, #170          ; Y Position
	LDR R6, =CharS   ; Bitmap Address
	LDR R10, =YELLOW
	BL DRAW_CHAR
	
	; HERO
	
	MOV R0, #230           ; X Position
	MOV R1, #170          ; Y Position
	LDR R6, =CharH   ; Bitmap Address
	LDR R10, =YELLOW
	BL DRAW_CHAR
	
	
	MOV R0, #250           ; X Position
	MOV R1, #170          ; Y Position
	LDR R6, =CharE   ; Bitmap Address
	LDR R10, =YELLOW
	BL DRAW_CHAR
	
	MOV R0, #270           ; X Position
	MOV R1, #170          ; Y Position
	LDR R6, =CharR   ; Bitmap Address
	LDR R10, =YELLOW
	BL DRAW_CHAR


	MOV R0, #290           ; X Position
	MOV R1, #170          ; Y Position
	LDR R6, =CharO   ; Bitmap Address
	LDR R10, =YELLOW
	BL DRAW_CHAR
	
	
	; TIME
	
	MOV R0, #151           ; X Position
	MOV R1, #205          ; Y Position
	LDR R6, =CharT   ; Bitmap Address
	LDR R10, =YELLOW
	BL DRAW_CHAR
	
	
	MOV R0, #171           ; X Position
	MOV R1, #205          ; Y Position
	LDR R6, =CharI   ; Bitmap Address
	LDR R10, =YELLOW
	BL DRAW_CHAR_I
	
	MOV R0, #186           ; X Position
	MOV R1, #205          ; Y Position
	LDR R6, =CharM   ; Bitmap Address
	LDR R10, =YELLOW
	BL DRAW_CHAR_M
	
	MOV R0, #214           ; X Position
	MOV R1, #205          ; Y Position
	LDR R6, =CharE   ; Bitmap Address
	LDR R10, =YELLOW
	BL DRAW_CHAR
	
	

	POP {R0-R12, PC}
    ENDFUNC
;====================================



;====================================

DRAW_HOME_SCREEN FUNCTION
	
	PUSH{R0-R12, LR}
	BL DRAW_RHOMBUS
	;BL DRAW_HOME_INTERFACE
	;BL DRAW_STOPWATCH_SCREEN
	;BL DRAW_ALARM_SCREEN
	;BL DRAW_THEMES_SCREEN
	;BL DRAW_CLOCK_PART
    POP {R0-R12, PC}
    ENDFUNC
;=====================================	
DRAW_OVERLAY_SCREEN FUNCTION
	
	PUSH{R0-R12, LR}
	
	MOV R9, R10
	
	MOV R0, #120
	MOV R1, #50
	MOV R3, #340
	MOV R4, #240
	LDR R10, =GRAY
	BL DRAW_RECTANGLE_FILLED
	
	MOV R10, R9
	
	MOV R0, #40
	MOV R1, #100
	MOV R3, #80
	MOV R4, #140
	;LDR R10, =GREEN
	BL DRAW_RECTANGLE_FILLED
	
	
	
    POP {R0-R12, PC}
    ENDFUNC
;==========================================	
HOME_INTERFACE FUNCTION
	PUSH{R0-R12, LR}
	BL DRAW_OVERLAY_SCREEN
	BL DRAW_HOME_INTERFACE
	MOV R0, #40           ; X Position
	MOV R1, #100          ; Y Position
	LDR R6, =HomeIcon  ; Bitmap Address
    LDR R10, =BLACK
	BL DRAW_ICON_OP


	POP {R0-R12, PC}
	ENDFUNC
;===========================================
STOPWATCH_INTERFACE FUNCTION
	PUSH{R0-R12, LR}
	BL DRAW_OVERLAY_SCREEN
	BL DRAW_STOPWATCH_SCREEN
	MOV R0, #40           ; X Position
	MOV R1, #100          ; Y Position
	LDR R6, =Stopwatch  ; Bitmap Address
    LDR R10, =BLACK
	BL DRAW_ICON_OP
	
	
	POP {R0-R12, PC}
	ENDFUNC
	
;============================================
ALARM_INTERFACE FUNCTION
	PUSH{R0-R12, LR}
	BL DRAW_OVERLAY_SCREEN
	BL DRAW_ALARM_SCREEN
	MOV R0, #40           ; X Position
	MOV R1, #100          ; Y Position
	LDR R6, =Alarm  ; Bitmap Address
    LDR R10, =BLACK
	BL DRAW_ICON_OP
	
	
	POP {R0-R12, PC}
	ENDFUNC
;=============================================
THEMES_INTERFACE FUNCTION
	PUSH{R0-R12, LR}
	BL DRAW_OVERLAY_SCREEN
	BL DRAW_THEMES_SCREEN
	MOV R0, #40           ; X Position
	MOV R1, #100          ; Y Position
	LDR R6, =SettingIcon  ; Bitmap Address
    LDR R10, =BLACK
	BL DRAW_ICON_OP
	
	
	POP {R0-R12, PC}
	ENDFUNC
;=============================================	DRAW_GAME_SCREEN
GAMES_INTERFACE FUNCTION
	PUSH{R0-R12, LR}
	BL DRAW_OVERLAY_SCREEN
	BL DRAW_GAME_SCREEN
	MOV R0, #40           ; X Position
	MOV R1, #100          ; Y Position
	LDR R6, =JoyStiick  ; Bitmap Address
    LDR R10, =BLACK
	BL DRAW_ICON_OP
	
	
	POP {R0-R12, PC}
	ENDFUNC
;==============================================
CALCULATOR_INTERFACE FUNCTION
	PUSH{R0-R12, LR}
	BL DRAW_OVERLAY_SCREEN
	BL DRAW_CALC_SCREEN
	MOV R0, #40           ; X Position
	MOV R1, #100          ; Y Position
	LDR R6, =CalculatorIcon  ; Bitmap Address
    LDR R10, =BLACK
	BL DRAW_ICON_OP

	POP {R0-R12, PC}
	ENDFUNC

	

	

	END