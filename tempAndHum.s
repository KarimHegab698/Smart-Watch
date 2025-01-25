	AREA MYDATA, DATA, READONLY
GPIOB_BASE  EQU 0x40010C00	        ;Base of port B
GPIOB_ODR	EQU GPIOB_BASE+0x0C   	;output register of port E, PE0 - PE15
GPIOB_IDR	EQU GPIOB_BASE+0x08   	;output register of port E, PE0 - PE15
GPIOB_CRL	EQU GPIOB_BASE+0x00		;this is where you configure the port's direction as output
GPIOB_CRH   EQU GPIOB_BASE+0x04

GPIOB_IDR_OFF	EQU 0x08   				;output register of port E, PE0 - PE15

RCC_BASE EQU 0x40021000
RCC_APB2ENR EQU RCC_BASE + 0x18 ;this register is responsible for enabling certain ports, by making the clock affect the target port.
RCC_APB1ENR EQU RCC_BASE + 0x1C
	
PIN_B9 EQU 9           ;used to send start bit & receive ack bit and 40 data bits
OUT_DATA_TFT_PIN EQU 4 ; used to send 40 data bits to tft screen to be displayed
	
INTERVAL EQU 0x186004		;just a number to perform the delay. this number takes roughly 1 second to decrement until it reaches 0


POWER_CONTROL_PWR EQU 0x40007000
TIM2_BASE EQU 0x40000000
TIM2_PSC EQU TIM2_BASE + 0X28
TIM2_ARR EQU TIM2_BASE + 0X2C	
TIM2_SR EQU TIM2_BASE + 0X10	
TIM2_CNT EQU TIM2_BASE + 0x24	
	
	MACRO 
	CHECK_PIN $BASE_ADDRESS,$OFFSET,$PIN_NUMBER
	LTORG
	LDR R0,=$BASE_ADDRESS
	LDR R1,=$OFFSET
	ADD R0,R1,R0
	LDR R4,[R0] ;OFFSET FOR OUTPUT DATA REGISTER(ODR)
	MOV R3,#1
	LSL R3,R3,$PIN_NUMBER
	AND R4,R3
	MEND
		
		
	AREA TEMPANDHUM, CODE, READONLY
	EXPORT GET_TEMPRATURE_AND_HUMIDITY_VALUE ;sends the values in r12	
;============================================================================	

START_SIGNAL FUNCTION
	;Blue Pill send a start signal to sensor using PB5
	
	PUSH {R0-R12, LR}
	;PIN_B12 is set as OUTPUT from setup
	;RESET START_PIN TO 0 to send start signal
	LDR R0, =GPIOB_ODR
	LDR R1, [R0]
	BIC R1, R1,#(1<<PIN_B9)
	STR R1,[R0]
	
	LDR R0, =GPIOB_CRH          ; Load the address of GPIOB_CRH
	LDR R1, [R0]                ; Read the current value of GPIOB_CRH
	BIC R1, R1, #(0xF << 4)     ; Clear CNF and MODE bits for PB9 (bits 4–7)
	ORR R1, R1, #(0x3 << 4)     ; Set MODE to 11 (50 MHz) and CNF to 00 (push-pull)
	STR R1, [R0]  
	
;	MOV R5, #0x4650 18MILLISECOND
	LDR R5 , =0x4650
;	bl delay_of_choice 

	LDR R0,=TIM2_CNT
	LDR R1,[R0]
	MOV R1,#0
	STR R1,[R0]
	

_TIME_NOT_REACHED_START_SIGNAL_0	
	LDR R0,=TIM2_CNT
	LDR R1,[R0]
	CMP R1,R5
	BNE _TIME_NOT_REACHED_START_SIGNAL_0
	
	;SET START_PIN TO 1
	LDR R0,=GPIOB_ODR
	ORR R1,R1,#(1<<PIN_B9)
	STR R1, [R0]
	
