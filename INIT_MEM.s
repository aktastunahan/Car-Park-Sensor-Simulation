; Memory pointer
PNT 				EQU 0x20000430
	AREA 	routines, CODE, READONLY
	THUMB
	
	EXPORT INIT_MEM

INIT_MEM	PROC
			MOV32 R1, #PNT
			; {0x00, 0x00, 0x00, 0x00, 0x00} // 20
			MOV R0, #0x00
			STRB R0, [R1], #1
			MOV R0, #0x00
			STRB R0, [R1], #1
			MOV R0, #0x00
			STRB R0, [R1], #1
			MOV R0, #0x00
			STRB R0, [R1], #1
			MOV R0, #0x00
			STRB R0, [R1], #1
			
			; {0x00, 0x00, 0x5f, 0x00, 0x00} // 21 !
			MOV R0, #0x00
			STRB R0, [R1], #1
			MOV R0, #0x00
			STRB R0, [R1], #1
			MOV R0, #0x5f
			STRB R0, [R1], #1
			MOV R0, #0x00
			STRB R0, [R1], #1
			MOV R0, #0x00
			STRB R0, [R1], #1
			
			; {0x00, 0x07, 0x00, 0x07, 0x00} // 22 "
			MOV R0, #0x00
			STRB R0, [R1], #1
			MOV R0, #0x07
			STRB R0, [R1], #1
			MOV R0, #0x00
			STRB R0, [R1], #1
			MOV R0, #0x07
			STRB R0, [R1], #1
			MOV R0, #0x00
			STRB R0, [R1], #1
			
			; {0x14, 0x7f, 0x14, 0x7f, 0x14} // 23 #
			MOV R0, #0x14
			STRB R0, [R1], #1
			MOV R0, #0x7f
			STRB R0, [R1], #1
			MOV R0, #0x14
			STRB R0, [R1], #1
			MOV R0, #0x7f
			STRB R0, [R1], #1
			MOV R0, #0x14
			STRB R0, [R1], #1
			
			; {0x24, 0x2a, 0x7f, 0x2a, 0x12} // 24 $
			MOV R0, #0x24
			STRB R0, [R1], #1
			MOV R0, #0x2a
			STRB R0, [R1], #1
			MOV R0, #0x7f
			STRB R0, [R1], #1
			MOV R0, #0x2a
			STRB R0, [R1], #1
			MOV R0, #0x12
			STRB R0, [R1], #1
			
			; {0x23, 0x13, 0x08, 0x64, 0x62} // 25 %
			MOV R0, #0x23
			STRB R0, [R1], #1
			MOV R0, #0x13
			STRB R0, [R1], #1
			MOV R0, #0x08
			STRB R0, [R1], #1
			MOV R0, #0x64
			STRB R0, [R1], #1
			MOV R0, #0x62
			STRB R0, [R1], #1
			
			; {0x36, 0x49, 0x55, 0x22, 0x50} // 26 &
			MOV R0, #0x36
			STRB R0, [R1], #1
			MOV R0, #0x49
			STRB R0, [R1], #1
			MOV R0, #0x55
			STRB R0, [R1], #1
			MOV R0, #0x22
			STRB R0, [R1], #1
			MOV R0, #0x50
			STRB R0, [R1], #1
			
			; {0x00, 0x05, 0x03, 0x00, 0x00} // 27 '
			MOV R0, #0x00
			STRB R0, [R1], #1
			MOV R0, #0x05
			STRB R0, [R1], #1
			MOV R0, #0x03
			STRB R0, [R1], #1
			MOV R0, #0x00
			STRB R0, [R1], #1
			MOV R0, #0x00
			STRB R0, [R1], #1
			
			; {0x00, 0x1c, 0x22, 0x41, 0x00} // 28 (
			MOV R0, #0x00
			STRB R0, [R1], #1
			MOV R0, #0x1c
			STRB R0, [R1], #1
			MOV R0, #0x22
			STRB R0, [R1], #1
			MOV R0, #0x41
			STRB R0, [R1], #1
			MOV R0, #0x00
			STRB R0, [R1], #1		

			; {0x00, 0x41, 0x22, 0x1c, 0x00} // 29 )
			MOV R0, #0x00
			STRB R0, [R1], #1
			MOV R0, #0x41
			STRB R0, [R1], #1
			MOV R0, #0x22
			STRB R0, [R1], #1
			MOV R0, #0x1c
			STRB R0, [R1], #1
			MOV R0, #0x00
			STRB R0, [R1], #1

			; {0x14, 0x08, 0x3e, 0x08, 0x14} // 2a *
			MOV R0, #0x14
			STRB R0, [R1], #1
			MOV R0, #0x08
			STRB R0, [R1], #1
			MOV R0, #0x3e
			STRB R0, [R1], #1
			MOV R0, #0x08
			STRB R0, [R1], #1
			MOV R0, #0x14
			STRB R0, [R1], #1
			
			; {0x08, 0x08, 0x3e, 0x08, 0x08} // 2b +
			MOV R0, #0x08
			STRB R0, [R1], #1
			MOV R0, #0x08
			STRB R0, [R1], #1
			MOV R0, #0x3e
			STRB R0, [R1], #1
			MOV R0, #0x08
			STRB R0, [R1], #1
			MOV R0, #0x08
			STRB R0, [R1], #1
			
			; {0x00, 0x50, 0x30, 0x00, 0x00} // 2c 
			MOV R0, #0x00
			STRB R0, [R1], #1
			MOV R0, #0x50
			STRB R0, [R1], #1
			MOV R0, #0x30
			STRB R0, [R1], #1
			MOV R0, #0x00
			STRB R0, [R1], #1
			MOV R0, #0x00
			STRB R0, [R1], #1

			; {0x08, 0x08, 0x08, 0x08, 0x08} // 2d -
			MOV R0, #0x08
			STRB R0, [R1], #1
			MOV R0, #0x08
			STRB R0, [R1], #1
			MOV R0, #0x08
			STRB R0, [R1], #1
			MOV R0, #0x08
			STRB R0, [R1], #1
			MOV R0, #0x08
			STRB R0, [R1], #1
			
			; {0x00, 0x60, 0x60, 0x00, 0x00} // 2e .
			MOV R0, #0x00
			STRB R0, [R1], #1
			MOV R0, #0x60
			STRB R0, [R1], #1
			MOV R0, #0x60
			STRB R0, [R1], #1
			MOV R0, #0x00
			STRB R0, [R1], #1
			MOV R0, #0x00
			STRB R0, [R1], #1

			; {0x20, 0x10, 0x08, 0x04, 0x02} // 2f /
			MOV R0, #0x20
			STRB R0, [R1], #1
			MOV R0, #0x10
			STRB R0, [R1], #1
			MOV R0, #0x08
			STRB R0, [R1], #1
			MOV R0, #0x04
			STRB R0, [R1], #1
			MOV R0, #0x02
			STRB R0, [R1], #1
			; {0x3e, 0x51, 0x49, 0x45, 0x3e} // 30 0
			MOV R0, #0x3e
			STRB R0, [R1], #1
			MOV R0, #0x51
			STRB R0, [R1], #1
			MOV R0, #0x49
			STRB R0, [R1], #1
			MOV R0, #0x45
			STRB R0, [R1], #1
			MOV R0, #0x3e
			STRB R0, [R1], #1
			; {0x00, 0x42, 0x7f, 0x40, 0x00} // 31 1
			MOV R0, #0x00
			STRB R0, [R1], #1
			MOV R0, #0x42
			STRB R0, [R1], #1
			MOV R0, #0x7f
			STRB R0, [R1], #1
			MOV R0, #0x40
			STRB R0, [R1], #1
			MOV R0, #0x00
			STRB R0, [R1], #1
			; {0x42, 0x61, 0x51, 0x49, 0x46} // 32 2
			MOV R0, #0x42
			STRB R0, [R1], #1
			MOV R0, #0x61
			STRB R0, [R1], #1
			MOV R0, #0x51
			STRB R0, [R1], #1
			MOV R0, #0x49
			STRB R0, [R1], #1
			MOV R0, #0x46
			STRB R0, [R1], #1
			; {0x21, 0x41, 0x45, 0x4b, 0x31} // 33 3
			MOV R0, #0x21
			STRB R0, [R1], #1
			MOV R0, #0x41
			STRB R0, [R1], #1
			MOV R0, #0x45
			STRB R0, [R1], #1
			MOV R0, #0x4b
			STRB R0, [R1], #1
			MOV R0, #0x31
			STRB R0, [R1], #1
			; {0x18, 0x14, 0x12, 0x7f, 0x10} // 34 4
			MOV R0, #0x18
			STRB R0, [R1], #1
			MOV R0, #0x14
			STRB R0, [R1], #1
			MOV R0, #0x12
			STRB R0, [R1], #1
			MOV R0, #0x7f
			STRB R0, [R1], #1
			MOV R0, #0x10
			STRB R0, [R1], #1
			; {0x27, 0x45, 0x45, 0x45, 0x39} // 35 5
			MOV R0, #0x27
			STRB R0, [R1], #1
			MOV R0, #0x45
			STRB R0, [R1], #1
			MOV R0, #0x45
			STRB R0, [R1], #1
			MOV R0, #0x45
			STRB R0, [R1], #1
			MOV R0, #0x39
			STRB R0, [R1], #1
			; {0x3c, 0x4a, 0x49, 0x49, 0x30} // 36 6
			MOV R0, #0x3c
			STRB R0, [R1], #1
			MOV R0, #0x4a
			STRB R0, [R1], #1
			MOV R0, #0x49
			STRB R0, [R1], #1
			MOV R0, #0x49
			STRB R0, [R1], #1
			MOV R0, #0x30
			STRB R0, [R1], #1
			; {0x01, 0x71, 0x09, 0x05, 0x03} // 37 7
			MOV R0, #0x01
			STRB R0, [R1], #1
			MOV R0, #0x71
			STRB R0, [R1], #1
			MOV R0, #0x09
			STRB R0, [R1], #1
			MOV R0, #0x05
			STRB R0, [R1], #1
			MOV R0, #0x03
			STRB R0, [R1], #1
			; {0x36, 0x49, 0x49, 0x49, 0x36} // 38 8
			MOV R0, #0x36
			STRB R0, [R1], #1
			MOV R0, #0x49
			STRB R0, [R1], #1
			MOV R0, #0x49
			STRB R0, [R1], #1
			MOV R0, #0x49
			STRB R0, [R1], #1
			MOV R0, #0x36
			STRB R0, [R1], #1

			; {0x06, 0x49, 0x49, 0x29, 0x1e} // 39 9
			MOV R0, #0x06
			STRB R0, [R1], #1
			MOV R0, #0x49
			STRB R0, [R1], #1
			MOV R0, #0x49
			STRB R0, [R1], #1
			MOV R0, #0x29
			STRB R0, [R1], #1
			MOV R0, #0x1e
			STRB R0, [R1], #1
			; {0x00, 0x36, 0x36, 0x00, 0x00} // 3a
			MOV R0, #0x00
			STRB R0, [R1], #1
			MOV R0, #0x36
			STRB R0, [R1], #1
			MOV R0, #0x36
			STRB R0, [R1], #1
			MOV R0, #0x00
			STRB R0, [R1], #1
			MOV R0, #0x00
			STRB R0, [R1], #1
			; {0x00, 0x56, 0x36, 0x00, 0x00} // 3b ;
			MOV R0, #0x00
			STRB R0, [R1], #1
			MOV R0, #0x56
			STRB R0, [R1], #1
			MOV R0, #0x36
			STRB R0, [R1], #1
			MOV R0, #0x00
			STRB R0, [R1], #1
			MOV R0, #0x00
			STRB R0, [R1], #1
			; {0x08, 0x14, 0x22, 0x41, 0x00} // 3c < ;
			MOV R0, #0x08
			STRB R0, [R1], #1
			MOV R0, #0x14
			STRB R0, [R1], #1
			MOV R0, #0x22
			STRB R0, [R1], #1
			MOV R0, #0x41
			STRB R0, [R1], #1
			MOV R0, #0x00
			STRB R0, [R1], #1
			; {0x14, 0x14, 0x14, 0x14, 0x14} // 3d =
			MOV R0, #0x14
			STRB R0, [R1], #1
			MOV R0, #0x14
			STRB R0, [R1], #1
			MOV R0, #0x14
			STRB R0, [R1], #1
			MOV R0, #0x14
			STRB R0, [R1], #1
			MOV R0, #0x14
			STRB R0, [R1], #1
			; {0x00, 0x41, 0x22, 0x14, 0x08} // 3e >
			MOV R0, #0x00
			STRB R0, [R1], #1
			MOV R0, #0x41
			STRB R0, [R1], #1
			MOV R0, #0x22
			STRB R0, [R1], #1
			MOV R0, #0x14
			STRB R0, [R1], #1
			MOV R0, #0x08
			STRB R0, [R1], #1
			; {0x02, 0x01, 0x51, 0x09, 0x06} // 3f ?
			MOV R0, #0x02
			STRB R0, [R1], #1
			MOV R0, #0x01
			STRB R0, [R1], #1
			MOV R0, #0x51
			STRB R0, [R1], #1
			MOV R0, #0x09
			STRB R0, [R1], #1
			MOV R0, #0x06
			STRB R0, [R1], #1
			; {0x32, 0x49, 0x79, 0x41, 0x3e} // 40 @
			MOV R0, #0x32
			STRB R0, [R1], #1
			MOV R0, #0x49
			STRB R0, [R1], #1
			MOV R0, #0x79
			STRB R0, [R1], #1
			MOV R0, #0x41
			STRB R0, [R1], #1
			MOV R0, #0x3e
			STRB R0, [R1], #1
			; {0x7e, 0x11, 0x11, 0x11, 0x7e} // 41 A
			MOV R0, #0x7e
			STRB R0, [R1], #1
			MOV R0, #0x11
			STRB R0, [R1], #1
			MOV R0, #0x11
			STRB R0, [R1], #1
			MOV R0, #0x11
			STRB R0, [R1], #1
			MOV R0, #0x7e
			STRB R0, [R1], #1
			; {0x7f, 0x49, 0x49, 0x49, 0x36} // 42 B
			MOV R0, #0x7e
			STRB R0, [R1], #1
			MOV R0, #0x49
			STRB R0, [R1], #1
			MOV R0, #0x49
			STRB R0, [R1], #1
			MOV R0, #0x49
			STRB R0, [R1], #1
			MOV R0, #0x36
			STRB R0, [R1], #1
			; {0x3e, 0x41, 0x41, 0x41, 0x22} // 43 C
			MOV R0, #0x3e
			STRB R0, [R1], #1
			MOV R0, #0x41
			STRB R0, [R1], #1
			MOV R0, #0x41
			STRB R0, [R1], #1
			MOV R0, #0x41
			STRB R0, [R1], #1
			MOV R0, #0x22
			STRB R0, [R1], #1
			; {0x7f, 0x41, 0x41, 0x22, 0x1c} // 44 D
			MOV R0, #0x7f
			STRB R0, [R1], #1
			MOV R0, #0x41
			STRB R0, [R1], #1
			MOV R0, #0x41
			STRB R0, [R1], #1
			MOV R0, #0x22
			STRB R0, [R1], #1
			MOV R0, #0x1c
			STRB R0, [R1], #1
			; {0x7f, 0x49, 0x49, 0x49, 0x41} // 45 E
			MOV R0, #0x7f
			STRB R0, [R1], #1
			MOV R0, #0x49
			STRB R0, [R1], #1
			MOV R0, #0x49
			STRB R0, [R1], #1
			MOV R0, #0x49
			STRB R0, [R1], #1
			MOV R0, #0x41
			STRB R0, [R1], #1
			; {0x7f, 0x09, 0x09, 0x09, 0x01} // 46 F
			MOV R0, #0x7f
			STRB R0, [R1], #1
			MOV R0, #0x09
			STRB R0, [R1], #1
			MOV R0, #0x09
			STRB R0, [R1], #1
			MOV R0, #0x09
			STRB R0, [R1], #1
			MOV R0, #0x01
			STRB R0, [R1], #1
			; {0x3e, 0x41, 0x49, 0x49, 0x7a} // 47 G
			MOV R0, #0x3e
			STRB R0, [R1], #1
			MOV R0, #0x41
			STRB R0, [R1], #1
			MOV R0, #0x49
			STRB R0, [R1], #1
			MOV R0, #0x49
			STRB R0, [R1], #1
			MOV R0, #0x7a
			STRB R0, [R1], #1
			; {0x7f, 0x08, 0x08, 0x08, 0x7f} // 48 H
			MOV R0, #0x7f
			STRB R0, [R1], #1
			MOV R0, #0x08
			STRB R0, [R1], #1
			MOV R0, #0x08
			STRB R0, [R1], #1
			MOV R0, #0x08
			STRB R0, [R1], #1
			MOV R0, #0x7f
			STRB R0, [R1], #1
			; {0x00, 0x41, 0x7f, 0x41, 0x00} // 49 I
			MOV R0, #0x00
			STRB R0, [R1], #1
			MOV R0, #0x41
			STRB R0, [R1], #1
			MOV R0, #0x7f
			STRB R0, [R1], #1
			MOV R0, #0x41
			STRB R0, [R1], #1
			MOV R0, #0x00
			STRB R0, [R1], #1
			; {0x20, 0x40, 0x41, 0x3f, 0x01} // 4a J
			MOV R0, #0x20
			STRB R0, [R1], #1
			MOV R0, #0x40
			STRB R0, [R1], #1
			MOV R0, #0x41
			STRB R0, [R1], #1
			MOV R0, #0x3f
			STRB R0, [R1], #1
			MOV R0, #0x01
			STRB R0, [R1], #1
			; {0x7f, 0x08, 0x14, 0x22, 0x41} // 4b K
			MOV R0, #0x7f
			STRB R0, [R1], #1
			MOV R0, #0x08
			STRB R0, [R1], #1
			MOV R0, #0x14
			STRB R0, [R1], #1
			MOV R0, #0x22
			STRB R0, [R1], #1
			MOV R0, #0x41
			STRB R0, [R1], #1
			; {0x7f, 0x40, 0x40, 0x40, 0x40} // 4c L
			MOV R0, #0x7f
			STRB R0, [R1], #1
			MOV R0, #0x40
			STRB R0, [R1], #1
			MOV R0, #0x40
			STRB R0, [R1], #1
			MOV R0, #0x40
			STRB R0, [R1], #1
			MOV R0, #0x40
			STRB R0, [R1], #1
			; {0x7f, 0x02, 0x0c, 0x02, 0x7f} // 4d M
			MOV R0, #0x7f
			STRB R0, [R1], #1
			MOV R0, #0x02
			STRB R0, [R1], #1
			MOV R0, #0x0c
			STRB R0, [R1], #1
			MOV R0, #0x02
			STRB R0, [R1], #1
			MOV R0, #0x7f
			STRB R0, [R1], #1
			; {0x7f, 0x04, 0x08, 0x10, 0x7f} // 4e N
			MOV R0, #0x7f
			STRB R0, [R1], #1
			MOV R0, #0x04
			STRB R0, [R1], #1
			MOV R0, #0x08
			STRB R0, [R1], #1
			MOV R0, #0x10
			STRB R0, [R1], #1
			MOV R0, #0x7f
			STRB R0, [R1], #1
			; {0x3e, 0x41, 0x41, 0x41, 0x3e} // 4f O
			MOV R0, #0x3e
			STRB R0, [R1], #1
			MOV R0, #0x41
			STRB R0, [R1], #1
			MOV R0, #0x41
			STRB R0, [R1], #1
			MOV R0, #0x41
			STRB R0, [R1], #1
			MOV R0, #0x3e
			STRB R0, [R1], #1
			; {0x7f, 0x09, 0x09, 0x09, 0x06} // 50 P
			MOV R0, #0x7f
			STRB R0, [R1], #1
			MOV R0, #0x09
			STRB R0, [R1], #1
			MOV R0, #0x09
			STRB R0, [R1], #1
			MOV R0, #0x09
			STRB R0, [R1], #1
			MOV R0, #0x06
			STRB R0, [R1], #1
			; {0x3e, 0x41, 0x51, 0x21, 0x5e} // 51 Q
			MOV R0, #0x3e
			STRB R0, [R1], #1
			MOV R0, #0x41
			STRB R0, [R1], #1
			MOV R0, #0x51
			STRB R0, [R1], #1
			MOV R0, #0x21
			STRB R0, [R1], #1
			MOV R0, #0x5e
			STRB R0, [R1], #1
			; {0x7f, 0x09, 0x19, 0x29, 0x46} // 52 R
			MOV R0, #0x7f
			STRB R0, [R1], #1
			MOV R0, #0x09
			STRB R0, [R1], #1
			MOV R0, #0x19
			STRB R0, [R1], #1
			MOV R0, #0x29
			STRB R0, [R1], #1
			MOV R0, #0x46
			STRB R0, [R1], #1
			; {0x46, 0x49, 0x49, 0x49, 0x31} // 53 S
			MOV R0, #0x46
			STRB R0, [R1], #1
			MOV R0, #0x49
			STRB R0, [R1], #1
			MOV R0, #0x49
			STRB R0, [R1], #1
			MOV R0, #0x49
			STRB R0, [R1], #1
			MOV R0, #0x31
			STRB R0, [R1], #1
			; {0x01, 0x01, 0x7f, 0x01, 0x01} // 54 T
			MOV R0, #0x01
			STRB R0, [R1], #1
			MOV R0, #0x01
			STRB R0, [R1], #1
			MOV R0, #0x7f
			STRB R0, [R1], #1
			MOV R0, #0x01
			STRB R0, [R1], #1
			MOV R0, #0x01
			STRB R0, [R1], #1
			; {0x3f, 0x40, 0x40, 0x40, 0x3f} // 55 U
			MOV R0, #0x3f
			STRB R0, [R1], #1
			MOV R0, #0x40
			STRB R0, [R1], #1
			MOV R0, #0x40
			STRB R0, [R1], #1
			MOV R0, #0x40
			STRB R0, [R1], #1
			MOV R0, #0x3f
			STRB R0, [R1], #1
			; {0x1f, 0x20, 0x40, 0x20, 0x1f} // 56 V
			MOV R0, #0x1f
			STRB R0, [R1], #1
			MOV R0, #0x20
			STRB R0, [R1], #1
			MOV R0, #0x40
			STRB R0, [R1], #1
			MOV R0, #0x20
			STRB R0, [R1], #1
			MOV R0, #0x1f
			STRB R0, [R1], #1
			; {0x3f, 0x40, 0x38, 0x40, 0x3f} // 57 W
			MOV R0, #0x3f
			STRB R0, [R1], #1
			MOV R0, #0x40
			STRB R0, [R1], #1
			MOV R0, #0x38
			STRB R0, [R1], #1
			MOV R0, #0x40
			STRB R0, [R1], #1
			MOV R0, #0x3f
			STRB R0, [R1], #1
			; {0x63, 0x14, 0x08, 0x14, 0x63} // 58 X
			MOV R0, #0x63
			STRB R0, [R1], #1
			MOV R0, #0x14
			STRB R0, [R1], #1
			MOV R0, #0x08
			STRB R0, [R1], #1
			MOV R0, #0x14
			STRB R0, [R1], #1
			MOV R0, #0x63
			STRB R0, [R1], #1
			; {0x07, 0x08, 0x70, 0x08, 0x07} // 59 Y
			MOV R0, #0x07
			STRB R0, [R1], #1
			MOV R0, #0x08
			STRB R0, [R1], #1
			MOV R0, #0x70
			STRB R0, [R1], #1
			MOV R0, #0x08
			STRB R0, [R1], #1
			MOV R0, #0x07
			STRB R0, [R1], #1
			; {0x61, 0x51, 0x49, 0x45, 0x43} // 5a Z
			MOV R0, #0x61
			STRB R0, [R1], #1
			MOV R0, #0x51
			STRB R0, [R1], #1
			MOV R0, #0x49
			STRB R0, [R1], #1
			MOV R0, #0x45
			STRB R0, [R1], #1
			MOV R0, #0x43
			STRB R0, [R1], #1
			; {0x00, 0x7f, 0x41, 0x41, 0x00} // 5b [
			MOV R0, #0x00
			STRB R0, [R1], #1
			MOV R0, #0x7f
			STRB R0, [R1], #1
			MOV R0, #0x41
			STRB R0, [R1], #1
			MOV R0, #0x41
			STRB R0, [R1], #1
			MOV R0, #0x00
			STRB R0, [R1], #1
			; {0x02, 0x04, 0x08, 0x10, 0x20} // 5c '\'
			MOV R0, #0x02
			STRB R0, [R1], #1
			MOV R0, #0x04
			STRB R0, [R1], #1
			MOV R0, #0x08
			STRB R0, [R1], #1
			MOV R0, #0x10
			STRB R0, [R1], #1
			MOV R0, #0x20
			STRB R0, [R1], #1
			; {0x00, 0x41, 0x41, 0x7f, 0x00} // 5d ]
			MOV R0, #0x00
			STRB R0, [R1], #1
			MOV R0, #0x41
			STRB R0, [R1], #1
			MOV R0, #0x41
			STRB R0, [R1], #1
			MOV R0, #0x7f
			STRB R0, [R1], #1
			MOV R0, #0x00
			STRB R0, [R1], #1
			; {0x04, 0x02, 0x01, 0x02, 0x04} // 5e ^
			MOV R0, #0x04
			STRB R0, [R1], #1
			MOV R0, #0x02
			STRB R0, [R1], #1
			MOV R0, #0x01
			STRB R0, [R1], #1
			MOV R0, #0x02
			STRB R0, [R1], #1
			MOV R0, #0x04
			STRB R0, [R1], #1
			; {0x40, 0x40, 0x40, 0x40, 0x40} // 5f _
			MOV R0, #0x40
			STRB R0, [R1], #1
			MOV R0, #0x40
			STRB R0, [R1], #1
			MOV R0, #0x40
			STRB R0, [R1], #1
			MOV R0, #0x40
			STRB R0, [R1], #1
			MOV R0, #0x40
			STRB R0, [R1], #1
			; {0x00, 0x01, 0x02, 0x04, 0x00} // 60 `
			MOV R0, #0x00
			STRB R0, [R1], #1
			MOV R0, #0x01
			STRB R0, [R1], #1
			MOV R0, #0x02
			STRB R0, [R1], #1
			MOV R0, #0x04
			STRB R0, [R1], #1
			MOV R0, #0x00
			STRB R0, [R1], #1
			; {0x20, 0x54, 0x54, 0x54, 0x78} // 61 a
			MOV R0, #0x20
			STRB R0, [R1], #1
			MOV R0, #0x54
			STRB R0, [R1], #1
			MOV R0, #0x54
			STRB R0, [R1], #1
			MOV R0, #0x54
			STRB R0, [R1], #1
			MOV R0, #0x78
			STRB R0, [R1], #1
			; {0x7f, 0x48, 0x44, 0x44, 0x38} // 62 b
			MOV R0, #0x7f
			STRB R0, [R1], #1
			MOV R0, #0x48
			STRB R0, [R1], #1
			MOV R0, #0x44
			STRB R0, [R1], #1
			MOV R0, #0x44
			STRB R0, [R1], #1
			MOV R0, #0x38
			STRB R0, [R1], #1
			; {0x38, 0x44, 0x44, 0x44, 0x20} // 63 c
			MOV R0, #0x38
			STRB R0, [R1], #1
			MOV R0, #0x44
			STRB R0, [R1], #1
			MOV R0, #0x44
			STRB R0, [R1], #1
			MOV R0, #0x44
			STRB R0, [R1], #1
			MOV R0, #0x20
			STRB R0, [R1], #1
			; {0x38, 0x44, 0x44, 0x48, 0x7f} // 64 d
			MOV R0, #0x38
			STRB R0, [R1], #1
			MOV R0, #0x44
			STRB R0, [R1], #1
			MOV R0, #0x44
			STRB R0, [R1], #1
			MOV R0, #0x48
			STRB R0, [R1], #1
			MOV R0, #0x7f
			STRB R0, [R1], #1
			; {0x38, 0x54, 0x54, 0x54, 0x18} // 65 e
			MOV R0, #0x38
			STRB R0, [R1], #1
			MOV R0, #0x54
			STRB R0, [R1], #1
			MOV R0, #0x54
			STRB R0, [R1], #1
			MOV R0, #0x54
			STRB R0, [R1], #1
			MOV R0, #0x18
			STRB R0, [R1], #1
			; {0x08, 0x7e, 0x09, 0x01, 0x02} // 66 f
			MOV R0, #0x08
			STRB R0, [R1], #1
			MOV R0, #0x7e
			STRB R0, [R1], #1
			MOV R0, #0x09
			STRB R0, [R1], #1
			MOV R0, #0x01
			STRB R0, [R1], #1
			MOV R0, #0x02
			STRB R0, [R1], #1
			; {0x0c, 0x52, 0x52, 0x52, 0x3e} // 67 g
			MOV R0, #0x0c
			STRB R0, [R1], #1
			MOV R0, #0x52
			STRB R0, [R1], #1
			MOV R0, #0x52
			STRB R0, [R1], #1
			MOV R0, #0x52
			STRB R0, [R1], #1
			MOV R0, #0x3e
			STRB R0, [R1], #1
			; {0x7f, 0x08, 0x04, 0x04, 0x78} // 68 h
			MOV R0, #0x7f
			STRB R0, [R1], #1
			MOV R0, #0x08
			STRB R0, [R1], #1
			MOV R0, #0x04
			STRB R0, [R1], #1
			MOV R0, #0x04
			STRB R0, [R1], #1
			MOV R0, #0x78
			STRB R0, [R1], #1
			; {0x00, 0x44, 0x7d, 0x40, 0x00} // 69 i
			MOV R0, #0x00
			STRB R0, [R1], #1
			MOV R0, #0x44
			STRB R0, [R1], #1
			MOV R0, #0x7d
			STRB R0, [R1], #1
			MOV R0, #0x40
			STRB R0, [R1], #1
			MOV R0, #0x00
			STRB R0, [R1], #1
			; {0x20, 0x40, 0x44, 0x3d, 0x00} // 6a j
			MOV R0, #0x20
			STRB R0, [R1], #1
			MOV R0, #0x40
			STRB R0, [R1], #1
			MOV R0, #0x44
			STRB R0, [R1], #1
			MOV R0, #0x3d
			STRB R0, [R1], #1
			MOV R0, #0x00
			STRB R0, [R1], #1
			; {0x7f, 0x10, 0x28, 0x44, 0x00} // 6b k
			MOV R0, #0x7f
			STRB R0, [R1], #1
			MOV R0, #0x10
			STRB R0, [R1], #1
			MOV R0, #0x28
			STRB R0, [R1], #1
			MOV R0, #0x44
			STRB R0, [R1], #1
			MOV R0, #0x00
			STRB R0, [R1], #1
			; {0x00, 0x41, 0x7f, 0x40, 0x00} // 6c l
			MOV R0, #0x00
			STRB R0, [R1], #1
			MOV R0, #0x41
			STRB R0, [R1], #1
			MOV R0, #0x7f
			STRB R0, [R1], #1
			MOV R0, #0x40
			STRB R0, [R1], #1
			MOV R0, #0x00
			STRB R0, [R1], #1
			; {0x7c, 0x04, 0x18, 0x04, 0x78} // 6d m
			MOV R0, #0x7c
			STRB R0, [R1], #1
			MOV R0, #0x04
			STRB R0, [R1], #1
			MOV R0, #0x18
			STRB R0, [R1], #1
			MOV R0, #0x04
			STRB R0, [R1], #1
			MOV R0, #0x78
			STRB R0, [R1], #1
			; {0x7c, 0x08, 0x04, 0x04, 0x78} // 6e n
			MOV R0, #0x7c
			STRB R0, [R1], #1
			MOV R0, #0x08
			STRB R0, [R1], #1
			MOV R0, #0x04
			STRB R0, [R1], #1
			MOV R0, #0x04
			STRB R0, [R1], #1
			MOV R0, #0x78
			STRB R0, [R1], #1
			; {0x38, 0x44, 0x44, 0x44, 0x38} // 6f o
			MOV R0, #0x38
			STRB R0, [R1], #1
			MOV R0, #0x44
			STRB R0, [R1], #1
			MOV R0, #0x44
			STRB R0, [R1], #1
			MOV R0, #0x44
			STRB R0, [R1], #1
			MOV R0, #0x38
			STRB R0, [R1], #1
			; {0x7c, 0x14, 0x14, 0x14, 0x08} // 70 p
			MOV R0, #0x7c
			STRB R0, [R1], #1
			MOV R0, #0x14
			STRB R0, [R1], #1
			MOV R0, #0x14
			STRB R0, [R1], #1
			MOV R0, #0x14
			STRB R0, [R1], #1
			MOV R0, #0x08
			STRB R0, [R1], #1
			; {0x08, 0x14, 0x14, 0x18, 0x7c} // 71 q
			MOV R0, #0x08
			STRB R0, [R1], #1
			MOV R0, #0x14
			STRB R0, [R1], #1
			MOV R0, #0x14
			STRB R0, [R1], #1
			MOV R0, #0x18
			STRB R0, [R1], #1
			MOV R0, #0x7c
			STRB R0, [R1], #1
			; {0x7c, 0x08, 0x04, 0x04, 0x08} // 72 r
			MOV R0, #0x7c
			STRB R0, [R1], #1
			MOV R0, #0x08
			STRB R0, [R1], #1
			MOV R0, #0x04
			STRB R0, [R1], #1
			MOV R0, #0x04
			STRB R0, [R1], #1
			MOV R0, #0x08
			STRB R0, [R1], #1
			; {0x48, 0x54, 0x54, 0x54, 0x20} // 73 s
			MOV R0, #0x48
			STRB R0, [R1], #1
			MOV R0, #0x54
			STRB R0, [R1], #1
			MOV R0, #0x54
			STRB R0, [R1], #1
			MOV R0, #0x54
			STRB R0, [R1], #1
			MOV R0, #0x20
			STRB R0, [R1], #1
			; {0x04, 0x3f, 0x44, 0x40, 0x20} // 74 t
			MOV R0, #0x04
			STRB R0, [R1], #1
			MOV R0, #0x3f
			STRB R0, [R1], #1
			MOV R0, #0x44
			STRB R0, [R1], #1
			MOV R0, #0x40
			STRB R0, [R1], #1
			MOV R0, #0x20
			STRB R0, [R1], #1
			; {0x3c, 0x40, 0x40, 0x20, 0x7c} // 75 u
			MOV R0, #0x3c
			STRB R0, [R1], #1
			MOV R0, #0x40
			STRB R0, [R1], #1
			MOV R0, #0x40
			STRB R0, [R1], #1
			MOV R0, #0x20
			STRB R0, [R1], #1
			MOV R0, #0x7c
			STRB R0, [R1], #1
			; {0x1c, 0x20, 0x40, 0x20, 0x1c} // 76 v
			MOV R0, #0x1c
			STRB R0, [R1], #1
			MOV R0, #0x20
			STRB R0, [R1], #1
			MOV R0, #0x40
			STRB R0, [R1], #1
			MOV R0, #0x20
			STRB R0, [R1], #1
			MOV R0, #0x1c
			STRB R0, [R1], #1
			; {0x3c, 0x40, 0x30, 0x40, 0x3c} // 77 w
			MOV R0, #0x3c
			STRB R0, [R1], #1
			MOV R0, #0x40
			STRB R0, [R1], #1
			MOV R0, #0x30
			STRB R0, [R1], #1
			MOV R0, #0x40
			STRB R0, [R1], #1
			MOV R0, #0x3c
			STRB R0, [R1], #1
			; {0x44, 0x28, 0x10, 0x28, 0x44} // 78 x
			MOV R0, #0x44
			STRB R0, [R1], #1
			MOV R0, #0x28
			STRB R0, [R1], #1
			MOV R0, #0x10
			STRB R0, [R1], #1
			MOV R0, #0x28
			STRB R0, [R1], #1
			MOV R0, #0x44
			STRB R0, [R1], #1
			; {0x0c, 0x50, 0x50, 0x50, 0x3c} // 79 y
			MOV R0, #0x0c
			STRB R0, [R1], #1
			MOV R0, #0x50
			STRB R0, [R1], #1
			MOV R0, #0x50
			STRB R0, [R1], #1
			MOV R0, #0x50
			STRB R0, [R1], #1
			MOV R0, #0x3c
			STRB R0, [R1], #1
			; {0x44, 0x64, 0x54, 0x4c, 0x44} // 7a z
			MOV R0, #0x44
			STRB R0, [R1], #1
			MOV R0, #0x64
			STRB R0, [R1], #1
			MOV R0, #0x54
			STRB R0, [R1], #1
			MOV R0, #0x4c
			STRB R0, [R1], #1
			MOV R0, #0x44
			STRB R0, [R1], #1
			; {0x00, 0x08, 0x36, 0x41, 0x00} // 7b {
			MOV R0, #0x00
			STRB R0, [R1], #1
			MOV R0, #0x08
			STRB R0, [R1], #1
			MOV R0, #0x36
			STRB R0, [R1], #1
			MOV R0, #0x41
			STRB R0, [R1], #1
			MOV R0, #0x00
			STRB R0, [R1], #1
			; {0x00, 0x00, 0x7f, 0x00, 0x00} // 7c |
			MOV R0, #0x00
			STRB R0, [R1], #1
			MOV R0, #0x00
			STRB R0, [R1], #1
			MOV R0, #0x7f
			STRB R0, [R1], #1
			MOV R0, #0x00
			STRB R0, [R1], #1
			MOV R0, #0x00
			STRB R0, [R1], #1
			; {0x00, 0x41, 0x36, 0x08, 0x00} // 7d }
			MOV R0, #0x00
			STRB R0, [R1], #1
			MOV R0, #0x41
			STRB R0, [R1], #1
			MOV R0, #0x36
			STRB R0, [R1], #1
			MOV R0, #0x08
			STRB R0, [R1], #1
			MOV R0, #0x00
			STRB R0, [R1], #1
			; {0x10, 0x08, 0x08, 0x10, 0x08} // 7e ~
			MOV R0, #0x10
			STRB R0, [R1], #1
			MOV R0, #0x08
			STRB R0, [R1], #1
			MOV R0, #0x08
			STRB R0, [R1], #1
			MOV R0, #0x10
			STRB R0, [R1], #1
			MOV R0, #0x08
			STRB R0, [R1], #1
;//  ,{0x78, 0x46, 0x41, 0x46, 0x78} // 7f DEL
;  ,{0x1f, 0x24, 0x7c, 0x24, 0x1f} // 7f UT sign
			BX LR

			ENDP
			END