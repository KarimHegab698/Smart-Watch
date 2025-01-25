	AREA MYDATA, DATA, READONLY

	
RCC_BASE EQU 0x40021000
RCC_APB2ENR EQU RCC_BASE + 0x18 
GPIOA_BASE EQU 0x40010800	
GPIOA_ODR	EQU GPIOA_BASE+0x0C   	
GPIOA_CRL	EQU GPIOA_BASE+0x00		
GPIOA_CRH   EQU GPIOA_BASE+0x04	
	
GPIOB_BASE EQU 0x40010C00	

GPIOB_ODR	EQU GPIOB_BASE+0x0C   	
GPIOB_CRL	EQU GPIOB_BASE+0x00		
GPIOB_CRH   EQU GPIOB_BASE+0x04
GPIOB_IDR   EQU GPIOB_BASE+0x08
	
GPIOB_ODR_OFF	EQU 0x0C   
GPIOB_CRL_OFF	EQU 0x00		
GPIOB_CRH_OFF   EQU 0x04	
GPIOB_IDR_OFF   EQU 0x08
;==================================RTC==========================
RCC_APB1ENR EQU RCC_BASE + 0X1C ;TO ENABLE PWREN AND BKPEN
RCC_CIR EQU RCC_BASE + 0X08     ;RCC CLOCK INTERUPT REGISTER
RCC_CSR EQU RCC_BASE + 0X024	

RCC_BDCR EQU RCC_BASE + 0X020  ;TO GET RTC SELECT
RTC_BASE EQU 0x40002800
RTC_CRL EQU RTC_BASE + 0X004
	
RTC_PRLH EQU RTC_BASE + 0X08   ;RTC PRE SCALER TO SET CLOCK TO 1HZ
RTC_PRLL EQU RTC_BASE + 0X0C
RTC_CNTL EQU RTC_BASE + 0x1C 	;LOWER RTC COUNTER
RTC_CNTH EQU RTC_BASE + 0x18	; HIGHER RTC COUNTER ;ENABLE CNF BEFORE EDITING	
	
BACKUP_REGISTERS_BKP EQU 0x40006C00
BKP_RTCCR EQU 	BACKUP_REGISTERS_BKP + 0X2C
	
POWER_CONTROL_PWR   EQU 0x40007000	
	
;============================TIME CONFIG============================
TIM2_BASE EQU 0x40000000
TIM2_PSC EQU TIM2_BASE + 0X28
TIM2_ARR EQU TIM2_BASE + 0X2C	
TIM2_SR EQU TIM2_BASE + 0X10	
TIM2_CNT EQU TIM2_BASE + 0x24
;==================================================================



;GPIOC_BASE EQU 0x40020800
;GPIOC_PUPDR EQU GPIOC_BASE + 0x0C
;GPIOC_IDR EQU GPIOC_BASE + 0x10
;===========================================================
RST_PIN EQU 8
CS_PIN EQU 9
RS_PIN EQU 10
WR_PIN EQU 11
RD_PIN EQU 12
;=========================================	
	


AFIO_BASE		EQU		0x40010000  
AFIO_MAPR	EQU		AFIO_BASE + 0x04   

INTERVAL EQU 0x186004		


;=======================COLORS=========================
;just some color codes, 16-bit colors coded in RGB 565
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
;======================================================
	




	AREA	MYCODE, CODE, READONLY
	IMPORT DRAW_BEN10_SCREEN
	IMPORT DRAW_HOME_SCREEN	
	IMPORT DRAW_INTRO_SCREEN 	
	IMPORT BOX_EXPANSION	
	IMPORT DRAW_CHAR	
	IMPORT HELLO_SCREEN	
		
	IMPORT COUNTER
	IMPORT DRAW_RECTANGLE_FILLED
	IMPORT READ_BUTTONS		
	IMPORT DRAW_NUMBERS	
	IMPORT READ_IR_BUTTONS
	IMPORT SNAKE_GAME	
	IMPORT GET_TEMPRATURE_AND_HUMIDITY_VALUE	
	IMPORT OMNITREX_SCREEN		
	IMPORT HOME_SCREEN	
	IMPORT SCREEN_MAIN
	IMPORT SCREEN_ALARM	
	IMPORT SCREEN_STOPWATCH
	IMPORT SCREEN_THEMES	
	IMPORT SCREEN_GAMES	
	IMPORT SCREEN_CALCULATOR		
	;=======================		
	EXPORT LCD_WRITE
	EXPORT LCD_COMMAND_WRITE
	EXPORT LCD_DATA_WRITE
	EXPORT delay_1_second
	EXPORT delay_half_second
	;=======================
	EXPORT __main
		
