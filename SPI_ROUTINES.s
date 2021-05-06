; System Clock Registers
SYSCTL_RCGCSSI 		EQU 0x400FE61C ; GPIO Gate Control
SYSCTL_RCGCGPIO		EQU	0x400FE608
	
; SPI0 registers
SSI0_CR0 			EQU 0x40008000
SSI0_CR1 			EQU 0x40008004
SSI0_CC				EQU 0x40008FC8
SSI0_CPSR 			EQU 0x40008010
SSI0_DR 			EQU 0x40008008
SSI0_SR 			EQU 0x4000800C	
	
; GPIO Port A registers
GPIO_PORTA_DATA		EQU 0x400043FC ; Access BIT2
GPIO_PORTA_DIR 		EQU 0x40004400 ; Port Direction
GPIO_PORTA_AFSEL	EQU 0x40004420 ; Alt Function enable
GPIO_PORTA_DEN 		EQU 0x4000451C ; Digital Enable
GPIO_PORTA_AMSEL 	EQU 0x40004528 ; Analog enable
GPIO_PORTA_PCTL 	EQU 0x4000452C ; Alternate Functions
GPIO_PORTA_PDR		EQU	0x40004514 ; pull down resistor
GPIO_PORTA_PUR		EQU	0x40004510 ; pull down resistor
GPIO_PORTA_LOCK		EQU	0x40004520 ; lock register
GPIO_PORTA_CR		EQU	0x40004524 ; 
	
PNT			EQU			0x20000430
PNT2		EQU			0x20000400
	AREA sdata , DATA, READONLY
	THUMB
STAR		DCB			"*** "
			DCB			0x04
			
STARS		DCB			"************ "
			DCB			0x04	
			
MEAS		DCB			"Meas: "
			DCB			0x04
			
THRE		DCB			"Thre: "
			DCB			0x04
			
NWL			DCB			0x0A
			DCB			0x04
			
MM			DCB			" mm "
			DCB			0x04

ARROW		DCB			"-> "
			DCB			0x04	
			
CAR			DCB			"CAR "
			DCB			0x04
			
ST_N		DCB			"Normal Op. "
			DCB			0x04

ST_T		DCB			"Thre. Adj. "
			DCB			0x04

ST_B		DCB			"BRAKE ON "
			DCB			0x04
		
	AREA 	routines, CODE, READONLY
	THUMB
	IMPORT DELAY100
	IMPORT INIT_MEM
	IMPORT OutStr
	IMPORT CONVRT
	IMPORT DELAY100n
		
	EXPORT PRINT_INFO
	EXPORT SPI_INIT
	EXPORT INIT_SCREEN
SPI_INIT 	PROC
;sample initialization
;// initialise SPI bus //
;// PA(2:5) -
;// PA(2) - SSI0CLK
;// PA(3) - SSI0Fss
;// PA(4) - SSI0Rx
;// PA(5) - SSI0Tx
; page 965
;To enable and initialize the SSI, the following steps are necessary:
;1. Enable the SSI module using the RCGCSSI register (see page 346). 
			LDR		R1, =SYSCTL_RCGCSSI
			LDR		R0, [R1]
			ORR		R0, #0x01	; enable SSI0
			STR 	R0, [R1]

;2. Enable the clock to the appropriate GPIO module via the RCGCGPIO register (see page 340).
;To find out which GPIO port to enable, refer to Table 23-5 on page 1351.
			LDR		R1, =SYSCTL_RCGCGPIO
			LDR		R0, [R1]
			ORR		R0, #0x01	; enable PA
			STR 	R0, [R1]
			NOP
			NOP
			NOP
			

;3. Set the GPIO AFSEL bits for the appropriate pins (see page 671). To determine which GPIOs to
;configure, see Table 23-4 on page 1344.
			LDR R1, =GPIO_PORTA_LOCK
			LDR R0, =0x4C4F434B
			STR R0, [R1]
			
			LDR R1, =GPIO_PORTA_CR
			LDR R0, [R1]
			ORR R0, #0xFF	; unlock all pins of PA
			STR R0, [R1]
			
			LDR R1, =GPIO_PORTA_DIR 
			LDR R0, [R1]
			ORR R0, #0xCC;1100_1100
			STR R0, [R1]
			
			LDR R1, =GPIO_PORTA_AFSEL
			LDR R0, [R1]
			ORR R0, #0x2C ;
			BIC R0, #0xC0 ;
			STR R0, [R1]
			
