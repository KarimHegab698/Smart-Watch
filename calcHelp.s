	AREA MY_CALCULATOR_DATA, DATA, READONLY



	AREA SNAKE_CODE, CODE, READONLY
	IMPORT DRAW_NUMBERS
	EXPORT HANDLE_RESULT
;--------------------------------------------------------------
CONVERSION_HEXA_DECIMEL FUNCTION
	PUSH {R0-R11, LR}	
	mov r1, R12
    mov r4, #0
    cmp r1, #0
    beq return55
    mov r0, r1
    mov r5, #0    ;counter
    mov r6, #10 
    mov r7, #0  ;remainder 
    mov r8, r1  ;Qoutient
    mov r9, #0 ;temp
    mov r10, #8

first55
    mov r7, #0 
    udiv r8, r8, r6
    mls r7, r8, r6, r0 ;r7 = r0 - (r8 * r6)
    mov r0, r8
    cmp r7, #0
    beq reverse55
    push {r7}
    add r5, #1
    sub r10, #1
    cmp r0, #0
    bne first55
    ;MOV R3,#1
reverse55
    pop {r9}
    add r4, r9
    ROR r4, r4, #4
    sub r5, #1
    cmp r5, #0
    bne reverse55

    cmp r10, #0
    beq return55


finish55
    ROR r4, r4, #4
    sub r10, #1
    cmp r10, #0
    bne finish55

return55

    MOV R10,R4
    MOV R12,#0
Loop_hex55
    AND R8, R10,#0x0F
    ADD R12,R8,R12
    LSL R12,#4
    LSR R10,#4
    CMP R10,#0
    bne Loop_hex55
    LSR R12,#4

	POP {R0-R11, PC}
	ENDFUNC
;##############################################################
	

;--------------------------------------------------------------
HANDLE_RESULT FUNCTION
	PUSH{R0-R12, LR}
	BL CONVERSION_HEXA_DECIMEL	
		
	MOV R7, #0
	AND R7, R12, #0X0F
	;LDR R10 ,=BLACK 
	MOV R0, #220
	MOV R1, #125
	BL DRAW_NUMBERS
	
	LSR R12, #4
	
	MOV R7, #0
	AND R7, R12, #0X0F
	;LDR R10 ,=BLACK 
	MOV R0, #200
	MOV R1, #125
	BL DRAW_NUMBERS
	
	POP{R0-R12, PC}
	ENDFUNC
;##############################################################
	END