; nvic registers
NVIC_ST_CTRL 	EQU 0xE000E010
NVIC_ST_RELOAD 	EQU 0xE000E014
NVIC_ST_CURRENT EQU 0xE000E018
NVIC_PRI23		EQU 0xE000E45C
NVIC_EN2 		EQU 0xE000E108
SHP_SYSPRI3 	EQU 0xE000ED20
RELOAD_VALUE    EQU 0x00080000

; 16/32 Timer Registers
WTIMER0_CFG			EQU 0x40036000
WTIMER0_TAMR		EQU 0x40036004
WTIMER0_CTL			EQU 0x4003600C
WTIMER0_IMR			EQU 0x40036018
WTIMER0_RIS			EQU 0x4003601C ; Timer Interrupt Status
WTIMER0_ICR			EQU 0x40036024 ; Timer Interrupt Clear
WTIMER0_TAILR		EQU 0x40036028 ; Timer interval
WTIMER0_TAPR		EQU 0x40036038
WTIMER0_TAR			EQU	0x40036048 ; Timer register
WTIMER0_MATCHR      EQU	0x40036030
	
; GPIO Registers, port P
GPIO_PORTB_DATA		EQU		0x400053FC
GPIO_PORTB_DIR		EQU		0x40005400
GPIO_PORTB_AFSEL	EQU		0x40005420
GPIO_PORTB_DEN		EQU		0x4000551C
IOB					EQU		0x0F
GPIO_PORTB_PUR		EQU		0x40005510
	
SYSCTL_RCGCGPIO		EQU		0x400FE608
SYSCTL_RCGCWTIMER 	EQU 	0x400FE65C ; GPTM Gate Control
	
GPIO_PORTF_DATA		EQU		0x400253FC
;*********************************************************
; I n i t i a l i z a t i o n a r e a
;*********************************************************
;LABEL DIRECTIVE VALUE COMMENT
	AREA routines , CODE, READONLY
	THUMB
	IMPORT DELAY100
	EXPORT INIT_TIMER0A
	EXPORT INIT_MOTOR_GPIO		
	EXPORT 	My_WTimer0A_Handler
		
INIT_TIMER0A PROC ; init motor timer
		PUSH{LR}
		BL	DELAY100
		POP{LR}
		LDR R1, =SYSCTL_RCGCWTIMER
		LDR R2, [R1] ; Start timer 0
		ORR R2, R2, #0x01 ; Timer module = bit position (0)
		STR R2, [R1]
		NOP
		NOP
		NOP ; allow clock to settle
; disable timer during setup
		
		LDR R1, =WTIMER0_CTL
		MOV	R2, #0
		STR R2, [R1]
		; set to 16bit Timer Mode
		LDR R1, =WTIMER0_CFG
		MOV R2, #0x04 ; set bits 2:0 to 0x04 for 32bit timer
		STR R2, [R1]
		; set for edge time and capture mode
		LDR R1, =WTIMER0_TAMR
		MOV R2, #0x02 ; set bit1:0 to #2 for Periodic Timer, bit5=1 to enable interrupt
		STR R2, [R1]
	
		; set start value
		LDR R1, =WTIMER0_TAILR ; counter counts down,
		MOV32 R0, #80000 ; 5msecs
		STR R0, [R1]

		LDR R1, =WTIMER0_TAPR
		MOV R2, #4 ; divide clock by 16 to
		STR R2, [R1] ; get 1us clocks
		; unmask the interrupt
		LDR R1, =WTIMER0_IMR 
		LDR R0, [R1]
		ORR R0, #0x01 ; enable interrupt
		STR R0, [R1]
		
		LDR R1, =WTIMER0_ICR
		LDR R0, [R1]
		ORR R0, #0x03 ; enable interrupt
		STR R0, [R1]
		
		
		
		; Configure interrupt priorities
; WTimer0A is interrupt #70.
; 0x45C PRI23 RW 0x0000.0000 Interrupt 92-95 Priority 154
; PRI17 RW 0x0000.0000 Interrupt 68-71 Priority
; Interrupts 68-71 are handled by PRI17 register PRI17.
; Interrupt 19 is controlled by bits 23:21 of PRI4.
; set NVIC interrupt 70 to priority 2
			LDR R1, =NVIC_PRI23
			LDR R2, [R1]
			BIC R2, #0x00D00000 ; clear interrupt 70 priority
			ORR R2, #0x00400000 ; set interrupt 70 priority to 2
			STR R2, [R1]