;4. Configure the PMCn fields in the GPIOPCTL register to assign the SSI signals to the appropriate
;pins. See page 688 and Table 23-5 on page 1351.
			LDR R1, =GPIO_PORTA_PCTL
			LDR R0, [R1]
			MOV32 R2, #0x00202200
			ORR R0, R2 ; PA[2:5] -> 0x2 for SSI0
			STR R0, [R1]
;5. Program the GPIODEN register to enable the pin's digital function. In addition, the drive strength,
;drain select and pull-up/pull-down functions must be configured. Refer to “General-Purpose
;Input/Outputs (GPIOs)” on page 649 for more information.
			LDR R1, =GPIO_PORTA_DEN 
			LDR R0, [R1]
			ORR R0, #0xEC;1011_1100
			STR R0, [R1]
			
			LDR R1, =GPIO_PORTA_AMSEL 
			LDR R0, [R1]
			BIC R0, #0xEC;1011_1100
			STR R0, [R1]
			

;Note: Pull-ups can be used to avoid unnecessary toggles on the SSI pins, which can take the
;slave to a wrong state. In addition, if the SSIClk signal is programmed to steady state
;High through the SPO bit in the SSICR0 register, then software must also configure the
;GPIO port pin corresponding to the SSInClk signal as a pull-up in the GPIO Pull-Up
;Select (GPIOPUR) register.
;For each of the frame formats, the SSI is configured using the following steps:
;1. Ensure that the SSE bit in the SSICR1 register is clear before making any configuration changes.			
;2. Select whether the SSI is a master or slave:
;a. For master operations, set the SSICR1 register to 0x0000.0000.
;b. For slave mode (output enabled), set the SSICR1 register to 0x0000.0004.
;c. For slave mode (output disabled), set the SSICR1 register to 0x0000.000C.
			LDR R1, =SSI0_CR1 
			MOV R0, #0x00	; clear SSE bit to disable for config and select master mode
			STR R0, [R1]
			
; 3. Configure the SSI clock source by writing to the SSICC register.
			LDR R1, =SSI0_CC 
			MOV R0, #0x00	; clear SSE bit to disable for config and select master mode
			STR R0, [R1]
			
; 4. Configure the clock prescale divisor by writing the SSICPSR register.
			LDR R1, =SSI0_CPSR
			MOV R0, #0x0F ;0x02
			STR R0, [R1]
			
; 5. Write the SSICR0 register with the following configuration:
			LDR R1, =SSI0_CR0 
			MOV R0, #0x000009C7
			STR R0, [R1]
			
; --		
			LDR R1, =SSI0_CR1 
			LDR R0, [R1]
			ORR R0, #0x02	; enable
			STR R0, [R1]
			
			BX LR
			ENDP
				
;-------------------------------------------------------------------------

CMD5110 	PROC
; R5: ASCII char R4=0: command, R4!=0: data 

;void N5110_Cmnd(char DATA) /* Function for sending command to Nokia5110 display */
;{
;  digitalWrite(DC, LOW); /* DC = 0, display in command mode */
;  digitalWrite(chipSelectPin, LOW); /* Make chip select pin low to enable SPI commuincation */
;  SPI.transfer(DATA); /* Send data(command) */
;  digitalWrite(chipSelectPin, HIGH); /* Make chip select pin high to disable SPI commuincation */
;  digitalWrite(DC, HIGH); /* DC = 1, display in data mode */
;}
			PUSH{R0-R5, LR}
			
			LDR R1, =GPIO_PORTA_DATA
			LDR R0, [R1]
			
			;  digitalWrite(DC, LOW),   digitalWrite(chipSelectPin, LOW)
			
			BIC R3, R0, #0x04 ; pa3 (Fss) low. store original value at R0
			CMP R4, #0
			BICEQ R3, #0x40 ; command. pa4 (DC) low,
			ORRNE R3, #0x40 ; data. pa4 (DC) high,
			
			STR R3, [R1]
			
			;  SPI.transfer(DATA)
			BL TX
			;  digitalWrite(DC, HIGH),  digitalWrite(chipSelectPin, HIGH)
			STR R0, [R1]
			
			POP{R0-R5, LR}
			BX LR
			ENDP
