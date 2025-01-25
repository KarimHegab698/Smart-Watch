	AREA MYDATA, DATA, READONLY
BLACK	EQU   	0x0000
BLUE 	EQU  	0x001F  ;0000 0000 0001 1111
RED  	EQU  	0xF800  ;1111 1000 0000 0000
RED2   	EQU 	0x4000
GREEN 	EQU  	0x07E0  ;0000 0111 1110 0000 
CYAN  	EQU  	0x07FF
MAGENTA EQU 	0xF81F
YELLOW	EQU  	0xFFE0
WHITE 	EQU  	0xFFFF  ;1111 1000 0001 1111 F81F
GREEN2 	EQU 	0x2FA4
CYAN2 	EQU  	0x07FF

	IMPORT CharA
	IMPORT CharB
	IMPORT CharC
	IMPORT CharE
	IMPORT CharH
	IMPORT CharI
	IMPORT CharG
	IMPORT CharL
	IMPORT CharM
	IMPORT CharN
	IMPORT CharO
	IMPORT CharP
	IMPORT CharR
	IMPORT CharS
	IMPORT CharT
	IMPORT CharU
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
		

	AREA DRAWS, CODE, READONLY

	EXPORT DRAW_CHAR
	EXPORT DRAW_RECTANGLE_FILLED	
	EXPORT DRAW_NUMBERS	
	EXPORT DRAW_ICON_OP
	EXPORT DRAW_LINE_HORIZONTAL
	EXPORT COUNTER
	EXPORT SIMPLE_ANIMATION
	EXPORT DRAW_DIGIT_PAIR
	EXPORT DRAW_CHAR_I
	EXPORT DRAW_CHAR_M
	EXPORT DRAW_ICON_OPS
	EXPORT DRAW_DIGIT_PAIR
		
	IMPORT DRAW_HOME_SCREEN
	IMPORT LCD_WRITE
	IMPORT LCD_COMMAND_WRITE
	IMPORT LCD_DATA_WRITE
	IMPORT delay_1_second
	
;================================================================		

DRAW_RECTANGLE_BORDERS FUNCTION

	PUSH {R0-R12, LR}
	;send border size in r6 and color r10

	;upper horizontal
	bl DRAW_LINE_HORIZONTAL
	
	;lower horizontal
	mov r5, r0
	sub r1, r4, r6
	bl DRAW_LINE_HORIZONTAL
	mov r1, r5
	
	;left vertical
	bl DRAW_LINE_VERTICAL
	
	;right vertical
	mov r5, r0
	sub r0, r3, r6
	bl DRAW_LINE_VERTICAL
	mov r0, r5

	POP {R0-R12, PC}
	ENDFUNC

;==================================================================	

DRAW_LINE_VERTICAL FUNCTION

	PUSH {R0-R12, LR}
		;takes y1, y2, x  r1, r4, r0
		;send border size in r6 and color r10
	mov r3, r0   
	add r3, r3,r6	;X2 = X1 + r6
	bl DRAW_RECTANGLE_FILLED

	POP {R0-R12, PC}	
	ENDFUNC

;==================================================================

DRAW_LINE_HORIZONTAL FUNCTION

	PUSH {R0-R12, LR}
			;takes x1, x2, y  r0, r3, r1
			;send border size in r6 and color r10
	mov r4, r1   
	add r4, r4, r6	;Y2 = Y1 + r6
	bl DRAW_RECTANGLE_FILLED

	POP {R0-R12, PC}
	ENDFUNC
	
;==================================================================

DRAW_RECTANGLE_FILLED FUNCTION

	PUSH {R0-R12, LR}
	
	;R0 = X1
	;R1 = Y1
	;R3 = X2
	;R4 = Y2
	
	mov r9, r1
	mov r1, r3
	mov r3, r9
	
	BL ADDRESS_SET

	sub r11, r1, r0
	ADD R11, #1
	sub r12, r4, r3
	mul r11, r11, r12
	
