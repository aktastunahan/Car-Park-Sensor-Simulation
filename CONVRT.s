	AREA routines , CODE, READONLY
	THUMB
	EXPORT CONVRT ; make i t a v a i l a b l e
									; to othe r s our c e s
CONVRT	    PROC
			PUSH		{R0-R8}

			MOV			R0, #9					; main loop (loop_1) iterate 9 times (+1 at the end). (max. 10 decimal digit).
			
			MOV			R6, #0					; 
			MOV			R7, #0
			MOV			R8, R5					; store initial address at R8, will be used in OutStr subrutine
			
			MOV			R2, #0
			MOV			R1, #100
loop		SUBS		R1, #1
			STRBGE		R2, [R5, R11]
			BGE			loop	
			
			MOV			R1, #0
			MOV			R3, #1					; x10 multiplier temp register
			
loop_1		CMP			R0, #0					; main loop
			BLE			done					; R0 will count [1,9]
			
loop_2											; iterates R0 times and finds hex. representation of 10^(R0) decimal.			
			CMP			R1, R0					; R1 counter register, counts R0 times
			LSLNE 		R2, R3, #3				; R2 = R3 * 8
			ADDNE		R2, R2, R3, LSL # 1		; R2 += R3 * 2 
			MOVNE		R3, R2					; R3 = 10*R3
			ADDNE		R1, #1					; counter up
			BNE			loop_2
												; at this point, R2 = hex. representation of 10^(R0) decimal.
loop_3											; will iterate until R0th digit of R4 = 0.
			CMP			R4, R2
			SUBGE		R4, R2					; substract 10^(R0) from R4
			ADDGE		R6, #1					; count how many substractiion have been done
			BGE			loop_3					; e.g.: 		 R4 = hex(2147483647); R2 = hex(10^10) 
												; at this point: R4 = hex(0147483647); R6 = 2
			
			SUB			R0, #1					; preperation/initialization for going back to loop_1
			MOV			R1, #0					; preperation/initialization for going back to loop_1
			MOV			R3, #1					; preperation/initialization for going back to loop_1
			MOV			R2, #0					; preperation/initialization for going back to loop_1
			
			CMP			R6, #0					; we do not want to store leading 0's at the address
			MOVNE		R7, #1					; R7 used as boolean. after first time R6 != 0, 
												; R7 will be set to 1 and stay until subrutine ends. 
			CMP			R7, #1					; checks if leading zeros ended
			ADDEQ		R6, #0x30				; ANSII offset
			STRBEQ		R6, [R5]				; store the coded digit to R5
			ADDEQ		R5, #1					; increment R5
			
			MOV			R6, #0					; preperation/initialization for going back to loop_1
			
			CMP			R4, #0					; if the number is not 0, return loop_1
			BNE			loop_1

done		ADD 		R4, #0x30				; final step, one more iteration, we have last digit at R4.
			STRB		R4, [R5], #1			; code R4, store it at R5, increment R5 pointer
			LDR			R4, =0x04				; end character
			STRB		R4, [R5]				; put end character to the address
			MOV			R5, R8
			POP			{R0-R8}
			BX			LR ; r e turn

			ALIGN
			ENDP