;-------------------------------------------------------------------------
TX			PROC
			PUSH {R0-R4}
			; Preload R4 with UART data address
			LDR R4, =SSI0_DR
			; check for incoming character
check		LDR R1, =SSI0_SR ; load status register address
			LDR R0, [R1] ;
			ANDS R0,R0,#0x10 ; check if previou tx is complete(BSY is 0)
			BNE check ; if not, check again, else
			STR R5, [R4] ; store char
			POP {R0-R4}

			BX LR
			ENDP
;-------------------------------------------------------------------------
INIT_SCREEN PROC
		; Set H=1 for Extended Command Mode, V=0 for Horizontal Addressing
		; Set VOP . You may need to sweep values between 0x[B0-C0] for correct operation.
		; Set temperature control value. You may need to sweep values between 0x[04-07] for correct operation.
		; Set voltage bias value as 0x13.
		; Set H=0 for Basic Command Mode
		; Configure for Normal Display Mode
		; Set Cursor to detemine the start address
			
		; reset the screen. Rst pin: PA7
		PUSH{R0-R5, LR}
			BL INIT_MEM
			LDR R1, =GPIO_PORTA_DATA
			LDR R0, [R1]
			BIC R0, #0x80 ; pa7 low->reset
			STR R0, [R1]
			
			PUSH{LR}
			BL DELAY100
			POP{LR}
			
			ORR R0,#0x80
			STR R0, [R1]

			MOV R4, #0
			MOV R5, #0x21
			BL CMD5110

			MOV R5, #0xBA
			BL CMD5110

			MOV R5, #0x07
			BL CMD5110
			
			
			MOV R5, #0x13
			BL CMD5110
			
			MOV R5, #0x20
			BL CMD5110
			
			MOV R5, #0x0C
			BL CMD5110
			
			BL DELAY100
			
			POP{R0-R5, LR}
			BX LR
			ENDP
				
;---------------------------------------------------------------------------------

CLR_SCR		PROC
			PUSH{R0-R5, LR}
			MOV R0, #503
			MOV R1, #0
			MOV R5, #0
			MOV R4, #0x01
loop1		MOV R5, #0
			BL CMD5110
			CMP R1, R0
			ADDNE R1, #1
			BNE loop1
			POP{R0-R5, LR}
			BX LR
			ENDP
				
;---------------------------------------------------------------------------------

PRINT_INFO	PROC 	
			PUSH{R0-R5, LR}
			BL CLR_SCR ; first, clear the old screen
			; set cursor to the beginning of the first line
			MOV R4, #0 ; command
			MOV R5, #0x80 ; X=0
			BL CMD5110
			BL DELAY100n
			MOV R4, #0 ; command
			MOV R5, #0x40 ; Y=0
			BL CMD5110
			BL DELAY100n
;**********************************************			
			; print distance measurement
			MOV		R4, #0x01 ;data mode lcd
			LDR		R3, =MEAS
			BL		Str2Disp
			; check if thr state
			CMP     R6, #0x01
			BNE 	no_t1
			LDR		R3, =STAR
			BL		Str2Disp
			B		nxt
			; convert hex. pulse width to dec.
no_t1		LDR		R3, =PNT2
			MOV		R5, R3
			MOV		R4, R9
			BL		CONVRT
			BL		Str2Disp
			; print mm
nxt			LDR		R3, =MM
			BL		Str2Disp
			; set cursor to the beginning of the second line
			MOV R4, #0 ; command
			MOV R5, #0x80 ; X=0
			BL CMD5110
			BL DELAY100n
			MOV R4, #0 ; command
			MOV R5, #0x41 ; Y=1
			BL CMD5110
			BL DELAY100n
