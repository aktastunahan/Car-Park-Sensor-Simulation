	AREA main, CODE, READONLY
	THUMB

	IMPORT	TRIG_GPIO_INIT
	IMPORT  TRIG
	IMPORT	DETECT_INIT	
	IMPORT	My_WTimer0A_Handler
	IMPORT  InitSysTick
	IMPORT  PRINT_INFO
	IMPORT	DELAY100
		
	IMPORT  INIT_TIMER0A
	IMPORT  INIT_MOTOR_GPIO
	IMPORT  SWITCH_INIT
		
	IMPORT  ST_CTRL
	IMPORT  PWM_INIT
	IMPORT  AIN0_INIT
	IMPORT  DTOA
		
	IMPORT  SPI_INIT
	IMPORT  INIT_SCREEN
		
		
	EXPORT	__main	
	ALIGN
		
GPIO_PORTB_DATA		EQU 0x400053FC ; Access 
WTIMER1_TAR			EQU	0x40037048 ; Timer register
WTIMER1_RIS			EQU 0x4003701C ; Timer Interrupt Status
WTIMER1_TAPR		EQU 0x40037038
WTIMER1_CTL			EQU 0x4003700C
WTIMER1_ICR			EQU 0x40037024 ; Timer Interrupt Clear
WTIMER0_CTL			EQU 0x4003600C
WTIMER0_IMR			EQU 0x40036018
WTIMER0_TAILR		EQU 0x40036028 ; Timer interval
WTIMER0_ICR			EQU 0x40036024 ; Timer Interrupt Clear	
;GPIO Registers, port F
GPIO_PORTF_DATA		EQU 0x400253FC ; Access BIT2
GPIO_PORTF_DIR 		EQU 0x40025400 ; Port Direction
GPIO_PORTF_AFSEL	EQU 0x40025420 ; Alt Function enable
GPIO_PORTF_DEN 		EQU 0x4002551C ; Digital Enable
GPIO_PORTF_AMSEL 	EQU 0x40025528 ; Analog enable
GPIO_PORTF_PCTL 	EQU 0x4002552C ; Alternate Functions
GPIO_PORTF_IS		EQU 0x40025404
GPIO_PORTF_IBE		EQU 0x40025408
GPIO_PORTF_IEV		EQU 0x4002540C
GPIO_PORTF_RIS		EQU 0x40025414
GPIO_PORTF_ICR		EQU	0x4002541C
	
; ADC
ADC_SSFIFO3			EQU	0x400380A8 ; result of adc
ADC_PSSI			EQU 0x40038028 ; software trigger
ADC_RIS				EQU	0x40038004 ; wathch interrupt
TIMER1_TBMATCHR		EQU	0x40031034 ; Timer 1B Match	
PNT					EQU	0x20000600 ; address of the decimal equivalent of the digit	

; SysTick control
NVIC_ST_CTRL 	EQU 0xE000E010
NVIC_ST_RELOAD 	EQU 0xE000E014
NVIC_ST_CURRENT EQU 0xE000E018
SHP_SYSPRI3 	EQU 0xE000ED20
RELOAD_VALUE    EQU 0x00080000
	
__main		PROC
		BL		DETECT_INIT				; HC sensor distance calculation timer init
		BL		TRIG_GPIO_INIT			; HC sensor trigger init
		BL		SWITCH_INIT				; Switch (1&2) GPIO init
		BL 		AIN0_INIT				; analog init
		BL 		PWM_INIT				; pwm init
		BL		SPI_INIT				; SPI config
		BL		INIT_SCREEN				; screen init commands
		BL		INIT_MOTOR_GPIO			; initialize GPIO
		BL		INIT_TIMER0A			; Timer0A for motor
		BL		InitSysTick				; initialize SysTick
		CPSIE	I
		
; register initializations
		MOV		R6, #0x00		; state registe
		MOV 	R8, #101		; treshold register
		MOV		R9, #0			; distance register

begin	BL		ST_CTRL			; state transitions	
; normal operation, threshold setting or preventative braking
st_ctl	CMP		R10, #1
		BNE		st_c
		BL		PRINT_INFO
		MOV		R10, #0

