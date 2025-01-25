	AREA MYDATA, DATA, READONLY
	
	
GPIOB_BASE EQU 0x40010C00
GPIOB_IDR_OFF EQU 0x08 
	
IR_RIGHT_PIN EQU 14
IR_LEFT_PIN EQU 15	
IR_UP_PIN EQU 10
IR_DOWN_PIN EQU 11	
	
	
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
	






	AREA BUTTONS, CODE, READONLY	
	EXPORT READ_BUTTONS
	EXPORT READ_IR_BUTTONS
	EXPORT GET_READINGS	
		
		
		
		
		
		
		
		
;==================================NOTES===================================
;values stored in R5
;left  #1
;right #2
;up    #4
;down  #8
;ok    #16     decimel


;=====================================================================
CHECK_LEFT FUNCTION
	
	PUSH{r4,LR}
	
	CHECK_PIN GPIOB_BASE,GPIOB_IDR_OFF,#1
	CMP R4,#0x00000002
	BEQ BUSY_LEFT
	B SKIP_LEFT
BUSY_LEFT
		CHECK_PIN GPIOB_BASE,GPIOB_IDR_OFF,#1
		CMP R4,#0x00000002
		BEQ BUSY_LEFT
	MOV R5,#1
SKIP_LEFT

	POP{r4, PC}

	ENDFUNC
;###############################################################################################################################################################
CHECK_RIGHT FUNCTION
	
	PUSH{r4, LR}
	
	CHECK_PIN GPIOB_BASE,GPIOB_IDR_OFF,#7
	CMP R4,#0x00000080
	BEQ BUSY_RIGHT
	B SKIP_RIGHT
BUSY_RIGHT
		CHECK_PIN GPIOB_BASE,GPIOB_IDR_OFF,#7
		CMP R4,#0x00000080
		BEQ BUSY_RIGHT
	MOV R5,#2
SKIP_RIGHT

	POP{r4, PC}

	ENDFUNC
;#####################################################################################################################################################3
CHECK_UP FUNCTION
	
	PUSH{r4, LR}
	
	CHECK_PIN GPIOB_BASE,GPIOB_IDR_OFF,#4
	CMP R4,#0x00000010
	BEQ BUSY_UP
	B SKIP_UP
BUSY_UP
		CHECK_PIN GPIOB_BASE,GPIOB_IDR_OFF,#4
		CMP R4,#0x00000010
		BEQ BUSY_UP
	MOV R5,#4
SKIP_UP

	POP{r4, PC}

	ENDFUNC
;#####################################################################################################################################################################3
CHECK_DOWN FUNCTION
	
	PUSH{r4, LR}
	
	CHECK_PIN GPIOB_BASE,GPIOB_IDR_OFF,#5
	CMP R4,#0x00000020
	BEQ BUSY_DOWN
	B SKIP_DOWN
BUSY_DOWN
		CHECK_PIN GPIOB_BASE,GPIOB_IDR_OFF,#5
		CMP R4,#0x00000020
		BEQ BUSY_DOWN
	MOV R5,#8
SKIP_DOWN

	POP{r4, PC}
	
	ENDFUNC
;############################################################################################################################################################
CHECK_OK FUNCTION
	
	PUSH{r4, LR}
	
	CHECK_PIN GPIOB_BASE,GPIOB_IDR_OFF,#6
	CMP R4,#0x00000040
	BEQ BUSY_OK
	B SKIP_OK
BUSY_OK
		CHECK_PIN GPIOB_BASE,GPIOB_IDR_OFF,#6
		CMP R4,#0x00000040
		BEQ BUSY_OK
	MOV R5,#16
SKIP_OK

	POP{r4, PC}
	
	ENDFUNC
	
;####################################################################################################################################################################
READ_BUTTONS FUNCTION
	
	PUSH{r0-r4, LR}
	
	BL CHECK_LEFT
	BL CHECK_RIGHT
	BL CHECK_UP
	BL CHECK_DOWN
	BL CHECK_OK
	
	POP{r0-r4, PC}
	
	ENDFUNC