loop_DRAW_RECTANGLE_FILLED
	mov r5, r10, lsr #8
	mov r2, r5
	BL LCD_DATA_WRITE
	mov r2, r10
	and r2, r2, #0xFF
	BL LCD_DATA_WRITE
	
	subs r11,r11, #1

	bne loop_DRAW_RECTANGLE_FILLED

	POP {R0-R12, PC}
	ENDFUNC	
;==================================================================

DRAWPIXEL FUNCTION
	PUSH {R0-R4, r10, LR}
	;r0, r1 ==> x, y
	mov r3, r0
	mov r4, r1
	add r3, #1
	add r4, #1
	
	bl DRAW_RECTANGLE_FILLED


	
	POP {R0-R4, r10, PC}
	ENDFUNC
;==================================================================

ADDRESS_SET FUNCTION
	;THIS FUNCTION TAKES X1, X2, Y1, Y2
	;IT ISSUES COLUMN ADDRESS SET TO SPECIFY THE START AND END COLUMNS (X1 AND X2)
	;IT ISSUES PAGE ADDRESS SET TO SPECIFY THE START AND END PAGE (Y1 AND Y2)
	;THIS FUNCTION JUST MARKS THE PLAYGROUND WHERE WE WILL ACTUALLY DRAW OUR PIXELS, MAYBE TARGETTING EACH PIXEL AS IT IS.
	;R0 = X1
	;R1 = X2
	;R3 = Y1
	;R4 = Y2

	;PUSHING ANY NEEDED REGISTERS
	PUSH {R0-R12, LR}
	

	;COLUMN ADDRESS SET | DATASHEET PAGE 110
	MOV R2, #0x2A ;0010 1010
	BL LCD_COMMAND_WRITE

	;TODO: SEND THE FIRST PARAMETER (HIGHER 8-BITS OF THE STARTING COLUMN, AKA HIGHER 8-BITS OF X1)
	mov r5, r0, lsr #8  
	mov r2, r5  
	BL LCD_DATA_WRITE  
	;TODO: SEND THE SECOND PARAMETER (LOWER 8-BITS OF THE STARTING COLUMN, AKA LOWER 8-BITS OF X1)
	mov r2, r0
	BL LCD_DATA_WRITE

	
	;TODO: SEND THE THIRD PARAMETER (HIGHER 8-BITS OF THE ENDING COLUMN, AKA HIGHER 8-BITS OF X2)
	mov r5, r1, lsr #8  
	mov r2, r5  
	BL LCD_DATA_WRITE  

	
	;TODO: SEND THE FOURTH PARAMETER (LOWER 8-BITS OF THE ENDING COLUMN, AKA LOWER 8-BITS OF X2)
	mov r2, r1
	BL LCD_DATA_WRITE

	;PAGE ADDRESS SET | DATASHEET PAGE 110
	MOV R2, #0x2B ;0010 1011
	BL LCD_COMMAND_WRITE

	;TODO: SEND THE FIRST PARAMETER (HIGHER 8-BITS OF THE STARTING PAGE, AKA HIGHER 8-BITS OF Y1)
	mov r5, r3, lsr #8  
	mov r2, r5  
	BL LCD_DATA_WRITE  


	;TODO: SEND THE SECOND PARAMETER (LOWER 8-BITS OF THE STARTING PAGE, AKA LOWER 8-BITS OF Y1)
	mov r2, r3
	BL LCD_DATA_WRITE
	;TODO: SEND THE THIRD PARAMETER (HIGHER 8-BITS OF THE ENDING PAGE, AKA HIGHER 8-BITS OF Y2)
	mov r5, r4, lsr #8  
	mov r2, r5  
	BL LCD_DATA_WRITE

	;TODO: SEND THE FOURTH PARAMETER (LOWER 8-BITS OF THE ENDING PAGE, AKA LOWER 8-BITS OF Y2)
	mov r2, r4
	BL LCD_DATA_WRITE

	;MEMORY WRITE
	MOV R2, #0x2C ;0010 1100
	BL LCD_COMMAND_WRITE


	;POPPING ALL REGISTERS I PUSHED
	POP {R0-R12, PC}
	
	ENDFUNC
