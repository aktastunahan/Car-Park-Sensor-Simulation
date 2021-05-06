	AREA routines, CODE, READONLY
	THUMB
	EXPORT	DELAY100
	EXPORT DELAY100n

CLKFRQ1			EQU 		160000		; 
CLKFRQ2			EQU 		160		; 
	
DELAY100		PROC					
				PUSH		{R0, R1,LR}		; 1clk
				MOV			R0,#0		; 1 clk
				LDR			R1, =CLKFRQ1 ; 1 clk
				
waste			CMP			R0, R1		; 1 clk
				NOPLT					; 1 clk
				NOPLT					; 1 clk		
				NOPLT					; 1 clk
				NOPLT					; 1 clk
				NOPLT					; 1 clk		
				ADDLT		R0, #1  	; 1 clk	
				BLT			waste		; 1 clk, tolat 8 clk for one loop
				POP			{R0, R1, LR}		; 1clk
				BX			LR
				ENDP
					
DELAY100n		PROC					
				PUSH		{R0, R1,LR}		; 1clk
				MOV			R0,#0		; 1 clk
				LDR			R1, =CLKFRQ2 ; 1 clk
				
waste2			CMP			R0, R1		; 1 clk
				NOPLT					; 1 clk
				NOPLT					; 1 clk		
				NOPLT					; 1 clk
				NOPLT					; 1 clk
				NOPLT					; 1 clk		
				ADDLT		R0, #1  	; 1 clk	
				BLT			waste2		; 1 clk, tolat 8 clk for one loop
				POP			{R0, R1, LR}		; 1clk
				BX			LR
				ENDP
				END