;	MOV R5, #0x28,25 micro
	LDR R5 , =0x1E
	;bl delay_of_choice 
	
	LDR R0,=TIM2_CNT
	LDR R1,[R0]
	MOV R1,#0
	STR R1,[R0]
	

_TIME_NOT_REACHED_START_SIGNAL_1
	LDR R0,=TIM2_CNT
	LDR R1,[R0]
	CMP R1,R5
	BNE _TIME_NOT_REACHED_START_SIGNAL_1
	
	POP {R0-R12, PC}
	ENDFUNC
;========================================
DHT11_ACK FUNCTION
    PUSH {R0-R10, r12, LR}
    
    ; Set PB12 as Input Pin (MODE - CNF) to receive ack from sensor
	MOV R4, #0                  ; Initialize R4 (optional, unrelated to PB9 configuration)
	LDR R0, =GPIOB_CRH          ; Load the address of GPIOB_CRH
	LDR R1, [R0]                ; Read the current value of GPIOB_CRH
	BIC R1, R1, #(0xF << 4)     ; Clear CNF and MODE bits for PB9 (bits 4–7)
	ORR R1, R1, #(0x8 << 4)     ; Set MODE to 11 (50 MHz) and CNF to 00 (push-pull)
	STR R1, [R0]  

	LDR R0,=TIM2_CNT
	LDR R1,[R0]
	MOV R1 , #0
	STR R1, [R0]  
	LDR R8 , =0x1388 
	
WAIT_LOW_ACK
	LDR R1,[R0]
	CMP R1 , R8
	BGE LOOOOOOOOOOOOOOOOOP1
	;mov R4 , #0
	bl CHECK_INPUT_INVERTED
	CMP R4, #0x00000200
    BNE WAIT_LOW_ACK       ; Loop until PB9 goes LOW
    ; Wait for PB12 to go HIGH (DHT11 pulls line high for 80µs)
	LDR R1,[R0]
	MOV R4, #0
;	
;	LDR R1,[R0]
;	MOV R1 , #0
;	STR R1, [R0]  
	mov R9 , #0
WAIT_HIGH_ACK
	LDR R0,=TIM2_CNT
	LDR R1,[R0]
	CMP R1 , R8
	BGE LOOOOOOOOOOOOOOOOOP1
	CHECK_PIN GPIOB_BASE,GPIOB_IDR_OFF,PIN_B9
	CMP R4, #0x00000200
    BNE WAIT_HIGH_ACK      ; Loop until PB9 goes HIGH
	mov r11, #1
	b cooooooooooooooooooooont
LOOOOOOOOOOOOOOOOOP1
	LDR R1,[R0]
	mov r11,#0

cooooooooooooooooooooont	
    POP {R0-R10, r12, PC}
    ENDFUNC
;=================================================
DHT11_DATA FUNCTION ; Sending Data to blue pill on PB3
	
    PUSH    {R0-R10, LR}            ; Save registers
	CMP r11, #0
	beq ret_DHT11_DATA
    ;MOV     R2, #0                 ; Clear R2 (to store lower 32 bits)
    ;MOV     R3, #0                 ; Clear R3 (to store upper 8 bits)
    MOV     R7, #40                ; Set loop counter (40 bits)
	MOV 	R12 , #0

	

	
READ_BIT

	; Wait for PB12 to go LOW (start of the bit)
WAIT_LOW_DATA
    bl CHECK_INPUT_INVERTED
	CMP R4,#0x00000200
    BNE     WAIT_LOW_DATA          ; Loop until PB12 goes LOW
	; ok
    ; Wait for PB12 to go HIGH
	CMP R7, #40
	BEQ SKIP_DHT11_DATA
	
	CMP R7, #8
	BEQ skip_to_break
	
	LDR R0,=TIM2_CNT
	LDR R1,[R0]
	
	CMP R1 , #30
	BLT _IF_VALUE_ZERO
	BGE _IF_VALUE_ONE
	
