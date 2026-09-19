/**************************************************************************
 *     File: Lab04.asm
 * Lab Name: factN
 *   Author: Drew Dimino
 *  Created: 09/15/2026
 *
 * This program calculates the factorial of an integer N
 * N must be greater than 0 and less than 6 [1,5]
 *************************************************************************/ 
 .def n = R16
.def result = R17
.def np = R18
.def rp = R19
.org 0x0000 ; next instruction will be written to address 0x0000
            ; (the location of the reset vector)
rjmp main	; set reset vector to point to the main code entry point

main:       ; jump here on reset

		; initialize the stack (RAMEND = 0x10FF by default for the ATmega128A)
		ldi R16, HIGH(RAMEND)
		out SPH, R16
		ldi R16, low(RAMEND)
		out SPL, R16

		LDI  n, 5; load a value into n
		PUSH n	; push it on the stack
		CALL factN	; calculate the factorial of n
		POP  result	; pop result off stack
here:
		RJMP here	; loop forever

factN:
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; Comments regarding the factN subroutine go here

; This subroutine is for a recursive program that takes n off 
;of the stack,and performs the calculation for n factorial 
;before placing the result onto the stack in n’s place

; n must be greater than 0 and less than 6. The range of 
;integer inputs for n is [1…5]

; The subroutine stores every integer from [1…n] on the stack. 
;The subroutine then backtracks the stack to multiply each of 
;the integers together, storing the partial result in the place 
;of the factor adjacent to the next factor. The subroutine 
;returns with the final product stored to n’s address.

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	; recursive factorial code begins here
	
	IN YH, SPH	; setting the Y pointer to the stack pointer
	IN YL, SPL

	LDD np, Y+3	; loading n into temporary register via stack

	CPI np, 1	; base case check (1!)
	BREQ base
	
	DEC np	; decrementing n for recursive call
	PUSH np	; storing decremented n to stack

	CALL factN	; recursive call
	
	POP np	; loading current result into temporary register via stack

	IN YH, SPH	; resetting Y pointer to match stack pointer
	IN YL, SPL

	LDD rp, Y+3	; loading next n value to temporary register via stack
	
	MUL rp, np	; calculating current result
	MOV rp, R0	; storing 2B product into temporary result register
	STD Y+3, rp	; storing current result onto stack

	RET

base:
	RET