;==================================================================

DRAW_CHAR FUNCTION
	
    PUSH {R0-R12, LR}       ; Save registers
	mov r4, r0; x position
    
    MOV R9, #18             ; Bitmap Horizontal Length
    MOV R11, #27            ; Bitmap Vertical Length
    LDRB R5, [R6]           ; Load first byte of bitmap

draw_char_v
    MOV R9, #18             ; Reset bitmap horizontal length
    MOV R0, r4             ; Reset X position for next row

draw_char_h
    CMP R5, #0x0          ; Check if the byte is 0 (no pixel to draw)
    BEQ skip                ; Skip drawing if no pixel
    
    BL DRAWPIXEL            ; Draw the pixel
skip
    LDRB R5, [R6, #1]!      ; Load next byte and increment R6
    ADD R0, #1              ; Increment X position for the next pixel
    SUBS R9, R9, #1         ; Decrement horizontal length
    BNE draw_char_h         ; If horizontal length > 0, keep drawing

    ADD R1, #1              ; Move to the next row
    SUBS R11, R11, #1       ; Decrement vertical length
    BNE draw_char_v         ; If vertical length > 0, keep drawing

    POP {R0-R12, PC}        ; Restore registers and return
	ENDFUNC

;==============================================

DRAW_CHAR_I FUNCTION
	
    PUSH {R0-R12, LR}       ; Save registers
	mov r4, r0; x position
    
    MOV R9, #12             ; Bitmap Horizontal Length
    MOV R11, #27            ; Bitmap Vertical Length
    LDRB R5, [R6]           ; Load first byte of bitmap

draw_char_vI
    MOV R9, #12             ; Reset bitmap horizontal length
    MOV R0, r4             ; Reset X position for next row

draw_char_hI
    CMP R5, #0x0          ; Check if the byte is 0 (no pixel to draw)
    BEQ skipI                ; Skip drawing if no pixel
    
    BL DRAWPIXEL            ; Draw the pixel
skipI
    LDRB R5, [R6, #1]!      ; Load next byte and increment R6
    ADD R0, #1              ; Increment X position for the next pixel
    SUBS R9, R9, #1         ; Decrement horizontal length
    BNE draw_char_hI         ; If horizontal length > 0, keep drawing

    ADD R1, #1              ; Move to the next row
    SUBS R11, R11, #1       ; Decrement vertical length
    BNE draw_char_vI         ; If vertical length > 0, keep drawing

    POP {R0-R12, PC}        ; Restore registers and return
	ENDFUNC

;============================

DRAW_CHAR_M FUNCTION
	
    PUSH {R0-R12, LR}       ; Save registers
	mov r4, r0; x position
    
    MOV R9, #24             ; Bitmap Horizontal Length
    MOV R11, #27            ; Bitmap Vertical Length
    LDRB R5, [R6]           ; Load first byte of bitmap

draw_char_vM
    MOV R9, #24             ; Reset bitmap horizontal length
    MOV R0, r4             ; Reset X position for next row

draw_char_hM
    CMP R5, #0x0          ; Check if the byte is 0 (no pixel to draw)
    BEQ skipM                ; Skip drawing if no pixel
    
    BL DRAWPIXEL            ; Draw the pixel
skipM
    LDRB R5, [R6, #1]!      ; Load next byte and increment R6
    ADD R0, #1              ; Increment X position for the next pixel
    SUBS R9, R9, #1         ; Decrement horizontal length
    BNE draw_char_hM         ; If horizontal length > 0, keep drawing

    ADD R1, #1              ; Move to the next row
    SUBS R11, R11, #1       ; Decrement vertical length
    BNE draw_char_vM         ; If vertical length > 0, keep drawing

    POP {R0-R12, PC}        ; Restore registers and return
	ENDFUNC


;============================
COUNTER FUNCTION

	PUSH {R0-R12, LR}
;	
;	mov r0, #0
;	mov r1, #0
;	mov r3, #320
;	mov r4, #240
;	ldr r10,=BLACK
;	bl DRAW_RECTANGLE_FILLED
;	
;	
;	mov r5, #0
;	;bl DRAW_BEN10_SCREEN
;	mov r0 , #50
;	mov r1, #50
;	ldr r10,=GREEN
;	mov r7, #0
;	
;	
;loop_TESTBUTTONSTFT	
;	
;	bl READ_BUTTONS
;	cmp r5, #1
;	beq TESTTTT


;	b loop_TESTBUTTONSTFT	
;	
;TESTTTT	
;	mov r3, #0
;	mov r4, #0
;	add r3, r0, #17
;	add r4, r1,#29
;	ldr r10, =BLACK 
;	bl DRAW_RECTANGLE_FILLED
;	ldr r10,=GREEN
;	bl DRAW_NUMBERS
;	mov r5, #0
;	add r7,r7 ,#1
;	b loop_TESTBUTTONSTFT
;	
	
	
	POP {R0-R12, PC}
	ENDFUNC

;============================
DRAW_NUMBERS FUNCTION
	PUSH {R0-R12, LR}
	;receive the number in R7
	;receive R0  X Postion
	;receive R1 Y Postion
	;receive R10 color 
	cmp r7, #0
	beq DRAW_0_DRAW_NUMBERS
	
	cmp r7, #1
	beq DRAW_1_DRAW_NUMBERS
	
	cmp r7, #2
	beq DRAW_2_DRAW_NUMBERS
	
	cmp r7, #3
	beq DRAW_3_DRAW_NUMBERS
	
	cmp r7, #4
	beq DRAW_4_DRAW_NUMBERS
	
	cmp r7, #5
	beq DRAW_5_DRAW_NUMBERS
	
	cmp r7, #6
	beq DRAW_6_DRAW_NUMBERS
	
	cmp r7, #7
	beq DRAW_7_DRAW_NUMBERS
	
	cmp r7, #8
	beq DRAW_8_DRAW_NUMBERS
	
	cmp r7, #9
	beq DRAW_9_DRAW_NUMBERS
	
	b ret_DRAW_NUMBERS
	

DRAW_0_DRAW_NUMBERS
	ldr r6,=Char0
	bl DRAW_CHAR
	b ret_DRAW_NUMBERS
	
DRAW_1_DRAW_NUMBERS
	ldr r6,=Char1
	bl DRAW_CHAR
	b ret_DRAW_NUMBERS
	
DRAW_2_DRAW_NUMBERS
	ldr r6,=Char2
	bl DRAW_CHAR
	b ret_DRAW_NUMBERS
	
DRAW_3_DRAW_NUMBERS
	ldr r6,=Char3
	bl DRAW_CHAR
	b ret_DRAW_NUMBERS
	
DRAW_4_DRAW_NUMBERS
	ldr r6,=Char4
	bl DRAW_CHAR
	b ret_DRAW_NUMBERS
	
DRAW_5_DRAW_NUMBERS
	ldr r6,=Char5
	bl DRAW_CHAR
	b ret_DRAW_NUMBERS
	
DRAW_6_DRAW_NUMBERS
	ldr r6,=Char6
	bl DRAW_CHAR
	b ret_DRAW_NUMBERS
	
DRAW_7_DRAW_NUMBERS
	ldr r6,=Char7
	bl DRAW_CHAR
	b ret_DRAW_NUMBERS
	
DRAW_8_DRAW_NUMBERS
	ldr r6,=Char8
	bl DRAW_CHAR
	b ret_DRAW_NUMBERS
	
DRAW_9_DRAW_NUMBERS
	ldr r6,=Char9
	bl DRAW_CHAR
	b ret_DRAW_NUMBERS
	

ret_DRAW_NUMBERS
	
	POP {R0-R12, PC}
	ENDFUNC 

;============================

DRAW_DIGIT_PAIR FUNCTION
    ; Draw two digits from R2 (Hours, Minutes, or Seconds)
    ; Input:
    ; - R2: Value to draw (0-59 or 0-23)
    ; - R0, R1: Current X, Y Position
    ; - R10: Color

    PUSH {R0-R12, LR}          ; Save registers and return address
    MOV R5, R2                 ; Copy value into R5

    ; Calculate Tens Digit
    MOV R6, #10                ; Load 10 into R6
    SDIV R2, R5, R6            ; R2 = R5 / 10 (Tens digit)
    MLS R5, R2, R6, R5         ; R5 = R5 - (R2 * 10), calculate modulus (Units digit)

    ; Draw Tens Digit
    MOV R7, R2                 ; Load Tens digit into R7 (to pass to DRAW_NUMBERS)
    BL DRAW_NUMBERS            ; Call DRAW_NUMBERS
    ADD R0, R0, #20            ; Move X Position

    ; Draw Units Digit
    MOV R7, R5                 ; Load Units digit into R7 (to pass to DRAW_NUMBERS)
    BL DRAW_NUMBERS            ; Call DRAW_NUMBERS
    ADD R0, R0, #26            ; Move X Position

    POP {R0-R12, PC}           ; Restore registers and return

	ENDFUNC
;==========================

SIMPLE_ANIMATION FUNCTION
	
		PUSH {R0-R12, LR} 
		
		MOV R0, #150
		MOV R1, #150
		MOV R3, #200
		MOV R4, #178
		LDR R10, =BLACK
		BL DRAW_RECTANGLE_FILLED
	
		MOV R0, #180            ; X Position
    	MOV R1, #150            	; Y Position
    	LDR R6, =Char0         	; Bitmap Address
    	LDR R10, =GREEN
		bl DRAW_CHAR
		
		bl delay_1_second
		bl delay_1_second
		bl delay_1_second
		bl delay_1_second
		
		MOV R0, #150
		MOV R1, #150
		MOV R3, #200
		MOV R4, #178
		LDR R10, =BLACK
		BL DRAW_RECTANGLE_FILLED
		
		
		MOV R0, #180           ; X Position
    	MOV R1, #150           	; Y Position
    	LDR R6, =Char1         	; Bitmap Address
    	LDR R10, =GREEN
		bl DRAW_CHAR
		
		POP {R0-R12, PC}

		
		ENDFUNC
;==================	

DRAW_ICON_OP FUNCTION
    ; R0 - X position
    ; R1 - Y position
    ; R6 - Pointer to bitmap data
    ; R10 - Color
    PUSH {R0-R12, LR}       ; Save registers
    MOV R4, R0              ; Store initial X position
    MOV R9, #40             ; Bitmap horizontal length (width)
    MOV R11, #40            ; Bitmap vertical length (height)

draw_icon_v_OP
    MOV R9, #40             ; Reset horizontal length for each row
    MOV R0, R4              ; Reset X position for the new row

draw_icon_h_OP
    LDRB R5, [R6]           ; Load the current byte of the bitmap
    MOV R8, #7              ; Initialize bit index (start from MSB)

process_bits_OP
    MOV R7, R5, LSR R8      ; Shift right to bring the target bit to LSB
    AND R7, R7, #1          ; Mask out all but the least significant bit
    CMP R7, #0              ; Check if the bit is set (1)
    BEQ skip_pixel_OP          ; Skip if the bit is not set

    BL DRAWPIXEL            ; Call DRAWPIXEL to draw the pixel

skip_pixel_OP
    ADD R0, #1              ; Move to the next X position
    SUBS R8, R8, #1         ; Move to the next bit (decrement index)
    BPL process_bits_OP        ; Repeat for all bits in the byte

    ADD R6, #1              ; Move to the next byte in the bitmap
    SUBS R9, R9, #8         ; Decrement horizontal length by 8 (processed 8 pixels)
    BGT draw_icon_h_OP         ; If horizontal length > 0, keep processing

    ADD R1, #1              ; Move to the next row
    SUBS R11, R11, #1       ; Decrement vertical length
    BNE draw_icon_v_OP         ; If vertical length > 0, continue drawing

    POP {R0-R12, PC}        ; Restore registers and return
	ENDFUNC

;====================================================================


DRAW_VAN FUNCTION
	
    PUSH {R0-R12, LR}       ; Save registers
	mov r4, r0; x position
    
    MOV R9, #40            ; Bitmap Horizontal Length
    MOV R11, #40            ; Bitmap Vertical Length
    LDRB R5, [R6]           ; Load first byte of bitmap

draw_icon_vVan
    MOV R9, #40           ; Reset bitmap horizontal length
    MOV R0, r4             ; Reset X position for next row

draw_icon_hVan
    CMP R5, #0x0          ; Check if the byte is 0 (no pixel to draw)
    BEQ skip_Van                ; Skip drawing if no pixel
    
    BL DRAWPIXEL            ; Draw the pixel
skip_Van
    LDRB R5, [R6, #1]!      ; Load next byte and increment R6
    ADD R0, #1              ; Increment X position for the next pixel
    SUBS R9, R9, #1         ; Decrement horizontal length
    BNE draw_icon_hVan         ; If horizontal length > 0, keep drawing

    ADD R1, #1              ; Move to the next row
    SUBS R11, R11, #1       ; Decrement vertical length
    BNE draw_icon_vVan         ; If vertical length > 0, keep drawing

    POP {R0-R12, PC}        ; Restore registers and return
	ENDFUNC

;=====================================================================
DRAW_ICON_OPS FUNCTION
    ; R0 - X position
    ; R1 - Y position
    ; R6 - Pointer to bitmap data
    ; R10 - Color
    PUSH {R0-R12, LR}       ; Save registers
    MOV R4, R0              ; Store initial X position
    MOV R9, #20             ; Bitmap horizontal length (width)
    MOV R11, #20            ; Bitmap vertical length (height)

draw_icon_v_OPS
    MOV R9, #20             ; Reset horizontal length for each row
    MOV R0, R4              ; Reset X position for the new row

draw_icon_h_OPS
    LDRB R5, [R6]           ; Load the current byte of the bitmap
    MOV R8, #7              ; Initialize bit index (start from MSB)

process_bits_OPS
    MOV R7, R5, LSR R8      ; Shift right to bring the target bit to LSB
    AND R7, R7, #1          ; Mask out all but the least significant bit
    CMP R7, #0              ; Check if the bit is set (1)
    BEQ skip_pixel_OPS          ; Skip if the bit is not set

    BL DRAWPIXEL            ; Call DRAWPIXEL to draw the pixel

skip_pixel_OPS
    ADD R0, #1              ; Move to the next X position
    SUBS R8, R8, #1         ; Move to the next bit (decrement index)
    BPL process_bits_OPS        ; Repeat for all bits in the byte

    ADD R6, #1              ; Move to the next byte in the bitmap
    SUBS R9, R9, #8         ; Decrement horizontal length by 8 (processed 8 pixels)
    BGT draw_icon_h_OPS         ; If horizontal length > 0, keep processing

    ADD R1, #1              ; Move to the next row
    SUBS R11, R11, #1       ; Decrement vertical length
    BNE draw_icon_v_OPS         ; If vertical length > 0, continue drawing

    POP {R0-R12, PC}        ; Restore registers and return
	ENDFUNC


;====================================================================



	END	