;=====================================================================
READ_IR_BUTTONS FUNCTION
	PUSH{R0-R4, LR}	
	BL CHECK_IR_RIGHT_INPUTS
	CMP R4,#0x00004000
	beq BUSY_2_LEFT_BUTTON   ;from right to left 


	BL CHECK_IR_LEFT_INPUTS
	CMP R4,#0x00008000
	beq BUSY_2_RIGHT_BUTTON  ;from left to right 
	
	BL CHECK_IR_UP_INPUTS
	CMP R4,#0x00000400
	beq BUSY_2_DOWN_BUTTON   ;from up to down 


	BL CHECK_IR_DOWN_INPUTS
	CMP R4,#0x00000800
	beq BUSY_2_UP_BUTTON  ;from down to up 
;	
	
	
	b ret_READ_IR_BUTTONS

	
	;========================
BUSY_2_LEFT_BUTTON 
	BL CHECK_IR_RIGHT_INPUTS
	CMP R4,#0x00004000
	bne ASSIST_ret_READ_IR_BUTTONS

	BL CHECK_IR_LEFT_INPUTS
	CMP R4,#0x00008000
	beq BUSY_3_LEFT_BUTTON 
	
	b BUSY_2_LEFT_BUTTON 



;==============================
BUSY_3_LEFT_BUTTON 	
	BL CHECK_IR_RIGHT_INPUTS
	CMP R4,#0x00004000
	bne BUSY_4_LEFT_BUTTON 
	
	BL CHECK_IR_LEFT_INPUTS
	CMP R4,#0x00008000
	bne BUSY_2_LEFT_BUTTON	
	
	
	b BUSY_3_LEFT_BUTTON

;=========================
BUSY_4_LEFT_BUTTON 
	BL CHECK_IR_RIGHT_INPUTS
	CMP R4,#0x00004000
	beq BUSY_3_LEFT_BUTTON 
	
	BL CHECK_IR_LEFT_INPUTS
	CMP R4,#0x00008000
	bne LEFT_SUCCESS	

	b BUSY_4_LEFT_BUTTON
;	
;;========================


;=========================

LEFT_SUCCESS
	mov r5, #1
ASSIST_ret_READ_IR_BUTTONS	
	b ret_READ_IR_BUTTONS
	
;;;=======================	
;;========================
BUSY_2_RIGHT_BUTTON 
	BL CHECK_IR_LEFT_INPUTS
	CMP R4,#0x00008000
	bne ret_READ_IR_BUTTONS
	
	BL CHECK_IR_RIGHT_INPUTS
	CMP R4,#0x00004000
	beq BUSY_3_RIGHT_BUTTON 
	
	b BUSY_2_RIGHT_BUTTON 



;==============================
BUSY_3_RIGHT_BUTTON 	
	BL CHECK_IR_LEFT_INPUTS
	CMP R4,#0x00008000
	bne BUSY_4_RIGHT_BUTTON 
	
	BL CHECK_IR_RIGHT_INPUTS
	CMP R4,#0x00004000
	bne BUSY_2_RIGHT_BUTTON	
	
	
	b BUSY_3_RIGHT_BUTTON

;=========================
BUSY_4_RIGHT_BUTTON 
	BL CHECK_IR_LEFT_INPUTS
	CMP R4,#0x00008000
	beq BUSY_3_RIGHT_BUTTON 
	
	BL CHECK_IR_RIGHT_INPUTS
	CMP R4,#0x00004000
	bne RIGHT_SUCCESS	

	b BUSY_4_RIGHT_BUTTON




RIGHT_SUCCESS
	mov r5,#2
	b ret_READ_IR_BUTTONS
	
	
;================================
;================================
BUSY_2_DOWN_BUTTON 
	BL CHECK_IR_UP_INPUTS
	CMP R4,#0x00000400
	bne ret_READ_IR_BUTTONS
	
	BL CHECK_IR_DOWN_INPUTS
	CMP R4,#0x00000800
	beq BUSY_3_DOWN_BUTTON 
	
	b BUSY_2_DOWN_BUTTON 



;==============================
BUSY_3_DOWN_BUTTON 	
	BL CHECK_IR_UP_INPUTS
	CMP R4,#0x00000400
	bne BUSY_4_DOWN_BUTTON 
	
	BL CHECK_IR_DOWN_INPUTS
	CMP R4,#0x00000800
	bne BUSY_2_DOWN_BUTTON	
	
	
	b BUSY_3_DOWN_BUTTON

