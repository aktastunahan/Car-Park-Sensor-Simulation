; Pulse.s
; Routine for creating a pulse train using interrupts
; This uses Channel 0, and a 1MHz Timer Clock (_TAPR = 15 )
; Uses Timer0A to create pulse train on PF2

;Nested Vector Interrupt Controller registers
NVIC_EN0_INT19		EQU 0x00080000 ; Interrupt 19 enable
NVIC_EN0			EQU 0xE000E100 ; IRQ 0 to 31 Set Enable Register
NVIC_PRI4			EQU 0xE000E410 ; IRQ 16 to 19 Priority Register
	

	
; 16/32 Timer Registers
WTIMER1_CFG			EQU 0x40037000
WTIMER1_TAMR			EQU 0x40037004
WTIMER1_CTL			EQU 0x4003700C
WTIMER1_IMR			EQU 0x40037018
WTIMER1_RIS			EQU 0x4003701C ; Timer Interrupt Status
WTIMER1_ICR			EQU 0x40037024 ; Timer Interrupt Clear
WTIMER1_TAILR		EQU 0x40037028 ; Timer interval
WTIMER1_TAPR			EQU 0x40037038
WTIMER1_TAR			EQU	0x40037048 ; Timer register
	
;GPIO Registers, port F
GPIO_PORTF_DATA		EQU 0x40025010 ; Access BIT2
GPIO_PORTF_DIR 		EQU 0x40025400 ; Port Direction
GPIO_PORTF_AFSEL	EQU 0x40025420 ; Alt Function enable
GPIO_PORTF_DEN 		EQU 0x4002551C ; Digital Enable
GPIO_PORTF_AMSEL 	EQU 0x40025528 ; Analog enable
GPIO_PORTF_PCTL 	EQU 0x4002552C ; Alternate Functions
GPIO_PORTF_PDR		EQU	0x40025514 ; pull down resistor
GPIO_PORTF_PUR		EQU	0x40025510 ; pull down resistor
GPIO_PORTF_LOCK		EQU 0x40025520 ; unlock register
GPIO_PORTF_CR		EQU 0x40025524 ; enable register
GPIO_PORTF_IS		EQU 0x40025404
GPIO_PORTF_IBE		EQU 0x40025408
GPIO_PORTF_IEV		EQU 0x4002540C
GPIO_PORTF_RIS		EQU 0x40025414
GPIO_PORTF_ICR		EQU	0x4002541C
GPIO_PORTF_IM		EQU	0x40025410
;GPIO Registers, port C
GPIO_PORTC_DIR 		EQU 0x40006400 ; Port Direction
GPIO_PORTC_AFSEL	EQU 0x40006420 ; Alt Function enable
GPIO_PORTC_DEN 		EQU 0x4000651C ; Digital Enable
GPIO_PORTC_AMSEL 	EQU 0x40006528 ; Analog enable
GPIO_PORTC_PCTL 	EQU 0x4000652C ; Alternate Functions
GPIO_PORTC_PDR		EQU	0x40006514 ; pull down resistor
;GPIO Registers, port B
GPIO_PORTB_DATA		EQU 0x400053FC ; Access all bits
GPIO_PORTB_DATA_2   EQU 0x40005010 ; Access BIT2
GPIO_PORTB_DIR 		EQU 0x40005400 ; Port Direction
GPIO_PORTB_AFSEL	EQU 0x40005420 ; Alt Function enable
GPIO_PORTB_DEN 		EQU 0x4000551C ; Digital Enable
GPIO_PORTB_AMSEL 	EQU 0x40005528 ; Analog enable
GPIO_PORTB_PCTL 	EQU 0x4000552C ; Alternate Functions
GPIO_PORTB_PDR		EQU	0x40005514 ; pull down resistor
;System Registers
SYSCTL_RCGCGPIO 	EQU 0x400FE608 ; GPIO Gate Control
SYSCTL_RCGCTIMER 	EQU 0x400FE604 ; GPTM Gate Control
SYSCTL_RCGCWTIMER 	EQU 0x400FE65C ; GPTM Gate Control
		
NVIC_ST_CTRL 	EQU 0xE000E010
NVIC_ST_RELOAD 	EQU 0xE000E014
NVIC_ST_CURRENT EQU 0xE000E018
SHP_SYSPRI3 	EQU 0xE000ED20
; end o f the r e g i s t e r l a b e l d e f i n i t i o n s
; 0x7D0 = 4000 -> 4000*250 ns = 500mus
;RELOAD_VALUE EQU 0xFA0 
RELOAD_VALUE EQU 0x3D0900 
;*********************************************************
;---------------------------------------------------
; they should be different than each other. For %50 duty cycle, LOW=N, HIGH=N-1 can be used

LOW					EQU	0xB 
HIGH				EQU	0xA  

;---------------------------------------------------
					
			AREA 	routines, CODE, READONLY
			THUMB
			IMPORT	DELAY100
			EXPORT	TRIG_GPIO_INIT
			EXPORT	DETECT_INIT
			EXPORT TRIG
				
;---------------------------------------------------

