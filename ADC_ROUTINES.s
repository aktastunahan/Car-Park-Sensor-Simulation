; System Registers
SYSCTL_RCGCGPIO 	EQU 0x400FE608 ; GPIO Gate Control
SYSCTL_RCGCADC 		EQU 0x400FE638 ; ADC Gate Control
SYSCTL_RCGCTIMER 	EQU 0x400FE604 ; GPTM Gate Control
	
; GPIO Registers, port F
GPIO_PORTF_DATA		EQU 0x40025010 ; Access BIT2
GPIO_PORTF_DIR 		EQU 0x40025400 ; Port Direction
GPIO_PORTF_AFSEL	EQU 0x40025420 ; Alt Function enable
GPIO_PORTF_DEN 		EQU 0x4002551C ; Digital Enable
GPIO_PORTF_AMSEL 	EQU 0x40025528 ; Analog enable
GPIO_PORTF_PCTL 	EQU 0x4002552C ; Alternate Functions
GPIO_PORTF_PDR		EQU	0x40025514 ; pull down resistor
GPIO_PORTF_PUR		EQU	0x40025510 ; pull down resistor

; GPIO Registers, port E
GPIO_PORTE_DATA		EQU 0x40024010 ; Access BIT2
GPIO_PORTE_DIR 		EQU 0x40024400 ; Port Direction
GPIO_PORTE_AFSEL	EQU 0x40024420 ; Alt Function enable
GPIO_PORTE_DEN 		EQU 0x4002451C ; Digital Enable
GPIO_PORTE_AMSEL 	EQU 0x40024528 ; Analog enable
GPIO_PORTE_PCTL 	EQU 0x4002452C ; Alternate Functions
GPIO_PORTE_PDR		EQU	0x40024514 ; pull down resistor
GPIO_PORTE_PUR		EQU	0x40024510 ; pull down resistor
	
; Timer 1B registers
TIMER1_CFG			EQU 0x40031000 ; Timer Configuration
TIMER1_CTL			EQU 0x4003100C ; Timer Control
TIMER1_TBMR			EQU 0x40031008 ; Timer 1B Mode
TIMER1_TBILR		EQU 0x4003102C ; Timer 1B Interval
TIMER1_TBMATCHR		EQU	0x40031034 ; Timer 1B Match
	
; ADC Registers
ADC_ACTSS			EQU	0x40038000 ; sequencer contor
ADC_EMUX			EQU	0x40038014 ; event select register
ADC_SSMUX3			EQU	0x400380A0 ; for sequencer3 select ATD channel
ADC_SSCTL3			EQU 0x400380A4 ; control register for sequencer3
ADC_PC				EQU 0x40038FC4
ADC_PSSI			EQU 0x40038028 ; software trigger
ADC_RIS				EQU	0x40038004 ; wathch interrupt
ADC_ISC				EQU 0x4003800C
ADC_SSFIFO3			EQU	0x400380A8 ; result of ADC
; *******************************	
PNT					EQU	0x20000600 ; address of the decimal equivalent of the digit
; *******************************	
	

	IMPORT OutStr
	IMPORT CONVRT
	IMPORT DELAY100
	IMPORT INIT_MEM
	EXPORT PWM_INIT
	EXPORT AIN0_INIT
	EXPORT DTOA


	AREA sdata , DATA, READONLY
	THUMB
MSG0 				DCB			"0,0"
					DCB			0x04
MSG1				DCB			"0,"
					DCB			0x04
	AREA 	routines, CODE, READONLY
	THUMB
;--------------------------------------------------------------------
PWM_INIT proc ; for ADC. Green led
	;===================
	; Configure PORTF.2
	;===================
			LDR R1, =SYSCTL_RCGCGPIO ; start GPIO clock
			LDR R0, [R1]
			ORR R0, R0, #0x20 ; set bit 6 for port F
			STR R0, [R1]
			NOP ; allow clock to settle
			NOP
			NOP
			
			LDR R1, =GPIO_PORTF_DIR ; set direction of PF3
			LDR R0, [R1]
			ORR R0, #0x08 ; set bit3 for input
			STR R0, [R1]
			; Se t bi t 6 f o r a l t e r n a t e f u n c ti o n on PF3
			LDR R1, =GPIO_PORTF_AFSEL
			LDR R0, [R1]
			ORR R0, R0, #0x08
			STR R0, [R1]
			; Se t b i t s 2 7: 2 4 o f PCTL t o 7 t o e n a bl e TIMER1A on PF3
			LDR R1, =GPIO_PORTF_PCTL
			LDR R0, [R1]
			ORR R0, #0x00007000
			STR R0, [R1]
			; c l e a r AMSEL t o d i a b l e an al o g
			LDR R1, =GPIO_PORTF_AMSEL
			BIC R0, #0x08
			STR R0, [R1]
			
			LDR R1, =GPIO_PORTF_DEN ; enable port digital
			LDR R0, [R1]
			ORR R0, R0, #0x08
			STR R0, [R1]
			
			LDR		R1, =GPIO_PORTF_PUR	  ; pull-up resistors to input pins
			ORR		R0, #0x08 
			STR		R0, [R1]
	
	PUSH{LR}
	BL DELAY100
	POP{LR}
	;====================
	; Configure TIMER1-B
	;====================
	; Start Timer 1 clock
		LDR R1, =SYSCTL_RCGCTIMER
		LDR R2, [R1] ; Start timer 1
		ORR R2, R2, #0x02 ; Timer module = bit position (1)
		STR R2, [R1]
		NOP
		NOP
		NOP ; allow clock to settle
		; disable timer during setup
		LDR R1, =TIMER1_CTL
		LDR R2, [R1]
		BIC R2, R2, #0x100 ; clear bit 0 to disable Timer 1 
		STR R2, [R1]
		; set to 16bit Timer Mode
		LDR R1, =TIMER1_CFG
		MOV R2, #0x04 ; set bits 2:0 to 0x04 for 16bit timer
		STR R2, [R1]
		; set for edge time and capture mode
		LDR R1, =TIMER1_TBMR ; [3]->1, [2]->0, [1,0]->2 1010
		MOV R2, #0x0A 
		STR R2, [R1] 
		; set start value
		LDR R1, =TIMER1_TBILR ; counter counts down,
		MOV R0, #330 ; 
		STR R0, [R1]
		; set match value
		LDR R1, =TIMER1_TBMATCHR ; determines low level periode for inverted pwm
		MOV R0, #200
		STR R0, [R1]
			
		LDR R1, =TIMER1_CTL
		LDR R2, [R1]
		ORR R2, R2, #0x100 ; set bit8 to enable
		STR R2, [R1] ; and bit 1 to stall on debug
	bx lr
	endp
