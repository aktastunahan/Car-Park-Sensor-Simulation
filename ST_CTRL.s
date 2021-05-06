	AREA 	routines, CODE, READONLY
	THUMB
	IMPORT DELAY100
	EXPORT ST_CTRL
	EXPORT SWITCH_INIT
; ******************************************************* ;
; Handles the state changes.
; 1. Check whether a button (SW1, SW2) is pressed by taking into account debouncing,
; 2. Check whether the button is released by taking into account debouncing,
; Update the state register R6  by taking into account the current state
; ******************************************************* ;
;GPIO Registers, port F
GPIO_PORTF_DATA		EQU 0x400253FC ; Access 
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
	
;System Registers
SYSCTL_RCGCGPIO 	EQU 0x400FE608 ; GPIO Gate Control
	
ST_CTRL		PROC
			PUSH {R0-R3, LR}
			LDR			R0, =GPIO_PORTF_RIS
			LDR			R1, [R0]
			ANDS		R1, #0x11
			BEQ			exit ; no interrupt
			
			LDR			R0, =GPIO_PORTF_DATA
			; button press control with debouncing
			; possible inputs: 11, 10, 01, 00
debnc		LDR			R1, [R0]
			AND			R1, #0x11
			BL			DELAY100
			LDR			R2, [R0]				; debouncing section
			AND			R2, #0x11
			CMP			R1, R2
			BNE			debnc					; there is debouncing
			; at this point, debouncing handled for pressing the button
			CMP			R1, #0x11
			BEQ			exit					; no input from buttons. no change in states
			CMP			R1, #0x00
			BEQ			debnc					; both buttons are pressed. check the inputs again
			
			; at this point, R2 = 10 or 01
			; button release control with debouncing
			; first, debouncing control
nrlst		LDR			R1, [R0]
			AND			R1, #0x11
			BL			DELAY100		
			LDR			R3, [R0]				; debouncing section
			AND			R3, #0x11
			CMP			R1, R3
			BNE			nrlst
			; at this point, debouncing handled for releasing the button
			; then, check if the button is released
			CMP			R3, #0x11				
			BNE			nrlst
			

			
; ***** New input from switches. Update the state here ***** ;
; R2: 0x01 --> SW1 is pressed    R2: 0x10 --> SW2 is pressed
; R6: state register. 0: normal mode ||| 0x01: treshold setting mode ||| 0x10: preventative braking

; first, check for current state
			CMP			R6, #0x00
			BEQ			cur_nor
			CMP			R6, #0x01
			BEQ			cur_trs
			CMP			R6, #0x10
			BEQ			cur_brk
			MOVNE		R6, #0	; error somehow. default state
			BNE			exit
			
; here, update new state
cur_nor		CMP			R2, #0x01	; check for treshold setting state
			MOVEQ		R6, R2	    ; set the new state to treshold setting
			B			exit

; in break mode, we are only expecting SW2 switch input to go to the normal state
cur_brk		CMP			R2, #0x10   ; if current state is break, check for reset input
			MOVEQ		R6, #0		; if reset, go to normal state
			B			exit
			
; in treshold settin mode, we are only expecting SW1 switch input to set the treshold and go to normal state
cur_trs		CMP			R2, #0x01
			MOVEQ		R6, #0x00
			
exit		LDR			R0, =GPIO_PORTF_ICR
			LDR			R1, [R0]
			ORR			R1, #0x11
			LDR			R1, [R0]

			POP{R0-R3, LR}
			BX			LR
			ENDP
;---------------------------------------------------------------------------
SWITCH_INIT	 PROC
			 LDR R1, =SYSCTL_RCGCGPIO ; start GPIO clock
			 LDR R0, [R1]
			 ORR R0, R0, #0x20 ; set bit 5 for port F
			 STR R0, [R1]
			 NOP ; allow clock to settle
			 NOP
			 NOP
			 
			 LDR R1, =GPIO_PORTF_LOCK
			 MOV32 R0, #0x4C4F434B
			 STR R0, [R1]
			
			 LDR R1, =GPIO_PORTF_CR
			 LDR R0, [R1]
			 ORR R0, #0x01
			 STR R0, [R1]
			 
			 LDR R1, =GPIO_PORTF_DIR ; set direction of PF4 (SW1 and SW2)
			 LDR R0, [R1]
			 BIC R0, R0, #0x11 ; set bit4 (SW1 and SW2) for input
			 STR R0, [R1]
			 LDR R1, =GPIO_PORTF_AFSEL ; regular port function
			 LDR R0, [R1]
			 BIC R0, R0, #0x11
			 STR R0, [R1]
			 LDR R1, =GPIO_PORTF_PCTL ; no alternate function
			 LDR R0, [R1]
			 BIC R0, R0, #0x000F000F
			 STR R0, [R1]
		 	 LDR R1, =GPIO_PORTF_AMSEL ; disable analog
			 LDR R0, [R1]
			 BIC R0, R0, #0x000F000F
			 STR R0, [R1]
			 LDR R1, =GPIO_PORTF_DEN ; enable port digital
			 LDR R0, [R1]
			 ORR R0, R0, #0x11
			 STR R0, [R1]
			 LDR R1, =GPIO_PORTF_PUR
			 LDR R0, [R1]
			 ORR R0, R0, #0x11
			 STR R0, [R1]
			 
			 LDR	R1, =GPIO_PORTF_IS
			 LDR	R0, [R1]
			 BIC	R0, #0x11	; SW1 & SW2 mask interrupts
			 STR	R0, [R1]
			
			 LDR	R1, =GPIO_PORTF_IBE
			 LDR	R0, [R1]
			 ORR	R0, #0x11	; SW1 & SW2 both edge interrupt
			 STR	R0, [R1]
			
			 ;LDR	R1, =GPIO_PORTF_IEV
			 ;LDR	R0, [R1]
			 ;ORR	R0, #0x11	; SW1 & SW2 falling edge interrupt
			 ;STR	R0, [R1]
			
			 LDR	R1, =GPIO_PORTF_ICR
			 LDR	R0, [R1]
			 ORR	R0, #0x11	; SW1 & SW2 clear interrupts
			 STR	R0, [R1]
			 
			 
			 BX LR
			 ENDP
			END