ENTRY

__main FUNCTION
	

	;This is the main funcion, you should only call two functions, one that sets up the TFT
	;And the other that draws a rectangle over the entire screen (ie from (0,0) to (320,240)) with a certain color of your choice


	;CALL FUNCTION SETUP
	BL SETUP
	
	
	
	
	BL HELLO_SCREEN
	
	LDR R10,=GREEN
	
THEME_CHANGED 
	
	MOV R1, #0
	BL OMNITREX_SCREEN
	MOV R5, #0
	
	
	;==============================
	BL HOME_SCREEN
	;==============================
MAIN_SCREEN_MAIN	
	MOV R5, #0
	BL SCREEN_MAIN
	
	
	CMP R5, #8
	BEQ MAIN_SCREEN_ALARM;ACTIONNNNNN
	;=============================NO ACTION==========================
	CMP R5, #1
	BEQ MAIN_SCREEN_MAIN
	
	CMP R5, #2
	BEQ MAIN_SCREEN_MAIN
	
	CMP R5, #4
	BEQ MAIN_SCREEN_MAIN
	
	CMP R5, #16
	BEQ MAIN_SCREEN_MAIN


	
	
	
	;==============================
MAIN_SCREEN_ALARM	
	MOV R5, #0
	BL SCREEN_ALARM
	
	CMP R5, #4
	BEQ MAIN_SCREEN_MAIN;ACTIONNNNNN
	
	CMP R5, #8
	BEQ MAIN_SCREEN_STOPWATCH;ACTIONNNNNN
	
	;=============================NO ACTION==========================
	CMP R5, #1
	BEQ MAIN_SCREEN_ALARM
	
	CMP R5, #2
	BEQ MAIN_SCREEN_ALARM
	
	CMP R5, #16
	BEQ MAIN_SCREEN_ALARM
	
	
	
	
	;===============================
MAIN_SCREEN_STOPWATCH	
	MOV R5, #0
	BL SCREEN_STOPWATCH
	
	CMP R5, #4
	BEQ MAIN_SCREEN_ALARM;ACTIONNNNNN 
	
	CMP R5, #8
	BEQ MAIN_SCREEN_THEMES;ACTIONNNNNN	
	;=============================NO ACTION==========================
	CMP R5, #1
	BEQ MAIN_SCREEN_STOPWATCH
	
	CMP R5, #2
	BEQ MAIN_SCREEN_STOPWATCH
	
	CMP R5, #16
	BEQ MAIN_SCREEN_STOPWATCH	
	
	
	
	
	;===============================
MAIN_SCREEN_THEMES	
	MOV R5, #0
	BL SCREEN_THEMES
	
	CMP R1, #1
	BEQ THEME_CHANGED
	
	CMP R5, #4
	BEQ MAIN_SCREEN_STOPWATCH;ACTIONNNNNN 
	
	CMP R5, #8
	BEQ MAIN_SCREEN_GAMES;ACTIONNNNNN 
	;=============================NO ACTION==========================
	CMP R5, #1
	BEQ MAIN_SCREEN_THEMES
	
	CMP R5, #2
	BEQ MAIN_SCREEN_THEMES
	

	
	CMP R5, #16
	BEQ MAIN_SCREEN_THEMES	
	
	
		;=========================
MAIN_SCREEN_GAMES
	MOV R5, #0
	BL SCREEN_GAMES
	
	CMP R5, #4
	BEQ MAIN_SCREEN_THEMES;ACTIONNNNNN
	
	CMP R5, #8
	BEQ MAIN_SCREEN_CALCULATOR	
	;=============================NO ACTION==========================
	CMP R5, #1
	BEQ MAIN_SCREEN_GAMES
	
	
	CMP R5, #8
	BEQ MAIN_SCREEN_GAMES
	
	CMP R5, #16
	BEQ MAIN_SCREEN_GAMES	
	


		;======================