;--------------------------------------------------------------------	
; ******************************************************************************
AIN0_INIT proc
	;===================
	; Configure ADC and GPIO clocks
	;===================
			LDR R1, =SYSCTL_RCGCADC ; start ADC clock
			LDR R0, [R1]
			ORR R0, R0, #0x01 ; Enable and provide a clock to ADC module 0 in Run mode.
			STR R0, [R1]
			
			LDR R1, =SYSCTL_RCGCGPIO ; start GPIO clock
			LDR R0, [R1]
			ORR R0, R0, #0x10 ; set bit 5 for port E
			STR R0, [R1]
			NOP ; allow clock to settle
			NOP
			NOP
	;===================
	; Configure PORTE.3
	;===================
			; Set PE3 as input
			LDR R1, =GPIO_PORTE_DIR ; set direction of PE3 to input
			LDR R0, [R1]
			BIC R0, #0x08 ; set bit3 for input
			STR R0, [R1]
			; Set bit 3 for alternate function on PE3
			LDR R1, =GPIO_PORTE_AFSEL
			LDR R0, [R1]
			ORR R0, R0, #0x08
			STR R0, [R1]
			; Clear bits 11:8  of PCTL to enable AIN0
			LDR R1, =GPIO_PORTE_PCTL
			LDR R0, [R1]
			BIC R0, #0xF000 ; clear for PE3 analog function
			STR R0, [R1]
			; Set AMSEL to enable analog
			LDR R1, =GPIO_PORTE_AMSEL
			LDR R0, [R1]
			ORR R0, #0x08
			STR R0, [R1]
			; Disable digital
			LDR R1, =GPIO_PORTE_DEN
			LDR R0, [R1]
			BIC R0, #0x08
			STR R0, [R1]

	;===================
	; Configure AIN0
	;===================

			; Disable sequencer 3
			LDR R1, =ADC_ACTSS
			LDR R0, [R1]
			BIC R0, #0x08 ; clear 3th bit 
			STR R0, [R1]
			; Select sampling
			LDR R1, =ADC_EMUX
			LDR R0, [R1]
			BIC R0, #0xF000 ; clear bits 15:12 to select for ss3
			STR R0, [R1]
			; Select ATD channel 0 for sample sequencer 3
			LDR R1, =ADC_SSMUX3
			LDR R0, [R1]
			BIC R0, #0x0F ; clear bits 3:0 to select AIN0
			STR R0, [R1]
			; Interrupt configuration
			LDR R1, =ADC_SSCTL3
			LDR R0, [R1]
			BIC R0, #0x0F
			ORR R0, #0x06 ; set IE0 and END0 bits
			STR R0, [R1]
			; Select sampling rate
			LDR R1, =ADC_PC
			LDR R0, [R1]
			BIC R0, #0x0F ; clear 3:0 bits
			ORR R0, #0x01 ; 125 ksps
			STR R0, [R1]
			; Ensable sequencer 3
			LDR R1, =ADC_ACTSS
			LDR R0, [R1]
			ORR R0, #0x08 ; set 3th bit 
			STR R0, [R1]
			BX	LR
			ENDP
; ******************************************************************************				
DTOA		PROC
			;=========================================================
			; takes 12 bit digital input in range (0-4095)
			; converts it to analog signal in range (000-330)
			; input: R4 output: R4
			;=========================================================
			PUSH{R3, LR}
			; first, multiply the number by 330
			MOV R3, R4, LSL #8 ; R5 = R4*256
			ADD R3, R4, LSL #6 ; R5 += R4*64
			ADD R3, R4, LSL #3 ; R5 += R4*8
			ADD R3, R4, LSL #1 ; R5 += R4*2
			; R3 = R4*(256+64+8+2) = R4*330
			MOV R4, R3, LSR #12        ; R4 = R3/4096
			POP{R3, LR}
			BX LR
			ENDP
; ******************************************************************************				

			 END