;=========================
BUSY_4_DOWN_BUTTON 
	BL CHECK_IR_UP_INPUTS
	CMP R4,#0x00000400
	beq BUSY_3_DOWN_BUTTON 
	
	BL CHECK_IR_DOWN_INPUTS
	CMP R4,#0x00000800
	bne DOWN_SUCCESS	

	b BUSY_4_DOWN_BUTTON
;	
;;========================


;=========================

DOWN_SUCCESS
	mov r5, #8
	b ret_READ_IR_BUTTONS
	
	
	
;===========================
;===========================
BUSY_2_UP_BUTTON 
	BL CHECK_IR_DOWN_INPUTS
	CMP R4,#0x00000800
	bne ret_READ_IR_BUTTONS
	
	BL CHECK_IR_UP_INPUTS
	CMP R4,#0x00000400
	beq BUSY_3_UP_BUTTON 
	
	b BUSY_2_UP_BUTTON 



;==============================
BUSY_3_UP_BUTTON 	
	BL CHECK_IR_DOWN_INPUTS
	CMP R4,#0x00000800
	bne BUSY_4_UP_BUTTON 
	
	BL CHECK_IR_UP_INPUTS
	CMP R4,#0x00000400
	bne BUSY_2_UP_BUTTON	
	
	
	b BUSY_3_UP_BUTTON

;=========================
BUSY_4_UP_BUTTON 
	BL CHECK_IR_DOWN_INPUTS
	CMP R4,#0x00000800
	beq BUSY_3_UP_BUTTON 
	
	BL CHECK_IR_UP_INPUTS
	CMP R4,#0x00000400
	bne UP_SUCCESS	

	b BUSY_4_DOWN_BUTTON




UP_SUCCESS
	mov r5,#4
	b ret_READ_IR_BUTTONS


;=========================
ret_READ_IR_BUTTONS
;========================


	POP{R0-R4, PC}		
	ENDFUNC
;==========================================

	
	
;==========================================
CHECK_IR_RIGHT_INPUTS FUNCTION
	PUSH{R0-R3, LR}
	LDR R0,=GPIOB_BASE
	LDR R1,=GPIOB_IDR_OFF
	ADD R0,R1,R0
	LDR R4,[R0] 
	MOV R3,#1
	LSL R3,R3,IR_RIGHT_PIN
	MVN R3, R3
	orr R4,R3
	MVN R4, R4

	POP{R0-R3, PC}	
	ENDFUNC
;===========================================		
CHECK_IR_LEFT_INPUTS FUNCTION
	PUSH{R0-R3, LR}
	LDR R0,=GPIOB_BASE
	LDR R1,=GPIOB_IDR_OFF
	ADD R0,R1,R0
	LDR R4,[R0] 
	MOV R3,#1
	LSL R3,R3,IR_LEFT_PIN
	MVN R3, R3
	orr R4,R3
	MVN R4, R4

	POP{R0-R3, PC}	
	ENDFUNC		
		
;===========================================
CHECK_IR_UP_INPUTS FUNCTION
	PUSH{R0-R3, LR}
	LDR R0,=GPIOB_BASE
	LDR R1,=GPIOB_IDR_OFF
	ADD R0,R1,R0
	LDR R4,[R0] 
	MOV R3,#1
	LSL R3,R3,IR_UP_PIN
	MVN R3, R3
	orr R4,R3
	MVN R4, R4

	POP{R0-R3, PC}	
	ENDFUNC	
;=============================================
CHECK_IR_DOWN_INPUTS FUNCTION
	PUSH{R0-R3, LR}
	LDR R0,=GPIOB_BASE
	LDR R1,=GPIOB_IDR_OFF
	ADD R0,R1,R0
	LDR R4,[R0] 
	MOV R3,#1
	LSL R3,R3,IR_DOWN_PIN
	MVN R3, R3
	orr R4,R3
	MVN R4, R4
	POP{R0-R3, PC}	
	ENDFUNC	
;=====================
GET_READINGS FUNCTION
	PUSH{LR}
	MOV R5, #0
	BL READ_BUTTONS
	CMP R5, #0
	BNE SKIP_READINGS
	
	BL READ_IR_BUTTONS	
SKIP_READINGS
	
	
	POP{PC}
	ENDFUNC


		
		
		
		
		
		
		
		
		
		
	END	