MAIN_SCREEN_CALCULATOR
	MOV R5, #0
	BL SCREEN_CALCULATOR
	
	CMP R5, #4
	BEQ MAIN_SCREEN_GAMES;ACTIONNNNNN
	;=============================NO ACTION==========================
	CMP R5, #1
	BEQ MAIN_SCREEN_CALCULATOR
	
	CMP R5, #2
	BEQ MAIN_SCREEN_CALCULATOR
	
	
	CMP R5, #8
	BEQ MAIN_SCREEN_CALCULATOR			





	
	
	
LOOPDUMMY
	B LOOPDUMMY
	

	;BL LCD_INIT
	;FINAL TODO: DRAW THE ENTIRE SCREEN WITH A CERTAIN COLOR

	;TODO: draw egypt
	


	ENDFUNC










;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ FUNCTIONS' DEFINITIONS @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


;#####################################################################################################################################################################
LCD_WRITE FUNCTION
	;this function takes what is inside r2 and writes it to the tft
	;this function writes 8 bits only
	;later we will choose whether those 8 bits are considered a command, or just pure data
	;your job is to just write 8-bits (regardless if data or command) to PE0-7 and set WR appropriately
	;arguments: R2 = data to be written to the D0-7 bus

	;TODO: PUSH THE NEEDED REGISTERS TO SAVE THEIR CONTENTS. HINT: Push any register you will modify inside the function, and LR 
	PUSH{R0-R1, LR}
	

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SETTING WR to 0 ;;;;;;;;;;;;;;;;;;;;;
	;TODO: RESET WR TO 0
	LDR R0, =GPIOA_ODR
	LDR R1, [R0]
	BIC R1, R1,#(1<<WR_PIN)
	STR R1,[R0]
	
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	LDR R0, =GPIOA_ODR         ; Load address of GPIOA_ODR
	LDR R1, [R0]               ; Load current value of GPIOA_ODR
	BIC R1, R1, #0xFF          ; Clear bits 0-7
	ORR R1, R1, R2             ; Set the lower 8 bits of R2
	STR R1, [R0]               ; Store the new value back to GPIOA_ODR



	;;;;;;;;;;;;; HERE YOU PUT YOUR DATA which is in R2 TO PE0-7 ;;;;;;;;;;;;;;;;;
	;TODO: SET PE0-7 WITH THE LOWER 8-bits of R2
	;only write the lower byte to PE0-7

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



	;;;;;;;;;;;;;;;;;;;;;;;;;; SETTING WR to 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;TODO: SET WR TO 1 AGAIN (ie make a rising edge)
	LDR R0, =GPIOA_ODR
	LDR R1, [R0]
	ORR R1,R1,#(1<<WR_PIN)
	STR R1, [R0]
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	POP{R0-R1, PC}
	;TODO: POP THE REGISTERS YOU JUST PUSHED, and PC
	ENDFUNC
	
;#####################################################################################################################################################################