_IF_VALUE_ZERO
	;CMP R7, #8
;	BLE SKIP_TO_ZERO_OF_CHECK
	ADD R12 ,R12 ,#0
    LSL R12,R12, #1
	B CONT
;SKIP_TO_ZERO_OF_CHECK
;	ADD R11 ,R11 ,#0
;    LSL R11,R11, #1
;	B CONT
	
_IF_VALUE_ONE
	;CMP R7, #8
;	BLE SKIP_TO_ONE_OF_CHECK
	ADD R12 ,R12 ,#1
    LSL R12,R12, #1
;	B CONT
;SKIP_TO_ONE_OF_CHECK
;	ADD R11 ,R11 ,#1
;    LSL R11,R11, #1
	
	
CONT
	
	
SKIP_DHT11_DATA	
WAIT_HIGH_DATA

    CHECK_PIN GPIOB_BASE,GPIOB_IDR_OFF,PIN_B9
	CMP R4, #0x00000200
    BNE     WAIT_HIGH_DATA         ; Loop until PB12 goes HIGH
	
	LDR R0,=TIM2_CNT
	MOV R1,#0
	STR R1,[R0]  ;RESET TIM COUNTER
	LDR R1,[R0]

;	mov r4 , r4
	
	SUBS    R7, R7, #1             ; Decrement loop counter
    BNE     READ_BIT  
    ;LSR R11,R11, #1

skip_to_break
	mov r1,#0
;	mov r4 , r4
	
    ; Measure the HIGH duration
;    BL      Measure_High_Width     ; Call a function to measure HIGH duration
;    CMP     R6, #50                ; Compare duration to threshold (50us)
;    MOVHI   R1, #1                 ; If HIGH > 50us, it's a 1
;    MOVLS   R1, #0                 ; If HIGH <= 50us, it's a 0

;    ; Store the bit into R2 or R3
;    CMP     R4, #33                ; Check if storing in upper 8 bits (R3)
;    MOVGE   R3, R3, LSL #1         ; Shift upper bits in R3 to the left
;    ORRGE   R3, R3, R1             ; Append the new bit (R1) to R3
;    MOVLT   R2, R2, LSL #1         ; Shift lower bits in R2 to the left
;    ORRLT   R2, R2, R1             ; Append the new bit (R1) to R2

;    ; Decrement the bit counter
;    SUBS    R4, R4, #1             ; Decrement loop counter
;    BNE     READ_BIT               ; Repeat if more bits to read
ret_DHT11_DATA
    POP     {R0-R10, PC}            ; Restore registers and return
    ENDFUNC
;====================================================
CHECK_INPUT_INVERTED FUNCTION
    PUSH{R0-R3, LR}
    LDR R0,=GPIOB_BASE
    LDR R1,=GPIOB_IDR_OFF
    ADD R0,R1,R0
    LDR R4,[R0] 
    MOV R3,#1
    LSL R3,R3,PIN_B9
    MVN R3, R3
    orr R4,R3
    MVN R4, R4

    POP{R0-R3, PC}
    ENDFUNC
;===================================================
delay_of_choice FUNCTION
	
	; put the delay you want in R5 in micro seconds
    
	PUSH {R0-R12, LR}  ; Save registers used in this function
	
	LDR R0,=TIM2_CNT
	LDR R1,[R0]
	MOV R1,#0
	STR R1,[R0]
	

_TIME_NOT_REACHED	
	LDR R0,=TIM2_CNT
	LDR R1,[R0]
	CMP R1,R5
	BNE _TIME_NOT_REACHED
	
	MOV R1,#0
	STR R1,[R0]
	
    POP {R0-R12, PC}  ; Restore registers and return