DETECT_INIT	PROC
	
			LDR R1, =SYSCTL_RCGCGPIO ; start GPIO clock
			LDR R0, [R1]
			ORR R0, R0, #0x04 ; set bit 4 for port c
			STR R0, [R1]
			NOP ; allow clock to settle
			NOP
			NOP
			
			LDR R1, =GPIO_PORTC_DIR ; set direction of PB4
			LDR R0, [R1]
			BIC R0, #0x40 ; set bit7 for input
			STR R0, [R1]
			; Se t bi t 6 f o r a l t e r n a t e f u n c ti o n on PB6
			LDR R1, =GPIO_PORTC_AFSEL
			LDR R0, [R1]
			ORR R0, R0, #0x40
			STR R0, [R1]
			; Se t b i t s 2 7: 2 4 o f PCTL t o 7 t o e n a bl e WTIMER1A on PC6
			LDR R1, =GPIO_PORTC_PCTL
			LDR R0, [R1]
			ORR R0, #0x07000000
			STR R0, [R1]
			; c l e a r AMSEL t o d i a b l e an al o g
			LDR R1, =GPIO_PORTC_AMSEL
			LDR R0, [R1]
			BIC R0, #0x07000000
			STR R0, [R1]
			
			LDR R1, =GPIO_PORTC_DEN ; enable port digital
			LDR R0, [R1]
			ORR R0, R0, #0x40
			STR R0, [R1]
			
			LDR		R1, =GPIO_PORTC_PDR	  ; pull-up resistors to input pins
			LDR		R0, [R1]
			ORR		R0, #0x40 
			STR		R0, [R1]
			
			PUSH{LR}
			BL	DELAY100
			POP{LR}
		; Start Timer 1 clock
		; Start Timer 0 clock
		LDR R1, =SYSCTL_RCGCWTIMER
		LDR R2, [R1] ; Start timer 0
		ORR R2, R2, #0x02 ; Timer module = bit position (0)
		STR R2, [R1]
		NOP
		NOP
		NOP ; allow clock to settle
		; disable timer during setup
		LDR R1, =WTIMER1_CTL
		LDR R2, [R1]
		BIC R2, R2, #0x01 ; clear bit 0 to disable Timer 0
		STR R2, [R1]
		; set to 16bit Timer Mode
		LDR R1, =WTIMER1_CFG
		MOV R2, #0x04 ; set bits 2:0 to 0x04 for 16bit timer
		STR R2, [R1]
		; set for edge time and capture mode
		LDR R1, =WTIMER1_TAMR
		MOV R2, #0x07 ; set bit2 to 0x01 for Edge Time Mode,
		STR R2, [R1] ; set bits 1:0 to 0x03 for Capture Mode
		; set edge detection to both
		LDR R1, =WTIMER1_CTL
		LDR R2, [R1]
		ORR R2, R2, #0x0C ; set bits 3:2 to 0x03
		STR R2, [R1]
		; set start value
		LDR R1, =WTIMER1_TAILR ; counter counts down,
		MOV R0, #0xFFFFFFFF ; so start counter at max value
		STR R0, [R1]
		; Enable timer
		LDR R1, =WTIMER1_CTL ;
		LDR R2, [R1] ;
		ORR R2, R2, #0x01 ; set bit 0 to enable
		STR R2, [R1] 
		BX	LR
		ENDP
;---------------------------------------------------

TRIG_GPIO_INIT	PROC
			LDR R1, =SYSCTL_RCGCGPIO ; start GPIO clock
			LDR R0, [R1]
			ORR R0, R0, #0x20 ; set bit 5 for port F
			STR R0, [R1]
			NOP ; allow clock to settle
			NOP
			NOP
			
			LDR R1, =GPIO_PORTF_DIR ; set direction of PF2
			LDR R0, [R1]
			ORR R0, R0, #0x04 ; set bit2 for output
			STR R0, [R1]
			LDR R1, =GPIO_PORTF_AFSEL ; regular port function
			LDR R0, [R1]
			BIC R0, R0, #0x04
			STR R0, [R1]
			LDR R1, =GPIO_PORTF_PCTL ; no alternate function
			LDR R0, [R1]
			BIC R0, R0, #0x00000F00
			STR R0, [R1]
			LDR R1, =GPIO_PORTF_AMSEL ; disable analog
			LDR R0, [R1]
			BIC R0, R0, #0x00000F00
			STR R0, [R1]
			LDR R1, =GPIO_PORTF_DEN ; enable port digital
			LDR R0, [R1]
			ORR R0, R0, #0x04
			STR R0, [R1]
			BX LR
			ENDP

;---------------------------------------------------

TRIG		PROC
			PUSH{R0-R2}
			
			LDR R1, =GPIO_PORTF_DATA ; set direction of PF2
			LDR R0, [R1]
			ORR R0, #0x04
			STR R0, [R1]
			
			MOV R0, #160 ; 16MHz general clock -> 160: 10us
			MOV R2, #0
wait		CMP R2, R0
			ADDNE R2, #1
			BNE wait
			
			LDR R0, [R1]
			BIC R0, #0x04
			STR R0, [R1]
			
			POP{R0-R2}
			BX LR
			ENDP
			
					END