;**********************************************	
			; print the treshold
			LDR		R3, =THRE
			BL		Str2Disp
			; convert hex. pulse width to dec.
			LDR		R3, =PNT2
			MOV		R4, R8
			MOV		R5, R3
			BL		CONVRT
			BL		Str2Disp
			; print nsec
			LDR		R3, =MM
			BL		Str2Disp
			; set cursor to the beginning of the third line
			MOV R4, #0 ; command
			MOV R5, #0x80 ; X=0
			BL CMD5110
			BL DELAY100n
			MOV R4, #0 ; command
			MOV R5, #0x42 ; Y=2
			BL CMD5110
			BL DELAY100n
;**********************************************
			; print arrows
			LDR		R3, =ARROW
			BL		Str2Disp
			; state check
			; normal op
			CMP		R6, #0x00
			LDREQ	R3, =ST_N
			BEQ		st_prt
			; threshold setting
			CMP		R6, #0x01
			LDREQ	R3, =ST_T
			BEQ		st_prt
			; brake on
			CMP		R6, #0x10
			LDREQ	R3, =ST_B
		
st_prt		BL		Str2Disp
			; set cursor to the beginning of the fourth line
			MOV R4, #0 ; command
			MOV R5, #0x80 ; X=0
			BL CMD5110
			BL DELAY100n
			MOV R4, #0 ; command
			MOV R5, #0x44 ; Y=2
			BL CMD5110
			BL DELAY100n
			BL DELAY100n
;**********************************************
			LDR		R0, =PNT2
			ADD		R0, #11
			MOV		R1, #0x04
			STRB	R1, [R0], #-1
			
			MOV		R4, #0x01
			CMP     R6, #0x01
			BNE 	no_t12
			LDR		R3, =STARS
			BL		Str2Disp
			B		exit
no_t12		LDR		R3, =CAR
			BL		Str2Disp
			
			MOV		R1, #900
			CMP		R9, R1
			BGE		x_s
			MOV		R3, #0x7C
			STRB	R3, [R0], #-1
			
looop		SUBS	R1, #100
			BLT		prnt
			CMP		R9, R1
			BGE		x_s
			MOV		R3, #0x7C ; '|'
			STRB	R3, [R0], #-1
			;LDR		R3, = OBS
			;BL		Str2Disp
			B		looop
			
x_s			MOV		R3, #0x7C
			STRB	R3, [R0], #-1
			
looop2		SUBS	R1, #100
			BLT		xchk
			MOV		R3, #0x2D ; '-'
			STRB	R3, [R0], #-1
			;LDR		R3, = OBS
			;BL		Str2Disp
			B		looop2
			
xchk		SUB		R2, R9, R8
			CMP		R2, #100
			BLE		prnt
			MOV		R2, #100
			UDIV	R1, R8, R2
			ADD		R1, #1
			MOV		R3, #0x58 ; 'X'
			STRB	R3, [R0, R1]
			
prnt		ADD		R3, R0, #1
			BL		Str2Disp
			
exit		POP{R0-R5, LR}
			BX		LR
		
			ENDP
				
;--------------------------------------------------

Str2Disp	PROC
;*********************
; R3: Pointer to the beginning of the string, 0x04: end of string char
;*********************
			PUSH{R0-R5, LR}
loop3		LDRB	R0, [R3], #1				; load ansii code of the character, post inc. address
			CMP		R0, #0x04					; has end character been reached?
			BEQ		done						; if so, end
			; find the memory index (M[i]), starting at ((ANSII_code - 20)*5), and 5 bytes
			; see: INIT_MEM.s
			SUBS	R0, #0x20
			LSLNE	R2, R0, #2
			ADDNE	R0, R2, R0
			; print five bytes for each char
			MOV		R1, #0
			MOV		R2, #5
			LDR		R5, =PNT
			ADD		R0, R5 ; r0: the pointer
chr			LDRB	R5, [R0]
			; print one byte. initial index is in R5
			MOV 	R4, #0x01; display is in the data mode
			BL 		CMD5110						; write the char to the display
			ADD		R0, #1 ; increment pointer
			ADD		R1, #1
			CMP		R1, R2
			BLT		chr
			B 		loop3
done		POP{R0-R5, LR}
			BX LR
			ENDP
			END