ENDFUNC
;====================================================
delay_one_ms FUNCTION
	
	PUSH    {R0-R12, LR}
	LDR R0,=RCC_APB1ENR
	LDR R1,[R0]
	ORR R1,#1
	STR R1,[R0]   ; ENABLE TIM2
	
	LDR R0,=TIM2_PSC
	LDR R1,[R0]
	MOV R1,#72
	STR R1,[R0] ;SET PRRESCALER
	
	LDR R0,=TIM2_ARR
	LDR R1,[R0]
	MOV R1,#1000
	STR R1,[R0] ;SET PRRESCALER

	LDR R0, =TIM2_BASE
	LDR R1, [r0]
	ORR R1, #1
	STR R1, [R0]

CHECK_UIF
	LDR R0,=TIM2_SR
	LDR R1,[R0]
	MOV R2,#0
	AND R2,R1,#1
	CMP R2,#1
	BNE CHECK_UIF
	
	POP     {R0-R12, PC}
	
	ENDFUNC
;==================================================	
GET_TEMPRATURE_AND_HUMIDITY_VALUE FUNCTION
	PUSH {R0-R10, LR}
	MOV R12,#0
;	MOV R11,#0
;	MOV R2, #0
;	MOV R3, #0	
_TRY_AGAIN	
	bl START_SIGNAL
	bl DHT11_ACK
	bl DHT11_DATA
	;MOV R8,R12
	MOV R0, #0
	; temprature check
	LDR R9,=0XFF00
	AND R9 ,R12
	CMP R9,#0X0A00
	BLT _TRY_AGAIN
	CMP R9,#0X2800
	BGT _TRY_AGAIN
	; humidity check
	LDR R9,=0xFF000000
	AND R9 ,R12
	CMP R9,#0x1E000000
	BLT _TRY_AGAIN
	CMP R9,#0x46000000
	BGT _TRY_AGAIN
	
	BL SEPERATE_TEMP_HUM
	
	POP {R0-R10, PC}
	ENDFUNC
;==========================================	
CONVERSION_HEXA_DECIMEL_TEMP FUNCTION
	PUSH {R0-R11, LR}	
	mov r1, R12
    mov r4, #0
    cmp r1, #0
    beq return
    mov r0, r1
    mov r5, #0    ;counter
    mov r6, #10 
    mov r7, #0  ;remainder 
    mov r8, r1  ;Qoutient
    mov r9, #0 ;temp
    mov r10, #8

first
    mov r7, #0 
    udiv r8, r8, r6
    mls r7, r8, r6, r0 ;r7 = r0 - (r8 * r6)
    mov r0, r8
    cmp r7, #0
    beq reverse
    push {r7}
    add r5, #1
    sub r10, #1
    cmp r0, #0
    bne first
    ;MOV R3,#1
reverse 
    pop {r9}
    add r4, r9
    ROR r4, r4, #4
    sub r5, #1
    cmp r5, #0
    bne reverse

    cmp r10, #0
    beq return


finish
    ROR r4, r4, #4
    sub r10, #1
    cmp r10, #0
    bne finish

return

    MOV R10,R4
    MOV R12,#0
Loop_hex
    AND R8, R10,#0x0F
    ADD R12,R8,R12
    LSL R12,#4
    LSR R10,#4
    CMP R10,#0
    bne Loop_hex
    LSR R12,#4

	POP {R0-R11, PC}
	ENDFUNC
;============================================================================
SEPERATE_TEMP_HUM FUNCTION
	PUSH {R0-R10, LR}
	LSR R12, #8
	
	MOV R11, #0
	
	AND R11, R12, #0XFF ;R11 STORES TEMP
	
	LSR R12, #16 ;R12 STORES HUMADITY
	
	BL CONVERSION_HEXA_DECIMEL_TEMP
	
	MOV R8, R12
	MOV R12, R11
	BL CONVERSION_HEXA_DECIMEL_TEMP
	MOV R11, R12
	MOV R12, R8
	
	

	
	
	POP {R0-R10, PC}
	ENDFUNC














;=============================================================================


	END