st_c	CMP		R6, #0x00		
		BEQ		normal
		CMP     R6, #0x01
		BEQ		tresh
		CMP     R6, #0x10
		BEQ		break
	
; ******************* NORMAL STATE ******************* ; 
; ***** motor part ***** ; 	
normal	LDR R1, =WTIMER0_IMR
		LDR R0, [R1]
		CMP R0, #0 	   ; if the motor is stopped and we are in normal state, speed-up
		BNE	sens
		
		LDR R1, =GPIO_PORTF_DATA	; off the brake led
		LDR R0, [R1]
		BIC R0, #0x02
		STR  R0, [R1]
		
		BL		INIT_TIMER0A			; Timer0A for motor
; ***** distance sensor part ***** ; 	
sens	BL		TRIG
		LDR R1, =WTIMER1_CTL ;
		LDR R2, [R1] ;
		ORR R2, R2, #0x01 ; set bit 0 to enable
		STR R2, [R1] 
		LDR R1, =WTIMER1_RIS
		
			;----------read first edge----------
			
loop 	LDR R2, [R1] ; pool timer0 count flag
		AND R2, #4 ; isolate CAERIS bit
		CMP	R2, #0
		BEQ loop ; if no capture, then loop
		
		LDR R1, =WTIMER1_ICR
		LDR R2, [R1]
		ORR R2, #04		; clear CAERIS
		STR R2, [R1]
		
		LDR R1, =WTIMER1_TAR ; address of timer register
		LDR R0, [R1] ; Get timer register value
		
		; R0 --> first edge (we know posedge)
;----------read second edge----------
		LDR R1, =WTIMER1_RIS
loop2 	LDR R2, [R1]
		AND R2, #4 ; isolate CAERIS bit
		CMP	R2, #0
		BEQ loop2 ; if no capture, then loop
		
		LDR R1, =WTIMER1_ICR
		LDR R2, [R1]
		ORR R2, #04		; clear CAERIS
		STR R2, [R1]
		
		LDR R1, =WTIMER1_TAR ; address of timer register
		LDR R4, [R1] ; Get timer register value

		; R4 --> second edge (we know negedge)

;----------calculations----------		
		LDR R1, =WTIMER1_CTL ;
		LDR R2, [R1] ;
		BIC R2, R2, #0x01 ; set bit 0 to enable
		STR R2, [R1] 
		
		SUB R4, R0, R4
		LSL R2, R4, #6		; R4 = R4*64
		SUB R2, R4, LSL #1	; R2 -= 2*R4			
		ADD R2, R4, LSR #1	; R2 += 0.5*R4
		
		LDR R4, =100000
		UDIV R2, R4		
		
		LSL R9, R2, #4 ; R9 = 16*R2
		ADD	R9, R2	   ; 17*R12
		
		LDR R4, =999
		CMP R9, R4
		MOVGE R9, R4
		
		CMP R9, R8	   ; treshold checking
		BGE	begin	   ; treshold is not exceeded. continue
		
		MOV R6, #0x10 ; if treshold is exceeded, go to breaking state
		; stop the motor here
		
		B		begin
; ******************* TRESHOLD SETTING STATE ******************* ; 
tresh		LDR R5, =PNT
			; start sampling signal
sample		LDR R1, =ADC_PSSI
			LDR R0, [R1]
			ORR R0, #0x08 ; set 3th bit 
			STR R0, [R1]

			LDR R1, =ADC_RIS
pool		LDR R0, [R1]
			ANDS R0, #0x08 ; Extract bit3
			BEQ pool	   ; if Z flag is set, bit3 is 0, meaning ADC not finished
			
			LDR R1, =ADC_SSFIFO3 ; get the result from FIFO
			LDR R4, [R1]
			
			BL DTOA     ; digital to analog (3.30-0.00) 
			
			LDR R1, =TIMER1_TBMATCHR ; determines low level periode for inverted pwm
			MOV	R2, #329
			SUB R2, R4
			STR R2, [R1]
			
			ADD		R8, R4, #21
			B		begin
			
; ******************* BRAKE OFF STATE ******************* ;		
break		
			LDR R1, =GPIO_PORTF_DATA	; off the brake led
			MOV R0, #0x00
			STR  R0, [R1]

			B 		begin ; only wait
			ENDP
			END
				