;#####################################################################################################################################################################
LCD_COMMAND_WRITE FUNCTION
	;this function writes a command to the TFT, the command is read from R2
	;it writes LOW to RS first to specify that we are writing a command not data.
	;then it normally calls the function LCD_WRITE we just defined above
	;arguments: R2 = data to be written on D0-7 bus

	;TODO: PUSH ANY NEEDED REGISTERS
	PUSH{R0-R1, LR}

	

	;;;;;;;;;;;;;;;;;;;;;;;;;; SETTING RD to 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;TODO: SET RD HIGH (we won't need reading anyways, but we must keep read pin to high, which means we will not read anything)
	LDR R0, =GPIOA_ODR
	LDR R1, [R0]
	ORR R1,R1,#(1<<RD_PIN)
	STR R1, [R0]
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



	;;;;;;;;;;;;;;;;;;;;;;;;; SETTING RS to 0 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;TODO: SET RS TO 0 (to specify that we are writing commands not data on the D0-7 bus)
	LDR R0, =GPIOA_ODR
	LDR R1, [R0]
	BIC R1, R1,#(1<<RS_PIN)
	STR R1,[R0]
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;TODO: CALL FUNCTION LCD_WRITE
	BL LCD_WRITE


	;TODO: POP ALL REGISTERS YOU PUSHED
	POP{R0-R1, PC}
	ENDFUNC

;#####################################################################################################################################################################






;#####################################################################################################################################################################
LCD_DATA_WRITE FUNCTION
	;this function writes Data to the TFT, the data is read from R2
	;it writes HIGH to RS first to specify that we are writing actual data not a command.
	;arguments: R2 = data

	;TODO: PUSH ANY NEEDED REGISTERS
	
	
	PUSH{R0-R1, LR}


	;;;;;;;;;;;;;;;;;;;;;;;;;; SETTING RD to 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;TODO: SET RD HIGH (we won't need reading anyways, but we must keep read pin to high, which means we will not read anything)
	LDR R0, =GPIOA_ODR
	LDR R1, [R0]
	ORR R1,R1,#(1<<RD_PIN)
	STR R1, [R0]
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	



	;;;;;;;;;;;;;;;;;;;; SETTING RS to 1 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;TODO: SET RS TO 1 (to specify that we are sending actual data not a command on the D0-7 bus)
	LDR R0, =GPIOA_ODR
	LDR R1, [R0]
	ORR R1,R1,#(1<<RS_PIN)
	STR R1, [R0]
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



	;TODO: CALL FUNCTION LCD_WRITE
	BL LCD_WRITE


	;TODO: POP ANY REGISTER YOU PUSHED
	POP{R0-R1, PC}
	ENDFUNC

;#####################################################################################################################################################################




; REVISE WITH YOUR TA THE LAST 3 FUNCTIONS (LCD_WRITE, LCD_COMMAND_WRITE AND LCD_DATA_WRITE BEFORE PROCEEDING)




;#####################################################################################################################################################################
LCD_INIT FUNCTION
	;This function executes the minimum needed LCD initialization measures
	;Only the necessary Commands are covered
	;Eventho there are so many more in the DataSheet

	;TODO: PUSH ANY NEEDED REGISTERS
	PUSH{R0-R12, LR}


	;;;;;;;;;;;;;;;;; HARDWARE RESET (putting RST to high then low then high again) ;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;TODO: SET RESET PIN TO HIGH
	LDR R0, =GPIOA_ODR
	LDR R1, [R0]
	ORR R1,R1,#(1<<RST_PIN)
	STR R1, [R0]


	;TODO: DELAY FOR SOME TIME (USE ANY FUNCTION AT THE BOTTOM OF THIS FILE)
	BL delay_half_second
	
	;TODO: RESET RESET PIN TO LOW
	LDR R0, =GPIOA_ODR
	LDR R1, [R0]
	BIC R1, R1,#(1<<RST_PIN)
	STR R1,[R0]

	;TODO: DELAY FOR SOME TIME (USE ANY FUNCTION AT THE BOTTOM OF THIS FILE)
	BL delay_half_second

	;TODO: SET RESET PIN TO HIGH AGAIN
	LDR R0, =GPIOA_ODR
	LDR R1, [R0]
	ORR R1,R1,#(1<<RST_PIN)
	STR R1, [R0]

	;TODO: DELAY FOR SOME TIME (USE ANY FUNCTION AT THE BOTTOM OF THIS FILE)
	BL delay_half_second
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;






	;;;;;;;;;;;;;;;;; PREPARATION FOR WRITE CYCLE SEQUENCE (setting CS to high, then configuring WR and RD, then resetting CS to low) ;;;;;;;;;;;;;;;;;;
	;TODO: SET CS PIN HIGH
	LDR R0, =GPIOA_ODR
	LDR R1, [R0]
	ORR R1,R1,#(1<<CS_PIN)
	STR R1, [R0]

	;TODO: SET WR PIN HIGH
	LDR R0, =GPIOA_ODR
	LDR R1, [R0]
	ORR R1,R1,#(1<<WR_PIN)
	STR R1, [R0]

	;TODO: SET RD PIN HIGH
	
	LDR R0, =GPIOA_ODR
	LDR R1, [R0]
	ORR R1,R1,#(1<<RD_PIN)
	STR R1, [R0]
	;TODO: SET CS PIN LOW
	LDR R0, =GPIOA_ODR
	LDR R1, [R0]
	BIC R1, R1,#(1<<CS_PIN)
	STR R1,[R0]
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	




	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SOFTWARE INITIALIZATION SEQUENCE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;ISSUE THE "SET CONTRAST" COMMAND, ITS HEX CODE IS 0xC5
	MOV R2, #0xC5 ;1100 0101
	BL LCD_COMMAND_WRITE

	;THIS COMMAND REQUIRES 2 PARAMETERS TO BE SENT AS DATA, THE VCOM H, AND THE VCOM L
	;WE WANT TO SET VCOM H TO A SPECIFIC VOLTAGE WITH CORRESPONDS TO A BINARY CODE OF 1111111 OR 0x7F HEXA
	;SEND THE FIRST PARAMETER (THE VCOM H) NEEDED BY THE COMMAND, WITH HEX 0x7F, PARAMETERS ARE SENT AS DATA BUT COMMANDS ARE SENT AS COMMANDS
	MOV R2, #0x7F ;0111 1111 0x7F
	BL LCD_DATA_WRITE

	;WE WANT TO SET VCOM L TO A SPECIFIC VOLTAGE WITH CORRESPONDS TO A BINARY CODE OF 00000000 OR 0x00 HEXA
	;SEND THE SECOND PARAMETER (THE VCOM L) NEEDED BY THE CONTRAST COMMAND, WITH HEX 0x00, PARAMETERS ARE SENT AS DATA BUT COMMANDS ARE SENT AS COMMANDS
	MOV R2, #0x00 ;00000
	BL LCD_DATA_WRITE


	;MEMORY ACCESS CONTROL AKA MADCLT | DATASHEET PAGE 127
	;WE WANT TO SET MX (to draw from left to right) AND SET MV (to configure the TFT to be in horizontal landscape mode, not a vertical screen)
	;TODO: ISSUE THE COMMAND MEMORY ACCESS CONTROL, HEXCODE 0x36
	MOV R2,#0x36 ;0011 0110
	BL LCD_COMMAND_WRITE

	;TODO: SEND ONE NEEDED PARAMETER ONLY WITH MX AND MV SET TO 1. HOW WILL WE SEND PARAMETERS? AS DATA OR AS COMMAND?
	
	MOV R2,#0x28 ;0110 0000 ;60
	BL LCD_DATA_WRITE
	
	
	;MOV R2,#0x39 ;0011 0110
	;BL LCD_COMMAND_WRITE

	;COLMOD: PIXEL FORMAT SET | DATASHEET PAGE 134
	;THIS COMMAND LETS US CHOOSE WHETHER WE WANT TO USE 16-BIT COLORS OR 18-BIT COLORS.
	;WE WILL ALWAYS USE 16-BIT COLORS
	;TODO: ISSUE THE COMMAND COLMOD
	MOV R2,#0x3A ;0011 1010
	BL LCD_COMMAND_WRITE

	;TODO: SEND THE NEEDED PARAMETER WHICH CORRESPONDS TO 16-BIT RGB AND 16-BIT MCU INTERFACE FORMAT
	
	MOV R2,#0x55 ;0101 0101
	BL LCD_DATA_WRITE
	

	;SLEEP OUT | DATASHEET PAGE 101
	;TODO: ISSUE THE SLEEP OUT COMMAND TO EXIT SLEEP MODE (THIS COMMAND TAKES NO PARAMETERS, JUST SEND THE COMMAND)
	MOV R2,#0x11 ;0001 0001
	BL LCD_COMMAND_WRITE

	;NECESSARY TO WAIT 5ms BEFORE SENDING NEXT COMMAND
	;I WILL WAIT FOR 10MSEC TO BE SURE
	;TODO: DELAY FOR AT LEAST 10ms
	
	BL delay_half_second ;half


	;DISPLAY ON | DATASHEET PAGE 109
	;TODO: ISSUE THE COMMAND, IT TAKES NO PARAMETERS
	
	MOV R2,#0x29 ;0010 1001
	BL LCD_COMMAND_WRITE

	;COLOR INVERSION OFF | DATASHEET PAGE 105
	;NOTE: SOME TFTs HAS COLOR INVERTED BY DEFAULT, SO YOU WOULD HAVE TO INVERT THE COLOR MANUALLY SO COLORS APPEAR NATURAL
	;MEANING THAT IF THE COLORS ARE INVERTED WHILE YOU ALREADY TURNED OFF INVERSION, YOU HAVE TO TURN ON INVERSION NOT TURN IT OFF.
	;TODO: ISSUE THE COMMAND, IT TAKES NO PARAMETERS
	MOV R2,#0x20 ;0010 0001
	BL LCD_COMMAND_WRITE



	;MEMORY WRITE | DATASHEET PAGE 245
	;WE NEED TO PREPARE OUR TFT TO SEND PIXEL DATA, MEMORY WRITE SHOULD ALWAYS BE ISSUED BEFORE ANY PIXEL DATA SENT
	;TODO: ISSUE MEMORY WRITE COMMAND
		
	MOV R2,#0x2C ;0010 1100
	BL LCD_COMMAND_WRITE
	
	

	;TODO: POP ALL PUSHED REGISTERS
	
	POP{R0-R12, PC}
	ENDFUNC

;#####################################################################################################################################################################






; REVISE THE FUNCTION LCD_INIT WITH YOUR TA BEFORE PROCEEDING






;#####################################################################################################################################################################

;#####################################################################################################################################################################



;#####################################################################################################################################################################

;#####################################################################################################################################################################


;	REVISE THE PREVIOUS TWO FUNCTIONS (ADDRESS_SET AND DRAW_PIXEL) WITH YOUR TA BEFORE PROCEEDING








;##########################################################################################################################################

;##########################################################################################################################################


	
;##########################################################################################################

;##########################################################################################################

;##########################################################################################################



;#####################################################################################################################################################################
SETUP FUNCTION
	;THIS FUNCTION ENABLES PORT A, MARKS IT AS OUTPUT, CONFIGURES SOME GPIO
	;THEN FINALLY IT CALLS LCD_INIT (HINT, USE THIS SETUP FUNCTION DIRECTLY IN THE MAIN)
	PUSH {R0-R12, LR}

;	;Enable GPIOA Clock
;	LDR r1, =RCC_APB2ENR
;	LDR r0, [r1]
;	MOV R2, #1
;	ORR r0, r0,r2, LSL #2
;	STR r0, [r1]
;	
;	;Enable AFIO Clock
;	LDR R1, =RCC_APB2ENR         ; Address of RCC_APB2ENR register
;    LDR R0, [R1]                 ; Read the current value of RCC_APB2ENR
;	MOV R2, #1
;    ORR R0, R0, R2        		; Set bit 0 to enable afio
;    STR R0, [R1]

	LDR R0, =RCC_APB2ENR
	ORR R2,R0,#0x0000000C
	STR R2,[R0]
	
	LDR R0,=GPIOA_BASE
	LDR R1,=GPIOB_CRL_OFF
	ADD R0,R0,R1
	MOV R2,#0x22222222
	STR R2,[R0]
	
	LDR R0,=GPIOA_BASE
	LDR R1,=GPIOB_CRH_OFF
	ADD R0,R0,R1
	MOV R2,#0x22222222
	STR R2,[R0]
	
	;
;	LDR r0, =GPIOA_CRL
;	mov r1, #0x33333333
;	STR r1, [r0]
;	
;	LDR r0, =GPIOA_CRH
;	mov r1, #0x33333333
;	STR r1, [r0]
	
	LDR R0,=GPIOB_BASE
	LDR R1,=GPIOB_CRL_OFF
	ADD R0,R0,R1
	MOV R2,#0x88888888
	STR R2,[R0]
	
	LDR R0,=GPIOB_BASE
	LDR R1,=GPIOB_CRH_OFF
	ADD R0,R0,R1
	MOV R2,#0x88888888
	STR R2,[R0]
	
	
;	;===================================RTC==================================
	LDR R0, =RCC_APB1ENR     ; RCC_APB1ENR address
	LDR R1, [R0]             ; Read current value
	MOV R2, #1
	ORR R1, R1, R2, LSL #28  ; Set PWREN (bit 28)
	STR R1, [R0]             ; Write back to RCC_APB1ENR

	
	LDR R0, =RCC_APB1ENR     ; RCC_APB1ENR address
	LDR R1, [R0]             ; Read current value
	MOV R2, #1
	ORR R1, R1, R2, LSL #27  ; Set BKPEN (bit 27)
	STR R1, [R0]             ; Write back to RCC_APB1ENR
	LDR R1,[R0]	
	
	
	LDR R0, =POWER_CONTROL_PWR
	LDR R1,[R0]
	MOV R2,#1
	ORR R1,R1,R2,LSL #8 ;set Disable backup domain write protection to  
	STR R1,[R0]           ;Access to RTC and Backup registers enabled
	LDR R1,[R0]
	
	LDR R0, =RCC_BDCR
	LDR R1, [R0]
	MOV R2, #1
	ORR R1, R1, R2, LSL #16 ; Set BDRST
	STR R1, [R0]
	LDR R1, [R0]
	AND R1,#0
	STR R1,[R0]
	
	BIC R1, R1, R2, LSL #16 ; Clear BDRST
	STR R1, [R0]
	LDR R1, [R0]
	
;	LDR R0, =RCC_BDCR
;	LDR R1,[R0]
;	mov R2,#4
;	ORR R1,R1,R2   ;SET LSEBYP
;	STR R1,[R0]
;	LDR R1,[R0]

;	
;	LDR R0, =RCC_BDCR
;	LDR R1,[R0]
;	mov R2,#1
;	ORR R1,R1,R2   ;SET LSEON
;	STR R1,[R0]
;	LDR R1,[R0]
	
	LDR R0,=RCC_CSR
	MOV R2,#1
	ORR R1,R1,R2 ; TO SET LSION TO 1
	STR R1,[R0]
	
_LSI_NOT_READY
	LDR R0,=RCC_CSR
	LDR R1,[R0]
	MOV R2,#1
	LSL R2 ,#1
	AND R2,R1
	CMP R2,#2
	BNE _LSI_NOT_READY
	
	LDR R0, =RCC_BDCR
	LDR r1,[R0]
	MOV R2,#1
	ORR R1,R1,R2,LSL #9  ;TO SET RTCSEL TO 01 LSE  ;NOW LSI
	STR R1,[R0]
	LDR R1,[R0]

	LDR R0, =RCC_BDCR
	LDR R1,[R0]
	MOV R2,#1 
	ORR R1,R1,R2,LSL #15  ;TO SET RTCEN TO 1 
	STR R1,[R0]
	LDR R1,[R0]
	
	
	LDR R0, =RTC_CRL
	LDR R1,[R0]
	MOV R2,#1
	ORR R1,R1,R2,LSL #4  ;SET CNF
	STR R1,[R0]
	
_WAIT_FOR_RTOFF0
	LDR R0, =RTC_CRL
	LDR R1,[R0]
	MOV R2, #1
	LSL R2,#5
	MOV R3,R2
	AND R2,R1
	CMP R2,R3
	BNE _WAIT_FOR_RTOFF0
	
	
	LDR R0,=RTC_PRLH
	LDR R1,[R0]
	MOV R2,#0X0
	AND R1,R2
	STR R1,[R0]
	LDR R1,[R0]
	
_WAIT_FOR_RTOFF1
	LDR R0, =RTC_CRL
	LDR R1,[R0]
	MOV R2, #1
	LSL R2,#5
	MOV R3,R2
	AND R2,R1
	CMP R2,R3
	BNE _WAIT_FOR_RTOFF1
	
	LDR R0,=RTC_PRLL
	LDR R1,[R0]
	MOV R2,#0XCFFF
	STR R2,[R0]
	LDR R2,[R0]
	
_WAIT_FOR_RTOFF2
	LDR R0, =RTC_CRL
	LDR R1,[R0]
	MOV R2, #1
	LSL R2,#5
	MOV R3,R2
	AND R2,R1
	CMP R2,R3
	BNE _WAIT_FOR_RTOFF2
	
	
	LDR R0,=RTC_CNTL
	LDR R1,[R0]
	MOV R2,#1
	AND R1,R2
	STR R1,[R0]
	LDR R1,[R0]
	
_WAIT_FOR_RTOFF3
	LDR R0, =RTC_CRL
	LDR R1,[R0]
	MOV R2, #1
	LSL R2,#5
	MOV R3,R2
	AND R2,R1
	CMP R2,R3
	BNE _WAIT_FOR_RTOFF3
		
	
	LDR R0,=RTC_CNTH
	LDR R1,[R0]
	MOV R2,#0
	AND R1,R2
	STR R1,[R0] 
	LDR R1,[R0]
	
_WAIT_FOR_RTOFF4
	LDR R0, =RTC_CRL
	LDR R1,[R0]
	MOV R2, #1
	LSL R2,#5
	MOV R3,R2
	AND R2,R1
	CMP R2,R3
	BNE _WAIT_FOR_RTOFF4
	
;	LDR R0, =RTC_CRL
;	LDR R1, [R0]
;	BIC R1, R1,#(1<<4) ;RESET CNF 
;	STR R1,[R0]
;	LDR R1,[R0]
	
_WAIT_FOR_RTOFF5
	LDR R0, =RTC_CRL
	LDR R1,[R0]
	MOV R2, #1
	LSL R2,#5
	MOV R3,R2
	AND R2,R1
	CMP R2,R3
	BNE _WAIT_FOR_RTOFF5
;	
	
;_LOOP_TO_OUT_TIME
;	LDR R0,=RTC_CNTL
;	LDR R1,[R0]
;;	
;;	
;;	LDR R2,=GPIOA_ODR
;;	MOV R4,#0						; TO OUTPUT RTC COUNT TO GPIOA
;;	LDR R4,[R2]
;;	LDR R3,[R2]
;;	
;;	MOV R3,R1
;;	STR R3,[R2]
;;	
;	B _LOOP_TO_OUT_TIME
;;====================================================================

;TIM CONFIG


	PUSH {R0-R12, LR}  ; Save registers used in this function
	LDR R0,=RCC_APB1ENR
	LDR R1,[R0]
	ORR R1,#1
	STR R1,[R0]   ; ENABLE REGISTER TIM2
	
	LDR R0,=TIM2_PSC
	LDR R1,[R0]
	MOV R1,#71
	STR R1,[R0] ;SET PRRESCALER
	
	LDR R0,=TIM2_ARR
	LDR R1,[R0]		
	LDR R1, =0X9999
	STR R1,[R0]		
	
	LDR R0,=TIM2_BASE
	LDR R1,[R0]
	ORR R1,#1
	STR R1,[R0]   ; ENABLE TIM2 TIMER	

;END TIM CONFIG
	
	
	
	
	BL LCD_INIT

	POP {R0-R12, PC}
	ENDFUNC
;#####################################################################################################################################################################






; HELPER DELAYS IN THE SYSTEM, YOU CAN USE THEM DIRECTLY


;##########################################################################################################################################
delay_1_second FUNCTION
	;this function just delays for 1 second
	PUSH {R8, LR}
	LDR r8, =INTERVAL
delay_loop
	SUBS r8, #1
	CMP r8, #0
	BGE delay_loop
	POP {R8, PC}
	ENDFUNC
;##########################################################################################################################################




;##########################################################################################################################################
delay_half_second
	;this function just delays for half a second
	PUSH {R8, LR}
	LDR r8, =INTERVAL
delay_loop1
	SUBS r8, #2
	CMP r8, #0
	BGE delay_loop1

	POP {R8, PC}
;##########################################################################################################################################


;##########################################################################################################################################
delay_milli_second
	;this function just delays for a millisecond
	PUSH {R8, LR}
	LDR r8, =INTERVAL
delay_loop2
	SUBS r8, #1000
	CMP r8, #0
	BGE delay_loop2

	POP {R8, PC}
;##########################################################################################################################################



;##########################################################################################################################################
delay_10_milli_second
	;this function just delays for 10 millisecondS
	PUSH {R8, LR}
	LDR r8, =INTERVAL
delay_loop3
	SUBS r8, #100
	CMP r8, #0
	BGE delay_loop3

	POP {R8, PC}
;##########################################################################################################################################







	END