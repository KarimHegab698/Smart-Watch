	AREA MYDATA, DATA, READONLY
	

GPIOA_BASE EQU 0x40010800
GPIOA_ODR	EQU GPIOA_BASE+0x0C	

GPIOB_BASE EQU 0x40010C00
GPIOB_IDR   EQU GPIOB_BASE+0x08	

RTC_BASE EQU 0x40002800
RTC_CNTL EQU RTC_BASE + 0x1C 	
	
INTERVAL EQU 0x186004		
		
	AREA RTC, CODE, READONLY
	
		
;============================================================================		
CLOSE_BUZZER FUNCTION
	PUSH {R0-R12, LR}
	
	LDR R0,=GPIOA_ODR
	LDR R1,[R0]
	BIC R1,R1,#1	;RESET BUZER
	STR R1,[R0]
	
	POP {R0-R12, PC}
	ENDFUNC
;============================================================================
TOGGLE_BUZZER FUNCTION
	PUSH {R0-R12, LR}

	LDR R0,=GPIOA_ODR
	LDR R1,[R0]
	AND R2,R1,#1
	CMP R2,#1
	BNE BUZZER_IS_NOT_SET
	
	LDR R0,=GPIOA_ODR
	LDR R1,[R0]
	BIC R1,R1,#1	;RESET BUZER
	STR R1,[R0]
	B FINISH_RESET_BUZZER
	
BUZZER_IS_NOT_SET	

	LDR R0,=GPIOA_ODR
	LDR R1,[R0]
	ORR R1,R1,#1	;SET BUZZER
	STR R1,[R0]
	
FINISH_RESET_BUZZER

	POP {R0-R12, PC}
	ENDFUNC
;=============================================================================
ALARM FUNCTION ;;;;;;;;;;;;;need to be modified after integration
	
;ALARM FUNCTION TAKES ;R10 DURATION ; R9 RTC_TIME ; R8 BUZZER_COUNTER 
	PUSH {R0-R12, LR} ;need to be checked 
	

	MOV R10,#10
	LDR R0,=RTC_CNTL
	LDR R9,[R0]

	MOV R8,#0XF



_TIME_NOT_REACHED
	LDR R0,=RTC_CNTL
	LDR R1,[R0]
	SUB R1,R1,R9
	CMP R1,R10
	BLT _TIME_NOT_REACHED
	BL TOGGLE_BUZZER
	
BIG_LOOP	
	
	SUB R8,#1
	CMP R8,#0
	BNE NO_TOGGLE
	LDR R8,=INTERVAL
	
	BL TOGGLE_BUZZER
	
	LDR R0,=GPIOB_IDR
	LDR R1,[R0]
	AND R2,R1,#1
	CMP R2,#1
	BEQ EXIT_TIMER
	
	
NO_TOGGLE	
	
	
	

	B BIG_LOOP

EXIT_TIMER
	BL CLOSE_BUZZER 	
	
	
	POP {R0-R12, PC}
	ENDFUNC






















;=============================================================================


	END