; NVIC has to be enabled
; 0x108 EN2 RW 0x0000.0000 Interrupt 64-95 Set Enable
; Interrupts 64-95are handled by NVIC register EN2
; Interrupt 70 is controlled by bit 6
; 0x108 EN2 RW 0x0000.0000 Interrupt 64-95 Set Enable 142
; enable interrupt 70 in NVIC
			LDR R1, =NVIC_EN2
			LDR R2, [R1]
			ORR R2, #0x40000000 ; set bit 6 to enable interrupt 70
			STR R2, [R1]
			
					; Enable timer
		LDR R1, =WTIMER0_CTL ;
		LDR R2, [R1] ;
		ORR R2, R2, #0x03 ; set bit 0 to enable
		STR R2, [R1] 
		
			BX LR
			ENDP
				
;**************************************************************************

INIT_MOTOR_GPIO		PROC
					PUSH 	{R0,R1}
					
					LDR		R1, =SYSCTL_RCGCGPIO
					LDR		R0, [R1]
					ORR		R0, R0, #0x02		 ; port B activated
					STR		R0, [R1]
					NOP
					NOP
					NOP
					
					LDR		R1, =GPIO_PORTB_DIR   ; input-output configuration for port B
					LDR		R0, [R1]
					BIC		R0, #0xFF
					ORR		R0, #IOB			  ; last 4 bit 1 (output) first 4 bit 0 (input)
					STR		R0, [R1]
					LDR		R1, =GPIO_PORTB_AFSEL ; related with assigning specific functions to pins, which we do not here.
					LDR		R0, [R1]
					BIC		R0, #0xFF
					STR		R0, [R1]
					LDR		R1, =GPIO_PORTB_DEN	  ; digital enable
					LDR		R0, [R1]
					ORR		R0, #0xFF
					STR		R0, [R1]
					LDR		R1, =GPIO_PORTB_PUR	  ; pull-up resistors to input pins
					MOV		R0, #0xF0
					STR		R0, [R1]
					
					
					POP 	{R0,R1}
					BX		LR
					ENDP
; ************************************************************************

				 
				 
My_WTimer0A_Handler	PROC
			 ; disable the timer	
			 CMP	R6, #0x10 ; brake state, exit
			 BNE	cnt
			 LDR R1, =WTIMER0_IMR
			 MOV R2, #0
			 STR R2, [R1]
			 
cnt			 LDR R1, =WTIMER0_CTL
			 MOV R2, #0
			 STR R2, [R1]
			 
			 LDR    R0, =GPIO_PORTB_DATA	; 
			 LDR    R2, [R0]				; read port-b pin values
			
			 AND	R1, R2, #0x0F			; extract output pins (motor transistor state)
			 BIC	R2, #0x0F
			 
			 CMP	R1, #0
			 MOVEQ  R1, #8
			 LSRNE  R1, #1
			 
			 ORR	R2, R1
			 STR    R2, [R0]
			 
			 CMP    R6, #0x01 ; treshold state, do nothing	
			 BEQ    exit
			 
			 ; normal state, speed up
			 MOV	R1, #600
			 SUBS	R3, R9, R8
			 BLE	exit
			 CMP	R3, R1
			 LDRGT	R2, =80000
			 BGE	load
			 
			 SUB 	R1, #50
			 CMP	R3, R1
			 LDRGT	R2, =87500
			 BGE	load
			 
			 SUB 	R1, #50
			 CMP	R3, R1
			 LDRGT	R2, =95000
			 BGE	load
			 
			 SUB 	R1, #50
			 CMP	R3, R1
			 LDRGT	R2, =102500
			 BGE	load
			 
			 SUB 	R1, #50
			 CMP	R3, R1
			 LDRGT	R2, =110000
			 BGE	load
			 
			 SUB 	R1, #50
			 CMP	R3, R1
			 LDRGT	R2, =117500
			 BGE	load
			 
			 SUB 	R1, #50
			 CMP	R3, R1
			 LDRGT	R2, =125000
			 BGE	load
			 
			 SUB 	R1, #50
			 CMP	R3, R1
			 LDRGT	R2, =132000
			 BGE	load
			 
			 SUB 	R1, #50
			 CMP	R3, R1
			 LDRGT	R2, =140000
			 BGE	load
			 
			 SUB 	R1, #50
			 CMP	R3, R1
			 LDRGT	R2, =147500
			 BGE	load
			 
			 SUB 	R1, #50
			 CMP	R3, R1
			 LDRGT	R2, =170000
			 BGE	load
			 
			 CMP	R3, #0
			 LDRGT	R2, =220000
			 BGE	load
			 
load		 LDR 	R1, =WTIMER0_TAILR
			 STR  	R2, [R1]
			 B		exit
			 
exit        ;LDR R1, =GPIO_PORTF_DATA
			;LDR R0, [R1]
			;ORR R0, #0x02
			;STR  R0, [R1]
			; clear interrupt register
			LDR R1, =WTIMER0_ICR
			LDR R2, [R1]
			ORR R2, R2, #0x01
			STR R2, [R1]
			; enable the timer
			 LDR R1, =WTIMER0_CTL
			 MOV R2, #3
			 STR R2, [R1]

bxlr			BX 	LR 
					ENDP
			end